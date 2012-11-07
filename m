Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2KGNYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:24:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: clarify interface iteration and make it configurable
Date: Wed,  7 Nov 2012 14:24:43 +0100
Message-Id: <1352294684-19266-3-git-send-email-johannes@sipsolutions.net> (sfid-20121107_142422_515497_2D21FBCC)
In-Reply-To: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
References: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During hardware restart, all interfaces are iterated even
though they haven't been re-added to the driver, document
this behaviour. The same also happens during resume, which
is even more confusing since all of the interfaces were
previously removed from the driver. Make this optional so
drivers relying on the current behaviour can still use it,
but to let drivers that don't want this behaviour disable
it.

Also convert all API users, keeping the old semantics
except in hwsim, where the new normal ones are desired.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/base.c           | 10 ++++++----
 drivers/net/wireless/ath/ath5k/mac80211-ops.c   |  5 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  6 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 20 ++++++++++++--------
 drivers/net/wireless/ath/ath9k/main.c           | 15 +++++++++------
 drivers/net/wireless/mac80211_hwsim.c           | 11 ++++++++---
 drivers/net/wireless/rt2x00/rt2x00dev.c         | 19 ++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00mac.c         |  6 +++---
 drivers/net/wireless/ti/wlcore/main.c           |  2 +-
 include/net/mac80211.h                          | 23 +++++++++++++++++++++--
 net/mac80211/util.c                             | 18 ++++++++++++++----
 11 files changed, 90 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9f31cfa..cdd1923 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -511,8 +511,9 @@ ath5k_update_bssid_mask_and_opmode(struct ath5k_hw *ah,
 		ath5k_vif_iter(&iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
-						   &iter_data);
+	ieee80211_iterate_active_interfaces_atomic(
+		ah->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath5k_vif_iter, &iter_data);
 	memcpy(ah->bssidmask, iter_data.mask, ETH_ALEN);
 
 	ah->opmode = iter_data.opmode;
@@ -3045,8 +3046,9 @@ ath5k_any_vif_assoc(struct ath5k_hw *ah)
 	iter_data.need_set_hw_addr = false;
 	iter_data.found_active = true;
 
-	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
-						   &iter_data);
+	ieee80211_iterate_active_interfaces_atomic(
+		ah->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath5k_vif_iter, &iter_data);
 	return iter_data.any_assoc;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 7a28538..1ea8c87 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -452,8 +452,9 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	iter_data.hw_macaddr = NULL;
 	iter_data.n_stas = 0;
 	iter_data.need_set_hw_addr = false;
