Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3157 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934715Ab1JENUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/15] staging: brcm80211: replace string based variable
 storage by linked list
Date: Wed, 5 Oct 2011 15:20:10 +0200
Message-ID: <1317820814-7083-12-git-send-email-arend@broadcom.com> (sfid-20111005_152050_522229_69FEAB1E)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The storage of variables obtained from srom are now stored in a linked
list and lookup is done based on the enumerated identifier.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    1 +
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    1 +
 drivers/staging/brcm80211/brcmsmac/srom.c    |  552 ++++++--------------------
 drivers/staging/brcm80211/brcmsmac/srom.h    |    1 +
 4 files changed, 124 insertions(+), 431 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 6086c26..afba8b1 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1210,6 +1210,7 @@ void ai_detach(struct si_pub *sih)
 		pcicore_deinit(sii->pch);
 	sii->pch = NULL;
 
+	srom_free_vars(sih);
 	kfree(sii);
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 4a3f98e..dce5551 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -266,6 +266,7 @@ struct si_info {
 
 	struct pcicore_info *pch; /* PCI/E core handle */
 
+	struct list_head var_list; /* list of srom variables */
 	char *vars;
 	uint varsz;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index f014044..75de8d1 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -364,6 +364,36 @@
 /* Max. nvram variable table size */
 #define	MAXSZ_NVRAM_VARS	4096
 
+/*
+ * indicates type of value.
+ */
+enum brcms_srom_var_type {
+	BRCMS_SROM_STRING,
+	BRCMS_SROM_SNUMBER,
+	BRCMS_SROM_UNUMBER
+};
+
+/*
+ * storage type for srom variable.
+ *
+ * var_list: for linked list operations.
+ * varid: identifier of the variable.
+ * var_type: type of variable.
+ * buf: variable value when var_type == BRCMS_SROM_STRING.
+ * uval: unsigned variable value when var_type == BRCMS_SROM_UNUMBER.
+ * sval: signed variable value when var_type == BRCMS_SROM_SNUMBER.
+ */
+struct brcms_srom_list_head {
+	struct list_head var_list;
+	enum brcms_srom_id varid;
+	enum brcms_srom_var_type var_type;
+	union {
+		char buf[0];
+		u32 uval;
+		s32 sval;
+	};
+};
+
 struct brcms_sromvar {
 	enum brcms_srom_id varid;
 	u32 revmask;
@@ -834,278 +864,6 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 	{BRCMS_SROM_NULL, 0, 0, 0, 0}
 };
 
-struct srom_id_name {
-	enum brcms_srom_id id;
-	const char *name;
-};
-
-static const struct srom_id_name srom_id_map[] = {
-	{ BRCMS_SROM_AA2G, "aa2g" },
-	{ BRCMS_SROM_AA5G, "aa5g" },
-	{ BRCMS_SROM_AG0, "ag0" },
-	{ BRCMS_SROM_AG1, "ag1" },
-	{ BRCMS_SROM_AG2, "ag2" },
-	{ BRCMS_SROM_AG3, "ag3" },
-	{ BRCMS_SROM_ANTSWCTL2G, "antswctl2g" },
-	{ BRCMS_SROM_ANTSWCTL5G, "antswctl5g" },
-	{ BRCMS_SROM_ANTSWITCH, "antswitch" },
-	{ BRCMS_SROM_BOARDFLAGS2, "boardflags2" },
-	{ BRCMS_SROM_BOARDFLAGS, "boardflags" },
-	{ BRCMS_SROM_BOARDNUM, "boardnum" },
-	{ BRCMS_SROM_BOARDREV, "boardrev" },
-	{ BRCMS_SROM_BOARDTYPE, "boardtype" },
-	{ BRCMS_SROM_BW40PO, "bw40po" },
-	{ BRCMS_SROM_BWDUPPO, "bwduppo" },
-	{ BRCMS_SROM_BXA2G, "bxa2g" },
-	{ BRCMS_SROM_BXA5G, "bxa5g" },
-	{ BRCMS_SROM_CC, "cc" },
-	{ BRCMS_SROM_CCK2GPO, "cck2gpo" },
-	{ BRCMS_SROM_CCKBW202GPO, "cckbw202gpo" },
-	{ BRCMS_SROM_CCKBW20UL2GPO, "cckbw20ul2gpo" },
-	{ BRCMS_SROM_CCODE, "ccode" },
-	{ BRCMS_SROM_CDDPO, "cddpo" },
-	{ BRCMS_SROM_DEVID, "devid" },
-	{ BRCMS_SROM_ET1MACADDR, "et1macaddr" },
-	{ BRCMS_SROM_EXTPAGAIN2G, "extpagain2g" },
-	{ BRCMS_SROM_EXTPAGAIN5G, "extpagain5g" },
-	{ BRCMS_SROM_FREQOFFSET_CORR, "freqoffset_corr" },
-	{ BRCMS_SROM_HW_IQCAL_EN, "hw_iqcal_en" },
-	{ BRCMS_SROM_IL0MACADDR, "il0macaddr" },
-	{ BRCMS_SROM_IQCAL_SWP_DIS, "iqcal_swp_dis" },
-	{ BRCMS_SROM_LEDBH0, "ledbh0" },
-	{ BRCMS_SROM_LEDBH1, "ledbh1" },
-	{ BRCMS_SROM_LEDBH2, "ledbh2" },
-	{ BRCMS_SROM_LEDBH3, "ledbh3" },
-	{ BRCMS_SROM_LEDDC, "leddc" },
-	{ BRCMS_SROM_LEGOFDM40DUPPO, "legofdm40duppo" },
-	{ BRCMS_SROM_LEGOFDMBW202GPO, "legofdmbw202gpo" },
-	{ BRCMS_SROM_LEGOFDMBW205GHPO, "legofdmbw205ghpo" },
-	{ BRCMS_SROM_LEGOFDMBW205GLPO, "legofdmbw205glpo" },
-	{ BRCMS_SROM_LEGOFDMBW205GMPO, "legofdmbw205gmpo" },
-	{ BRCMS_SROM_LEGOFDMBW20UL2GPO, "legofdmbw20ul2gpo" },
-	{ BRCMS_SROM_LEGOFDMBW20UL5GHPO, "legofdmbw20ul5ghpo" },
-	{ BRCMS_SROM_LEGOFDMBW20UL5GLPO, "legofdmbw20ul5glpo" },
-	{ BRCMS_SROM_LEGOFDMBW20UL5GMPO, "legofdmbw20ul5gmpo" },
-	{ BRCMS_SROM_MACADDR, "macaddr" },
-	{ BRCMS_SROM_MCS2GPO0, "mcs2gpo0" },
-	{ BRCMS_SROM_MCS2GPO1, "mcs2gpo1" },
-	{ BRCMS_SROM_MCS2GPO2, "mcs2gpo2" },
-	{ BRCMS_SROM_MCS2GPO3, "mcs2gpo3" },
-	{ BRCMS_SROM_MCS2GPO4, "mcs2gpo4" },
-	{ BRCMS_SROM_MCS2GPO5, "mcs2gpo5" },
-	{ BRCMS_SROM_MCS2GPO6, "mcs2gpo6" },
-	{ BRCMS_SROM_MCS2GPO7, "mcs2gpo7" },
-	{ BRCMS_SROM_MCS32PO, "mcs32po" },
-	{ BRCMS_SROM_MCS5GHPO0, "mcs5ghpo0" },
-	{ BRCMS_SROM_MCS5GHPO1, "mcs5ghpo1" },
-	{ BRCMS_SROM_MCS5GHPO2, "mcs5ghpo2" },
-	{ BRCMS_SROM_MCS5GHPO3, "mcs5ghpo3" },
-	{ BRCMS_SROM_MCS5GHPO4, "mcs5ghpo4" },
-	{ BRCMS_SROM_MCS5GHPO5, "mcs5ghpo5" },
-	{ BRCMS_SROM_MCS5GHPO6, "mcs5ghpo6" },
-	{ BRCMS_SROM_MCS5GHPO7, "mcs5ghpo7" },
-	{ BRCMS_SROM_MCS5GLPO0, "mcs5glpo0" },
-	{ BRCMS_SROM_MCS5GLPO1, "mcs5glpo1" },
-	{ BRCMS_SROM_MCS5GLPO2, "mcs5glpo2" },
-	{ BRCMS_SROM_MCS5GLPO3, "mcs5glpo3" },
-	{ BRCMS_SROM_MCS5GLPO4, "mcs5glpo4" },
-	{ BRCMS_SROM_MCS5GLPO5, "mcs5glpo5" },
-	{ BRCMS_SROM_MCS5GLPO6, "mcs5glpo6" },
-	{ BRCMS_SROM_MCS5GLPO7, "mcs5glpo7" },
-	{ BRCMS_SROM_MCS5GPO0, "mcs5gpo0" },
-	{ BRCMS_SROM_MCS5GPO1, "mcs5gpo1" },
-	{ BRCMS_SROM_MCS5GPO2, "mcs5gpo2" },
-	{ BRCMS_SROM_MCS5GPO3, "mcs5gpo3" },
-	{ BRCMS_SROM_MCS5GPO4, "mcs5gpo4" },
-	{ BRCMS_SROM_MCS5GPO5, "mcs5gpo5" },
-	{ BRCMS_SROM_MCS5GPO6, "mcs5gpo6" },
-	{ BRCMS_SROM_MCS5GPO7, "mcs5gpo7" },
-	{ BRCMS_SROM_MCSBW202GPO, "mcsbw202gpo" },
-	{ BRCMS_SROM_MCSBW205GHPO, "mcsbw205ghpo" },
-	{ BRCMS_SROM_MCSBW205GLPO, "mcsbw205glpo" },
-	{ BRCMS_SROM_MCSBW205GMPO, "mcsbw205gmpo" },
-	{ BRCMS_SROM_MCSBW20UL2GPO, "mcsbw20ul2gpo" },
-	{ BRCMS_SROM_MCSBW20UL5GHPO, "mcsbw20ul5ghpo" },
-	{ BRCMS_SROM_MCSBW20UL5GLPO, "mcsbw20ul5glpo" },
-	{ BRCMS_SROM_MCSBW20UL5GMPO, "mcsbw20ul5gmpo" },
-	{ BRCMS_SROM_MCSBW402GPO, "mcsbw402gpo" },
-	{ BRCMS_SROM_MCSBW405GHPO, "mcsbw405ghpo" },
-	{ BRCMS_SROM_MCSBW405GLPO, "mcsbw405glpo" },
-	{ BRCMS_SROM_MCSBW405GMPO, "mcsbw405gmpo" },
-	{ BRCMS_SROM_MEASPOWER, "measpower" },
-	{ BRCMS_SROM_OFDM2GPO, "ofdm2gpo" },
-	{ BRCMS_SROM_OFDM5GHPO, "ofdm5ghpo" },
-	{ BRCMS_SROM_OFDM5GLPO, "ofdm5glpo" },
-	{ BRCMS_SROM_OFDM5GPO, "ofdm5gpo" },
-	{ BRCMS_SROM_OPO, "opo" },
-	{ BRCMS_SROM_PA0B0, "pa0b0" },
-	{ BRCMS_SROM_PA0B1, "pa0b1" },
-	{ BRCMS_SROM_PA0B2, "pa0b2" },
-	{ BRCMS_SROM_PA0ITSSIT, "pa0itssit" },
-	{ BRCMS_SROM_PA0MAXPWR, "pa0maxpwr" },
-	{ BRCMS_SROM_PA1B0, "pa1b0" },
-	{ BRCMS_SROM_PA1B1, "pa1b1" },
-	{ BRCMS_SROM_PA1B2, "pa1b2" },
-	{ BRCMS_SROM_PA1HIB0, "pa1hib0" },
-	{ BRCMS_SROM_PA1HIB1, "pa1hib1" },
-	{ BRCMS_SROM_PA1HIB2, "pa1hib2" },
-	{ BRCMS_SROM_PA1HIMAXPWR, "pa1himaxpwr" },
-	{ BRCMS_SROM_PA1ITSSIT, "pa1itssit" },
-	{ BRCMS_SROM_PA1LOB0, "pa1lob0" },
-	{ BRCMS_SROM_PA1LOB1, "pa1lob1" },
-	{ BRCMS_SROM_PA1LOB2, "pa1lob2" },
-	{ BRCMS_SROM_PA1LOMAXPWR, "pa1lomaxpwr" },
-	{ BRCMS_SROM_PA1MAXPWR, "pa1maxpwr" },
-	{ BRCMS_SROM_PDETRANGE2G, "pdetrange2g" },
-	{ BRCMS_SROM_PDETRANGE5G, "pdetrange5g" },
-	{ BRCMS_SROM_PHYCAL_TEMPDELTA, "phycal_tempdelta" },
-	{ BRCMS_SROM_RAWTEMPSENSE, "rawtempsense" },
-	{ BRCMS_SROM_REV, "sromrev" },
-	{ BRCMS_SROM_REGREV, "regrev" },
-	{ BRCMS_SROM_RSSISAV2G, "rssisav2g" },
-	{ BRCMS_SROM_RSSISAV5G, "rssisav5g" },
-	{ BRCMS_SROM_RSSISMC2G, "rssismc2g" },
-	{ BRCMS_SROM_RSSISMC5G, "rssismc5g" },
-	{ BRCMS_SROM_RSSISMF2G, "rssismf2g" },
-	{ BRCMS_SROM_RSSISMF5G, "rssismf5g" },
-	{ BRCMS_SROM_RXCHAIN, "rxchain" },
-	{ BRCMS_SROM_RXPO2G, "rxpo2g" },
-	{ BRCMS_SROM_RXPO5G, "rxpo5g" },
-	{ BRCMS_SROM_STBCPO, "stbcpo" },
-	{ BRCMS_SROM_TEMPCORRX, "tempcorrx" },
-	{ BRCMS_SROM_TEMPOFFSET, "tempoffset" },
-	{ BRCMS_SROM_TEMPSENSE_OPTION, "tempsense_option" },
-	{ BRCMS_SROM_TEMPSENSE_SLOPE, "tempsense_slope" },
-	{ BRCMS_SROM_TEMPTHRESH, "tempthresh" },
-	{ BRCMS_SROM_TRI2G, "tri2g" },
-	{ BRCMS_SROM_TRI5GH, "tri5gh" },
-	{ BRCMS_SROM_TRI5GL, "tri5gl" },
-	{ BRCMS_SROM_TRI5G, "tri5g" },
-	{ BRCMS_SROM_TRISO2G, "triso2g" },
-	{ BRCMS_SROM_TRISO5G, "triso5g" },
-	{ BRCMS_SROM_TSSIPOS2G, "tssipos2g" },
-	{ BRCMS_SROM_TSSIPOS5G, "tssipos5g" },
-	{ BRCMS_SROM_TXCHAIN, "txchain" },
-	{ BRCMS_SROM_TXPID2GA0, "txpid2ga0" },
-	{ BRCMS_SROM_TXPID2GA1, "txpid2ga1" },
-	{ BRCMS_SROM_TXPID2GA2, "txpid2ga2" },
-	{ BRCMS_SROM_TXPID2GA3, "txpid2ga3" },
-	{ BRCMS_SROM_TXPID5GA0, "txpid5ga0" },
-	{ BRCMS_SROM_TXPID5GA1, "txpid5ga1" },
-	{ BRCMS_SROM_TXPID5GA2, "txpid5ga2" },
-	{ BRCMS_SROM_TXPID5GA3, "txpid5ga3" },
-	{ BRCMS_SROM_TXPID5GHA0, "txpid5gha0" },
-	{ BRCMS_SROM_TXPID5GHA1, "txpid5gha1" },
-	{ BRCMS_SROM_TXPID5GHA2, "txpid5gha2" },
-	{ BRCMS_SROM_TXPID5GHA3, "txpid5gha3" },
-	{ BRCMS_SROM_TXPID5GLA0, "txpid5gla0" },
-	{ BRCMS_SROM_TXPID5GLA1, "txpid5gla1" },
-	{ BRCMS_SROM_TXPID5GLA2, "txpid5gla2" },
-	{ BRCMS_SROM_TXPID5GLA3, "txpid5gla3" },
-	{ BRCMS_SROM_ITT2GA0, "itt2ga0" },
-	{ BRCMS_SROM_ITT2GA1, "itt2ga1" },
-	{ BRCMS_SROM_ITT2GA2, "itt2ga2" },
-	{ BRCMS_SROM_ITT2GA3, "itt2ga3" },
-	{ BRCMS_SROM_ITT5GA0, "itt5ga0" },
-	{ BRCMS_SROM_ITT5GA1, "itt5ga1" },
-	{ BRCMS_SROM_ITT5GA2, "itt5ga2" },
-	{ BRCMS_SROM_ITT5GA3, "itt5ga3" },
-	{ BRCMS_SROM_MAXP2GA0, "maxp2ga0" },
-	{ BRCMS_SROM_MAXP2GA1, "maxp2ga1" },
-	{ BRCMS_SROM_MAXP2GA2, "maxp2ga2" },
-	{ BRCMS_SROM_MAXP2GA3, "maxp2ga3" },
-	{ BRCMS_SROM_MAXP5GA0, "maxp5ga0" },
-	{ BRCMS_SROM_MAXP5GA1, "maxp5ga1" },
-	{ BRCMS_SROM_MAXP5GA2, "maxp5ga2" },
-	{ BRCMS_SROM_MAXP5GA3, "maxp5ga3" },
-	{ BRCMS_SROM_MAXP5GHA0, "maxp5gha0" },
-	{ BRCMS_SROM_MAXP5GHA1, "maxp5gha1" },
-	{ BRCMS_SROM_MAXP5GHA2, "maxp5gha2" },
-	{ BRCMS_SROM_MAXP5GHA3, "maxp5gha3" },
-	{ BRCMS_SROM_MAXP5GLA0, "maxp5gla0" },
-	{ BRCMS_SROM_MAXP5GLA1, "maxp5gla1" },
-	{ BRCMS_SROM_MAXP5GLA2, "maxp5gla2" },
-	{ BRCMS_SROM_MAXP5GLA3, "maxp5gla3" },
-	{ BRCMS_SROM_PA2GW0A0, "pa2gw0a0" },
-	{ BRCMS_SROM_PA2GW0A1, "pa2gw0a1" },
-	{ BRCMS_SROM_PA2GW0A2, "pa2gw0a2" },
-	{ BRCMS_SROM_PA2GW0A3, "pa2gw0a3" },
-	{ BRCMS_SROM_PA2GW1A0, "pa2gw1a0" },
-	{ BRCMS_SROM_PA2GW1A1, "pa2gw1a1" },
-	{ BRCMS_SROM_PA2GW1A2, "pa2gw1a2" },
-	{ BRCMS_SROM_PA2GW1A3, "pa2gw1a3" },
-	{ BRCMS_SROM_PA2GW2A0, "pa2gw2a0" },
-	{ BRCMS_SROM_PA2GW2A1, "pa2gw2a1" },
-	{ BRCMS_SROM_PA2GW2A2, "pa2gw2a2" },
-	{ BRCMS_SROM_PA2GW2A3, "pa2gw2a3" },
-	{ BRCMS_SROM_PA2GW3A0, "pa2gw3a0" },
-	{ BRCMS_SROM_PA2GW3A1, "pa2gw3a1" },
-	{ BRCMS_SROM_PA2GW3A2, "pa2gw3a2" },
-	{ BRCMS_SROM_PA2GW3A3, "pa2gw3a3" },
-	{ BRCMS_SROM_PA5GHW0A0, "pa5ghw0a0" },
-	{ BRCMS_SROM_PA5GHW0A1, "pa5ghw0a1" },
-	{ BRCMS_SROM_PA5GHW0A2, "pa5ghw0a2" },
-	{ BRCMS_SROM_PA5GHW0A3, "pa5ghw0a3" },
-	{ BRCMS_SROM_PA5GHW1A0, "pa5ghw1a0" },
-	{ BRCMS_SROM_PA5GHW1A1, "pa5ghw1a1" },
-	{ BRCMS_SROM_PA5GHW1A2, "pa5ghw1a2" },
-	{ BRCMS_SROM_PA5GHW1A3, "pa5ghw1a3" },
-	{ BRCMS_SROM_PA5GHW2A0, "pa5ghw2a0" },
-	{ BRCMS_SROM_PA5GHW2A1, "pa5ghw2a1" },
-	{ BRCMS_SROM_PA5GHW2A2, "pa5ghw2a2" },
-	{ BRCMS_SROM_PA5GHW2A3, "pa5ghw2a3" },
-	{ BRCMS_SROM_PA5GHW3A0, "pa5ghw3a0" },
-	{ BRCMS_SROM_PA5GHW3A1, "pa5ghw3a1" },
-	{ BRCMS_SROM_PA5GHW3A2, "pa5ghw3a2" },
-	{ BRCMS_SROM_PA5GHW3A3, "pa5ghw3a3" },
-	{ BRCMS_SROM_PA5GLW0A0, "pa5glw0a0" },
-	{ BRCMS_SROM_PA5GLW0A1, "pa5glw0a1" },
-	{ BRCMS_SROM_PA5GLW0A2, "pa5glw0a2" },
-	{ BRCMS_SROM_PA5GLW0A3, "pa5glw0a3" },
-	{ BRCMS_SROM_PA5GLW1A0, "pa5glw1a0" },
-	{ BRCMS_SROM_PA5GLW1A1, "pa5glw1a1" },
-	{ BRCMS_SROM_PA5GLW1A2, "pa5glw1a2" },
-	{ BRCMS_SROM_PA5GLW1A3, "pa5glw1a3" },
-	{ BRCMS_SROM_PA5GLW2A0, "pa5glw2a0" },
-	{ BRCMS_SROM_PA5GLW2A1, "pa5glw2a1" },
-	{ BRCMS_SROM_PA5GLW2A2, "pa5glw2a2" },
-	{ BRCMS_SROM_PA5GLW2A3, "pa5glw2a3" },
-	{ BRCMS_SROM_PA5GLW3A0, "pa5glw3a0" },
-	{ BRCMS_SROM_PA5GLW3A1, "pa5glw3a1" },
-	{ BRCMS_SROM_PA5GLW3A2, "pa5glw3a2" },
-	{ BRCMS_SROM_PA5GLW3A3, "pa5glw3a3" },
-	{ BRCMS_SROM_PA5GW0A0, "pa5gw0a0" },
-	{ BRCMS_SROM_PA5GW0A1, "pa5gw0a1" },
-	{ BRCMS_SROM_PA5GW0A2, "pa5gw0a2" },
-	{ BRCMS_SROM_PA5GW0A3, "pa5gw0a3" },
-	{ BRCMS_SROM_PA5GW1A0, "pa5gw1a0" },
-	{ BRCMS_SROM_PA5GW1A1, "pa5gw1a1" },
-	{ BRCMS_SROM_PA5GW1A2, "pa5gw1a2" },
-	{ BRCMS_SROM_PA5GW1A3, "pa5gw1a3" },
-	{ BRCMS_SROM_PA5GW2A0, "pa5gw2a0" },
-	{ BRCMS_SROM_PA5GW2A1, "pa5gw2a1" },
-	{ BRCMS_SROM_PA5GW2A2, "pa5gw2a2" },
-	{ BRCMS_SROM_PA5GW2A3, "pa5gw2a3" },
-	{ BRCMS_SROM_PA5GW3A0, "pa5gw3a0" },
-	{ BRCMS_SROM_PA5GW3A1, "pa5gw3a1" },
-	{ BRCMS_SROM_PA5GW3A2, "pa5gw3a2" },
-	{ BRCMS_SROM_PA5GW3A3, "pa5gw3a3" },
-};
-
-static const char *get_varname(enum brcms_srom_id id)
-{
-	const struct srom_id_name *entry;
-	int i;
-
-	entry = &srom_id_map[0];
-	for (i = 0; i < ARRAY_SIZE(srom_id_map); i++) {
-		if (entry->id == id)
-			return entry->name;
-		entry++;
-	}
-	return NULL;
-}
-
 /* crc table has the same contents for every device instance, so it can be
  * shared between devices. */
 static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
@@ -1162,70 +920,14 @@ static inline void htol16_buf(u16 *buf, unsigned int size)
 		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
 }
 
