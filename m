Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbcAaLHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:07:03 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/31] iwlwifi: pcie: update iwl_mpdu_desc fields
Date: Sun, 31 Jan 2016 13:06:25 +0200
Message-Id: <1454238386-27032-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123653_527785_5E37153C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Final API of iwl_mpdu_desc has a change in the order of
the fields and does not include energy from the third
antenna (which is perfectly fine, since we don't have one).
Update the structure accordingly.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h |  6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 11 ++++-------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index b45c61e..df939f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -347,11 +347,11 @@ struct iwl_rx_mpdu_desc {
 	/* DW8 */
 	__le32 filter_match;
 	/* DW9 */
-	__le32 gp2_on_air_rise;
-	/* DW10 */
 	__le32 rate_n_flags;
+	/* DW10 */
+	u8 energy_a, energy_b, channel, reserved;
 	/* DW11 */
-	u8 energy_a, energy_b, energy_c, channel;
+	__le32 gp2_on_air_rise;
 	/* DW12 & DW13 */
 	__le64 tsf_on_air_rise;
 } __packed;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 4cce372..615dea1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -201,25 +201,22 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 					struct iwl_rx_mpdu_desc *desc,
 					struct ieee80211_rx_status *rx_status)
 {
-	int energy_a, energy_b, energy_c, max_energy;
+	int energy_a, energy_b, max_energy;
 
 	energy_a = desc->energy_a;
 	energy_a = energy_a ? -energy_a : S8_MIN;
 	energy_b = desc->energy_b;
 	energy_b = energy_b ? -energy_b : S8_MIN;
-	energy_c = desc->energy_c;
-	energy_c = energy_c ? -energy_c : S8_MIN;
 	max_energy = max(energy_a, energy_b);
-	max_energy = max(max_energy, energy_c);
 
-	IWL_DEBUG_STATS(mvm, "energy In A %d B %d C %d , and max %d\n",
-			energy_a, energy_b, energy_c, max_energy);
+	IWL_DEBUG_STATS(mvm, "energy In A %d B %d, and max %d\n",
+			energy_a, energy_b, max_energy);
 
 	rx_status->signal = max_energy;
 	rx_status->chains = 0; /* TODO: phy info */
 	rx_status->chain_signal[0] = energy_a;
 	rx_status->chain_signal[1] = energy_b;
-	rx_status->chain_signal[2] = energy_c;
+	rx_status->chain_signal[2] = S8_MIN;
 }
 
 static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
-- 
2.5.0

