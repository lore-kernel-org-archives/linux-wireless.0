Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbZAWVmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:53 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/15] iwl3945: Use iwl-eeprom.c routines
Date: Fri, 23 Jan 2009 13:45:15 -0800
Message-Id: <1232747123-7261-8-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224305_009656_9C100FD2)
In-Reply-To: <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

By adding the eeprom ops to the 3945 code, we can now use the iwlcore eeprom
routines (defined in iwl-eeprom.c).
We also removed the heavy eeprom39 reference from iwl_priv and use the eeprom
pointer instead.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   92 ++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    8 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    3 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  372 ++-------------------------
 6 files changed, 115 insertions(+), 367 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 013e24e..1327b2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -182,7 +182,7 @@ struct iwl3945_eeprom {
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  */
 	u16 band_1_count;	/* abs.ofs: 196 */
-	struct iwl_eeprom_channel band_1_channels[14];  /* abs.ofs: 196 */
+	struct iwl_eeprom_channel band_1_channels[14];  /* abs.ofs: 198 */
 
 /*
  * 4.9 GHz channels 183, 184, 185, 187, 188, 189, 192, 196,
@@ -225,7 +225,7 @@ struct iwl3945_eeprom {
 	u8 reserved16[172];	/* fill out to full 1024 byte block */
 } __attribute__ ((packed));
 
-#define IWL_EEPROM_IMAGE_SIZE 1024
+#define IWL3945_EEPROM_IMG_SIZE 1024
 
 /* End of EEPROM */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2689113..75e9553 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -42,6 +42,7 @@
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
+#include "iwl-eeprom.h"
 #include "iwl-helpers.h"
 #include "iwl-core.h"
 #include "iwl-agn-rs.h"
@@ -209,17 +210,19 @@ static int iwl3945_hwrate_to_plcp_idx(u8 plcp)
  */
 __le32 iwl3945_get_antenna_flags(const struct iwl_priv *priv)
 {
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
+
 	switch (priv->antenna) {
 	case IWL_ANTENNA_DIVERSITY:
 		return 0;
 
 	case IWL_ANTENNA_MAIN:
-		if (priv->eeprom39.antenna_switch_type)
+		if (eeprom->antenna_switch_type)
 			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
 		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
 
 	case IWL_ANTENNA_AUX:
-		if (priv->eeprom39.antenna_switch_type)
+		if (eeprom->antenna_switch_type)
 			return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_A_MSK;
 		return RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_B_MSK;
 	}
@@ -1128,6 +1131,7 @@ out:
 
 static void iwl3945_nic_config(struct iwl_priv *priv)
 {
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	unsigned long flags;
 	u8 rev_id = 0;
 
@@ -1145,42 +1149,42 @@ static void iwl3945_nic_config(struct iwl_priv *priv)
 			    CSR39_HW_IF_CONFIG_REG_BIT_3945_MM);
 	}
 
-	if (EEPROM_SKU_CAP_OP_MODE_MRC == priv->eeprom39.sku_cap) {
+	if (EEPROM_SKU_CAP_OP_MODE_MRC == eeprom->sku_cap) {
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_SKU_MRC);
 	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
 
-	if ((priv->eeprom39.board_revision & 0xF0) == 0xD0) {
+	if ((eeprom->board_revision & 0xF0) == 0xD0) {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
-			       priv->eeprom39.board_revision);
+			       eeprom->board_revision);
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	} else {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
-			       priv->eeprom39.board_revision);
+			       eeprom->board_revision);
 		iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
 			      CSR39_HW_IF_CONFIG_REG_BIT_BOARD_TYPE);
 	}
 
