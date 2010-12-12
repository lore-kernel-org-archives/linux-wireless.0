Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50818 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0LLNeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 08:34:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 4/7] ath9k_hw: fix the PA predistortion rate mask
Date: Sun, 12 Dec 2010 14:34:34 +0100
Message-Id: <1292160877-50618-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292160877-50618-3-git-send-email-nbd@openwrt.org>
References: <1292160877-50618-1-git-send-email-nbd@openwrt.org>
 <1292160877-50618-2-git-send-email-nbd@openwrt.org>
 <1292160877-50618-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The EEPROM PAPRD rate mask fields only contain mask values for actual
rates in the low 25 bits. The upper bits are reserved for tx power
scale values. Add the proper mask definitions and use them before
writing the values to the register.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    6 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 620821e..efb6a02 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -31,6 +31,12 @@
 #define AR9300_ANT_16S               25
 #define AR9300_FUTURE_MODAL_SZ       6
 
+#define AR9300_PAPRD_RATE_MASK		0x01ffffff
+#define AR9300_PAPRD_SCALE_1		0x0e000000
+#define AR9300_PAPRD_SCALE_1_S		25
+#define AR9300_PAPRD_SCALE_2		0x70000000
+#define AR9300_PAPRD_SCALE_2_S		28
+
 /* Delta from which to start power to pdadc table */
 /* This offset is used in both open loop and closed loop power control
  * schemes. In open loop power control, it is not really needed, but for
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 74cff43..cdca4c3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -52,8 +52,8 @@ static void ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	else
 		hdr = &eep->modalHeader2G;
 
-	am_mask = le32_to_cpu(hdr->papdRateMaskHt20);
-	ht40_mask = le32_to_cpu(hdr->papdRateMaskHt40);
+	am_mask = le32_to_cpu(hdr->papdRateMaskHt20) & AR9300_PAPRD_RATE_MASK;
+	ht40_mask = le32_to_cpu(hdr->papdRateMaskHt40) & AR9300_PAPRD_RATE_MASK;
 
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2AM, AR_PHY_PAPRD_AM2AM_MASK, am_mask);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK, am_mask);
-- 
1.7.3.2

