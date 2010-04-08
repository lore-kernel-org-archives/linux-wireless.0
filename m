Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933150Ab0DHT1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 006/102] ath9k_hw: add support for GPIO differences on AR9003
Date: Thu,  8 Apr 2010 15:26:02 -0400
Message-Id: <1270754858-26266-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    4 +++-
 drivers/net/wireless/ath/ath9k/reg.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2f82da5..8f3b602 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3490,7 +3490,9 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 	if (gpio >= ah->caps.num_gpio_pins)
 		return 0xffffffff;
 
-	if (AR_SREV_9271(ah))
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		return MS_REG_READ(AR9300, gpio) != 0;
+	else if (AR_SREV_9271(ah))
 		return MS_REG_READ(AR9271, gpio) != 0;
 	else if (AR_SREV_9287_10_OR_LATER(ah))
 		return MS_REG_READ(AR9287, gpio) != 0;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d56b4ea..d524891 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -954,6 +954,7 @@ enum {
 #define AR9285_NUM_GPIO                          12
 #define AR9287_NUM_GPIO                          11
 #define AR9271_NUM_GPIO                          16
+#define AR9300_NUM_GPIO                          17
 
 #define AR_GPIO_IN_OUT                           0x4048
 #define AR_GPIO_IN_VAL                           0x0FFFC000
-- 
1.6.3.3

