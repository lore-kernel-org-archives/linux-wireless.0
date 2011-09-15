Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934539Ab1IOTcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/27] iwlagn: merge eeprom access into single file
Date: Thu, 15 Sep 2011 11:46:41 -0700
Message-Id: <1316112414-6341-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213315_592413_FAECFA09)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split and no need to support legacy devices, there is no reason
we need to separate the NVM access into different files, merge those.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |  299 -------------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |  239 +++++++++++++++++++-
 3 files changed, 235 insertions(+), 305 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 48ab914..ae1d816 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
-iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
+iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o
 
 iwlagn-objs 		+= iwl-core.o iwl-eeprom.o iwl-power.o
 iwlagn-objs 		+= iwl-rx.o iwl-sta.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
deleted file mode 100644
index c62ddc2..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ /dev/null
@@ -1,299 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-
-#include <net/mac80211.h>
-
-#include "iwl-commands.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-debug.h"
-#include "iwl-agn.h"
-#include "iwl-io.h"
-
-/******************************************************************************
- *
- * EEPROM related functions
- *
-******************************************************************************/
-
-int iwl_eeprom_check_version(struct iwl_priv *priv)
-{
-	u16 eeprom_ver;
-	u16 calib_ver;
-
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	calib_ver = iwlagn_eeprom_calib_version(priv);
-
-	if (eeprom_ver < priv->cfg->eeprom_ver ||
-	    calib_ver < priv->cfg->eeprom_calib_ver)
-		goto err;
-
-	IWL_INFO(priv, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-		 eeprom_ver, calib_ver);
-
-	return 0;
-err:
-	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x "
-		  "CALIB=0x%x < 0x%x\n",
-		  eeprom_ver, priv->cfg->eeprom_ver,
-		  calib_ver,  priv->cfg->eeprom_calib_ver);
-	return -EINVAL;
-
-}
-
-int iwl_eeprom_check_sku(struct iwl_priv *priv)
-{
-	u16 radio_cfg;
-
-	if (!priv->cfg->sku) {
-		/* not using sku overwrite */
-		priv->cfg->sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
-		if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE &&
-		    !priv->cfg->ht_params) {
-			IWL_ERR(priv, "Invalid 11n configuration\n");
-			return -EINVAL;
-		}
-	}
-	if (!priv->cfg->sku) {
-		IWL_ERR(priv, "Invalid device sku\n");
-		return -EINVAL;
-	}
-
-	IWL_INFO(priv, "Device SKU: 0X%x\n", priv->cfg->sku);
-
-	if (!priv->cfg->valid_tx_ant && !priv->cfg->valid_rx_ant) {
-		/* not using .cfg overwrite */
-		radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
-		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
-		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
-			IWL_ERR(priv, "Invalid chain (0X%x, 0X%x)\n",
-				priv->cfg->valid_tx_ant,
-				priv->cfg->valid_rx_ant);
-			return -EINVAL;
-		}
-		IWL_INFO(priv, "Valid Tx ant: 0X%x, Valid Rx ant: 0X%x\n",
-			 priv->cfg->valid_tx_ant, priv->cfg->valid_rx_ant);
-	}
-	/*
-	 * for some special cases,
-	 * EEPROM did not reflect the correct antenna setting
-	 * so overwrite the valid tx/rx antenna from .cfg
-	 */
-	return 0;
-}
-
-void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
-{
-	const u8 *addr = iwl_eeprom_query_addr(priv,
-					EEPROM_MAC_ADDRESS);
-	memcpy(mac, addr, ETH_ALEN);
-}
-
-/**
- * iwl_get_max_txpower_avg - get the highest tx power from all chains.
- *     find the highest tx power from all chains for the channel
- */
-static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int element, s8 *max_txpower_in_half_dbm)
-{
-	s8 max_txpower_avg = 0; /* (dBm) */
-
-	/* Take the highest tx power from any valid chains */
-	if ((priv->cfg->valid_tx_ant & ANT_A) &&
-	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_a_max;
-	if ((priv->cfg->valid_tx_ant & ANT_B) &&
-	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_b_max;
-	if ((priv->cfg->valid_tx_ant & ANT_C) &&
-	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_c_max;
-	if (((priv->cfg->valid_tx_ant == ANT_AB) |
-	    (priv->cfg->valid_tx_ant == ANT_BC) |
-	    (priv->cfg->valid_tx_ant == ANT_AC)) &&
-	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
-		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
-	if ((priv->cfg->valid_tx_ant == ANT_ABC) &&
-	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].mimo3_max;
-
-	/*
-	 * max. tx power in EEPROM is in 1/2 dBm format
-	 * convert from 1/2 dBm to dBm (round-up convert)
-	 * but we also do not want to loss 1/2 dBm resolution which
-	 * will impact performance
-	 */
-	*max_txpower_in_half_dbm = max_txpower_avg;
-	return (max_txpower_avg & 0x01) + (max_txpower_avg >> 1);
-}
-
-static void
-iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
-				    struct iwl_eeprom_enhanced_txpwr *txp,
-				    s8 max_txpower_avg)
-{
-	int ch_idx;
-	bool is_ht40 = txp->flags & IWL_EEPROM_ENH_TXP_FL_40MHZ;
-	enum ieee80211_band band;
-
-	band = txp->flags & IWL_EEPROM_ENH_TXP_FL_BAND_52G ?
-		IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
-
-	for (ch_idx = 0; ch_idx < priv->channel_count; ch_idx++) {
-		struct iwl_channel_info *ch_info = &priv->channel_info[ch_idx];
-
-		/* update matching channel or from common data only */
-		if (txp->channel != 0 && ch_info->channel != txp->channel)
-			continue;
-
-		/* update matching band only */
-		if (band != ch_info->band)
-			continue;
-
-		if (ch_info->max_power_avg < max_txpower_avg && !is_ht40) {
-			ch_info->max_power_avg = max_txpower_avg;
-			ch_info->curr_txpow = max_txpower_avg;
-			ch_info->scan_power = max_txpower_avg;
-		}
-
-		if (is_ht40 && ch_info->ht40_max_power_avg < max_txpower_avg)
-			ch_info->ht40_max_power_avg = max_txpower_avg;
-	}
-}
-
-#define EEPROM_TXP_OFFS	(0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT)
-#define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
-#define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
-
-#define TXP_CHECK_AND_PRINT(x) ((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) \
-			    ? # x " " : "")
-
-void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
-{
-	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
-	int idx, entries;
-	__le16 *txp_len;
-	s8 max_txp_avg, max_txp_avg_halfdbm;
-
-	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
-
-	/* the length is in 16-bit words, but we want entries */
-	txp_len = (__le16 *) iwl_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
-	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
-
-	txp_array = (void *) iwl_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
-
-	for (idx = 0; idx < entries; idx++) {
-		txp = &txp_array[idx];
-		/* skip invalid entries */
-		if (!(txp->flags & IWL_EEPROM_ENH_TXP_FL_VALID))
-			continue;
-
-		IWL_DEBUG_EEPROM(priv, "%s %d:\t %s%s%s%s%s%s%s%s (0x%02x)\n",
-				 (txp->channel && (txp->flags &
-					IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE)) ?
-					"Common " : (txp->channel) ?
-					"Channel" : "Common",
-				 (txp->channel),
-				 TXP_CHECK_AND_PRINT(VALID),
-				 TXP_CHECK_AND_PRINT(BAND_52G),
-				 TXP_CHECK_AND_PRINT(OFDM),
-				 TXP_CHECK_AND_PRINT(40MHZ),
-				 TXP_CHECK_AND_PRINT(HT_AP),
-				 TXP_CHECK_AND_PRINT(RES1),
-				 TXP_CHECK_AND_PRINT(RES2),
-				 TXP_CHECK_AND_PRINT(COMMON_TYPE),
-				 txp->flags);
-		IWL_DEBUG_EEPROM(priv, "\t\t chain_A: 0x%02x "
-				 "chain_B: 0X%02x chain_C: 0X%02x\n",
-				 txp->chain_a_max, txp->chain_b_max,
-				 txp->chain_c_max);
-		IWL_DEBUG_EEPROM(priv, "\t\t MIMO2: 0x%02x "
-				 "MIMO3: 0x%02x High 20_on_40: 0x%02x "
-				 "Low 20_on_40: 0x%02x\n",
-				 txp->mimo2_max, txp->mimo3_max,
-				 ((txp->delta_20_in_40 & 0xf0) >> 4),
-				 (txp->delta_20_in_40 & 0x0f));
-
-		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
-						      &max_txp_avg_halfdbm);
-
-		/*
-		 * Update the user limit values values to the highest
-		 * power supported by any channel
-		 */
-		if (max_txp_avg > priv->tx_power_user_lmt)
-			priv->tx_power_user_lmt = max_txp_avg;
-		if (max_txp_avg_halfdbm > priv->tx_power_lmt_in_half_dbm)
-			priv->tx_power_lmt_in_half_dbm = max_txp_avg_halfdbm;
-
-		iwl_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
-	}
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 80ee65b..0b66941 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -72,6 +72,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-debug.h"
+#include "iwl-agn.h"
 #include "iwl-eeprom.h"
 #include "iwl-io.h"
 
@@ -138,7 +139,7 @@ static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
 
 /******************************************************************************
  *
- * EEPROM related functions
+ * generic NVM functions
  *
 ******************************************************************************/
 
@@ -214,6 +215,93 @@ static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 	return ret;
 }
 
+u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
+{
+	if (!priv->eeprom)
+		return 0;
+	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
+}
+
+int iwl_eeprom_check_version(struct iwl_priv *priv)
+{
+	u16 eeprom_ver;
+	u16 calib_ver;
+
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	calib_ver = iwlagn_eeprom_calib_version(priv);
+
+	if (eeprom_ver < priv->cfg->eeprom_ver ||
+	    calib_ver < priv->cfg->eeprom_calib_ver)
+		goto err;
+
+	IWL_INFO(priv, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+		 eeprom_ver, calib_ver);
+
+	return 0;
+err:
+	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x "
+		  "CALIB=0x%x < 0x%x\n",
+		  eeprom_ver, priv->cfg->eeprom_ver,
+		  calib_ver,  priv->cfg->eeprom_calib_ver);
+	return -EINVAL;
+
+}
+
+int iwl_eeprom_check_sku(struct iwl_priv *priv)
+{
+	u16 radio_cfg;
+
+	if (!priv->cfg->sku) {
+		/* not using sku overwrite */
+		priv->cfg->sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
+		if (priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE &&
+		    !priv->cfg->ht_params) {
+			IWL_ERR(priv, "Invalid 11n configuration\n");
+			return -EINVAL;
+		}
+	}
+	if (!priv->cfg->sku) {
+		IWL_ERR(priv, "Invalid device sku\n");
+		return -EINVAL;
+	}
+
+	IWL_INFO(priv, "Device SKU: 0X%x\n", priv->cfg->sku);
+
+	if (!priv->cfg->valid_tx_ant && !priv->cfg->valid_rx_ant) {
+		/* not using .cfg overwrite */
+		radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
+		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
+			IWL_ERR(priv, "Invalid chain (0X%x, 0X%x)\n",
+				priv->cfg->valid_tx_ant,
+				priv->cfg->valid_rx_ant);
+			return -EINVAL;
+		}
+		IWL_INFO(priv, "Valid Tx ant: 0X%x, Valid Rx ant: 0X%x\n",
+			 priv->cfg->valid_tx_ant, priv->cfg->valid_rx_ant);
+	}
+	/*
+	 * for some special cases,
+	 * EEPROM did not reflect the correct antenna setting
+	 * so overwrite the valid tx/rx antenna from .cfg
+	 */
+	return 0;
+}
+
+void iwl_eeprom_get_mac(const struct iwl_priv *priv, u8 *mac)
+{
+	const u8 *addr = iwl_eeprom_query_addr(priv,
+					EEPROM_MAC_ADDRESS);
+	memcpy(mac, addr, ETH_ALEN);
+}
+
+/******************************************************************************
+ *
+ * OTP related functions
+ *
+******************************************************************************/
+
 static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 {
 	iwl_read32(bus(priv), CSR_OTP_GP_REG);
@@ -407,11 +495,152 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 	return -EINVAL;
 }
 
