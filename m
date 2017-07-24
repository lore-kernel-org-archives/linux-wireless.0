Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48047 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752875AbdGXIqp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 04:46:45 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: fix more-data flag for buffered multicast packets
Date: Mon, 24 Jul 2017 10:46:43 +0200
Message-Id: <20170724084643.90789-1-nbd@nbd.name> (sfid-20170724_104649_284747_EBF6DD5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag needs to be cleared for the last packet in the list, not the
first one. Fixes some issues with multicast packet loss for powersave
clients connected to an ath9k AP.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 30efe79e9d89..2f663e19f2b9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2451,7 +2451,6 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		.txq = sc->beacon.cabq
 	};
 	struct ath_tx_info info = {};
-	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf_tail = NULL;
 	struct ath_buf *bf;
 	LIST_HEAD(bf_q);
@@ -2495,14 +2494,8 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (list_empty(&bf_q))
 		return;
 
-	bf = list_first_entry(&bf_q, struct ath_buf, list);
-	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
-
-	if (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_MOREDATA)) {
-		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
-			sizeof(*hdr), DMA_TO_DEVICE);
-	}
+	bf = list_last_entry(&bf_q, struct ath_buf, list);
+	ath9k_set_moredata(sc, bf, false);
 
 	ath_txq_lock(sc, txctl.txq);
 	ath_tx_fill_desc(sc, bf, txctl.txq, 0);
-- 
2.13.0
