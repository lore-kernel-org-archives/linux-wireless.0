Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2FGGHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 02:07:45 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Joe Perches <joe@perches.com>
Subject: [PATCH] mac80211: ratelimit few aggregated messages
Date: Thu, 7 Jun 2012 11:32:23 +0530
Message-ID: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120607_080823_079325_EFB6B4DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ratelimit few aggregation related messages, these messages
floods the log when aggregation is disabled in the AP(for some
wifi testcases) and we run traffic between STA and AP.
mac80211 gives up after 15 addba requests, but
ieee80211_start_tx_ba_session will be repeatedly called
by drivers rate control tx_status callback. These net_dbg_ratelimited
messages will be visible only when dynamic debug is enabled for
mac80211 module.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/agg-tx.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index da07f01..c2dc766 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -449,8 +449,11 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
-	ht_vdbg("Open BA session requested for %pM tid %u\n",
-		pubsta->addr, tid);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	net_dbg_ratelimited("Open BA session requested for %pM tid %u\n",
+			    pubsta->addr, tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
@@ -485,8 +488,11 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
 	spin_lock_bh(&sta->lock);
 
-	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		net_dbg_ratelimited("receiver does not wants A-MPDU, maximum addba requests tried for tid %u\n",
+				    tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -EBUSY;
 		goto err_unlock_sta;
 	}
@@ -499,8 +505,10 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_BURST_RETRIES &&
 	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
 			HT_AGG_RETRIES_PERIOD)) {
-		ht_vdbg("BA request denied - waiting a grace period after %d failed requests on tid %u\n",
-			sta->ampdu_mlme.addba_req_num[tid], tid);
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		net_dbg_ratelimited("BA request denied - waiting a grace period after %d failed requests on tid %u\n",
+				    sta->ampdu_mlme.addba_req_num[tid], tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -EBUSY;
 		goto err_unlock_sta;
 	}
-- 
1.7.0.4

