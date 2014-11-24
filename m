Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46890 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaKXOfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:17 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so5969137wiw.10
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/75] iwlwifi: mvm: handle unsolicited DTS_MEASUREMENT_NOTIFICATIONs
Date: Mon, 24 Nov 2014 16:33:49 +0200
Message-Id: <1416839691-28533-13-git-send-email-egrumbach@gmail.com> (sfid-20141124_153523_423205_B2D11B13)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Currently, the firmware only sends temperature notificaitions inside
RX statistics notifications, which are tied to beacon filtering.  This
is a problem because beacon filtering is not used with vifs that don't
receive beacons (e.g. P2P GO and AP), so the driver doesn't receive
temperature notifications in those cases.  To solve that, the firmware
will be changed so that it sends DTS_MEASUREMENT_NOTIFICATIONs,
independently from the beacon filtering flows.

To support that, the driver needs to also handle unsolicited
DTS_MEASUREMENT_NOTIFICATIONs, that are not triggered by
DTS_TRIGGER_CMD_FLAGS_TEMP requests.

This change is backwards compatible and will simply not be used with
firmware versions that do not send the notifications.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  3 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c |  2 ++
 drivers/net/wireless/iwlwifi/mvm/tt.c  | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 9ac2d4c..7d2c528 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1211,6 +1211,9 @@ bool iwl_mvm_is_idle(struct iwl_mvm *mvm);
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
+int iwl_mvm_temp_notif(struct iwl_mvm *mvm,
+		       struct iwl_rx_cmd_buffer *rxb,
+		       struct iwl_device_cmd *cmd);
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index be3dd4f..737aac3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -254,6 +254,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(REPLY_ERROR, iwl_mvm_rx_fw_error, false),
 	RX_HANDLER(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION,
 		   iwl_mvm_power_uapsd_misbehaving_ap_notif, false),
+	RX_HANDLER(DTS_MEASUREMENT_NOTIFICATION, iwl_mvm_temp_notif, true),
+
 };
 #undef RX_HANDLER
 #define CMD(x) [x] = #x
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 35acf00..2b1e61f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -150,6 +150,26 @@ static bool iwl_mvm_temp_notif_wait(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
+int iwl_mvm_temp_notif(struct iwl_mvm *mvm,
+		       struct iwl_rx_cmd_buffer *rxb,
+		       struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	int temp;
+
+	/* the notification is handled synchronously in ctkill, so skip here */
+	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
+		return 0;
+
+	temp = iwl_mvm_temp_notif_parse(mvm, pkt);
+	if (temp < 0)
+		return 0;
+
+	iwl_mvm_tt_temp_changed(mvm, temp);
+
+	return 0;
+}
+
 static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
 {
 	struct iwl_dts_measurement_cmd cmd = {
-- 
1.9.1

