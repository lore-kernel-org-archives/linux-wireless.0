Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab2LTNl3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:41:29 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mac80211: properly stop/wake queues before/after off-channel
Date: Thu, 20 Dec 2012 14:41:19 +0100
Message-Id: <1356010879-10054-2-git-send-email-sgruszka@redhat.com> (sfid-20121220_144135_978357_0252CBD0)
In-Reply-To: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
References: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not assume driver will not stop some queue during off-channel.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/offchannel.c  |   19 +++++--------------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 63c5d9f..4302494 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -830,6 +830,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index a3ad4c3..0fdbe75 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -132,7 +132,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			netif_tx_stop_all_queues(sdata->dev);
+			ieee80211_stop_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
 			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
@@ -164,19 +165,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local)
 		    sdata->u.mgd.associated)
 			ieee80211_offchannel_ps_disable(sdata);
 
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			/*
-			 * This may wake up queues even though the driver
-			 * currently has them stopped. This is not very
-			 * likely, since the driver won't have gotten any
-			 * (or hardly any) new packets while we weren't
-			 * on the right channel, and even if it happens
-			 * it will at most lead to queueing up one more
-			 * packet per queue in mac80211 rather than on
-			 * the interface qdisc.
-			 */
-			netif_tx_wake_all_queues(sdata->dev);
-		}
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+			ieee80211_wake_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL);
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-- 
1.7.1

