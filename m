Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49718 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1K2C1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 21:27:16 -0500
Received: by qao25 with SMTP id 25so4176qao.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 18:27:15 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH] mac80211: reset addba retries after timeout
Date: Mon, 28 Nov 2011 21:27:05 -0500
Message-Id: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com> (sfid-20111129_032719_396777_36A0D329)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
requests. When this limit is reached aggregation is turned off for
given TID permanently. This doesn't seem right: three requests is
not that much, some 'blackout' can happen, but effect of it affects
whole connection indefinitely.
  This patch adds a period of time (1 minute) after which counter of
sent addba requests is reset so addba requests can be sent again.
  The traffic impact should be negligible, but connection will be more
stable.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-tx.c   |   21 ++++++++++++++++++---
 net/mac80211/sta_info.h |    3 +++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..521638c 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -339,6 +339,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 #endif
 
 	spin_lock_bh(&sta->lock);
+	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies_to_msecs(jiffies);
 	sta->ampdu_mlme.addba_req_num[tid]++;
 	spin_unlock_bh(&sta->lock);
 
@@ -389,10 +390,24 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 
 	spin_lock_bh(&sta->lock);
 
-	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
-		ret = -EBUSY;
-		goto err_unlock_sta;
+		unsigned int timestamp = jiffies_to_msecs(jiffies);
+		if (timestamp - sta->ampdu_mlme.last_addba_req_time[tid] >
+		    HT_AGG_RETRIES_PERIOD) {
+			/*
+			 * last addba attempt was more then
+			 * HT_AGG_RETRIES_PERIOD time ago,
+			 * we can start trying again now
+			 */
+			sta->ampdu_mlme.addba_req_num[tid] = 0;
+		} else {
+			/*
+			 * we have tried too many times,
+			 * receiver does not want A-MPDU (yet)
+			 */
+			ret = -EBUSY;
+			goto err_unlock_sta;
+		}
 	}
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6280e8b..a16d60a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -76,6 +76,7 @@ enum ieee80211_sta_info_flags {
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
 #define HT_AGG_MAX_RETRIES		0x3
+#define HT_AGG_RETRIES_PERIOD		(60*1000)
 
 #define HT_AGG_STATE_DRV_READY		0
 #define HT_AGG_STATE_RESPONSE_RECEIVED	1
@@ -169,6 +170,7 @@ struct tid_ampdu_rx {
  * @tid_tx: aggregation info for Tx per TID
  * @tid_start_tx: sessions where start was requested
  * @addba_req_num: number of times addBA request has been sent.
+ * @last_addba_req_time: timestamp of the last addBA request.
  * @dialog_token_allocator: dialog token enumerator for each new session;
  * @work: work struct for starting/stopping aggregation
  * @tid_rx_timer_expired: bitmap indicating on which TIDs the
@@ -188,6 +190,7 @@ struct sta_ampdu_mlme {
 	struct work_struct work;
 	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
 	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
+	unsigned int last_addba_req_time[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
 };
-- 
1.7.4.1

