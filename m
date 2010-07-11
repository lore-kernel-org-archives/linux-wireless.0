Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46133 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab0GKKtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:49:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 4/7] ath9k_hw: prevent a fast channel change after a rx DMA stuck issue
Date: Sun, 11 Jul 2010 12:48:42 +0200
Message-Id: <1278845325-62000-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-3-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
 <1278845325-62000-2-git-send-email-nbd@openwrt.org>
 <1278845325-62000-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the receive path gets stuck, a full hardware reset is necessary to
recover from it. If this happens during a scan, the whole scan might fail,
as each channel change bypasses the full reset sequence.
Fix this by resetting the fast channel change flag if stopping the
receive path fails.

This will reduce the number of error messages that look like this:
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2acd799..2f83f97 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1232,9 +1232,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	if (!ah->chip_fullsleep) {
 		ath9k_hw_abortpcurecv(ah);
-		if (!ath9k_hw_stopdmarecv(ah))
+		if (!ath9k_hw_stopdmarecv(ah)) {
 			ath_print(common, ATH_DBG_XMIT,
 				"Failed to stop receive dma\n");
+			bChannelChange = false;
+		}
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-- 
1.6.4.2

