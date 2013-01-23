Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52607 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AWQiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 11:38:24 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, sven@open-mesh.com,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 3/4] ath9k: reorder error codes for spectral
Date: Wed, 23 Jan 2013 17:38:06 +0100
Message-Id: <1358959087-24897-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130123_173828_978182_75EB09DA)
In-Reply-To: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using the spectral scan feature, frames with phy errors are
returned for further processing to the driver. However, if the frames
also have an invalid CRC (which seems to happen quite often), the frame
is marked with bad CRC and not with the PHY error bit. The FFT
processing function will thus miss the frames.

Fix this by changing the precedence in error marking.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/mac.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index b42be91..811007e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -605,13 +605,13 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		 * reported, then decryption and MIC errors are irrelevant,
 		 * the frame is going to be dropped either way
 		 */
-		if (ads.ds_rxstatus8 & AR_CRCErr)
-			rs->rs_status |= ATH9K_RXERR_CRC;
-		else if (ads.ds_rxstatus8 & AR_PHYErr) {
+		if (ads.ds_rxstatus8 & AR_PHYErr) {
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
-		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		} else if (ads.ds_rxstatus8 & AR_CRCErr)
+			rs->rs_status |= ATH9K_RXERR_CRC;
+		else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-- 
1.7.10.4