-/* Initialization of varbuf structure */
-static void varbuf_init(struct brcms_varbuf *b, char *buf, uint size)
-{
-	b->size = size;
-	b->base = b->buf = buf;
-}
-
-/* append a null terminated var=value string */
-static int varbuf_append(struct brcms_varbuf *b, const char *fmt, ...)
-{
-	va_list ap;
-	int r;
-	size_t len;
-	char *s;
-
-	if (b->size < 2)
-		return 0;
-
-	va_start(ap, fmt);
-	r = vsnprintf(b->buf, b->size, fmt, ap);
-	va_end(ap);
-
-	/*
-	 * C99 snprintf behavior returns r >= size on overflow,
-	 * others return -1 on overflow. All return -1 on format error.
-	 * We need to leave room for 2 null terminations, one for the current
-	 * var string, and one for final null of the var table. So check that
-	 * the strlen written, r, leaves room for 2 chars.
-	 */
-	if ((r == -1) || (r > (int)(b->size - 2))) {
-		b->size = 0;
-		return 0;
-	}
-
-	/* Remove any earlier occurrence of the same variable */
-	s = strchr(b->buf, '=');
-	if (s != NULL) {
-		len = (size_t) (s - b->buf);
-		for (s = b->base; s < b->buf;) {
-			if ((memcmp(s, b->buf, len) == 0) && s[len] == '=') {
-				len = strlen(s) + 1;
-				memmove(s, (s + len),
-					((b->buf + r + 1) - (s + len)));
-				b->buf -= len;
-				b->size += (unsigned int)len;
-				break;
-			}
-
-			while (*s++)
-				;
-		}
-	}
-
-	/* skip over this string's null termination */
-	r++;
-	b->size -= r;
-	b->buf += r;
-
-	return r;
-}
-
+/*
+ * convert binary srom data into linked list of srom variable items.
+ */
 static void
