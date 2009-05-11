Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbZEKJZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 05:25:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 3/5] mac80211: fix idle trigger upon resume
Date: Mon, 11 May 2009 05:25:02 -0400
Message-Id: <1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we suspend we stop the queues, then upon resume
the new idle checks will immediately pick up we're
idle and ask call our driver's config callback. At
this point its pointless to to call this callback
as we haven't yet come back from suspend. We avoid
then making assumptions about being idle until we know
we've come back from suspend. We do this by checking
the reason stop on all our queues.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |    5 +++++
 net/mac80211/util.c        |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 03e0d22..b8f3013 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1099,6 +1099,8 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
+bool ieee80211_any_queues_stopped_by_reason(struct ieee80211_hw *hw,
+					    enum queue_stop_reason reason);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8c9f1c7..f8eefad 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -931,6 +931,11 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
 
+	/* allow resume to finish before we make any assumptions */
+	if (ieee80211_any_queues_stopped_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_SUSPEND))
+		return 0;
+
 	if (local->hw_scanning || local->sw_scanning)
 		return ieee80211_idle_off(local, "scanning");
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 97b613a..3f82d51 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -447,6 +447,45 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 }
 EXPORT_SYMBOL(ieee80211_queue_stopped);
 
+static bool __ieee80211_queues_stopped_by_reason(struct ieee80211_hw *hw,
+						 int queue,
+						 enum queue_stop_reason reason)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (WARN_ON(queue >= hw->queues))
+		return false;
+
+	if (!local->queue_stop_reasons[queue])
+		return false;
+
+	if (test_bit(reason, &local->queue_stop_reasons[queue]))
+		return true;
+
+	return false;
+}
+
+bool ieee80211_any_queues_stopped_by_reason(struct ieee80211_hw *hw,
+					    enum queue_stop_reason reason)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	unsigned long flags;
+	unsigned int i;
+	bool queue_match = false;
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
+	for (i = 0; i < hw->queues; i++) {
+		if (__ieee80211_queues_stopped_by_reason(hw, i, reason))
+			queue_match = true;
+	}
+
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	return queue_match;
+}
+EXPORT_SYMBOL(ieee80211_any_queues_stopped_by_reason);
+
+
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason)
 {
-- 
1.6.0.6

