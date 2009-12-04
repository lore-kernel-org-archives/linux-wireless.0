Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZLDOvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 09:51:45 -0500
Message-Id: <20091204143702.976422368@sipsolutions.net>
Date: Fri, 04 Dec 2009 15:35:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/4] mac80211: support remain-on-channel command
References: <20091204143544.034718060@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the new remain-on-channel cfg80211
command in mac80211, extending the work interface.

Also change the work purge code to be able to clean
up events properly (pretending they timed out.)

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c         |   24 ++++++++
 net/mac80211/ieee80211_i.h |   15 +++++
 net/mac80211/main.c        |    3 +
 net/mac80211/mlme.c        |    3 +
 net/mac80211/offchannel.c  |    8 ++
 net/mac80211/work.c        |  134 +++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 181 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-04 15:00:40.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-04 15:00:41.000000000 +0100
@@ -225,9 +225,11 @@ struct mesh_preq_queue {
 };
 
 enum ieee80211_work_type {
+	IEEE80211_WORK_ABORT,
 	IEEE80211_WORK_DIRECT_PROBE,
 	IEEE80211_WORK_AUTH,
 	IEEE80211_WORK_ASSOC,
+	IEEE80211_WORK_REMAIN_ON_CHANNEL,
 };
 
 /**
@@ -283,6 +285,9 @@ struct ieee80211_work {
 			u8 supp_rates_len;
 			bool wmm_used, use_11n;
 		} assoc;
+		struct {
+			unsigned long timeout;
+		} remain;
 	};
 
 	int ie_len;
@@ -729,6 +734,10 @@ struct ieee80211_local {
 	enum nl80211_channel_type oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
+	/* Temporary remain-on-channel for off-channel operations */
+	struct ieee80211_channel *tmp_channel;
+	enum nl80211_channel_type tmp_channel_type;
+
 	/* SNMP counters */
 	/* dot11CountersTable */
 	u32 dot11TransmittedFragmentCount;
