Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752263AbdG1O0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:32 +0300
Message-Id: <20170728142337.19183-20-luca@coelho.fi> (sfid-20170728_162618_806665_AB132C68)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 19/24] iwlwifi: mvm: fix TCP CSUM offload with WEP and A000 series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we enabled TCP checksum offload, we need to tell the
firmware where the IP header starts. If we have an IV, then
we need to adapt that value since the IV is placed before
the SNAP header. This is true only for cases where the
driver adds the IV, not the WEP case in which the IV is
added by the firmware itself.

On A000 devices series, the IV is always added by the
device.

Fix this.

Fixes: 5e6a98dc4863 ("iwlwifi: mvm: enable TCP/UDP checksum support for 9000 family")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index cccff1073e3b..f16228f9b93b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -184,8 +184,14 @@ static u16 iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 	else
 		udp_hdr(skb)->check = 0;
 
-	/* mac header len should include IV, size is in words */
-	if (info->control.hw_key)
+	/*
+	 * mac header len should include IV, size is in words unless
+	 * the IV is added by the firmware like in WEP.
+	 * In new Tx API, the IV is always added by the firmware.
+	 */
+	if (!iwl_mvm_has_new_tx_api(mvm) && info->control.hw_key &&
+	    info->control.hw_key->cipher != WLAN_CIPHER_SUITE_WEP40 &&
+	    info->control.hw_key->cipher != WLAN_CIPHER_SUITE_WEP104)
 		mh_len += info->control.hw_key->iv_len;
 	mh_len /= 2;
 	offload_assist |= mh_len << TX_CMD_OFFLD_MH_SIZE;
-- 
2.13.2
