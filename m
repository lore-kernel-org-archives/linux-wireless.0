Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751631AbdKYPfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 10:35:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 17:35:05 +0200
Message-Id: <20171125153510.25359-2-luca@coelho.fi> (sfid-20171125_163533_786674_351B2735)
In-Reply-To: <20171125153510.25359-1-luca@coelho.fi>
References: <20171125153510.25359-1-luca@coelho.fi>
Subject: [PATCH 1/6] iwlwifi: mvm: set correct chains in Rx status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

ieee80211_rx_status::chains was always set to zero.
That caused rate scaling to always start with the
lowest rate possible (rs_get_initial_rate).
Set it correctly according to the MPDU response.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 76dc58381e1c..20fe23fbf040 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -213,6 +213,7 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 					struct ieee80211_rx_status *rx_status)
 {
 	int energy_a, energy_b, max_energy;
+	u32 rate_flags = le32_to_cpu(desc->rate_n_flags);
 
 	energy_a = desc->energy_a;
 	energy_a = energy_a ? -energy_a : S8_MIN;
@@ -224,7 +225,8 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 			energy_a, energy_b, max_energy);
 
 	rx_status->signal = max_energy;
-	rx_status->chains = 0; /* TODO: phy info */
+	rx_status->chains =
+		(rate_flags & RATE_MCS_ANT_AB_MSK) >> RATE_MCS_ANT_POS;
 	rx_status->chain_signal[0] = energy_a;
 	rx_status->chain_signal[1] = energy_b;
 	rx_status->chain_signal[2] = S8_MIN;
-- 
2.15.0
