Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752243AbdG1O0C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:27 +0300
Message-Id: <20170728142337.19183-15-luca@coelho.fi> (sfid-20170728_162611_420065_BD760F3E)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 14/24] iwlwifi: pcie: fix A-MSDU on gen2 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The return status check of iwl_pcie_gen2_build_amsdu
was buggy. Fix it.

Fixes: 6ffe5de35b05 ("iwlwifi: pcie: add AMSDU to gen2")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 5e85f29220f6..5dc785d4c167 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -422,9 +422,9 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
 	if (amsdu) {
-		if (!iwl_pcie_gen2_build_amsdu(trans, skb, tfd,
-					       tb1_len + IWL_FIRST_TB_SIZE,
-					       hdr_len, dev_cmd))
+		if (iwl_pcie_gen2_build_amsdu(trans, skb, tfd,
+					      tb1_len + IWL_FIRST_TB_SIZE,
+					      hdr_len, dev_cmd))
 			goto out_err;
 
 		/*
-- 
2.13.2
