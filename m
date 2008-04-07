Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbYDGRQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 13:16:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: BA session debug prints changes
Date: Mon,  7 Apr 2008 10:16:56 -0700
Message-Id: <1207588616-30489-1-git-send-email-reinette.chatre@intel.com> (sfid-20080407_181706_887830_EAF6997A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch contains next issues:
1 - prevents "stop BA session" multiple warnings
2 - adds debug print to stop Rx BA session flow
3 - adds EOL in one debug print

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/ieee80211.c     |   18 ++++++++----------
 net/mac80211/ieee80211_sta.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 5d30dd4..b3cf69e 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -700,11 +700,6 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Stop a BA session requested for %s tid %u\n",
-				print_mac(mac, ra), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
 	rcu_read_lock();
 	sta = sta_info_get(local, ra);
 	if (!sta) {
@@ -717,14 +712,15 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw,
 	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 
 	if (*state != HT_AGG_STATE_OPERATIONAL) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "Try to stop Tx aggregation on"
-				" non active TID\n");
-#endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -ENOENT;
 		goto stop_BA_exit;
 	}
 
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Tx BA session stop requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
 	ieee80211_stop_queue(hw, sta->tid_to_tx_q[tid]);
 
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
@@ -809,8 +805,10 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 		return;
 	}
 
-	printk(KERN_DEBUG "Stop a BA session requested on DA %s tid %d\n",
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Stopping Tx BA session for %s tid %d\n",
 				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	rcu_read_lock();
 	sta = sta_info_get(local, ra);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 833b225..5120e38 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1281,7 +1281,7 @@ static void ieee80211_sta_process_addba_request(struct net_device *dev,
 		ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_START,
 					       sta->addr, tid, &start_seq_num);
 #ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Rx A-MPDU on tid %d result %d", tid, ret);
+	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (ret) {
@@ -1436,6 +1436,7 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
 	int ret, i;
+	DECLARE_MAC_BUF(mac);
 
 	rcu_read_lock();
 
@@ -1456,12 +1457,17 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	sta->ampdu_mlme.tid_state_rx[tid] =
 		HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+	spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
 
 	/* stop HW Rx aggregation. ampdu_action existence
 	 * already verified in session init so we add the BUG_ON */
 	BUG_ON(!local->ops->ampdu_action);
 
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Rx BA session stop requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
 	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
 					ra, tid, NULL);
 	if (ret)
-- 
1.5.3.4

