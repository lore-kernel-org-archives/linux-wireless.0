Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40470 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaGTMck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:32:40 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so3011382wiv.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:32:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 2/2] mac80211: add enable_dynack API
Date: Sun, 20 Jul 2014 14:32:35 +0200
Message-Id: <1405859555-31806-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_145108_413413_B3F61FC2)
In-Reply-To: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add enable_dynack API to mac80211 in order to enable the estimation
of ack timeout (dynack). Currently dynack is supported just by ath9k

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h    |  4 ++++
 net/mac80211/cfg.c        |  8 ++++++++
 net/mac80211/driver-ops.h | 14 ++++++++++++++
 net/mac80211/trace.h      |  5 +++++
 4 files changed, 31 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9ce5cb1..723db9b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2840,6 +2840,8 @@ enum ieee80211_roc_type {
  * @get_expected_throughput: extract the expected throughput towards the
  *	specified station. The returned value is expressed in Kbps. It returns 0
  *	if the RC algorithm does not have proper data to provide.
+ *
+ * @enable_dynack: Enable ack timeout estimation algorithm
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3041,6 +3043,8 @@ struct ieee80211_ops {
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
+
+	int (*enable_dynack)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 927b4ea..cb7c514 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3481,6 +3481,13 @@ static int ieee80211_set_ap_chanwidth(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_enable_dynack(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_enable_dynack(local);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3557,4 +3564,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
+	.enable_dynack = ieee80211_enable_dynack,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1142395..5968c00 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1238,4 +1238,18 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_enable_dynack(struct ieee80211_local *local)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	trace_drv_enable_dynack(local);
+	if (local->ops->enable_dynack)
+		ret = local->ops->enable_dynack(&local->hw);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 02ac535..7523eee 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1623,6 +1623,11 @@ TRACE_EVENT(drv_get_expected_throughput,
 	)
 );
 
+DEFINE_EVENT(local_only_evt, drv_enable_dynack,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.9.1

