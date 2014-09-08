Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51594 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaIHQ4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:42 -0400
Received: by mail-wg0-f41.google.com with SMTP id k14so1052663wgh.24
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:56:41 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/12] iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength
Date: Mon,  8 Sep 2014 19:56:17 +0300
Message-Id: <1410195377-10075-12-git-send-email-egrumbach@gmail.com> (sfid-20140908_185646_758307_6AB47AEA)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The idea here is to translate a value of 0 received from
the firmware to the lowest rssi figure. As rx_status->chain_signal
is a signed byte the lowest possible value is -128 and not -256.
-256 was causing 0 to get stored in the signed byte.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 4b98987..bf5cd8c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -149,13 +149,13 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 	    le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_ENERGY_ANT_ABC_IDX]);
 	energy_a = (val & IWL_RX_INFO_ENERGY_ANT_A_MSK) >>
 						IWL_RX_INFO_ENERGY_ANT_A_POS;
-	energy_a = energy_a ? -energy_a : -256;
+	energy_a = energy_a ? -energy_a : S8_MIN;
 	energy_b = (val & IWL_RX_INFO_ENERGY_ANT_B_MSK) >>
 						IWL_RX_INFO_ENERGY_ANT_B_POS;
-	energy_b = energy_b ? -energy_b : -256;
+	energy_b = energy_b ? -energy_b : S8_MIN;
 	energy_c = (val & IWL_RX_INFO_ENERGY_ANT_C_MSK) >>
 						IWL_RX_INFO_ENERGY_ANT_C_POS;
-	energy_c = energy_c ? -energy_c : -256;
+	energy_c = energy_c ? -energy_c : S8_MIN;
 	max_energy = max(energy_a, energy_b);
 	max_energy = max(max_energy, energy_c);
 
-- 
1.9.1

