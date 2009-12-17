Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZLQMvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 07:51:09 -0500
Subject: [PATCH] mac80211: annotate sleeping driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20091216214202.17238.82313.stgit@tikku>
References: <20091216214202.17238.82313.stgit@tikku>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 13:50:58 +0100
Message-ID: <1261054258.10356.104.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@iki.fi>

To make it easier to notice cases of calling sleeping ops in atomic context,
annotate driver-ops.h with appropiate might_sleep() calls. At the same time,
also document in mac80211.h the op functions with missing contexts.

mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be on
the safe side, I documented it to be atomic, but hopefully the op can be
removed in the future.

Compile-tested only.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h    |   43 +++++++++++++++++++++++---------
 net/mac80211/driver-ops.h |   60 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 87 insertions(+), 16 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-12-15 20:54:11.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-12-17 13:48:38.000000000 +0100
@@ -1385,7 +1385,7 @@ enum ieee80211_ampdu_mlme_action {
  *	When the device is started it should not have a MAC address
  *	to avoid acknowledging frames before a non-monitor device
  *	is added.
- *	Must be implemented.
+ *	Must be implemented and can sleep.
  *
  * @stop: Called after last netdevice attached to the hardware
  *	is disabled. This should turn off the hardware (at least
@@ -1393,7 +1393,7 @@ enum ieee80211_ampdu_mlme_action {
  *	May be called right after add_interface if that rejects
  *	an interface. If you added any work onto the mac80211 workqueue
  *	you should ensure to cancel it on this callback.
- *	Must be implemented.
+ *	Must be implemented and can sleep.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
  *	enabled. Because it is not called for monitor mode devices, @start
@@ -1403,7 +1403,7 @@ enum ieee80211_ampdu_mlme_action {
  *	interface is given in the conf parameter.
  *	The callback may refuse to add an interface by returning a
  *	negative error code (which will be seen in userspace.)
- *	Must be implemented.
+ *	Must be implemented and can sleep.
  *
  * @remove_interface: Notifies a driver that an interface is going down.
  *	The @stop callback is called after this if it is the last interface
@@ -1412,19 +1412,20 @@ enum ieee80211_ampdu_mlme_action {
  *	must be cleared so the device no longer acknowledges packets,
  *	the mac_addr member of the conf structure is, however, set to the
  *	MAC address of the device going away.
- *	Hence, this callback must be implemented.
+ *	Hence, this callback must be implemented. It can sleep.
  *
  * @config: Handler for configuration requests. IEEE 802.11 code calls this
  *	function to change hardware configuration, e.g., channel.
  *	This function should never fail but returns a negative error code
- *	if it does.
+ *	if it does. The callback can sleep.
  *
  * @bss_info_changed: Handler for configuration requests related to BSS
  *	parameters that may vary during BSS's lifespan, and may affect low
  *	level driver (e.g. assoc/disassoc status, erp parameters).
  *	This function should not be used if no BSS has been set, unless
  *	for association indication. The @changed parameter indicates which
- *	of the bss parameters has changed when a call is made.
+ *	of the bss parameters has changed when a call is made. The callback
+ *	can sleep.
  *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
@@ -1432,20 +1433,22 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @configure_filter: Configure the device's RX filter.
  *	See the section "Frame filtering" for more information.
- *	This callback must be implemented.
+ *	This callback must be implemented and can sleep.
  *
  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
  * 	must be set or cleared for a given STA. Must be atomic.
  *
  * @set_key: See the section "Hardware crypto acceleration"
- *	This callback can sleep, and is only called between add_interface
- *	and remove_interface calls, i.e. while the given virtual interface
+ *	This callback is only called between add_interface and
+ *	remove_interface calls, i.e. while the given virtual interface
  *	is enabled.
  *	Returns a negative error code if the key can't be added.
+ *	The callback can sleep.
  *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
  * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
+ *	The callback can sleep.
  *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
@@ -1459,21 +1462,28 @@ enum ieee80211_ampdu_mlme_action {
  *	When the scan finishes, ieee80211_scan_completed() must be called;
  *	note that it also must be called when the scan cannot finish due to
  *	any error unless this callback returned a negative error code.
+ *	The callback can sleep.
  *
  * @sw_scan_start: Notifier function that is called just before a software scan
  *	is started. Can be NULL, if the driver doesn't need this notification.
+ *	The callback can sleep.
  *
- * @sw_scan_complete: Notifier function that is called just after a software scan
- *	finished. Can be NULL, if the driver doesn't need this notification.
+ * @sw_scan_complete: Notifier function that is called just after a
+ *	software scan finished. Can be NULL, if the driver doesn't need
+ *	this notification.
+ *	The callback can sleep.
  *
  * @get_stats: Return low-level statistics.
  * 	Returns zero if statistics are available.
+ *	The callback can sleep.
  *
  * @get_tkip_seq: If your device implements TKIP encryption in hardware this
  *	callback should be provided to read the TKIP transmit IVs (both IV32
  *	and IV16) for the given key from hardware.
+ *	The callback must be atomic.
  *
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
+ *	The callback can sleep.
  *
  * @sta_notify: Notifies low level driver about addition, removal or power
  *	state transition of an associated station, AP,  IBSS/WDS/mesh peer etc.
@@ -1482,30 +1492,36 @@ enum ieee80211_ampdu_mlme_action {
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
+ *	The callback can sleep.
  *
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
  *	size (limit), and total number of packets sent using each TX queue
  *	(count). The 'stats' pointer points to an array that has hw->queues
  *	items.
+ *	The callback must be atomic.
  *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
  *	this is only used for IBSS mode BSSID merging and debugging. Is not a
  *	required function.
+ *	The callback can sleep.
  *
  * @set_tsf: Set the TSF timer to the specified value in the firmware/hardware.
  *      Currently, this is only used for IBSS mode debugging. Is not a
  *	required function.
+ *	The callback can sleep.
  *
  * @reset_tsf: Reset the TSF timer and allow firmware/hardware to synchronize
  *	with other STAs in the IBSS. This is only used in IBSS mode. This
  *	function is optional if the firmware/hardware takes full care of
  *	TSF synchronization.
+ *	The callback can sleep.
  *
  * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
  *	This is needed only for IBSS mode and the result of this function is
  *	used to determine whether to reply to Probe Requests.
  *	Returns non-zero if this device sent the last beacon.
+ *	The callback can sleep.
  *
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
@@ -1514,16 +1530,19 @@ enum ieee80211_ampdu_mlme_action {
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
  *	Returns a negative error code on failure.
+ *	The callback must be atomic.
  *
  * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
  *	need to set wiphy->rfkill_poll to %true before registration,
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
+ *	The callback can sleep.
  *
  * @testmode_cmd: Implement a cfg80211 test mode command.
+ *	The callback can sleep.
  *
  * @flush: Flush all pending frames from the hardware queue, making sure
  *	that the hardware queues are empty. If the parameter @drop is set
- *	to %true, pending frames may be dropped.
+ *	to %true, pending frames may be dropped. The callback can sleep.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-12-12 16:28:36.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-12-17 13:49:59.000000000 +0100
@@ -14,6 +14,8 @@ static inline int drv_start(struct ieee8
 {
 	int ret;
 
+	might_sleep();
+
 	local->started = true;
 	smp_mb();
 	ret = local->ops->start(&local->hw);
@@ -23,6 +25,8 @@ static inline int drv_start(struct ieee8
 
 static inline void drv_stop(struct ieee80211_local *local)
 {
+	might_sleep();
+
 	local->ops->stop(&local->hw);
 	trace_drv_stop(local);
 
@@ -38,7 +42,11 @@ static inline void drv_stop(struct ieee8
 static inline int drv_add_interface(struct ieee80211_local *local,
 				    struct ieee80211_vif *vif)
 {
-	int ret = local->ops->add_interface(&local->hw, vif);
+	int ret;
+
+	might_sleep();
+
+	ret = local->ops->add_interface(&local->hw, vif);
 	trace_drv_add_interface(local, vif_to_sdata(vif), ret);
 	return ret;
 }
@@ -46,13 +54,19 @@ static inline int drv_add_interface(stru
 static inline void drv_remove_interface(struct ieee80211_local *local,
 					struct ieee80211_vif *vif)
 {
+	might_sleep();
+
 	local->ops->remove_interface(&local->hw, vif);
 	trace_drv_remove_interface(local, vif_to_sdata(vif));
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
 {
-	int ret = local->ops->config(&local->hw, changed);
+	int ret;
+
+	might_sleep();
+
+	ret = local->ops->config(&local->hw, changed);
 	trace_drv_config(local, changed, ret);
 	return ret;
 }
@@ -62,6 +76,8 @@ static inline void drv_bss_info_changed(
 					struct ieee80211_bss_conf *info,
 					u32 changed)
 {
+	might_sleep();
+
 	if (local->ops->bss_info_changed)
 		local->ops->bss_info_changed(&local->hw, &sdata->vif, info, changed);
 	trace_drv_bss_info_changed(local, sdata, info, changed);
@@ -111,7 +127,11 @@ static inline int drv_set_key(struct iee
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_key_conf *key)
 {
-	int ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
+	int ret;
+
+	might_sleep();
+
+	ret = local->ops->set_key(&local->hw, cmd, &sdata->vif, sta, key);
 	trace_drv_set_key(local, cmd, sdata, sta, key, ret);
 	return ret;
 }
@@ -121,6 +141,8 @@ static inline void drv_update_tkip_key(s
 				       const u8 *address, u32 iv32,
 				       u16 *phase1key)
 {
+	might_sleep();
+
 	if (local->ops->update_tkip_key)
 		local->ops->update_tkip_key(&local->hw, conf, address,
 					    iv32, phase1key);
@@ -130,13 +152,19 @@ static inline void drv_update_tkip_key(s
 static inline int drv_hw_scan(struct ieee80211_local *local,
 			      struct cfg80211_scan_request *req)
 {
-	int ret = local->ops->hw_scan(&local->hw, req);
+	int ret;
+
+	might_sleep();
+
+	ret = local->ops->hw_scan(&local->hw, req);
 	trace_drv_hw_scan(local, req, ret);
 	return ret;
 }
 
 static inline void drv_sw_scan_start(struct ieee80211_local *local)
 {
+	might_sleep();
+
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(&local->hw);
 	trace_drv_sw_scan_start(local);
@@ -144,6 +172,8 @@ static inline void drv_sw_scan_start(str
 
 static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 {
+	might_sleep();
+
 	if (local->ops->sw_scan_complete)
 		local->ops->sw_scan_complete(&local->hw);
 	trace_drv_sw_scan_complete(local);
@@ -154,6 +184,8 @@ static inline int drv_get_stats(struct i
 {
 	int ret = -EOPNOTSUPP;
 
+	might_sleep();
+
 	if (local->ops->get_stats)
 		ret = local->ops->get_stats(&local->hw, stats);
 	trace_drv_get_stats(local, stats, ret);
@@ -173,6 +205,9 @@ static inline int drv_set_rts_threshold(
 					u32 value)
 {
 	int ret = 0;
+
+	might_sleep();
+
 	if (local->ops->set_rts_threshold)
 		ret = local->ops->set_rts_threshold(&local->hw, value);
 	trace_drv_set_rts_threshold(local, value, ret);
@@ -193,6 +228,9 @@ static inline int drv_conf_tx(struct iee
 			      const struct ieee80211_tx_queue_params *params)
 {
 	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, queue, params);
 	trace_drv_conf_tx(local, queue, params, ret);
@@ -210,6 +248,9 @@ static inline int drv_get_tx_stats(struc
 static inline u64 drv_get_tsf(struct ieee80211_local *local)
 {
 	u64 ret = -1ULL;
+
+	might_sleep();
+
 	if (local->ops->get_tsf)
 		ret = local->ops->get_tsf(&local->hw);
 	trace_drv_get_tsf(local, ret);
@@ -218,6 +259,8 @@ static inline u64 drv_get_tsf(struct iee
 
 static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
 {
+	might_sleep();
+
 	if (local->ops->set_tsf)
 		local->ops->set_tsf(&local->hw, tsf);
 	trace_drv_set_tsf(local, tsf);
@@ -225,6 +268,8 @@ static inline void drv_set_tsf(struct ie
 
 static inline void drv_reset_tsf(struct ieee80211_local *local)
 {
+	might_sleep();
+
 	if (local->ops->reset_tsf)
 		local->ops->reset_tsf(&local->hw);
 	trace_drv_reset_tsf(local);
@@ -233,6 +278,9 @@ static inline void drv_reset_tsf(struct 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
 	int ret = 1;
+
+	might_sleep();
+
 	if (local->ops->tx_last_beacon)
 		ret = local->ops->tx_last_beacon(&local->hw);
 	trace_drv_tx_last_beacon(local, ret);
@@ -256,12 +304,16 @@ static inline int drv_ampdu_action(struc
 
 static inline void drv_rfkill_poll(struct ieee80211_local *local)
 {
+	might_sleep();
+
 	if (local->ops->rfkill_poll)
 		local->ops->rfkill_poll(&local->hw);
 }
 
 static inline void drv_flush(struct ieee80211_local *local, bool drop)
 {
+	might_sleep();
+
 	trace_drv_flush(local, drop);
 	if (local->ops->flush)
 		local->ops->flush(&local->hw, drop);


