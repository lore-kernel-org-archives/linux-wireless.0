Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:51957 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932264Ab2E3IlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:41:14 -0400
Received: by obbuo13 with SMTP id uo13so18441550obb.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 01:40:59 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3] mac80211: add op to configure default key id
Date: Wed, 30 May 2012 11:36:39 +0300
Message-Id: <1338366999-5268-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120530_104118_257567_BDCC3548)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are hardwares which support offload of data packets
for example when auto ARP is enabled the hw will send
the ARP response. In such cases if WEP encryption is
configured the hw must know the default WEP key in order
to encrypt the packets correctly.

When hw_accel is enabled and encryption type is set to WEP,
the driver should get the default key index from mac80211.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---

v2 to v3:
	removed the return value of set_default_key_idx op
        since it should not fail at this point.

 include/net/mac80211.h      |    7 ++++++-
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |   24 ++++++++++++++++++++++++
 net/mac80211/key.c          |    2 ++
 4 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..aecdca7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1427,6 +1427,10 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
  * provided by update_tkip_key only. The trigger that makes mac80211 call this
  * handler is software decryption with wrap around of iv16.
+ *
+ * The set_default_key_idx() call updates the default WEP key index configured
+ * to the hardware for WEP encryption type. This is required for hw which
+ * supports offload of data packets (i.e. auto ARP respones).
  */
 
 /**
@@ -2361,7 +2365,6 @@ struct ieee80211_ops {
 					u16 tids, int num_frames,
 					enum ieee80211_frame_release_type reason,
 					bool more_data);
-
 	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif, int sset);
 	void	(*get_et_stats)(struct ieee80211_hw *hw,
@@ -2370,6 +2373,8 @@ struct ieee80211_ops {
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
+	void (*set_default_key_idx)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, int idx);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6d33a0c..b627f56 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -845,4 +845,18 @@ drv_allow_buffered_frames(struct ieee80211_local *local,
 						  more_data);
 	trace_drv_return_void(local);
 }
+
+static inline void
+drv_set_default_unicast_key(struct ieee80211_local *local,
+		    struct ieee80211_sub_if_data *sdata,
+		    int key_idx)
+{
+	check_sdata_in_driver(sdata);
+
+	trace_drv_set_default_unicast_key(local, sdata, key_idx);
+	if (local->ops->set_default_key_idx)
+		local->ops->set_default_key_idx(&local->hw, &sdata->vif,
+						key_idx);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..bd4cc06 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1606,6 +1606,30 @@ TRACE_EVENT(stop_queue,
 		LOCAL_PR_ARG, __entry->queue, __entry->reason
 	)
 );
+
+TRACE_EVENT(drv_set_default_unicast_key,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 int key_idx),
+
+	TP_ARGS(local, sdata, key_idx),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(int, key_idx)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->key_idx = key_idx;
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT " key_idx:%d",
+		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->key_idx)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 5bb600d..32ff162 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -237,6 +237,8 @@ void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 {
 	mutex_lock(&sdata->local->key_mtx);
 	__ieee80211_set_default_key(sdata, idx, uni, multi);
+	if (uni)
+		drv_set_default_unicast_key(sdata->local, sdata, idx);
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
-- 
1.7.0.4

