Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3ARMdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 07:33:44 -0500
Message-ID: <1358512446.5035.2.camel@jlt4.sipsolutions.net> (sfid-20130118_133357_489152_614492B6)
Subject: Re: [PATCH v3] mac80211: add op to configure default key id
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 Jan 2013 13:34:06 +0100
In-Reply-To: <1338366999-5268-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120530_104118_257567_BDCC3548)
References: <1338366999-5268-1-git-send-email-yoni.divinsky@ti.com>
	 (sfid-20120530_104118_257567_BDCC3548)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 11:36 +0300, Yoni Divinsky wrote:
> There are hardwares which support offload of data packets
> for example when auto ARP is enabled the hw will send
> the ARP response. In such cases if WEP encryption is
> configured the hw must know the default WEP key in order
> to encrypt the packets correctly.
> 
> When hw_accel is enabled and encryption type is set to WEP,
> the driver should get the default key index from mac80211.
> 
> Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>

I applied the fixed up version below.

johannes

>From de5fad815703b5b24bc4726cd71422929537d259 Mon Sep 17 00:00:00 2001
From: Yoni Divinsky <yoni.divinsky@ti.com>
Date: Wed, 30 May 2012 11:36:39 +0300
Subject: [PATCH] mac80211: add op to configure default key id

There are hardwares which support offload of data packets
for example when auto ARP is enabled the hw will send
the ARP response. In such cases if WEP encryption is
configured the hw must know the default WEP key in order
to encrypt the packets correctly.

When hw_accel is enabled and encryption type is set to WEP,
the driver should get the default key index from mac80211.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
[cleanups, fixes, documentation]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    | 10 ++++++++++
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 net/mac80211/key.c        |  5 ++++-
 net/mac80211/trace.h      | 23 +++++++++++++++++++++++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3037f49..e0825a9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1630,6 +1630,10 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * rekeying), it will not include a valid phase 1 key. The valid phase 1 key is
  * provided by update_tkip_key only. The trigger that makes mac80211 call this
  * handler is software decryption with wrap around of iv16.
+ *
+ * The set_default_unicast_key() call updates the default WEP key index
+ * configured to the hardware for WEP encryption type. This is required
+ * for devices that support offload of data packets (e.g. ARP responses).
  */
 
 /**
@@ -2208,6 +2212,10 @@ enum ieee80211_rate_control_changed {
  *	After rekeying was done it should (for example during resume) notify
  *	userspace of the new replay counter using ieee80211_gtk_rekey_notify().
  *
+ * @set_default_unicast_key: Set the default (unicast) key index, useful for
+ *	WEP when the device sends data packets autonomously, e.g. for ARP
+ *	offloading. The index can be 0-3, or -1 for unsetting it.
+ *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
  *	configuration done by the regulatory agent in the wiphy's
@@ -2539,6 +2547,8 @@ struct ieee80211_ops {
 	void (*set_rekey_data)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct cfg80211_gtk_rekey_data *data);
+	void (*set_default_unicast_key)(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif, int idx);
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	void (*cancel_hw_scan)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0c07f94..e6033b0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1020,4 +1020,20 @@ static inline void drv_restart_complete(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
+static inline void
+drv_set_default_unicast_key(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    int key_idx)
+{
+	check_sdata_in_driver(sdata);
+
+	WARN_ON_ONCE(key_idx < -1 || key_idx > 3);
+
+	trace_drv_set_default_unicast_key(local, sdata, key_idx);
+	if (local->ops->set_default_unicast_key)
+		local->ops->set_default_unicast_key(&local->hw, &sdata->vif,
+						    key_idx);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 619c5d6..ef252eb 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -204,8 +204,11 @@ static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 	if (idx >= 0 && idx < NUM_DEFAULT_KEYS)
 		key = key_mtx_dereference(sdata->local, sdata->keys[idx]);
 
-	if (uni)
+	if (uni) {
 		rcu_assign_pointer(sdata->default_unicast_key, key);
+		drv_set_default_unicast_key(sdata->local, sdata, idx);
+	}
+
 	if (multi)
 		rcu_assign_pointer(sdata->default_multicast_key, key);
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 41861b9..9341b93 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1821,6 +1821,29 @@ TRACE_EVENT(stop_queue,
 	)
 );
 
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
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
-- 
1.8.0



