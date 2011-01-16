Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65104 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1APF1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:27:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:27:13 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix endian issue in tx header
Date: Sun, 16 Jan 2011 10:56:37 +0530
Message-ID: <1295155597-14247-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index c976600..6354986 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -78,7 +78,7 @@ struct tx_frame_hdr {
 	u8 node_idx;
 	u8 vif_idx;
 	u8 tidno;
-	u32 flags; /* ATH9K_HTC_TX_* */
+	__be32 flags; /* ATH9K_HTC_TX_* */
 	u8 key_type;
 	u8 keyix;
 	u8 reserved[26];
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 33f3602..7a5ffca 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -113,6 +113,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 
 	if (ieee80211_is_data(fc)) {
 		struct tx_frame_hdr tx_hdr;
+		u32 flags = 0;
 		u8 *qc;
 
 		memset(&tx_hdr, 0, sizeof(struct tx_frame_hdr));
@@ -136,13 +137,14 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		/* Check for RTS protection */
 		if (priv->hw->wiphy->rts_threshold != (u32) -1)
 			if (skb->len > priv->hw->wiphy->rts_threshold)
-				tx_hdr.flags |= ATH9K_HTC_TX_RTSCTS;
+				flags |= ATH9K_HTC_TX_RTSCTS;
 
 		/* CTS-to-self */
-		if (!(tx_hdr.flags & ATH9K_HTC_TX_RTSCTS) &&
+		if (!(flags & ATH9K_HTC_TX_RTSCTS) &&
 		    (priv->op_flags & OP_PROTECT_ENABLE))
-			tx_hdr.flags |= ATH9K_HTC_TX_CTSONLY;
+			flags |= ATH9K_HTC_TX_CTSONLY;
 
+		tx_hdr.flags = cpu_to_be32(flags);
 		tx_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
 		if (tx_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
 			tx_hdr.keyix = (u8) ATH9K_TXKEYIX_INVALID;
-- 
1.7.3.5

