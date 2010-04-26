Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22133 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0DZSBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:01:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 11:01:17 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19413.24414.623941.711001@gargle.gargle.HOWL>
Date: Mon, 26 Apr 2010 15:09:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k_htc: Simplify RX IRQ handler
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A bunch of validation and processing in the RX IRQ handler
can be moved to the RX tasklet. The IRQ handler is
already heavy, with the memory allocation for handling
stream mode. Also, a memcpy of 40 bytes for every packet
can be avoided in the handler.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   44 ++++++++++++------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 08bfe5d..28abc7d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,10 +448,32 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ieee80211_hw *hw = priv->hw;
 	struct sk_buff *skb = rxbuf->skb;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath_htc_rx_status *rxstatus;
 	int hdrlen, padpos, padsize;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
 
+	if (skb->len <= HTC_RX_FRAME_HEADER_SIZE) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Corrupted RX frame, dropping\n");
+		goto rx_next;
+	}
+
+	rxstatus = (struct ath_htc_rx_status *)skb->data;
+
+	if (be16_to_cpu(rxstatus->rs_datalen) -
+	    (skb->len - HTC_RX_FRAME_HEADER_SIZE) != 0) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Corrupted RX data len, dropping "
+			  "(dlen: %d, skblen: %d)\n",
+			  rxstatus->rs_datalen, skb->len);
+		goto rx_next;
+	}
+
+	/* Get the RX status information */
+	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
+	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -616,8 +638,6 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_rxbuf *rxbuf = NULL, *tmp_buf = NULL;
-	struct ath_htc_rx_status *rxstatus;
-	u32 len = 0;
 
 	spin_lock(&priv->rx.rxbuflock);
 	list_for_each_entry(tmp_buf, &priv->rx.rxbuf, list) {
@@ -634,27 +654,7 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 		goto err;
 	}
 
-	len = skb->len;
-	if (len <= HTC_RX_FRAME_HEADER_SIZE) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Corrupted RX frame, dropping\n");
-		goto err;
-	}
-
-	rxstatus = (struct ath_htc_rx_status *)skb->data;
-
-	if (be16_to_cpu(rxstatus->rs_datalen) -
-	    (len - HTC_RX_FRAME_HEADER_SIZE) != 0) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Corrupted RX data len, dropping "
-			  "(epid: %d, dlen: %d, skblen: %d)\n",
-			  ep_id, rxstatus->rs_datalen, len);
-		goto err;
-	}
-
 	spin_lock(&priv->rx.rxbuflock);
-	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
-	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
 	rxbuf->skb = skb;
 	rxbuf->in_process = true;
 	spin_unlock(&priv->rx.rxbuflock);
-- 
1.7.0.5

