Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:41777 "EHLO
        2.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732621AbeHNP4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 11:56:37 -0400
Received: from player792.ha.ovh.net (unknown [10.109.143.216])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id 70754119C59
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 12:43:34 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v6 2/3] mac80211: Define new driver callback replace_key
Date: Tue, 14 Aug 2018 12:42:54 +0200
Message-Id: <20180814104255.4183-3-alexander@wetzel-home.de> (sfid-20180814_150937_268341_D6A69B63)
In-Reply-To: <20180814104255.4183-1-alexander@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define the new driver callback replace_key in mac80211 for future use.
Drivers able to replace a in-use key should implement this new callback
to allow mac80211 drivers to securely use PTK rekeying.

On return of the function drivers must guarantee they:
 - Did not send out any frames for the key unencrypted during the
   replace,
 - will not send out packets queued to them prior to the call encrypted
   with the new key
 - and will no longer hand over any frames which were decrypted by the
   old key to mac80211 when not also handling PN (IV) in the driver.

Packets handed over to the driver after the callback has returned are
expected to be send out encrypted with the new key and retransmissions
must either be dropped or continue to use the old key.

Mac80211 will not hand over packets for the key being replaced while the
callback is running. All other packets will still be handed over.
If the driver can't handle that the driver is allowed to call functions
like ieee80211_stop_queues from the callback.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/mac80211.h    | 15 +++++++++++++++
 net/mac80211/driver-ops.h | 20 ++++++++++++++++++++
 net/mac80211/main.c       |  5 +++++
 net/mac80211/trace.h      | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..7d13cd10b7d7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3137,6 +3137,17 @@ enum ieee80211_reconfig_type {
  *	Returns a negative error code if the key can't be added.
  *	The callback can sleep.
  *
+ * @replace_key: Replace an exiting in use key with a new one while guaranteeing
+ * 	to not leak clear text packets. Implementing this callback will enable
+ * 	mac80211 to announce NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE.
+ * 	Packets already queued must not be send out encrypted with the new key
+ * 	and packets decoded with the old key must not be handed over to mac80211
+ * 	when the driver is not checking IV/ICV itself once the callback has been
+ * 	completed.
+ * 	Mac80211 will log an error when asked to use replace a PTK key
+ * 	without replace_key but will still perform the then potentially
+ * 	insecure action via set_key for backward compatibility for now.
+ *
  * @update_tkip_key: See the section "Hardware crypto acceleration"
  * 	This callback will be called in the context of Rx. Called for drivers
  * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
@@ -3585,6 +3596,10 @@ struct ieee80211_ops {
 	int (*set_key)(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key);
+	int (*replace_key)(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		       struct ieee80211_key_conf *old,
+		       struct ieee80211_key_conf *new);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_key_conf *conf,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 8f6998091d26..ebd7f1463336 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -255,6 +255,26 @@ static inline int drv_set_key(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_replace_key(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_key_conf *old_key,
+			      struct ieee80211_key_conf *new_key)
+{
+	int ret;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_replace_key(local, sdata, sta, old_key, new_key);
+	ret = local->ops->replace_key(&local->hw, &sdata->vif, sta, old_key, new_key);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_key_conf *conf,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4fb2709cb527..84cc8005c19a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -572,9 +572,14 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 				      NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT);
 	}
 
+	if (ops->replace_key)
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE);
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+
 	if (ops->wake_tx_queue)
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_TXQS);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0ab69a1964f8..f93e00f1ae4d 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -603,6 +603,45 @@ TRACE_EVENT(drv_set_key,
 	)
 );
 
+TRACE_EVENT(drv_replace_key,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 struct ieee80211_key_conf *old_key,
+		 struct ieee80211_key_conf *new_key),
+
+	TP_ARGS(local, sdata, sta, old_key, new_key),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		KEY_ENTRY
+		__field(u32, cipher2)
+		__field(u8, hw_key_idx2)
+		__field(u8, flags2)
+		__field(s8, keyidx2)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		KEY_ASSIGN(old_key);
+		__entry->cipher2 = new_key->cipher;
+		__entry->flags2 = new_key->flags;
+		__entry->keyidx2 = new_key->keyidx;
+		__entry->hw_key_idx2 = new_key->hw_key_idx;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT KEY_PR_FMT
+		" cipher2:0x%x, flags2=%#x, keyidx2=%d, hw_key_idx2=%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, KEY_PR_ARG,
+		__entry->cipher2, __entry->flags2, __entry->keyidx2, __entry->hw_key_idx2
+	)
+);
+
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.18.0
