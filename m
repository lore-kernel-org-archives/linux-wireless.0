Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYCMAIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:08:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/5] iwlwifi-2.6: enables HW TKIP security
Date: Wed, 12 Mar 2008 17:06:01 -0700
Message-Id: <1205366762-12828-5-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000852_874662_6AE30F0B)
In-Reply-To: <1205366762-12828-4-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch add support for TKIP in HW.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   63 +++++++++++++++++++++++----
 1 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d47941d..d9df2b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1449,7 +1449,58 @@ static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
-	return -EOPNOTSUPP;
+	unsigned long flags;
+	__le16 key_flags = 0;
+	int i, ret = 0;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY;
+	keyconf->flags |= IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY;
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+	keyconf->hw_key_idx = sta_id;
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_setting.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.keylen = 16;
+
+	/* This copy is acutally not needed: we get the key with each TX */
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
+
+	priv->stations[sta_id].sta.key.key_offset = (sta_id%8);/*FIXME!!!*/
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	if (keyconf->flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
+		priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 =
+				(u8) keyconf->tkip_iv32;
+		for (i = 0; i < 5; i++)
+			priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
+				cpu_to_le16(keyconf->tkip_p1k[i]);
+	} else {
+		priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = 0xff;
+	}
+
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	/* Don't send an incomplete key: a key w/o valid TTAK */
+	if (keyconf->flags & IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID) {
+		IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
+		ret = iwl4965_send_add_station(priv,
+				&priv->stations[sta_id].sta, CMD_ASYNC);
+	}
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
 }
 
 static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
@@ -2484,15 +2535,9 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
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
+		memcpy(cmd->cmd.tx.key, ctl->tkip_key, keyinfo->keylen);
+		IWL_DEBUG_TX("tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case ALG_WEP:
-- 
1.5.3.4

