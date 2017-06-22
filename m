Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34216 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753735AbdFVVVI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:37 +0300
Message-Id: <20170622212101.16422-2-luca@coelho.fi> (sfid-20170622_232115_362421_965B0EC0)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: remove txq EMPTYING_DELBA state for DQA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In DQA mode, there is no need to wait for the TXQ to
clear out after getting a DELBA, since traffic can
continue running on the queue.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index bc52739eeb25..c76ffe1476b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2814,8 +2814,13 @@ int iwl_mvm_sta_tx_agg_stop(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				    "ssn = %d, next_recl = %d\n",
 				    tid_data->ssn, tid_data->next_reclaimed);
 
-		/* There are still packets for this RA / TID in the HW */
-		if (tid_data->ssn != tid_data->next_reclaimed) {
+		/*
+		 * There are still packets for this RA / TID in the HW.
+		 * Not relevant for DQA mode, since there is no need to disable
+		 * the queue.
+		 */
+		if (!iwl_mvm_is_dqa_supported(mvm) &&
+		    tid_data->ssn != tid_data->next_reclaimed) {
 			tid_data->state = IWL_EMPTYING_HW_QUEUE_DELBA;
 			err = 0;
 			break;
-- 
2.11.0
