Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:65330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1GPPcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/18] iwlagn: simplify TX flags assignments
Date: Sat, 16 Jul 2011 07:56:31 -0700
Message-Id: <1310828199-18000-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173223_907281_C3906831)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The first assignment of TX_CMD_FLG_SEQ_CTL_MSK for
ack-expected mgmt frames is overwritten later in
the function, so it's useless. Also, probe response
frames, BACK request and others there are mutually
exclusive so can be moved into an else branch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f306824..554750d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -364,19 +364,15 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 	__le32 tx_flags = tx_cmd->tx_flags;
 
 	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if (ieee80211_is_mgmt(fc))
-			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-		if (ieee80211_is_probe_resp(fc) &&
-		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
-			tx_flags |= TX_CMD_FLG_TSF_MSK;
-	} else {
-		tx_flags &= (~TX_CMD_FLG_ACK_MSK);
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-	}
+	else
+		tx_flags &= ~TX_CMD_FLG_ACK_MSK;
 
-	if (ieee80211_is_back_req(fc))
+	if (ieee80211_is_probe_resp(fc))
+		tx_flags |= TX_CMD_FLG_TSF_MSK;
+	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
 	else if (info->band == IEEE80211_BAND_2GHZ &&
 		 priv->cfg->bt_params &&
-- 
1.7.0.4

