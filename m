Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeC0IoO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:44:14 -0400
From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: [RFC 1/4] mac80211: Add NoAck policy functionality offload infrastructure
Date: Tue, 27 Mar 2018 14:12:48 +0530
Message-Id: <1522140171-10926-2-git-send-email-vthiagar@codeaurora.org> (sfid-20180327_104420_657886_88E29060)
In-Reply-To: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add infrastructure for drivers to implement NoAck policy functionlity.
Driver like ath10k does not use the per-packet TID NoAck policy
configuration.  Instead NoAck map is sent to the firmware/hardware
in control path. Firmware takes care of setting up QOS header and
hw with NoAck policy based on the TID NoAck map.

Drivers having this support should advertise it through a new hw_flag,
IEEE80211_HW_SUPPORTS_NOACK_POLICY, and must implement callback
set_noack_tid_bitmap(). Supporting drivers would receive TID NoAck map
through set_noack_tid_bitmap() instead of receiving as part of every
tx skb.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
---
 include/net/mac80211.h    | 15 +++++++++++++++
 net/mac80211/cfg.c        | 10 ++++++++--
 net/mac80211/debugfs.c    |  1 +
 net/mac80211/driver-ops.h | 21 +++++++++++++++++++++
 net/mac80211/iface.c      |  4 ++++
 net/mac80211/main.c       |  4 ++++
 net/mac80211/trace.h      | 25 +++++++++++++++++++++++++
 net/mac80211/tx.c         |  3 ++-
 net/mac80211/wme.c        |  3 ++-
 9 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d39fd68..5a49c90 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2081,6 +2081,13 @@ struct ieee80211_txq {
  *	the frame, as it is not synced with the AP/P2P GO yet, and thus the
  *	deauthentication frame might not be transmitted.
  *
+ * @IEEE80211_HW_SUPPORTS_NOACK_POLICY: Hardware (or driver) manages noack
+ *	policy handling. Hardware (or driver) takes care of setting
+ *	noack policy in the qos header and does not wait for the ack based
+ *	on the noack TID map. Driver advertising this support must implement
+ *	callback @set_noack_tid_bitmap to receive the user configured noack TID
+ *	bitmap.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2125,6 +2132,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
 	IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
 	IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP,
+	IEEE80211_HW_SUPPORTS_NOACK_POLICY,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -3490,6 +3498,10 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ *
+ * @set_noack_tid_bitmap: Set NoAck policy TID bitmap for a virtual interface.
+ *	Drivers advertising NoAck policy handing support
+ *	(%IEEE80211_HW_SUPPORTS_NOACK_POLICY) must implement this callback.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3771,6 +3783,9 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+
+	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, u8 noack_map);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5c4b105..a2f0eae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -347,9 +347,15 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 
 	sdata->noack_map = noack_map;
 
-	ieee80211_check_fast_xmit_iface(sdata);
+	if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
+		ieee80211_check_fast_xmit_iface(sdata);
+		return 0;
+	}
 
-	return 0;
+	if (!ieee80211_sdata_running(sdata))
+		return 0;
+
+	return drv_set_noack_tid_bitmap(sdata->local, sdata, noack_map);
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a75653a..b6e6243 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -213,6 +213,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	FLAG(SUPPORTS_TX_FRAG),
 	FLAG(SUPPORTS_TDLS_BUFFER_STA),
 	FLAG(DEAUTH_NEED_MGD_TX_PREP),
+	FLAG(SUPPORTS_NOACK_POLICY),
 #undef FLAG
 };
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4d82fe7..a0a2d3c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1250,4 +1250,25 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
+					   struct ieee80211_sub_if_data *sdata,
+					   u16 noack_map)
+{
+	int ret;
+
+	might_sleep();
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	if (!local->ops->set_noack_tid_bitmap)
+		return -EOPNOTSUPP;
+
+	trace_drv_set_noack_tid_bitmap(local, sdata, noack_map);
+	ret = local->ops->set_noack_tid_bitmap(&local->hw, &sdata->vif,
+					       noack_map);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d13ba06..4e120b9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -631,6 +631,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 				ieee80211_vif_type_p2p(&sdata->vif));
 			if (res)
 				goto err_del_interface;
+
+			if (sdata->noack_map)
+				drv_set_noack_tid_bitmap(local, sdata,
+							 sdata->noack_map);
 		}
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0785d04..78f2574 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -835,6 +835,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		    (!local->ops->start_nan || !local->ops->stop_nan)))
 		return -EINVAL;
 
+	if (WARN_ON(ieee80211_hw_check(hw, SUPPORTS_NOACK_POLICY) &&
+		    !local->ops->set_noack_tid_bitmap))
+		return -EINVAL;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 591ad02..3b55569 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1863,6 +1863,31 @@ struct trace_switch_entry {
 	)
 );
 
+TRACE_EVENT(drv_set_noack_tid_bitmap,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u16 noack_map),
+
+	TP_ARGS(local, sdata, noack_map),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u16, noack_map)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->noack_map = noack_map;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", noack_map: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->noack_map
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 933c67b..27fcef3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2817,7 +2817,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
 		goto out;
 
-	if (sdata->noack_map)
+	if (sdata->noack_map &&
+	    !ieee80211_hw_check(&local->hw, SUPPORTS_NOACK_POLICY))
 		goto out;
 
 	/* fast-xmit doesn't handle fragmentation at all */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5f7c963..6512a47 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -256,7 +256,8 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 		       IEEE80211_QOS_CTL_ACK_POLICY_MASK);
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
-	    sdata->noack_map & BIT(tid)) {
+	    (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY) &&
+	    sdata->noack_map & BIT(tid))) {
 		flags |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
-- 
1.9.1
