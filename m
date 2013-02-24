Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53989 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab3BXBHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:07:11 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 10/13] brcmsmac: add beacon template support
Date: Sun, 24 Feb 2013 02:06:08 +0100
Message-Id: <1361667972-22909-11-git-send-email-hauke@hauke-m.de> (sfid-20130224_020720_970774_02C51F0E)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible that a beacon template provided by mac80211 is
written to the hardware for constant beaconing.

This is based on an old version of brcmsmac, on b43 and the spec b43 is
based on.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   13 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  141 +++++++++++++++++++-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    4 +
 4 files changed, 159 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 577df22..7a76977 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010 Broadcom Corporation
+ * Copyright (c) 2013 Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -519,9 +520,17 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET, info->bssid);
 		spin_unlock_bh(&wl->lock);
 	}
-	if (changed & BSS_CHANGED_BEACON)
+	if (changed & BSS_CHANGED_BEACON) {
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
-		brcms_err(core, "%s: beacon changed\n", __func__);
+		struct sk_buff *beacon;
+		u16 tim_offset = 0;
+
+		spin_lock_bh(&wl->lock);
+		beacon = ieee80211_beacon_get_tim(hw, vif, &tim_offset, NULL);
+		brcms_c_set_new_beacon(wl->wlc, beacon, tim_offset,
+				       info->dtim_period);
+		spin_unlock_bh(&wl->lock);
+	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b993ddc..7ed4e8e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010 Broadcom Corporation
+ * Copyright (c) 2013 Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -448,6 +449,8 @@ static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	kfree(wlc->corestate);
 	kfree(wlc->hw->bandstate[0]);
 	kfree(wlc->hw);
+	if (wlc->beacon)
+		dev_kfree_skb_any(wlc->beacon);
 
 	/* free the wlc */
 	kfree(wlc);
@@ -4084,10 +4087,14 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 					  *shm_entry++);
 	}
 
-	if (suspend) {
+	if (suspend)
 		brcms_c_suspend_mac_and_wait(wlc);
+
+	brcms_c_update_beacon(wlc);
+	brcms_c_update_probe_resp(wlc, false);
+
+	if (suspend)
 		brcms_c_enable_mac(wlc);
-	}
 }
 
 static void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
@@ -7375,6 +7382,107 @@ int brcms_c_get_header_len(void)
 	return TXOFF;
 }
 
+static void brcms_c_beacon_write(struct brcms_c_info *wlc,
+				 struct sk_buff *beacon, u16 tim_offset,
+				 u16 dtim_period, bool bcn0, bool bcn1)
+{
+	size_t len;
+	struct ieee80211_tx_info *tx_info;
+	struct brcms_hardware *wlc_hw = wlc->hw;
+	struct ieee80211_hw *ieee_hw = brcms_c_pub(wlc)->ieee_hw;
+
+	/* Get tx_info */
+	tx_info = IEEE80211_SKB_CB(beacon);
+
+	len = min_t(size_t, beacon->len, BCN_TMPL_LEN);
+	wlc->bcn_rspec = ieee80211_get_tx_rate(ieee_hw, tx_info)->hw_value;
+
+	brcms_c_compute_plcp(wlc, wlc->bcn_rspec,
+			     len + FCS_LEN - D11_PHY_HDR_LEN, beacon->data);
+
+	/* "Regular" and 16 MBSS but not for 4 MBSS */
+	/* Update the phytxctl for the beacon based on the rspec */
+	brcms_c_beacon_phytxctl_txant_upd(wlc, wlc->bcn_rspec);
+
+	if (bcn0) {
+		/* write the probe response into the template region */
+		brcms_b_write_template_ram(wlc_hw, T_BCN0_TPL_BASE,
+					    (len + 3) & ~3, beacon->data);
+
+		/* write beacon length to SCR */
+		brcms_b_write_shm(wlc_hw, M_BCN0_FRM_BYTESZ, (u16) len);
+	}
+	if (bcn1) {
+		/* write the probe response into the template region */
+		brcms_b_write_template_ram(wlc_hw, T_BCN1_TPL_BASE,
+					    (len + 3) & ~3, beacon->data);
+
+		/* write beacon length to SCR */
+		brcms_b_write_shm(wlc_hw, M_BCN1_FRM_BYTESZ, (u16) len);
+	}
+
+	if (tim_offset != 0) {
+		brcms_b_write_shm(wlc_hw, M_TIMBPOS_INBEACON,
+				  tim_offset + D11B_PHY_HDR_LEN);
+		brcms_b_write_shm(wlc_hw, M_DOT11_DTIMPERIOD, dtim_period);
+	} else {
+		brcms_b_write_shm(wlc_hw, M_TIMBPOS_INBEACON,
+				  len + D11B_PHY_HDR_LEN);
+		brcms_b_write_shm(wlc_hw, M_DOT11_DTIMPERIOD, 0);
+	}
+}
+
+static void brcms_c_update_beacon_hw(struct brcms_c_info *wlc,
+				     struct sk_buff *beacon, u16 tim_offset,
+				     u16 dtim_period)
+{
+	struct brcms_hardware *wlc_hw = wlc->hw;
+	struct bcma_device *core = wlc_hw->d11core;
+
+	/* Hardware beaconing for this config */
+	u32 both_valid = MCMD_BCN0VLD | MCMD_BCN1VLD;
+
+	/* Check if both templates are in use, if so sched. an interrupt
+	 *      that will call back into this routine
+	 */
+	if ((bcma_read32(core, D11REGOFFS(maccommand)) & both_valid) == both_valid)
+		/* clear any previous status */
+		bcma_write32(core, D11REGOFFS(macintstatus), MI_BCNTPL);
+
+	if (wlc->beacon_template_virgin) {
+		wlc->beacon_template_virgin = false;
+		brcms_c_beacon_write(wlc, beacon, tim_offset, dtim_period, true,
+				     true);
+		/* mark beacon0 valid */
+		bcma_set32(core, D11REGOFFS(maccommand), MCMD_BCN0VLD);
+		return;
+	}
+
+	/* Check that after scheduling the interrupt both of the
+	 *      templates are still busy. if not clear the int. & remask
+	 */
+	if ((bcma_read32(core, D11REGOFFS(maccommand)) & both_valid) == both_valid) {
+		wlc->defmacintmask |= MI_BCNTPL;
+		return;
+	}
+
+	if (!(bcma_read32(core, D11REGOFFS(maccommand)) & MCMD_BCN0VLD)) {
+		brcms_c_beacon_write(wlc, beacon, tim_offset, dtim_period, true,
+				     false);
+		/* mark beacon0 valid */
+		bcma_set32(core, D11REGOFFS(maccommand), MCMD_BCN0VLD);
+		return;
+	}
+	if (!(bcma_read32(core, D11REGOFFS(maccommand)) & MCMD_BCN1VLD)) {
+		brcms_c_beacon_write(wlc, beacon, tim_offset, dtim_period,
+				     false, true);
+		/* mark beacon0 valid */
+		bcma_set32(core, D11REGOFFS(maccommand), MCMD_BCN1VLD);
+		return;
+	}
+	return;
+}
+
 /*
  * Update all beacons for the system.
  */
