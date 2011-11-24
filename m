Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KXTGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:06:18 -0500
Subject: [PATCH] mac80211: don't stop a single aggregation session twice
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nikolay Martynov <mar.kolya@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 20:06:14 +0100
Message-ID: <1322161574.5366.55.camel@jlt3.sipsolutions.net> (sfid-20111124_200621_006204_D45AD97B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Nikolay noticed (by code review) that mac80211 can
attempt to stop an aggregation session while it is
already being stopped. So to fix it, check whether
stop is already being done and bail out if so.

Also move setting the STOPPING state into the lock
so things are properly atomic.

Cc: stable@vger.kernel.org
Reported-by: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mac80211/agg-tx.c	2011-11-24 20:03:36.000000000 +0100
+++ b/net/mac80211/agg-tx.c	2011-11-24 20:03:49.000000000 +0100
@@ -162,6 +162,12 @@ int ___ieee80211_stop_tx_ba_session(stru
 		return -ENOENT;
 	}
 
+	/* if we're already stopping ignore any new requests to stop */
+	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+		spin_unlock_bh(&sta->lock);
+		return -EALREADY;
+	}
+
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/* not even started yet! */
 		ieee80211_assign_tid_tx(sta, tid, NULL);
@@ -170,6 +176,8 @@ int ___ieee80211_stop_tx_ba_session(stru
 		return 0;
 	}
 
+	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
+
 	spin_unlock_bh(&sta->lock);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -177,8 +185,6 @@ int ___ieee80211_stop_tx_ba_session(stru
 	       sta->sta.addr, tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
-	set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);
-
 	del_timer_sync(&tid_tx->addba_resp_timer);
 
 	/*


