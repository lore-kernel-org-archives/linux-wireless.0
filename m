Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:58570
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753474Ab0DTI2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 04:28:44 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 2/2] ath9k: use also AR_DecryptBusyErr to determine decrypt errors
Date: Tue, 20 Apr 2010 10:28:08 +0200
Message-Id: <1271752088-13639-2-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100420082519.GB5288@lundinova.se>
References: <20100420082519.GB5288@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent non-decrypted frames with DecryptBusyErr flag set to be marked
decrypted.

Have seen such a frame with status 0x40030bc1 (due to bit error?).

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---
 drivers/net/wireless/ath/ath9k/mac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 2afe72f..780da87 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -930,7 +930,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			rs->rs_phyerr = phyerr;
-		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
+		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr ||
+				ads.ds_rxstatus8 & AR_DecryptBusyErr)
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-- 
1.7.0.3

