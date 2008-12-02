Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58077 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbYLBNJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 08:09:28 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 05:09:28 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18741.12999.753996.233483@gargle.gargle.HOWL> (sfid-20081202_140932_557935_08D2929B)
Date: Tue, 2 Dec 2008 18:36:15 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using GFP_KERNEL was wrong and produces a 'scheduling while atomic'
bug. Also, check for proper return values now, in case allocation
fails.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index fc52f61..021cc56 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1641,9 +1641,9 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 	}
 }
 
-static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
-				struct sk_buff *skb,
-				struct ath_tx_control *txctl)
+static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
+			       struct sk_buff *skb,
+			       struct ath_tx_control *txctl)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1651,7 +1651,10 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	int hdrlen;
 	__le16 fc;
 
-	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_KERNEL);
+	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
+	if (!tx_info_priv)
+		return -ENOMEM;
+
 	tx_info->rate_driver_data[0] = tx_info_priv;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
@@ -1703,6 +1706,8 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
 					   skb->len, PCI_DMA_TODEVICE);
 	bf->bf_buf_addr = bf->bf_dmacontext;
+
+	return 0;
 }
 
 /* FIXME: tx power */
@@ -1777,6 +1782,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		 struct ath_tx_control *txctl)
 {
+	int ret = 0;
 	struct ath_buf *bf;
 
 	/* Check if a tx buffer is available */
@@ -1787,7 +1793,12 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		return -1;
 	}
 
-	ath_tx_setup_buffer(sc, bf, skb, txctl);
+	ret = ath_tx_setup_buffer(sc, bf, skb, txctl);
+	if (ret) {
+		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
+		return ret;
+	}
+
 	ath_tx_start_dma(sc, bf, txctl);
 
 	return 0;
-- 
1.6.0.3

