Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56117 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab2ANOIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 09:08:48 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.3] ath9k_hw: fix interpretation of the rx KeyMiss flag
Date: Sat, 14 Jan 2012 15:08:34 +0100
Message-Id: <1326550114-76278-1-git-send-email-nbd@openwrt.org> (sfid-20120114_150851_546358_6C18D00C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documentation states that the KeyMiss flag is only valid if RxFrameOK is
unset, however empirical evidence has shown that this is false.
When KeyMiss is set (and RxFrameOK is 1), the hardware passes a valid frame
which has not been decrypted. The driver then falsely marks the frame
as decrypted, and when using CCMP this corrupts the rx CCMP PN, leading
to connection hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++--
 drivers/net/wireless/ath/ath9k/mac.c        |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 88c81c5..09b8c9d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -557,10 +557,11 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		if (rxsp->status11 & AR_KeyMiss)
-			rxs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
+	if (rxsp->status11 & AR_KeyMiss)
+		rxs->rs_status |= ATH9K_RXERR_KEYMISS;
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_process_rxdesc_edma);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index fd3f19c..e196aba 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -618,10 +618,11 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-		if (ads.ds_rxstatus8 & AR_KeyMiss)
-			rs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
+	if (ads.ds_rxstatus8 & AR_KeyMiss)
+		rs->rs_status |= ATH9K_RXERR_KEYMISS;
+
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_rxprocdesc);
-- 
1.7.3.2

