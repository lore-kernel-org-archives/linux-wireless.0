Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32808 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2EYPhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 11:37:13 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] mac80211: net_ratelimit few aggregation related messages
Date: Fri, 25 May 2012 21:07:04 +0530
Message-ID: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120525_173719_799137_66353F55)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

net_ratelimit few aggregation related messages, these messages
floods the log when aggregation is disabled for some wifi
test cases in the AP side. mac80211 gives up after 15 addba
requests, but ieee80211_start_tx_ba_session will be
repeatedly called by drivers rate control tx_status callback

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/agg-tx.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 7cf0715..d9fb5ef 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -464,8 +464,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
-	       pubsta->addr, tid);
+	if (net_ratelimit())
+		printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
+		       pubsta->addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
@@ -506,8 +507,10 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
 	spin_lock_bh(&sta->lock);
 
-	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "receiver does not wants A-MPDU, maximum addba requests tried for tid %u",
+			       tid);
 		ret = -EBUSY;
 		goto err_unlock_sta;
 	}
@@ -521,10 +524,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
 			HT_AGG_RETRIES_PERIOD)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - "
-		       "waiting a grace period after %d failed requests "
-		       "on tid %u\n",
-		       sta->ampdu_mlme.addba_req_num[tid], tid);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "BA request denied waiting a grace period after %d failed requests on tid %u\n",
+			       sta->ampdu_mlme.addba_req_num[tid], tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -EBUSY;
 		goto err_unlock_sta;
@@ -534,8 +536,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	/* check if the TID is not in aggregation flow already */
 	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "BA request denied - session is not "
-				 "idle on tid %u\n", tid);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "BA request denied - session is not idle on tid %u\n",
+			       tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		ret = -EAGAIN;
 		goto err_unlock_sta;
-- 
1.7.0.4

