Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZHQOQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 10:16:59 -0400
Subject: [PATCH] mac80211: allow configure_filter callback to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 16:16:53 +0200
Message-Id: <1250518613.15103.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Over time, a whole bunch of drivers have come up
with their own scheme to delay the configure_filter
operation to a workqueue. To be able to simplify
things, allow configure_filter to sleep, and add
a new prepare_multicast callback that drivers that
need the multicast address list implement. This new
callback must be atomic, but most drivers either
don't care or just calculate a hash which can be
done atomically and then uploaded to the hardware
non-atomically.

A cursory look suggests that at76c50x-usb, ar9170,
mwl8k (which is actually very broken now), rt2x00,
wl1251, wl1271 and zd1211 should make use of this
new capability.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c             |   42 ++++++++++++-------
 drivers/net/wireless/at76c50x-usb.c        |    7 +--
 drivers/net/wireless/ath/ar9170/main.c     |   43 +++++++++++--------
 drivers/net/wireless/ath/ath5k/base.c      |   64 +++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/main.c      |    3 -
 drivers/net/wireless/b43/main.c            |    2 
 drivers/net/wireless/b43legacy/main.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 
 drivers/net/wireless/iwlwifi/iwl-core.h    |    3 -
 drivers/net/wireless/libertas_tf/main.c    |   37 +++++++++++-----
 drivers/net/wireless/mac80211_hwsim.c      |    4 -
 drivers/net/wireless/mwl8k.c               |   34 ++++++++++++---
 drivers/net/wireless/p54/main.c            |    2 
 drivers/net/wireless/rt2x00/rt2x00.h       |    2 
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    2 
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   11 ++++
 drivers/net/wireless/wl12xx/wl1251_main.c  |    4 -
 drivers/net/wireless/wl12xx/wl1271_main.c  |    4 -
 drivers/net/wireless/zd1211rw/zd_mac.c     |   44 +++++++++++++------
 include/net/mac80211.h                     |   21 ++++++---
 net/mac80211/driver-ops.h                  |   24 +++++++++-
 net/mac80211/driver-trace.h                |   36 +++++++++++++---
 net/mac80211/ieee80211_i.h                 |    3 +
 net/mac80211/iface.c                       |   15 +-----
 net/mac80211/main.c                        |   24 ++++++++--
 net/mac80211/scan.c                        |   16 -------
 net/mac80211/util.c                        |    2 
 28 files changed, 297 insertions(+), 169 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-08-17 15:13:13.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-08-17 15:50:50.000000000 +0200
@@ -1219,10 +1219,13 @@ ieee80211_get_alt_retry_rate(const struc
  * the driver's configure_filter() function which frames should be
  * passed to mac80211 and which should be filtered out.
  *
- * The configure_filter() callback is invoked with the parameters
- * @mc_count and @mc_list for the combined multicast address list
- * of all virtual interfaces, @changed_flags telling which flags
- * were changed and @total_flags with the new flag states.
+ * Before configure_filter() is invoked, the prepare_multicast()
+ * callback is invoked with the parameters @mc_count and @mc_list
+ * for the combined multicast address list of all virtual interfaces.
+ * It's use is optional, and it returns a u64 that is passed to
+ * configure_filter(). Additionally, configure_filter() has the
+ * arguments @changed_flags telling which flags were changed and
+ * @total_flags with the new flag states.
  *
  * If your device has no multicast address filters your driver will
  * need to check both the %FIF_ALLMULTI flag and the @mc_count
@@ -1375,9 +1378,13 @@ enum ieee80211_ampdu_mlme_action {
  *	for association indication. The @changed parameter indicates which
  *	of the bss parameters has changed when a call is made.
  *
+ * @prepare_multicast: Prepare for multicast filter configuration.
+ *	This callback is optional, and its return value is passed
+ *	to configure_filter(). This callback must be atomic.
+ *
  * @configure_filter: Configure the device's RX filter.
  *	See the section "Frame filtering" for more information.
- *	This callback must be implemented and atomic.
+ *	This callback must be implemented.
  *
  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
  * 	must be set or cleared for a given STA. Must be atomic.
@@ -1479,10 +1486,12 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
+				 int mc_count, struct dev_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
-				 int mc_count, struct dev_addr_list *mc_list);
+				 u64 multicast);
 	int (*set_tim)(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		       bool set);
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2009-08-17 15:53:56.000000000 +0200
@@ -55,16 +55,32 @@ static inline void drv_bss_info_changed(
 	trace_drv_bss_info_changed(local, vif, info, changed);
 }
 
