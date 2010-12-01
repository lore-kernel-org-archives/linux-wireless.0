Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13754 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0LAHYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:24:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:23:53 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix bug in reading input gpio state for ar9003
Date: Tue, 30 Nov 2010 23:24:09 -0800
Message-ID: <1291188249-13507-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register which gives input gpio state is 0x404c for ar9003,
currently 0x4048 is wrongly used. This will disable RF and make
it unusable on some of AR9003.

Cc:stable@kernel.org
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/reg.h |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b4396a9..9b1ee7f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2051,7 +2051,8 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 		val = REG_READ(ah, AR7010_GPIO_IN);
 		return (MS(val, AR7010_GPIO_IN_VAL) & AR_GPIO_BIT(gpio)) == 0;
 	} else if (AR_SREV_9300_20_OR_LATER(ah))
-		return MS_REG_READ(AR9300, gpio) != 0;
+		return (MS(REG_READ(ah, AR_GPIO_IN), AR9300_GPIO_IN_VAL) &
+			AR_GPIO_BIT(gpio)) != 0;
 	else if (AR_SREV_9271(ah))
 		return MS_REG_READ(AR9271, gpio) != 0;
 	else if (AR_SREV_9287_11_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a597cc8..c2472ed 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -976,11 +976,13 @@ enum {
 #define AR9287_GPIO_IN_VAL_S                     11
 #define AR9271_GPIO_IN_VAL                       0xFFFF0000
 #define AR9271_GPIO_IN_VAL_S                     16
-#define AR9300_GPIO_IN_VAL                       0x0001FFFF
-#define AR9300_GPIO_IN_VAL_S                     0
 #define AR7010_GPIO_IN_VAL                       0x0000FFFF
 #define AR7010_GPIO_IN_VAL_S                     0
 
+#define AR_GPIO_IN				 0x404c
+#define AR9300_GPIO_IN_VAL                       0x0001FFFF
+#define AR9300_GPIO_IN_VAL_S                     0
+
 #define AR_GPIO_OE_OUT                           (AR_SREV_9300_20_OR_LATER(ah) ? 0x4050 : 0x404c)
 #define AR_GPIO_OE_OUT_DRV                       0x3
 #define AR_GPIO_OE_OUT_DRV_NO                    0x0
-- 
1.7.0.4

