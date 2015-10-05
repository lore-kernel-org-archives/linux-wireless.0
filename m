Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57179 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbbJEPBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:48 +0300
Message-Id: <1444055820-27506-17-git-send-email-luca@coelho.fi> (sfid-20151005_170138_682291_9AB3CF7C)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 17/29] iwlwifi: mvm: stop using DEVICE_POWER_FLAGS_CAM_MSK
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware has always treated these two bits to mean that
powersave is enabled when POWER_SAVE_ENA is set and CAM is
clear; it doesn't use them in any non-combined way.

Therefore, it's pointless to send it two bits, and the API
should be cleaned up. Prepare the driver by removing the CAM
bit and using only POWER_SAVE_ENA to indicate whether PS is
enabled or not.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 8 +-------
 drivers/net/wireless/iwlwifi/mvm/power.c        | 6 +++---
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index 7005fa4..c8f3e25 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -192,16 +192,10 @@ struct iwl_powertable_cmd {
 /**
  * enum iwl_device_power_flags - masks for device power command flags
  * @DEVIC_POWER_FLAGS_POWER_SAVE_ENA_MSK: '1' Allow to save power by turning off
- *	receiver and transmitter. '0' - does not allow. This flag should be
- *	always set to '1' unless one need to disable actual power down for debug
- *	purposes.
- * @DEVICE_POWER_FLAGS_CAM_MSK: '1' CAM (Continuous Active Mode) is set, meaning
- *	that power management is disabled. '0' Power management is enabled, one
- *	of power schemes is applied.
+ *	receiver and transmitter. '0' - does not allow.
 */
 enum iwl_device_power_flags {
 	DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK	= BIT(0),
-	DEVICE_POWER_FLAGS_CAM_MSK		= BIT(13),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 21a858d..723b537 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -471,14 +471,14 @@ static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 {
 	struct iwl_device_power_cmd cmd = {
-		.flags = cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK),
+		.flags = 0,
 	};
 
 	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
 		mvm->ps_disabled = true;
 
-	if (mvm->ps_disabled)
-		cmd.flags |= cpu_to_le16(DEVICE_POWER_FLAGS_CAM_MSK);
+	if (!mvm->ps_disabled)
+		cmd.flags |= cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if ((mvm->cur_ucode == IWL_UCODE_WOWLAN) ? mvm->disable_power_off_d3 :
-- 
2.5.3

