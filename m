Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/26] iwlwifi: use enhance_sensitivity from iwl_fw
Date: Fri, 17 Feb 2012 11:13:44 -0800
Message-Id: <1329506034-1394-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212400_038067_E3C883B6)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove another dependency between the nic layer and the iwl_priv
struct.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-ucode.c     |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 6aa0098..988ee45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -68,6 +68,8 @@
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 #include "iwl-agn.h"
+#include "iwl-wifi.h"
+#include "iwl-ucode.h"
 
 /*****************************************************************************
  * INIT calibrations framework
@@ -634,7 +636,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data->last_bad_plcp_cnt_cck = 0;
 	data->last_fa_cnt_cck = 0;
 
-	if (priv->enhance_sensitivity_table)
+	if (nic(priv)->fw.enhance_sensitivity_table)
 		ret |= iwl_enhance_sensitivity_write(priv);
 	else
 		ret |= iwl_sensitivity_write(priv);
@@ -745,7 +747,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 
 	iwl_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
 	iwl_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
-	if (priv->enhance_sensitivity_table)
+	if (nic(priv)->fw.enhance_sensitivity_table)
 		iwl_enhance_sensitivity_write(priv);
 	else
 		iwl_sensitivity_write(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0d0b4bb..8a72940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -796,7 +796,6 @@ struct iwl_priv {
 	u8 start_calib;
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
-	bool enhance_sensitivity_table;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
 	__le16 enhance_sensitivity_tbl[ENHANCE_HD_TABLE_ENTRIES];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 26ead61..a2695c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -967,7 +967,7 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
 			if (tlv_len)
 				goto invalid_tlv_len;
-			priv->enhance_sensitivity_table = true;
+			nic->fw.enhance_sensitivity_table = true;
 			break;
 		case IWL_UCODE_TLV_WOWLAN_INST:
 			pieces->wowlan_inst = tlv_data;
-- 
1.7.0.4

