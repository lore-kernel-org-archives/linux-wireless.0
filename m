Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:58565
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753086Ab0DTI2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 04:28:36 -0400
From: Johan Hovold <johan.hovold@lundinova.se>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Johan Hovold <johan.hovold@lundinova.se>
Subject: [RFC][PATCH 1/2] ath9k: fix corrupt frames being forwarded to mac80211
Date: Tue, 20 Apr 2010 10:28:07 +0200
Message-Id: <1271752088-13639-1-git-send-email-johan.hovold@lundinova.se>
In-Reply-To: <20100420082519.GB5288@lundinova.se>
References: <20100420082519.GB5288@lundinova.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frame status frequently gets corrupted in hardware with 802.11n which
can lead to corrupt frames being forwarded to mac80211. This in turn may
trigger countermeasures in reponse to false MIC-errors or cause receive
to stall when frames are dropped after processing a frame with corrupt PN.

Verify frame status by making sure that no error flags are set if frame
is marked ok and that reserved bits 19 through 28 (0x1ff80000) are all
zero, otherwise discarded frame (as ATH9K_PHYERR_HT_CRC_ERROR).

Tested with AR9280 (WEP, TKIP and CCMP).

Signed-off-by: Johan Hovold <johan.hovold@lundinova.se>
---
 drivers/net/wireless/ath/ath9k/mac.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 4a2060e..2afe72f 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -934,9 +934,22 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+	} else {
+		if (ads.ds_rxstatus8 & (AR_CRCErr |
+					AR_PHYErr |
+					AR_DecryptCRCErr |
+					AR_MichaelErr |
+					AR_DecryptBusyErr))
+			goto corrupt;
 	}
+	if (ads.ds_rxstatus8 & 0x1ff80000)
+		goto corrupt;
 
 	return 0;
+corrupt:
+	rs->rs_status |= ATH9K_RXERR_PHY;
+	rs->rs_phyerr = ATH9K_PHYERR_HT_CRC_ERROR;
+	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_rxprocdesc);
 
-- 
1.7.0.3