+static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
+					int mc_count,
+					struct dev_addr_list *mc_list)
+{
+	u64 ret = 0;
+
+	if (local->ops->prepare_multicast)
+		ret = local->ops->prepare_multicast(&local->hw, mc_count,
+						    mc_list);
+
+	trace_drv_prepare_multicast(local, mc_count, ret);
+
+	return ret;
+}
+
 static inline void drv_configure_filter(struct ieee80211_local *local,
 					unsigned int changed_flags,
 					unsigned int *total_flags,
-					int mc_count,
-					struct dev_addr_list *mc_list)
+					u64 multicast)
 {
+	might_sleep();
+
 	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
-				     mc_count, mc_list);
+				     multicast);
 	trace_drv_configure_filter(local, changed_flags, total_flags,
-					    mc_count);
+				   multicast);
 }
 
 static inline int drv_set_tim(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2009-08-17 15:13:18.000000000 +0200
@@ -191,31 +191,55 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
+TRACE_EVENT(drv_prepare_multicast,
+	TP_PROTO(struct ieee80211_local *local, int mc_count, u64 ret),
+
+	TP_ARGS(local, mc_count, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, mc_count)
+		__field(u64, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->mc_count = mc_count;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " prepare mc (%d): %llx",
+		LOCAL_PR_ARG, __entry->mc_count,
+		(unsigned long long) __entry->ret
+	)
+);
+
 TRACE_EVENT(drv_configure_filter,
 	TP_PROTO(struct ieee80211_local *local,
 		 unsigned int changed_flags,
 		 unsigned int *total_flags,
-		 int mc_count),
+		 u64 multicast),
 
-	TP_ARGS(local, changed_flags, total_flags, mc_count),
+	TP_ARGS(local, changed_flags, total_flags, multicast),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		__field(unsigned int, changed)
 		__field(unsigned int, total)
-		__field(int, mc)
+		__field(u64, multicast)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		__entry->changed = changed_flags;
 		__entry->total = *total_flags;
-		__entry->mc = mc_count;
+		__entry->multicast = multicast;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " changed:%#x total:%#x mc:%d",
-		LOCAL_PR_ARG, __entry->changed, __entry->total, __entry->mc
+		LOCAL_PR_FMT " changed:%#x total:%#x",
+		LOCAL_PR_ARG, __entry->changed, __entry->total
 	)
 );
 
