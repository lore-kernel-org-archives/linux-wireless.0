Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45656 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728084AbeHaODM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:03:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:04 +0300
Message-Id: <20180831095614.14099-7-luca@coelho.fi> (sfid-20180831_115637_300776_16386AAA)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: iwlmvm: fix typo when checking for TX Beamforming
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Check the actual bit (mask) in Rx notification rate_n_flags.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index f415c72394ee..4400e69a39b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1150,7 +1150,7 @@ static void iwl_mvm_rx_he(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	he->data1 |= cpu_to_le16(he_type >> RATE_MCS_HE_TYPE_POS);
 
-	if (rate_n_flags & RATE_MCS_BF_POS)
+	if (rate_n_flags & RATE_MCS_BF_MSK)
 		he->data5 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA5_TXBF);
 
 	switch ((rate_n_flags & RATE_MCS_HE_GI_LTF_MSK) >>
-- 
2.18.0
