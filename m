Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939256AbYCSXts (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6/7] iwlwifi-2.6: enables HW TKIP encryption
Date: Wed, 19 Mar 2008 16:41:45 -0700
Message-Id: <1205970106-22196-7-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235020_178777_B73C0554)
In-Reply-To: <1205970106-22196-6-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-4-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-5-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch add support for TKIP encryption (TX) in HW.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   33 +++++++++++++++++++-------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index bf17289..0842176 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -478,6 +478,7 @@ struct iwl4965_tid_data {
 struct iwl4965_hw_key {
 	enum ieee80211_key_alg alg;
 	int keylen;
+	struct ieee80211_key_conf *conf;
 	u8 key[32];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9d4cd8e..2449e00 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1385,7 +1385,27 @@ static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
-	return -EOPNOTSUPP;
+	unsigned long flags;
+	int ret = 0;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+	keyconf->hw_key_idx = keyconf->keyidx;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.conf = keyconf;
+	priv->stations[sta_id].keyinfo.keylen = 16;
+
+	/* This copy is acutally not needed: we get the key with each TX */
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
 }
 
 static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
@@ -2333,15 +2353,10 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_TKIP:
-#if 0
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
-
-		if (last_frag)
-			memcpy(cmd->cmd.tx.tkip_mic.byte, skb_frag->tail - 8,
-			       8);
-		else
-			memset(cmd->cmd.tx.tkip_mic.byte, 0, 8);
-#endif
+		ieee80211_get_tkip_key(keyinfo->conf, skb_frag,
+			IEEE80211_TKIP_P2_KEY, cmd->cmd.tx.key);
+		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case ALG_WEP:
-- 
1.5.3.4

