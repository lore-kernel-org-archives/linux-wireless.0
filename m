Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24069 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2B0QAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 11:00:37 -0500
From: "Chadd, Adrian" <achadd@qca.qualcomm.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] ath9k: decouple RX error checking for DFS
Date: Mon, 27 Feb 2012 16:00:35 +0000
Message-ID: <48EC4E8D43A28947B1AB2639FA97CDB901524852@nasanexd02a.na.qualcomm.com> (sfid-20120227_170041_253807_759CF23E)
References: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Hm, so the AR9003 series NICs set PHY error _and_ decrypt/CRC error? On radar frames?

Interesting! Have you checked to see if the AR9280 does the same?



Adrian
________________________________________
From: Zefir Kurtisi [zefir.kurtisi@neratec.com]
Sent: Monday, 27 February 2012 3:52 AM
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org; Rodriguez, Luis; Chadd, Adrian; Zefir Kurtisi
Subject: [PATCH] ath9k: decouple RX error checking for DFS

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
-               else if (rxsp->status11 & AR_PHYErr) {
+               else if (rxsp->status11 & AR_DecryptCRCErr)
+                       rxs->rs_status |= ATH9K_RXERR_DECRYPT;
+               else if (rxsp->status11 & AR_MichaelErr)
+                       rxs->rs_status |= ATH9K_RXERR_MIC;
+               if (rxsp->status11 & AR_PHYErr) {
                        phyerr = MS(rxsp->status11, AR_PHYErrCode);
                        /*
                         * If we reach a point here where AR_PostDelimCRCErr is
@@ -552,11 +556,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
                                rxs->rs_status |= ATH9K_RXERR_PHY;
                                rxs->rs_phyerr = phyerr;
                        }
-
-               } else if (rxsp->status11 & AR_DecryptCRCErr)
-                       rxs->rs_status |= ATH9K_RXERR_DECRYPT;
-               else if (rxsp->status11 & AR_MichaelErr)
-                       rxs->rs_status |= ATH9K_RXERR_MIC;
+               };
        }

        if (rxsp->status11 & AR_KeyMiss)
--
1.7.4.1

