Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1EMTim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/13] iwlagn: prepare for multi-TB commands
Date: Fri, 13 May 2011 12:13:18 -0700
Message-Id: <1305314010-18073-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213848_590354_97F449D3)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In a subsequent patch, I want to make commands use
multiple TBs in a TFD. This is a simple change to
prepare the data structures for this, with as of
now still just a single TB supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-led.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c       |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c        |    6 +++---
 14 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 89b8da7..9f34cd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -195,9 +195,9 @@ static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
-		.len = sizeof(cmd),
+		.len = { sizeof(cmd), },
 		.flags = CMD_SYNC,
-		.data = &cmd,
+		.data = { &cmd, },
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 98f81df..09751f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -282,9 +282,9 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
-		.len = sizeof(cmd),
+		.len = { sizeof(cmd), },
 		.flags = CMD_SYNC,
-		.data = &cmd,
+		.data = { &cmd, },
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a7921f9..860c26e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -221,9 +221,9 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	struct ieee80211_vif *vif = ctx->vif;
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
-		.len = sizeof(cmd),
+		.len = { sizeof(cmd), },
 		.flags = CMD_SYNC,
-		.data = &cmd,
+		.data = { &cmd, },
 	};
 
 	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 0f6bb9b..30e11c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -93,8 +93,8 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
 		if ((BIT(i) & priv->hw_params.calib_init_cfg) &&
 		    priv->calib_results[i].buf) {
-			hcmd.len = priv->calib_results[i].buf_len;
-			hcmd.data = priv->calib_results[i].buf;
+			hcmd.len[0] = priv->calib_results[i].buf_len;
+			hcmd.data[0] = priv->calib_results[i].buf;
 			ret = iwl_send_cmd_sync(priv, &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
@@ -456,9 +456,9 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	struct iwl_sensitivity_data *data = NULL;
 	struct iwl_host_cmd cmd_out = {
 		.id = SENSITIVITY_CMD,
-		.len = sizeof(struct iwl_sensitivity_cmd),
+		.len = { sizeof(struct iwl_sensitivity_cmd), },
 		.flags = CMD_ASYNC,
-		.data = &cmd,
+		.data = { &cmd, },
 	};
 
 	data = &(priv->sensitivity_data);
@@ -491,9 +491,9 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 	struct iwl_sensitivity_data *data = NULL;
 	struct iwl_host_cmd cmd_out = {
 		.id = SENSITIVITY_CMD,
-		.len = sizeof(struct iwl_enhance_sensitivity_cmd),
+		.len = { sizeof(struct iwl_enhance_sensitivity_cmd), },
 		.flags = CMD_ASYNC,
-		.data = &cmd,
+		.data = { &cmd, },
 	};
 
 	data = &(priv->sensitivity_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8e79653..576f45e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1140,7 +1140,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
-		.len = sizeof(struct iwl_scan_cmd),
+		.len = { sizeof(struct iwl_scan_cmd), },
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
@@ -1425,10 +1425,10 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		return -EIO;
 	}
 
-	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
+	cmd.len[0] += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl_scan_channel);
-	cmd.data = scan;
-	scan->len = cpu_to_le16(cmd.len);
+	cmd.data[0] = scan;
+	scan->len = cpu_to_le16(cmd.len[0]);
 
 	/* set scan bit here for PAN params */
 	set_bit(STATUS_SCAN_HW, &priv->status);
@@ -1520,9 +1520,9 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 	struct iwl_txfifo_flush_cmd flush_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TXFIFO_FLUSH,
-		.len = sizeof(struct iwl_txfifo_flush_cmd),
+		.len = { sizeof(struct iwl_txfifo_flush_cmd), },
 		.flags = CMD_SYNC,
-		.data = &flush_cmd,
+		.data = { &flush_cmd, },
 	};
 
 	might_sleep();
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 079275f..0bd722c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -144,7 +144,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
 	struct iwl_host_cmd cmd = {
 		.id = ctx->wep_key_cmd,
-		.data = wep_cmd,
+		.data = { wep_cmd, },
 		.flags = CMD_SYNC,
 	};
 
@@ -172,7 +172,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 
 	cmd_size += sizeof(struct iwl_wep_key) * WEP_KEYS_MAX;
 
-	cmd.len = cmd_size;
+	cmd.len[0] = cmd_size;
 
 	if (not_empty || send_if_empty)
 		return iwl_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8bda0e8..e35755c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -217,8 +217,8 @@ static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = CALIBRATION_CFG_CMD,
