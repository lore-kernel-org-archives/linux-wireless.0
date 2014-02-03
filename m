Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49181 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaBCU7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:36 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so3871384eek.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:35 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 48/62] iwlwifi: mvm: remove unneeded calculations
Date: Mon,  3 Feb 2014 22:57:54 +0200
Message-Id: <1391461088-8082-48-git-send-email-egrumbach@gmail.com> (sfid-20140203_220011_228652_FD7951B8)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In iwl_mvm_calc_rssi() some values are calculated but then
never used, remove the calculations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index a85b60f..ef727df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -129,22 +129,16 @@ static void iwl_mvm_calc_rssi(struct iwl_mvm *mvm,
 			      struct ieee80211_rx_status *rx_status)
 {
 	int rssi_a, rssi_b, rssi_a_dbm, rssi_b_dbm, max_rssi_dbm;
-	int rssi_all_band_a, rssi_all_band_b;
-	u32 agc_a, agc_b, max_agc;
+	u32 agc_a, agc_b;
 	u32 val;
 
 	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_AGC_IDX]);
 	agc_a = (val & IWL_OFDM_AGC_A_MSK) >> IWL_OFDM_AGC_A_POS;
 	agc_b = (val & IWL_OFDM_AGC_B_MSK) >> IWL_OFDM_AGC_B_POS;
-	max_agc = max_t(u32, agc_a, agc_b);
 
 	val = le32_to_cpu(phy_info->non_cfg_phy[IWL_RX_INFO_RSSI_AB_IDX]);
 	rssi_a = (val & IWL_OFDM_RSSI_INBAND_A_MSK) >> IWL_OFDM_RSSI_A_POS;
 	rssi_b = (val & IWL_OFDM_RSSI_INBAND_B_MSK) >> IWL_OFDM_RSSI_B_POS;
-	rssi_all_band_a = (val & IWL_OFDM_RSSI_ALLBAND_A_MSK) >>
-				IWL_OFDM_RSSI_ALLBAND_A_POS;
-	rssi_all_band_b = (val & IWL_OFDM_RSSI_ALLBAND_B_MSK) >>
-				IWL_OFDM_RSSI_ALLBAND_B_POS;
 
 	/*
 	 * dBm = rssi dB - agc dB - constant.
-- 
1.7.9.5

