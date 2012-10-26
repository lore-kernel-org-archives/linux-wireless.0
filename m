Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 10/18] brcmsmac: Add BRCMS_DBG_MAC80211 debug macro
Date: Fri, 26 Oct 2012 09:23:25 -0500
Message-Id: <1351261413-20821-11-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162418_756851_28A24DAC)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This macro is used for messages related to the 802.11 MAC layer.
Relevant messages are also converted to use this macro.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   59 +++++++++++---------
 drivers/net/wireless/brcm80211/include/defs.h      |    1 +
 3 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
index ab7f516..12f513b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
@@ -35,6 +35,7 @@ static inline void __brcms_dbg(struct device *dev, u32 level,
 #define BRCMS_ERR(core, f, a...)	__brcms_err(&(core)->dev, f, ##a)
 #define BRCMS_CRIT(core, f, a...)	__brcms_crit(&(core)->dev, f, ##a)
 
-#define BRCMS_DBG_INFO(core, f, a...)	BRCMS_DBG(core, BRCM_DL_INFO, f, ##a)
+#define BRCMS_DBG_INFO(core, f, a...)		BRCMS_DBG(core, BRCM_DL_INFO, f, ##a)
+#define BRCMS_DBG_MAC80211(core, f, a...)	BRCMS_DBG(core, BRCM_DL_MAC80211, f, ##a)
 
 #endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index a5fafb0..09cca57 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -652,8 +652,9 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		rate = BRCM_RATE_1M;
 	}
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
-		 wlc->pub->unit, ratespec, preamble_type, mac_len);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
+			   wlc->pub->unit, ratespec, preamble_type, mac_len);
 
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -813,8 +814,8 @@ static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 /* low-level band switch utility routine */
 static void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		bandunit);
+	BRCMS_DBG_MAC80211(wlc_hw->d11core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   bandunit);
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
@@ -842,7 +843,7 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 	u32 macintmask;
 	u32 macctrl;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_MAC80211(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 	macctrl = bcma_read32(wlc_hw->d11core,
 			      D11REGOFFS(maccontrol));
 	WARN_ON((macctrl & MCTL_EN_MAC) != 0);
@@ -1730,8 +1731,8 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc_hw->band->bandunit);
+	BRCMS_DBG_MAC80211(wlc_hw->d11core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc_hw->band->bandunit);
 
 	brcms_c_ucode_bsinit(wlc_hw);
 
@@ -2654,8 +2655,8 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc_hw->band->bandunit);
+	BRCMS_DBG_MAC80211(core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc_hw->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -2722,8 +2723,8 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc->band->bandunit);
+	BRCMS_DBG_MAC80211(core, "wl%d: bandunit %d\n", wlc_hw->unit,
+			   wlc->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3783,7 +3784,8 @@ static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 
 	hps = brcms_c_ps_allowed(wlc);
 
-	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core, "wl%d: hps %d\n", wlc->pub->unit,
+			   hps);
 
 	v1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
 	v2 = MCTL_WAKE;
@@ -3869,7 +3871,8 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 {
 	uint bandunit;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
+	BRCMS_DBG_MAC80211(wlc_hw->d11core, "wl%d: 0x%x\n", wlc_hw->unit,
+			   chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -5984,8 +5987,9 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 {
 	uint dur = 0;
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -6003,8 +6007,9 @@ static uint
 brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
 		      u8 preamble_type)
 {
-	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core,
+			   "wl%d: ratespec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -6012,8 +6017,9 @@ static uint
 brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 		     u8 preamble_type)
 {
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
-                "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d\n",
+			   wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -6067,8 +6073,9 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = rspec2rate(ratespec);
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
-		 wlc->pub->unit, ratespec, preamble_type, dur);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core,
+			   "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
+			   wlc->pub->unit, ratespec, preamble_type, dur);
 
 	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -6183,9 +6190,9 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
-				BCMMSG(wlc->wiphy, "wl%d: enabling "
-				       "SDM mode for mcs %d\n",
-				       wlc->pub->unit, rate);
+				BRCMS_DBG_MAC80211(core, "wl%d: enabling "
+						   "SDM mode for mcs %d\n",
+						   wlc->pub->unit, rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -7474,8 +7481,8 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 {
 	uint nsyms, len = 0, kNdps;
 
-	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
-		 wlc->pub->unit, rspec2rate(ratespec), mac_len);
+	BRCMS_DBG_MAC80211(wlc->hw->d11core, "wl%d: rate %d, len%d\n",
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

