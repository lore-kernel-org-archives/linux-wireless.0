Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49883 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1LIDnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 22:43:50 -0500
Received: by vcbfk14 with SMTP id fk14so2000505vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 19:43:49 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v2] mac80211: split addba retries in time
Date: Thu,  8 Dec 2011 22:43:41 -0500
Message-Id: <1323402221-9869-1-git-send-email-mar.kolya@gmail.com> (sfid-20111209_044354_093812_5AADEA34)
In-Reply-To: <1323162576.4696.4.camel@jlt3.sipsolutions.net>
References: <1323162576.4696.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
requests. When this limit is reached aggregation is turned off for
given TID permanently. This doesn't seem right: three requests is
not that much, some 'blackout' can happen, but effect of it affects
whole connection indefinitely.
  This patch increases number of retries to 15. Also, when there have
been 3 or more retries it splits further retries apart by 15 seconds
instead of sending them in very short period of time.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-tx.c   |   19 +++++++++++++++++++
 net/mac80211/sta_info.h |    6 +++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 7380287..7060c8f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -390,6 +390,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 #endif
 
 	spin_lock_bh(&sta->lock);
+	sta->ampdu_mlme.last_addba_req_time[tid] = jiffies;
 	sta->ampdu_mlme.addba_req_num[tid]++;
 	spin_unlock_bh(&sta->lock);
 
@@ -490,6 +491,24 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		goto err_unlock_sta;
 	}
 
+	/*
+	 * if we have tried more than HT_AGG_BURST_RETRIES times we
+	 * will spread our requests in time to avoid stalling connection
+	 * for too long
+	 */
+	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_BURST_RETRIES &&
+	    time_before(jiffies, sta->ampdu_mlme.last_addba_req_time[tid] +
+			HT_AGG_RETRIES_PERIOD)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - "
+		       "waiting a grace period after %d failed requests "
+		       "on tid %u\n",
+		       sta->ampdu_mlme.addba_req_num[tid], tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		ret = -EBUSY;
+		goto err_unlock_sta;
+	}
+
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
 	/* check if the TID is not in aggregation flow already */
 	if (tid_tx || sta->ampdu_mlme.tid_start_tx[tid]) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1a14fab..c8578eb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -75,7 +75,9 @@ enum ieee80211_sta_info_flags {
 
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
-#define HT_AGG_MAX_RETRIES		0x3
+#define HT_AGG_MAX_RETRIES		15
+#define HT_AGG_BURST_RETRIES		3
+#define HT_AGG_RETRIES_PERIOD		(15 * HZ)
 
 #define HT_AGG_STATE_DRV_READY		0
 #define HT_AGG_STATE_RESPONSE_RECEIVED	1
@@ -171,6 +173,7 @@ struct tid_ampdu_rx {
  * @tid_tx: aggregation info for Tx per TID
  * @tid_start_tx: sessions where start was requested
  * @addba_req_num: number of times addBA request has been sent.
+ * @last_addba_req_time: timestamp of the last addBA request.
  * @dialog_token_allocator: dialog token enumerator for each new session;
  * @work: work struct for starting/stopping aggregation
  * @tid_rx_timer_expired: bitmap indicating on which TIDs the
@@ -190,6 +193,7 @@ struct sta_ampdu_mlme {
 	struct work_struct work;
 	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
 	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
+	unsigned int last_addba_req_time[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
 	u8 dialog_token_allocator;
 };
-- 
1.7.4.1

