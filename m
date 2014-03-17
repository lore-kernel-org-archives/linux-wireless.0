Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54153 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbaCQJdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 05:33:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/3] ath9k: Disable AR_INTR_SYNC_HOST1_FATAL for QCA953x
Date: Mon, 17 Mar 2014 15:02:47 +0530
Message-Id: <1395048768-25245-2-git-send-email-sujith@msujith.org> (sfid-20140317_103347_721002_703FF58E)
In-Reply-To: <1395048768-25245-1-git-send-email-sujith@msujith.org>
References: <1395048768-25245-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Along with AR9340 and AR955x, this is also needed for
the QCA953x SoC.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 2 +-
 drivers/net/wireless/ath/ath9k/mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d91403f..c8a9dfa 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -882,7 +882,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 5f72758..51ce36f 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -827,7 +827,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		return;
 	}
 
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	async_mask = AR_INTR_MAC_IRQ;
-- 
1.9.0

