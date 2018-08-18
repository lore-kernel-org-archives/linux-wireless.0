Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbeHRLfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:35:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:45 +0300
Message-Id: <20180818082750.28717-12-luca@coelho.fi> (sfid-20180818_102828_629559_DBDA16D1)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 11/16] iwlwifi: mvm: add support for RX_AMPDU_EOF bit for HE SU
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Current implementation turns this bit on only for HE MU.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 4af3ab2ee1a8..311c639e23de 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1082,7 +1082,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			mvm->ampdu_toggle = toggle_bit;
 
 			if (he_phy_data != HE_PHY_DATA_INVAL &&
-			    he_type == RATE_MCS_HE_TYPE_MU) {
+			    (he_type == RATE_MCS_HE_TYPE_MU ||
+			     he_type == RATE_MCS_HE_TYPE_SU)) {
 				rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
 				if (FIELD_GET(IWL_RX_HE_PHY_DELIM_EOF,
 					      he_phy_data))
-- 
2.18.0
