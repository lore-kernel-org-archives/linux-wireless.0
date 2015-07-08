Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:4306 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbbGHMmH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] mac80211: TDLS: handle chan-switch in RTNL locked work
Date: Wed,  8 Jul 2015 15:41:45 +0300
Message-Id: <1436359312-26533-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144215_639516_EA96E6EB)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Move TDLS channel-switch Rx handling into an RTNL locked work. This is
required to add proper regulatory checking to incoming channel-switch
requests.
Queue incoming requests in a dedicated skb queue and handle the request
in a device-specific work to avoid deadlocking on interface removal.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  8 +++++---
 net/mac80211/iface.c       |  2 --
 net/mac80211/main.c        |  5 +++++
 net/mac80211/rx.c          |  5 ++---
 net/mac80211/tdls.c        | 34 ++++++++++++++++++++++++++++++++--
 5 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 90580e9..36f217e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1008,7 +1008,6 @@ enum sdata_queue_type {
 	IEEE80211_SDATA_QUEUE_AGG_STOP		= 2,
 	IEEE80211_SDATA_QUEUE_RX_AGG_START	= 3,
 	IEEE80211_SDATA_QUEUE_RX_AGG_STOP	= 4,
-	IEEE80211_SDATA_QUEUE_TDLS_CHSW		= 5,
 };
 
 enum {
@@ -1351,6 +1350,10 @@ struct ieee80211_local {
 
 	/* extended capabilities provided by mac80211 */
 	u8 ext_capa[8];
+
+	/* TDLS channel switch */
+	struct work_struct tdls_chsw_work;
+	struct sk_buff_head skb_queue_tdls_chsw;
 };
 
 static inline struct ieee80211_sub_if_data *
@@ -2054,9 +2057,8 @@ int ieee80211_tdls_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 					  struct net_device *dev,
 					  const u8 *addr);
-void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb);
 void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata);
+void ieee80211_tdls_chsw_work(struct work_struct *wk);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ed1edac..e648ea8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1242,8 +1242,6 @@ static void ieee80211_iface_work(struct work_struct *work)
 							WLAN_BACK_RECIPIENT, 0,
 							false);
 			mutex_unlock(&local->sta_mtx);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_TDLS_CHSW) {
-			ieee80211_process_tdls_channel_switch(sdata, skb);
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dba0a86..ff79a13 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -629,6 +629,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	INIT_WORK(&local->sched_scan_stopped_work,
 		  ieee80211_sched_scan_stopped_work);
 
+	INIT_WORK(&local->tdls_chsw_work, ieee80211_tdls_chsw_work);
+
 	spin_lock_init(&local->ack_status_lock);
 	idr_init(&local->ack_status_frames);
 
@@ -645,6 +647,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
+	skb_queue_head_init(&local->skb_queue_tdls_chsw);
 
 	ieee80211_alloc_led_names(local);
 
@@ -1161,6 +1164,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
+	cancel_work_sync(&local->tdls_chsw_work);
 	flush_work(&local->sched_scan_stopped_work);
 
 	ieee80211_clear_tx_pending(local);
@@ -1171,6 +1175,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 		wiphy_warn(local->hw.wiphy, "skb_queue not empty\n");
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
+	skb_queue_purge(&local->skb_queue_tdls_chsw);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3a14628..f673304 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2410,9 +2410,8 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		    tf->category == WLAN_CATEGORY_TDLS &&
 		    (tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_REQUEST ||
 		     tf->action_code == WLAN_TDLS_CHANNEL_SWITCH_RESPONSE)) {
-			rx->skb->pkt_type = IEEE80211_SDATA_QUEUE_TDLS_CHSW;
-			skb_queue_tail(&sdata->skb_queue, rx->skb);
-			ieee80211_queue_work(&rx->local->hw, &sdata->work);
+			skb_queue_tail(&local->skb_queue_tdls_chsw, rx->skb);
+			schedule_work(&local->tdls_chsw_work);
 			if (rx->sta)
 				rx->sta->rx_packets++;
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 20c9dbd..91e86bf 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -12,6 +12,7 @@
 #include <linux/ieee80211.h>
 #include <linux/log2.h>
 #include <net/cfg80211.h>
+#include <linux/rtnetlink.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
@@ -1800,12 +1801,15 @@ out:
 	return ret;
 }
 
-void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb)
+static void
+ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
+				      struct sk_buff *skb)
 {
 	struct ieee80211_tdls_data *tf = (void *)skb->data;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
+	ASSERT_RTNL();
+
 	/* make sure the driver supports it */
 	if (!(wiphy->features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH))
 		return;
@@ -1847,3 +1851,29 @@ void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata)
 	}
 	rcu_read_unlock();
 }
+
+void ieee80211_tdls_chsw_work(struct work_struct *wk)
+{
+	struct ieee80211_local *local =
+		container_of(wk, struct ieee80211_local, tdls_chsw_work);
+	struct ieee80211_sub_if_data *sdata;
+	struct sk_buff *skb;
+	struct ieee80211_tdls_data *tf;
+
+	rtnl_lock();
+	while ((skb = skb_dequeue(&local->skb_queue_tdls_chsw))) {
+		tf = (struct ieee80211_tdls_data *)skb->data;
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata) ||
+			    sdata->vif.type != NL80211_IFTYPE_STATION ||
+			    !ether_addr_equal(tf->da, sdata->vif.addr))
+				continue;
+
+			ieee80211_process_tdls_channel_switch(sdata, skb);
+			break;
+		}
+
+		kfree_skb(skb);
+	}
+	rtnl_unlock();
+}
-- 
2.1.4

