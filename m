Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57077 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbbJEOhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Aviya Erenfeld <aviya.erenfeld@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:32 +0300
Message-Id: <1444055820-27506-1-git-send-email-luca@coelho.fi> (sfid-20151005_163711_885847_BCC5ABE8)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 01/29] iwlwifi: mvm: move DTS command and notification to new group
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

Move the DTS measurement command and notification from short
command header to the new PHY command group for firmware
supporting the extended command headers.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  2 ++
 drivers/net/wireless/iwlwifi/mvm/tt.c     | 14 ++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 5e4014a..44ff684 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -268,6 +268,16 @@ enum {
 	REPLY_MAX = 0xff,
 };
 
+enum iwl_phy_ops_subcmd_ids {
+	CMD_DTS_MEASUREMENT_TRIGGER_WIDE = 0x0,
+	DTS_MEASUREMENT_NOTIF_WIDE = 0xFF,
+};
+
+/* command groups */
+enum {
+	PHY_OPS_GROUP = 0x4,
+};
+
 /**
  * struct iwl_cmd_response - generic response struct for most commands
  * @status: status of the command asked, changes for each one
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 3f6428c..23825ff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -257,6 +257,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION,
 		   iwl_mvm_power_uapsd_misbehaving_ap_notif, false),
 	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif, true),
+	RX_HANDLER_GRP(PHY_OPS_GROUP, DTS_MEASUREMENT_NOTIF_WIDE,
+		       iwl_mvm_temp_notif, true),
 
 	RX_HANDLER(TDLS_CHANNEL_SWITCH_NOTIFICATION, iwl_mvm_rx_tdls_notif,
 		   true),
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index fe7145c..58b762f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -176,17 +176,27 @@ static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 	struct iwl_dts_measurement_cmd cmd = {
 		.flags = cpu_to_le32(DTS_TRIGGER_CMD_FLAGS_TEMP),
 	};
+	u32 cmdid;
 
-	return iwl_mvm_send_cmd_pdu(mvm, CMD_DTS_MEASUREMENT_TRIGGER, 0,
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
+		cmdid = iwl_cmd_id(CMD_DTS_MEASUREMENT_TRIGGER_WIDE,
+				   PHY_OPS_GROUP, 0);
+	else
+		cmdid = CMD_DTS_MEASUREMENT_TRIGGER;
+	return iwl_mvm_send_cmd_pdu(mvm, cmdid, 0,
 				    sizeof(cmd), &cmd);
 }
 
 int iwl_mvm_get_temp(struct iwl_mvm *mvm)
 {
 	struct iwl_notification_wait wait_temp_notif;
-	static const u16 temp_notif[] = { DTS_MEASUREMENT_NOTIFICATION };
+	static u16 temp_notif[] = { WIDE_ID(PHY_OPS_GROUP,
+					    DTS_MEASUREMENT_NOTIF_WIDE) };
 	int ret, temp;
 
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_WIDE_CMD_HDR))
+		temp_notif[0] = DTS_MEASUREMENT_NOTIFICATION;
+
 	lockdep_assert_held(&mvm->mutex);
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_temp_notif,
-- 
2.5.3