-		.len = sizeof(struct iwl_calib_cfg_cmd),
-		.data = &calib_cfg_cmd,
+		.len = { sizeof(struct iwl_calib_cfg_cmd), },
+		.data = { &calib_cfg_cmd, },
 	};
 
 	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3ecc319..2713081 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -189,8 +189,8 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 			rate_flags);
 
 	/* Submit command */
-	cmd.len = sizeof(*tx_beacon_cmd) + frame_size;
-	cmd.data = tx_beacon_cmd;
+	cmd.len[0] = sizeof(*tx_beacon_cmd) + frame_size;
+	cmd.data[0] = tx_beacon_cmd;
 
 	err = iwl_send_cmd_sync(priv, &cmd);
 
@@ -2114,8 +2114,8 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = CALIBRATION_CFG_CMD,
-		.len = sizeof(struct iwl_calib_cfg_cmd),
-		.data = &calib_cfg_cmd,
+		.len = { sizeof(struct iwl_calib_cfg_cmd), },
+		.data = { &calib_cfg_cmd, },
 	};
 
 	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 214e465..9daf964 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -277,15 +277,16 @@ struct iwl_device_cmd {
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
 
+#define IWL_MAX_CMD_TFDS	1
 
 struct iwl_host_cmd {
-	const void *data;
+	const void *data[IWL_MAX_CMD_TFDS];
 	unsigned long reply_page;
 	void (*callback)(struct iwl_priv *priv,
 			 struct iwl_device_cmd *cmd,
 			 struct iwl_rx_packet *pkt);
 	u32 flags;
-	u16 len;
+	u16 len[IWL_MAX_CMD_TFDS];
 	u8 id;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 8f0beb9..1ff1f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -264,8 +264,8 @@ int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
-		.len = len,
-		.data = data,
+		.len = { len, },
+		.data = { data, },
 	};
 
 	return iwl_send_cmd_sync(priv, &cmd);
@@ -279,8 +279,8 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
-		.len = len,
-		.data = data,
+		.len = { len, },
+		.data = { data, },
 	};
 
 	cmd.flags |= CMD_ASYNC;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 439187f..7c23beb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -107,8 +107,8 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct iwl_led_cmd),
-		.data = led_cmd,
+		.len = { sizeof(struct iwl_led_cmd), },
+		.data = { led_cmd, },
 		.flags = CMD_ASYNC,
 		.callback = NULL,
 	};
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 3c8cebd..7df2814 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -141,7 +141,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
 		.flags = flags,
-		.data = data,
+		.data = { data, },
 	};
 	u8 sta_id __maybe_unused = sta->sta.sta_id;
 
@@ -155,7 +155,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 		might_sleep();
 	}
 
-	cmd.len = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
+	cmd.len[0] = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
 	ret = iwl_send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
@@ -401,9 +401,9 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_REMOVE_STA,
-		.len = sizeof(struct iwl_rem_sta_cmd),
+		.len = { sizeof(struct iwl_rem_sta_cmd), },
 		.flags = CMD_SYNC,
-		.data = &rm_sta_cmd,
+		.data = { &rm_sta_cmd, },
 	};
 
 	memset(&rm_sta_cmd, 0, sizeof(rm_sta_cmd));
@@ -760,9 +760,9 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
-		.len = sizeof(struct iwl_link_quality_cmd),
+		.len = { sizeof(struct iwl_link_quality_cmd), },
 		.flags = flags,
-		.data = lq,
+		.data = { lq, },
 	};
 
 	if (WARN_ON(lq->sta_id == IWL_INVALID_STATION))
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 89b6696..01a8ec9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -198,10 +198,10 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	}
 
 	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
-	cmd.data = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
-	cmd.len = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
-				" len %d\n", cmd.id, cmd.flags, cmd.len);
+				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
 	return iwl_send_cmd(priv, &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index e69597e..7843195 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -446,7 +446,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u16 fix_size;
 	bool is_ct_kill = false;
 
-	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
+	fix_size = (u16)(cmd->len[0] + sizeof(out_cmd->hdr));
 
 	/*
 	 * If any of the command structures end up being larger than
@@ -506,7 +506,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		out_meta->callback = cmd->callback;
 
 	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
+	memcpy(&out_cmd->cmd.payload, cmd->data[0], cmd->len[0]);
 
 	/* At this point, the out_cmd now has all of the incoming cmd
 	 * information */
@@ -555,7 +555,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   phys_addr, fix_size, 1,
-						   U32_PAD(cmd->len));
+						   U32_PAD(cmd->len[0]));
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-- 
1.7.0.4

