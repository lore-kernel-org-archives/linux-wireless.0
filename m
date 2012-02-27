Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41448 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2B0LwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 06:52:16 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: decouple RX error checking for DFS
Date: Mon, 27 Feb 2012 12:52:06 +0100
Message-Id: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120227_125220_004921_7479B042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous RX error checking was done exclusive-or for different error
types and caused DFS pulse events to be dropped when other error
flags (e.g. CRC) were set simultaneously.

This patch decouples PHY error processing from other types and ensures
that all pulses detected by HW are accounted by the pattern detector.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..92e0042 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -530,7 +530,11 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 		 */
 		if (rxsp->status11 & AR_CRCErr)
 			rxs->rs_status |= ATH9K_RXERR_CRC;
-		else if (rxsp->status11 & AR_PHYErr) {
+		else if (rxsp->status11 & AR_DecryptCRCErr)
+			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
+		else if (rxsp->status11 & AR_MichaelErr)
+			rxs->rs_status |= ATH9K_RXERR_MIC;
+		if (rxsp->status11 & AR_PHYErr) {
 			phyerr = MS(rxsp->status11, AR_PHYErrCode);
 			/*
 			 * If we reach a point here where AR_PostDelimCRCErr is
@@ -552,11 +556,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 				rxs->rs_status |= ATH9K_RXERR_PHY;
 				rxs->rs_phyerr = phyerr;
 			}
-
-		} else if (rxsp->status11 & AR_DecryptCRCErr)
-			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
-		else if (rxsp->status11 & AR_MichaelErr)
-			rxs->rs_status |= ATH9K_RXERR_MIC;
+		};
 	}
 
 	if (rxsp->status11 & AR_KeyMiss)
-- 
1.7.4.1

