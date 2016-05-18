Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41852 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753863AbcERTAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 15:00:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: linus@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, reinoudkoornstra@gmail.com,
	linux-kernel@vger.kernel.org, linuxwifi@intel.com,
	johannes.berg@intel.com, akpm@linux-foundation.org,
	kvalo@codeaurora.org, egrumbach@gmail.com, netdev@vger.kernel.org,
	davem@davemloft.net
Date: Wed, 18 May 2016 22:00:09 +0300
Message-Id: <1463598009-31865-1-git-send-email-luca@coelho.fi> (sfid-20160518_210057_649314_FAE6EC92)
In-Reply-To: <1463597411.29999.16.camel@intel.com>
References: <1463597411.29999.16.camel@intel.com>
Subject: [PATCH] iwlwifi: mvm: fix merge damage in tx.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

During the merge in commit 909b27f70643 ("Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net"), there was a
small merge damage where one instance of info was not converted into
skb_info.  Fix this.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8802109..c53aa0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -211,6 +211,7 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 			struct iwl_tx_cmd *tx_cmd,
 			struct ieee80211_tx_info *info, u8 sta_id)
 {
+	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	__le16 fc = hdr->frame_control;
 	u32 tx_flags = le32_to_cpu(tx_cmd->tx_flags);
@@ -294,7 +295,7 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	tx_cmd->tx_flags = cpu_to_le32(tx_flags);
 	/* Total # bytes to be transmitted */
 	tx_cmd->len = cpu_to_le16((u16)skb->len +
-		(uintptr_t)info->driver_data[0]);
+		(uintptr_t)skb_info->driver_data[0]);
 	tx_cmd->life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	tx_cmd->sta_id = sta_id;
 
-- 
2.8.1

