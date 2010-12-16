Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LPOR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:17:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PTEe7-0001AN-QF
	for linux-wireless@vger.kernel.org; Thu, 16 Dec 2010 15:17:28 +0100
Message-Id: <20101216141633.158244039@sipsolutions.net>
Date: Thu, 16 Dec 2010 15:15:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: implement hardware offload for
 remain-on-channel
References: <20101216141518.879668720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This allows drivers to support remain-on-channel
offload if they implement smarter timing or need
to use a device implementation like iwlwifi.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   19 ++++++++++
 net/mac80211/cfg.c          |   81 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   30 ++++++++++++++++
 net/mac80211/driver-trace.h |   80 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    8 ++++
 net/mac80211/iface.c        |    9 +++-
 net/mac80211/main.c         |    5 ++
 net/mac80211/offchannel.c   |   75 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 304 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-12-14 17:06:54.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-12-14 17:07:39.000000000 +0100
@@ -365,6 +365,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
+	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -1824,6 +1825,12 @@ struct ieee80211_ops {
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
+
+	int (*remain_on_channel)(struct ieee80211_hw *hw,
+				 struct ieee80211_channel *chan,
+				 enum nl80211_channel_type channel_type,
+				 int duration);
+	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
 };
 
 /**
@@ -2727,6 +2734,18 @@ void ieee80211_request_smps(struct ieee8
  */
 void ieee80211_key_removed(struct ieee80211_key_conf *key_conf);
 
+/**
+ * ieee80211_ready_on_channel - notification of remain-on-channel start
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+void ieee80211_ready_on_channel(struct ieee80211_hw *hw);
+
+/**
+ * ieee80211_remain_on_channel_expired - remain_on_channel duration expired
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
+
 /* Rate control API */
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-14 17:07:39.000000000 +0100
@@ -1562,6 +1562,37 @@ static int ieee80211_set_bitrate_mask(st
 	return 0;
 }
 
+static int ieee80211_remain_on_channel_hw(struct ieee80211_local *local,
+					  struct net_device *dev,
+					  struct ieee80211_channel *chan,
+					  enum nl80211_channel_type chantype,
+					  unsigned int duration, u64 *cookie)
+{
+	int ret;
+	u32 random_cookie;
+
+	lockdep_assert_held(&local->mtx);
+
+	if (local->hw_roc_cookie)
+		return -EBUSY;
+	/* must be nonzero */
+	random_cookie = random32() | 1;
+
+	*cookie = random_cookie;
+	local->hw_roc_dev = dev;
+	local->hw_roc_cookie = random_cookie;
+	local->hw_roc_channel = chan;
+	local->hw_roc_channel_type = chantype;
+	local->hw_roc_duration = duration;
+	ret = drv_remain_on_channel(local, chan, chantype, duration);
+	if (ret) {
+		local->hw_roc_channel = NULL;
+		local->hw_roc_cookie = 0;
+	}
+
+	return ret;
+}
+
 static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       struct ieee80211_channel *chan,
@@ -1570,16 +1601,60 @@ static int ieee80211_remain_on_channel(s
 				       u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->ops->remain_on_channel) {
+		int ret;
+
+		mutex_lock(&local->mtx);
+		ret = ieee80211_remain_on_channel_hw(local, dev,
+						     chan, channel_type,
+						     duration, cookie);
+		mutex_unlock(&local->mtx);
+
+		return ret;
+	}
 
 	return ieee80211_wk_remain_on_channel(sdata, chan, channel_type,
 					      duration, cookie);
 }
 
+static int ieee80211_cancel_remain_on_channel_hw(struct ieee80211_local *local,
+						 u64 cookie)
+{
+	int ret;
+
+	lockdep_assert_held(&local->mtx);
+
+	if (local->hw_roc_cookie != cookie)
+		return -ENOENT;
+
+	ret = drv_cancel_remain_on_channel(local);
+	if (ret)
+		return ret;
+
+	local->hw_roc_cookie = 0;
+	local->hw_roc_channel = NULL;
+
+	return 0;
+}
+
 static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	if (local->ops->cancel_remain_on_channel) {
+		int ret;
+
+		mutex_lock(&local->mtx);
+		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
+		mutex_unlock(&local->mtx);
+
+		return ret;
+	}
 
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
 }
@@ -1631,6 +1706,12 @@ static int ieee80211_mgmt_tx(struct wiph
 	     channel_type != local->_oper_channel_type))
 		is_offchan = true;
 
+	if (chan == local->hw_roc_channel) {
+		/* TODO: check channel type? */
+		is_offchan = false;
+		flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
+	}
+
 	if (is_offchan && !offchan)
 		return -EBUSY;
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-12-14 17:07:39.000000000 +0100
@@ -938,6 +938,13 @@ struct ieee80211_local {
 	} debugfs;
 #endif
 
+	struct ieee80211_channel *hw_roc_channel;
+	struct net_device *hw_roc_dev;
+	struct work_struct hw_roc_start, hw_roc_done;
+	enum nl80211_channel_type hw_roc_channel_type;
+	unsigned int hw_roc_duration;
+	u32 hw_roc_cookie;
+
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
 
@@ -1129,6 +1136,7 @@ void ieee80211_offchannel_stop_beaconing
 void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
 				 bool enable_beaconing);
+void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
 /* interface handling */
 int ieee80211_iface_init(void);
