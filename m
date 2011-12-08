Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:35685 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750983Ab1LHGoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 01:44:17 -0500
Date: Thu, 8 Dec 2011 12:11:30 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mac80211: Purge A-MPDU TX queues before station
 destructions
Message-ID: <20111208064124.GA4406@hertz.marvell.com> (sfid-20111208_074421_606738_7A47FCF3)
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
---
 net/mac80211/sta_info.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

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

