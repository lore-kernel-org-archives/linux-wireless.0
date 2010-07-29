Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47902 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0G2UWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:22:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] mac80211: support use of NAPI for bottom-half processing
Date: Thu, 29 Jul 2010 16:14:13 -0400
Message-Id: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implement basic infrastructure to support use of NAPI by
mac80211-based hardware drivers.

Because mac80211 devices can support multiple netdevs, a dummy netdev
is used for interfacing with the NAPI code in the core of the network
stack.  That structure is hidden from the hardware drivers, but the
actual napi_struct is exposed in the ieee80211_hw structure so that the
poll routines in drivers can retrieve that structure.  Hardware drivers
can also specify their own weight value for NAPI polling.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/mac80211.h     |    8 ++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    4 ++++
 net/mac80211/main.c        |    6 ++++++
 4 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 20d372e..88223b4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1094,6 +1094,9 @@ enum ieee80211_hw_flags {
  *
  * @max_rates: maximum number of alternate rate retry stages
  * @max_rate_tries: maximum number of tries for each stage
+ *
+ * @napi: NAPI control structure
+ * @napi_weight: weight used for NAPI polling
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1105,6 +1108,8 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
+	struct napi_struct napi;
+	int napi_weight;
 	u16 queues;
 	u16 max_listen_interval;
 	s8 max_signal;
@@ -1679,6 +1684,8 @@ enum ieee80211_ampdu_mlme_action {
  *	switch operation for CSAs received from the AP may implement this
  *	callback. They must then call ieee80211_chswitch_done() to indicate
  *	completion of the channel switch.
+ *
+ * @napi_poll: Poll Rx queue for incoming data frames.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1744,6 +1751,7 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*napi_poll)(struct napi_struct *napi, int budget);
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c6b5c2d..2c6ac97 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -869,6 +869,9 @@ struct ieee80211_local {
 		struct dentry *keys;
 	} debugfs;
 #endif
+
+	/* dummy netdev for use w/ NAPI */
+	struct net_device napi_dev;
 };
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ebbe264..827f25d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -187,6 +187,8 @@ static int ieee80211_open(struct net_device *dev)
 		res = drv_start(local);
 		if (res)
 			goto err_del_bss;
+		if (local->ops->napi_poll)
+			napi_enable(&local->hw.napi);
 		/* we're brought up, everything changes */
 		hw_reconf_flags = ~0;
 		ieee80211_led_radio(local, true);
@@ -519,6 +521,8 @@ static int ieee80211_stop(struct net_device *dev)
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
+		if (local->ops->napi_poll)
+			napi_disable(&local->hw.napi);
 		ieee80211_clear_tx_pending(local);
 		ieee80211_stop_device(local);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0e95c75..79ca2ba 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -491,6 +491,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
+	/* init dummy netdev for use w/ NAPI */
+	init_dummy_netdev(&local->napi_dev);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
@@ -680,6 +683,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_ifa;
 #endif
 
+	netif_napi_add(&local->napi_dev, &local->hw.napi, local->ops->napi_poll,
+			local->hw.napi_weight);
+
 	return 0;
 
  fail_ifa:
-- 
1.7.1.1