-	ieee80211_iterate_active_interfaces_atomic(ah->hw, ath5k_vif_iter,
-						   &iter_data);
+	ieee80211_iterate_active_interfaces_atomic(
+		ah->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath5k_vif_iter, &iter_data);
 
 	/* Set up RX Filter */
 	if (iter_data.n_stas > 1) {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index f42d2eb..1318d79 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -587,9 +587,9 @@ static bool ath9k_htc_check_beacon_config(struct ath9k_htc_priv *priv,
 	    (priv->num_sta_vif > 1) &&
 	    (vif->type == NL80211_IFTYPE_STATION)) {
 		beacon_configured = false;
-		ieee80211_iterate_active_interfaces_atomic(priv->hw,
-							   ath9k_htc_beacon_iter,
-							   &beacon_configured);
+		ieee80211_iterate_active_interfaces_atomic(
+			priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+			ath9k_htc_beacon_iter, &beacon_configured);
 
 		if (beacon_configured) {
 			ath_dbg(common, CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 66f6a74..02cce95 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -127,8 +127,9 @@ static void ath9k_htc_vif_reconfig(struct ath9k_htc_priv *priv)
 	priv->rearm_ani = false;
 	priv->reconfig_beacon = false;
 
-	ieee80211_iterate_active_interfaces_atomic(priv->hw,
-						   ath9k_htc_vif_iter, priv);
+	ieee80211_iterate_active_interfaces_atomic(
+		priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath9k_htc_vif_iter, priv);
 	if (priv->rearm_ani)
 		ath9k_htc_start_ani(priv);
 
@@ -165,8 +166,9 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
 		ath9k_htc_bssid_iter(&iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(priv->hw, ath9k_htc_bssid_iter,
-						   &iter_data);
+	ieee80211_iterate_active_interfaces_atomic(
+		priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath9k_htc_bssid_iter, &iter_data);
 
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
@@ -1144,8 +1146,9 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	 */
 	if ((vif->type == NL80211_IFTYPE_AP) && (priv->num_ap_vif == 0)) {
 		priv->rearm_ani = false;
-		ieee80211_iterate_active_interfaces_atomic(priv->hw,
-						   ath9k_htc_vif_iter, priv);
+		ieee80211_iterate_active_interfaces_atomic(
+			priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+			ath9k_htc_vif_iter, priv);
 		if (!priv->rearm_ani)
 			ath9k_htc_stop_ani(priv);
 	}
@@ -1466,8 +1469,9 @@ static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 static void ath9k_htc_choose_set_bssid(struct ath9k_htc_priv *priv)
 {
 	if (priv->num_sta_assoc_vif == 1) {
-		ieee80211_iterate_active_interfaces_atomic(priv->hw,
-							   ath9k_htc_bss_iter, priv);
+		ieee80211_iterate_active_interfaces_atomic(
+			priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+			ath9k_htc_bss_iter, priv);
 		ath9k_htc_set_bssid(priv);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 578a723..c084532 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -924,8 +924,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 		ath9k_vif_iter(iter_data, vif->addr, vif);
 
 	/* Get list of all active MAC addresses */
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
-						   iter_data);
+	ieee80211_iterate_active_interfaces_atomic(
+		sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		ath9k_vif_iter, iter_data);
 }
 
 /* Called with sc->mutex held. */
@@ -975,8 +976,9 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	if (ah->opmode == NL80211_IFTYPE_STATION &&
 	    old_opmode == NL80211_IFTYPE_AP &&
 	    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
-		ieee80211_iterate_active_interfaces_atomic(sc->hw,
-						   ath9k_sta_vif_iter, sc);
+		ieee80211_iterate_active_interfaces_atomic(
+			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+			ath9k_sta_vif_iter, sc);
 	}
 }
 
@@ -1505,8 +1507,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
 		}
 
-		ieee80211_iterate_active_interfaces_atomic(sc->hw,
-						   ath9k_bss_assoc_iter, sc);
+		ieee80211_iterate_active_interfaces_atomic(
+			sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+			ath9k_bss_assoc_iter, sc);
 
 		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags) &&
 		    ah->opmode == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9b4f767..a8ec708 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -571,6 +571,7 @@ static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
 	md.ret = false;
 	md.addr = addr;
 	ieee80211_iterate_active_interfaces_atomic(data->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
 						   mac80211_hwsim_addr_iter,
 						   &md);
 
@@ -744,8 +745,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		if (!hwsim_chans_compat(chan, data2->tmp_chan) &&
 		    !hwsim_chans_compat(chan, data2->channel)) {
 			ieee80211_iterate_active_interfaces_atomic(
-				data2->hw, mac80211_hwsim_tx_iter,
-				&tx_iter_data);
+				data2->hw, IEEE80211_IFACE_ITER_NORMAL,
+				mac80211_hwsim_tx_iter, &tx_iter_data);
 			if (!tx_iter_data.receive)
 				continue;
 		}
@@ -958,7 +959,8 @@ static void mac80211_hwsim_beacon(unsigned long arg)
 		return;
 
 	ieee80211_iterate_active_interfaces_atomic(
-		hw, mac80211_hwsim_beacon_tx, hw);
+		hw, IEEE80211_IFACE_ITER_NORMAL,
+		mac80211_hwsim_beacon_tx, hw);
 
 	data->beacon_timer.expires = jiffies + data->beacon_int;
 	add_timer(&data->beacon_timer);
@@ -1680,14 +1682,17 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 
 	if (val == PS_MANUAL_POLL) {
 		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
 						    hwsim_send_ps_poll, data);
 		data->ps_poll_pending = true;
 	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
 		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
 						    hwsim_send_nullfunc_ps,
 						    data);
 	} else if (old_ps != PS_DISABLED && val == PS_DISABLED) {
 		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
 						    hwsim_send_nullfunc_no_ps,
 						    data);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 69097d1..67d1679 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -157,6 +157,7 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 	 * requested configurations.
 	 */
 	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
+					    IEEE80211_IFACE_ITER_RESUME_ALL,
 					    rt2x00lib_intf_scheduled_iter,
 					    rt2x00dev);
 }
