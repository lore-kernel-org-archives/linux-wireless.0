Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab2DWVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/29] iwlwifi: move eeprom versions to HW files
Date: Mon, 23 Apr 2012 14:47:33 -0700
Message-Id: <1335217660-21950-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235327_948974_2D4850DB)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hardware files belong to the core PCI
functionality, but the eeprom header file
mixes higher-level functionality and the
defines, so move out the specific defines
and put them into the appropriate HW files
instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    4 +++
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    5 +++
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 ++++
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   14 +++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   42 -----------------------------
 5 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e900607..42de5aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -42,6 +42,10 @@
 #define IWL1000_UCODE_API_MIN 1
 #define IWL100_UCODE_API_MIN 5
 
+/* EEPROM version */
+#define EEPROM_1000_TX_POWER_VERSION	(4)
+#define EEPROM_1000_EEPROM_VERSION	(0x15C)
+
 #define IWL1000_FW_PRE "iwlwifi-1000-"
 #define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE __stringify(api) ".ucode"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3d4a36c..d3d8c10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -48,6 +48,11 @@
 #define IWL105_UCODE_API_MIN 5
 #define IWL135_UCODE_API_MIN 5
 
+/* EEPROM version */
+#define EEPROM_2000_TX_POWER_VERSION	(6)
+#define EEPROM_2000_EEPROM_VERSION	(0x805)
+
+
 #define IWL2030_FW_PRE "iwlwifi-2030-"
 #define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE __stringify(api) ".ucode"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ffa9ac5..94d465e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -38,6 +38,12 @@
 #define IWL5000_UCODE_API_MIN 1
 #define IWL5150_UCODE_API_MIN 1
 
+/* EEPROM versions */
+#define EEPROM_5000_TX_POWER_VERSION	(4)
+#define EEPROM_5000_EEPROM_VERSION	(0x11A)
+#define EEPROM_5050_TX_POWER_VERSION	(4)
+#define EEPROM_5050_EEPROM_VERSION	(0x21E)
+
 #define IWL5000_FW_PRE "iwlwifi-5000-"
 #define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE __stringify(api) ".ucode"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 00da252..6db0a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -44,6 +44,20 @@
 #define IWL6050_UCODE_API_MIN 4
 #define IWL6000G2_UCODE_API_MIN 4
 
+/* EEPROM versions */
+#define EEPROM_6000_TX_POWER_VERSION	(4)
+#define EEPROM_6000_EEPROM_VERSION	(0x423)
+#define EEPROM_6050_TX_POWER_VERSION	(4)
+#define EEPROM_6050_EEPROM_VERSION	(0x532)
+#define EEPROM_6150_TX_POWER_VERSION	(6)
+#define EEPROM_6150_EEPROM_VERSION	(0x553)
+#define EEPROM_6005_TX_POWER_VERSION	(6)
+#define EEPROM_6005_EEPROM_VERSION	(0x709)
+#define EEPROM_6030_TX_POWER_VERSION	(6)
+#define EEPROM_6030_EEPROM_VERSION	(0x709)
+#define EEPROM_6035_TX_POWER_VERSION	(6)
+#define EEPROM_6035_EEPROM_VERSION	(0x753)
+
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE __stringify(api) ".ucode"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index b3a3b1f..24279db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -206,48 +206,6 @@ struct iwl_eeprom_calib_hdr {
 /* 6000 regulatory - indirect access */
 #define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-
-/* 5000 Specific */
-#define EEPROM_5000_TX_POWER_VERSION    (4)
-#define EEPROM_5000_EEPROM_VERSION	(0x11A)
-
-/* 5050 Specific */
-#define EEPROM_5050_TX_POWER_VERSION    (4)
-#define EEPROM_5050_EEPROM_VERSION	(0x21E)
-
-/* 1000 Specific */
-#define EEPROM_1000_TX_POWER_VERSION    (4)
-#define EEPROM_1000_EEPROM_VERSION	(0x15C)
-
-/* 6x00 Specific */
-#define EEPROM_6000_TX_POWER_VERSION    (4)
-#define EEPROM_6000_EEPROM_VERSION	(0x423)
-
-/* 6x50 Specific */
-#define EEPROM_6050_TX_POWER_VERSION    (4)
-#define EEPROM_6050_EEPROM_VERSION	(0x532)
-
-/* 6150 Specific */
-#define EEPROM_6150_TX_POWER_VERSION    (6)
-#define EEPROM_6150_EEPROM_VERSION	(0x553)
-
-/* 6x05 Specific */
-#define EEPROM_6005_TX_POWER_VERSION    (6)
-#define EEPROM_6005_EEPROM_VERSION	(0x709)
-
-/* 6x30 Specific */
-#define EEPROM_6030_TX_POWER_VERSION    (6)
-#define EEPROM_6030_EEPROM_VERSION	(0x709)
-
-/* 2x00 Specific */
-#define EEPROM_2000_TX_POWER_VERSION    (6)
-#define EEPROM_2000_EEPROM_VERSION	(0x805)
-
-/* 6x35 Specific */
-#define EEPROM_6035_TX_POWER_VERSION    (6)
-#define EEPROM_6035_EEPROM_VERSION	(0x753)
-
-
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-- 
1.7.0.4

