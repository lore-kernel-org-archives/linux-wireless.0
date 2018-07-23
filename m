Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53694 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbeGWRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/9] ath9k: fix moredata bit in PS buffered frame release
Date: Mon, 23 Jul 2018 18:02:55 +0200
Message-Id: <20180723160300.58024-4-nbd@nbd.name> (sfid-20180723_180334_297283_304485D4)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7fdb152be0bb..cab24b43ac88 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1659,6 +1659,22 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
+
+static void
+ath9k_set_moredata(struct ath_softc *sc, struct ath_buf *bf, bool val)
+{
+	struct ieee80211_hdr *hdr;
+	u16 mask = cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	u16 mask_val = mask * val;
+
+	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
+	if ((hdr->frame_control & mask) != mask_val) {
+		hdr->frame_control = (hdr->frame_control & ~mask) | mask_val;
+		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+			sizeof(*hdr), DMA_TO_DEVICE);
+	}
+}
+
 void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   struct ieee80211_sta *sta,
 				   u16 tids, int nframes,
@@ -1689,6 +1705,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 			if (!bf)
 				break;
 
+			ath9k_set_moredata(sc, bf, true);
 			list_add_tail(&bf->list, &bf_q);
 			ath_set_rates(tid->an->vif, tid->an->sta, bf);
 			if (bf_isampdu(bf)) {
@@ -1712,6 +1729,9 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 	if (list_empty(&bf_q))
 		return;
 
+	if (!more_data)
+		ath9k_set_moredata(sc, bf_tail, false);
+
 	info = IEEE80211_SKB_CB(bf_tail->bf_mpdu);
 	info->flags |= IEEE80211_TX_STATUS_EOSP;
 
-- 
2.17.0
