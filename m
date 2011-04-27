Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42279 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1D0Kmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 06:42:39 -0400
Received: by pwi15 with SMTP id 15so586553pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 03:42:39 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19895.62392.401485.495514@gargle.gargle.HOWL> (sfid-20110427_124243_049030_B1927070)
Date: Wed, 27 Apr 2011 16:15:12 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Add new API for rate selection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This patch adds a new API for setting a TX rate mask in
drivers that have rate control in either the firmware or hardware.
This can be used for various purposes, for example, masking out the
11b rates in P2P operation.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
v2 : rc_rateidx_mask has to be updated for drivers using
     IEEE80211_HW_HAS_RATE_CONTROL since building IEs for
     a probe request makes use of it.

 include/net/mac80211.h      |    6 ++++++
 net/mac80211/cfg.c          |   15 ++++++---------
 net/mac80211/driver-ops.h   |   18 ++++++++++++++++++
 net/mac80211/driver-trace.h |   27 +++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d23dd6c..4c97fc8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1822,6 +1822,10 @@ enum ieee80211_ampdu_mlme_action {
  *
  * @tx_frames_pending: Check if there is any pending frame in the hardware
  *	queues before entering power save.
+ *
+ * @set_bitrate_mask: Set a mask of rates to be used for rate control selection
+ *	when transmitting a frame. Currently only legacy rates are handled.
+ *	The callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1910,6 +1914,8 @@ struct ieee80211_ops {
 	void (*get_ringparam)(struct ieee80211_hw *hw,
 			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
 	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
+	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				const struct cfg80211_bitrate_mask *mask);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9ddaf6..12d52ce 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1633,16 +1633,13 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int i;
-
-	/*
-	 * This _could_ be supported by providing a hook for
-	 * drivers for this function, but at this point it
-	 * doesn't seem worth bothering.
-	 */
-	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
-		return -EOPNOTSUPP;
+	int i, ret;
 
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
+		ret = drv_set_bitrate_mask(local, sdata, mask);
+		if (ret)
+			return ret;
+	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
 		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 00a0685..4ed3013 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -565,4 +565,22 @@ static inline bool drv_tx_frames_pending(struct ieee80211_local *local)
 
 	return ret;
 }
+
+static inline int drv_set_bitrate_mask(struct ieee80211_local *local,
+				       struct ieee80211_sub_if_data *sdata,
+				       const struct cfg80211_bitrate_mask *mask)
+{
+	int ret = -ENOTSUPP;
+
+	might_sleep();
+
+	trace_drv_set_bitrate_mask(local, sdata, mask);
+	if (local->ops->set_bitrate_mask)
+		ret = local->ops->set_bitrate_mask(&local->hw,
+						   &sdata->vif, mask);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index c8c934d..191e834 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -989,6 +989,33 @@ DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(drv_set_bitrate_mask,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const struct cfg80211_bitrate_mask *mask),
+
+	TP_ARGS(local, sdata, mask),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u32, legacy_2g)
+		__field(u32, legacy_5g)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->legacy_2g = mask->control[IEEE80211_BAND_2GHZ].legacy;
+		__entry->legacy_5g = mask->control[IEEE80211_BAND_5GHZ].legacy;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " 2G Mask:0x%x 5G Mask:0x%x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->legacy_2g, __entry->legacy_5g
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.4.4

