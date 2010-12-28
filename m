Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41239 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab0L1OqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 09:46:25 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k_hw: fix dma descriptor rx error bit parsing
Date: Tue, 28 Dec 2010 15:46:16 +0100
Message-Id: <1293547576-88801-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An Rx DMA descriptor can have multiple error bits set, and some error
bits (e.g. MIC failure) are filtered by the driver based on other criteria.
Remove the 'else' in various error bit checks so that all error information
is properly passed to the driver.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   11 ++++++-----
 drivers/net/wireless/ath/ath9k/mac.c        |    9 +++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index b6e4ee4..4ceddbb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -613,9 +613,9 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 		 * possibly be reviewing the last subframe. AR_CRCErr
 		 * is the CRC of the actual data.
 		 */
-		if (rxsp->status11 & AR_CRCErr) {
+		if (rxsp->status11 & AR_CRCErr)
 			rxs->rs_status |= ATH9K_RXERR_CRC;
-		} else if (rxsp->status11 & AR_PHYErr) {
+		if (rxsp->status11 & AR_PHYErr) {
 			phyerr = MS(rxsp->status11, AR_PHYErrCode);
 			/*
 			 * If we reach a point here where AR_PostDelimCRCErr is
@@ -638,11 +638,12 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 				rxs->rs_phyerr = phyerr;
 			}
 
-		} else if (rxsp->status11 & AR_DecryptCRCErr) {
+		}
+		if (rxsp->status11 & AR_DecryptCRCErr)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
-		} else if (rxsp->status11 & AR_MichaelErr) {
+		if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		} else if (rxsp->status11 & AR_KeyMiss)
+		if (rxsp->status11 & AR_KeyMiss)
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e3d2ebf..180170d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -692,15 +692,16 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
 		if (ads.ds_rxstatus8 & AR_CRCErr)
 			rs->rs_status |= ATH9K_RXERR_CRC;
-		else if (ads.ds_rxstatus8 & AR_PHYErr) {
+		if (ads.ds_rxstatus8 & AR_PHYErr) {
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
-		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		}
+		if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		else if (ads.ds_rxstatus8 & AR_MichaelErr)
+		if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-		else if (ads.ds_rxstatus8 & AR_KeyMiss)
+		if (ads.ds_rxstatus8 & AR_KeyMiss)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
-- 
1.7.3.2

