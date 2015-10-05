Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56877 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbbJELlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:41:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>, <stable@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 14:40:45 +0300
Message-Id: <1444045246-9946-7-git-send-email-luca@coelho.fi> (sfid-20151005_134110_313514_EFBD0CA7)
In-Reply-To: <1444044666.27220.5.camel@coelho.fi>
References: <1444044666.27220.5.camel@coelho.fi>
Subject: [PATCH 7/8] iwlwifi: mvm: init card correctly on ctkill exit check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

During the CT-kill exit flow, the card is powered up and partially
initialized to check if the temperature is already low enough.
Unfortunately the init bails early because the CT-kill flag is set.
Make the code bail early only for HW RF-kill, as was intended by the
author. CT-kill is self-imposed and is not really RF-kill.

Fixes: 31b8b343e019 ("iwlwifi: fix RFkill while calibrating")
Cc: <stable@vger.kernel.org> [3.18+]
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 4a0ce83..5c7f7cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -703,7 +703,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	 * abort after reading the nvm in case RF Kill is on, we will complete
 	 * the init seq later when RF kill will switch to off
 	 */
-	if (iwl_mvm_is_radio_killed(mvm)) {
+	if (iwl_mvm_is_radio_hw_killed(mvm)) {
 		IWL_DEBUG_RF_KILL(mvm,
 				  "jump over all phy activities due to RF kill\n");
 		iwl_remove_notification(&mvm->notif_wait, &calib_wait);
@@ -736,7 +736,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	ret = iwl_wait_notification(&mvm->notif_wait, &calib_wait,
 			MVM_UCODE_CALIB_TIMEOUT);
 
-	if (ret && iwl_mvm_is_radio_killed(mvm)) {
+	if (ret && iwl_mvm_is_radio_hw_killed(mvm)) {
 		IWL_DEBUG_RF_KILL(mvm, "RFKILL while calibrating.\n");
 		ret = 1;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b95a07e..c754051 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -860,6 +860,11 @@ static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
 	       test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status);
 }
 
+static inline bool iwl_mvm_is_radio_hw_killed(struct iwl_mvm *mvm)
+{
+	return test_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
+}
+
 /* Must be called with rcu_read_lock() held and it can only be
  * released when mvmsta is not needed anymore.
  */
-- 
2.5.3

