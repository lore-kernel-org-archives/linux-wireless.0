Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbZJPVZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/10] iwlwifi: identify eeprom version for 6x50 series NIC
Date: Fri, 16 Oct 2009 14:25:51 -0700
Message-Id: <1255728358-29976-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding support for 6x50 series EEPROM version check, 6x50 is wifi/wimax
combo device which has different EEPROM map

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index bdc1c74..e74dad3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -399,7 +399,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
@@ -425,7 +425,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
@@ -476,7 +476,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index b363c96..5ba5a4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -261,9 +261,12 @@ struct iwl_eeprom_enhanced_txpwr {
 /* 1000 Specific */
 #define EEPROM_1000_EEPROM_VERSION	(0x15C)
 
-/* 60x0 Specific */
+/* 6x00 Specific */
 #define EEPROM_6000_EEPROM_VERSION	(0x434)
 
+/* 6x50 Specific */
+#define EEPROM_6050_EEPROM_VERSION	(0x532)
+
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-- 
1.5.6.3

