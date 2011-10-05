Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2288 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab1JENUe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/15] staging: brcm80211: remove locking macro
 definitions
Date: Wed, 5 Oct 2011 15:20:05 +0200
Message-ID: <1317820814-7083-7-git-send-email-arend@broadcom.com> (sfid-20111005_152038_462116_9A8D52C4)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver contained locking macros which map directly to the
lock function provided by the kernel. It does not provide any
additional value so these have been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |  157 ++++++++++------------
 1 files changed, 68 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index ac78052..185a098 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -35,26 +35,6 @@
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
-#define LOCK(wl)	spin_lock_bh(&(wl)->lock)
-#define UNLOCK(wl)	spin_unlock_bh(&(wl)->lock)
-
-/* locking from inside brcms_isr */
-#define ISR_LOCK(wl, flags)\
-	do {\
-		spin_lock(&(wl)->isr_lock);\
-		(void)(flags); } \
-	while (0)
-
-#define ISR_UNLOCK(wl, flags)\
-	do {\
-		spin_unlock(&(wl)->isr_lock);\
-		(void)(flags); } \
-	while (0)
-
-/* locking under LOCK() to synchronize with brcms_isr */
-#define INT_LOCK(wl, flags)	spin_lock_irqsave(&(wl)->isr_lock, flags)
-#define INT_UNLOCK(wl, flags)	spin_unlock_irqrestore(&(wl)->isr_lock, flags)
-
 /* Flags we support */
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | \
@@ -291,7 +271,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct brcms_info *wl = hw->priv;
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	if (!wl->pub->up) {
 		wiphy_err(wl->wiphy, "ops->tx called while down\n");
 		kfree_skb(skb);
@@ -299,7 +279,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
  done:
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_start(struct ieee80211_hw *hw)
@@ -308,9 +288,9 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	bool blocked;
 
 	ieee80211_wake_queues(hw);
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	blocked = brcms_rfkill_set_hw_state(wl);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	if (!blocked)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 
@@ -340,12 +320,12 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	wl = hw->priv;
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	if (!wl->pub->up)
 		err = brcms_up(wl);
 	else
 		err = -ENODEV;
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 
 	if (err != 0)
 		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
@@ -362,9 +342,9 @@ brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	wl = hw->priv;
 
 	/* put driver in down state */
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	brcms_down(wl);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 }
 
 static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
@@ -375,7 +355,7 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 	int new_int;
 	struct wiphy *wiphy = hw->wiphy;
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		brcms_c_set_beacon_listen_interval(wl->wlc,
 						   conf->listen_interval);
@@ -416,7 +396,7 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 					     conf->long_frame_max_tx_count);
 
  config_out:
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	return err;
 }
 
@@ -434,9 +414,9 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		 */
 		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
 			  __func__, info->assoc ? "" : "dis");
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_associate_upd(wl->wlc, info->assoc);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		s8 val;
@@ -446,23 +426,23 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 			val = 1;
 		else
 			val = 0;
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_set_shortslot_override(wl->wlc, val);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 
 	if (changed & BSS_CHANGED_HT) {
 		/* 802.11n parameters changed */
 		u16 mode = info->ht_operation_mode;
 
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
 		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_NONGF,
 			mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_OBSS,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		struct ieee80211_supported_band *bi;
@@ -472,9 +452,9 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		int error;
 
 		/* retrieve the current rates */
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_get_current_rateset(wl->wlc, &rs);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 
 		br_mask = info->basic_rates;
 		bi = hw->wiphy->bands[brcms_c_get_curband(wl->wlc)];
@@ -488,24 +468,24 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		}
 
 		/* update the rate set */
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		error = brcms_c_set_rateset(wl->wlc, &rs);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 		if (error)
 			wiphy_err(wiphy, "changing basic rates failed: %d\n",
 				  error);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_set_beacon_period(wl->wlc, info->beacon_int);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET, info->bssid);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	if (changed & BSS_CHANGED_BEACON)
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
@@ -571,7 +551,7 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 	if (changed_flags & FIF_OTHER_BSS)
 		wiphy_err(wiphy, "FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
 			brcms_c_mac_bcn_promisc_change(wl->wlc, 1);
@@ -579,7 +559,7 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 			brcms_c_mac_bcn_promisc_change(wl->wlc, 0);
 			wl->pub->mac80211_state &= ~MAC80211_PROMISC_BCNS;
 		}
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	return;
 }
@@ -587,18 +567,18 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	brcms_c_scan_start(wl->wlc);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	return;
 }
 
 static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	brcms_c_scan_stop(wl->wlc);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	return;
 }
 
@@ -608,9 +588,9 @@ brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	struct brcms_info *wl = hw->priv;
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	brcms_c_wme_setparams(wl->wlc, queue, params, true);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 
 	return 0;
 }
@@ -661,9 +641,9 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		status = brcms_c_aggregatable(wl->wlc, tid);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 		if (!status) {
 			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
 				  tid);
@@ -673,9 +653,9 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		break;
 
 	case IEEE80211_AMPDU_TX_STOP:
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_ampdu_flush(wl->wlc, sta, tid);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
@@ -685,11 +665,11 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		 * recipient and traffic class. 'ampdu_factor' gives maximum
 		 * AMPDU size.
 		 */
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_c_ampdu_tx_operational(wl->wlc, tid, buf_size,
 			(1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 			 sta->ht_cap.ampdu_factor)) - 1);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 		/* Power save wakeup */
 		break;
 	default:
