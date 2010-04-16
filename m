Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:18977
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756682Ab0DPKwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:52:46 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Tor Krill <tor@excito.com>,
	Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 5/6] ath9k: check error flags even if rx frame is marked ok
Date: Fri, 16 Apr 2010 12:52:14 +0200
Message-Id: <1271415135-18317-5-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100416104850.GA13329@lundinova.se>
References: <20100416104850.GA13329@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check error flags even if frame is marked ok by hardware as this flag
may have been incorrectly set.

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---

00000000: 88 41 30 00 00 80 48 68 08 af 00 b9 49 c3 e1 3f
00000010: 5a 9d 51 71 09 63 00 50 00 00 00 00 ff 54 00 20
00000020: 36 9d 46 02 90 31 2c e8 68 06 84 6e b5 00 29 e8
00000030: ef e3 6f a0 ee 99 7c 7e d8 7d 12 aa de 5c 20 69
00000040: d6 6a ad c4 99 bb c1 e4 c3 ba bd 77 51 7f a2 a5
00000050: 01 e4 81 a0 be 40 54 45 70 e4 cc 11 58 f8 ad 45
00000060: 84 1c 72 36 a1 fd b7 33 ad aa 4f 8b
rxstatus8 = 5994daab

Here AR_RxFrameOK is set even though AR_DecryptCRCErr and AR_MichaelErr are
set.

Note that this also happens for frames with non-corrupt PNs, e.g.: 

FrameOK with error: c79e7573
FrameOK with error: 264786bf
FrameOK with error: f3a2446f
FrameOK with error: 2c054c4f

 drivers/net/wireless/ath/ath9k/mac.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 891a294..2b4295b 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -925,18 +925,16 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 	if (ads.ds_rxstatus8 & AR_KeyMiss)
 		rs->rs_flags |= ATH9K_RX_KEY_MISS;
 
-	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
-		if (ads.ds_rxstatus8 & AR_CRCErr)
-			rs->rs_status |= ATH9K_RXERR_CRC;
-		else if (ads.ds_rxstatus8 & AR_PHYErr) {
-			rs->rs_status |= ATH9K_RXERR_PHY;
-			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
-			rs->rs_phyerr = phyerr;
-		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
-			rs->rs_status |= ATH9K_RXERR_DECRYPT;
-		else if (ads.ds_rxstatus8 & AR_MichaelErr)
-			rs->rs_status |= ATH9K_RXERR_MIC;
-	}
+	if (ads.ds_rxstatus8 & AR_CRCErr)
+		rs->rs_status |= ATH9K_RXERR_CRC;
+	else if (ads.ds_rxstatus8 & AR_PHYErr) {
+		rs->rs_status |= ATH9K_RXERR_PHY;
+		phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
+		rs->rs_phyerr = phyerr;
+	} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		rs->rs_status |= ATH9K_RXERR_DECRYPT;
+	else if (ads.ds_rxstatus8 & AR_MichaelErr)
+		rs->rs_status |= ATH9K_RXERR_MIC;
 
 	return 0;
 }
-- 
1.7.0.3

