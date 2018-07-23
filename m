Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53672 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbeGWRFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:12 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 9/9] ath9k: fix more-data flag for buffered multicast packets
Date: Mon, 23 Jul 2018 18:03:00 +0200
Message-Id: <20180723160300.58024-9-nbd@nbd.name> (sfid-20180723_180333_728756_B8FCD6A9)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag needs to be cleared for the last packet in the list, not the
first one. Fixes some issues with multicast packet loss for powersave
clients connected to an ath9k AP.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index bae0f6c045e1..43b6c8508e49 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2436,7 +2436,6 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		.txq = sc->beacon.cabq
 	};
 	struct ath_tx_info info = {};
-	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf_tail = NULL;
 	struct ath_buf *bf;
 	LIST_HEAD(bf_q);
@@ -2480,15 +2479,10 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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
 
+	bf = list_first_entry(&bf_q, struct ath_buf, list);
 	ath_txq_lock(sc, txctl.txq);
 	ath_tx_fill_desc(sc, bf, txctl.txq, 0);
 	ath_tx_txqaddbuf(sc, txctl.txq, &bf_q, false);
-- 
2.17.0