-	if (priv->eeprom39.almgor_m_version <= 1) {
+	if (eeprom->almgor_m_version <= 1) {
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A);
 		IWL_DEBUG_INFO("Card M type A version is 0x%X\n",
-			       priv->eeprom39.almgor_m_version);
+			       eeprom->almgor_m_version);
 	} else {
 		IWL_DEBUG_INFO("Card M type B version is 0x%X\n",
-			       priv->eeprom39.almgor_m_version);
+			       eeprom->almgor_m_version);
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR39_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->eeprom39.sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
+	if (eeprom->sku_cap & EEPROM_SKU_CAP_SW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("SW RF KILL supported in EEPROM.\n");
 
-	if (priv->eeprom39.sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
+	if (eeprom->sku_cap & EEPROM_SKU_CAP_HW_RF_KILL_ENABLE)
 		IWL_DEBUG_RF_KILL("HW RF KILL supported in EEPROM.\n");
 }
 
@@ -1406,6 +1410,7 @@ int iwl3945_hw_get_temperature(struct iwl_priv *priv)
 */
 static int iwl3945_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 {
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	int temperature;
 
 	temperature = iwl3945_hw_get_temperature(priv);
@@ -1421,7 +1426,7 @@ static int iwl3945_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 		/* if really really hot(?),
 		 *   substitute the 3rd band/group's temp measured at factory */
 		if (priv->last_temperature > 100)
-			temperature = priv->eeprom39.groups[2].temperature;
+			temperature = eeprom->groups[2].temperature;
 		else /* else use most recent "sane" value from driver */
 			temperature = priv->last_temperature;
 	}
@@ -1720,7 +1725,7 @@ int iwl3945_send_tx_power(struct iwl_priv *priv)
 	};
 
 	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