--- wireless-testing.orig/net/mac80211/offchannel.c	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/offchannel.c	2010-12-14 17:07:39.000000000 +0100
@@ -14,6 +14,7 @@
  */
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-trace.h"
 
 /*
  * inform AP that we will go to sleep so that it will buffer the frames
@@ -190,3 +191,77 @@ void ieee80211_offchannel_return(struct
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
+
+static void ieee80211_hw_roc_start(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, hw_roc_start);
+
+	mutex_lock(&local->mtx);
+
+	if (!local->hw_roc_channel) {
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
+	ieee80211_recalc_idle(local);
+
+	cfg80211_ready_on_channel(local->hw_roc_dev, local->hw_roc_cookie,
+				  local->hw_roc_channel,
+				  local->hw_roc_channel_type,
+				  local->hw_roc_duration,
+				  GFP_KERNEL);
+	mutex_unlock(&local->mtx);
+}
+
+void ieee80211_ready_on_channel(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	trace_api_ready_on_channel(local);
+
+	ieee80211_queue_work(hw, &local->hw_roc_start);
+}
+EXPORT_SYMBOL_GPL(ieee80211_ready_on_channel);
+
+static void ieee80211_hw_roc_done(struct work_struct *work)
+{
+	struct ieee80211_local *local =
+		container_of(work, struct ieee80211_local, hw_roc_done);
+
+	mutex_lock(&local->mtx);
+
+	if (!local->hw_roc_channel) {
+		mutex_unlock(&local->mtx);
+		return;
+	}
+
+	cfg80211_remain_on_channel_expired(local->hw_roc_dev,
+					   local->hw_roc_cookie,
+					   local->hw_roc_channel,
+					   local->hw_roc_channel_type,
+					   GFP_KERNEL);
+
+	local->hw_roc_channel = NULL;
+	local->hw_roc_cookie = 0;
+
+	ieee80211_recalc_idle(local);
+
+	mutex_unlock(&local->mtx);
+}
+
+void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	trace_api_remain_on_channel_expired(local);
+
+	ieee80211_queue_work(hw, &local->hw_roc_done);
+}
+EXPORT_SYMBOL_GPL(ieee80211_remain_on_channel_expired);
+
+void ieee80211_hw_roc_setup(struct ieee80211_local *local)
+{
+	INIT_WORK(&local->hw_roc_start, ieee80211_hw_roc_start);
+	INIT_WORK(&local->hw_roc_done, ieee80211_hw_roc_done);
+}
--- wireless-testing.orig/net/mac80211/main.c	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2010-12-14 17:07:39.000000000 +0100
@@ -603,6 +603,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	ieee80211_led_names(local);
 
+	ieee80211_hw_roc_setup(local);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
@@ -747,7 +749,8 @@ int ieee80211_register_hw(struct ieee802
 		}
 	}
 
-	local->hw.wiphy->max_remain_on_channel_duration = 5000;
+	if (!local->ops->remain_on_channel)
+		local->hw.wiphy->max_remain_on_channel_duration = 5000;
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
--- wireless-testing.orig/net/mac80211/iface.c	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-12-14 17:07:39.000000000 +0100
@@ -1264,7 +1264,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 {
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
-	bool working = false, scanning = false;
+	bool working = false, scanning = false, hw_roc = false;
 	struct ieee80211_work *wk;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
 
@@ -1308,6 +1308,9 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		local->scan_sdata->vif.bss_conf.idle = false;
 	}
 
+	if (local->hw_roc_channel)
+		hw_roc = true;
+
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->old_idle == sdata->vif.bss_conf.idle)
 			continue;
@@ -1316,7 +1319,7 @@ u32 __ieee80211_recalc_idle(struct ieee8
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 	}
 
-	if (working || scanning)
+	if (working || scanning || hw_roc)
 		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_WORK;
 	else
 		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_WORK;
@@ -1328,6 +1331,8 @@ u32 __ieee80211_recalc_idle(struct ieee8
 
 	ieee80211_mod_tpt_led_trig(local, led_trig_start, led_trig_stop);
 
+	if (hw_roc)
+		return ieee80211_idle_off(local, "hw remain-on-channel");
 	if (working)
 		return ieee80211_idle_off(local, "working");
 	if (scanning)
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2010-12-14 17:07:39.000000000 +0100
@@ -465,4 +465,34 @@ static inline int drv_get_antenna(struct
 	return ret;
 }
 
+static inline int drv_remain_on_channel(struct ieee80211_local *local,
+					struct ieee80211_channel *chan,
+					enum nl80211_channel_type chantype,
+					unsigned int duration)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_remain_on_channel(local, chan, chantype, duration);
+	ret = local->ops->remain_on_channel(&local->hw, chan, chantype,
+					    duration);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline int drv_cancel_remain_on_channel(struct ieee80211_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_cancel_remain_on_channel(local);
+	ret = local->ops->cancel_remain_on_channel(&local->hw);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-12-14 17:06:55.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2010-12-14 17:07:39.000000000 +0100
@@ -933,6 +933,50 @@ TRACE_EVENT(drv_get_antenna,
 	)
 );
 
+TRACE_EVENT(drv_remain_on_channel,
+	TP_PROTO(struct ieee80211_local *local, struct ieee80211_channel *chan,
+		 enum nl80211_channel_type chantype, unsigned int duration),
+
+	TP_ARGS(local, chan, chantype, duration),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, center_freq)
+		__field(int, channel_type)
+		__field(unsigned int, duration)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->center_freq = chan->center_freq;
+		__entry->channel_type = chantype;
+		__entry->duration = duration;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " freq:%dMHz duration:%dms",
+		LOCAL_PR_ARG, __entry->center_freq, __entry->duration
+	)
+);
+
+TRACE_EVENT(drv_cancel_remain_on_channel,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
@@ -1170,6 +1214,42 @@ TRACE_EVENT(api_chswitch_done,
 	)
 );
 
+TRACE_EVENT(api_ready_on_channel,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(api_remain_on_channel_expired,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)


