Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:33181 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaIOFLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:25 -0400
Received: by mail-we0-f169.google.com with SMTP id w61so3325634wes.14
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:11:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/12] iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength
Date: Mon, 15 Sep 2014 08:10:48 +0300
Message-Id: <1410757848-1827-12-git-send-email-egrumbach@gmail.com> (sfid-20140915_071135_465156_9130B0FD)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
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