--- wireless-testing.orig/net/mac80211/iface.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-08-17 15:13:18.000000000 +0200
@@ -227,9 +227,7 @@ static int ieee80211_open(struct net_dev
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss++;
 
-		spin_lock_bh(&local->filter_lock);
 		ieee80211_configure_filter(local);
-		spin_unlock_bh(&local->filter_lock);
 		break;
 	default:
 		conf.vif = &sdata->vif;
@@ -241,17 +239,13 @@ static int ieee80211_open(struct net_dev
 
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
 			local->fif_other_bss++;
-			spin_lock_bh(&local->filter_lock);
 			ieee80211_configure_filter(local);
-			spin_unlock_bh(&local->filter_lock);
 
 			ieee80211_start_mesh(sdata);
 		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
 
-			spin_lock_bh(&local->filter_lock);
 			ieee80211_configure_filter(local);
-			spin_unlock_bh(&local->filter_lock);
 		}
 
 		changed |= ieee80211_reset_erp_info(sdata);
@@ -404,10 +398,11 @@ static int ieee80211_stop(struct net_dev
 	spin_lock_bh(&local->filter_lock);
 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
 			  &dev->mc_list, &dev->mc_count);
-	ieee80211_configure_filter(local);
 	spin_unlock_bh(&local->filter_lock);
 	netif_addr_unlock_bh(dev);
 
+	ieee80211_configure_filter(local);
+
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
@@ -458,9 +453,7 @@ static int ieee80211_stop(struct net_dev
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss--;
 
-		spin_lock_bh(&local->filter_lock);
 		ieee80211_configure_filter(local);
-		spin_unlock_bh(&local->filter_lock);
 		break;
 	case NL80211_IFTYPE_STATION:
 		del_timer_sync(&sdata->u.mgd.chswitch_timer);
@@ -503,9 +496,7 @@ static int ieee80211_stop(struct net_dev
 			local->fif_other_bss--;
 			atomic_dec(&local->iff_allmultis);
 
-			spin_lock_bh(&local->filter_lock);
 			ieee80211_configure_filter(local);
-			spin_unlock_bh(&local->filter_lock);
 
 			ieee80211_stop_mesh(sdata);
 		}
@@ -622,8 +613,8 @@ static void ieee80211_set_multicast_list
 	spin_lock_bh(&local->filter_lock);
 	__dev_addr_sync(&local->mc_list, &local->mc_count,
 			&dev->mc_list, &dev->mc_count);
-	ieee80211_configure_filter(local);
 	spin_unlock_bh(&local->filter_lock);
+	ieee80211_queue_work(&local->hw, &local->reconfig_filter);
 }
 
 /*
--- wireless-testing.orig/net/mac80211/main.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-08-17 16:13:09.000000000 +0200
@@ -50,9 +50,9 @@ struct ieee80211_tx_status_rtap_hdr {
 } __attribute__ ((packed));
 
 
-/* must be called under mdev tx lock */
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
+	u64 mc;
 	unsigned int changed_flags;
 	unsigned int new_flags = 0;
 
@@ -62,7 +62,7 @@ void ieee80211_configure_filter(struct i
 	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;
 
-	if (local->monitors)
+	if (local->monitors || local->scanning)
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;
 
 	if (local->fif_fcsfail)
@@ -80,20 +80,30 @@ void ieee80211_configure_filter(struct i
 	if (local->fif_pspoll)
 		new_flags |= FIF_PSPOLL;
 
+	spin_lock_bh(&local->filter_lock);
 	changed_flags = local->filter_flags ^ new_flags;
 
+	mc = drv_prepare_multicast(local, local->mc_count, local->mc_list);
+	spin_unlock_bh(&local->filter_lock);
+
 	/* be a bit nasty */
 	new_flags |= (1<<31);
 
-	drv_configure_filter(local, changed_flags, &new_flags,
-			     local->mc_count,
-			     local->mc_list);
+	drv_configure_filter(local, changed_flags, &new_flags, mc);
 
 	WARN_ON(new_flags & (1<<31));
 
 	local->filter_flags = new_flags & ~(1<<31);
 }
 
+static void ieee80211_reconfig_filter(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, reconfig_filter);
+
+	ieee80211_configure_filter(local);
+}
+
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan, *scan_chan;
@@ -692,6 +702,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_WORK(&local->restart_work, ieee80211_restart_work);
 
+	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
+
 	INIT_WORK(&local->dynamic_ps_enable_work,
 		  ieee80211_dynamic_ps_enable_work);
 	INIT_WORK(&local->dynamic_ps_disable_work,
@@ -946,6 +958,8 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
+	cancel_work_sync(&local->reconfig_filter);
+
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
--- wireless-testing.orig/net/mac80211/scan.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-08-17 15:13:18.000000000 +0200
@@ -292,13 +292,7 @@ void ieee80211_scan_completed(struct iee
 	if (was_hw_scan)
 		goto done;
 
-	spin_lock_bh(&local->filter_lock);
-	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
-	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
-			     &local->filter_flags,
-			     local->mc_count,
-			     local->mc_list);
-	spin_unlock_bh(&local->filter_lock);
+	ieee80211_configure_filter(local);
 
 	drv_sw_scan_complete(local);
 
@@ -376,13 +370,7 @@ static int ieee80211_start_sw_scan(struc
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	spin_lock_bh(&local->filter_lock);
-	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-	drv_configure_filter(local, FIF_BCN_PRBRESP_PROMISC,
-			     &local->filter_flags,
-			     local->mc_count,
-			     local->mc_list);
-	spin_unlock_bh(&local->filter_lock);
+	ieee80211_configure_filter(local);
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	ieee80211_queue_delayed_work(&local->hw,
--- wireless-testing.orig/net/mac80211/util.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-08-17 15:13:18.000000000 +0200
@@ -1076,9 +1076,7 @@ int ieee80211_reconfig(struct ieee80211_
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
-	spin_lock_bh(&local->filter_lock);
 	ieee80211_configure_filter(local);
-	spin_unlock_bh(&local->filter_lock);
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-17 15:13:18.000000000 +0200
@@ -636,6 +636,9 @@ struct ieee80211_local {
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
+	/* used for uploading changed mc list */
+	struct work_struct reconfig_filter;
+
 	/* aggregated multicast list */
 	struct dev_addr_list *mc_list;
 	int mc_count;
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-08-17 15:50:50.000000000 +0200
@@ -1997,15 +1997,14 @@ static void at76_bss_info_changed(struct
 /* must be atomic */
 static void at76_configure_filter(struct ieee80211_hw *hw,
 				  unsigned int changed_flags,
-				  unsigned int *total_flags, int mc_count,
-				  struct dev_addr_list *mc_list)
+				  unsigned int *total_flags, u64 multicast)
 {
 	struct at76_priv *priv = hw->priv;
 	int flags;
 
 	at76_dbg(DBG_MAC80211, "%s(): changed_flags=0x%08x "
-		 "total_flags=0x%08x mc_count=%d",
-		 __func__, changed_flags, *total_flags, mc_count);
+		 "total_flags=0x%08x",
+		 __func__, changed_flags, *total_flags);
 
 	flags = changed_flags & AT76_SUPPORTED_FILTERS;
 	*total_flags = AT76_SUPPORTED_FILTERS;
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-08-17 15:13:18.000000000 +0200
@@ -3646,7 +3646,7 @@ out_unlock:
 
 static void b43_op_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed, unsigned int *fflags,
-				    int mc_count, struct dev_addr_list *mc_list)
+				    u64 multicast)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-08-17 15:13:18.000000000 +0200
@@ -2836,9 +2836,7 @@ static void b43legacy_op_bss_info_change
 
 static void b43legacy_op_configure_filter(struct ieee80211_hw *hw,
 					  unsigned int changed,
-					  unsigned int *fflags,
-					  int mc_count,
-					  struct dev_addr_list *mc_list)
+					  unsigned int *fflags,u64 multicast)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-08-17 15:13:18.000000000 +0200
@@ -582,9 +582,7 @@ static int mac80211_hwsim_config(struct 
 
 static void mac80211_hwsim_configure_filter(struct ieee80211_hw *hw,
 					    unsigned int changed_flags,
-					    unsigned int *total_flags,
-					    int mc_count,
-					    struct dev_addr_list *mc_list)
+					    unsigned int *total_flags,u64 multicast)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-08-17 15:50:50.000000000 +0200
@@ -3251,31 +3251,50 @@ mwl8k_configure_filter_exit:
 	return rc;
 }
 
+static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mclist)
+{
+	struct mwl8k_configure_filter_worker *worker;
+
+	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
+
+	if (!worker)
+		return 0;
+
+	/*
+	 * XXX: This is _HORRIBLY_ broken!!
+	 *
+	 *	No locking, the mclist pointer might be invalid as soon as this
+	 *	function returns, something in the list might be invalidated
+	 *	once we get to the worker, etc...
+	 */
+	worker->mc_count = mc_count;
+	worker->mclist = mclist;
+
+	return (u64)worker;
+}
+
 static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
-				   int mc_count,
-				   struct dev_addr_list *mclist)
+				   u64 multicast)
 {
 
-	struct mwl8k_configure_filter_worker *worker;
+	struct mwl8k_configure_filter_worker *worker = (void *)multicast;
 	struct mwl8k_priv *priv = hw->priv;
 
 	/* Clear unsupported feature flags */
 	*total_flags &= MWL8K_SUPPORTED_IF_FLAGS;
 
-	if (!(changed_flags & MWL8K_SUPPORTED_IF_FLAGS) && !mc_count)
+	if (!(changed_flags & MWL8K_SUPPORTED_IF_FLAGS))
 		return;
 
-	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
 	if (worker == NULL)
 		return;
 
 	worker->header.options = MWL8K_WQ_QUEUE_ONLY | MWL8K_WQ_TX_WAIT_EMPTY;
 	worker->changed_flags = changed_flags;
 	worker->total_flags = total_flags;
-	worker->mc_count = mc_count;
-	worker->mclist = mclist;
 
 	mwl8k_queue_work(hw, &worker->header, priv->config_wq,
 			 mwl8k_configure_filter_wt);
@@ -3441,6 +3460,7 @@ static const struct ieee80211_ops mwl8k_
 	.remove_interface	= mwl8k_remove_interface,
 	.config			= mwl8k_config,
 	.bss_info_changed	= mwl8k_bss_info_changed,
+	.prepare_multicast	= mwl8k_prepare_multicast,
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
 	.conf_tx		= mwl8k_conf_tx,
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-08-17 15:13:18.000000000 +0200
@@ -728,10 +728,16 @@ static void rtl8180_bss_info_changed(str
 	        priv->rf->conf_erp(dev, info);
 }
 
+static u64 rtl8180_prepare_multicast(struct ieee80211_hw *dev, int mc_count,
+				     struct dev_addr_list *mc_list)
+{
+	return mc_count;
+}
+
 static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
-				     int mc_count, struct dev_addr_list *mclist)
+				     u64 multicast)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
@@ -741,7 +747,7 @@ static void rtl8180_configure_filter(str
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
 	if (changed_flags & FIF_OTHER_BSS)
 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
-	if (*total_flags & FIF_ALLMULTI || mc_count > 0)
+	if (*total_flags & FIF_ALLMULTI || multicast > 0)
 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
 	else
 		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
@@ -768,6 +774,7 @@ static const struct ieee80211_ops rtl818
 	.remove_interface	= rtl8180_remove_interface,
 	.config			= rtl8180_config,
 	.bss_info_changed	= rtl8180_bss_info_changed,
+	.prepare_multicast	= rtl8180_prepare_multicast,
 	.configure_filter	= rtl8180_configure_filter,
 };
 
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-08-17 15:13:18.000000000 +0200
@@ -1192,10 +1192,16 @@ static void rtl8187_bss_info_changed(str
 				 info->use_short_preamble);
 }
 
