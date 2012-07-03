Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40089 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261Ab2GCROH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:07 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 15/20] ath9k: disable SYNC_HOST1_FATAL interrupts for AR9550
Date: Tue,  3 Jul 2012 19:13:29 +0200
Message-Id: <1341335614-15419-16-git-send-email-juhosg@openwrt.org> (sfid-20120703_191413_743583_CB259817)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c16c59f..1ddec4b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -946,7 +946,7 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
-	if (AR_SREV_9340(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 04ef775..7990cd5 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -810,7 +810,7 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 		return;
 	}
 
-	if (AR_SREV_9340(ah))
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
 	async_mask = AR_INTR_MAC_IRQ;
-- 
1.7.2.1

