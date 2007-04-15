Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:56261 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXDOJZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 05:25:29 -0400
From: Ulrich Kunitz <kune@deine-taler.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ulrich Kunitz <kune@deine-taler.de>
Subject: [PATCH] mac80211: add ieee80211_wake_queues()
Date: Sun, 15 Apr 2007 11:25:28 +0200
Message-Id: <11766291282625-git-send-email-kune@deine-taler.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For zd1211rw I need the possibility to wake the tx queues in the
mac80211 stack. Though the mac80211 stack provides the function
ieee80211_stop_queues() there is no function
ieee80211_wake_queues(). This patch adds ieee80211_wake_queues().

The patch includes also a tiny simplification of
ieee80211_stop_queues().

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
---
 include/net/mac80211.h   |    8 ++++++++
 net/mac80211/ieee80211.c |   12 ++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index eb785c9..a0ac4a8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1019,6 +1019,14 @@ void ieee80211_start_queues(struct ieee80211_hw *hw);
 void ieee80211_stop_queues(struct ieee80211_hw *hw);
 
 /**
+ * ieee80211_wake_queues - wake all queues
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ *
+ * Drivers should use this function instead of netif_wake_queue.
+ */
+void ieee80211_wake_queues(struct ieee80211_hw *hw);
+
+/**
  * ieee80211_get_mc_list_item - iteration over items in multicast list
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @prev: value returned by previous call to ieee80211_get_mc_list_item() or
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index b5a62b7..34b7837 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -5048,14 +5048,22 @@ EXPORT_SYMBOL(ieee80211_start_queues);
 
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++)
+	for (i = 0; i < hw->queues; i++)
 		ieee80211_stop_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
+void ieee80211_wake_queues(struct ieee80211_hw *hw)
+{
+	int i;
+
+	for (i = 0; i < hw->queues; i++)
+		ieee80211_wake_queue(hw, i);
+}
+EXPORT_SYMBOL(ieee80211_wake_queues);
+
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata;
-- 
1.5.1.1

