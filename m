Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1GUP0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/25] iwlagn: rename iwlagn_set_dynamic_key
Date: Thu, 21 Jul 2011 07:50:26 -0700
Message-Id: <1311259828-8415-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172706_433487_25871719)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We now have iwlagn_set_dynamic_key() and
iwl_set_dynamic_key() which is confusing,
rename the former to iwlagn_send_sta_key()
to better reflect what it does -- it only
sends a command and doesn't change driver
state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 7a2babe..37e6240 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -301,15 +301,16 @@ static u8 iwlagn_key_sta_id(struct iwl_priv *priv,
 	return sta_id;
 }
 
-static int iwlagn_set_dynamic_key(struct iwl_priv *priv,
-				  struct ieee80211_key_conf *keyconf,
-				  u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
-				  u32 cmd_flags)
+static int iwlagn_send_sta_key(struct iwl_priv *priv,
+			       struct ieee80211_key_conf *keyconf,
+			       u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
+			       u32 cmd_flags)
 {
 	unsigned long flags;
 	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
 	int i;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
@@ -370,8 +371,8 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 		return;
 	}
 
-	iwlagn_set_dynamic_key(priv, keyconf, sta_id,
-			       iv32, phase1key, CMD_ASYNC);
+	iwlagn_send_sta_key(priv, keyconf, sta_id,
+			    iv32, phase1key, CMD_ASYNC);
 }
 
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
@@ -450,16 +451,16 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 		/* pre-fill phase 1 key into device cache */
 		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
 		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
-		ret = iwlagn_set_dynamic_key(priv, keyconf, sta_id,
-					     seq.tkip.iv32, p1k, CMD_SYNC);
+		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
+					  seq.tkip.iv32, p1k, CMD_SYNC);
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		ret = iwlagn_set_dynamic_key(priv, keyconf, sta_id,
-					     0, NULL, CMD_SYNC);
+		ret = iwlagn_send_sta_key(priv, keyconf, sta_id,
+					  0, NULL, CMD_SYNC);
 		break;
 	default:
 		IWL_ERR(priv, "Unknown cipher %x\n", keyconf->cipher);
-- 
1.7.0.4

