Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYGRF41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/13] iwlwifi: move beacon handling to iwl4965-base.c
Date: Fri, 18 Jul 2008 13:53:03 +0800
Message-Id: <1216360389-5352-8-git-send-email-yi.zhu@intel.com> (sfid-20080718_075630_989745_37E0F9C8)
In-Reply-To: <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch concentrates becaon handling in iwl4965-base.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   32 ----------------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   39 ++++++++++++++++++++++++---
 4 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 39107c9..32baeb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1689,38 +1689,6 @@ static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
 	return le32_to_cpu(s->rb_closed) & 0xFFF;
 }
 
-unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-			  struct iwl_frame *frame, u8 rate)
-{
-	struct iwl4965_tx_beacon_cmd *tx_beacon_cmd;
-	unsigned int frame_size;
-
-	tx_beacon_cmd = &frame->u.beacon;
-	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
-
-	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
-	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-
-	frame_size = iwl4965_fill_beacon_frame(priv,
-				tx_beacon_cmd->frame,
-				iwl_bcast_addr,
-				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
-
-	BUG_ON(frame_size > MAX_MPDU_SIZE);
-	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
-
-	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
-		tx_beacon_cmd->tx.rate_n_flags =
-			iwl_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
-	else
-		tx_beacon_cmd->tx.rate_n_flags =
-			iwl_hw_set_rate_n_flags(rate, 0);
-
-	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
-				TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK);
-	return (sizeof(*tx_beacon_cmd) + frame_size);
-}
-
 static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 {
 	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 74a8397..9df96d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2323,7 +2323,7 @@ struct iwl4965_beacon_notif {
 /*
  * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
  */
-struct iwl4965_tx_beacon_cmd {
+struct iwl_tx_beacon_cmd {
 	struct iwl_tx_cmd tx;
 	__le16 tim_idx;
 	u8 tim_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d2d4bea..ff16cca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -219,7 +219,7 @@ enum iwl_pwr_src {
 struct iwl_frame {
 	union {
 		struct ieee80211_hdr frame;
-		struct iwl4965_tx_beacon_cmd beacon;
+		struct iwl_tx_beacon_cmd beacon;
 		u8 raw[IEEE80211_FRAME_LEN];
 		u8 cmd[360];
 	} u;
@@ -286,7 +286,6 @@ struct iwl_cmd {
 		struct iwl_powertable_cmd powertable;
 		struct iwl_qosparam_cmd qosparam;
 		struct iwl_tx_cmd tx;
-		struct iwl4965_tx_beacon_cmd tx_beacon;
 		struct iwl4965_rxon_assoc_cmd rxon_assoc;
 		struct iwl_rem_sta_cmd rm_sta;
 		u8 *indirect;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d3ed3ca..e468936 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -444,11 +444,10 @@ static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 	list_add(&frame->list, &priv->free_frames);
 }
 
-unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
-				struct ieee80211_hdr *hdr,
-				const u8 *dest, int left)
+static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+					  struct ieee80211_hdr *hdr,
+					  const u8 *dest, int left)
 {
-
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
 	    ((priv->iw_mode != IEEE80211_IF_TYPE_IBSS) &&
 	     (priv->iw_mode != IEEE80211_IF_TYPE_AP)))
@@ -487,6 +486,38 @@ static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 		return IWL_RATE_6M_PLCP;
 }
 
+unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
+				       struct iwl_frame *frame, u8 rate)
+{
+	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
+	unsigned int frame_size;
+
+	tx_beacon_cmd = &frame->u.beacon;
+	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
+
+	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
+	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+
+	frame_size = iwl_fill_beacon_frame(priv, tx_beacon_cmd->frame,
+				iwl_bcast_addr,
+				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
+
+	BUG_ON(frame_size > MAX_MPDU_SIZE);
+	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
+
+	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
+		tx_beacon_cmd->tx.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
+	else
+		tx_beacon_cmd->tx.rate_n_flags =
+			iwl_hw_set_rate_n_flags(rate, 0);
+
+	tx_beacon_cmd->tx.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK |
+				     TX_CMD_FLG_TSF_MSK |
+				     TX_CMD_FLG_STA_RATE_MSK;
+
+	return sizeof(*tx_beacon_cmd) + frame_size;
+}
 static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_frame *frame;
-- 
1.5.3.6

