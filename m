Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45327 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab1GKNDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 09:03:09 -0400
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH 1/1] ath9k_hw: Fix incorrect key_miss handling
Date: Tue, 12 Jul 2011 00:02:56 +0530
Message-ID: <1310409176-3083-1-git-send-email-senthilb@qca.qualcomm.com> (sfid-20110711_150314_896417_4563AAE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Decryping frames on key_miss handling shouldn't be done for Michael
MIC failed frames as h/w would have already decrypted such frames
successfully anyway.

Also leaving CRC and PHY error(where the frame is going to be dropped
anyway), we are left to prcoess Decrypt error for which s/w decrypt is
selected anway and so having key_miss as a separate check doesn't serve
anything. So making key_miss handling mutually exlusive with other RX
status handling makes much more sense.

This patch addresses an issue with STA not reporting MIC failure events
resulting in STA being disconnected immediately.

Cc: stable@kernel.org
Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 +--
 drivers/net/wireless/ath/ath9k/mac.c        |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 575e185..8ff0b88 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -625,8 +625,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-
-		if (rxsp->status11 & AR_KeyMiss)
+		else if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c2091f1..b6b523a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -645,8 +645,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-
-		if (ads.ds_rxstatus8 & AR_KeyMiss)
+		else if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
-- 
1.7.4.4