-	ch_info = iwl3945_get_channel_info(priv,
+	ch_info = iwl_get_channel_info(priv,
 				       priv->band,
 				       le16_to_cpu(priv->active39_rxon.channel));
 	if (!ch_info) {
@@ -1881,6 +1886,7 @@ static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl_channel_info *ch_info)
 static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch_info = NULL;
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	int delta_index;
 	const s8 *clip_pwrs; /* array of h/w max power levels for each rate */
 	u8 a_band;
@@ -1896,7 +1902,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 		a_band = is_channel_a_band(ch_info);
 
 		/* Get this chnlgrp's factory calibration temperature */
-		ref_temp = (s16)priv->eeprom39.groups[ch_info->group_index].
+		ref_temp = (s16)eeprom->groups[ch_info->group_index].
 		    temperature;
 
 		/* get power index adjustment based on current and factory
@@ -2041,7 +2047,8 @@ static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl_priv *priv,
 				       const struct iwl_channel_info *ch_info)
 {
-	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom39.groups[0];
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
+	struct iwl3945_eeprom_txpower_group *ch_grp = &eeprom->groups[0];
 	u8 group;
 	u16 group_index = 0;	/* based on factory calib frequencies */
 	u8 grp_channel;
@@ -2077,6 +2084,7 @@ static int iwl3945_hw_reg_get_matched_power_index(struct iwl_priv *priv,
 				       s32 setting_index, s32 *new_index)
 {
 	const struct iwl3945_eeprom_txpower_group *chnl_grp = NULL;
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	s32 index0, index1;
 	s32 power = 2 * requested_power;
 	s32 i;
@@ -2085,7 +2093,7 @@ static int iwl3945_hw_reg_get_matched_power_index(struct iwl_priv *priv,
 	s32 res;
 	s32 denominator;
 
-	chnl_grp = &priv->eeprom39.groups[setting_index];
+	chnl_grp = &eeprom->groups[setting_index];
 	samples = chnl_grp->samples;
 	for (i = 0; i < 5; i++) {
 		if (power == samples[i].power) {
@@ -2124,6 +2132,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 {
 	u32 i;
 	s32 rate_index;
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	const struct iwl3945_eeprom_txpower_group *group;
 
 	IWL_DEBUG_POWER("Initializing factory calib info from EEPROM\n");
@@ -2131,7 +2140,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl_priv *priv)
 	for (i = 0; i < IWL_NUM_TX_CALIB_GROUPS; i++) {
 		s8 *clip_pwrs;	/* table of power levels for each rate */
 		s8 satur_pwr;	/* saturation power for each chnl group */
-		group = &priv->eeprom39.groups[i];
+		group = &eeprom->groups[i];
 
 		/* sanity check on factory saturation power value */
 		if (group->saturation_power < 40) {
@@ -2204,6 +2213,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_channel_power_info *pwr_info;
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 	int delta_index;
 	u8 rate_index;
 	u8 scan_tbl_index;
@@ -2238,7 +2248,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 		/* calculate power index *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
 		delta_index = iwl3945_hw_reg_adjust_power_by_temp(temperature,
-				priv->eeprom39.groups[ch_info->group_index].
+				eeprom->groups[ch_info->group_index].
 				temperature);
 
 		IWL_DEBUG_POWER("Delta index for channel %d: %d [%d]\n",
@@ -2585,6 +2595,33 @@ static int iwl3945_verify_bsm(struct iwl_priv *priv)
 	return 0;
 }
 
+
+/******************************************************************************
+ *
+ * EEPROM related functions
+ *
+ ******************************************************************************/
+
+/*
+ * Clear the OWNER_MSK, to establish driver (instead of uCode running on
+ * embedded controller) as EEPROM reader; each read is a series of pulses
+ * to/from the EEPROM chip, not a single event, so even reads could conflict
+ * if they weren't arbitrated by some ownership mechanism.  Here, the driver
+ * simply claims ownership, which should be safe when this function is called
+ * (i.e. before loading uCode!).
+ */
+static int iwl3945_eeprom_acquire_semaphore(struct iwl_priv *priv)
+{
+	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
+	return 0;
+}
+
+
+static void iwl3945_eeprom_release_semaphore(struct iwl_priv *priv)
+{
+	return;
+}
+
  /**
   * iwl3945_load_bsm - Load bootstrap instructions
   *
@@ -2715,6 +2752,21 @@ static struct iwl_lib_ops iwl3945_lib = {
 		.config = iwl3945_nic_config,
 		.set_pwr_src = iwl3945_set_pwr_src,
 	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_REGULATORY_BAND_1_CHANNELS,
+			EEPROM_REGULATORY_BAND_2_CHANNELS,
+			EEPROM_REGULATORY_BAND_3_CHANNELS,
+			EEPROM_REGULATORY_BAND_4_CHANNELS,
+			EEPROM_REGULATORY_BAND_5_CHANNELS,
+			IWL3945_EEPROM_IMG_SIZE,
+			IWL3945_EEPROM_IMG_SIZE,
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwl3945_eeprom_acquire_semaphore,
+		.release_semaphore = iwl3945_eeprom_release_semaphore,
+		.query_addr = iwlcore_eeprom_query_addr,
+	},
 	.send_tx_power	= iwl3945_send_tx_power,
 };
 
@@ -2733,6 +2785,8 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
+	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params
 };
@@ -2743,6 +2797,8 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
+	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
 	.mod_params = &iwl3945_mod_params
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 5aa22d6..d4e0778 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1091,9 +1091,6 @@ struct iwl_priv {
 
 	struct iwl3945_station_entry stations_39[IWL_STATION_COUNT];
 
-	/* eeprom */
-	struct iwl3945_eeprom eeprom39;
-
 	u32 sta_supp_rates;
 }; /*iwl_priv */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index cebfb8f..eaa658f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -531,6 +531,13 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 		}
 	}
 
+	/* Check if we do have FAT channels */
+	if (priv->cfg->ops->lib->eeprom_ops.regulatory_bands[5] >=
+	    priv->cfg->eeprom_size &&
+	    priv->cfg->ops->lib->eeprom_ops.regulatory_bands[6] >=
+	    priv->cfg->eeprom_size)
+		return 0;
+
 	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
 	for (band = 6; band <= 7; band++) {
 		enum ieee80211_band ieeeband;
@@ -582,6 +589,7 @@ void iwl_free_channel_map(struct iwl_priv *priv)
 	kfree(priv->channel_info);
 	priv->channel_count = 0;
 }
+EXPORT_SYMBOL(iwl_free_channel_map);
 
 /**
  * iwl_get_channel_info - Find driver's private channel info
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index dd2e7d2..17fed49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -118,6 +118,9 @@ struct iwl_eeprom_channel {
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __attribute__ ((packed));
 
+/* 3945 Specific */
+#define EEPROM_3945_EEPROM_VERSION	(0x2f)
+
 /* 4965 has two radio transmitters (and 3 radio receivers) */
 #define EEPROM_TX_POWER_TX_CHAINS      (2)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 14f9523..b57c2b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -257,7 +257,7 @@ static int iwl3945_set_rxon_channel(struct iwl_priv *priv,
 				    enum ieee80211_band band,
 				    u16 channel)
 {
-	if (!iwl3945_get_channel_info(priv, band, channel)) {
+	if (!iwl_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
 			       channel, band);
 		return -EINVAL;
@@ -834,86 +834,6 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 	return rc;
 }
 
-/******************************************************************************
- *
- * EEPROM related functions
- *
- ******************************************************************************/
-
-static void get_eeprom_mac(struct iwl_priv *priv, u8 *mac)
-{
-	memcpy(mac, priv->eeprom39.mac_address, 6);
-}
-
-/*
- * Clear the OWNER_MSK, to establish driver (instead of uCode running on
- * embedded controller) as EEPROM reader; each read is a series of pulses
- * to/from the EEPROM chip, not a single event, so even reads could conflict
- * if they weren't arbitrated by some ownership mechanism.  Here, the driver
- * simply claims ownership, which should be safe when this function is called
- * (i.e. before loading uCode!).
- */
-static inline int iwl3945_eeprom_acquire_semaphore(struct iwl_priv *priv)
-{
-	_iwl_clear_bit(priv, CSR_EEPROM_GP, CSR_EEPROM_GP_IF_OWNER_MSK);
-	return 0;
-}
-
-/**
- * iwl3945_eeprom_init - read EEPROM contents
- *
- * Load the EEPROM contents from adapter into priv->eeprom39
- *
- * NOTE:  This routine uses the non-debug IO access functions.
- */
-int iwl3945_eeprom_init(struct iwl_priv *priv)
-{
-	u16 *e = (u16 *)&priv->eeprom39;
-	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
-	int sz = sizeof(priv->eeprom39);
-	int ret;
-	u16 addr;
-
-	/* The EEPROM structure has several padding buffers within it
-	 * and when adding new EEPROM maps is subject to programmer errors
-	 * which may be very difficult to identify without explicitly
-	 * checking the resulting size of the eeprom map. */
-	BUILD_BUG_ON(sizeof(priv->eeprom39) != IWL_EEPROM_IMAGE_SIZE);
-
-	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
-		return -ENOENT;
-	}
-
-	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl3945_eeprom_acquire_semaphore(priv);
-	if (ret < 0) {
-		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
-		return -ENOENT;
-	}
-
-	/* eeprom is an array of 16bit values */
-	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		u32 r;
-
-		_iwl_write32(priv, CSR_EEPROM_REG,
-				 CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-		_iwl_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
-		ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
-					      CSR_EEPROM_REG_READ_VALID_MSK,
-					      IWL_EEPROM_ACCESS_TIMEOUT);
-		if (ret < 0) {
-			IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
-			return ret;
-		}
-
-		r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
-		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
-	}
-
-	return 0;
-}
-
 static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 {
 	if (priv->shared_virt)
@@ -1304,7 +1224,7 @@ static void iwl3945_connection_init_rx_config(struct iwl_priv *priv,
 		priv->staging39_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl3945_get_channel_info(priv, priv->band,
+	ch_info = iwl_get_channel_info(priv, priv->band,
 				       le16_to_cpu(priv->active39_rxon.channel));
 
 	if (!ch_info)
@@ -1336,7 +1256,7 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		const struct iwl_channel_info *ch_info;
 
-		ch_info = iwl3945_get_channel_info(priv,
+		ch_info = iwl_get_channel_info(priv,
 			priv->band,
 			le16_to_cpu(priv->staging39_rxon.channel));
 
@@ -3349,258 +3269,6 @@ unplugged:
 	return IRQ_NONE;
 }
 
-/************************** EEPROM BANDS ****************************
- *
- * The iwl3945_eeprom_band definitions below provide the mapping from the
- * EEPROM contents to the specific channel number supported for each
- * band.
- *
- * For example, iwl3945_priv->eeprom39.band_3_channels[4] from the band_3
- * definition below maps to physical channel 42 in the 5.2GHz spectrum.
- * The specific geography and calibration information for that channel
- * is contained in the eeprom map itself.
- *
- * During init, we copy the eeprom information and channel map
- * information into priv->channel_info_24/52 and priv->channel_map_24/52
- *
- * channel_map_24/52 provides the index in the channel_info array for a
- * given channel.  We have to have two separate maps as there is channel
- * overlap with the 2.4GHz and 5.2GHz spectrum as seen in band_1 and
- * band_2
- *
- * A value of 0xff stored in the channel_map indicates that the channel
- * is not supported by the hardware at all.
- *
- * A value of 0xfe in the channel_map indicates that the channel is not
- * valid for Tx with the current hardware.  This means that
- * while the system can tune and receive on a given channel, it may not
- * be able to associate or transmit any frames on that
- * channel.  There is no corresponding channel information for that
- * entry.
- *
- *********************************************************************/
-
-/* 2.4 GHz */
-static const u8 iwl3945_eeprom_band_1[14] = {
-	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
-};
-
-/* 5.2 GHz bands */
-static const u8 iwl3945_eeprom_band_2[] = {	/* 4915-5080MHz */
-	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
-};
-
-static const u8 iwl3945_eeprom_band_3[] = {	/* 5170-5320MHz */
-	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
-};
-
-static const u8 iwl3945_eeprom_band_4[] = {	/* 5500-5700MHz */
-	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
-};
-
-static const u8 iwl3945_eeprom_band_5[] = {	/* 5725-5825MHz */
-	145, 149, 153, 157, 161, 165
-};
-
-static void iwl3945_init_band_reference(const struct iwl_priv *priv, int band,
-				    int *eeprom_ch_count,
-				    const struct iwl_eeprom_channel
-				    **eeprom_ch_info,
-				    const u8 **eeprom_ch_index)
-{
-	switch (band) {
-	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_1);
-		*eeprom_ch_info = priv->eeprom39.band_1_channels;
-		*eeprom_ch_index = iwl3945_eeprom_band_1;
-		break;
-	case 2:		/* 4.9GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_2);
-		*eeprom_ch_info = priv->eeprom39.band_2_channels;
-		*eeprom_ch_index = iwl3945_eeprom_band_2;
-		break;
-	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_3);
-		*eeprom_ch_info = priv->eeprom39.band_3_channels;
-		*eeprom_ch_index = iwl3945_eeprom_band_3;
-		break;
-	case 4:		/* 5.5GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_4);
-		*eeprom_ch_info = priv->eeprom39.band_4_channels;
-		*eeprom_ch_index = iwl3945_eeprom_band_4;
-		break;
-	case 5:		/* 5.7GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl3945_eeprom_band_5);
-		*eeprom_ch_info = priv->eeprom39.band_5_channels;
-		*eeprom_ch_index = iwl3945_eeprom_band_5;
-		break;
-	default:
-		BUG();
-		return;
-	}
-}
-
-/**
- * iwl3945_get_channel_info - Find driver's private channel info
- *
- * Based on band and channel number.
- */
-const struct iwl_channel_info *
-iwl3945_get_channel_info(const struct iwl_priv *priv,
-			 enum ieee80211_band band, u16 channel)
-{
-	int i;
-
-	switch (band) {
-	case IEEE80211_BAND_5GHZ:
-		for (i = 14; i < priv->channel_count; i++) {
-			if (priv->channel_info[i].channel == channel)
-				return &priv->channel_info[i];
-		}
-		break;
-
-	case IEEE80211_BAND_2GHZ:
-		if (channel >= 1 && channel <= 14)
-			return &priv->channel_info[channel - 1];
-		break;
-	case IEEE80211_NUM_BANDS:
-		WARN_ON(1);
-	}
-
-	return NULL;
-}
-
-#define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
-			    ? # x " " : "")
-
-/**
- * iwl3945_init_channel_map - Set up driver's info for all possible channels
- */
-static int iwl3945_init_channel_map(struct iwl_priv *priv)
-{
-	int eeprom_ch_count = 0;
-	const u8 *eeprom_ch_index = NULL;
-	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
-	int band, ch;
-	struct iwl_channel_info *ch_info;
-
-	if (priv->channel_count) {
-		IWL_DEBUG_INFO("Channel map already initialized.\n");
-		return 0;
-	}
-
-	if (priv->eeprom39.version < 0x2f) {
-		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
-			    priv->eeprom39.version);
-		return -EINVAL;
-	}
-
-	IWL_DEBUG_INFO("Initializing regulatory info from EEPROM\n");
-
-	priv->channel_count =
-	    ARRAY_SIZE(iwl3945_eeprom_band_1) +
-	    ARRAY_SIZE(iwl3945_eeprom_band_2) +
-	    ARRAY_SIZE(iwl3945_eeprom_band_3) +
-	    ARRAY_SIZE(iwl3945_eeprom_band_4) +
-	    ARRAY_SIZE(iwl3945_eeprom_band_5);
-
-	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
-
-	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
-				     priv->channel_count, GFP_KERNEL);
-	if (!priv->channel_info) {
-		IWL_ERR(priv, "Could not allocate channel_info\n");
-		priv->channel_count = 0;
-		return -ENOMEM;
-	}
-
-	ch_info = priv->channel_info;
-
-	/* Loop through the 5 EEPROM bands adding them in order to the
-	 * channel map we maintain (that contains additional information than
-	 * what just in the EEPROM) */
-	for (band = 1; band <= 5; band++) {
-
-		iwl3945_init_band_reference(priv, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
-
-		/* Loop through each band adding each of the channels */
-		for (ch = 0; ch < eeprom_ch_count; ch++) {
-			ch_info->channel = eeprom_ch_index[ch];
-			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
-			    IEEE80211_BAND_5GHZ;
-
-			/* permanently store EEPROM's channel regulatory flags
-			 *   and max power in channel info database. */
-			ch_info->eeprom = eeprom_ch_info[ch];
-
-			/* Copy the run-time flags so they are there even on
-			 * invalid channels */
-			ch_info->flags = eeprom_ch_info[ch].flags;
-
-			if (!(is_channel_valid(ch_info))) {
-				IWL_DEBUG_INFO("Ch. %d Flags %x [%sGHz] - "
-					       "No traffic\n",
-					       ch_info->channel,
-					       ch_info->flags,
-					       is_channel_a_band(ch_info) ?
-					       "5.2" : "2.4");
-				ch_info++;
-				continue;
-			}
-
-			/* Initialize regulatory-based run-time data */
-			ch_info->max_power_avg = ch_info->curr_txpow =
-			    eeprom_ch_info[ch].max_power_avg;
-			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
-			ch_info->min_power = 0;
-
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
-				       " %ddBm): Ad-Hoc %ssupported\n",
-				       ch_info->channel,
-				       is_channel_a_band(ch_info) ?
-				       "5.2" : "2.4",
-				       CHECK_AND_PRINT(VALID),
-				       CHECK_AND_PRINT(IBSS),
-				       CHECK_AND_PRINT(ACTIVE),
-				       CHECK_AND_PRINT(RADAR),
-				       CHECK_AND_PRINT(WIDE),
-				       CHECK_AND_PRINT(DFS),
-				       eeprom_ch_info[ch].flags,
-				       eeprom_ch_info[ch].max_power_avg,
-				       ((eeprom_ch_info[ch].
-					 flags & EEPROM_CHANNEL_IBSS)
-					&& !(eeprom_ch_info[ch].
-					     flags & EEPROM_CHANNEL_RADAR))
-				       ? "" : "not ");
-
-			/* Set the tx_power_user_lmt to the highest power
-			 * supported by any channel */
-			if (eeprom_ch_info[ch].max_power_avg >
-			    priv->tx_power_user_lmt)
-				priv->tx_power_user_lmt =
-				    eeprom_ch_info[ch].max_power_avg;
-
-			ch_info++;
-		}
-	}
-
-	/* Set up txpower settings in driver for all channels */
-	if (iwl3945_txpower_set_from_eeprom(priv))
-		return -EIO;
-
-	return 0;
-}
-
-/*
- * iwl3945_free_channel_map - undo allocations in iwl3945_init_channel_map
- */
-static void iwl3945_free_channel_map(struct iwl_priv *priv)
-{
-	kfree(priv->channel_info);
-	priv->channel_count = 0;
-}
-
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
@@ -3631,7 +3299,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 
 		scan_ch->channel = channels[i].hw_value;
 
-		ch_info = iwl3945_get_channel_info(priv, band, scan_ch->channel);
+		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this band.\n",
 				       scan_ch->channel);
@@ -3718,6 +3386,7 @@ static void iwl3945_init_hw_rates(struct iwl_priv *priv,
 /**
  * iwl3945_init_geos - Initialize mac80211's geo/channel info based from eeprom
  */
+#define IEEE80211_24GHZ_MAX_CHANNEL 14
 static int iwl3945_init_geos(struct iwl_priv *priv)
 {
 	struct iwl_channel_info *ch;
@@ -3748,7 +3417,7 @@ static int iwl3945_init_geos(struct iwl_priv *priv)
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
+	sband->channels = &channels[IEEE80211_24GHZ_MAX_CHANNEL];
 	/* just OFDM */
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
 	sband->n_bitrates = IWL_RATE_COUNT - IWL_FIRST_OFDM_RATE;
@@ -5242,8 +4911,8 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ch_info = iwl3945_get_channel_info(priv, conf->channel->band,
-					   conf->channel->hw_value);
+	ch_info = iwl_get_channel_info(priv, conf->channel->band,
+				       conf->channel->hw_value);
 	if (!is_channel_valid(ch_info)) {
 		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this band.\n",
 			       conf->channel->hw_value, conf->channel->band);
@@ -6423,6 +6092,7 @@ static struct ieee80211_ops iwl3945_hw_ops = {
 static int iwl3945_init_drv(struct iwl_priv *priv)
 {
 	int ret;
+	struct iwl3945_eeprom *eeprom = (struct iwl3945_eeprom *)priv->eeprom;
 
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
@@ -6456,12 +6126,24 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->power_mode = IWL39_POWER_AC;
 	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
 
-	ret = iwl3945_init_channel_map(priv);
+	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
+		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
+			 eeprom->version);
+		ret = -EINVAL;
+		goto err;
+	}
+	ret = iwl_init_channel_map(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
 		goto err;
 	}
 
+	/* Set up txpower settings in driver for all channels */
+	if (iwl3945_txpower_set_from_eeprom(priv)) {
+		ret = -EIO;
+		goto err_free_channel_map;
+	}
+
 	ret = iwl3945_init_geos(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
@@ -6471,7 +6153,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	return 0;
 
 err_free_channel_map:
-	iwl3945_free_channel_map(priv);
+	iwl_free_channel_map(priv);
 err:
 	return ret;
 }
@@ -6482,6 +6164,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct iwl_priv *priv;
 	struct ieee80211_hw *hw;
 	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	struct iwl3945_eeprom *eeprom;
 	unsigned long flags;
 
 	/***********************
@@ -6597,13 +6280,14 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * ********************/
 
 	/* Read the EEPROM */
-	err = iwl3945_eeprom_init(priv);
+	err = iwl_eeprom_init(priv);
 	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_remove_sysfs;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
-	get_eeprom_mac(priv, priv->mac_addr);
+	eeprom = (struct iwl3945_eeprom *)priv->eeprom;
+	memcpy(priv->mac_addr, eeprom->mac_address, ETH_ALEN);
 	IWL_DEBUG_INFO("MAC address: %pM\n", priv->mac_addr);
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
@@ -6776,7 +6460,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 
-	iwl3945_free_channel_map(priv);
+	iwl_free_channel_map(priv);
 	iwl3945_free_geos(priv);
 	kfree(priv->scan);
 	if (priv->ibss_beacon)
-- 
1.5.4.3

