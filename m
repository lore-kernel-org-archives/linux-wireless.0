Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36662 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752770AbdAZHYa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 02:24:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Sara Sharon <sara.sharon@intel.com>
Date: Thu, 26 Jan 2017 09:24:17 +0200
Message-Id: <20170126072417.19802-1-luca@coelho.fi> (sfid-20170126_082434_594107_9C7B7D13)
In-Reply-To: <20170123220350.25305-12-luca@coelho.fi>
References: <20170123220350.25305-12-luca@coelho.fi>
Subject: [PATCH v2] iwlwifi: mvm: change iwl_mvm_tx_csum to return value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the function changes the TX cmd itself.
Make it more generic by returning a value, as preperation
to the new TX cmd.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2:

   * Fix compilation warning when CONFIG_INET is not set

drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 66957ac12ca4..73a90d4a43eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -102,14 +102,13 @@ iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
 #define OPT_HDR(type, skb, off) \
 	(type *)(skb_network_header(skb) + (off))
 
-static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
-			    struct ieee80211_hdr *hdr,
-			    struct ieee80211_tx_info *info,
-			    struct iwl_tx_cmd *tx_cmd)
+static u16 iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
+			   struct ieee80211_hdr *hdr,
+			   struct ieee80211_tx_info *info)
 {
+	u16 offload_assist = 0;
 #if IS_ENABLED(CONFIG_INET)
 	u16 mh_len = ieee80211_hdrlen(hdr->frame_control);
-	u16 offload_assist = le16_to_cpu(tx_cmd->offload_assist);
 	u8 protocol = 0;
 
 	/*
@@ -117,7 +116,7 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * compute it
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL || IWL_MVM_SW_TX_CSUM_OFFLOAD)
-		return;
+		goto out;
 
 	/* We do not expect to be requested to csum stuff we do not support */
 	if (WARN_ONCE(!(mvm->hw->netdev_features & IWL_TX_CSUM_NETIF_FLAGS) ||
@@ -125,7 +124,7 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 		       skb->protocol != htons(ETH_P_IPV6)),
 		      "No support for requested checksum\n")) {
 		skb_checksum_help(skb);
-		return;
+		goto out;
 	}
 
 	if (skb->protocol == htons(ETH_P_IP)) {
@@ -145,7 +144,7 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 			    protocol != NEXTHDR_HOP &&
 			    protocol != NEXTHDR_DEST) {
 				skb_checksum_help(skb);
-				return;
+				goto out;
 			}
 
 			hp = OPT_HDR(struct ipv6_opt_hdr, skb, off);
@@ -159,7 +158,7 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
 		WARN_ON_ONCE(1);
 		skb_checksum_help(skb);
-		return;
+		goto out;
 	}
 
 	/* enable L4 csum */
@@ -191,8 +190,9 @@ static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 	mh_len /= 2;
 	offload_assist |= mh_len << TX_CMD_OFFLD_MH_SIZE;
 
-	tx_cmd->offload_assist = cpu_to_le16(offload_assist);
+out:
 #endif
+	return offload_assist;
 }
 
 /*
@@ -295,7 +295,8 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !(tx_cmd->offload_assist & cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU))))
 		tx_cmd->offload_assist |= cpu_to_le16(BIT(TX_CMD_OFFLD_PAD));
 
-	iwl_mvm_tx_csum(mvm, skb, hdr, info, tx_cmd);
+	tx_cmd->offload_assist |=
+		cpu_to_le16(iwl_mvm_tx_csum(mvm, skb, hdr, info));
 }
 
 /*
-- 
2.11.0