-_initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
+_initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct list_head *var_list)
 {
+	struct brcms_srom_list_head *entry;
+	enum brcms_srom_id id;
 	u16 w;
 	u32 val;
 	const struct brcms_sromvar *srv;
@@ -1233,10 +935,17 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 	uint flags;
 	u32 sr = (1 << sromrev);
 
-	varbuf_append(b, "sromrev=%d", sromrev);
+	/* first store the srom revision */
+	entry = kzalloc(sizeof(struct brcms_srom_list_head), GFP_KERNEL);
+	entry->varid = BRCMS_SROM_REV;
+	entry->var_type = BRCMS_SROM_UNUMBER;
+	entry->uval = sromrev;
+	list_add(&entry->var_list, var_list);
 
 	for (srv = pci_sromvars; srv->varid != BRCMS_SROM_NULL; srv++) {
-		const char *name;
+		enum brcms_srom_var_type type;
+		u8 ea[ETH_ALEN];
+		u8 extra_space = 0;
 
 		if ((srv->revmask & sr) == 0)
 			continue;
@@ -1245,23 +954,25 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 			continue;
 
 		flags = srv->flags;
-		name = get_varname(srv->varid);
+		id = srv->varid;
 
 		/* This entry is for mfgc only. Don't generate param for it, */
 		if (flags & SRFL_NOVAR)
 			continue;
 
 		if (flags & SRFL_ETHADDR) {
-			u8 ea[ETH_ALEN];
-
+			/*
+			 * stored in string format XX:XX:XX:XX:XX:XX (17 chars)
+			 */
 			ea[0] = (srom[srv->off - off] >> 8) & 0xff;
 			ea[1] = srom[srv->off - off] & 0xff;
 			ea[2] = (srom[srv->off + 1 - off] >> 8) & 0xff;
 			ea[3] = srom[srv->off + 1 - off] & 0xff;
 			ea[4] = (srom[srv->off + 2 - off] >> 8) & 0xff;
 			ea[5] = srom[srv->off + 2 - off] & 0xff;
-
-			varbuf_append(b, "%s=%pM", name, ea);
+			/* 17 characters + string terminator - union size */
+			extra_space = 18 - sizeof(s32);
+			type = BRCMS_SROM_STRING;
 		} else {
 			w = srom[srv->off - off];
 			val = (w & srv->mask) >> mask_shift(srv->mask);
@@ -1285,30 +996,42 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 				continue;
 
 			if (flags & SRFL_CCODE) {
-				if (val == 0)
-					varbuf_append(b, "ccode=");
-				else
-					varbuf_append(b, "ccode=%c%c",
-						      (val >> 8), (val & 0xff));
-			}
-			/* LED Powersave duty cycle has to be scaled:
-			 *(oncount >> 24) (offcount >> 8)
-			 */
-			else if (flags & SRFL_LEDDC) {
+				type = BRCMS_SROM_STRING;
+			} else if (flags & SRFL_LEDDC) {
+				/* LED Powersave duty cycle has to be scaled:
+				 *(oncount >> 24) (offcount >> 8)
+				 */
 				u32 w32 = /* oncount */
 					  (((val >> 8) & 0xff) << 24) |
 					  /* offcount */
 					  (((val & 0xff)) << 8);
-				varbuf_append(b, "leddc=%d", w32);
-			} else if (flags & SRFL_PRHEX)
-				varbuf_append(b, "%s=0x%x", name, val);
-			else if ((flags & SRFL_PRSIGN)
-				 && (val & (1 << (width - 1))))
-				varbuf_append(b, "%s=%d", name,
-					      (int)(val | (~0 << width)));
+				type = BRCMS_SROM_UNUMBER;
+				val = w32;
+			} else if ((flags & SRFL_PRSIGN)
+				 && (val & (1 << (width - 1)))) {
+				type = BRCMS_SROM_SNUMBER;
+				val |= ~0 << width;
+			} else
+				type = BRCMS_SROM_UNUMBER;
+		}
+
+		entry = kzalloc(sizeof(struct brcms_srom_list_head) +
+				extra_space, GFP_KERNEL);
+		entry->varid = id;
+		entry->var_type = type;
+		if (flags & SRFL_ETHADDR) {
+			snprintf(entry->buf, 18, "%pM", ea);
+		} else if (flags & SRFL_CCODE) {
+			if (val == 0)
+				entry->buf[0] = '\0';
 			else
-				varbuf_append(b, "%s=%u", name, val);
+				snprintf(entry->buf, 3, "%c%c",
+					 (val >> 8), (val & 0xff));
+		} else {
+			entry->uval = val;
 		}
+
+		list_add(&entry->var_list, var_list);
 	}
 
 	if (sromrev >= 4) {
@@ -1345,14 +1068,13 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 				    && ((int)val == (1 << width) - 1))
 					continue;
 