+static u64 rtl8187_prepare_multicast(struct ieee80211_hw *dev,
+				     int mc_count, struct dev_addr_list *mc_list)
+{
+	return mc_count;
+}
+
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
-				     int mc_count, struct dev_addr_list *mclist)
+				     u64 multicast)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
@@ -1205,7 +1211,7 @@ static void rtl8187_configure_filter(str
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
 	if (changed_flags & FIF_OTHER_BSS)
 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
-	if (*total_flags & FIF_ALLMULTI || mc_count > 0)
+	if (*total_flags & FIF_ALLMULTI || multicast > 0)
 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
 	else
 		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
@@ -1268,6 +1274,7 @@ static const struct ieee80211_ops rtl818
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
 	.bss_info_changed	= rtl8187_bss_info_changed,
+	.prepare_multicast	= rtl8187_prepare_multicast,
 	.configure_filter	= rtl8187_configure_filter,
 	.conf_tx		= rtl8187_conf_tx
 };
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2009-08-17 15:13:18.000000000 +0200
@@ -652,9 +652,7 @@ out:
 
 static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
-				       unsigned int *total,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
+				       unsigned int *total,u64 multicast)
 {
 	struct wl1251 *wl = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2009-08-17 15:13:18.000000000 +0200
@@ -793,9 +793,7 @@ out:
 
 static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
-				       unsigned int *total,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
+				       unsigned int *total,u64 multicast)
 {
 	struct wl1271 *wl = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/adm8211.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/adm8211.c	2009-08-17 15:46:38.000000000 +0200
@@ -1328,16 +1328,39 @@ static void adm8211_bss_info_changed(str
 	}
 }
 