@@ -7382,9 +7490,31 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	if (wlc->pub->up && bsscfg->type == BRCMS_TYPE_AP)
+	if (wlc->pub->up && bsscfg->type == BRCMS_TYPE_AP) {
 		/* Clear the soft intmask */
 		wlc->defmacintmask &= ~MI_BCNTPL;
+		if (!wlc->beacon)
+			return;
+		brcms_c_update_beacon_hw(wlc, wlc->beacon,
+					 wlc->beacon_tim_offset,
+					 wlc->beacon_dtim_period);
+	}
+}
+
+void brcms_c_set_new_beacon(struct brcms_c_info *wlc, struct sk_buff *beacon,
+			    u16 tim_offset, u16 dtim_period)
+{
+	if (!beacon)
+		return;
+	if (wlc->beacon)
+		dev_kfree_skb_any(wlc->beacon);
+	wlc->beacon = beacon;
+
+	/* add PLCP */
+	skb_push(wlc->beacon, D11_PHY_HDR_LEN);
+	wlc->beacon_tim_offset = tim_offset;
+	wlc->beacon_dtim_period = dtim_period;
+	brcms_c_update_beacon(wlc);
 }
 
 /* Write ssid into shared memory */
@@ -7782,6 +7912,10 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		brcms_rfkill_set_hw_state(wlc->wl);
 	}
 
+	/* BCN template is available */
+	if (macintstatus & MI_BCNTPL)
+		brcms_c_update_beacon(wlc);
+
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
 
@@ -7913,6 +8047,7 @@ brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
 	pub->unit = unit;
 	pub->_piomode = piomode;
 	wlc->bandinit_pending = false;
+	wlc->beacon_template_virgin = true;
 
 	/* populate struct brcms_c_info with default values  */
 	brcms_c_info_init(wlc, unit);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 397cff3..82382da 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -492,6 +492,8 @@ struct brcms_c_info {
 	bool radio_monitor;
 	bool going_down;
 
+	bool beacon_template_virgin;
+
 	struct brcms_timer *wdtimer;
 	struct brcms_timer *radio_timer;
 
@@ -561,6 +563,10 @@ struct brcms_c_info {
 
 	struct wiphy *wiphy;
 	struct scb pri_scb;
+
+	struct sk_buff *beacon;
+	u16 beacon_tim_offset;
+	u16 beacon_dtim_period;
 };
 
 /* antsel module specific state */
@@ -630,7 +636,6 @@ extern u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 extern void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
-extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
 extern void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
 extern int brcms_c_set_nmode(struct brcms_c_info *wlc);
 extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 9dae59c..8a3071f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -332,5 +332,9 @@ extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern void brcms_c_mute(struct brcms_c_info *wlc, bool on);
 extern bool brcms_c_tx_flush_completed(struct brcms_c_info *wlc);
 extern void brcms_c_start_station(struct brcms_c_info *wlc, u8 *addr);
+extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
+extern void brcms_c_set_new_beacon(struct brcms_c_info *wlc,
+				   struct sk_buff *beacon, u16 tim_offset,
+				   u16 dtim_period);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.10.4

