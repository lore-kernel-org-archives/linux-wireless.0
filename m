Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52089 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0INRLd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:11:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_hw: handle rx key miss
Date: Tue, 14 Sep 2010 18:38:26 +0200
Message-Id: <1284482306-58024-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If AR_KeyMiss is set in the rx descriptor and AR_RxFrameOK is unset,
the hardware could not locate a valid key during a decryption attempt.

In this case, the frame must not be reported as decrypted, otherwise
mac80211 sees only random garbage.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 ++-
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index a462da2..3b424ca 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -616,7 +616,8 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		} else if (rxsp->status11 & AR_MichaelErr) {
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		}
+		} else if (rxsp->status11 & AR_KeyMiss)
+			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 0b7d125..3efda8a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -714,6 +714,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		else if ((ads.ds_rxstatus8 & AR_MichaelErr) &&
 		         rs->rs_keyix != ATH9K_RXKEYIX_INVALID)
 			rs->rs_status |= ATH9K_RXERR_MIC;
+		else if (ads.ds_rxstatus8 & AR_KeyMiss)
+			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 	}
 
 	return 0;
-- 
1.7.2.2

