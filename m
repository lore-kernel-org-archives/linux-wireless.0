Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13033 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1I3GBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 02:01:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>,
	"Hu, Russell" <rhu@qca.qualcomm.com>
Subject: [PATCH v2] ath9k_hw: extend GPIO pin select mask for rfkill
Date: Fri, 30 Sep 2011 11:31:26 +0530
Message-ID: <1317362488-4816-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110930_080146_234269_CE5E63BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this extends the bits for rf kill GPIO selection to [7:2] from [4:2] as
we use GPIO pin 11 as rfkill for AR9480 and also remove few unused
macros

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: "Hu, Russell" <rhu@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h |    8 +++-----
 drivers/net/wireless/ath/ath9k/hw.c     |   10 ++++++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index a3c7d0c..70fe75c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -104,11 +104,6 @@
 #define OLC_FOR_AR9287_10_LATER (AR_SREV_9287_11_OR_LATER(ah) && \
 				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 
-#define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
-#define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
-#define AR_EEPROM_RFSILENT_POLARITY     0x0002
-#define AR_EEPROM_RFSILENT_POLARITY_S   1
-
 #define EEP_RFSILENT_ENABLED        0x0001
 #define EEP_RFSILENT_ENABLED_S      0
 #define EEP_RFSILENT_POLARITY       0x0002
@@ -116,6 +111,9 @@
 #define EEP_RFSILENT_GPIO_SEL       0x001c
 #define EEP_RFSILENT_GPIO_SEL_S     2
 
+#define AR9480_EEP_RFSILENT_GPIO_SEL       0x00fc
+#define AR9480_EEP_RFSILENT_GPIO_SEL_S     2
+
 #define AR5416_OPFLAGS_11A           0x01
 #define AR5416_OPFLAGS_11G           0x02
 #define AR5416_OPFLAGS_N_5G_HT40     0x04
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f2de7ee..521bb79 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2170,8 +2170,14 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
 	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
-		ah->rfkill_gpio =
-			MS(ah->rfsilent, EEP_RFSILENT_GPIO_SEL);
+
+		if (AR_SREV_9480(ah))
+			ah->rfkill_gpio =
+				MS(ah->rfsilent, AR9480_EEP_RFSILENT_GPIO_SEL);
+		else
+			ah->rfkill_gpio =
+				MS(ah->rfsilent, EEP_RFSILENT_GPIO_SEL);
+
 		ah->rfkill_polarity =
 			MS(ah->rfsilent, EEP_RFSILENT_POLARITY);
 
-- 
1.7.0.4