-				if (srv->flags & SRFL_PRHEX)
-					varbuf_append(b, "%s%d=0x%x",
-						      get_varname(srv->varid),
-						      p, val);
-				else
-					varbuf_append(b, "%s%d=%d",
-						      get_varname(srv->varid),
-						      p, val);
+				entry =
+				    kzalloc(sizeof(struct brcms_srom_list_head),
+					    GFP_KERNEL);
+				entry->varid = srv->varid+p;
+				entry->var_type = BRCMS_SROM_UNUMBER;
+				entry->uval = val;
+				list_add(&entry->var_list, var_list);
 			}
 			pb += psz;
 		}
@@ -1435,31 +1157,6 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 }
 
 /*
-* Create variable table from memory.
-* Return 0 on success, nonzero on error.
-*/
-static int initvars_table(char *start, char *end,
-			  char **vars, uint *count)
-{
-	int c = (int)(end - start);
-
-	/* do it only when there is more than just the null string */
-	if (c > 1) {
-		char *vp = kmalloc(c, GFP_ATOMIC);
-		if (!vp)
-			return -ENOMEM;
-		memcpy(vp, start, c);
-		*vars = vp;
-		*count = c;
-	} else {
-		*vars = NULL;
-		*count = 0;
-	}
-
-	return 0;
-}
-
-/*
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
@@ -1470,8 +1167,6 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
 	u16 __iomem *sromwindow;
 	u8 sromrev = 0;
 	u32 sr;
-	struct brcms_varbuf b;
-	char *vp, *base = NULL;
 	int err = 0;
 
 	/*
@@ -1514,6 +1209,8 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
 	}
 
 	if (!err) {
+		struct si_info *sii = (struct si_info *)sih;
+
 		/* Bitmask for the sromrev */
 		sr = 1 << sromrev;
 