-u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
+/******************************************************************************
+ *
+ * Tx Power related functions
+ *
+******************************************************************************/
+/**
+ * iwl_get_max_txpower_avg - get the highest tx power from all chains.
+ *     find the highest tx power from all chains for the channel
+ */
+static s8 iwl_get_max_txpower_avg(struct iwl_priv *priv,
+		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
+		int element, s8 *max_txpower_in_half_dbm)
 {
-	if (!priv->eeprom)
-		return 0;
-	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
+	s8 max_txpower_avg = 0; /* (dBm) */
+
+	/* Take the highest tx power from any valid chains */
+	if ((priv->cfg->valid_tx_ant & ANT_A) &&
+	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_a_max;
+	if ((priv->cfg->valid_tx_ant & ANT_B) &&
+	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_b_max;
+	if ((priv->cfg->valid_tx_ant & ANT_C) &&
+	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].chain_c_max;
+	if (((priv->cfg->valid_tx_ant == ANT_AB) |
+	    (priv->cfg->valid_tx_ant == ANT_BC) |
+	    (priv->cfg->valid_tx_ant == ANT_AC)) &&
+	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
+		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
+	if ((priv->cfg->valid_tx_ant == ANT_ABC) &&
+	    (enhanced_txpower[element].mimo3_max > max_txpower_avg))
+		max_txpower_avg = enhanced_txpower[element].mimo3_max;
+
+	/*
+	 * max. tx power in EEPROM is in 1/2 dBm format
+	 * convert from 1/2 dBm to dBm (round-up convert)
+	 * but we also do not want to loss 1/2 dBm resolution which
+	 * will impact performance
+	 */
+	*max_txpower_in_half_dbm = max_txpower_avg;
+	return (max_txpower_avg & 0x01) + (max_txpower_avg >> 1);
+}
+
+static void
+iwl_eeprom_enh_txp_read_element(struct iwl_priv *priv,
+				    struct iwl_eeprom_enhanced_txpwr *txp,
+				    s8 max_txpower_avg)
+{
+	int ch_idx;
+	bool is_ht40 = txp->flags & IWL_EEPROM_ENH_TXP_FL_40MHZ;
+	enum ieee80211_band band;
+
+	band = txp->flags & IWL_EEPROM_ENH_TXP_FL_BAND_52G ?
+		IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+
+	for (ch_idx = 0; ch_idx < priv->channel_count; ch_idx++) {
+		struct iwl_channel_info *ch_info = &priv->channel_info[ch_idx];
+
+		/* update matching channel or from common data only */
+		if (txp->channel != 0 && ch_info->channel != txp->channel)
+			continue;
+
+		/* update matching band only */
+		if (band != ch_info->band)
+			continue;
+
+		if (ch_info->max_power_avg < max_txpower_avg && !is_ht40) {
+			ch_info->max_power_avg = max_txpower_avg;
+			ch_info->curr_txpow = max_txpower_avg;
+			ch_info->scan_power = max_txpower_avg;
+		}
+
+		if (is_ht40 && ch_info->ht40_max_power_avg < max_txpower_avg)
+			ch_info->ht40_max_power_avg = max_txpower_avg;
+	}
+}
+
+#define EEPROM_TXP_OFFS	(0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT)
+#define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
+#define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
+
+#define TXP_CHECK_AND_PRINT(x) ((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) \
+			    ? # x " " : "")
+
+void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
+{
+	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
+	int idx, entries;
+	__le16 *txp_len;
+	s8 max_txp_avg, max_txp_avg_halfdbm;
+
+	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
+
+	/* the length is in 16-bit words, but we want entries */
+	txp_len = (__le16 *) iwl_eeprom_query_addr(priv, EEPROM_TXP_SZ_OFFS);
+	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
+
+	txp_array = (void *) iwl_eeprom_query_addr(priv, EEPROM_TXP_OFFS);
+
+	for (idx = 0; idx < entries; idx++) {
+		txp = &txp_array[idx];
+		/* skip invalid entries */
+		if (!(txp->flags & IWL_EEPROM_ENH_TXP_FL_VALID))
+			continue;
+
+		IWL_DEBUG_EEPROM(priv, "%s %d:\t %s%s%s%s%s%s%s%s (0x%02x)\n",
+				 (txp->channel && (txp->flags &
+					IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE)) ?
+					"Common " : (txp->channel) ?
+					"Channel" : "Common",
+				 (txp->channel),
+				 TXP_CHECK_AND_PRINT(VALID),
+				 TXP_CHECK_AND_PRINT(BAND_52G),
+				 TXP_CHECK_AND_PRINT(OFDM),
+				 TXP_CHECK_AND_PRINT(40MHZ),
+				 TXP_CHECK_AND_PRINT(HT_AP),
+				 TXP_CHECK_AND_PRINT(RES1),
+				 TXP_CHECK_AND_PRINT(RES2),
+				 TXP_CHECK_AND_PRINT(COMMON_TYPE),
+				 txp->flags);
+		IWL_DEBUG_EEPROM(priv, "\t\t chain_A: 0x%02x "
+				 "chain_B: 0X%02x chain_C: 0X%02x\n",
+				 txp->chain_a_max, txp->chain_b_max,
+				 txp->chain_c_max);
+		IWL_DEBUG_EEPROM(priv, "\t\t MIMO2: 0x%02x "
+				 "MIMO3: 0x%02x High 20_on_40: 0x%02x "
+				 "Low 20_on_40: 0x%02x\n",
+				 txp->mimo2_max, txp->mimo3_max,
+				 ((txp->delta_20_in_40 & 0xf0) >> 4),
+				 (txp->delta_20_in_40 & 0x0f));
+
+		max_txp_avg = iwl_get_max_txpower_avg(priv, txp_array, idx,
+						      &max_txp_avg_halfdbm);
+
+		/*
+		 * Update the user limit values values to the highest
+		 * power supported by any channel
+		 */
+		if (max_txp_avg > priv->tx_power_user_lmt)
+			priv->tx_power_user_lmt = max_txp_avg;
+		if (max_txp_avg_halfdbm > priv->tx_power_lmt_in_half_dbm)
+			priv->tx_power_lmt_in_half_dbm = max_txp_avg_halfdbm;
+
+		iwl_eeprom_enh_txp_read_element(priv, txp, max_txp_avg);
+	}
 }
 
 /**
-- 
1.7.0.4

