Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43846 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3LaRQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:26 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so5553287eak.25
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:25 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/28] iwlwifi: mvm: disable the device as soon as RFKILL fires
Date: Tue, 31 Dec 2013 19:15:46 +0200
Message-Id: <1388510157-23345-17-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_947927_209B2559)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware needs to be stopped quickly (100ms) after the
RFKILL interrupt fired. Failing to do so would allow the
firmware to access the radio registers which would lead to
a hardware error.

Before this change, we would kill the firmware only when
mac80211 stops the device which can take a fair amount of
time. Take a shortcut by stopping the device right away
in the interrupt.

This is not relevant if the current firmware is INIT
firmware since that firmware can run while in RFKILL.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c  |    2 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c |    9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a362430..d6b96ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -665,6 +665,8 @@ static void iwl_mvm_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 	else
 		clear_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
 
+	if (state && mvm->cur_ucode != IWL_UCODE_INIT)
+		iwl_trans_stop_device(mvm->trans);
 	wiphy_rfkill_set_hw_state(mvm->hw->wiphy, iwl_mvm_is_radio_killed(mvm));
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4ce9bb5..71718a81 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -473,13 +473,18 @@ void iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
 		return;
 
+	if (iwl_mvm_is_radio_killed(mvm)) {
+		ieee80211_scan_completed(mvm->hw, true);
+		mvm->scan_status = IWL_MVM_SCAN_NONE;
+		return;
+	}
+
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_abort,
 				   scan_abort_notif,
 				   ARRAY_SIZE(scan_abort_notif),
 				   iwl_mvm_scan_abort_notif, NULL);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD,
-				   CMD_SYNC | CMD_SEND_IN_RFKILL, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, CMD_SYNC, 0, NULL);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send SCAN_ABORT_CMD: %d\n", ret);
 		/* mac80211's state will be cleaned in the fw_restart flow */
-- 
1.7.9.5

