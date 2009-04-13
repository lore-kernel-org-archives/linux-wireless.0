Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54196 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZDMQa5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:30:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:30:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26554.365030.596582@gargle.gargle.HOWL> (sfid-20090413_183059_891989_FBE82A9F)
Date: Mon, 13 Apr 2009 21:56:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/11] ath9k: Fix memleak on TX DMA failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver-specific region has to be freed in case
of a DMA mapping failure.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 628b780..faf2cab 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1572,8 +1572,9 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 					   skb->len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
 		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"dma_mapping_error() on TX\n");
+		kfree(tx_info_priv);
+		tx_info->rate_driver_data[0] = NULL;
+		DPRINTF(sc, ATH_DBG_FATAL, "dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
-- 
1.6.2.2

