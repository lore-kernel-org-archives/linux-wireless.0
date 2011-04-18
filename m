Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab1DRRFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 13:05:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: remove most BUG_ON instances
Date: Mon, 18 Apr 2011 09:44:09 -0700
Message-Id: <1303145057-6545-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a number of things in the driver that
may result in a BUG(), which is suboptimal since
it's hard to get debugging information out of
the driver in that case and the user experience
is also not good :-)

Almost all BUG_ON instances can be converted to
WARN_ON with a few lines of appropriate error
handling, so do that instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    9 +++++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    6 ------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-hcmd.c   |   12 ++++++++----
 drivers/net/wireless/iwlwifi/iwl-power.c  |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-sta.c    |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   25 +++++++++++++++++--------
 7 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b4f7510..0daeded 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -394,7 +394,9 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 		return -EINVAL;
 	}
 
-	BUG_ON(addr & ~DMA_BIT_MASK(36));
+	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
+		return -EINVAL;
+
 	if (unlikely(addr & ~IWL_TX_DMA_MASK))
 		IWL_ERR(priv, "Unaligned address = %llx\n",
 			  (unsigned long long)addr);
@@ -718,7 +720,10 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		/* If an RXB doesn't have a Rx queue slot associated with it,
 		 * then a bug has been introduced in the queue refilling
 		 * routines -- catch it here */
-		BUG_ON(rxb == NULL);
+		if (WARN_ON(rxb == NULL)) {
+			i = (i + 1) & RX_QUEUE_MASK;
+			continue;
+		}
 
 		rxq->queue[i] = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 859b94a..4027336 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -215,12 +215,6 @@ static int iwlcore_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 	return  nvm_type;
 }
 
-const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
-{
-	BUG_ON(offset >= priv->cfg->base_params->eeprom_size);
-	return &priv->eeprom[offset];
-}
-
 static int iwl_init_otp_access(struct iwl_priv *priv)
 {
 	int ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 0e9d970..9ce0525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -309,7 +309,6 @@ int  iwl_eeprom_check_sku(struct iwl_priv *priv);
 const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
 int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
-const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
 const struct iwl_channel_info *iwl_get_channel_info(
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 9177b55..8f0beb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -143,10 +143,12 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
-	BUG_ON(!(cmd->flags & CMD_ASYNC));
+	if (WARN_ON(!(cmd->flags & CMD_ASYNC)))
+		return -EINVAL;
 
 	/* An asynchronous command can not expect an SKB to be set. */
-	BUG_ON(cmd->flags & CMD_WANT_SKB);
+	if (WARN_ON(cmd->flags & CMD_WANT_SKB))
+		return -EINVAL;
 
 	/* Assign a generic callback if one is not provided */
 	if (!cmd->callback)
@@ -169,10 +171,12 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
-	lockdep_assert_held(&priv->mutex);
+	if (WARN_ON(cmd->flags & CMD_ASYNC))
+		return -EINVAL;
 
 	 /* A synchronous command can not have a callback set. */
-	BUG_ON((cmd->flags & CMD_ASYNC) || cmd->callback);
+	if (WARN_ON(cmd->callback))
+		return -EINVAL;
 
 	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index ae176d8..b7cd958 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -188,9 +188,10 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 			table = range_0;
 	}
 
-	BUG_ON(lvl < 0 || lvl >= IWL_POWER_NUM);
-
-	*cmd = table[lvl].cmd;
+	if (WARN_ON(lvl < 0 || lvl >= IWL_POWER_NUM))
+		memset(cmd, 0, sizeof(*cmd));
+	else
+		*cmd = table[lvl].cmd;
 
 	if (period == 0) {
 		skip = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index c215156..3c8cebd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -494,7 +494,8 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 
 	priv->num_stations--;
 
-	BUG_ON(priv->num_stations < 0);
+	if (WARN_ON(priv->num_stations < 0))
+		priv->num_stations = 0;
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
@@ -679,7 +680,8 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 
 		priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
 		priv->num_stations--;
-		BUG_ON(priv->num_stations < 0);
+		if (WARN_ON(priv->num_stations < 0))
+			priv->num_stations = 0;
 		kfree(priv->stations[i].lq);
 		priv->stations[i].lq = NULL;
 	}
@@ -775,7 +777,8 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
 
 	iwl_dump_lq_cmd(priv, lq);
-	BUG_ON(init && (cmd.flags & CMD_ASYNC));
+	if (WARN_ON(init && (cmd.flags & CMD_ASYNC)))
+		return -EINVAL;
 
 	if (is_lq_table_valid(priv, ctx, lq))
 		ret = iwl_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3732380..e7faba5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -263,11 +263,13 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 
 	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
 	 * and iwl_queue_dec_wrap are broken. */
-	BUG_ON(!is_power_of_2(count));
+	if (WARN_ON(!is_power_of_2(count)))
+		return -EINVAL;
 
 	/* slots_num must be power-of-two size, otherwise
 	 * get_cmd_index is broken. */
-	BUG_ON(!is_power_of_2(slots_num));
+	if (WARN_ON(!is_power_of_2(slots_num)))
+		return -EINVAL;
 
 	q->low_mark = q->n_window / 4;
 	if (q->low_mark < 4)
@@ -384,7 +386,9 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+	ret = iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+	if (ret)
+		return ret;
 
 	/* Tell device where to find queue */
 	priv->cfg->ops->lib->txq_init(priv, txq);
@@ -446,14 +450,19 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 
-	/* If any of the command structures end up being larger than
+	/*
+	 * If any of the command structures end up being larger than
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
 	 * we will need to increase the size of the TFD entries
 	 * Also, check to see if command buffer should not exceed the size
-	 * of device_cmd and max_cmd_size. */
-	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
-	       !(cmd->flags & CMD_SIZE_HUGE));
-	BUG_ON(fix_size > IWL_MAX_CMD_SIZE);
+	 * of device_cmd and max_cmd_size.
+	 */
+	if (WARN_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
+		    !(cmd->flags & CMD_SIZE_HUGE)))
+		return -EINVAL;
+
+	if (WARN_ON(fix_size > IWL_MAX_CMD_SIZE))
+		return -EINVAL;
 
 	if (iwl_is_rfkill(priv) || iwl_is_ctkill(priv)) {
 		IWL_WARN(priv, "Not sending command - %s KILL\n",
-- 
1.7.0.4

