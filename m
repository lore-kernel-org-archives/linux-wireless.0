Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 86/97] ath9k_hw: enable CRC check of descriptors for AR9003
Date: Thu, 15 Apr 2010 17:39:31 -0400
Message-Id: <1271367582-992-87-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable CRC check on the descriptor fetched from host on AR9003
upon reseting the TX queue.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    3 +++
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 0515958..44ea43a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -569,6 +569,9 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  AR_D_MISC_POST_FR_BKOFF_DIS);
 	}
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		REG_WRITE(ah, AR_Q_DESC_CRCCHK, AR_Q_DESC_CRCCHK_EN);
+
 	if (qi->tqi_qflags & TXQ_FLAG_TXOKINT_ENABLE)
 		ah->txok_interrupt_mask |= 1 << q;
 	else
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ff89140..d4371a4 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -478,6 +478,10 @@
 #define AR_Q_RDYTIMESHDN    0x0a40
 #define AR_Q_RDYTIMESHDN_M  0x000003FF
 
+/* MAC Descriptor CRC check */
+#define AR_Q_DESC_CRCCHK    0xa44
+/* Enable CRC check on the descriptor fetched from host */
+#define AR_Q_DESC_CRCCHK_EN 1
 
 #define AR_NUM_DCU      10
 #define AR_DCU_0        0x0001
-- 
1.6.3.3

