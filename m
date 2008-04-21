Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYDUWmR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 02/11] iwlwifi: changing EEPROM layout handling
Date: Mon, 21 Apr 2008 15:41:52 -0700
Message-Id: <1208817721-11333-3-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_434860_D562E6FA)
In-Reply-To: <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. changes the current EEPROM handling through a single HW struct
layout representation, to more general approach, treating the EEPROM
image as a flat bytes array, handling this image through ops functions
and offsets.
2. Eeprom is dynamically allocated accroding HW type

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    3 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   62 +++++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |  101 ++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |  155 +++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +-
 7 files changed, 188 insertions(+), 148 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 1a66b50..855a006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -69,6 +69,9 @@
 #ifndef __iwl_4965_hw_h__
 #define __iwl_4965_hw_h__
 
+/* EERPROM */
+#define IWL4965_EEPROM_IMG_SIZE			1024
+
 /*
  * uCode queue management definitions ...
  * Queue #4 is the command queue for 3945 and 4965; map it to Tx FIFO chnl 4.
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d051aac..7886596 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -699,8 +699,9 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	unsigned long flags;
 	struct iwl4965_rx_queue *rxq = &priv->rxq;
 	u8 rev_id;
-	u32 val;
 	u8 val_link;
+	u16 sku_cap;
+	u32 val;
 
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -759,7 +760,8 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->eeprom.calib_version < EEPROM_TX_POWER_VERSION_NEW) {
+	if (iwl_eeprom_query16(priv, EEPROM_4965_CALIB_VERSION_OFFSET) <
+		EEPROM_4965_TX_POWER_VERSION) {
 		IWL_ERROR("Older EEPROM detected!  Aborting.\n");
 		return -EINVAL;
 	}
@@ -816,6 +818,10 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	rxq->need_update = 1;
 	iwl4965_rx_queue_update_write_ptr(priv, rxq);
 
+	/* init the txpower calibration pointer */
+	priv->calib_info = (struct iwl_eeprom_calib_info *)
+		iwl_eeprom_query_addr(priv, EEPROM_4965_CALIB_TXPOWER_OFFSET);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Allocate and init all Tx and Command queues */
@@ -823,10 +829,11 @@ int iwl4965_hw_nic_init(struct iwl_priv *priv)
 	if (rc)
 		return rc;
 
-	if (priv->eeprom.sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
+	sku_cap = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
+	if (sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("SW RF KILL supported in EEPROM.\n");
 
-	if (priv->eeprom.sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
+	if (sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
 
 	set_bit(STATUS_INIT, &priv->status);
@@ -1542,11 +1549,11 @@ static u32 iwl4965_get_sub_band(const struct iwl_priv *priv, u32 channel)
 	s32 b = -1;
 
 	for (b = 0; b < EEPROM_TX_POWER_BANDS; b++) {
-		if (priv->eeprom.calib_info.band_info[b].ch_from == 0)
+		if (priv->calib_info->band_info[b].ch_from == 0)
 			continue;
 
-		if ((channel >= priv->eeprom.calib_info.band_info[b].ch_from)
-		    && (channel <= priv->eeprom.calib_info.band_info[b].ch_to))
+		if ((channel >= priv->calib_info->band_info[b].ch_from)
+		    && (channel <= priv->calib_info->band_info[b].ch_to))
 			break;
 	}
 
@@ -1574,14 +1581,14 @@ static s32 iwl4965_interpolate_value(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
  * in channel number.
  */
 static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
-				    struct iwl4965_eeprom_calib_ch_info *chan_info)
+				    struct iwl_eeprom_calib_ch_info *chan_info)
 {
 	s32 s = -1;
 	u32 c;
 	u32 m;
-	const struct iwl4965_eeprom_calib_measure *m1;
-	const struct iwl4965_eeprom_calib_measure *m2;
-	struct iwl4965_eeprom_calib_measure *omeas;
+	const struct iwl_eeprom_calib_measure *m1;
+	const struct iwl_eeprom_calib_measure *m2;
+	struct iwl_eeprom_calib_measure *omeas;
 	u32 ch_i1;
 	u32 ch_i2;
 
@@ -1591,8 +1598,8 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 		return -1;
 	}
 
-	ch_i1 = priv->eeprom.calib_info.band_info[s].ch1.ch_num;
-	ch_i2 = priv->eeprom.calib_info.band_info[s].ch2.ch_num;
+	ch_i1 = priv->calib_info->band_info[s].ch1.ch_num;
+	ch_i2 = priv->calib_info->band_info[s].ch2.ch_num;
 	chan_info->ch_num = (u8) channel;
 
 	IWL_DEBUG_TXPOWER("channel %d subband %d factory cal ch %d & %d\n",
@@ -1600,9 +1607,9 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 
 	for (c = 0; c < EEPROM_TX_POWER_TX_CHAINS; c++) {
 		for (m = 0; m < EEPROM_TX_POWER_MEASUREMENTS; m++) {
-			m1 = &(priv->eeprom.calib_info.band_info[s].ch1.
+			m1 = &(priv->calib_info->band_info[s].ch1.
 			       measurements[c][m]);
-			m2 = &(priv->eeprom.calib_info.band_info[s].ch2.
+			m2 = &(priv->calib_info->band_info[s].ch2.
 			       measurements[c][m]);
 			omeas = &(chan_info->measurements[c][m]);
 
@@ -1921,8 +1928,8 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	int i;
 	int c;
 	const struct iwl_channel_info *ch_info = NULL;
-	struct iwl4965_eeprom_calib_ch_info ch_eeprom_info;
-	const struct iwl4965_eeprom_calib_measure *measurement;
+	struct iwl_eeprom_calib_ch_info ch_eeprom_info;
+	const struct iwl_eeprom_calib_measure *measurement;
 	s16 voltage;
 	s32 init_voltage;
 	s32 voltage_compensation;
@@ -1979,9 +1986,9 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	/* hardware txpower limits ...
 	 * saturation (clipping distortion) txpowers are in half-dBm */
 	if (band)
-		saturation_power = priv->eeprom.calib_info.saturation_power24;
+		saturation_power = priv->calib_info->saturation_power24;
 	else
-		saturation_power = priv->eeprom.calib_info.saturation_power52;
+		saturation_power = priv->calib_info->saturation_power52;
 
 	if (saturation_power < IWL_TX_POWER_SATURATION_MIN ||
 	    saturation_power > IWL_TX_POWER_SATURATION_MAX) {
@@ -2011,7 +2018,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	iwl4965_interpolate_chan(priv, channel, &ch_eeprom_info);
 
 	/* calculate tx gain adjustment based on power supply voltage */
-	voltage = priv->eeprom.calib_info.voltage;
+	voltage = priv->calib_info->voltage;
 	init_voltage = (s32)le32_to_cpu(priv->card_alive_init.voltage);
 	voltage_compensation =
 	    iwl4965_get_voltage_compensation(voltage, init_voltage);
@@ -2467,14 +2474,14 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 
 static void iwl4965_hw_card_show_info(struct iwl_priv *priv)
 {
-	u16 hw_version = priv->eeprom.board_revision_4965;
+	u16 hw_version = iwl_eeprom_query16(priv, EEPROM_4965_BOARD_REVISION);
 
 	IWL_DEBUG_INFO("4965ABGN HW Version %u.%u.%u\n",
 		       ((hw_version >> 8) & 0x0F),
 		       ((hw_version >> 8) >> 4), (hw_version & 0x00FF));
 
 	IWL_DEBUG_INFO("4965ABGN PBA Number %.16s\n",
-		       priv->eeprom.board_pba_number_4965);
+		       &priv->eeprom[EEPROM_4965_BOARD_PBA]);
 }
 
 #define IWL_TX_CRC_SIZE		4
@@ -4340,9 +4347,19 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_REGULATORY_BAND_1_CHANNELS,
+			EEPROM_REGULATORY_BAND_2_CHANNELS,
+			EEPROM_REGULATORY_BAND_3_CHANNELS,
+			EEPROM_REGULATORY_BAND_4_CHANNELS,
+			EEPROM_REGULATORY_BAND_5_CHANNELS,
+			EEPROM_4965_REGULATORY_BAND_24_FAT_CHANNELS,
+			EEPROM_4965_REGULATORY_BAND_52_FAT_CHANNELS
+		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.query_addr = iwlcore_eeprom_query_addr,
 	},
 	.radio_kill_sw = iwl4965_radio_kill_sw,
 	.set_power = iwl4965_set_power,
@@ -4359,6 +4376,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
 	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
 	.ops = &iwl4965_ops,
 	.mod_params = &iwl4965_mod_params,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 478f03f..754ed37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -200,9 +200,9 @@ enum {
 struct iwl_channel_info {
 	struct iwl4965_channel_tgd_info tgd;
 	struct iwl4965_channel_tgh_info tgh;
-	struct iwl4965_eeprom_channel eeprom;	  /* EEPROM regulatory limit */
-	struct iwl4965_eeprom_channel fat_eeprom; /* EEPROM regulatory limit for
-						   * FAT channel */
+	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
+						 * FAT channel */
 
 	u8 channel;	  /* channel number */
 	u8 flags;	  /* flags copied from EEPROM */
@@ -1123,7 +1123,8 @@ struct iwl_priv {
 	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
 
 	/* eeprom */
-	struct iwl4965_eeprom eeprom;
+	u8 *eeprom;
+	struct iwl_eeprom_calib_info *calib_info;
 
 	enum ieee80211_if_types iw_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3d113dc..79e9793 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -146,6 +146,7 @@ struct iwl_cfg {
 	const char *name;
 	const char *fw_name;
 	unsigned int sku;
+	int eeprom_size;
 	const struct iwl_ops *ops;
 	const struct iwl_mod_params *mod_params;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a07d5dc..a436f87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -193,6 +193,12 @@ void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_eeprom_release_semaphore);
 
+const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
+{
+	BUG_ON(offset >= priv->cfg->eeprom_size);
+	return &priv->eeprom[offset];
+}
+EXPORT_SYMBOL(iwlcore_eeprom_query_addr);
 
 /**
  * iwl_eeprom_init - read EEPROM contents
@@ -203,30 +209,35 @@ EXPORT_SYMBOL(iwlcore_eeprom_release_semaphore);
  */
 int iwl_eeprom_init(struct iwl_priv *priv)
 {
-	u16 *e = (u16 *)&priv->eeprom;
+	u16 *e;
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	u32 r;
-	int sz = sizeof(priv->eeprom);
+	int sz = priv->cfg->eeprom_size;
 	int ret;
 	int i;
 	u16 addr;
 
-	/* The EEPROM structure has several padding buffers within it
-	 * and when adding new EEPROM maps is subject to programmer errors
-	 * which may be very difficult to identify without explicitly
-	 * checking the resulting size of the eeprom map. */
-	BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE);
+	/* allocate eeprom */
+	priv->eeprom = kzalloc(sz, GFP_KERNEL);
+	if (!priv->eeprom) {
+		ret = -ENOMEM;
+		goto alloc_err;
+	}
+	e = (u16 *)priv->eeprom;
 
-	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
+	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
+	if (ret < 0) {
 		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err;
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	ret = priv->cfg->ops->lib->eeprom_ops.acquire_semaphore(priv);
 	if (ret < 0) {
 		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err;
 	}
 
 	/* eeprom is an array of 16bit values */
@@ -250,61 +261,93 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 	ret = 0;
-
 done:
 	priv->cfg->ops->lib->eeprom_ops.release_semaphore(priv);
+err:
+	if (ret)
+		kfree(priv->eeprom);
+alloc_err:
 	return ret;
 }
 EXPORT_SYMBOL(iwl_eeprom_init);
 
+void iwl_eeprom_free(struct iwl_priv *priv)
+{
+	if(priv->eeprom)
+		kfree(priv->eeprom);
+	priv->eeprom = NULL;
+}
+EXPORT_SYMBOL(iwl_eeprom_free);
+
+
+const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
+{
+	return priv->cfg->ops->lib->eeprom_ops.query_addr(priv, offset);
+}
+EXPORT_SYMBOL(iwl_eeprom_query_addr);
+
+u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
+{
+	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
+}
+EXPORT_SYMBOL(iwl_eeprom_query16);
 
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
 {
-	memcpy(mac, priv->eeprom.mac_address, 6);
+	const u8 *addr = priv->cfg->ops->lib->eeprom_ops.query_addr(priv,
+					EEPROM_MAC_ADDRESS);
+	memcpy(mac, addr, ETH_ALEN);
 }
 EXPORT_SYMBOL(iwl_eeprom_get_mac);
 
 static void iwl_init_band_reference(const struct iwl_priv *priv,
-				    int band,
-				    int *eeprom_ch_count,
-				    const struct iwl4965_eeprom_channel
-				    **eeprom_ch_info,
-				    const u8 **eeprom_ch_index)
+			int eep_band, int *eeprom_ch_count,
+			const struct iwl_eeprom_channel **eeprom_ch_info,
+			const u8 **eeprom_ch_index)
 {
-	switch (band) {
+	u32 offset = priv->cfg->ops->lib->
+			eeprom_ops.regulatory_bands[eep_band - 1];
+	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
-		*eeprom_ch_info = priv->eeprom.band_1_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
-		*eeprom_ch_info = priv->eeprom.band_2_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
-		*eeprom_ch_info = priv->eeprom.band_3_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
-		*eeprom_ch_info = priv->eeprom.band_4_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
-		*eeprom_ch_info = priv->eeprom.band_5_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz FAT channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
-		*eeprom_ch_info = priv->eeprom.band_24_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz FAT channels */
 		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
-		*eeprom_ch_info = priv->eeprom.band_52_channels;
+		*eeprom_ch_info = (struct iwl_eeprom_channel *)
+				iwl_eeprom_query_addr(priv, offset);
 		*eeprom_ch_index = iwl_eeprom_band_7;
 		break;
 	default:
@@ -323,7 +366,7 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
  */
 static int iwl4965_set_fat_chan_info(struct iwl_priv *priv,
 			      enum ieee80211_band band, u16 channel,
-			      const struct iwl4965_eeprom_channel *eeprom_ch,
+			      const struct iwl_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
 {
 	struct iwl_channel_info *ch_info;
@@ -372,7 +415,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_index = NULL;
-	const struct iwl4965_eeprom_channel *eeprom_ch_info = NULL;
+	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
 	struct iwl_channel_info *ch_info;
 
@@ -381,9 +424,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		return 0;
 	}
 
-	if (priv->eeprom.version < 0x2f) {
+	if (iwl_eeprom_query16(priv, EEPROM_VERSION) < 0x2f) {
 		IWL_WARNING("Unsupported EEPROM version: 0x%04X\n",
-			    priv->eeprom.version);
+			    iwl_eeprom_query16(priv, EEPROM_VERSION));
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index bd0a042..26a73e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -116,7 +116,7 @@ enum {
 
 /* *regulatory* channel data format in eeprom, one for each channel.
  * There are separate entries for FAT (40 MHz) vs. normal (20 MHz) channels. */
-struct iwl4965_eeprom_channel {
+struct iwl_eeprom_channel {
 	u8 flags;		/* EEPROM_CHANNEL_* flags copied from EEPROM */
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __attribute__ ((packed));
@@ -131,17 +131,19 @@ struct iwl4965_eeprom_channel {
  * each of 3 target output levels */
 #define EEPROM_TX_POWER_MEASUREMENTS   (3)
 
-#define EEPROM_4965_TX_POWER_VERSION        (2)
-
-/* 4965 driver does not work with txpower calibration version < 5.
- * Look for this in calib_version member of struct iwl4965_eeprom. */
-#define EEPROM_TX_POWER_VERSION_NEW    (5)
+/* 4965 Specific */
+/* 4965 driver does not work with txpower calibration version < 5 */
+#define EEPROM_4965_TX_POWER_VERSION    (5)
+#define EEPROM_4965_CALIB_VERSION_OFFSET       (2*0xB6) /* 2 bytes */
+#define EEPROM_4965_CALIB_TXPOWER_OFFSET       (2*0xE8) /* 48  bytes */
+#define EEPROM_4965_BOARD_REVISION             (2*0x4F) /* 2 bytes */
+#define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
 
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
 
 /*
- * 4965 factory calibration data for one txpower level, on one channel,
+ * factory calibration data for one txpower level, on one channel,
  * measured on one of the 2 tx chains (radio transmitter and associated
  * antenna).  EEPROM contains:
  *
@@ -154,7 +156,7 @@ extern const u8 iwl_eeprom_band_1[14];
  *
  * 4)  RF power amplifier detector level measurement (not used).
  */
-struct iwl4965_eeprom_calib_measure {
+struct iwl_eeprom_calib_measure {
 	u8 temperature;		/* Device temperature (Celsius) */
 	u8 gain_idx;		/* Index into gain table */
 	u8 actual_pow;		/* Measured RF output power, half-dBm */
@@ -163,22 +165,22 @@ struct iwl4965_eeprom_calib_measure {
 
 
 /*
- * 4965 measurement set for one channel.  EEPROM contains:
+ * measurement set for one channel.  EEPROM contains:
  *
  * 1)  Channel number measured
  *
  * 2)  Measurements for each of 3 power levels for each of 2 radio transmitters
  *     (a.k.a. "tx chains") (6 measurements altogether)
  */
-struct iwl4965_eeprom_calib_ch_info {
+struct iwl_eeprom_calib_ch_info {
 	u8 ch_num;
-	struct iwl4965_eeprom_calib_measure
+	struct iwl_eeprom_calib_measure
 		measurements[EEPROM_TX_POWER_TX_CHAINS]
 			[EEPROM_TX_POWER_MEASUREMENTS];
 } __attribute__ ((packed));
 
 /*
- * 4965 txpower subband info.
+ * txpower subband info.
  *
  * For each frequency subband, EEPROM contains the following:
  *
@@ -187,16 +189,16 @@ struct iwl4965_eeprom_calib_ch_info {
  *
  * 2)  Sample measurement sets for 2 channels close to the range endpoints.
  */
-struct iwl4965_eeprom_calib_subband_info {
+struct iwl_eeprom_calib_subband_info {
 	u8 ch_from;	/* channel number of lowest channel in subband */
 	u8 ch_to;	/* channel number of highest channel in subband */
-	struct iwl4965_eeprom_calib_ch_info ch1;
-	struct iwl4965_eeprom_calib_ch_info ch2;
+	struct iwl_eeprom_calib_ch_info ch1;
+	struct iwl_eeprom_calib_ch_info ch2;
 } __attribute__ ((packed));
 
 
 /*
- * 4965 txpower calibration info.  EEPROM contains:
+ * txpower calibration info.  EEPROM contains:
  *
  * 1)  Factory-measured saturation power levels (maximum levels at which
  *     tx power amplifier can output a signal without too much distortion).
@@ -212,55 +214,45 @@ struct iwl4965_eeprom_calib_subband_info {
  *     characteristics of the analog radio circuitry vary with frequency.
  *
  *     Not all sets need to be filled with data;
- *     struct iwl4965_eeprom_calib_subband_info contains range of channels
+ *     struct iwl_eeprom_calib_subband_info contains range of channels
  *     (0 if unused) for each set of data.
  */
-struct iwl4965_eeprom_calib_info {
+struct iwl_eeprom_calib_info {
 	u8 saturation_power24;	/* half-dBm (e.g. "34" = 17 dBm) */
 	u8 saturation_power52;	/* half-dBm */
 	s16 voltage;		/* signed */
-	struct iwl4965_eeprom_calib_subband_info
+	struct iwl_eeprom_calib_subband_info
 		band_info[EEPROM_TX_POWER_BANDS];
 } __attribute__ ((packed));
 
 
-
-/*
- * 4965 EEPROM map
- */
-struct iwl4965_eeprom {
-	u8 reserved0[16];
-	u16 device_id;		/* abs.ofs: 16 */
-	u8 reserved1[2];
-	u16 pmc;		/* abs.ofs: 20 */
-	u8 reserved2[20];
-	u8 mac_address[6];	/* abs.ofs: 42 */
-	u8 reserved3[58];
-	u16 board_revision;	/* abs.ofs: 106 */
-	u8 reserved4[11];
-	u8 board_pba_number[9];	/* abs.ofs: 119 */
-	u8 reserved5[8];
-	u16 version;		/* abs.ofs: 136 */
-	u8 sku_cap;		/* abs.ofs: 138 */
-	u8 leds_mode;		/* abs.ofs: 139 */
-	u16 oem_mode;
-	u16 wowlan_mode;	/* abs.ofs: 142 */
-	u16 leds_time_interval;	/* abs.ofs: 144 */
-	u8 leds_off_time;	/* abs.ofs: 146 */
-	u8 leds_on_time;	/* abs.ofs: 147 */
-	u8 almgor_m_version;	/* abs.ofs: 148 */
-	u8 antenna_switch_type;	/* abs.ofs: 149 */
-	u8 reserved6[8];
-	u16 board_revision_4965;	/* abs.ofs: 158 */
-	u8 reserved7[13];
-	u8 board_pba_number_4965[9];	/* abs.ofs: 173 */
-	u8 reserved8[10];
-	u8 sku_id[4];		/* abs.ofs: 192 */
+#define ADDRESS_MSK                 0x0000FFFF
+#define INDIRECT_TYPE_MSK           0x000F0000
+#define INDIRECT_HOST               0x00010000
+#define INDIRECT_GENERAL            0x00020000
+#define INDIRECT_REGULATORY         0x00030000
+#define INDIRECT_CALIBRATION        0x00040000
+#define INDIRECT_PROCESS_ADJST      0x00050000
+#define INDIRECT_OTHERS             0x00060000
+#define INDIRECT_ADDRESS            0x00100000
+
+/* General */
+#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
+#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
+#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
+#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
+#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
+#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
+#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
+#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
+#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
+#define EEPROM_3945_M_VERSION               (2*0x4A)	/* 1  bytes */
+#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
 
 /*
  * Per-channel regulatory data.
  *
- * Each channel that *might* be supported by 3945 or 4965 has a fixed location
+ * Each channel that *might* be supported by iwl has a fixed location
  * in EEPROM containing EEPROM_CHANNEL_* usage flags (LSB) and max regulatory
  * txpower (MSB).
  *
@@ -269,40 +261,38 @@ struct iwl4965_eeprom {
  *
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  */
-	u16 band_1_count;	/* abs.ofs: 196 */
-	struct iwl4965_eeprom_channel band_1_channels[14]; /* abs.ofs: 196 */
+#define EEPROM_REGULATORY_SKU_ID            (2*0x60)    /* 4  bytes */
+#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
+#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
 
 /*
  * 4.9 GHz channels 183, 184, 185, 187, 188, 189, 192, 196,
  * 5.0 GHz channels 7, 8, 11, 12, 16
  * (4915-5080MHz) (none of these is ever supported)
  */
-	u16 band_2_count;	/* abs.ofs: 226 */
-	struct iwl4965_eeprom_channel band_2_channels[13]; /* abs.ofs: 228 */
+#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
+#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
 
 /*
  * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
  * (5170-5320MHz)
  */
-	u16 band_3_count;	/* abs.ofs: 254 */
-	struct iwl4965_eeprom_channel band_3_channels[12]; /* abs.ofs: 256 */
+#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
+#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
 
 /*
  * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
  * (5500-5700MHz)
  */
-	u16 band_4_count;	/* abs.ofs: 280 */
-	struct iwl4965_eeprom_channel band_4_channels[11]; /* abs.ofs: 282 */
+#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
+#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
 
 /*
  * 5.7 GHz channels 145, 149, 153, 157, 161, 165
  * (5725-5825MHz)
  */
-	u16 band_5_count;	/* abs.ofs: 304 */
-	struct iwl4965_eeprom_channel band_5_channels[6]; /* abs.ofs: 306 */
-
-	u8 reserved10[2];
-
+#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
+#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
 
 /*
  * 2.4 GHz FAT channels 1 (5), 2 (6), 3 (7), 4 (8), 5 (9), 6 (10), 7 (11)
@@ -319,52 +309,33 @@ struct iwl4965_eeprom {
  *
  * NOTE:  4965 does not support FAT channels on 2.4 GHz.
  */
-	struct iwl4965_eeprom_channel band_24_channels[7]; /* abs.ofs: 320 */
-	u8 reserved11[2];
+#define EEPROM_4965_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
 
 /*
  * 5.2 GHz FAT channels 36 (40), 44 (48), 52 (56), 60 (64),
  * 100 (104), 108 (112), 116 (120), 124 (128), 132 (136), 149 (153), 157 (161)
  */
-	struct iwl4965_eeprom_channel band_52_channels[11]; /* abs.ofs: 336 */
-	u8 reserved12[6];
-
-/*
- * 4965 driver requires txpower calibration format version 5 or greater.
- * Driver does not work with txpower calibration version < 5.
- * This value is simply a 16-bit number, no major/minor versions here.
- */
-	u16 calib_version;	/* abs.ofs: 364 */
-	u8 reserved13[2];
-	u8 reserved14[96];	/* abs.ofs: 368 */
-
-/*
- * 4965 Txpower calibration data.
- */
-	struct iwl4965_eeprom_calib_info calib_info;	/* abs.ofs: 464 */
-
-	u8 reserved16[140];	/* fill out to full 1024 byte block */
-
-
-} __attribute__ ((packed));
-
-#define IWL_EEPROM_IMAGE_SIZE 1024
-
-/* End of EEPROM */
+#define EEPROM_4965_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
 
 struct iwl_eeprom_ops {
+	const u32 regulatory_bands[7];
 	int (*verify_signature) (struct iwl_priv *priv);
 	int (*acquire_semaphore) (struct iwl_priv *priv);
 	void (*release_semaphore) (struct iwl_priv *priv);
+	const u8* (*query_addr) (const struct iwl_priv *priv, size_t offset);
 };
 
 
 void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac);
 int iwl_eeprom_init(struct iwl_priv *priv);
+void iwl_eeprom_free(struct iwl_priv *priv);
+const u8 *iwl_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
+u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset);
 
 int iwlcore_eeprom_verify_signature(struct iwl_priv *priv);
 int iwlcore_eeprom_acquire_semaphore(struct iwl_priv *priv);
 void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
+const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset);
 
 int iwl_init_channel_map(struct iwl_priv *priv);
 void iwl_free_channel_map(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6fb9979..17b1858 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7564,7 +7564,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Device-specific setup */
 	if (priv->cfg->ops->lib->set_hw_params(priv)) {
 		IWL_ERROR("failed to set hw parameters\n");
-		goto out_iounmap;
+		goto out_free_eeprom;
 	}
 
 	/*******************
@@ -7625,6 +7625,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	sysfs_remove_group(&pdev->dev.kobj, &iwl4965_attribute_group);
  out_unset_hw_params:
 	iwl4965_unset_hw_params(priv);
+ out_free_eeprom:
+	iwl_eeprom_free(priv);
  out_iounmap:
 	pci_iounmap(pdev, priv->hw_base);
  out_pci_release_regions:
@@ -7688,6 +7690,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	iwl4965_unset_hw_params(priv);
 	iwlcore_clear_stations_table(priv);
+	iwl_eeprom_free(priv);
 
 
 	/*netif_stop_queue(dev); */
-- 
1.5.3.4

