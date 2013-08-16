Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3HPLJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:09:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 16/20] iwlwifi: use a macro for default probe length
Date: Fri, 16 Aug 2013 13:07:06 +0200
Message-Id: <1376651230-1060-16-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130917_256080_79D72BB6)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of assigning the default max probe length to 200 in the main
code, create a macro for consistency and clarity.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h  | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d0162d4..e88397b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -843,7 +843,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 
-	fw->ucode_capa.max_probe_length = 200;
+	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 1705d24..a122368 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -99,6 +99,9 @@ enum iwl_ucode_tlv_flag {
 #define IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE		19
 #define IWL_MAX_PHY_CALIBRATE_TBL_SIZE			253
 
+/* The default max probe length if not specified by the firmware file */
+#define IWL_DEFAULT_MAX_PROBE_LENGTH	200
+
 /**
  * enum iwl_ucode_type
  *
-- 
1.8.4.rc2

