Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42216 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbeHRLf3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:35:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:44 +0300
Message-Id: <20180818082750.28717-11-luca@coelho.fi> (sfid-20180818_102841_841230_E7D83BB3)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: mvm: add bss color to radiotap
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Add BSS color to the HE radiotap.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index b53148f972a4..4af3ab2ee1a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1042,6 +1042,20 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 						   he_phy_data),
 					 IEEE80211_RADIOTAP_HE_MU_FLAGS2_PUNC_FROM_SIG_A_BW);
 	}
+
+	if (he_phy_data != HE_PHY_DATA_INVAL &&
+	    (he_type == RATE_MCS_HE_TYPE_SU ||
+	     he_type == RATE_MCS_HE_TYPE_MU)) {
+		u8 bss_color = FIELD_GET(IWL_RX_HE_PHY_BSS_COLOR_MASK,
+					 he_phy_data);
+
+		if (bss_color) {
+			he->data1 |=
+				cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_BSS_COLOR_KNOWN);
+			he->data3 |= cpu_to_le16(bss_color);
+		}
+	}
+
 	rx_status->device_timestamp = gp2_on_air_rise;
 	rx_status->band = channel > 14 ? NL80211_BAND_5GHZ :
 		NL80211_BAND_2GHZ;
-- 
2.18.0
