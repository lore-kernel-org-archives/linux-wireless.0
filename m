Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53252 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1JHUDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 16:03:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/2] ath9k_hw: fix a regression in key miss handling
Date: Sat,  8 Oct 2011 22:02:58 +0200
Message-Id: <1318104179-90126-1-git-send-email-nbd@openwrt.org> (sfid-20111008_220314_335145_806FFB94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k_hw: Fix incorrect key_miss handling" changed the code
to only report key miss errors if a MIC error wasn't reported.
When checking the flags in that order in the MAC code, it might miss some
real events, because the value of the MIC error flag is undefined under
some conditions.

The primary issue addressed by the previous commit is making sure that
MIC errors are properly reported on the STA side. This can be fixed in
a better way by adding a separate rx status flag for key miss and
ignoring it for multicast frames.

This fix slightly improves stability in AP mode on some older hardware,
like AR9132.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    4 ++--
 drivers/net/wireless/ath/ath9k/mac.c        |    4 ++--
 drivers/net/wireless/ath/ath9k/mac.h        |    1 +
 drivers/net/wireless/ath/ath9k/recv.c       |   27 ++++++++++++++-------------
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 6cabc85..b363cc0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -525,8 +525,8 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (rxsp->status11 & AR_MichaelErr)
 			rxs->rs_status |= ATH9K_RXERR_MIC;
-		else if (rxsp->status11 & AR_KeyMiss)
-			rxs->rs_status |= ATH9K_RXERR_DECRYPT;
+		if (rxsp->status11 & AR_KeyMiss)
+			rxs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 22f23ea..43f53d6 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -620,8 +620,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
 			rs->rs_status |= ATH9K_RXERR_MIC;
-		else if (ads.ds_rxstatus8 & AR_KeyMiss)
-			rs->rs_status |= ATH9K_RXERR_DECRYPT;
+		if (ads.ds_rxstatus8 & AR_KeyMiss)
+			rs->rs_status |= ATH9K_RXERR_KEYMISS;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 91c9654..934caa7 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -181,6 +181,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RXERR_FIFO          0x04
 #define ATH9K_RXERR_DECRYPT       0x08
 #define ATH9K_RXERR_MIC           0x10
+#define ATH9K_RXERR_KEYMISS       0x20
 
 #define ATH9K_RX_MORE             0x01
 #define ATH9K_RX_MORE_AGGR        0x02
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f658ec6..c7306dc 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -823,7 +823,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
 	strip_mic = is_valid_tkip && ieee80211_is_data(fc) &&
 		!(rx_stats->rs_status &
-		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC));
+		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
+		 ATH9K_RXERR_KEYMISS));
 
 	if (!rx_stats->rs_datalen)
 		return false;
@@ -851,6 +852,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	 * descriptors.
 	 */
 	if (rx_stats->rs_status != 0) {
+		u8 status_mask;
+
 		if (rx_stats->rs_status & ATH9K_RXERR_CRC) {
 			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
 			mic_error = false;
@@ -858,7 +861,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
 			return false;
 
-		if (rx_stats->rs_status & ATH9K_RXERR_DECRYPT) {
+		if ((rx_stats->rs_status & ATH9K_RXERR_DECRYPT) ||
+		    (!is_mc && (rx_stats->rs_status & ATH9K_RXERR_KEYMISS))) {
 			*decrypt_error = true;
 			mic_error = false;
 		}
@@ -868,17 +872,14 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		 * decryption and MIC failures. For monitor mode,
 		 * we also ignore the CRC error.
 		 */
-		if (ah->is_monitoring) {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-			      ATH9K_RXERR_CRC))
-				return false;
-		} else {
-			if (rx_stats->rs_status &
-			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-				return false;
-			}
-		}
+		status_mask = ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+			      ATH9K_RXERR_KEYMISS;
+
+		if (ah->is_monitoring)
+			status_mask |= ATH9K_RXERR_CRC;
+
+		if (rx_stats->rs_status & ~status_mask)
+			return false;
 	}
 
 	/*
-- 
1.7.3.2

