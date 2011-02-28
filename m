Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab1B1Qss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:48:48 -0500
Received: by mail-fx0-f46.google.com with SMTP id 17so3915244fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:48:47 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] [mac80211] enable radar detection
Date: Mon, 28 Feb 2011 17:47:44 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281747.44842.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When switching to channels requiring radar detection, enable it
if the current mode is one which requires beaconing. In all other
cases the radar detection is disabled.

Note, drivers which do not support radar detection are not allowed
to switch to those channels.

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/net/mac80211.h      |    4 ++++
 net/mac80211/cfg.c          |   15 +++++++++++++++
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |   21 +++++++++++++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2b072fa..495b0c5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1804,6 +1804,8 @@ enum ieee80211_ampdu_mlme_action {
  *	return value is 1, then the @remain_on_channel will be used with a
  *	regular transmission (if supported.)
  * @offchannel_tx_cancel_wait: cancel wait associated with offchannel TX
+ *
+ * @radar_detection: Enable or disable radar detection on current channel.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1888,6 +1890,8 @@ struct ieee80211_ops {
 			     enum nl80211_channel_type channel_type,
 			     unsigned int wait);
 	int (*offchannel_tx_cancel_wait)(struct ieee80211_hw *hw);
+
+	int (*radar_detection)(struct ieee80211_hw *hw, int enable);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4a07e67..e50ecaa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1245,6 +1245,21 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 		old_vif_oper_type = sdata->vif.bss_conf.channel_type;
 	old_oper_type = local->_oper_channel_type;
 
+	if (sdata && (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		      sdata->vif.type == NL80211_IFTYPE_AP ||
+		      sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		      sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+		      sdata->vif.type == NL80211_IFTYPE_P2P_GO) &&
+	    (chan->flags & IEEE80211_CHAN_RADAR)) {
+		/*
+		 * Do not allow switching to channels requiring radar
+		 * detection if hardware doesn't support detection.
+		 */
+		if (drv_radar_detection(local, true))
+			return -EINVAL;
+	} else
+		drv_radar_detection(local, false);
+
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3729296..a2bef0c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -526,4 +526,18 @@ static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
 	return ret;
 }
 
+static inline int drv_radar_detection(struct ieee80211_local *local, int enable)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	trace_drv_radar_detection(local, enable);
+	if (local->ops->radar_detection)
+		ret = local->ops->radar_detection(&local->hw, enable);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 520fe24..aa2c833 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1150,6 +1150,27 @@ DEFINE_EVENT(local_only_evt, api_remain_on_channel_expired,
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(drv_radar_detection,
+	TP_PROTO(struct ieee80211_local *local, int enable),
+
+	TP_ARGS(local, enable),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, enable)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->enable = enable;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " enable:%d",
+		LOCAL_PR_ARG, __entry->enable
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
-- 
1.7.2.3
