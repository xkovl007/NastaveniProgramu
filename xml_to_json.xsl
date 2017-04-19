<!-- uvodni deklarace -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/> <!-- vystupni format -->

    <!-- vstup -->
    <xsl:template match="/">{<xsl:apply-templates select="*"/>}
    </xsl:template>
    
    <!-- objekt nebo vlastnost (vsechno, sablona) -->
    <xsl:template match="*">
        "<xsl:value-of select="name()"/>" : <xsl:call-template name="Vlastnosti"/>
    </xsl:template>

    <!-- Pole (sablona) -->
    <xsl:template match="*" mode="Pole">
        <xsl:call-template name="Vlastnosti"/>
    </xsl:template>

    <!-- Vlastnosti (sablona) -->
    <xsl:template name="Vlastnosti">
        <xsl:variable name="jmenoPotomka" select="name(*[1])"/>
        <xsl:variable name="pocet" select="count(*[name()=$jmenoPotomka])"/>
        <xsl:choose>
            <xsl:when test="not(*|attribute::*)">"<xsl:value-of select="."/>"</xsl:when>
            <xsl:when test="$pocet > 1">{ "<xsl:value-of select="$jmenoPotomka"/>":[<xsl:apply-templates select="*" mode="Pole"/>]}
            </xsl:when>
            <xsl:otherwise>{
                <xsl:apply-templates select="attribute::*"/><!-- atributy -->
                <xsl:apply-templates select="*"/>
                <xsl:choose>
                    <xsl:when test="attribute::*">
                        <xsl:choose> <!-- vypsat hodnotu v elementu, pokud nejakou ma -->
                            <xsl:when test="not(normalize-space(node())='')">"$": "<xsl:value-of select="node()"/>"
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
                }</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::*">,</xsl:if> <!-- obsahuje dalsi, pridat carku -->
    </xsl:template>
    <!-- sablona pro vypis atributu -->
    <xsl:template match="attribute::*">"@<xsl:value-of select="name()"/>" : "<xsl:value-of select="."/>",
    </xsl:template>
</xsl:stylesheet>