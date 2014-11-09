Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60822 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaKIQur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:47 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so7051261wgh.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:46 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 15/16] mac80211: add specific-queue flushing support
Date: Sun,  9 Nov 2014 18:50:21 +0200
Message-Id: <1415551822-20121-15-git-send-email-arik@wizery.com> (sfid-20141109_181320_776246_89234FB4)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

If the HW supports IEEE80211_HW_QUEUE_CONTROL, allow
flushing only specific queues rather than all of them.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/util.c        | 20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5de2e5f..a30d408 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1881,6 +1881,9 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 				struct sk_buff_head *skbs);
 void ieee80211_flush_queues(struct ieee80211_local *local,
 			    struct ieee80211_sub_if_data *sdata);
+void __ieee80211_flush_queues(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      unsigned int queues);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9e5bfd6..745a8a9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -576,15 +576,19 @@ ieee80211_get_vif_queues(struct ieee80211_local *local,
 	return queues;
 }
 
-void ieee80211_flush_queues(struct ieee80211_local *local,
-			    struct ieee80211_sub_if_data *sdata)
+void __ieee80211_flush_queues(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      unsigned int queues)
 {
-	unsigned int queues;
-
 	if (!local->ops->flush)
 		return;
 
-	queues = ieee80211_get_vif_queues(local, sdata);
+	/*
+	 * If no queue was set, or if the HW doesn't support
+	 * IEEE80211_HW_QUEUE_CONTROL - flush all queues
+	 */
+	if (!queues || !(local->hw.flags & IEEE80211_HW_QUEUE_CONTROL))
+		queues = ieee80211_get_vif_queues(local, sdata);
 
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
@@ -597,6 +601,12 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 					false);
 }
 
+void ieee80211_flush_queues(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata)
+{
+	__ieee80211_flush_queues(local, sdata, 0);
+}
+
 void ieee80211_stop_vif_queues(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata,
 			       enum queue_stop_reason reason)
-- 
1.9.1

