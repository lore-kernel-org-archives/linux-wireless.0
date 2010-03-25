Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0CYUo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/22] iwlwifi: each device has its own eeprom tx power version
Date: Thu, 25 Mar 2010 13:44:38 -0700
Message-Id: <1269549890-19195-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Each device has it own eeprom, so the tx power version could be
different, define TX_POWER_VERSION per device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    3 +++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a99945b..cf0aa71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -234,7 +234,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.ops = &iwl1000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -264,7 +264,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ops = &iwl1000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 92b407f..cb9c2d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -371,7 +371,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -404,7 +404,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -436,7 +436,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -468,7 +468,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -501,7 +501,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
@@ -533,7 +533,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 907a30a..cb6d50b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -261,12 +261,15 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
 
 /* 1000 Specific */
+#define EEPROM_1000_TX_POWER_VERSION    (4)
 #define EEPROM_1000_EEPROM_VERSION	(0x15C)
 
 /* 6x00 Specific */
+#define EEPROM_6000_TX_POWER_VERSION    (4)
 #define EEPROM_6000_EEPROM_VERSION	(0x434)
 
 /* 6x50 Specific */
+#define EEPROM_6050_TX_POWER_VERSION    (4)
 #define EEPROM_6050_EEPROM_VERSION	(0x532)
 
 /* OTP */
-- 
1.6.3.3

