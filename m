Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55007 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1GHHbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 03:31:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Disable PAPRD based on paprd_ht20_mask for 5GHz
Date: Fri, 8 Jul 2011 13:01:32 +0530
Message-ID: <1310110292-7854-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110708_093145_123259_51B51C41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   30 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |    2 +
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index de19723..f80d1d6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -21,6 +21,36 @@ void ar9003_paprd_enable(struct ath_hw *ah, bool val)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath9k_channel *chan = ah->curchan;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	/*
+	 * 3 bits for modalHeader5G.papdRateMaskHt20
+	 * is used for sub-band disabling of PAPRD.
+	 * 5G band is divided into 3 sub-bands -- upper,
+	 * middle, lower.
+	 * if bit 30 of modalHeader5G.papdRateMaskHt20 is set
+	 * -- disable PAPRD for upper band 5GHz
+	 * if bit 29 of modalHeader5G.papdRateMaskHt20 is set
+	 * -- disable PAPRD for middle band 5GHz
+	 * if bit 28 of modalHeader5G.papdRateMaskHt20 is set
+	 * -- disable PAPRD for lower band 5GHz
+	 */
+
+	if (IS_CHAN_5GHZ(chan)) {
+		if (chan->channel >= UPPER_5G_SUB_BAND_START) {
+			if (le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20)
+								  & BIT(30))
+				val = false;
+		} else if (chan->channel >= MID_5G_SUB_BAND_START) {
+			if (le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20)
+								  & BIT(29))
+				val = false;
+		} else {
+			if (le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20)
+								  & BIT(28))
+				val = false;
+		}
+	}
 
 	if (val) {
 		ah->paprd_table_write_done = true;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 818acdd..a1c3174 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -143,6 +143,8 @@
 #define AR_KEYTABLE_SIZE            128
 #define POWER_UP_TIME               10000
 #define SPUR_RSSI_THRESH            40
+#define UPPER_5G_SUB_BAND_START		5700
+#define MID_5G_SUB_BAND_START		5400
 
 #define CAB_TIMEOUT_VAL             10
 #define BEACON_TIMEOUT_VAL          10
-- 
1.7.0.4