+static u64 adm8211_prepare_multicast(struct ieee80211_hw *hw,
+				     int mc_count, struct dev_addr_list *mclist)
+{
+	unsigned int bit_nr, i;
+	u32 mc_filter[2];
+
+	mc_filter[1] = mc_filter[0] = 0;
+
+	for (i = 0; i < mc_count; i++) {
+		if (!mclist)
+			break;
+		bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
+
+		bit_nr &= 0x3F;
+		mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
+		mclist = mclist->next;
+	}
+
+	return mc_filter[0] | ((u64)(mc_filter[1]) << 32);
+}
+
 static void adm8211_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
-				     int mc_count, struct dev_mc_list *mclist)
+				     u64 multicast)
 {
 	static const u8 bcast[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 	struct adm8211_priv *priv = dev->priv;
-	unsigned int bit_nr, new_flags;
+	unsigned int new_flags;
 	u32 mc_filter[2];
-	int i;
+
+	mc_filter[0] = multicast;
+	mc_filter[1] = multicast >> 32;
 
 	new_flags = 0;
 
@@ -1346,23 +1369,13 @@ static void adm8211_configure_filter(str
 		priv->nar |= ADM8211_NAR_PR;
 		priv->nar &= ~ADM8211_NAR_MM;
 		mc_filter[1] = mc_filter[0] = ~0;
-	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {
+	} else if (*total_flags & FIF_ALLMULTI || multicast == ~(0ULL)) {
 		new_flags |= FIF_ALLMULTI;
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_MM;
 		mc_filter[1] = mc_filter[0] = ~0;
 	} else {
 		priv->nar &= ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
-		mc_filter[1] = mc_filter[0] = 0;
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
-
-			bit_nr &= 0x3F;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-			mclist = mclist->next;
-		}
 	}
 
 	ADM8211_IDLE_RX();
@@ -1757,6 +1770,7 @@ static const struct ieee80211_ops adm821
 	.remove_interface	= adm8211_remove_interface,
 	.config			= adm8211_config,
 	.bss_info_changed	= adm8211_bss_info_changed,
+	.prepare_multicast	= adm8211_prepare_multicast,
 	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
 	.get_tx_stats		= adm8211_get_tx_stats,
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-08-17 15:45:42.000000000 +0200
@@ -2100,10 +2100,29 @@ unlock:
 	mutex_unlock(&ar->mutex);
 }
 
+static u64 ar9170_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
+				       struct dev_addr_list *mclist)
+{
+	u64 mchash;
+	int i;
+
+	/* always get broadcast frames */
+	mchash = 1ULL << (0xff >> 2);
+
+	for (i = 0; i < mc_count; i++) {
+		if (WARN_ON(!mclist))
+			break;
+		mchash |= 1ULL << (mclist->dmi_addr[5] >> 2);
+		mclist = mclist->next;
+	}
+
+	return mchash;
+}
+
 static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed_flags,
 				       unsigned int *new_flags,
