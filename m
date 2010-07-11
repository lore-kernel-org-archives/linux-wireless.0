Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46132 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab0GKKs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:48:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 7/7] ath9k_hw: handle an rx key miss properly
Date: Sun, 11 Jul 2010 12:48:45 +0200
Message-Id: <1278845325-62000-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-6-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
 <1278845325-62000-2-git-send-email-nbd@openwrt.org>
 <1278845325-62000-3-git-send-email-nbd@openwrt.org>
 <1278845325-62000-4-git-send-email-nbd@openwrt.org>
 <1278845325-62000-5-git-send-email-nbd@openwrt.org>
 <1278845325-62000-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the hardware reports an rx key miss, then the frame has not been
decrypted at all, and this must be recognized by the software, otherwise
mac80211 can generate bogus MIC failure events.

Fix this by reporting an invalid key index if a key miss is detected
in the rx status.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 +++
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 06ef710..9de8554 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -578,6 +578,9 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	if (rxsp->status11 & AR_DecryptBusyErr)
 		rxs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
 
+	if (rxsp->status11 & AR_KeyMiss)
+		rxs->rs_keyix = ATH9K_RXKEYIX_INVALID;
+
 	if ((rxsp->status11 & AR_RxFrameOK) == 0) {
 		if (rxsp->status11 & AR_CRCErr) {
 			rxs->rs_status |= ATH9K_RXERR_CRC;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e955bb9..8d0bb5a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -701,6 +701,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_POST;
 	if (ads.ds_rxstatus8 & AR_DecryptBusyErr)
 		rs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
+	if (ads.ds_rxstatus8 & AR_KeyMiss)
+		rs->rs_keyix = ATH9K_RXKEYIX_INVALID;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
 		if (ads.ds_rxstatus8 & AR_CRCErr)
-- 
1.6.4.2

