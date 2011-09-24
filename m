Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4599 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1IXCJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 22:09:23 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/20] staging: brcm80211: declared global vars in
 softmac phy as const
Date: Fri, 23 Sep 2011 19:09:04 -0700
Message-ID: <1316830148-28661-17-git-send-email-frankyl@broadcom.com> (sfid-20110924_040943_874074_66A66277)
In-Reply-To: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Global variables are undesirable unless they are read only.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   16 +-----
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   23 --------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   60 ++++++++++----------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    2 +-
 5 files changed, 36 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 3f6e4bc..ab1db2d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -52,7 +52,7 @@ struct chan_info_basic {
 	u16 freq;
 };
 
-static struct chan_info_basic chan_info_all[] = {
+static const struct chan_info_basic chan_info_all[] = {
 	{1, 2412},
 	{2, 2417},
 	{3, 2422},
@@ -111,20 +111,6 @@ static struct chan_info_basic chan_info_all[] = {
 	{216, 50800}
 };
 
-u16 ltrn_list[PHY_LTRN_LIST_LEN] = {
-	0x18f9, 0x0d01, 0x00e4, 0xdef4, 0x06f1, 0x0ffc,
-	0xfa27, 0x1dff, 0x10f0, 0x0918, 0xf20a, 0xe010,
-	0x1417, 0x1104, 0xf114, 0xf2fa, 0xf7db, 0xe2fc,
-	0xe1fb, 0x13ee, 0xff0d, 0xe91c, 0x171a, 0x0318,
-	0xda00, 0x03e8, 0x17e6, 0xe9e4, 0xfff3, 0x1312,
-	0xe105, 0xe204, 0xf725, 0xf206, 0xf1ec, 0x11fc,
-	0x14e9, 0xe0f0, 0xf2f6, 0x09e8, 0x1010, 0x1d01,
-	0xfad9, 0x0f04, 0x060f, 0xde0c, 0x001c, 0x0dff,
-	0x1807, 0xf61a, 0xe40e, 0x0f16, 0x05f9, 0x18ec,
-	0x0a1b, 0xff1e, 0x2600, 0xffe2, 0x0ae5, 0x1814,
-	0x0507, 0x0fea, 0xe4f2, 0xf6e6
-};
-
 const u8 ofdm_rate_lookup[] = {
 
 	BRCM_RATE_48M,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index b94117b..f67e2be 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -247,9 +247,6 @@ enum phy_cal_mode {
 #define PUB_NOT_ASSOC(pi) \
 	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_NOT_ASSOC))
 
-#define PHY_LTRN_LIST_LEN	64
-extern u16 ltrn_list[PHY_LTRN_LIST_LEN];
-
 struct phy_table_info {
 	uint table;
 	int q;
@@ -922,26 +919,6 @@ struct lcnphy_radio_regs {
 	u8 do_init_g;
 };
 
-extern struct lcnphy_radio_regs lcnphy_radio_regs_2064[];
-extern struct lcnphy_radio_regs lcnphy_radio_regs_2066[];
-
-extern struct radio_regs regs_2055[], regs_SYN_2056[], regs_TX_2056[],
-			 regs_RX_2056[];
-extern struct radio_regs regs_SYN_2056_A1[], regs_TX_2056_A1[],
-			 regs_RX_2056_A1[];
-extern struct radio_regs regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
-			 regs_RX_2056_rev5[];
-extern struct radio_regs regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
-			 regs_RX_2056_rev6[];
-extern struct radio_regs regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
-			 regs_RX_2056_rev7[];
-extern struct radio_regs regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
-			 regs_RX_2056_rev8[];
-
-extern struct radio_20xx_regs regs_2057_rev4[], regs_2057_rev5[],
-			      regs_2057_rev5v1[];
-extern struct radio_20xx_regs regs_2057_rev7[], regs_2057_rev8[];
-
 extern char *phy_getvar(struct brcms_phy *pi, const char *name);
 extern int phy_getintvar(struct brcms_phy *pi, const char *name);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index fdcea56..a87e392 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -558,7 +558,7 @@ struct chan_info_2064_lcnphy {
 	u8 rxrf_rxrf_spare1;
 };
 
-static struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
+static const struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{1, 2412, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{2, 2417, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{3, 2422, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
@@ -575,7 +575,7 @@ static struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{14, 2484, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 };
 
-struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
+static const struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
 	{0x00, 0, 0, 0, 0},
 	{0x01, 0x64, 0x64, 0, 0},
 	{0x02, 0x20, 0x20, 0, 0},
@@ -4489,7 +4489,7 @@ static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
 static void wlc_radio_2064_init(struct brcms_phy *pi)
 {
 	u32 i;
-	struct lcnphy_radio_regs *lcnphyregs = NULL;
+	const struct lcnphy_radio_regs *lcnphyregs = NULL;
 
 	lcnphyregs = lcnphy_radio_regs_2064;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 224ce06..e080b3a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -443,7 +443,7 @@ struct nphy_sfo_cfg {
 	u16 PHY_BW6;
 };
 
-static struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
+static const struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
 	{
 	 184, 4920, 3280, 0x71, 0x01, 0xEC, 0x0F, 0xFF, 0x01, 0x04, 0x0A,
 	 0x00, 0x8F, 0xFF, 0xFF, 0xFF, 0x00, 0x0F, 0x0F, 0x8F, 0xFF, 0x00, 0x0F,
@@ -942,7 +942,7 @@ static struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
 	 0x01, 0x80, 0x3E6, 0x3E2, 0x3DE, 0x41B, 0x41F, 0x424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x08, 0x00, 0x7f,
@@ -1565,7 +1565,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
 	 0x0f, 0x00, 0x0d, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0e, 0x00, 0x7f,
@@ -2188,7 +2188,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
 	 0x0f, 0x00, 0x0e, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -2811,7 +2811,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -3434,7 +3434,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -4057,7 +4057,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -4680,7 +4680,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
+static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x02, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -5303,7 +5303,7 @@ static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
+static const struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0x00, 0x0f, 0x0f, 0xf3, 0x00, 0xef, 0x00,
@@ -6166,7 +6166,8 @@ static struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
 	 0x0424}
 };
 
-static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev8_2057_rev5[] = {
+static const struct chan_info_nphy_radio2057_rev5
+chan_info_nphyrev8_2057_rev5[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6225,7 +6226,8 @@ static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev8_2057_rev5[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev9_2057_rev5v1[] = {
+static const struct chan_info_nphy_radio2057_rev5
+chan_info_nphyrev9_2057_rev5v1[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6284,7 +6286,7 @@ static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev9_2057_rev5v1[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
+static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -7025,7 +7027,7 @@ static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
 	 0x0424}
 };
 
-static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
+static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
 	{
 	 186, 4930, 0x6b, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xed, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -20387,15 +20389,15 @@ void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
 
 static bool
 wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
-		       struct chan_info_nphy_radio2057 **t0,
-		       struct chan_info_nphy_radio205x **t1,
-		       struct chan_info_nphy_radio2057_rev5 **t2,
-		       struct chan_info_nphy_2055 **t3)
+		       const struct chan_info_nphy_radio2057 **t0,
+		       const struct chan_info_nphy_radio205x **t1,
+		       const struct chan_info_nphy_radio2057_rev5 **t2,
+		       const struct chan_info_nphy_2055 **t3)
 {
 	uint i;
-	struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
-	struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
+	const struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
+	const struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
+	const struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
 	u32 tbl_len = 0;
 
 	int freq = 0;
@@ -20550,10 +20552,10 @@ fail:
 u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 {
 	int freq;
-	struct chan_info_nphy_radio2057 *t0 = NULL;
-	struct chan_info_nphy_radio205x *t1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	struct chan_info_nphy_2055 *t3 = NULL;
+	const struct chan_info_nphy_radio2057 *t0 = NULL;
+	const struct chan_info_nphy_radio205x *t1 = NULL;
+	const struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	const struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (channel == 0)
 		channel = CHSPEC_CHANNEL(pi->radio_chanspec);
@@ -20573,7 +20575,7 @@ u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 
 static void
 wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
-				 struct chan_info_nphy_2055 *ci)
+				 const struct chan_info_nphy_2055 *ci)
 {
 
 	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
@@ -21294,10 +21296,10 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 {
 	int freq;
-	struct chan_info_nphy_radio2057 *t0 = NULL;
-	struct chan_info_nphy_radio205x *t1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	struct chan_info_nphy_2055 *t3 = NULL;
+	const struct chan_info_nphy_radio2057 *t0 = NULL;
+	const struct chan_info_nphy_radio205x *t1 = NULL;
+	const struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	const struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (!wlc_phy_chan2freq_nphy
 		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 15c5ffc..1b11b2f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1611,7 +1611,7 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
 
-static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
+const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
 
-- 
1.7.1