@@ -1526,23 +1223,10 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
 			goto errout;
 		}
 
-		base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-		if (!base) {
-			err = -ENOMEM;
-			goto errout;
-		}
-
-		varbuf_init(&b, base, MAXSZ_NVRAM_VARS);
+		INIT_LIST_HEAD(&sii->var_list);
 
 		/* parse SROM into name=value pairs. */
-		_initvars_srom_pci(sromrev, srom, 0, &b);
-
-		/* final nullbyte terminator */
-		vp = b.buf;
-		*vp++ = '\0';
-
-		err = initvars_table(base, vp, vars, count);
-		kfree(base);
+		_initvars_srom_pci(sromrev, srom, 0, &sii->var_list);
 	}
 
 errout:
@@ -1550,6 +1234,17 @@ errout:
 	return err;
 }
 
+void srom_free_vars(struct si_pub *sih)
+{
+	struct si_info *sii;
+	struct brcms_srom_list_head *entry, *next;
+
+	sii = (struct si_info *)sih;
+	list_for_each_entry_safe(entry, next, &sii->var_list, var_list) {
+		list_del(&entry->var_list);
+		kfree(entry);
+	}
+}
 /*
  * Initialize local vars from the right source for this platform.
  * Return 0 on success, nonzero on error.
@@ -1579,44 +1274,39 @@ int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
  */
 char *getvar(struct si_pub *sih, enum brcms_srom_id id)
 {
-	const char *name = get_varname(id);
-	char *s;
-	int len;
 	struct si_info *sii;
-
-	if (!name)
-		return NULL;
-
-	len = strlen(name);
-	if (len == 0)
-		return NULL;
+	struct brcms_srom_list_head *entry;
 
 	sii = (struct si_info *)sih;
 
-	/* first look in vars[] */
-	for (s = sii->vars; s && *s;) {
-		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
-			return &s[len + 1];
+	list_for_each_entry(entry, &sii->var_list, var_list)
+		if (entry->varid == id)
+			return &entry->buf[0];
 
-		while (*s++)
-			;
-	}
 	/* nothing found */
 	return NULL;
 }
 
 /*
  * Search the vars for a specific one and return its value as
- * an integer. Returns 0 if not found.
+ * an integer. Returns 0 if not found.-
  */
 int getintvar(struct si_pub *sih, enum brcms_srom_id id)
 {
-	char *val;
+	struct si_info *sii;
+	struct brcms_srom_list_head *entry;
 	unsigned long res;
 
-	val = getvar(sih, id);
-	if (val && !kstrtoul(val, 0, &res))
-		return res;
+	sii = (struct si_info *)sih;
+
+	list_for_each_entry(entry, &sii->var_list, var_list)
+		if (entry->varid == id) {
+			if (entry->var_type == BRCMS_SROM_SNUMBER ||
+			    entry->var_type == BRCMS_SROM_UNUMBER)
+				return (int)entry->sval;
+			else if (!kstrtoul(&entry->buf[0], 0, &res))
+				return (int)res;
+		}
 
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
index 826c2cd..395ab7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.h
+++ b/drivers/staging/brcm80211/brcmsmac/srom.h
@@ -22,6 +22,7 @@
 /* Prototypes */
 extern int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
 			 uint *count);
+extern void srom_free_vars(struct si_pub *sih);
 
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
 		     uint byteoff, uint nbytes, u16 *buf, bool check_crc);
-- 
1.7.4.1