@@ -705,9 +685,9 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 	struct brcms_info *wl = hw->priv;
 	bool blocked;
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	blocked = brcms_c_check_radio_disabled(wl->wlc);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
@@ -719,9 +699,9 @@ static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 	no_printk("%s: drop = %s\n", __func__, drop ? "true" : "false");
 
 	/* wait for packet queue and dma fifos to run empty */
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	brcms_c_wait_for_tx_completion(wl->wlc, drop);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 }
 
 static const struct ieee80211_ops brcms_ops = {
@@ -756,16 +736,16 @@ void brcms_dpc(unsigned long data)
 
 	wl = (struct brcms_info *) data;
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 
 	/* call the common second level interrupt handler */
 	if (wl->pub->up) {
 		if (wl->resched) {
 			unsigned long flags;
 
-			INT_LOCK(wl, flags);
+			spin_lock_irqsave(&wl->isr_lock, flags);
 			brcms_c_intrsupd(wl->wlc);
-			INT_UNLOCK(wl, flags);
+			spin_unlock_irqrestore(&wl->isr_lock, flags);
 		}
 
 		wl->resched = brcms_c_dpc(wl->wlc, true);
@@ -783,7 +763,7 @@ void brcms_dpc(unsigned long data)
 		brcms_intrson(wl);
 
  done:
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 }
 
 /*
@@ -912,9 +892,9 @@ static void brcms_remove(struct pci_dev *pdev)
 		return;
 	}
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	if (!status) {
 		wiphy_err(wl->wiphy, "wl: brcms_remove: chipmatch "
 				     "failed\n");
@@ -924,9 +904,9 @@ static void brcms_remove(struct pci_dev *pdev)
 		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
-		LOCK(wl);
+		spin_lock_bh(&wl->lock);
 		brcms_down(wl);
-		UNLOCK(wl);
+		spin_unlock_bh(&wl->lock);
 	}
 	pci_disable_device(pdev);
 
@@ -940,11 +920,10 @@ static irqreturn_t brcms_isr(int irq, void *dev_id)
 {
 	struct brcms_info *wl;
 	bool ours, wantdpc;
-	unsigned long flags;
 
 	wl = (struct brcms_info *) dev_id;
 
-	ISR_LOCK(wl, flags);
+	spin_lock(&wl->isr_lock);
 
 	/* call common first level interrupt handler */
 	ours = brcms_c_isr(wl->wlc, &wantdpc);
@@ -958,7 +937,7 @@ static irqreturn_t brcms_isr(int irq, void *dev_id)
 		}
 	}
 
-	ISR_UNLOCK(wl, flags);
+	spin_unlock(&wl->isr_lock);
 
 	return IRQ_RETVAL(ours);
 }
@@ -1226,9 +1205,9 @@ static int brcms_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 
 	/* only need to flag hw is down for proper resume */
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	wl->pub->hw_up = false;
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
@@ -1365,9 +1344,9 @@ void brcms_intrson(struct brcms_info *wl)
 {
 	unsigned long flags;
 
-	INT_LOCK(wl, flags);
+	spin_lock_irqsave(&wl->isr_lock, flags);
 	brcms_c_intrson(wl->wlc);
-	INT_UNLOCK(wl, flags);
+	spin_unlock_irqrestore(&wl->isr_lock, flags);
 }
 
 u32 brcms_intrsoff(struct brcms_info *wl)
@@ -1375,9 +1354,9 @@ u32 brcms_intrsoff(struct brcms_info *wl)
 	unsigned long flags;
 	u32 status;
 
-	INT_LOCK(wl, flags);
+	spin_lock_irqsave(&wl->isr_lock, flags);
 	status = brcms_c_intrsoff(wl->wlc);
-	INT_UNLOCK(wl, flags);
+	spin_unlock_irqrestore(&wl->isr_lock, flags);
 	return status;
 }
 
@@ -1385,9 +1364,9 @@ void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask)
 {
 	unsigned long flags;
 
-	INT_LOCK(wl, flags);
+	spin_lock_irqsave(&wl->isr_lock, flags);
 	brcms_c_intrsrestore(wl->wlc, macintmask);
-	INT_UNLOCK(wl, flags);
+	spin_unlock_irqrestore(&wl->isr_lock, flags);
 }
 
 /*
@@ -1417,14 +1396,14 @@ void brcms_down(struct brcms_info *wl)
 	callbacks = atomic_read(&wl->callbacks) - ret_val;
 
 	/* wait for down callbacks to complete */
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 
 	/* For HIGH_only driver, it's important to actually schedule other work,
 	 * not just spin wait since everything runs at schedule level
 	 */
 	SPINWAIT((atomic_read(&wl->callbacks) > callbacks), 100 * 1000);
 
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 }
 
 /*
@@ -1432,7 +1411,7 @@ void brcms_down(struct brcms_info *wl)
  */
 void brcms_timer(struct brcms_timer *t)
 {
-	LOCK(t->wl);
+	spin_lock_bh(&t->wl->lock);
 
 	if (t->set) {
 		if (t->periodic) {
@@ -1448,7 +1427,7 @@ void brcms_timer(struct brcms_timer *t)
 
 	atomic_dec(&t->wl->callbacks);
 
-	UNLOCK(t->wl);
+	spin_unlock_bh(&t->wl->lock);
 }
 
 /*
@@ -1703,11 +1682,11 @@ bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
 {
 	bool blocked = brcms_c_check_radio_disabled(wl->wlc);
 
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 	if (blocked)
 		wiphy_rfkill_start_polling(wl->pub->ieee_hw->wiphy);
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 	return blocked;
 }
 
@@ -1716,7 +1695,7 @@ bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
  */
 void brcms_msleep(struct brcms_info *wl, uint ms)
 {
-	UNLOCK(wl);
+	spin_unlock_bh(&wl->lock);
 	msleep(ms);
-	LOCK(wl);
+	spin_lock_bh(&wl->lock);
 }
-- 
1.7.4.1


