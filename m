Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1DMFvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:51:55 -0400
Received: by pzk9 with SMTP id 9so107951pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:51:54 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14987.142612.37729@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:24:19 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 13/40] ath9k_htc: Fix RX length check
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
1.7.4.4

