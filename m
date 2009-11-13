Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZKMT4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/16] iwlwifi: fix bugs in beacon configuration
Date: Fri, 13 Nov 2009 11:56:33 -0800
Message-Id: <1258142198-3223-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

When sending beacon commands to the uCode, we must
inform it of the offset in the beacon frame of the
TIM Element so it can transmit packets from the
correct queue. This functionality is implemented
in iwl_set_beacon_tim().

Fix a bug setting the rate_n_flags for the beacon
packet. First, it should not use the station table's
rate (it's a management frame), and second it needs
to properly configure the TX antennas.

Finally, also, clean up and comment relevant functions.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   83 +++++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 2 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d2050d0..24f3192 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -311,7 +311,7 @@ static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 	list_add(&frame->list, &priv->free_frames);
 }
 
-static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
 					  struct ieee80211_hdr *hdr,
 					  int left)
 {
@@ -328,34 +328,74 @@ static unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
 	return priv->ibss_beacon->len;
 }
 
+/* Parse the beacon frame to find the TIM element and set tim_idx & tim_size */
+static void iwl_set_beacon_tim(struct iwl_priv *priv,
+		struct iwl_tx_beacon_cmd *tx_beacon_cmd,
+		u8 *beacon, u32 frame_size)
+{
+	u16 tim_idx;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)beacon;
+
+	/*
+	 * The index is relative to frame start but we start looking at the
+	 * variable-length part of the beacon.
+	 */
+	tim_idx = mgmt->u.beacon.variable - beacon;
+
+	/* Parse variable-length elements of beacon to find WLAN_EID_TIM */
+	while ((tim_idx < (frame_size - 2)) &&
+			(beacon[tim_idx] != WLAN_EID_TIM))
+		tim_idx += beacon[tim_idx+1] + 2;
+
+	/* If TIM field was found, set variables */
+	if ((tim_idx < (frame_size - 1)) && (beacon[tim_idx] == WLAN_EID_TIM)) {
+		tx_beacon_cmd->tim_idx = cpu_to_le16(tim_idx);
+		tx_beacon_cmd->tim_size = beacon[tim_idx+1];
+	} else
+		IWL_WARN(priv, "Unable to find TIM Element in beacon\n");
+}
+
 static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-				       struct iwl_frame *frame, u8 rate)
+				       struct iwl_frame *frame)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
-	unsigned int frame_size;
+	u32 frame_size;
+	u32 rate_flags;
+	u32 rate;
+	/*
+	 * We have to set up the TX command, the TX Beacon command, and the
+	 * beacon contents.
+	 */
 
+	/* Initialize memory */
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
-	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-
+	/* Set up TX beacon contents */
 	frame_size = iwl_fill_beacon_frame(priv, tx_beacon_cmd->frame,
 				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
+	if (WARN_ON_ONCE(frame_size > MAX_MPDU_SIZE))
+		return 0;
 
-	BUG_ON(frame_size > MAX_MPDU_SIZE);
+	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
+	tx_beacon_cmd->tx.sta_id = priv->hw_params.bcast_sta_id;
+	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	tx_beacon_cmd->tx.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK |
+		TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK;
 
-	if ((rate == IWL_RATE_1M_PLCP) || (rate >= IWL_RATE_2M_PLCP))
-		tx_beacon_cmd->tx.rate_n_flags =
-			iwl_hw_set_rate_n_flags(rate, RATE_MCS_CCK_MSK);
-	else
-		tx_beacon_cmd->tx.rate_n_flags =
-			iwl_hw_set_rate_n_flags(rate, 0);
+	/* Set up TX beacon command fields */
+	iwl_set_beacon_tim(priv, tx_beacon_cmd, (u8 *)tx_beacon_cmd->frame,
+			frame_size);
 
-	tx_beacon_cmd->tx.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK |
-				     TX_CMD_FLG_TSF_MSK |
-				     TX_CMD_FLG_STA_RATE_MSK;
+	/* Set up packet rate and flags */
+	rate = iwl_rate_get_lowest_plcp(priv);
+	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
+	if ((rate >= IWL_FIRST_CCK_RATE) && (rate <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+	tx_beacon_cmd->tx.rate_n_flags = iwl_hw_set_rate_n_flags(rate,
+			rate_flags);
 
 	return sizeof(*tx_beacon_cmd) + frame_size;
 }
@@ -364,19 +404,20 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_frame *frame;
 	unsigned int frame_size;
 	int rc;
-	u8 rate;
 
 	frame = iwl_get_free_frame(priv);
-
 	if (!frame) {
 		IWL_ERR(priv, "Could not obtain free frame buffer for beacon "
 			  "command.\n");
 		return -ENOMEM;
 	}
 
-	rate = iwl_rate_get_lowest_plcp(priv);
-
-	frame_size = iwl_hw_get_beacon_cmd(priv, frame, rate);
+	frame_size = iwl_hw_get_beacon_cmd(priv, frame);
+	if (!frame_size) {
+		IWL_ERR(priv, "Error configuring the beacon command\n");
+		iwl_free_frame(priv, frame);
+		return -EINVAL;
+	}
 
 	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 83b7f60..294d50c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -209,6 +209,7 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant)
 	}
 	return ant;
 }
+EXPORT_SYMBOL(iwl_toggle_tx_ant);
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 EXPORT_SYMBOL(iwl_bcast_addr);
-- 
1.5.6.3

