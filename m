Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16185 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1IMRKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:10:07 -0400
From: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH 4/4] ath9k_hw: move register definitions to header files
Date: Tue, 13 Sep 2011 22:38:19 +0530
Message-ID: <1315933699-7642-4-git-send-email-senthilb@qca.qualcomm.com> (sfid-20110913_191012_292315_65C32D98)
In-Reply-To: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
References: <1315933699-7642-1-git-send-email-senthilb@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the register macros to appropriate header files to be in
sync with other register definitions and also a single place
to refer everything.

Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   26 ------------------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   25 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 8884979..51398f0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -22,32 +22,6 @@
 #define COMP_HDR_LEN 4
 #define COMP_CKSUM_LEN 2
 
-#define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
-				((AR_SREV_9480(ah) ? 0x1628c : 0x16280)))
-#define AR_CH0_TOP_XPABIASLVL (0x300)
-#define AR_CH0_TOP_XPABIASLVL_S (8)
-
-#define AR_CH0_THERM	(AR_SREV_9300(ah) ? 0x16290 : \
-				((AR_SREV_9485(ah) ? 0x1628c : 0x16294)))
-#define AR_CH0_THERM_XPABIASLVL_MSB 0x3
-#define AR_CH0_THERM_XPABIASLVL_MSB_S 0
-#define AR_CH0_THERM_XPASHORT2GND 0x4
-#define AR_CH0_THERM_XPASHORT2GND_S 2
-
-#define AR_SWITCH_TABLE_COM_ALL (0xffff)
-#define AR_SWITCH_TABLE_COM_ALL_S (0)
-#define AR_SWITCH_TABLE_COM_AR9480_ALL (0xffffff)
-#define AR_SWITCH_TABLE_COM_AR9480_ALL_S (0)
-#define AR_SWITCH_TABLE_COM_SPDT (0x00f00000)
-#define AR_SWITCH_TABLE_COM_SPDT_ALL (0x0000fff0)
-#define AR_SWITCH_TABLE_COM_SPDT_ALL_S (4)
-
-#define AR_SWITCH_TABLE_COM2_ALL (0xffffff)
-#define AR_SWITCH_TABLE_COM2_ALL_S (0)
-
-#define AR_SWITCH_TABLE_ALL (0xfff)
-#define AR_SWITCH_TABLE_ALL_S (0)
-
 #define LE16(x) __constant_cpu_to_le16(x)
 #define LE32(x) __constant_cpu_to_le32(x)
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 1075fc7..6cea546 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -624,6 +624,31 @@
 #define AR_PHY_65NM_CH0_BIAS4       0x160cc
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
 
+#define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
+				((AR_SREV_9480(ah) ? 0x1628c : 0x16280)))
+#define AR_CH0_TOP_XPABIASLVL (0x300)
+#define AR_CH0_TOP_XPABIASLVL_S (8)
+
+#define AR_CH0_THERM	(AR_SREV_9300(ah) ? 0x16290 : \
+				((AR_SREV_9485(ah) ? 0x1628c : 0x16294)))
+#define AR_CH0_THERM_XPABIASLVL_MSB 0x3
+#define AR_CH0_THERM_XPABIASLVL_MSB_S 0
+#define AR_CH0_THERM_XPASHORT2GND 0x4
+#define AR_CH0_THERM_XPASHORT2GND_S 2
+
+#define AR_SWITCH_TABLE_COM_ALL (0xffff)
+#define AR_SWITCH_TABLE_COM_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_AR9480_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM_AR9480_ALL_S (0)
+#define AR_SWITCH_TABLE_COM_SPDT (0x00f00000)
+#define AR_SWITCH_TABLE_COM_SPDT_ALL (0x0000fff0)
+#define AR_SWITCH_TABLE_COM_SPDT_ALL_S (4)
+
+#define AR_SWITCH_TABLE_COM2_ALL (0xffffff)
+#define AR_SWITCH_TABLE_COM2_ALL_S (0)
+
+#define AR_SWITCH_TABLE_ALL (0xfff)
+#define AR_SWITCH_TABLE_ALL_S (0)
 
 #define AR_PHY_65NM_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 :\
 					(AR_SREV_9485(ah) ? 0x1628c : 0x16294))
-- 
1.7.0.4

