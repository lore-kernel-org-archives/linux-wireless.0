Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48005 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751021Ab1LHJ07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:26:59 -0500
Date: Thu, 8 Dec 2011 14:56:15 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] mac80211: Purge A-MPDU TX queues before station
 destructions
Message-ID: <20111208092608.GA4981@hertz.marvell.com> (sfid-20111208_102705_943598_D5C9AFE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station leaves suddenly while ampdu traffic to that station is still
running, there is a possibility that the ampdu pending queues are not freed due
to a race condition leading to memory leaks. In '__sta_info_destroy' when we
attempt to destroy the ampdu sessions in 'ieee80211_sta_tear_down_BA_sessions',
the driver calls 'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu
structures (tid_tx) and splice the pending queues and this job gets queued in
sdata workqueue. However, the sta entry can get destroyed before the above work
gets scheduled and hence the race.

Purging the queues and freeing the tid_tx to avoid the leak. The better solution
would be to fix the race, but that can be taken up in a separate patch.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>

v2: Adding note for driver authors as suggested by Johannes.
---
 net/mac80211/agg-tx.c   |    2 ++
 net/mac80211/sta_info.c |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 7380287..4bb33b8 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -55,6 +55,8 @@
  * @ampdu_action function will be called with the action
  * %IEEE80211_AMPDU_TX_STOP. In this case, the call must not fail,
  * and the driver must later call ieee80211_stop_tx_ba_cb_irqsafe().
+ * Note that the sta can get destroyed before the BA tear down is
+ * complete.
  */
 
 static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f982352..c6ca9bd 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -851,6 +851,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int ret, i, ac;
+	struct tid_ampdu_tx *tid_tx;
 
 	might_sleep();
 
@@ -949,6 +950,30 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	}
 #endif
 
+	/* There could be some memory leaks because of ampdu tx pending queue
+	 * not being freed before destroying the station info.
+	 *
+	 * Make sure that such queues are purged before freeing the station
+	 * info.
+	 * TODO: We have to somehow postpone the full destruction
+	 * until the aggregation stop completes. Refer
+	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
+	 */
+	for (i = 0; i < STA_TID_NUM; i++) {
+		if (!sta->ampdu_mlme.tid_tx[i])
+			continue;
+		tid_tx = sta->ampdu_mlme.tid_tx[i];
+		if (skb_queue_len(&tid_tx->pending)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			wiphy_debug(local->hw.wiphy, "TX A-MPDU  purging %d "
+				"packets for tid=%d\n",
+				skb_queue_len(&tid_tx->pending), i);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+			__skb_queue_purge(&tid_tx->pending);
+		}
+		kfree_rcu(tid_tx, rcu_head);
+	}
+
 	__sta_info_free(local, sta);
 
 	return 0;
-- 
1.5.4.1

