Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab3CDQoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 11:44:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: pass queue bitmap to flush operation
Date: Mon,  4 Mar 2013 17:43:56 +0100
Message-Id: <1362415437-25564-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_174408_967733_EF5F37D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of situations in which mac80211 only
really needs to flush queues for one virtual interface,
and in fact during this frames might be transmitted on
other virtual interfaces. Calculate and pass a queue
bitmap to the driver so it knows which queues to flush.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c           |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  2 +-
 drivers/net/wireless/ath/carl9170/main.c           |  2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  2 +-
 drivers/net/wireless/iwlegacy/common.c             |  3 +--
 drivers/net/wireless/iwlegacy/common.h             |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  2 +-
 drivers/net/wireless/mac80211_hwsim.c              |  2 +-
 drivers/net/wireless/p54/main.c                    |  2 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |  2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  2 +-
 drivers/net/wireless/rtlwifi/core.c                |  2 +-
 drivers/net/wireless/ti/wlcore/main.c              |  2 +-
 include/net/mac80211.h                             |  9 +++++---
 net/mac80211/driver-ops.h                          |  7 +++---
 net/mac80211/ieee80211_i.h                         |  2 ++
 net/mac80211/iface.c                               |  2 +-
 net/mac80211/mlme.c                                |  8 +++----
 net/mac80211/offchannel.c                          |  4 ++--
 net/mac80211/pm.c                                  |  2 +-
 net/mac80211/scan.c                                |  4 ++--
 net/mac80211/trace.h                               | 11 ++++++----
 net/mac80211/util.c                                | 25 ++++++++++++++++++++++
 23 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 7157f7d..afd1e36 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1091,7 +1091,7 @@ static int ar5523_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static void ar5523_flush(struct ieee80211_hw *hw, bool drop)
+static void ar5523_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct ar5523 *ar = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5432f12..a5e1f8c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1748,7 +1748,7 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
-static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
+static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f293b3f..08b1931 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1703,7 +1703,7 @@ found:
 	return 0;
 }
 
-static void carl9170_op_flush(struct ieee80211_hw *hw, bool drop)
+static void carl9170_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct ar9170 *ar = hw->priv;
 	unsigned int vid;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index b1dd560..7090f92 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -712,7 +712,7 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
 
-static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
+static void brcms_ops_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct brcms_info *wl = hw->priv;
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 4c9aafb..3a76ca8 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4698,8 +4698,7 @@ out:
 }
 EXPORT_SYMBOL(il_mac_change_interface);
 
-void
-il_mac_flush(struct ieee80211_hw *hw, bool drop)
+void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct il_priv *il = hw->priv;
 	unsigned long timeout = jiffies + msecs_to_jiffies(500);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 73bd3ef..728aa13 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1720,7 +1720,7 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum nl80211_iftype newtype, bool newp2p);
-void il_mac_flush(struct ieee80211_hw *hw, bool drop);
+void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 int il_alloc_txq_mem(struct il_priv *il);
 void il_free_txq_mem(struct il_priv *il);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index de5cafd..df2634c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -997,7 +997,7 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
+static void iwlagn_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7490c4f..3466f1a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1389,7 +1389,7 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
+static void mac80211_hwsim_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	/* Not implemented, queues only on kernel side */
 }
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index aadda99..ee654a6 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -670,7 +670,7 @@ static unsigned int p54_flush_count(struct p54_common *priv)
 	return total;
 }
 
-static void p54_flush(struct ieee80211_hw *dev, bool drop)
+static void p54_flush(struct ieee80211_hw *dev, u32 queues, bool drop)
 {
 	struct p54_common *priv = dev->priv;
 	unsigned int total, i;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9a3f31a..cf385e6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1358,7 +1358,7 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_vif *vif, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
-void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop);
+void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
 int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 int rt2x00mac_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 20c6ecc..9161c02 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -748,7 +748,7 @@ void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
 
-void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
+void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index d3ce9fb..b5a7a26 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1166,7 +1166,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
  * before switch channle or power save, or tx buffer packet
  * maybe send after offchannel or rf sleep, this may cause
  * dis-association by AP */
