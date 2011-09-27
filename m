Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4747 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab1I0Rpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 25/26] staging: brcm80211: simple changes to softmac
 phy variables
Date: Tue, 27 Sep 2011 10:45:29 -0700
Message-ID: <1317145530-18839-26-git-send-email-frankyl@broadcom.com> (sfid-20110927_194637_673821_68B3E8BA)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup resulting in less sparse warnings.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   60 ++++++++++----------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    2 +-
 4 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 5b81480..f31ebe2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -52,7 +52,7 @@ struct chan_info_basic {
 	u16 freq;
 };
 
-static const struct chan_info_basic chan_info_all[] = {
+static struct chan_info_basic chan_info_all[] = {
 	{1, 2412},
 	{2, 2417},
 	{3, 2422},
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index a87e392..bada928 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -558,7 +558,7 @@ struct chan_info_2064_lcnphy {
 	u8 rxrf_rxrf_spare1;
 };
 
-static const struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
+static struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{1, 2412, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{2, 2417, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{3, 2422, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
@@ -575,7 +575,7 @@ static const struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{14, 2484, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 };
 
-static const struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
+static struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
 	{0x00, 0, 0, 0, 0},
 	{0x01, 0x64, 0x64, 0, 0},
 	{0x02, 0x20, 0x20, 0, 0},
@@ -4489,7 +4489,7 @@ static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
 static void wlc_radio_2064_init(struct brcms_phy *pi)
 {
 	u32 i;
-	const struct lcnphy_radio_regs *lcnphyregs = NULL;
+	struct lcnphy_radio_regs *lcnphyregs = NULL;
 
 	lcnphyregs = lcnphy_radio_regs_2064;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 93ac12f..a34d292 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -443,7 +443,7 @@ struct nphy_sfo_cfg {
 	u16 PHY_BW6;
 };
 
-static const struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
+static struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
 	{
 	 184, 4920, 3280, 0x71, 0x01, 0xEC, 0x0F, 0xFF, 0x01, 0x04, 0x0A,
 	 0x00, 0x8F, 0xFF, 0xFF, 0xFF, 0x00, 0x0F, 0x0F, 0x8F, 0xFF, 0x00, 0x0F,
@@ -942,7 +942,7 @@ static const struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
 	 0x01, 0x80, 0x3E6, 0x3E2, 0x3DE, 0x41B, 0x41F, 0x424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x08, 0x00, 0x7f,
@@ -1565,7 +1565,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
 	 0x0f, 0x00, 0x0d, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0e, 0x00, 0x7f,
@@ -2188,7 +2188,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
 	 0x0f, 0x00, 0x0e, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -2811,7 +2811,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -3434,7 +3434,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -4057,7 +4057,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -4680,7 +4680,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x02, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -5303,7 +5303,7 @@ static const struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0x00, 0x0f, 0x0f, 0xf3, 0x00, 0xef, 0x00,
@@ -6166,8 +6166,7 @@ static const struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
 	 0x0424}
 };
 
-static const struct chan_info_nphy_radio2057_rev5
-chan_info_nphyrev8_2057_rev5[] = {
+static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev8_2057_rev5[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6226,8 +6225,7 @@ chan_info_nphyrev8_2057_rev5[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio2057_rev5
-chan_info_nphyrev9_2057_rev5v1[] = {
+static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev9_2057_rev5v1[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6286,7 +6284,7 @@ chan_info_nphyrev9_2057_rev5v1[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -7027,7 +7025,7 @@ static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
 	 0x0424}
 };
 
-static const struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
 	{
 	 186, 4930, 0x6b, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xed, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -20389,15 +20387,15 @@ void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
 
 static bool
 wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
-		       const struct chan_info_nphy_radio2057 **t0,
-		       const struct chan_info_nphy_radio205x **t1,
-		       const struct chan_info_nphy_radio2057_rev5 **t2,
-		       const struct chan_info_nphy_2055 **t3)
+		       struct chan_info_nphy_radio2057 **t0,
+		       struct chan_info_nphy_radio205x **t1,
+		       struct chan_info_nphy_radio2057_rev5 **t2,
+		       struct chan_info_nphy_2055 **t3)
 {
 	uint i;
-	const struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
-	const struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
-	const struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
+	struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
+	struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
 	u32 tbl_len = 0;
 
 	int freq = 0;
@@ -20552,10 +20550,10 @@ fail:
 u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 {
 	int freq;
-	const struct chan_info_nphy_radio2057 *t0 = NULL;
-	const struct chan_info_nphy_radio205x *t1 = NULL;
-	const struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	const struct chan_info_nphy_2055 *t3 = NULL;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (channel == 0)
 		channel = CHSPEC_CHANNEL(pi->radio_chanspec);
@@ -20575,7 +20573,7 @@ u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 
 static void
 wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
-				 const struct chan_info_nphy_2055 *ci)
+				 struct chan_info_nphy_2055 *ci)
 {
 
 	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
@@ -21296,10 +21294,10 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 {
 	int freq;
-	const struct chan_info_nphy_radio2057 *t0 = NULL;
-	const struct chan_info_nphy_radio205x *t1 = NULL;
-	const struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	const struct chan_info_nphy_2055 *t3 = NULL;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (!wlc_phy_chan2freq_nphy
 		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 1b11b2f..15c5ffc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1611,7 +1611,7 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
 
-const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
+static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
 
-- 
1.7.1