@@ -1160,6 +1169,12 @@ void ieee80211_add_work(struct ieee80211
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb);
+int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_channel *chan,
+				   enum nl80211_channel_type channel_type,
+				   unsigned int duration, u64 *cookie);
+int ieee80211_wk_cancel_remain_on_channel(
+	struct ieee80211_sub_if_data *sdata, u64 cookie);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-04 15:00:40.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-04 15:00:41.000000000 +0100
@@ -849,6 +849,9 @@ static void ieee80211_mgd_probe_ap(struc
 	if (sdata->local->scanning)
 		return;
 
+	if (sdata->local->tmp_channel)
+		return;
+
 	mutex_lock(&ifmgd->mtx);
 
 	if (!ifmgd->associated)
--- wireless-testing.orig/net/mac80211/main.c	2009-12-04 15:00:40.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-12-04 15:00:41.000000000 +0100
@@ -107,6 +107,9 @@ int ieee80211_hw_config(struct ieee80211
 	if (scan_chan) {
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
+	} else if (local->tmp_channel) {
+		chan = scan_chan = local->tmp_channel;
+		channel_type = local->tmp_channel_type;
 	} else {
 		chan = local->oper_channel;
 		channel_type = local->oper_channel_type;
--- wireless-testing.orig/net/mac80211/cfg.c	2009-12-04 15:00:40.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-12-04 15:00:41.000000000 +0100
@@ -1440,6 +1440,28 @@ static int ieee80211_set_bitrate_mask(st
 	return -EINVAL;
 }
 
+static int ieee80211_remain_on_channel(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       struct ieee80211_channel *chan,
+				       enum nl80211_channel_type channel_type,
+				       unsigned int duration,
+				       u64 *cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return ieee80211_wk_remain_on_channel(sdata, chan, channel_type,
+					      duration, cookie);
+}
+
+static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
+					      struct net_device *dev,
+					      u64 cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1486,4 +1508,6 @@ struct cfg80211_ops mac80211_config_ops 
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 	.set_power_mgmt = ieee80211_set_power_mgmt,
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
+	.remain_on_channel = ieee80211_remain_on_channel,
+	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 };
--- wireless-testing.orig/net/mac80211/offchannel.c	2009-12-04 15:00:40.000000000 +0100
+++ wireless-testing/net/mac80211/offchannel.c	2009-12-04 15:00:41.000000000 +0100
@@ -94,9 +94,13 @@ void ieee80211_offchannel_stop_beaconing
 		/*
 		 * only handle non-STA interfaces here, STA interfaces
 		 * are handled in ieee80211_offchannel_stop_station(),
-		 * e.g., from the background scan state machine
+		 * e.g., from the background scan state machine.
+		 *
+		 * In addition, do not stop monitor interface to allow it to be
+		 * used from user space controlled off-channel operations.
 		 */
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			netif_stop_queue(sdata->dev);
 	}
 	mutex_unlock(&local->iflist_mtx);
--- wireless-testing.orig/net/mac80211/work.c	2009-12-04 15:00:41.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-04 15:00:41.000000000 +0100
@@ -538,6 +538,44 @@ ieee80211_associate(struct ieee80211_wor
 	return WORK_ACT_NONE;
 }
 
+static enum work_action __must_check
+ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
+{
+	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct ieee80211_local *local = sdata->local;
+
+	/*
+	 * First time we run, do nothing -- the generic code will
+	 * have switched to the right channel etc.
+	 */
+	if (wk->timeout != wk->remain.timeout) {
+		wk->timeout = wk->remain.timeout;
+		return WORK_ACT_NONE;
+	}
+
+	/*
+	 * We are done serving the remain-on-channel command; kill the work
+	 * item to allow idle state to be entered again. In addition, clear the
+	 * temporary channel information to allow operational channel to be
+	 * used.
+	 */
+	list_del(&wk->list);
+	free_work(wk);
+
+	if (local->tmp_channel) {
+		cfg80211_remain_on_channel_expired(sdata->dev, (u64)wk,
+						   local->tmp_channel,
+						   local->tmp_channel_type,
+						   GFP_KERNEL);
+
+		local->tmp_channel = NULL;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_offchannel_return(local, true);
+	}
+
+	return WORK_ACT_NONE;
+}
+
 static void ieee80211_auth_challenge(struct ieee80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
@@ -825,6 +863,8 @@ static void ieee80211_work_work(struct w
 			/* nothing */
 			rma = WORK_ACT_NONE;
 			break;
+		case IEEE80211_WORK_ABORT:
+			rma = WORK_ACT_TIMEOUT;
 		case IEEE80211_WORK_DIRECT_PROBE:
 			rma = ieee80211_direct_probe(wk);
 			break;
@@ -834,6 +874,9 @@ static void ieee80211_work_work(struct w
 		case IEEE80211_WORK_ASSOC:
 			rma = ieee80211_associate(wk);
 			break;
+		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
+			rma = ieee80211_remain_on_channel_timeout(wk);
+			break;
 		}
 
 		switch (rma) {
@@ -900,14 +943,25 @@ void ieee80211_work_init(struct ieee8021
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_work *wk, *tmp;
+	struct ieee80211_work *wk;
 
 	mutex_lock(&local->work_mtx);
-	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
+	list_for_each_entry(wk, &local->work_list, list) {
 		if (wk->sdata != sdata)
 			continue;
-		list_del(&wk->list);
-		free_work(wk);
+		wk->type = IEEE80211_WORK_ABORT;
+	}
+	mutex_unlock(&local->work_mtx);
+
+	/* run cleanups etc. */
+	ieee80211_work_work(&local->work_work);
+
+	mutex_lock(&local->work_mtx);
+	list_for_each_entry(wk, &local->work_list, list) {
+		if (wk->sdata != sdata)
+			continue;
+		WARN_ON(1);
+		break;
 	}
 	mutex_unlock(&local->work_mtx);
 }
@@ -949,3 +1003,75 @@ ieee80211_rx_result ieee80211_work_rx_mg
 
 	return RX_CONTINUE;
 }
+
+int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_channel *chan,
+				   enum nl80211_channel_type channel_type,
+				   unsigned int duration, u64 *cookie)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_work *wk;
+
+	wk = kzalloc(sizeof(*wk), GFP_KERNEL);
+	if (!wk)
+		return -ENOMEM;
+
+	wk->type = IEEE80211_WORK_REMAIN_ON_CHANNEL;
+	wk->chan = chan;
+	wk->sdata = sdata;
+
+	wk->remain.timeout = jiffies + msecs_to_jiffies(duration);
+
+	*cookie = (u64)wk;
+
+	ieee80211_add_work(wk);
+
+	/*
+	 * TODO: could optimize this by leaving the station vifs in awake mode
+	 * if they happen to be on the same channel as the requested channel
+	 */
+	ieee80211_offchannel_stop_beaconing(local);
+	ieee80211_offchannel_stop_station(local);
+
+	sdata->local->tmp_channel = chan;
+	sdata->local->tmp_channel_type = channel_type;
+	ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	cfg80211_ready_on_channel(sdata->dev, (u64)wk, chan, channel_type,
+				  duration, GFP_KERNEL);
+
+	return 0;
+}
+
+int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+					  u64 cookie)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_work *wk, *tmp;
+	bool found = false;
+
+	mutex_lock(&local->work_mtx);
+	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
+		if ((u64)wk == cookie) {
+			found = true;
+			list_del(&wk->list);
+			free_work(wk);
+			break;
+		}
+	}
+	mutex_unlock(&local->work_mtx);
+
+	if (!found)
+		return -ENOENT;
+
+	if (sdata->local->tmp_channel) {
+		sdata->local->tmp_channel = NULL;
+		ieee80211_hw_config(sdata->local,
+				    IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_offchannel_return(sdata->local, true);
+	}
+
+	ieee80211_recalc_idle(local);
+
+	return 0;
+}