-				       int mc_count, struct dev_mc_list *mclist)
+				       u64 multicast)
 {
 	struct ar9170 *ar = hw->priv;
 
@@ -2116,24 +2135,11 @@ static void ar9170_op_configure_filter(s
 	 * then checking the error flags, later.
 	 */
 
-	if (changed_flags & FIF_ALLMULTI) {
-		if (*new_flags & FIF_ALLMULTI) {
-			ar->want_mc_hash = ~0ULL;
-		} else {
-			u64 mchash;
-			int i;
-
-			/* always get broadcast frames */
-			mchash = 1ULL << (0xff >> 2);
+	if (changed_flags & FIF_ALLMULTI && *new_flags & FIF_ALLMULTI)
+			multicast = ~0ULL;
 
-			for (i = 0; i < mc_count; i++) {
-				if (WARN_ON(!mclist))
-					break;
-				mchash |= 1ULL << (mclist->dmi_addr[5] >> 2);
-				mclist = mclist->next;
-			}
-		ar->want_mc_hash = mchash;
-		}
+	if (multicast != ar->want_mc_hash) {
+		ar->want_mc_hash = multicast;
 		set_bit(AR9170_FILTER_CHANGED_MULTICAST, &ar->filter_changed);
 	}
 
@@ -2543,6 +2549,7 @@ static const struct ieee80211_ops ar9170
 	.add_interface		= ar9170_op_add_interface,
 	.remove_interface	= ar9170_op_remove_interface,
 	.config			= ar9170_op_config,
+	.prepare_multicast	= ar9170_op_prepare_multicast,
 	.configure_filter	= ar9170_op_configure_filter,
 	.conf_tx		= ar9170_conf_tx,
 	.bss_info_changed	= ar9170_op_bss_info_changed,
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-08-17 15:13:18.000000000 +0200
@@ -229,10 +229,12 @@ static int ath5k_add_interface(struct ie
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf);
 static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
+static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mc_list);
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		unsigned int changed_flags,
 		unsigned int *new_flags,
-		int mc_count, struct dev_mc_list *mclist);
+		u64 multicast);
 static int ath5k_set_key(struct ieee80211_hw *hw,
 		enum set_key_cmd cmd,
 		struct ieee80211_vif *vif, struct ieee80211_sta *sta,
@@ -260,6 +262,7 @@ static const struct ieee80211_ops ath5k_
 	.add_interface 	= ath5k_add_interface,
 	.remove_interface = ath5k_remove_interface,
 	.config 	= ath5k_config,
+	.prepare_multicast = ath5k_prepare_multicast,
 	.configure_filter = ath5k_configure_filter,
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
@@ -2853,6 +2856,37 @@ unlock:
 	return ret;
 }
 
+static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mclist)
+{
+	u32 mfilt[2], val;
+	int i;
+	u8 pos;
+
+	mfilt[0] = 0;
+	mfilt[1] = 1;
+
+	for (i = 0; i < mc_count; i++) {
+		if (!mclist)
+			break;
+		/* calculate XOR of eight 6-bit values */
+		val = get_unaligned_le32(mclist->dmi_addr + 0);
+		pos = (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
+		val = get_unaligned_le32(mclist->dmi_addr + 3);
+		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
+		pos &= 0x3f;
+		mfilt[pos / 32] |= (1 << (pos % 32));
+		/* XXX: we might be able to just do this instead,
+		* but not sure, needs testing, if we do use this we'd
+		* neet to inform below to not reset the mcast */
+		/* ath5k_hw_set_mcast_filterindex(ah,
+		 *      mclist->dmi_addr[5]); */
+		mclist = mclist->next;
+	}
+
+	return ((u64)(mfilt[1]) << 32) | mfilt[0];
+}
+
 #define SUPPORTED_FIF_FLAGS \
 	FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
 	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
@@ -2878,16 +2912,14 @@ unlock:
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		unsigned int changed_flags,
 		unsigned int *new_flags,
-		int mc_count, struct dev_mc_list *mclist)
+		u64 multicast)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
-	u32 mfilt[2], val, rfilt;
-	u8 pos;
-	int i;
+	u32 mfilt[2], rfilt;
 