-static void rtl_op_flush(struct ieee80211_hw *hw, bool drop)
+static void rtl_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d7e3063..a9f7041 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4946,7 +4946,7 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
+static void wlcore_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 {
 	struct wl1271 *wl = hw->priv;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cdd7cea..17707c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2440,8 +2440,11 @@ enum ieee80211_roc_type {
  * @testmode_dump: Implement a cfg80211 test mode dump. The callback can sleep.
  *
  * @flush: Flush all pending frames from the hardware queue, making sure
- *	that the hardware queues are empty. If the parameter @drop is set
- *	to %true, pending frames may be dropped. The callback can sleep.
+ *	that the hardware queues are empty. The @queues parameter is a bitmap
+ *	of queues to flush, which is useful if different virtual interfaces
+ *	use different hardware queues; it may also indicate all queues.
+ *	If the parameter @drop is set to %true, pending frames may be dropped.
+ *	The callback can sleep.
  *
  * @channel_switch: Drivers that need (or want) to offload the channel
  *	switch operation for CSAs received from the AP may implement this
@@ -2691,7 +2694,7 @@ struct ieee80211_ops {
 			     struct netlink_callback *cb,
 			     void *data, int len);
 #endif
-	void (*flush)(struct ieee80211_hw *hw, bool drop);
+	void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 832acea..33f99b9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -741,13 +741,14 @@ static inline void drv_rfkill_poll(struct ieee80211_local *local)
 		local->ops->rfkill_poll(&local->hw);
 }
 
-static inline void drv_flush(struct ieee80211_local *local, bool drop)
+static inline void drv_flush(struct ieee80211_local *local,
+			     u32 queues, bool drop)
 {
 	might_sleep();
 
-	trace_drv_flush(local, drop);
+	trace_drv_flush(local, queues, drop);
 	if (local->ops->flush)
-		local->ops->flush(&local->hw, drop);
+		local->ops->flush(&local->hw, queues, drop);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d080a13..b80349d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1542,6 +1542,8 @@ static inline void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 {
 	ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
 }
+void ieee80211_flush_queues(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2d39221..441d93a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -92,7 +92,7 @@ static u32 ieee80211_idle_on(struct ieee80211_local *local)
 	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
 		return 0;
 
-	drv_flush(local, false);
+	ieee80211_flush_queues(local, NULL);
 
 	local->hw.conf.flags |= IEEE80211_CONF_IDLE;
 	return IEEE80211_CONF_CHANGE_IDLE;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8c3af06..ab695f3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1432,7 +1432,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		else {
 			ieee80211_send_nullfunc(local, sdata, 1);
 			/* Flush to get the tx status of nullfunc frame */
-			drv_flush(local, false);
+			ieee80211_flush_queues(local, sdata);
 		}
 	}
 
@@ -1763,7 +1763,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	/* flush out any pending frame (e.g. DELBA) before deauth/disassoc */
 	if (tx)
-		drv_flush(local, false);
+		ieee80211_flush_queues(local, sdata);
 
 	/* deauthenticate/disassociate now */
 	if (tx || frame_buf)
@@ -1772,7 +1772,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	/* flush out frame */
 	if (tx)
-		drv_flush(local, false);
+		ieee80211_flush_queues(local, sdata);
 
 	/* clear bssid only after building the needed mgmt frames */
 	memset(ifmgd->bssid, 0, ETH_ALEN);
@@ -1944,7 +1944,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		drv_flush(sdata->local, false);
+		ieee80211_flush_queues(sdata->local, sdata);
 }
 
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index db547fc..d32f514 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -120,7 +120,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	 */
 	ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
-	drv_flush(local, false);
+	ieee80211_flush_queues(local, NULL);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -373,7 +373,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		ieee80211_roc_notify_destroy(roc);
 
 		if (started) {
-			drv_flush(local, false);
+			ieee80211_flush_queues(local, NULL);
 
 			local->tmp_channel = NULL;
 			ieee80211_hw_config(local, 0);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index b471a67..497f21a 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -35,7 +35,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* flush out all packets */
 	synchronize_net();
 
-	drv_flush(local, false);
+	ieee80211_flush_queues(local, NULL);
 
 	local->quiescing = true;
 	/* make quiescing visible to timers everywhere */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 43a45cf..7c156e2 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -335,7 +335,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	ieee80211_offchannel_stop_vifs(local);
 
 	/* ensure nullfunc is transmitted before leaving operating channel */
-	drv_flush(local, false);
+	ieee80211_flush_queues(local, NULL);
 
 	ieee80211_configure_filter(local);
 
@@ -671,7 +671,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
-		drv_flush(local, false);
+		ieee80211_flush_queues(local, NULL);
 		*next_delay = 0;
 	} else
 		*next_delay = HZ / 10;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e7db2b8..f18f32b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -940,23 +940,26 @@ TRACE_EVENT(drv_get_survey,
 );
 
 TRACE_EVENT(drv_flush,
-	TP_PROTO(struct ieee80211_local *local, bool drop),
+	TP_PROTO(struct ieee80211_local *local,
+		 u32 queues, bool drop),
 
-	TP_ARGS(local, drop),
+	TP_ARGS(local, queues, drop),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(bool, drop)
+		__field(u32, queues)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->drop = drop;
+		__entry->queues = queues;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " drop:%d",
-		LOCAL_PR_ARG, __entry->drop
+		LOCAL_PR_FMT " queues:0x%x drop:%d",
+		LOCAL_PR_ARG, __entry->queues, __entry->drop
 	)
 );
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d8eea76..b6baed9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -511,6 +511,31 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
+void ieee80211_flush_queues(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata)
+{
+	u32 queues;
+
+	if (!local->ops->flush)
+		return;
+
+	if (sdata && local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
+		int ac;
+
+		queues = 0;
+
+		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+			queues |= BIT(sdata->vif.hw_queue[ac]);
+		if (sdata->vif.cab_queue != IEEE80211_INVAL_HW_QUEUE)
+			queues |= BIT(sdata->vif.cab_queue);
+	} else {
+		/* all queues */
+		queues = BIT(local->hw.queues) - 1;
+	}
+
+	drv_flush(local, queues, false);
+}
+
 void ieee80211_iterate_active_interfaces(
 	struct ieee80211_hw *hw, u32 iter_flags,
 	void (*iterator)(void *data, u8 *mac,
-- 
1.8.0

