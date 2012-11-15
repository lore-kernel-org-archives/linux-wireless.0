Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767961Ab2KOOIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:45 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 14/22] brcmsmac: Add brcms_dbg_mac80211() debug macro
Date: Thu, 15 Nov 2012 08:08:04 -0600
Message-Id: <1352988492-21340-15-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150854_612681_335B8417)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This macro is used for messages related to the 802.11 MAC layer.
Relevant messages are also converted to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |   59 +++++++++++++----------
 drivers/net/wireless/brcm80211/include/defs.h   |    1 +
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index 6f2fe3b..f4f5090 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -35,6 +35,7 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define brcms_err(core, f, a...)	__brcms_err(&(core)->dev, f, ##a)
 #define brcms_crit(core, f, a...)	__brcms_crit(&(core)->dev, f, ##a)
 
-#define brcms_dbg_info(core, f, a...)	brcms_dbg(core, BRCM_DL_INFO, f, ##a)
+#define brcms_dbg_info(core, f, a...)		brcms_dbg(core, BRCM_DL_INFO, f, ##a)
+#define brcms_dbg_mac80211(core, f, a...)	brcms_dbg(core, BRCM_DL_MAC80211, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 87db750..9c976b2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -646,8 +646,9 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		rate = BRCM_RATE_1M;
 	}
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
-		 wlc->pub->unit, ratespec, preamble_type, mac_len);
+	brcms_dbg_mac80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
+			   wlc->pub->unit, ratespec, preamble_type, mac_len);
 
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -807,8 +808,8 @@ static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 /* low-level band switch utility routine */
 static void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		bandunit);
+	brcms_dbg_mac80211(wlc_hw->d11core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   bandunit);
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
@@ -836,7 +837,7 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 	u32 macintmask;
 	u32 macctrl;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	brcms_dbg_mac80211(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 	macctrl = bcma_read32(wlc_hw->d11core,
 			      D11REGOFFS(maccontrol));
 	WARN_ON((macctrl & MCTL_EN_MAC) != 0);
@@ -1724,8 +1725,8 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc_hw->band->bandunit);
+	brcms_dbg_mac80211(wlc_hw->d11core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc_hw->band->bandunit);
 
 	brcms_c_ucode_bsinit(wlc_hw);
 
@@ -2648,8 +2649,8 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc_hw->band->bandunit);
+	brcms_dbg_mac80211(core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc_hw->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -2716,8 +2717,8 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc->band->bandunit);
+	brcms_dbg_mac80211(core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3777,7 +3778,8 @@ static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 
 	hps = brcms_c_ps_allowed(wlc);
 
-	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
+	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: hps %d\n", wlc->pub->unit,
+			   hps);
 
 	v1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
 	v2 = MCTL_WAKE;
@@ -3863,7 +3865,8 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 {
 	uint bandunit;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
+	brcms_dbg_mac80211(wlc_hw->d11core, "wl%d: 0x%x\n", wlc_hw->unit,
+			   chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -5978,8 +5981,9 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 {
 	uint dur = 0;
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
+	brcms_dbg_mac80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -5997,8 +6001,9 @@ static uint
 brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
 		      u8 preamble_type)
 {
-	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
+	brcms_dbg_mac80211(wlc->hw->d11core,
+			   "wl%d: ratespec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -6006,8 +6011,9 @@ static uint
 brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 		     u8 preamble_type)
 {
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
-                "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
+	brcms_dbg_mac80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -6061,8 +6067,9 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = rspec2rate(ratespec);
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
-		 wlc->pub->unit, ratespec, preamble_type, dur);
+	brcms_dbg_mac80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
+			   wlc->pub->unit, ratespec, preamble_type, dur);
 
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -6177,9 +6184,9 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
-				BCMMSG(wlc->wiphy, "wl%d: enabling "
-				       "SDM mode for mcs %d\n",
-				       wlc->pub->unit, rate);
+				brcms_dbg_mac80211(core, "wl%d: enabling "
+						   "SDM mode for mcs %d\n",
+						   wlc->pub->unit, rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -7468,8 +7475,8 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 {
 	uint nsyms, len = 0, kNdps;
 
-	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
-		 wlc->pub->unit, rspec2rate(ratespec), mac_len);
+	brcms_dbg_mac80211(wlc->hw->d11core, "wl%d: rate %d, len%d\n",
+			   wlc->pub->unit, rspec2rate(ratespec), mac_len);
 
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 223eb2b..4d6906f 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -80,6 +80,7 @@
 
 /* Debug levels */
 #define BRCM_DL_INFO		0x00000001
+#define BRCM_DL_MAC80211	0x00000002
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.9.5

