Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965063Ab2CEUiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 02/33] iwlwifi: remove an unused argument
Date: Mon,  5 Mar 2012 11:24:20 -0800
Message-Id: <1330975491-19680-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213907_953375_20D535C6)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station ID argument to the function
iwlagn_tx_cmd_build_hwcrypto isn't used
so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 5f78567..81a3b0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -208,10 +208,9 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 }
 
 static void iwlagn_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
-				      struct ieee80211_tx_info *info,
-				      struct iwl_tx_cmd *tx_cmd,
-				      struct sk_buff *skb_frag,
-				      int sta_id)
+					 struct ieee80211_tx_info *info,
+					 struct iwl_tx_cmd *tx_cmd,
+					 struct sk_buff *skb_frag)
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;
 
@@ -358,7 +357,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	tx_cmd->len = cpu_to_le16(len);
 
 	if (info->control.hw_key)
-		iwlagn_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+		iwlagn_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb);
 
 	/* TODO need this for burst mode later on */
 	iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);
-- 
1.7.0.4

