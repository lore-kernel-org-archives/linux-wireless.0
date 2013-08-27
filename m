Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3H0JiM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 05:38:12 -0400
Date: Tue, 27 Aug 2013 11:36:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: change beacon/connection polling
Message-ID: <20130827093635.GD5548@redhat.com> (sfid-20130827_113816_452565_F9C7378E)
References: <20130823065200.GA3835@redhat.com>
 <1377264280.14021.29.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377264280.14021.29.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since when we detect baecon lost we do active AP probing (using nullfunc
frame or probe request) there is no need to have beacon polling. Flags
IEEE80211_STA_BEACON_POLL seems to be used just for historical reasons.

Change also make that after we start connection poll due to beacon loss,
next received beacon will abort the poll.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 correct subject and changelog

 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |   38 +++++++++-----------------------------
 net/mac80211/scan.c        |    3 +--
 3 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b618651..d353c64 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -322,7 +322,6 @@ struct ieee80211_roc_work {
 
 /* flags used in struct ieee80211_if_managed.flags */
 enum ieee80211_sta_flags {
-	IEEE80211_STA_BEACON_POLL	= BIT(0),
 	IEEE80211_STA_CONNECTION_POLL	= BIT(1),
 	IEEE80211_STA_CONTROL_PORT	= BIT(2),
 	IEEE80211_STA_DISABLE_HT	= BIT(4),
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2aab130..23694b7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -893,8 +893,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL))
+	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 
 	ieee80211_tx_skb(sdata, skb);
@@ -1374,8 +1373,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 	if (!mgd->associated)
 		return false;
 
-	if (mgd->flags & (IEEE80211_STA_BEACON_POLL |
-			  IEEE80211_STA_CONNECTION_POLL))
+	if (mgd->flags & IEEE80211_STA_CONNECTION_POLL)
 		return false;
 
 	if (!mgd->have_beacon)
@@ -1691,8 +1689,7 @@ static void __ieee80211_stop_poll(struct ieee80211_sub_if_data *sdata)
 {
 	lockdep_assert_held(&sdata->local->mtx);
 
-	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
-				IEEE80211_STA_BEACON_POLL);
+	sdata->u.mgd.flags &= ~IEEE80211_STA_CONNECTION_POLL;
 	ieee80211_run_deferred_scan(sdata->local);
 }
 
@@ -1954,11 +1951,8 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	mutex_lock(&local->mtx);
-	if (!(ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			      IEEE80211_STA_CONNECTION_POLL))) {
-		mutex_unlock(&local->mtx);
-		return;
-	}
+	if (!(ifmgd->flags & IEEE80211_STA_CONNECTION_POLL))
+		goto out;
 
 	__ieee80211_stop_poll(sdata);
 
@@ -2094,15 +2088,9 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	 * because otherwise we would reset the timer every time and
 	 * never check whether we received a probe response!
 	 */
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL))
+	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
 		already = true;
 
-	if (beacon)
-		ifmgd->flags |= IEEE80211_STA_BEACON_POLL;
-	else
-		ifmgd->flags |= IEEE80211_STA_CONNECTION_POLL;
-
 	mutex_unlock(&sdata->local->mtx);
 
 	if (already)
@@ -3069,17 +3057,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (ifmgd->flags & IEEE80211_STA_BEACON_POLL) {
+	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
 		mlme_dbg_ratelimited(sdata,
 				     "cancelling AP probe due to a received beacon\n");
-		mutex_lock(&local->mtx);
-		ifmgd->flags &= ~IEEE80211_STA_BEACON_POLL;
-		ieee80211_run_deferred_scan(local);
-		mutex_unlock(&local->mtx);
-
-		mutex_lock(&local->iflist_mtx);
-		ieee80211_recalc_ps(local, -1);
-		mutex_unlock(&local->iflist_mtx);
+		ieee80211_reset_ap_probe(sdata);
 	}
 
 	/*
@@ -3548,8 +3529,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
 
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
-			    IEEE80211_STA_CONNECTION_POLL) &&
+	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL &&
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 		int max_tries;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 08afe74..ecb57b0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -391,8 +391,7 @@ static bool ieee80211_can_scan(struct ieee80211_local *local,
 		return false;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    sdata->u.mgd.flags & (IEEE80211_STA_BEACON_POLL |
-				  IEEE80211_STA_CONNECTION_POLL))
+	    sdata->u.mgd.flags & IEEE80211_STA_CONNECTION_POLL)
 		return false;
 
 	return true;
-- 
1.7.1

