Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22586 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab0ETVr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 17:47:27 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 14:47:27 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Fix bug in accessing skb->data of rx frame for edma
Date: Thu, 20 May 2010 14:47:28 -0700
Message-ID: <1274392048-16281-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip the rx status portion in skb->data before accessing ieee80211
frame header.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 512b3f0..95f1622 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1091,6 +1091,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int dma_type;
+	u8 rx_status_len = ah->caps.rx_status_len;
 
 	if (edma)
 		dma_type = DMA_FROM_DEVICE;
@@ -1118,7 +1119,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (!skb)
 			continue;
 
-		hdr = (struct ieee80211_hdr *) skb->data;
+		hdr = (struct ieee80211_hdr *) (skb->data + rx_status_len);
 		rxs =  IEEE80211_SKB_RXCB(skb);
 
 		hw = ath_get_virt_hw(sc, hdr);
-- 
1.7.0.4

