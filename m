Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33736 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1GSWCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:02:17 -0400
Subject: [PATCH] carl9170: fix sparse warnings enabled by
 CONFIG_SPARSE_RCU_POINTER
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 19 Jul 2011 18:02:15 -0400
Message-ID: <20110719220215.11336.250.stgit@mj.roinet.com> (sfid-20110720_000220_556971_9CD6E4B6)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index d5c35fe..c5427a7 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -177,7 +177,7 @@ struct carl9170_tx_queue_stats {
 
 struct carl9170_vif {
 	unsigned int id;
-	struct ieee80211_vif *vif;
+	struct ieee80211_vif __rcu *vif;
 };
 
 struct carl9170_vif_info {
@@ -311,7 +311,7 @@ struct ar9170 {
 	spinlock_t beacon_lock;
 	unsigned int global_pretbtt;
 	unsigned int global_beacon_int;
-	struct carl9170_vif_info *beacon_iter;
+	struct carl9170_vif_info __rcu *beacon_iter;
 	unsigned int beacon_enabled;
 
 	/* cryptographic engine */
@@ -389,7 +389,7 @@ struct ar9170 {
 	/* tx ampdu */
 	struct work_struct ampdu_work;
 	spinlock_t tx_ampdu_list_lock;
-	struct carl9170_sta_tid *tx_ampdu_iter;
+	struct carl9170_sta_tid __rcu *tx_ampdu_iter;
 	struct list_head tx_ampdu_list;
 	atomic_t tx_ampdu_upload;
 	atomic_t tx_ampdu_scheduler;
@@ -456,7 +456,7 @@ struct carl9170_sta_info {
 	bool sleeping;
 	atomic_t pending_frames;
 	unsigned int ampdu_max_len;
-	struct carl9170_sta_tid *agg[CARL9170_NUM_TID];
+	struct carl9170_sta_tid __rcu *agg[CARL9170_NUM_TID];
 	struct carl9170_ba_stats stats[CARL9170_NUM_TID];
 };
 
