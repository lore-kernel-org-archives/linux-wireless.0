Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 21/24] ath9k_hw: add support for parsing PA predistortion related EEPROM fields
Date: Sat, 12 Jun 2010 00:33:59 -0400
Message-Id: <1276317242-15540-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   13 ++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    4 +++-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c            |    2 ++
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 5 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 23eb60e..343c9a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -67,6 +67,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		  * bit2 - enable fastClock - enabled
 		  * bit3 - enable doubling - enabled
 		  * bit4 - enable internal regulator - disabled
+		  * bit5 - enable pa predistortion - disabled
 		  */
 		.miscConfiguration = 0, /* bit0 - turn down drivestrength */
 		.eepromWriteEnableGpio = 3,
@@ -129,9 +130,11 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txEndToRxOn = 0x2,
 		.txFrameToXpaOn = 0xe,
 		.thresh62 = 28,
-		.futureModal = { /* [32] */
+		.papdRateMaskHt20 = LE32(0x80c080),
+		.papdRateMaskHt40 = LE32(0x80c080),
+		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+			0, 0, 0, 0, 0, 0, 0, 0
 		},
 	 },
 	.calFreqPier2G = {
@@ -326,9 +329,11 @@ static const struct ar9300_eeprom ar9300_default = {
 		.txEndToRxOn = 0x2,
 		.txFrameToXpaOn = 0xe,
 		.thresh62 = 28,
+		.papdRateMaskHt20 = LE32(0xf0e0e0),
+		.papdRateMaskHt40 = LE32(0xf0e0e0),
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
-			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+			0, 0, 0, 0, 0, 0, 0, 0
 		},
 	 },
 	.calFreqPier5G = {
@@ -644,6 +649,8 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		return (pBase->featureEnable & 0x10) >> 4;
 	case EEP_SWREG:
 		return le32_to_cpu(pBase->swreg);
+	case EEP_PAPRD:
+		return !!(pBase->featureEnable & BIT(5));
 	default:
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 23fb353..3c533bb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -234,7 +234,9 @@ struct ar9300_modal_eep_header {
 	u8 txEndToRxOn;
 	u8 txFrameToXpaOn;
 	u8 thresh62;
-	u8 futureModal[32];
+	__le32 papdRateMaskHt20;
+	__le32 papdRateMaskHt40;
+	u8 futureModal[24];
 } __packed;
 
 struct ar9300_cal_data_per_freq_op_loop {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 7da7d73..bdd8aa0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -263,7 +263,8 @@ enum eeprom_param {
 	EEP_PWR_TABLE_OFFSET,
 	EEP_DRIVE_STRENGTH,
 	EEP_INTERNAL_REGULATOR,
-	EEP_SWREG
+	EEP_SWREG,
+	EEP_PAPRD,
 };
 
 enum ar5416_rates {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 83e0461..5a2e72a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2235,6 +2235,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
 		pCap->tx_desc_len = sizeof(struct ar9003_txc);
 		pCap->txs_len = sizeof(struct ar9003_txs);
+		if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD))
+			pCap->hw_caps |= ATH9K_HW_CAP_PAPRD;
 	} else {
 		pCap->tx_desc_len = sizeof(struct ath_desc);
 		if (AR_SREV_9280_20(ah) &&
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 09dd7be..9d09216 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -200,6 +200,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_LDPC			= BIT(19),
 	ATH9K_HW_CAP_FASTCLOCK			= BIT(20),
 	ATH9K_HW_CAP_SGI_20			= BIT(21),
+	ATH9K_HW_CAP_PAPRD			= BIT(22),
 };
 
 enum ath9k_capability_type {
-- 
1.6.3.3

