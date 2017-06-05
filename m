Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59238 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751258AbdFEUmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:41:54 +0300
Message-Id: <20170605204218.30151-2-luca@coelho.fi> (sfid-20170605_224237_453073_094F0579)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: add AMSDU flag to offload assist
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Enable offload assist for AMSDU when the AMSDU present flag is set.

Fixes: a830baba9c2e ("iwlwifi: mvm: support new TX API")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 64ca8b92f8d2..4d0d23b224c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -480,8 +480,14 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		struct iwl_tx_cmd_gen2 *cmd = (void *)dev_cmd->payload;
 		u16 offload_assist = iwl_mvm_tx_csum(mvm, skb, hdr, info);
 
+		if (ieee80211_is_data_qos(hdr->frame_control)) {
+			u8 *qc = ieee80211_get_qos_ctl(hdr);
+
+			if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
+				offload_assist |= BIT(TX_CMD_OFFLD_AMSDU);
+		}
+
 		/* padding is inserted later in transport */
-		/* FIXME - check for AMSDU may need to be removed */
 		if (ieee80211_hdrlen(hdr->frame_control) % 4 &&
 		    !(offload_assist & BIT(TX_CMD_OFFLD_AMSDU)))
 			offload_assist |= BIT(TX_CMD_OFFLD_PAD);
-- 
2.11.0
