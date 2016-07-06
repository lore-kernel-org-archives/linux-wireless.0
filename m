Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33232 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753426AbcGFKlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:41:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:05 +0300
Message-Id: <1467801651-1816-10-git-send-email-luca@coelho.fi> (sfid-20160706_124133_532549_098BACAF)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 10/56] iwlwifi: mvm: set sta_id in SCD_QUEUE_CONFIG cmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Set the correct sta_id in the SCD_QUEUE_CONFIG command sent
to the FW when enabling/disabling queues. This is needed in
DQA-mode to allow the FW to associate between queue and STA.

In case the queue isn't connected to a specific station but
rather is a static "generic" queue - the sta_id should be
set to 0x10 (max supported STA is 0x0f).

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 14c06cb..9d4ebc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -635,9 +635,16 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 			.scd_queue = queue,
 			.enable = 0,
 		};
+		u8 ac;
 
 		disable_agg_tids = iwl_mvm_remove_sta_queue_marking(mvm, queue);
 
+		spin_lock_bh(&mvm->queue_info_lock);
+		ac = mvm->queue_info[queue].mac80211_ac;
+		cmd.sta_id = mvm->queue_info[queue].ra_sta_id;
+		cmd.tx_fifo = iwl_mvm_ac_to_tx_fifo[ac];
+		spin_unlock_bh(&mvm->queue_info_lock);
+
 		/* Disable the queue */
 		iwl_mvm_invalidate_sta_queue(mvm, queue, disable_agg_tids,
 					     true);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2fc51e7..68f4e7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -691,6 +691,10 @@ void iwl_mvm_enable_txq(struct iwl_mvm *mvm, int queue, int mac80211_queue,
 			.tid = cfg->tid,
 		};
 
+		/* Set sta_id in the command, if it exists */
+		if (iwl_mvm_is_dqa_supported(mvm))
+			cmd.sta_id = cfg->sta_id;
+
 		iwl_trans_txq_enable_cfg(mvm->trans, queue, ssn, NULL,
 					 wdg_timeout);
 		WARN(iwl_mvm_send_cmd_pdu(mvm, SCD_QUEUE_CFG, 0, sizeof(cmd),
-- 
2.8.1