-	mfilt[0] = 0;
-	mfilt[1] = 0;
+	mfilt[0] = multicast;
+	mfilt[1] = multicast >> 32;
 
 	/* Only deal with supported flags */
 	changed_flags &= SUPPORTED_FIF_FLAGS;
@@ -2913,24 +2945,6 @@ static void ath5k_configure_filter(struc
 	if (*new_flags & FIF_ALLMULTI) {
 		mfilt[0] =  ~0;
 		mfilt[1] =  ~0;
-	} else {
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			/* calculate XOR of eight 6-bit values */
-			val = get_unaligned_le32(mclist->dmi_addr + 0);
-			pos = (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
-			val = get_unaligned_le32(mclist->dmi_addr + 3);
-			pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
-			pos &= 0x3f;
-			mfilt[pos / 32] |= (1 << (pos % 32));
-			/* XXX: we might be able to just do this instead,
-			* but not sure, needs testing, if we do use this we'd
-			* neet to inform below to not reset the mcast */
-			/* ath5k_hw_set_mcast_filterindex(ah,
-			 *      mclist->dmi_addr[5]); */
-			mclist = mclist->next;
-		}
 	}
 
 	/* This is the best we can do */
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-08-17 15:13:18.000000000 +0200
@@ -2389,8 +2389,7 @@ skip_chan_change:
 static void ath9k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
-				   int mc_count,
-				   struct dev_mc_list *mclist)
+				   u64 multicast)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-08-17 15:13:18.000000000 +0200
@@ -366,15 +366,35 @@ static int lbtf_op_config(struct ieee802
 	return 0;
 }
 
+static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
+				     int mc_count, struct dev_addr_list *mclist)
+{
+	struct lbtf_private *priv = hw->priv;
+	int i;
+
+	if (!mc_count || mc_count > MRVDRV_MAX_MULTICAST_LIST_SIZE)
+		return mc_count;
+
+	priv->nr_of_multicastmacaddr = mc_count;
+	for (i = 0; i < mc_count; i++) {
+		if (!mclist)
+			break;
+		memcpy(&priv->multicastlist[i], mclist->da_addr,
+				ETH_ALEN);
+		mclist = mclist->next;
+	}
+
+	return mc_count;
+}
+
 #define SUPPORTED_FIF_FLAGS  (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)
 static void lbtf_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *new_flags,
-			int mc_count, struct dev_mc_list *mclist)
+			u64 multicast)
 {
 	struct lbtf_private *priv = hw->priv;
 	int old_mac_control = priv->mac_control;
-	int i;
 	changed_flags &= SUPPORTED_FIF_FLAGS;
 	*new_flags &= SUPPORTED_FIF_FLAGS;
 
@@ -386,20 +406,12 @@ static void lbtf_op_configure_filter(str
 	else
 		priv->mac_control &= ~CMD_ACT_MAC_PROMISCUOUS_ENABLE;
 	if (*new_flags & (FIF_ALLMULTI) ||
-	    mc_count > MRVDRV_MAX_MULTICAST_LIST_SIZE) {
+	    multicast > MRVDRV_MAX_MULTICAST_LIST_SIZE) {
 		priv->mac_control |= CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
 		priv->mac_control &= ~CMD_ACT_MAC_MULTICAST_ENABLE;
-	} else if (mc_count) {
+	} else if (multicast) {
 		priv->mac_control |= CMD_ACT_MAC_MULTICAST_ENABLE;
 		priv->mac_control &= ~CMD_ACT_MAC_ALL_MULTICAST_ENABLE;
-		priv->nr_of_multicastmacaddr = mc_count;
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			memcpy(&priv->multicastlist[i], mclist->da_addr,
-					ETH_ALEN);
-			mclist = mclist->next;
-		}
 		lbtf_cmd_set_mac_multicast_addr(priv);
 	} else {
 		priv->mac_control &= ~(CMD_ACT_MAC_MULTICAST_ENABLE |
@@ -461,6 +473,7 @@ static const struct ieee80211_ops lbtf_o
 	.add_interface		= lbtf_op_add_interface,
 	.remove_interface	= lbtf_op_remove_interface,
 	.config			= lbtf_op_config,
+	.prepare_multicast	= lbtf_op_prepare_multicast,
 	.configure_filter	= lbtf_op_configure_filter,
 	.bss_info_changed	= lbtf_op_bss_info_changed,
 };
--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/main.c	2009-08-17 15:13:18.000000000 +0200
@@ -302,7 +302,7 @@ out:
 static void p54_configure_filter(struct ieee80211_hw *dev,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
-				 int mc_count, struct dev_mc_list *mclist)
+				 u64 multicast)
 {
 	struct p54_common *priv = dev->priv;
 
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-08-17 15:13:18.000000000 +0200
@@ -796,18 +796,40 @@ static void set_rx_filter_handler(struct
 		dev_err(zd_mac_dev(mac), "set_rx_filter_handler error %d\n", r);
 }
 
+static u64 zd_op_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mclist)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	struct zd_mc_hash hash;
+	int i;
+
+	zd_mc_clear(&hash);
+
+	for (i = 0; i < mc_count; i++) {
+		if (!mclist)
+			break;
+		dev_dbg_f(zd_mac_dev(mac), "mc addr %pM\n", mclist->dmi_addr);
+		zd_mc_add_addr(&hash, mclist->dmi_addr);
+		mclist = mclist->next;
+	}
+
+	return hash.low | ((u64)hash.high << 32);
+}
+
 #define SUPPORTED_FIF_FLAGS \
 	(FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
 	FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
 static void zd_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *new_flags,
-			int mc_count, struct dev_mc_list *mclist)
+			u64 multicast)
 {
-	struct zd_mc_hash hash;
+	struct zd_mc_hash hash = {
+		.low = multicast,
+		.high = multicast >> 32,
+	};
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
-	int i;
 
 	/* Only deal with supported flags */
 	changed_flags &= SUPPORTED_FIF_FLAGS;
@@ -819,25 +841,16 @@ static void zd_op_configure_filter(struc
 	if (!changed_flags)
 		return;
 
-	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) {
+	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI))
 		zd_mc_add_all(&hash);
