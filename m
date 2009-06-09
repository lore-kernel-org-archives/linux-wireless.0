Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45250 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbZFIIr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:47:59 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 01:48:02 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] mac80211: Fix the way ADDBA request count being modified
Date: Tue, 9 Jun 2009 14:11:46 +0530
Message-ID: <1244536906-22335-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

addba_req_num[tid] is supposed to have the count of consecutive
addba request attempts on 'tid' which failed. This count is checked
against a retry threshold (3 times) before starting the addba negotiation.
This patch fixes the way this addba count is incremented/reset and thereby
avoids indefinite addba attempts.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/agg-tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 43d00ff..9e5762a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -132,6 +132,9 @@ static int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
+	if (*state == HT_AGG_STATE_OPERATIONAL)
+		sta->ampdu_mlme.addba_req_num[tid] = 0;
+
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
@@ -337,6 +340,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 			 sta->ampdu_mlme.tid_tx[tid]->dialog_token,
 			 sta->ampdu_mlme.tid_tx[tid]->ssn,
 			 0x40, 5000);
+	sta->ampdu_mlme.addba_req_num[tid]++;
 	/* activate the timer for the recipient's addBA response */
 	sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer.expires =
 				jiffies + ADDBA_RESP_INTERVAL;
@@ -606,7 +610,6 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 
 	*state = HT_AGG_STATE_IDLE;
 	/* from now on packets are no longer put onto sta->pending */
-	sta->ampdu_mlme.addba_req_num[tid] = 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
 
@@ -689,7 +692,6 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 		sta->ampdu_mlme.addba_req_num[tid] = 0;
 	} else {
-		sta->ampdu_mlme.addba_req_num[tid]++;
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	}
 	spin_unlock_bh(&sta->lock);
-- 
1.5.5.1