@@ -225,9 +226,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* send buffered bc/mc frames out for every bssid */
-	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
-						   rt2x00lib_bc_buffer_iter,
-						   rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(
+		rt2x00dev->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		rt2x00lib_bc_buffer_iter, rt2x00dev);
 	/*
 	 * Devices with pre tbtt interrupt don't need to update the beacon
 	 * here as they will fetch the next beacon directly prior to
@@ -237,9 +238,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* fetch next beacon */
-	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
-						   rt2x00lib_beaconupdate_iter,
-						   rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(
+		rt2x00dev->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		rt2x00lib_beaconupdate_iter, rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
@@ -249,9 +250,9 @@ void rt2x00lib_pretbtt(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/* fetch next beacon */
-	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
-						   rt2x00lib_beaconupdate_iter,
-						   rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(
+		rt2x00dev->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		rt2x00lib_beaconupdate_iter, rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_pretbtt);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 98a9e48..ed7a1bb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -424,9 +424,9 @@ int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return 0;
 
-	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
-						   rt2x00mac_set_tim_iter,
-						   rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(
+		rt2x00dev->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		rt2x00mac_set_tim_iter, rt2x00dev);
 
 	/* queue work to upodate the beacon template */
 	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->intf_work);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 25530c8..380cf1f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -677,7 +677,7 @@ static void wl12xx_get_vif_count(struct ieee80211_hw *hw,
 	memset(data, 0, sizeof(*data));
 	data->cur_vif = cur_vif;
 
-	ieee80211_iterate_active_interfaces(hw,
+	ieee80211_iterate_active_interfaces(hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 					    wl12xx_vif_count_iter, data);
 }
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e1d8309..a789dd1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3413,6 +3413,21 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw);
 void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw);
 
 /**
+ * enum ieee80211_interface_iteration_flags - interface iteration flags
+ * @IEEE80211_IFACE_ITER_NORMAL: Iterate over all interfaces that have
+ *	been added to the driver; However, note that during hardware
+ *	reconfiguration (after restart_hw) it will iterate over a new
+ *	interface and over all the existing interfaces even if they
+ *	haven't been re-added to the driver yet.
+ * @IEEE80211_IFACE_ITER_RESUME_ALL: During resume, iterate over all
+ *	interfaces, even if they haven't been re-added to the driver yet.
+ */
+enum ieee80211_interface_iteration_flags {
+	IEEE80211_IFACE_ITER_NORMAL	= 0,
+	IEEE80211_IFACE_ITER_RESUME_ALL	= BIT(0),
+};
+
+/**
  * ieee80211_iterate_active_interfaces - iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
@@ -3420,13 +3435,15 @@ void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw);
  * This function allows the iterator function to sleep, when the iterator
  * function is atomic @ieee80211_iterate_active_interfaces_atomic can
  * be used.
- * Does not iterate over a new interface during add_interface()
+ * Does not iterate over a new interface during add_interface().
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
  * @iterator: the iterator function to call
  * @data: first argument of the iterator function
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
+					 u32 iter_flags,
 					 void (*iterator)(void *data, u8 *mac,
 						struct ieee80211_vif *vif),
 					 void *data);
@@ -3438,13 +3455,15 @@ void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
  * hardware that are currently active and calls the callback for them.
  * This function requires the iterator callback function to be atomic,
  * if that is not desired, use @ieee80211_iterate_active_interfaces instead.
- * Does not iterate over a new interface during add_interface()
+ * Does not iterate over a new interface during add_interface().
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
  * @iterator: the iterator function to call, cannot sleep
  * @data: first argument of the iterator function
  */
 void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
+						u32 iter_flags,
 						void (*iterator)(void *data,
 						    u8 *mac,
 						    struct ieee80211_vif *vif),
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce6a233..690e474 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -512,7 +512,7 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
 void ieee80211_iterate_active_interfaces(
-	struct ieee80211_hw *hw,
+	struct ieee80211_hw *hw, u32 iter_flags,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
@@ -530,6 +530,9 @@ void ieee80211_iterate_active_interfaces(
 		default:
 			break;
 		}
+		if (!(iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL) &&
+		    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+			continue;
 		if (ieee80211_sdata_running(sdata))
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
@@ -537,7 +540,9 @@ void ieee80211_iterate_active_interfaces(
 
 	sdata = rcu_dereference_protected(local->monitor_sdata,
 					  lockdep_is_held(&local->iflist_mtx));
-	if (sdata)
+	if (sdata &&
+	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL ||
+	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		iterator(data, sdata->vif.addr, &sdata->vif);
 
 	mutex_unlock(&local->iflist_mtx);
@@ -545,7 +550,7 @@ void ieee80211_iterate_active_interfaces(
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
 
 void ieee80211_iterate_active_interfaces_atomic(
-	struct ieee80211_hw *hw,
+	struct ieee80211_hw *hw, u32 iter_flags,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
@@ -563,13 +568,18 @@ void ieee80211_iterate_active_interfaces_atomic(
 		default:
 			break;
 		}
+		if (!(iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL) &&
+		    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+			continue;
 		if (ieee80211_sdata_running(sdata))
 			iterator(data, sdata->vif.addr,
 				 &sdata->vif);
 	}
 
 	sdata = rcu_dereference(local->monitor_sdata);
-	if (sdata)
+	if (sdata &&
+	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL ||
+	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		iterator(data, sdata->vif.addr, &sdata->vif);
 
 	rcu_read_unlock();
-- 
1.8.0

