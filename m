Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:60201 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbaFMNaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri, 13 Jun 2014 16:30:06 +0300
Message-Id: <1402666207-2257-4-git-send-email-luca@coelho.fi> (sfid-20140613_153049_461218_DB459595)
In-Reply-To: <1402666207-2257-1-git-send-email-luca@coelho.fi>
References: <1402666207-2257-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 3/4] mac80211: add functions to stop and wake all queues assigned to a vif
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
---
In v2:

  * use unsigned int instead of u32 for the queues variables;
  * pass reason instead of IEEE80211_QUEUE_STOP_REASON_DRIVER in
    wake_vif_queues();
  * rebase on top of the new refcounted stop/wake queues;
---
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/util.c        | 41 +++++++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f2b59c6..dd3086d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1719,6 +1719,12 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
 				     enum queue_stop_reason reason,
 				     bool refcounted);
+void ieee80211_stop_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason);
+void ieee80211_wake_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason);
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
 				     enum queue_stop_reason reason,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8552fe4..4978b62 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -552,13 +552,11 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-void ieee80211_flush_queues(struct ieee80211_local *local,
-			    struct ieee80211_sub_if_data *sdata)
+static unsigned int
+ieee80211_get_vif_queues(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata)
 {
-	u32 queues;
-
-	if (!local->ops->flush)
-		return;
+	unsigned int queues;
 
 	if (sdata && local->hw.flags & IEEE80211_HW_QUEUE_CONTROL) {
 		int ac;
@@ -574,6 +572,19 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 		queues = BIT(local->hw.queues) - 1;
 	}
 
+	return queues;
+}
+
+void ieee80211_flush_queues(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata)
+{
+	unsigned int queues;
+
+	if (!local->ops->flush)
+		return;
+
+	queues = ieee80211_get_vif_queues(local, sdata);
+
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
 					false);
@@ -585,6 +596,24 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 					false);
 }
 
+void ieee80211_stop_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason)
+{
+	ieee80211_stop_queues_by_reason(&local->hw,
+					ieee80211_get_vif_queues(local, sdata),
+					reason, true);
+}
+
+void ieee80211_wake_vif_queues(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       enum queue_stop_reason reason)
+{
+	ieee80211_wake_queues_by_reason(&local->hw,
+					ieee80211_get_vif_queues(local, sdata),
+					reason, true);
+}
+
 static void __iterate_active_interfaces(struct ieee80211_local *local,
 					u32 iter_flags,
 					void (*iterator)(void *data, u8 *mac,
-- 
2.0.0.rc2

