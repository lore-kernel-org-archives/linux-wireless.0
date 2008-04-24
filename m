Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275AbYDXSzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 18/21] iwlwifi-5000: add eeprom check version handler
Date: Thu, 24 Apr 2008 11:55:35 -0700
Message-Id: <1209063338-6572-19-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205639_226925_5F01B4A6)
In-Reply-To: <1209063338-6572-18-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-16-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-17-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-18-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds implementation for eeprom check version
handler for 5000 HW

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 ++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1e63b49..d8e3dd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -125,6 +125,33 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
+static int iwl5000_eeprom_check_version(struct iwl_priv *priv)
+{
+	u16 eeprom_ver;
+	struct iwl_eeprom_calib_hdr {
+		u8 version;
+		u8 pa_type;
+		u16 voltage;
+	} *hdr;
+
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+							EEPROM_5000_CALIB_ALL);
+
+	if (eeprom_ver < EEPROM_5000_EEPROM_VERSION ||
+	    hdr->version < EEPROM_5000_TX_POWER_VERSION)
+		goto err;
+
+	return 0;
+err:
+	IWL_ERROR("Unsuported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		  eeprom_ver, EEPROM_5000_EEPROM_VERSION,
+		  hdr->version, EEPROM_5000_TX_POWER_VERSION);
+	return -EINVAL;
+
+}
+
 #ifdef CONFIG_IWL5000_RUN_TIME_CALIB
 
 static void iwl5000_gain_computation(struct iwl_priv *priv,
@@ -179,6 +206,7 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 	data->beacon_count = 0;
 }
 
+
 static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
@@ -394,6 +422,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.check_version	= iwl5000_eeprom_check_version,
 		.query_addr = iwl5000_eeprom_query_addr,
 	},
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 56e0a07..06ed300 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -140,6 +140,10 @@ struct iwl_eeprom_channel {
 #define EEPROM_4965_BOARD_REVISION             (2*0x4F) /* 2 bytes */
 #define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
 
+/* 5000 Specific */
+#define EEPROM_5000_TX_POWER_VERSION    (4)
+#define EEPROM_5000_EEPROM_VERSION	(0x11A)
+
 /*5000 calibrations */
 #define EEPROM_5000_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
 
-- 
1.5.3.4

