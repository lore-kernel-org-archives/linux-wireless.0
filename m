Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0HWOx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/26] iwlagn: set BT IGNORE for some frames
Date: Mon, 23 Aug 2010 07:56:56 -0700
Message-Id: <1282575437-23270-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The BT ignore bit should be set when transmitting
auth, assoc response and eap frames.

Also, scanning should set the BT ignore bit for the
probe request transmission; Note that we only use
the non-shared antenna.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   17 ++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index eedd71f..e1b5250 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1290,6 +1290,12 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			rate = IWL_RATE_1M_PLCP;
 			rate_flags = RATE_MCS_CCK_MSK;
 		}
+		/*
+		 * Internal scans are passive, so we can indiscriminately set
+		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
+		 */
+		if (priv->cfg->advanced_bt_coexist)
+			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
 		scan->good_CRC_th = IWL_GOOD_CRC_TH_DISABLED;
 		break;
 	case IEEE80211_BAND_5GHZ:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 3fc982e..8d2ffff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -342,10 +342,11 @@ static inline int get_queue_from_ac(u16 ac)
  * handle build REPLY_TX command notification.
  */
 static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
-				  struct iwl_tx_cmd *tx_cmd,
-				  struct ieee80211_tx_info *info,
-				  struct ieee80211_hdr *hdr,
-				  u8 std_id)
+					struct sk_buff *skb,
+					struct iwl_tx_cmd *tx_cmd,
+					struct ieee80211_tx_info *info,
+					struct ieee80211_hdr *hdr,
+					u8 std_id)
 {
 	__le16 fc = hdr->frame_control;
 	__le32 tx_flags = tx_cmd->tx_flags;
@@ -365,6 +366,12 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 
 	if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
+	else if (info->band == IEEE80211_BAND_2GHZ &&
+		 priv->cfg->advanced_bt_coexist &&
+		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
+		 ieee80211_is_reassoc_req(fc) ||
+		 skb->protocol == cpu_to_be16(ETH_P_PAE)))
+		tx_flags |= TX_CMD_FLG_IGNORE_BT;
 
 
 	tx_cmd->sta_id = std_id;
@@ -655,7 +662,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwlagn_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
 
 	/* TODO need this for burst mode later on */
-	iwlagn_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
+	iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);
 	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 
 	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
-- 
1.7.0.4

