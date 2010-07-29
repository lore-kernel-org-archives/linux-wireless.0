Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35083 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab0G2VP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 17:15:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 1/2] mac80211: support use of NAPI for bottom-half processing
Date: Thu, 29 Jul 2010 17:14:04 -0400
Message-Id: <1280438045-16424-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280435978.3823.20.camel@jlt3.sipsolutions.net>
References: <1280435978.3823.20.camel@jlt3.sipsolutions.net>
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
v2 -> hide napi_struct as suggested by johill

 include/net/mac80211.h     |   24 ++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    5 +++++
 net/mac80211/iface.c       |    4 ++++
 net/mac80211/main.c        |   30 ++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f85fc8a..64171c1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1102,6 +1102,10 @@ enum ieee80211_hw_flags {
  *
  * @max_rates: maximum number of alternate rate retry stages
  * @max_rate_tries: maximum number of tries for each stage
+ *
+ * @napi_weight: weight used for NAPI polling.  You must specify an
+ *	appropriate value here if a napi_poll operation is provided
+ *	by your driver.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1113,6 +1117,7 @@ struct ieee80211_hw {
 	int channel_change_time;
 	int vif_data_size;
 	int sta_data_size;
+	int napi_weight;
 	u16 queues;
 	u16 max_listen_interval;
 	s8 max_signal;
@@ -1687,6 +1692,8 @@ enum ieee80211_ampdu_mlme_action {
  *	switch operation for CSAs received from the AP may implement this
  *	callback. They must then call ieee80211_chswitch_done() to indicate
  *	completion of the channel switch.
+ *
+ * @napi_poll: Poll Rx queue for incoming data frames.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1752,6 +1759,7 @@ struct ieee80211_ops {
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
+	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
 };
 
 /**
@@ -1897,6 +1905,22 @@ void ieee80211_free_hw(struct ieee80211_hw *hw);
  */
 void ieee80211_restart_hw(struct ieee80211_hw *hw);
 
+/** ieee80211_napi_schedule - schedule NAPI poll
+ *
+ * Use this function to schedule NAPI polling on a device.
+ *
+ * @hw: the hardware to start polling
+ */
+void ieee80211_napi_schedule(struct ieee80211_hw *hw);
+
+/** ieee80211_napi_complete - complete NAPI polling
+ *
+ * Use this function to finish NAPI polling on a device.
+ *
+ * @hw: the hardware to stop polling
+ */
+void ieee80211_napi_complete(struct ieee80211_hw *hw);
+
 /**
  * ieee80211_rx - receive frame
  *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 65e0ed6..79d5645 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -870,6 +870,11 @@ struct ieee80211_local {
 		struct dentry *keys;
 	} debugfs;
 #endif
+
+	/* dummy netdev for use w/ NAPI */
+	struct net_device napi_dev;
+
+	struct napi_struct napi;
 };
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ebbe264..c1008a9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -187,6 +187,8 @@ static int ieee80211_open(struct net_device *dev)
 		res = drv_start(local);
 		if (res)
 			goto err_del_bss;
+		if (local->ops->napi_poll)
+			napi_enable(&local->napi);
 		/* we're brought up, everything changes */
 		hw_reconf_flags = ~0;
 		ieee80211_led_radio(local, true);
@@ -519,6 +521,8 @@ static int ieee80211_stop(struct net_device *dev)
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
+		if (local->ops->napi_poll)
+			napi_disable(&local->napi);
 		ieee80211_clear_tx_pending(local);
 		ieee80211_stop_device(local);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7cc4f91..98bb5c0 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -390,6 +390,30 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 }
 #endif
 
+static int ieee80211_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ieee80211_local *local =
+		container_of(napi, struct ieee80211_local, napi);
+
+	return local->ops->napi_poll(&local->hw, budget);
+}
+
+void ieee80211_napi_schedule(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	napi_schedule(&local->napi);
+}
+EXPORT_SYMBOL(ieee80211_napi_schedule);
+
+void ieee80211_napi_complete(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	napi_complete(&local->napi);
+}
+EXPORT_SYMBOL(ieee80211_napi_complete);
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -494,6 +518,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
 
+	/* init dummy netdev for use w/ NAPI */
+	init_dummy_netdev(&local->napi_dev);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
@@ -683,6 +710,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_ifa;
 #endif
 
+	netif_napi_add(&local->napi_dev, &local->napi, ieee80211_napi_poll,
+			local->hw.napi_weight);
+
 	return 0;
 
  fail_ifa:
-- 
1.7.1.1

