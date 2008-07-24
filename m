Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:46467 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYGXSDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 14:03:12 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: [old MQ] add ieee80211_queue_stopped)
Date: Thu, 24 Jul 2008 21:02:05 +0300
Message-Id: <1216922525-29150-2-git-send-email-tomas.winkler@intel.com> (sfid-20080724_200317_360259_5300B066)
In-Reply-To: <1216922525-29150-1-git-send-email-tomas.winkler@intel.com>
References: <1216922525-29150-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds ieee80211_queue_stopped that let drivers to query
queue status

This version should support back porting by compat-wireless

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/util.c    |   12 ++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 24a69f6..f78209b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1619,6 +1619,16 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue);
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue);
 
 /**
+ * ieee80211_queue_stopped - test status of the queue
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @queue: queue number (counted from zero).
+ *
+ * Drivers should use this function instead of netif_stop_queue.
+ */
+
+int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue);
+
+/**
  * ieee80211_stop_queues - stop all queues
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 02af3e8..ab9538e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -396,6 +396,18 @@ void ieee80211_stop_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 
+int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	if (ieee80211_is_multiqueue(local)) {
+		return __netif_subqueue_stopped(local->mdev, queue);
+	} else {
+		WARN_ON(queue != 0);
+		return netif_queue_stopped(local->mdev);
+	}
+}
+EXPORT_SYMBOL(ieee80211_queue_stopped);
+
 void ieee80211_wake_queues(struct ieee80211_hw *hw)
 {
 	int i;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

