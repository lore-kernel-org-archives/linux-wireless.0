Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751381AbdJ2M2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:02 +0200
Message-Id: <20171029122816.8802-4-luca@coelho.fi> (sfid-20171029_132849_400144_B7BA8807)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 03/17] iwlwifi: mvm: reset seq num after restart
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

After a FW reset on A000 NICs, the driver doesn't
set the seq number when re-allocating the queues.
This in turn leads to a mismatch between the seq
number the driver thinks each frame has, and the
actual seq num given by the HW.

This especially causes issues with aggregations,
since the driver could be waiting to start an
aggregation and queue traffic from the mac80211
until then, when actually it shouldn't be waiting.

Fixes: 310181ec34e2 ("iwlwifi: move to TVQM mode")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index c8febde2dffb..039efcd2735d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1257,6 +1257,14 @@ static void iwl_mvm_realloc_queues_after_restart(struct iwl_mvm *mvm,
 							 mvm_sta->sta_id,
 							 i, wdg_timeout);
 			tid_data->txq_id = txq_id;
+
+			/*
+			 * Since we don't set the seq number after reset, and HW
+			 * sets it now, FW reset will cause the seq num to start
+			 * at 0 again, so driver will need to update it
+			 * internally as well, so it keeps in sync with real val
+			 */
+			tid_data->seq_number = 0;
 		} else {
 			u16 seq = IEEE80211_SEQ_TO_SN(tid_data->seq_number);
 
-- 
2.14.2
