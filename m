Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47366 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751658AbdKYPfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:31 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:06 +0200
Message-Id: <20171125153510.25359-3-luca@coelho.fi> (sfid-20171125_163547_109050_A13C92AA)
In-Reply-To: <20171125153510.25359-1-luca@coelho.fi>
References: <20171125153510.25359-1-luca@coelho.fi>
Subject: [PATCH 2/6] iwlwifi: mvm: don't use transmit queue hang detection when it is not possible
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we act as an AP, new firmware versions handle
internally the power saving clients and the driver doesn't
know that the peers went to sleep. It is, hence, possible
that a peer goes to sleep for a long time and stop pulling
frames. This will cause its transmit queue to hang which is
a condition that triggers the recovery flow in the driver.

While this client is certainly buggy (it should have pulled
the frame based on the TIM IE in the beacon), we can't blow
up because of a buggy client.

Change the current implementation to not enable the
transmit queue hang detection on queues that serve peers
when we act as an AP / GO.

We can still enable this mechanism using the debug
configuration which can come in handy when we want to
debug why the client doesn't wake up.

Cc: stable@vger.kernel.org # v4.13
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index d46115e2d69e..19c1d1f76e15 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1134,9 +1134,18 @@ unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 	unsigned int default_timeout =
 		cmd_q ? IWL_DEF_WD_TIMEOUT : mvm->cfg->base_params->wd_timeout;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TXQ_TIMERS))
+	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TXQ_TIMERS)) {
+		/*
+		 * We can't know when the station is asleep or awake, so we
+		 * must disable the queue hang detection.
+		 */
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_STA_PM_NOTIF) &&
+		    vif && vif->type == NL80211_IFTYPE_AP)
+			return IWL_WATCHDOG_DISABLED;
 		return iwlmvm_mod_params.tfd_q_hang_detect ?
 			default_timeout : IWL_WATCHDOG_DISABLED;
+	}
 
 	trigger = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TXQ_TIMERS);
 	txq_timer = (void *)trigger->data;
-- 
2.15.0
