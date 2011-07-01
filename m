Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab1GAWP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:15:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Qcm0C-0007N0-LF
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:15:56 +0200
Message-Id: <20110701221534.101853720@sipsolutions.net> (sfid-20110702_001602_512004_F63FF50C)
Date: Sat, 02 Jul 2011 00:13:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/3] mac80211: support GTK rekey offload
References: <20110701221321.478559320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds the necessary mac80211 APIs to support
GTK rekey offload, mirroring the functionality
from cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   20 +++++++++++++++++
 net/mac80211/cfg.c          |   16 ++++++++++++++
 net/mac80211/driver-ops.h   |   10 ++++++++
 net/mac80211/driver-trace.h |   49 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/key.c          |   12 ++++++++++
 5 files changed, 107 insertions(+)

--- a/include/net/mac80211.h	2011-07-02 00:08:13.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-02 00:12:31.000000000 +0200
@@ -1700,6 +1700,12 @@ enum ieee80211_ampdu_mlme_action {
  * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
  *	The callback must be atomic.
  *
+ * @set_rekey_data: If the device supports GTK rekeying, for example while the
+ *	host is suspended, it can assign this callback to retrieve the data
+ *	necessary to do GTK rekeying, this is the KEK, KCK and replay counter.
+ *	After rekeying was done it should (for example during resume) notify
+ *	userspace of the new replay counter using ieee80211_gtk_rekey_notify().
+ *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
  *	the scan state machine in stack. The scan must honour the channel
  *	configuration done by the regulatory agent in the wiphy's
@@ -1912,6 +1918,9 @@ struct ieee80211_ops {
 				struct ieee80211_key_conf *conf,
 				struct ieee80211_sta *sta,
 				u32 iv32, u16 *phase1key);
+	void (*set_rekey_data)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_gtk_rekey_data *data);
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	void (*cancel_hw_scan)(struct ieee80211_hw *hw,
@@ -2585,6 +2594,17 @@ ieee80211_get_buffered_bc(struct ieee802
 void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 				struct sk_buff *skb,
 				enum ieee80211_tkip_key_type type, u8 *key);
+
+/**
+ * ieee80211_gtk_rekey_notify - notify userspace supplicant of rekeying
+ * @vif: virtual interface the rekeying was done on
+ * @bssid: The BSSID of the AP, for checking association
+ * @replay_ctr: the new replay counter after GTK rekeying
+ * @gfp: allocation flags
+ */
+void ieee80211_gtk_rekey_notify(struct ieee80211_vif *vif, const u8 *bssid,
+				const u8 *replay_ctr, gfp_t gfp);
+
 /**
  * ieee80211_wake_queue - wake specific queue
  * @hw: pointer as obtained from ieee80211_alloc_hw().
--- a/net/mac80211/cfg.c	2011-07-02 00:00:35.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-07-02 00:12:31.000000000 +0200
@@ -2101,6 +2101,21 @@ static void ieee80211_get_ringparam(stru
 	drv_get_ringparam(local, tx, tx_max, rx, rx_max);
 }
 
+static int ieee80211_set_rekey_data(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct cfg80211_gtk_rekey_data *data)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (!local->ops->set_rekey_data)
+		return -EOPNOTSUPP;
+
+	drv_set_rekey_data(local, sdata, data);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2163,4 +2178,5 @@ struct cfg80211_ops mac80211_config_ops
 	.get_antenna = ieee80211_get_antenna,
 	.set_ringparam = ieee80211_set_ringparam,
 	.get_ringparam = ieee80211_get_ringparam,
+	.set_rekey_data = ieee80211_set_rekey_data,
 };
--- a/net/mac80211/driver-trace.h	2011-07-02 00:00:35.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-07-02 00:12:31.000000000 +0200
@@ -1024,6 +1024,34 @@ TRACE_EVENT(drv_set_bitrate_mask,
 	)
 );
 
+TRACE_EVENT(drv_set_rekey_data,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_gtk_rekey_data *data),
+
+	TP_ARGS(local, sdata, data),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(u8, kek, NL80211_KEK_LEN)
+		__array(u8, kck, NL80211_KCK_LEN)
+		__array(u8, replay_ctr, NL80211_REPLAY_CTR_LEN)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->kek, data->kek, NL80211_KEK_LEN);
+		memcpy(__entry->kck, data->kck, NL80211_KCK_LEN);
+		memcpy(__entry->replay_ctr, data->replay_ctr,
+		       NL80211_REPLAY_CTR_LEN);
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT,
+		  LOCAL_PR_ARG, VIF_PR_ARG)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
@@ -1293,6 +1321,27 @@ DEFINE_EVENT(local_only_evt, api_remain_
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(api_gtk_rekey_notify,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid, const u8 *replay_ctr),
+
+	TP_ARGS(sdata, bssid, replay_ctr),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__array(u8, bssid, ETH_ALEN)
+		__array(u8, replay_ctr, NL80211_REPLAY_CTR_LEN)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		memcpy(__entry->bssid, bssid, ETH_ALEN);
+		memcpy(__entry->replay_ctr, replay_ctr, NL80211_REPLAY_CTR_LEN);
+	),
+
+	TP_printk(VIF_PR_FMT, VIF_PR_ARG)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
--- a/net/mac80211/key.c	2011-07-02 00:08:13.000000000 +0200
+++ b/net/mac80211/key.c	2011-07-02 00:12:31.000000000 +0200
@@ -566,3 +566,15 @@ void ieee80211_free_keys(struct ieee8021
 
 	mutex_unlock(&sdata->local->key_mtx);
 }
+
+
+void ieee80211_gtk_rekey_notify(struct ieee80211_vif *vif, const u8 *bssid,
+				const u8 *replay_ctr, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	trace_api_gtk_rekey_notify(sdata, bssid, replay_ctr);
+
+	cfg80211_gtk_rekey_notify(sdata->dev, bssid, replay_ctr, gfp);
+}
+EXPORT_SYMBOL_GPL(ieee80211_gtk_rekey_notify);
--- a/net/mac80211/driver-ops.h	2011-07-02 00:07:54.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-07-02 00:12:48.000000000 +0200
@@ -647,4 +647,14 @@ static inline int drv_set_bitrate_mask(s
 	return ret;
 }
 
+static inline void drv_set_rekey_data(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata,
+				      struct cfg80211_gtk_rekey_data *data)
+{
+	trace_drv_set_rekey_data(local, sdata, data);
+	if (local->ops->set_rekey_data)
+		local->ops->set_rekey_data(&local->hw, &sdata->vif, data);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */


