Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1JJPQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/34] iwlagn: kill hw_params.max_stations
Date: Mon, 10 Oct 2011 07:26:55 -0700
Message-Id: <1318256839-31837-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171732_055866_6779AADF)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Not needed since driver split.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-shared.h  |    2 --
 drivers/net/wireless/iwlwifi/iwl-sta.c     |   11 +++++------
 7 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 887f9ac..dfd81de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -130,7 +130,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index db88958..09a6b8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -127,7 +127,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2907016..14b4c5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -158,7 +158,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
@@ -195,7 +194,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 37837f7..d81c87d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -147,7 +147,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
 	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index ea1452c..a1670e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -349,7 +349,6 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	struct iwl_priv *priv = file->private_data;
 	struct iwl_station_entry *station;
 	struct iwl_tid_data *tid_data;
-	int max_sta = hw_params(priv).max_stations;
 	char *buf;
 	int i, j, pos = 0;
 	ssize_t ret;
@@ -363,7 +362,7 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 	pos += scnprintf(buf + pos, bufsz - pos, "num of stations: %d\n\n",
 			priv->num_stations);
 
-	for (i = 0; i < max_sta; i++) {
+	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		station = &priv->stations[i];
 		if (!station->used)
 			continue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 3a24b47..1f7a93c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -165,7 +165,6 @@ struct iwl_mod_params {
  * @rx_chains_num: Number of RX chains
  * @valid_tx_ant: usable antennas for TX
  * @valid_rx_ant: usable antennas for RX
- * @max_stations: the maximal number of stations
  * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
  * @sku: sku read from EEPROM
  * @rx_page_order: Rx buffer page order
@@ -186,7 +185,6 @@ struct iwl_hw_params {
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
-	u8  max_stations;
 	u8  ht40_channel;
 	bool shadow_reg_enable;
 	u16 sku;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 30bfdd3..23a9364 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -248,8 +248,7 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	else if (is_broadcast_ether_addr(addr))
 		sta_id = ctx->bcast_sta_id;
 	else
-		for (i = IWL_STA_ID;
-		     i < hw_params(priv).max_stations; i++) {
+		for (i = IWL_STA_ID; i < IWLAGN_STATION_COUNT; i++) {
 			if (!compare_ether_addr(priv->stations[i].sta.sta.addr,
 						addr)) {
 				sta_id = i;
@@ -535,7 +534,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 	IWL_DEBUG_INFO(priv, "Clearing ucode stations in driver\n");
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
-	for (i = 0; i < hw_params(priv).max_stations; i++) {
+	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (ctx && ctx->ctxid != priv->stations[i].ctxid)
 			continue;
 
@@ -576,7 +575,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags_spin);
-	for (i = 0; i < hw_params(priv).max_stations; i++) {
+	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (ctx->ctxid != priv->stations[i].ctxid)
 			continue;
 		if ((priv->stations[i].used & IWL_STA_DRIVER_ACTIVE) &&
@@ -589,7 +588,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 	}
 
-	for (i = 0; i < hw_params(priv).max_stations; i++) {
+	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if ((priv->stations[i].used & IWL_STA_UCODE_INPROGRESS)) {
 			memcpy(&sta_cmd, &priv->stations[i].sta,
 			       sizeof(struct iwl_addsta_cmd));
@@ -692,7 +691,7 @@ void iwl_dealloc_bcast_stations(struct iwl_priv *priv)
 	int i;
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	for (i = 0; i < hw_params(priv).max_stations; i++) {
+	for (i = 0; i < IWLAGN_STATION_COUNT; i++) {
 		if (!(priv->stations[i].used & IWL_STA_BCAST))
 			continue;
 
-- 
1.7.0.4

