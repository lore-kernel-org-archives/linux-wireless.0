Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47432 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751383AbdKYQev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Nov 2017 11:34:51 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 25 Nov 2017 18:34:34 +0200
Message-Id: <20171125163444.24258-2-luca@coelho.fi> (sfid-20171125_173519_673780_5D0FC03F)
In-Reply-To: <20171125163444.24258-1-luca@coelho.fi>
References: <20171125163444.24258-1-luca@coelho.fi>
Subject: [PATCH 01/11] iwlwifi: mvm: check for short GI only for OFDM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This bit will be used in CCK to indicate short preamble.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index d1a40688d5e1..7cbea7890b0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -439,7 +439,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->bw = RATE_INFO_BW_160;
 		break;
 	}
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
+	if (!(rate_n_flags & RATE_MCS_CCK_MSK) &&
+	    rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_HT_GF;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 76dc58381e1c..f444ff3a3396 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1010,7 +1010,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		rx_status->bw = RATE_INFO_BW_160;
 		break;
 	}
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
+
+	if (!(rate_n_flags & RATE_MCS_CCK_MSK) &&
+	    rate_n_flags & RATE_MCS_SGI_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
 		rx_status->enc_flags |= RX_ENC_FLAG_HT_GF;
-- 
2.15.0
