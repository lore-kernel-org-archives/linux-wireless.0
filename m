Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10970 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab1I3Grl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 02:47:41 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>,
	"Hu, Russell" <rhu@qca.qualcomm.com>
Subject: [PATCH v3] ath9k_hw: extend GPIO pin select mask for rfkill
Date: Fri, 30 Sep 2011 12:17:28 +0530
Message-ID: <1317365248-7129-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110930_084745_229318_6B1B966A)
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
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index a3c7d0c..5d92f96 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -104,16 +104,11 @@
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
 #define EEP_RFSILENT_POLARITY_S     1
-#define EEP_RFSILENT_GPIO_SEL       0x001c
+#define EEP_RFSILENT_GPIO_SEL       (AR_SREV_9480(ah) ? 0x00fc : 0x001c)
 #define EEP_RFSILENT_GPIO_SEL_S     2
 
 #define AR5416_OPFLAGS_11A           0x01
-- 
1.7.0.4

