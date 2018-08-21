Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42708 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726253AbeHUI27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 04:28:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 08:09:46 +0300
Message-Id: <20180821050952.31603-12-luca@coelho.fi> (sfid-20180821_071028_637677_2140A376)
In-Reply-To: <20180821050952.31603-1-luca@coelho.fi>
References: <20180821050952.31603-1-luca@coelho.fi>
Subject: [PATCH v2 11/17] iwlwifi: mvm: add bss color to radiotap
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
