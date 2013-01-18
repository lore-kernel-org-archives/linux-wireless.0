Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ARXBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 18:01:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: fix aggregation state with older drivers
Date: Sat, 19 Jan 2013 00:01:22 +0100
Message-Id: <1358550082-24185-1-git-send-email-johannes@sipsolutions.net> (sfid-20130119_000105_716434_54602D73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For drivers that don't actually flush their queues when
aggregation stop with the IEEE80211_AMPDU_TX_STOP_FLUSH
or IEEE80211_AMPDU_TX_STOP_FLUSH_CONT reasons is done,
like iwlwifi or iwlegacy, mac80211 can then transmit on
a TID that the driver still considers busy. This happens
in the following way:

 - IEEE80211_AMPDU_TX_STOP_FLUSH requested
 - driver marks TID as emptying
 - mac80211 removes tid_tx data, this can copy packets
   to the TX pending queues and also let new packets
   through to the driver
 - driver gets unexpected TX as it wasn't completely
   converted to the new API

In iwlwifi, this lead to the following warning:

WARNING: at drivers/net/wireless/iwlwifi/dvm/tx.c:442 iwlagn_tx_skb+0xc47/0xce0
Tx while agg.state = 4
Modules linked in: [...]
Pid: 0, comm: kworker/0:0 Tainted: G        W   3.1.0 #1
Call Trace:
 [<c1046e42>] warn_slowpath_common+0x72/0xa0
 [<c1046f13>] warn_slowpath_fmt+0x33/0x40
 [<fddffa17>] iwlagn_tx_skb+0xc47/0xce0 [iwldvm]
 [<fddfcaa3>] iwlagn_mac_tx+0x23/0x40 [iwldvm]
 [<fd8c98b6>] __ieee80211_tx+0xf6/0x3c0 [mac80211]
 [<fd8cbe00>] ieee80211_tx+0xd0/0x100 [mac80211]
 [<fd8cc176>] ieee80211_xmit+0x96/0xe0 [mac80211]
 [<fd8cc578>] ieee80211_subif_start_xmit+0x348/0xc80 [mac80211]
 [<c1445207>] dev_hard_start_xmit+0x337/0x6d0
 [<c145eee9>] sch_direct_xmit+0xa9/0x210
 [<c14462c0>] dev_queue_xmit+0x1b0/0x8e0

Fortunately, solving this problem is easy as the station
is being destroyed, so such transmit packets can only
happen due to races. Instead of trying to close the race
just let the race not reach the drivers by making two
changes:
 1) remove the explicit aggregation session teardown in
    the managed mode code, the same thing will be done
    when the station is removed, in __sta_info_destroy.
 2) When aggregation stop with AGG_STOP_DESTROY_STA is
    requested, leave the tid_tx data around as stopped.
    It will be cleared and freed in cleanup_single_sta
    later, but until then any racy packets will be put
    onto the tid_tx pending queue instead of transmitted
    which is fine since the station is being removed.

Change-Id: I0ebd814e720a3e734d73f37c1fabef5eb34a2101
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 17 ++++++++++-------
 net/mac80211/mlme.c   |  9 ---------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 2f0ccbc..e6e1056 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -296,7 +296,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
 				       &sta->sta, tid, NULL, 0);
 		WARN_ON_ONCE(ret);
-		goto remove_tid_tx;
+		return 0;
 	}
 
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
@@ -354,12 +354,15 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		 */
 	}
 
-	if (reason == AGG_STOP_DESTROY_STA) {
- remove_tid_tx:
-		spin_lock_bh(&sta->lock);
-		ieee80211_remove_tid_tx(sta, tid);
-		spin_unlock_bh(&sta->lock);
-	}
+	/*
+	 * In the case of AGG_STOP_DESTROY_STA, the driver won't
+	 * necessarily call ieee80211_stop_tx_ba_cb(), so this may
+	 * seem like we can leave the tid_tx data pending forever.
+	 * This is true, in a way, but "forever" is only until the
+	 * station struct is actually destroyed. In the meantime,
+	 * leaving it around ensures that we don't transmit packets
+	 * to the driver on this TID which might confuse it.
+	 */
 
 	return 0;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d90c07b..ed029ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1489,7 +1489,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
 	u32 changed = 0;
 
 	ASSERT_MGD_MTX(ifmgd);
@@ -1521,14 +1520,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	netif_tx_stop_all_queues(sdata->dev);
 	netif_carrier_off(sdata->dev);
 
-	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get(sdata, ifmgd->bssid);
-	if (sta) {
-		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
-		ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
-	}
-	mutex_unlock(&local->sta_mtx);
-
 	/*
 	 * if we want to get out of ps before disassoc (why?) we have
 	 * to do it before sending disassoc, as otherwise the null-packet
-- 
1.8.0

