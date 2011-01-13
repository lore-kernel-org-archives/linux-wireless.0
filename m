Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46423 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1AMXGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 18:06:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"
Date: Fri, 14 Jan 2011 00:06:27 +0100
Message-Id: <1294959987-69072-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rx error bit parsing was changed to consider PHY errors and various
decryption errors separately. While correct according to the documentation,
this is causing spurious decryption error reports in some situations.

Fix this by restoring the original order of the checks in those places,
where the errors are meant to be mutually exclusive.

If a CRC error is reported, then MIC failure and decryption errors
are irrelevant, and a PHY error is unlikely.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/mac.c        |   14 ++++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 4ceddbb..038a0cb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -615,7 +615,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 		 */
 		if (rxsp->status11 & AR_CRCErr)
 			rxs->rs_status |= ATH9K_RXERR_CRC;
-		if (rxsp->status11 & AR_PHYErr) {
+		else if (rxsp->status11 & AR_PHYErr) {
 			phyerr = MS(rxsp->status11, AR_PHYErrCode);
 			/*
 			 * If we reach a point here where AR_PostDelimCRCErr is
@@ -638,11 +638,11 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 				rxs->rs_phyerr = phyerr;
 			}
 
-		}
-		if (rxsp->status11 & AR_DecryptCRCErr)
+		} else if (rxsp->status11 & AR_DecryptCRCErr)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
-		if (rxsp->status11 & AR_MichaelErr)
+		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
+
 		if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 180170d..c75d40f 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -690,17 +690,23 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		rs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
+		/*
+		 * Treat these errors as mutually exclusive to avoid spurious
+		 * extra error reports from the hardware. If a CRC error is
+		 * reported, then decryption and MIC errors are irrelevant,
+		 * the frame is going to be dropped either way
+		 */
 		if (ads.ds_rxstatus8 & AR_CRCErr)
 			rs->rs_status |= ATH9K_RXERR_CRC;
-		if (ads.ds_rxstatus8 & AR_PHYErr) {
+		else if (ads.ds_rxstatus8 & AR_PHYErr) {
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
-		}
-		if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		if (ads.ds_rxstatus8 & AR_MichaelErr)
+		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+
 		if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
-- 
1.7.3.2

