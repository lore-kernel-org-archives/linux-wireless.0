Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51226 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZCTKBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:01:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 03:01:52 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k: Nuke struct ath_xmit_status
Date: Fri, 20 Mar 2009 15:27:50 +0530
Message-ID: <1237543070-25471-2-git-send-email-vasanth@atheros.com> (sfid-20090320_110154_775560_06473ABC)
In-Reply-To: <1237543070-25471-1-git-send-email-vasanth@atheros.com>
References: <1237543070-25471-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    4 ----
 drivers/net/wireless/ath9k/xmit.c  |   25 ++++++++-----------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index ffaebc1..10cd96a 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -295,13 +295,9 @@ struct ath_tx_control {
 	enum ath9k_internal_frame_type frame_type;
 };
 
-struct ath_xmit_status {
-	int retries;
-	int flags;
 #define ATH_TX_ERROR        0x01
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
-};
 
 /* All RSSI values are noise floor adjusted */
 struct ath_tx_stat {
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 21e90bc..689bdbf 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1750,7 +1750,7 @@ exit:
 /*****************/
 
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-			    struct ath_xmit_status *tx_status)
+			    int tx_flags)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -1771,12 +1771,10 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		tx_info->rate_driver_data[0] = NULL;
 	}
 
-	if (tx_status->flags & ATH_TX_BAR) {
+	if (tx_flags & ATH_TX_BAR)
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-		tx_status->flags &= ~ATH_TX_BAR;
-	}
 
-	if (!(tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
+	if (!(tx_flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
@@ -1803,29 +1801,22 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				int txok, int sendbar)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
-	struct ath_xmit_status tx_status;
 	unsigned long flags;
+	int tx_flags = 0;
 
-	/*
-	 * Set retry information.
-	 * NB: Don't use the information in the descriptor, because the frame
-	 * could be software retried.
-	 */
-	tx_status.retries = bf->bf_retries;
-	tx_status.flags = 0;
 
 	if (sendbar)
-		tx_status.flags = ATH_TX_BAR;
+		tx_flags = ATH_TX_BAR;
 
 	if (!txok) {
-		tx_status.flags |= ATH_TX_ERROR;
+		tx_flags |= ATH_TX_ERROR;
 
 		if (bf_isxretried(bf))
-			tx_status.flags |= ATH_TX_XRETRY;
+			tx_flags |= ATH_TX_XRETRY;
 	}
 
 	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
-	ath_tx_complete(sc, skb, &tx_status);
+	ath_tx_complete(sc, skb, tx_flags);
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
-- 
1.5.5.1

