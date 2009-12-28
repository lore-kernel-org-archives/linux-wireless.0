Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZL1I5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 03:57:22 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH V2] mac80211: quit addba_resp_timer if Tx BA session is torn down
Date: Mon, 28 Dec 2009 16:57:15 +0800
Message-Id: <1261990635-29016-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make addba_resp_timer aware the HT_AGG_STATE_REQ_STOP_BA_MSK mask
so that when ___ieee80211_stop_tx_ba_session() is issued the timer
will quit. Otherwise when suspend happens before the timer expired,
the timer handler will be called immediately after resume and
messes up driver status.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/agg-tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ceda366..a57bd73 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -179,7 +179,8 @@ static void sta_addba_resp_timer_expired(unsigned long data)
 
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->lock);
-	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=
+	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK |
+		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=
 						HT_ADDBA_REQUESTED_MSK) {
 		spin_unlock_bh(&sta->lock);
 		*state = HT_AGG_STATE_IDLE;
-- 
1.6.3.3

