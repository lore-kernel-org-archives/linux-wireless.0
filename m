Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40265 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab1CGCN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:56 -0500
Received: by mail-pw0-f46.google.com with SMTP id 15so692257pwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:13:56 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16219.455263.765424@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:43:47 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 11/34] ath9k_htc: Fix RX length check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The length of the received SKB could be equal to
HTC_RX_FRAME_HEADER_SIZE in case of packets with phy/crc errors,
in which case they are dropped without being processed.
Fix this check so that the error counters are updated correctly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a62495d..7cd3e4e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -525,8 +525,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
 	__le16 fc;
 
-	if (skb->len <= HTC_RX_FRAME_HEADER_SIZE) {
-		ath_err(common, "Corrupted RX frame, dropping\n");
+	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
+		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
+			skb->len);
 		goto rx_next;
 	}
 
-- 
1.7.4.1

