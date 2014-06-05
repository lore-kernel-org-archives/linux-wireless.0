Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaFEQ3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:29:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: add functions to stop and wake all queues assigned to a vif
Date: Thu,  5 Jun 2014 19:26:06 +0300
Message-Id: <1401985567-27336-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140605_182952_626288_45D61A73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In some cases we may want to stop the queues of a single vif (for
instance during a channel-switch).  Add a function that stops all the
queues that are assigned to a vif.  If a queue is assigned to more
than one vif, the corresponding netdev subqueue of the other vif(s)
will also be stopped.  If the HW doesn't set the
IEEE80211_HW_QUEUE_CONTROL flag, then all queues are stopped.

Also add a corresponding function to wake the queues of a vif back.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/util.c        | 38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c9309db..2f995b1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1736,6 +1736,12 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
 				     enum queue_stop_reason reason);
+void ieee80211_stop_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason);
+void ieee80211_wake_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6d29e40..f1e751d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -529,14 +529,11 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-void ieee80211_flush_queues(struct ieee80211_local *local,
-			    struct ieee80211_sub_if_data *sdata)
+static int ieee80211_get_vif_queues(struct ieee80211_local *local,
+				    struct ieee80211_sub_if_data *sdata)
 {
 	u32 queues;
 
-	if (!local->ops->flush)
-		return;
-
 	if (sdata && local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
 		int ac;
 
@@ -551,6 +548,19 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 		queues = BIT(local->hw.queues) - 1;
 	}
 
+	return queues;
+}
+
+void ieee80211_flush_queues(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata)
+{
+	u32 queues;
+
+	if (!local->ops->flush)
+		return;
+
+	queues = ieee80211_get_vif_queues(local, sdata);
+
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 
@@ -560,6 +570,24 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 }
 
+void ieee80211_stop_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason)
+{
+	ieee80211_stop_queues_by_reason(&local->hw,
+					ieee80211_get_vif_queues(local, sdata),
+					reason);
+}
+
+void ieee80211_wake_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason)
+{
+	ieee80211_wake_queues_by_reason(&local->hw,
+					ieee80211_get_vif_queues(local, sdata),
+					IEEE80211_QUEUE_STOP_REASON_DRIVER);
+}
+
 static void __iterate_active_interfaces(struct ieee80211_local *local,
 					u32 iter_flags,
 					void (*iterator)(void *data, u8 *mac,
-- 
1.9.1

