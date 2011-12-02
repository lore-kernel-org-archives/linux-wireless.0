Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab1LBRqS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 12:46:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/16] iwlagn: remove MACDUMP debug
Date: Fri,  2 Dec 2011 08:48:33 -0800
Message-Id: <1322844520-21149-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111202_184644_623381_58D56D8E)
In-Reply-To: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322844520-21149-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is only used for TX debugging where there
already is more debugging and tracing is more
useful anyway, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 3220608..95740c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -139,7 +139,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_HCMD		(1 << 2)
 #define IWL_DL_STATE		(1 << 3)
 /* 0x000000F0 - 0x00000010 */
-#define IWL_DL_MACDUMP		(1 << 4)
+/* unused (1 << 4) */
 /* unused (1 << 5) */
 #define IWL_DL_EEPROM		(1 << 6)
 #define IWL_DL_RADIO		(1 << 7)
@@ -175,7 +175,6 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_MACDUMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_MACDUMP, f, ## a)
 #define IWL_DEBUG_TEMP(p, f, a...)	IWL_DEBUG(p, IWL_DL_TEMP, f, ## a)
 #define IWL_DEBUG_SCAN(p, f, a...)	IWL_DEBUG(p, IWL_DL_SCAN, f, ## a)
 #define IWL_DEBUG_RX(p, f, a...)	IWL_DEBUG(p, IWL_DL_RX, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index bafd525..2dd536c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -481,15 +481,11 @@ static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
 
-	IWL_DEBUG_MACDUMP(priv, "enter\n");
-
 	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
 	if (iwlagn_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
-
-	IWL_DEBUG_MACDUMP(priv, "leave\n");
 }
 
 static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
-- 
1.7.0.4

