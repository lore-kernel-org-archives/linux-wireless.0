Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933275AbcISHcr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:26 +0300
Message-Id: <20160919073028.22065-23-luca@coelho.fi> (sfid-20160919_100149_414635_26AF9251)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: mvm: set HCMD_NAME for PHY_DB as well
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently it is logged as UNKNOWN.
Also, 0x6c seems to be the permanent ID for this command, remove
incorrect comment and uncomment the command from the commands
list.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index 7beba9a..2893826 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -110,7 +110,7 @@ enum iwl_phy_db_section_type {
 	IWL_PHY_DB_MAX
 };
 
-#define PHY_DB_CMD 0x6c /* TEMP API - The actual is 0x8c */
+#define PHY_DB_CMD 0x6c
 
 /*
  * phy db - configure operational ucode
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index fdd9506..9763369 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -205,7 +205,7 @@ enum {
 	/* Phy */
 	PHY_CONFIGURATION_CMD = 0x6a,
 	CALIB_RES_NOTIF_PHY_DB = 0x6b,
-	/* PHY_DB_CMD = 0x6c, */
+	PHY_DB_CMD = 0x6c,
 
 	/* ToF - 802.11mc FTM */
 	TOF_CMD = 0x10,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index b2d8722..3eccd89 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -359,6 +359,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 	HCMD_NAME(BT_COEX_CI),
 	HCMD_NAME(PHY_CONFIGURATION_CMD),
 	HCMD_NAME(CALIB_RES_NOTIF_PHY_DB),
+	HCMD_NAME(PHY_DB_CMD),
 	HCMD_NAME(SCAN_OFFLOAD_COMPLETE),
 	HCMD_NAME(SCAN_OFFLOAD_UPDATE_PROFILES_CMD),
 	HCMD_NAME(SCAN_OFFLOAD_CONFIG_CMD),
-- 
2.9.3
