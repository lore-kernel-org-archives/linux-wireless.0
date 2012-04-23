Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab2DWVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/29] iwlwifi: move OTP defines
Date: Mon, 23 Apr 2012 14:47:35 -0700
Message-Id: <1335217660-21950-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235309_649514_C5958421)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the PCI core shouldn't include the
iwl-eeprom.h header file, move the OTP
definitions into iwl-agn-hw.h which can
be included.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index c797ab1..7960a52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -102,6 +102,17 @@
 
 /* EEPROM */
 #define IWLAGN_EEPROM_IMG_SIZE		2048
+/* OTP */
+/* lower blocks contain EEPROM image and calibration data */
+#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
+/* high blocks contain PAPD data */
+#define OTP_HIGH_IMAGE_SIZE_6x00        (6 * 512 * sizeof(u16)) /* 6 KB */
+#define OTP_HIGH_IMAGE_SIZE_1000        (0x200 * sizeof(u16)) /* 1024 bytes */
+#define OTP_MAX_LL_ITEMS_1000		(3)	/* OTP blocks for 1000 */
+#define OTP_MAX_LL_ITEMS_6x00		(4)	/* OTP blocks for 6x00 */
+#define OTP_MAX_LL_ITEMS_6x50		(7)	/* OTP blocks for 6x50 */
+#define OTP_MAX_LL_ITEMS_2x00		(4)	/* OTP blocks for 2x00 */
+
 
 #define IWLAGN_NUM_QUEUES		20
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 24279db..64bfd94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -206,17 +206,6 @@ struct iwl_eeprom_calib_hdr {
 /* 6000 regulatory - indirect access */
 #define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-/* OTP */
-/* lower blocks contain EEPROM image and calibration data */
-#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-/* high blocks contain PAPD data */
-#define OTP_HIGH_IMAGE_SIZE_6x00        (6 * 512 * sizeof(u16)) /* 6 KB */
-#define OTP_HIGH_IMAGE_SIZE_1000        (0x200 * sizeof(u16)) /* 1024 bytes */
-#define OTP_MAX_LL_ITEMS_1000		(3)	/* OTP blocks for 1000 */
-#define OTP_MAX_LL_ITEMS_6x00		(4)	/* OTP blocks for 6x00 */
-#define OTP_MAX_LL_ITEMS_6x50		(7)	/* OTP blocks for 6x50 */
-#define OTP_MAX_LL_ITEMS_2x00		(4)	/* OTP blocks for 2x00 */
-
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
 
-- 
1.7.0.4