-	} else {
-		zd_mc_clear(&hash);
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			dev_dbg_f(zd_mac_dev(mac), "mc addr %pM\n",
-				  mclist->dmi_addr);
-			zd_mc_add_addr(&hash, mclist->dmi_addr);
-			mclist = mclist->next;
-		}
-	}
 
 	spin_lock_irqsave(&mac->lock, flags);
 	mac->pass_failed_fcs = !!(*new_flags & FIF_FCSFAIL);
 	mac->pass_ctrl = !!(*new_flags & FIF_CONTROL);
 	mac->multicast_hash = hash;
 	spin_unlock_irqrestore(&mac->lock, flags);
+
+	/* XXX: these can be called here now, can sleep now! */
 	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
 
 	if (changed_flags & FIF_CONTROL)
@@ -940,6 +953,7 @@ static const struct ieee80211_ops zd_ops
 	.add_interface		= zd_op_add_interface,
 	.remove_interface	= zd_op_remove_interface,
 	.config			= zd_op_config,
+	.prepare_multicast	= zd_op_prepare_multicast,
 	.configure_filter	= zd_op_configure_filter,
 	.bss_info_changed	= zd_op_bss_info_changed,
 	.get_tsf		= zd_op_get_tsf,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-08-17 15:13:18.000000000 +0200
@@ -1513,7 +1513,7 @@ EXPORT_SYMBOL(iwl_irq_handle_error);
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags,
-			  int mc_count, struct dev_addr_list *mc_list)
+			  u64 multicast)
 {
 	struct iwl_priv *priv = hw->priv;
 	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-08-17 15:12:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-08-17 15:13:18.000000000 +0200
@@ -277,8 +277,7 @@ int iwl_set_decrypted_flag(struct iwl_pr
 void iwl_irq_handle_error(struct iwl_priv *priv);
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
-			  unsigned int *total_flags,
-			  int mc_count, struct dev_addr_list *mc_list);
+			  unsigned int *total_flags, u64 multicast);
 int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_setup_mac(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00.h	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00.h	2009-08-17 15:13:18.000000000 +0200
@@ -978,7 +978,7 @@ int rt2x00mac_config(struct ieee80211_hw
 void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,
 				unsigned int *total_flags,
-				int mc_count, struct dev_addr_list *mc_list);
+				u64 multicast);
 int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		      bool set);
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-08-17 15:12:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-08-17 15:13:18.000000000 +0200
@@ -379,7 +379,7 @@ EXPORT_SYMBOL_GPL(rt2x00mac_config);
 void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,
 				unsigned int *total_flags,
-				int mc_count, struct dev_addr_list *mc_list)
+				u64 multicast)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 


