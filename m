Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64039 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3HZIxj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 04:53:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/4] ath10k: synchronize tx/rx reporting to mac80211
Date: Mon, 26 Aug 2013 10:53:22 +0200
Message-ID: <1377507205-5386-2-git-send-email-michal.kazior@tieto.com> (sfid-20130826_105344_149927_A9046CF3)
In-Reply-To: <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
 <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to mac80211 docs tx and rx reporting
routines must not run concurrently unless they are
_irqsafe variants.

This doesn't fix any visible bug but is apparently
the right thing to do as per the documentation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    1 +
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 drivers/net/wireless/ath/ath10k/txrx.c |    4 ++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 04c132e..b43e8ad 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -526,6 +526,7 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
+	spin_lock_init(&ar->txrx_lock);
 
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ab05c4c..0469a2e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -392,6 +392,9 @@ struct ath10k {
 	u32 survey_last_cycle_count;
 	struct survey_info survey[ATH10K_NUM_CHANS];
 
+	/* synchronized tx/rx reporting to mac80211 */
+	spinlock_t txrx_lock;
+
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 68b6fae..ce7e304 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -88,7 +88,9 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt, struct sk_buff *txdesc)
 	if (ATH10K_SKB_CB(txdesc)->htt.no_ack)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
+	spin_lock_bh(&htt->ar->txrx_lock);
 	ieee80211_tx_status(htt->ar->hw, msdu);
+	spin_unlock_bh(&htt->ar->txrx_lock);
 	/* we do not own the msdu anymore */
 
 exit:
@@ -294,7 +296,9 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		   status->freq,
 		   status->band);
 
+	spin_lock_bh(&ar->txrx_lock);
 	ieee80211_rx(ar->hw, info->skb);
+	spin_unlock_bh(&ar->txrx_lock);
 }
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
-- 
1.7.9.5

