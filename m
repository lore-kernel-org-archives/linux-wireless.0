Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36222 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752787AbdF2Sai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:15 +0300
Message-Id: <20170629183027.15408-4-luca@coelho.fi> (sfid-20170629_203046_237074_5995A564)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 03/15] iwlwifi: mvm: properly enable IP header checksumming
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code was intended to enable IP header checksumming on AMSDUs, but
failed to really do so because the A-MSDU bit was set after all the
checksumming bits, and thus checking for A-MSDU could never be true.

Fix this by setting the A-MSDU bit before the offload bits.

Fixes: 5e6a98dc4863 ("iwlwifi: mvm: enable TCP/UDP checksum support for 9000 family")
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 214829e5a860..419d0351e0ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -105,9 +105,9 @@ iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
 
 static u16 iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 			   struct ieee80211_hdr *hdr,
-			   struct ieee80211_tx_info *info)
+			   struct ieee80211_tx_info *info,
+			   u16 offload_assist)
 {
-	u16 offload_assist = 0;
 #if IS_ENABLED(CONFIG_INET)
 	u16 mh_len = ieee80211_hdrlen(hdr->frame_control);
 	u8 protocol = 0;
@@ -207,6 +207,7 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	__le16 fc = hdr->frame_control;
 	u32 tx_flags = le32_to_cpu(tx_cmd->tx_flags);
 	u32 len = skb->len + FCS_LEN;
+	u16 offload_assist = 0;
 	u8 ac;
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -225,8 +226,7 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
 		if (*qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
-			tx_cmd->offload_assist |=
-				cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU));
+			offload_assist |= BIT(TX_CMD_OFFLD_AMSDU);
 	} else if (ieee80211_is_back_req(fc)) {
 		struct ieee80211_bar *bar = (void *)skb->data;
 		u16 control = le16_to_cpu(bar->control);
@@ -291,11 +291,12 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	/* padding is inserted later in transport */
 	if (ieee80211_hdrlen(fc) % 4 &&
-	    !(tx_cmd->offload_assist & cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU))))
-		tx_cmd->offload_assist |= cpu_to_le16(BIT(TX_CMD_OFFLD_PAD));
+	    !(offload_assist & BIT(TX_CMD_OFFLD_AMSDU)))
+		offload_assist |= BIT(TX_CMD_OFFLD_PAD);
 
 	tx_cmd->offload_assist |=
-		cpu_to_le16(iwl_mvm_tx_csum(mvm, skb, hdr, info));
+		cpu_to_le16(iwl_mvm_tx_csum(mvm, skb, hdr, info,
+					    offload_assist));
 }
 
 static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
@@ -481,7 +482,7 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		struct iwl_tx_cmd_gen2 *cmd = (void *)dev_cmd->payload;
-		u16 offload_assist = iwl_mvm_tx_csum(mvm, skb, hdr, info);
+		u16 offload_assist = 0;
 
 		if (ieee80211_is_data_qos(hdr->frame_control)) {
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
@@ -490,6 +491,9 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 				offload_assist |= BIT(TX_CMD_OFFLD_AMSDU);
 		}
 
+		offload_assist = iwl_mvm_tx_csum(mvm, skb, hdr, info,
+						 offload_assist);
+
 		/* padding is inserted later in transport */
 		if (ieee80211_hdrlen(hdr->frame_control) % 4 &&
 		    !(offload_assist & BIT(TX_CMD_OFFLD_AMSDU)))
-- 
2.11.0
