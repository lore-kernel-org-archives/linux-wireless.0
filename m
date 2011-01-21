Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47645 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1AUDES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:18 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so1251567iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:18 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63364.704614.856827@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:33:32 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 29/33] ath9k_htc: Fix RX length check
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
index 1b629fd..9913ef0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -528,8 +528,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
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
1.7.3.5

