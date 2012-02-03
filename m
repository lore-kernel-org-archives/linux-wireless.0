Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab2BCQcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 08/25] iwlegacy: move bcast_sta_id to hw_params
Date: Fri,  3 Feb 2012 17:31:44 +0100
Message-Id: <1328286721-11309-9-git-send-email-sgruszka@redhat.com> (sfid-20120203_173256_442361_236F251C)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    4 ++--
 drivers/net/wireless/iwlegacy/3945-rs.c  |    2 +-
 drivers/net/wireless/iwlegacy/3945.c     |    5 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c |   15 ++++++++-------
 drivers/net/wireless/iwlegacy/4965.c     |    3 +--
 drivers/net/wireless/iwlegacy/common.c   |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    6 +++---
 7 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 8072ae8..b11701f 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -140,7 +140,7 @@ il3945_set_ccmp_dynamic_key_info(struct il_priv *il,
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 
-	if (sta_id == il->ctx.bcast_sta_id)
+	if (sta_id == il->hw_params.bcast_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -2598,7 +2598,7 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = il->ctx.bcast_sta_id;
+	scan->tx_cmd.sta_id = il->hw_params.bcast_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	/* flags + rate selection */
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 40d17d7..6a782b5 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -342,7 +342,7 @@ il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 	int i;
 
 	D_INFO("enter\n");
-	if (sta_id == il->ctx.bcast_sta_id)
+	if (sta_id == il->hw_params.bcast_id)
 		goto out;
 
 	psta = (struct il3945_sta_priv *)sta->drv_priv;
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index dc0433f..3024645 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2396,6 +2396,8 @@ il3945_hw_set_hw_params(struct il_priv *il)
 		return -ENOMEM;
 	}
 
+	il->hw_params.bcast_id = IL3945_BROADCAST_ID;
+
 	/* Assign number of Usable TX queues */
 	il->hw_params.max_txq_num = il->cfg->base_params->num_of_queues;
 
@@ -2404,7 +2406,6 @@ il3945_hw_set_hw_params(struct il_priv *il)
 	il->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	il->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	il->hw_params.max_stations = IL3945_STATION_COUNT;
-	il->ctx.bcast_sta_id = IL3945_BROADCAST_ID;
 
 	il->sta_key_max_num = STA_KEY_MAX_NUM;
 
@@ -2425,7 +2426,7 @@ il3945_hw_get_beacon_cmd(struct il_priv *il, struct il3945_frame *frame,
 	tx_beacon_cmd = (struct il3945_tx_beacon_cmd *)&frame->u;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
 
-	tx_beacon_cmd->tx.sta_id = il->ctx.bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id = il->hw_params.bcast_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	frame_size =
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f2b03cd..af78862 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -919,7 +919,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 		D_SCAN("Start passive scan.\n");
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
+	scan->tx_cmd.sta_id = il->hw_params.bcast_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 
 	switch (il->scan_band) {
@@ -1678,7 +1678,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* For management frames use broadcast id to do not break aggregation */
 	if (!ieee80211_is_data(fc))
-		sta_id = ctx->bcast_sta_id;
+		sta_id = il->hw_params.bcast_id;
 	else {
 		/* Find idx into station table for destination station */
 		sta_id = il_sta_id_or_broadcast(il, ctx, info->control.sta);
@@ -2938,7 +2938,7 @@ il4965_set_wep_dynamic_key_info(struct il_priv *il, struct il_rxon_context *ctx,
 	if (keyconf->keylen == WEP_KEY_LEN_128)
 		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
 
-	if (sta_id == ctx->bcast_sta_id)
+	if (sta_id == il->hw_params.bcast_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
@@ -2988,7 +2988,7 @@ il4965_set_ccmp_dynamic_key_info(struct il_priv *il,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == ctx->bcast_sta_id)
+	if (sta_id == il->hw_params.bcast_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -3035,7 +3035,7 @@ il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
 	key_flags &= ~STA_KEY_FLG_INVALID;
 
-	if (sta_id == ctx->bcast_sta_id)
+	if (sta_id == il->hw_params.bcast_id)
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -3253,7 +3253,7 @@ il4965_update_bcast_station(struct il_priv *il, struct il_rxon_context *ctx)
 {
 	unsigned long flags;
 	struct il_link_quality_cmd *link_cmd;
-	u8 sta_id = ctx->bcast_sta_id;
+	u8 sta_id = il->hw_params.bcast_id;
 
 	link_cmd = il4965_sta_alloc_lq(il, sta_id);
 	if (!link_cmd) {
@@ -3510,7 +3510,7 @@ il4965_hw_get_beacon_cmd(struct il_priv *il, struct il_frame *frame)
 
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16) frame_size);
-	tx_beacon_cmd->tx.sta_id = il->beacon_ctx->bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id = il->hw_params.bcast_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	tx_beacon_cmd->tx.tx_flags =
 	    TX_CMD_FLG_SEQ_CTL_MSK | TX_CMD_FLG_TSF_MSK |
@@ -6082,6 +6082,7 @@ il4965_hw_detect(struct il_priv *il)
 static int
 il4965_set_hw_params(struct il_priv *il)
 {
+	il->hw_params.bcast_id = IL4965_BROADCAST_ID;
 	il->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	il->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (il->cfg->mod_params->amsdu_size_8K)
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 8926108..8d0fd60 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -624,7 +624,6 @@ il4965_hw_set_hw_params(struct il_priv *il)
 	    sizeof(struct il4965_scd_bc_tbl);
 	il->hw_params.tfd_size = sizeof(struct il_tfd);
 	il->hw_params.max_stations = IL4965_STATION_COUNT;
-	il->ctx.bcast_sta_id = IL4965_BROADCAST_ID;
 	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
 	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
 	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
@@ -1968,7 +1967,7 @@ il4965_find_station(struct il_priv *il, const u8 * addr)
 		start = IL_STA_ID;
 
 	if (is_broadcast_ether_addr(addr))
-		return il->ctx.bcast_sta_id;
+		return il->hw_params.bcast_id;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	for (i = start; i < il->hw_params.max_stations; i++)
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index d30a206..b7567a8 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1901,7 +1901,7 @@ il_prep_station(struct il_priv *il, struct il_rxon_context *ctx,
 	if (is_ap)
 		sta_id = IL_AP_ID;
 	else if (is_broadcast_ether_addr(addr))
-		sta_id = ctx->bcast_sta_id;
+		sta_id = il->hw_params.bcast_id;
 	else
 		for (i = IL_STA_ID; i < il->hw_params.max_stations; i++) {
 			if (!compare_ether_addr
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index cf7352f..66d0c1d 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -816,6 +816,7 @@ struct il_sensitivity_ranges {
 
 /**
  * struct il_hw_params
+ * @bcast_id: f/w broadcast station ID
  * @max_txq_num: Max # Tx queues supported
  * @dma_chnl_num: Number of Tx DMA/FIFO channels
  * @scd_bc_tbls_size: size of scheduler byte count tables
@@ -836,6 +837,7 @@ struct il_sensitivity_ranges {
  * @struct il_sensitivity_ranges: range of sensitivity values
  */
 struct il_hw_params {
+	u8 bcast_id;
 	u8 max_txq_num;
 	u8 dma_chnl_num;
 	u16 scd_bc_tbls_size;
@@ -1173,8 +1175,6 @@ struct il_rxon_context {
 
 	struct il_qos_info qos_data;
 
-	u8 bcast_sta_id;
-
 	struct il_wep_key wep_keys[WEP_KEYS_MAX];
 	u8 key_mapping_keys;
 
@@ -2372,7 +2372,7 @@ il_sta_id_or_broadcast(struct il_priv *il, struct il_rxon_context *context,
 	int sta_id;
 
 	if (!sta)
-		return context->bcast_sta_id;
+		return il->hw_params.bcast_id;
 
 	sta_id = il_sta_id(sta);
 
-- 
1.7.1

