Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2016 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087Ab1F2XtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 028/119] staging: brcm80211: cleanup whitespace errors
Date: Wed, 29 Jun 2011 16:46:52 -0700
Message-ID: <1309391303-22741-29-git-send-email-frankyl@broadcom.com> (sfid-20110630_015138_550251_938C5585)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Cleanup remaining whitespace errors:
	- space before tabs
	- spaces at the start of a line
	- space between function name and open parenthesis '('
	- unnecessary whitespace before a quoted newline

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    6 ++--
 drivers/staging/brcm80211/brcmfmac/sbsdio.h        |    2 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   10 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |   10 +++----
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   18 ++++++------
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |   28 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |   10 +++---
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |    4 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |    2 +-
 drivers/staging/brcm80211/include/brcmu_utils.h    |    4 +-
 11 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index e0cd8e1..c556191 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -916,14 +916,14 @@ static int _dhd_sysioc_thread(void *data)
 
 				if (in_ap && dhd->set_macaddress) {
 					DHD_TRACE(("attempt to set MAC for %s "
-						"in AP Mode," "blocked. \n",
+						"in AP Mode," "blocked.\n",
 						dhd->iflist[i]->net->name));
 					dhd->set_macaddress = false;
 					continue;
 				}
 
 				if (in_ap && dhd->set_multicast) {
-					DHD_TRACE(("attempt to set MULTICAST list for %s" "in AP Mode, blocked. \n",
+					DHD_TRACE(("attempt to set MULTICAST list for %s" "in AP Mode, blocked.\n",
 						dhd->iflist[i]->net->name));
 					dhd->set_multicast = false;
 					continue;
@@ -2157,7 +2157,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 	}
 
 	if (ifidx == 1) {
-		DHD_TRACE(("%s ACCESS POINT MAC: \n", __func__));
+		DHD_TRACE(("%s ACCESS POINT MAC:\n", __func__));
 		/*  ACCESSPOINT INTERFACE CASE */
 		temp_addr[0] |= 0X02;	/* set bit 2 ,
 			 - Locally Administered address  */
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdio.h b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
index 86b62b8..614a25f 100644
--- a/drivers/staging/brcm80211/brcmfmac/sbsdio.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
@@ -37,7 +37,7 @@
 #define SBSDIO_FUNC1_SBADDRHIGH		0x1000C	/* SB Address Window High (b31:b24)    */
 #define SBSDIO_FUNC1_FRAMECTRL		0x1000D	/* Frame Control (frame term/abort) */
 #define SBSDIO_FUNC1_CHIPCLKCSR		0x1000E	/* ChipClockCSR (ALP/HT ctl/status) */
-#define SBSDIO_FUNC1_SDIOPULLUP 	0x1000F	/* SdioPullUp (on cmd, d0-d2) */
+#define SBSDIO_FUNC1_SDIOPULLUP		0x1000F	/* SdioPullUp (on cmd, d0-d2) */
 #define SBSDIO_FUNC1_WFRAMEBCLO		0x10019	/* Write Frame Byte Count Low */
 #define SBSDIO_FUNC1_WFRAMEBCHI		0x1001A	/* Write Frame Byte Count High */
 #define SBSDIO_FUNC1_RFRAMEBCLO		0x1001B	/* Read Frame Byte Count Low */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index adf364c..5cdbfe9 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -34,7 +34,7 @@
 #define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
 #define	D64RINGALIGN		(1 << D64RINGALIGN_BITS)
 
-#define	D64MAXDD	(D64MAXRINGSZ / sizeof (dma64dd_t))
+#define	D64MAXDD	(D64MAXRINGSZ / sizeof(dma64dd_t))
 
 /* transmit channel control */
 #define	D64_XC_XE		0x00000001	/* transmit enable */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 68938fe..0019c04 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -966,16 +966,16 @@ struct lcnphy_radio_regs {
 extern lcnphy_radio_regs_t lcnphy_radio_regs_2064[];
 extern lcnphy_radio_regs_t lcnphy_radio_regs_2066[];
 extern radio_regs_t regs_2055[], regs_SYN_2056[], regs_TX_2056[],
-    regs_RX_2056[];
+	regs_RX_2056[];
 extern radio_regs_t regs_SYN_2056_A1[], regs_TX_2056_A1[], regs_RX_2056_A1[];
 extern radio_regs_t regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
-    regs_RX_2056_rev5[];
+	regs_RX_2056_rev5[];
 extern radio_regs_t regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
-    regs_RX_2056_rev6[];
+	regs_RX_2056_rev6[];
 extern radio_regs_t regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
-    regs_RX_2056_rev7[];
+	regs_RX_2056_rev7[];
 extern radio_regs_t regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
-    regs_RX_2056_rev8[];
+	regs_RX_2056_rev8[];
 extern radio_20xx_regs_t regs_2057_rev4[], regs_2057_rev5[], regs_2057_rev5v1[];
 extern radio_20xx_regs_t regs_2057_rev7[], regs_2057_rev8[];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 4d35e5d..3b61beb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -888,9 +888,8 @@ lcnphy_radio_regs_t lcnphy_radio_regs_2064[] = {
 #define LCNPHY_NUM_DIG_FILT_COEFFS 16
 #define LCNPHY_NUM_TX_DIG_FILTERS_CCK 13
 
-u16
-    LCNPHY_txdigfiltcoeffs_cck[LCNPHY_NUM_TX_DIG_FILTERS_CCK]
-    [LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
+u16 LCNPHY_txdigfiltcoeffs_cck[LCNPHY_NUM_TX_DIG_FILTERS_CCK]
+	[LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
 	{0, 1, 415, 1874, 64, 128, 64, 792, 1656, 64, 128, 64, 778, 1582, 64,
 	 128, 64,},
 	{1, 1, 402, 1847, 259, 59, 259, 671, 1794, 68, 54, 68, 608, 1863, 93,
@@ -920,9 +919,8 @@ u16
 };
 
 #define LCNPHY_NUM_TX_DIG_FILTERS_OFDM 3
-u16
-    LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
-    [LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
+u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
+	[LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
 	{0, 0, 0xa2, 0x0, 0x100, 0x100, 0x0, 0x0, 0x0, 0x100, 0x0, 0x0,
 	 0x278, 0xfea0, 0x80, 0x100, 0x80,},
 	{1, 0, 374, 0xFF79, 16, 32, 16, 799, 0xFE74, 50, 32, 50,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 6439d81..5b6538f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1608,20 +1608,20 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[] = {
 };
 
 const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
-    sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
-    sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
+	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
+	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
 
 const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
-    sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
-    sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
+	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
+	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
 
 const u32 dot11lcnphytbl_rx_gain_info_2G_rev2_sz =
-    sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2) /
-    sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2[0]);
+	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2) /
+	sizeof(dot11lcnphytbl_rx_gain_info_2G_rev2[0]);
 
 const u32 dot11lcnphytbl_rx_gain_info_5G_rev2_sz =
-    sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2) /
-    sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2[0]);
+	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2) /
+	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2[0]);
 
 const u16 dot11lcn_min_sig_sq_tbl_rev0[] = {
 	0x014d,
@@ -2857,7 +2857,7 @@ const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
 };
 
 const u32 dot11lcnphytbl_info_sz_rev0 =
-    sizeof(dot11lcnphytbl_info_rev0) / sizeof(dot11lcnphytbl_info_rev0[0]);
+	sizeof(dot11lcnphytbl_info_rev0) / sizeof(dot11lcnphytbl_info_rev0[0]);
 
 const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
 	{3, 0, 31, 0, 72,}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index 84b4f69..8835367 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -4535,10 +4535,10 @@ const mimophytbl_info_t mimophytbl_info_rev0[] = {
 };
 
 const u32 mimophytbl_info_sz_rev0 =
-    sizeof(mimophytbl_info_rev0) / sizeof(mimophytbl_info_rev0[0]);
+	sizeof(mimophytbl_info_rev0) / sizeof(mimophytbl_info_rev0[0]);
 const u32 mimophytbl_info_sz_rev0_volatile =
-    sizeof(mimophytbl_info_rev0_volatile) /
-    sizeof(mimophytbl_info_rev0_volatile[0]);
+	sizeof(mimophytbl_info_rev0_volatile) /
+	sizeof(mimophytbl_info_rev0_volatile[0]);
 
 const u16 ant_swctrl_tbl_rev3[] = {
 	0x0082,
@@ -9475,19 +9475,19 @@ const mimophytbl_info_t mimophytbl_info_rev3[] = {
 };
 
 const u32 mimophytbl_info_sz_rev3 =
-    sizeof(mimophytbl_info_rev3) / sizeof(mimophytbl_info_rev3[0]);
+	sizeof(mimophytbl_info_rev3) / sizeof(mimophytbl_info_rev3[0]);
 const u32 mimophytbl_info_sz_rev3_volatile =
-    sizeof(mimophytbl_info_rev3_volatile) /
-    sizeof(mimophytbl_info_rev3_volatile[0]);
+	sizeof(mimophytbl_info_rev3_volatile) /
+	sizeof(mimophytbl_info_rev3_volatile[0]);
 const u32 mimophytbl_info_sz_rev3_volatile1 =
-    sizeof(mimophytbl_info_rev3_volatile1) /
-    sizeof(mimophytbl_info_rev3_volatile1[0]);
+	sizeof(mimophytbl_info_rev3_volatile1) /
+	sizeof(mimophytbl_info_rev3_volatile1[0]);
 const u32 mimophytbl_info_sz_rev3_volatile2 =
-    sizeof(mimophytbl_info_rev3_volatile2) /
-    sizeof(mimophytbl_info_rev3_volatile2[0]);
+	sizeof(mimophytbl_info_rev3_volatile2) /
+	sizeof(mimophytbl_info_rev3_volatile2[0]);
 const u32 mimophytbl_info_sz_rev3_volatile3 =
-    sizeof(mimophytbl_info_rev3_volatile3) /
-    sizeof(mimophytbl_info_rev3_volatile3[0]);
+	sizeof(mimophytbl_info_rev3_volatile3) /
+	sizeof(mimophytbl_info_rev3_volatile3[0]);
 
 const u32 tmap_tbl_rev7[] = {
 	0x8a88aa80,
@@ -10579,7 +10579,7 @@ const mimophytbl_info_t mimophytbl_info_rev7[] = {
 };
 
 const u32 mimophytbl_info_sz_rev7 =
-    sizeof(mimophytbl_info_rev7) / sizeof(mimophytbl_info_rev7[0]);
+	sizeof(mimophytbl_info_rev7) / sizeof(mimophytbl_info_rev7[0]);
 
 const mimophytbl_info_t mimophytbl_info_rev16[] = {
 	{&noise_var_tbl_rev7,
@@ -10626,4 +10626,4 @@ const mimophytbl_info_t mimophytbl_info_rev16[] = {
 };
 
 const u32 mimophytbl_info_sz_rev16 =
-    sizeof(mimophytbl_info_rev16) / sizeof(mimophytbl_info_rev16[0]);
+	sizeof(mimophytbl_info_rev16) / sizeof(mimophytbl_info_rev16[0]);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
index a02b73c..4b2a04d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
@@ -20,15 +20,15 @@
 #include "phy_int.h"
 
 extern const mimophytbl_info_t mimophytbl_info_rev0[],
-    mimophytbl_info_rev0_volatile[];
+	mimophytbl_info_rev0_volatile[];
 extern const u32 mimophytbl_info_sz_rev0, mimophytbl_info_sz_rev0_volatile;
 
 extern const mimophytbl_info_t mimophytbl_info_rev3[],
-    mimophytbl_info_rev3_volatile[], mimophytbl_info_rev3_volatile1[],
-    mimophytbl_info_rev3_volatile2[], mimophytbl_info_rev3_volatile3[];
+	mimophytbl_info_rev3_volatile[], mimophytbl_info_rev3_volatile1[],
+	mimophytbl_info_rev3_volatile2[], mimophytbl_info_rev3_volatile3[];
 extern const u32 mimophytbl_info_sz_rev3, mimophytbl_info_sz_rev3_volatile,
-    mimophytbl_info_sz_rev3_volatile1, mimophytbl_info_sz_rev3_volatile2,
-    mimophytbl_info_sz_rev3_volatile3;
+	mimophytbl_info_sz_rev3_volatile1, mimophytbl_info_sz_rev3_volatile2,
+	mimophytbl_info_sz_rev3_volatile3;
 
 extern const u32 noise_var_tbl_rev3[];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 413d5db..61b3720 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -31,8 +31,8 @@
 #define RADAR_TYPE_ITU_K	5	/* ITU K Radar type */
 #define RADAR_TYPE_UNCLASSIFIED	6	/* Unclassified Radar type  */
 #define RADAR_TYPE_BIN5		7	/* long pulse radar type */
-#define RADAR_TYPE_STG2 	8	/* staggered-2 radar */
-#define RADAR_TYPE_STG3 	9	/* staggered-3 radar */
+#define RADAR_TYPE_STG2		8	/* staggered-2 radar */
+#define RADAR_TYPE_STG3		9	/* staggered-3 radar */
 #define RADAR_TYPE_FRA		10	/* French radar */
 
 /* French radar pulse widths */
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index e221a3b..37b6b77 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -510,7 +510,7 @@ static const u8 crc8_table[256] = {
 u8 brcmu_crc8(u8 *pdata,	/* pointer to array of data to process */
 			 uint nbytes,	/* number of input data bytes to process */
 			 u8 crc	/* either CRC8_INIT_VALUE or previous return value */
-    ) {
+	) {
 	/* loop over the buffer data */
 	while (nbytes-- > 0)
 		crc = crc8_table[(crc ^ *pdata++) & 0xff];
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index b0f36e3..d0039d7 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -246,9 +246,9 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 
 /* modulo add/sub - assumes x, y E [0, bound - 1] */
 #define MODADD(x, y, bound) \
-    MUX((x) + (y) >= (bound), (x) + (y) - (bound), (x) + (y))
+	MUX((x) + (y) >= (bound), (x) + (y) - (bound), (x) + (y))
 #define MODSUB(x, y, bound) \
-    MUX(((int)(x)) - ((int)(y)) < 0, (x) - (y) + (bound), (x) - (y))
+	MUX(((int)(x)) - ((int)(y)) < 0, (x) - (y) + (bound), (x) - (y))
 
 /* module add/sub, bound = 2^k */
 #define MODADD_POW2(x, y, bound) (((x) + (y)) & ((bound) - 1))
-- 
1.7.1


