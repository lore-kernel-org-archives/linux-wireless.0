Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab1GPPcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/18] iwlagn: comments for iwl_cfg
Date: Sat, 16 Jul 2011 07:56:29 -0700
Message-Id: <1310828199-18000-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173216_731169_2F5528E5)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify the comments for iwl_cfg, no functional changes

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 28c21f4..5187318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -189,11 +189,22 @@ struct iwl_ht_params {
 
 /**
  * struct iwl_cfg
+ * @name: Offical name of the device
  * @fw_name_pre: Firmware filename prefix. The api version and extension
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
  * @ucode_api_max: Highest version of uCode API supported by driver.
  * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @valid_tx_ant: valid transmit antenna
+ * @valid_rx_ant: valid receive antenna
+ * @sku: sku information from EEPROM
+ * @eeprom_ver: EEPROM version
+ * @eeprom_calib_ver: EEPROM calibration version
+ * @lib: pointer to the lib ops
+ * @additional_nic_config: additional nic configuration
+ * @base_params: pointer to basic parameters
+ * @ht_params: point to ht patameters
+ * @bt_params: pointer to bt parameters
  * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  * @need_dc_calib: need to perform init dc calibration
  * @need_temp_offset_calib: need to perform temperature offset calibration
@@ -220,11 +231,7 @@ struct iwl_ht_params {
  * }
  *
  * The ideal usage of this infrastructure is to treat a new ucode API
- * release as a new hardware revision. That is, through utilizing the
- * iwl_hcmd_utils_ops etc. we accommodate different command structures
- * and flows between hardware versions (4965/5000) as well as their API
- * versions.
- *
+ * release as a new hardware revision.
  */
 struct iwl_cfg {
 	/* params specific to an individual device within a device family */
-- 
1.7.0.4

