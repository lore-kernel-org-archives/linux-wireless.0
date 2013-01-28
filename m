Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3A1Jh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/37] iwlwifi: add NVM and PHY DB code for new MVM driver
Date: Mon, 28 Jan 2013 10:37:11 +0100
Message-Id: <1359365864-4259-5-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103738_373680_1FCCBF91)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new MVM (multi-virtual MAC) firmware driver
requires NVM (non-volatile memory) parsing code
and some PHY information database code. Add this
separately.

Change-Id: I98100a5376e007db5c2bb335cdaa23558b875adb
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile           |   1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  14 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |   9 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    | 346 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |  80 ++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.c       | 514 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h       |  82 ++++
 7 files changed, 1039 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 98cb8e8..2d4d47a 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -5,6 +5,7 @@ iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
 iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
+iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-objs		+= pcie/1000.o pcie/2000.o pcie/5000.o pcie/6000.o
 iwlwifi-objs		+= pcie/7000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 1ece4c0..034f2ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -703,9 +703,9 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	return n_channels;
 }
 
-static int iwl_init_sband_channels(struct iwl_nvm_data *data,
-				   struct ieee80211_supported_band *sband,
-				   int n_channels, enum ieee80211_band band)
+int iwl_init_sband_channels(struct iwl_nvm_data *data,
+			    struct ieee80211_supported_band *sband,
+			    int n_channels, enum ieee80211_band band)
 {
 	struct ieee80211_channel *chan = &data->channels[0];
 	int n = 0, idx = 0;
@@ -728,10 +728,10 @@ static int iwl_init_sband_channels(struct iwl_nvm_data *data,
 #define MAX_BIT_RATE_40_MHZ	150 /* Mbps */
 #define MAX_BIT_RATE_20_MHZ	72 /* Mbps */
 
-static void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
-				 struct iwl_nvm_data *data,
-				 struct ieee80211_sta_ht_cap *ht_info,
-				 enum ieee80211_band band)
+void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
+			  struct iwl_nvm_data *data,
+			  struct ieee80211_sta_ht_cap *ht_info,
+			  enum ieee80211_band band)
 {
 	int max_bit_rate = 0;
 	u8 rx_chains;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index 074cd07..683fe6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -126,4 +126,13 @@ static inline void iwl_free_nvm_data(struct iwl_nvm_data *data)
 int iwl_nvm_check_version(struct iwl_nvm_data *data,
 			  struct iwl_trans *trans);
 
+int iwl_init_sband_channels(struct iwl_nvm_data *data,
+			    struct ieee80211_supported_band *sband,
+			    int n_channels, enum ieee80211_band band);
+
+void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
+			  struct iwl_nvm_data *data,
+			  struct ieee80211_sta_ht_cap *ht_info,
+			  enum ieee80211_band band);
+
 #endif /* __iwl_eeprom_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
new file mode 100644
index 0000000..a70213b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -0,0 +1,346 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/export.h>
+#include "iwl-modparams.h"
+#include "iwl-nvm-parse.h"
+
+/* NVM offsets (in words) definitions */
+enum wkp_nvm_offsets {
+	/* NVM HW-Section offset (in words) definitions */
+	HW_ADDR = 0x15,
+
+/* NVM SW-Section offset (in words) definitions */
+	NVM_SW_SECTION = 0x1C0,
+	NVM_VERSION = 0,
+	RADIO_CFG = 1,
+	SKU = 2,
+	N_HW_ADDRS = 3,
+	NVM_CHANNELS = 0x1E0 - NVM_SW_SECTION,
+
+/* NVM calibration section offset (in words) definitions */
+	NVM_CALIB_SECTION = 0x2B8,
+	XTAL_CALIB = 0x316 - NVM_CALIB_SECTION
+};
+
+/* SKU Capabilities (actual values from NVM definition) */
+enum nvm_sku_bits {
+	NVM_SKU_CAP_BAND_24GHZ	= BIT(0),
+	NVM_SKU_CAP_BAND_52GHZ	= BIT(1),
+	NVM_SKU_CAP_11N_ENABLE	= BIT(2),
+};
+
+/* radio config bits (actual values from NVM definition) */
+#define NVM_RF_CFG_DASH_MSK(x)   (x & 0x3)         /* bits 0-1   */
+#define NVM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
+#define NVM_RF_CFG_TYPE_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
+#define NVM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
+#define NVM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
+#define NVM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
+
+/*
+ * These are the channel numbers in the order that they are stored in the NVM
+ */
+static const u8 iwl_nvm_channels[] = {
+	/* 2.4 GHz */
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
+	/* 5 GHz */
+	36, 40, 44 , 48, 52, 56, 60, 64,
+	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
+	149, 153, 157, 161, 165
+};
+
+#define IWL_NUM_CHANNELS	ARRAY_SIZE(iwl_nvm_channels)
+#define NUM_2GHZ_CHANNELS	14
+#define FIRST_2GHZ_HT_MINUS	5
+#define LAST_2GHZ_HT_PLUS	9
+#define LAST_5GHZ_HT		161
+
+
+/* rate data (static) */
+static struct ieee80211_rate iwl_cfg80211_rates[] = {
+	{ .bitrate = 1 * 10, .hw_value = 0, .hw_value_short = 0, },
+	{ .bitrate = 2 * 10, .hw_value = 1, .hw_value_short = 1,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE, },
+	{ .bitrate = 5.5 * 10, .hw_value = 2, .hw_value_short = 2,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE, },
+	{ .bitrate = 11 * 10, .hw_value = 3, .hw_value_short = 3,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE, },
+	{ .bitrate = 6 * 10, .hw_value = 4, .hw_value_short = 4, },
+	{ .bitrate = 9 * 10, .hw_value = 5, .hw_value_short = 5, },
+	{ .bitrate = 12 * 10, .hw_value = 6, .hw_value_short = 6, },
+	{ .bitrate = 18 * 10, .hw_value = 7, .hw_value_short = 7, },
+	{ .bitrate = 24 * 10, .hw_value = 8, .hw_value_short = 8, },
+	{ .bitrate = 36 * 10, .hw_value = 9, .hw_value_short = 9, },
+	{ .bitrate = 48 * 10, .hw_value = 10, .hw_value_short = 10, },
+	{ .bitrate = 54 * 10, .hw_value = 11, .hw_value_short = 11, },
+};
+#define RATES_24_OFFS	0
+#define N_RATES_24	ARRAY_SIZE(iwl_cfg80211_rates)
+#define RATES_52_OFFS	4
+#define N_RATES_52	(N_RATES_24 - RATES_52_OFFS)
+
+/**
+ * enum iwl_nvm_channel_flags - channel flags in NVM
+ * @NVM_CHANNEL_VALID: channel is usable for this SKU/geo
+ * @NVM_CHANNEL_IBSS: usable as an IBSS channel
+ * @NVM_CHANNEL_ACTIVE: active scanning allowed
+ * @NVM_CHANNEL_RADAR: radar detection required
+ * @NVM_CHANNEL_DFS: dynamic freq selection candidate
+ * @NVM_CHANNEL_WIDE: 20 MHz channel okay (?)
+ * @NVM_CHANNEL_40MHZ: 40 MHz channel okay (?)
+ */
+enum iwl_nvm_channel_flags {
+	NVM_CHANNEL_VALID = BIT(0),
+	NVM_CHANNEL_IBSS = BIT(1),
+	NVM_CHANNEL_ACTIVE = BIT(3),
+	NVM_CHANNEL_RADAR = BIT(4),
+	NVM_CHANNEL_DFS = BIT(7),
+	NVM_CHANNEL_WIDE = BIT(8),
+	NVM_CHANNEL_40MHZ = BIT(9),
+};
+
+#define CHECK_AND_PRINT_I(x)	\
+	((ch_flags & NVM_CHANNEL_##x) ? # x " " : "")
+
+static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
+				struct iwl_nvm_data *data,
+				const __le16 * const nvm_ch_flags)
+{
+	int ch_idx;
+	int n_channels = 0;
+	struct ieee80211_channel *channel;
+	u16 ch_flags;
+	bool is_5ghz;
+
+	for (ch_idx = 0; ch_idx < IWL_NUM_CHANNELS; ch_idx++) {
+		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
+		if (!(ch_flags & NVM_CHANNEL_VALID)) {
+			IWL_DEBUG_EEPROM(dev,
+					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
+					 iwl_nvm_channels[ch_idx],
+					 ch_flags,
+					 (ch_idx >= NUM_2GHZ_CHANNELS) ?
+					 "5.2" : "2.4");
+			continue;
+		}
+
+		channel = &data->channels[n_channels];
+		n_channels++;
+
+		channel->hw_value = iwl_nvm_channels[ch_idx];
+		channel->band = (ch_idx < NUM_2GHZ_CHANNELS) ?
+				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+		channel->center_freq =
+			ieee80211_channel_to_frequency(
+				channel->hw_value, channel->band);
+
+		/* TODO: Need to be dependent to the NVM */
+		channel->flags = IEEE80211_CHAN_NO_HT40;
+		if (ch_idx < NUM_2GHZ_CHANNELS &&
+		    (ch_flags & NVM_CHANNEL_40MHZ)) {
+			if (iwl_nvm_channels[ch_idx] <= LAST_2GHZ_HT_PLUS)
+				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
+			if (iwl_nvm_channels[ch_idx] >= FIRST_2GHZ_HT_MINUS)
+				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
+		} else if (iwl_nvm_channels[ch_idx] <= LAST_5GHZ_HT &&
+			   (ch_flags & NVM_CHANNEL_40MHZ)) {
+			if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
+				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
+			else
+				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
+		}
+
+		if (!(ch_flags & NVM_CHANNEL_IBSS))
+			channel->flags |= IEEE80211_CHAN_NO_IBSS;
+
+		if (!(ch_flags & NVM_CHANNEL_ACTIVE))
+			channel->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
+		if (ch_flags & NVM_CHANNEL_RADAR)
+			channel->flags |= IEEE80211_CHAN_RADAR;
+
+		/* Initialize regulatory-based run-time data */
+
+		/* TODO: read the real value from the NVM */
+		channel->max_power = 0;
+		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
+		IWL_DEBUG_EEPROM(dev,
+				 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
+				 channel->hw_value,
+				 is_5ghz ? "5.2" : "2.4",
+				 CHECK_AND_PRINT_I(VALID),
+				 CHECK_AND_PRINT_I(IBSS),
+				 CHECK_AND_PRINT_I(ACTIVE),
+				 CHECK_AND_PRINT_I(RADAR),
+				 CHECK_AND_PRINT_I(WIDE),
+				 CHECK_AND_PRINT_I(DFS),
+				 ch_flags,
+				 channel->max_power,
+				 ((ch_flags & NVM_CHANNEL_IBSS) &&
+				  !(ch_flags & NVM_CHANNEL_RADAR))
+					? "" : "not ");
+	}
+
+	return n_channels;
+}
+
+static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
+			    struct iwl_nvm_data *data, const __le16 *nvm_sw)
+{
+	int n_channels = iwl_init_channel_map(dev, cfg, data,
+			&nvm_sw[NVM_CHANNELS]);
+	int n_used = 0;
+	struct ieee80211_supported_band *sband;
+
+	sband = &data->bands[IEEE80211_BAND_2GHZ];
+	sband->band = IEEE80211_BAND_2GHZ;
+	sband->bitrates = &iwl_cfg80211_rates[RATES_24_OFFS];
+	sband->n_bitrates = N_RATES_24;
+	n_used += iwl_init_sband_channels(data, sband, n_channels,
+					  IEEE80211_BAND_2GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_2GHZ);
+
+	sband = &data->bands[IEEE80211_BAND_5GHZ];
+	sband->band = IEEE80211_BAND_5GHZ;
+	sband->bitrates = &iwl_cfg80211_rates[RATES_52_OFFS];
+	sband->n_bitrates = N_RATES_52;
+	n_used += iwl_init_sband_channels(data, sband, n_channels,
+					  IEEE80211_BAND_5GHZ);
+	iwl_init_ht_hw_capab(cfg, data, &sband->ht_cap, IEEE80211_BAND_5GHZ);
+
+	if (n_channels != n_used)
+		IWL_ERR_DEV(dev, "NVM: used only %d of %d channels\n",
+			    n_used, n_channels);
+}
+
+struct iwl_nvm_data *
+iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
+		   const __le16 *nvm_hw, const __le16 *nvm_sw,
+		   const __le16 *nvm_calib)
+{
+	struct iwl_nvm_data *data;
+	u8 hw_addr[ETH_ALEN];
+	u16 radio_cfg, sku;
+
+	data = kzalloc(sizeof(*data) +
+		       sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
+		       GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->nvm_version = le16_to_cpup(nvm_sw + NVM_VERSION);
+
+	radio_cfg = le16_to_cpup(nvm_sw + RADIO_CFG);
+	data->radio_cfg_type = NVM_RF_CFG_TYPE_MSK(radio_cfg);
+	data->radio_cfg_step = NVM_RF_CFG_STEP_MSK(radio_cfg);
+	data->radio_cfg_dash = NVM_RF_CFG_DASH_MSK(radio_cfg);
+	data->radio_cfg_pnum = NVM_RF_CFG_PNUM_MSK(radio_cfg);
+	data->valid_tx_ant = NVM_RF_CFG_TX_ANT_MSK(radio_cfg);
+	data->valid_rx_ant = NVM_RF_CFG_RX_ANT_MSK(radio_cfg);
+
+	sku = le16_to_cpup(nvm_sw + SKU);
+	data->sku_cap_band_24GHz_enable = sku & NVM_SKU_CAP_BAND_24GHZ;
+	data->sku_cap_band_52GHz_enable = sku & NVM_SKU_CAP_BAND_52GHZ;
+	data->sku_cap_11n_enable = sku & NVM_SKU_CAP_11N_ENABLE;
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
+		data->sku_cap_11n_enable = false;
+
+	/* check overrides (some devices have wrong NVM) */
+	if (cfg->valid_tx_ant)
+		data->valid_tx_ant = cfg->valid_tx_ant;
+	if (cfg->valid_rx_ant)
+		data->valid_rx_ant = cfg->valid_rx_ant;
+
+	if (!data->valid_tx_ant || !data->valid_rx_ant) {
+		IWL_ERR_DEV(dev, "invalid antennas (0x%x, 0x%x)\n",
+			    data->valid_tx_ant, data->valid_rx_ant);
+		kfree(data);
+		return NULL;
+	}
+
+	data->n_hw_addrs = le16_to_cpup(nvm_sw + N_HW_ADDRS);
+
+	data->xtal_calib[0] = *(nvm_calib + XTAL_CALIB);
+	data->xtal_calib[1] = *(nvm_calib + XTAL_CALIB + 1);
+
+	/* The byte order is little endian 16 bit, meaning 214365 */
+	memcpy(hw_addr, nvm_hw + HW_ADDR, ETH_ALEN);
+	data->hw_addr[0] = hw_addr[1];
+	data->hw_addr[1] = hw_addr[0];
+	data->hw_addr[2] = hw_addr[3];
+	data->hw_addr[3] = hw_addr[2];
+	data->hw_addr[4] = hw_addr[5];
+	data->hw_addr[5] = hw_addr[4];
+
+	iwl_init_sbands(dev, cfg, data, nvm_sw);
+
+	data->calib_version = 255;   /* TODO:
+					this value will prevent some checks from
+					failing, we need to check if this
+					field is still needed, and if it does,
+					where is it in the NVM*/
+
+	return data;
+}
+EXPORT_SYMBOL_GPL(iwl_parse_nvm_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
new file mode 100644
index 0000000..b2692bd
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -0,0 +1,80 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+#ifndef __iwl_nvm_parse_h__
+#define __iwl_nvm_parse_h__
+
+#include "iwl-eeprom-parse.h"
+
+/**
+ * iwl_parse_nvm_data - parse NVM data and return values
+ *
+ * This function parses all NVM values we need and then
+ * returns a (newly allocated) struct containing all the
+ * relevant values for driver use. The struct must be freed
+ * later with iwl_free_nvm_data().
+ */
+struct iwl_nvm_data *
+iwl_parse_nvm_data(struct device *dev, const struct iwl_cfg *cfg,
+		   const __le16 *nvm_hw, const __le16 *nvm_sw,
+		   const __le16 *nvm_calib);
+
+#endif /* __iwl_nvm_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
new file mode 100644
index 0000000..14fc8d3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -0,0 +1,514 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/export.h>
+
+#include "iwl-phy-db.h"
+#include "iwl-debug.h"
+#include "iwl-op-mode.h"
+#include "iwl-trans.h"
+
+#define CHANNEL_NUM_SIZE	4	/* num of channels in calib_ch size */
+#define IWL_NUM_PAPD_CH_GROUPS	4
+#define IWL_NUM_TXP_CH_GROUPS	9
+
+struct iwl_phy_db_entry {
+	u16	size;
+	u8	*data;
+};
+
+/**
+ * struct iwl_phy_db - stores phy configuration and calibration data.
+ *
+ * @cfg: phy configuration.
+ * @calib_nch: non channel specific calibration data.
+ * @calib_ch: channel specific calibration data.
+ * @calib_ch_group_papd: calibration data related to papd channel group.
+ * @calib_ch_group_txp: calibration data related to tx power chanel group.
+ */
+struct iwl_phy_db {
+	struct iwl_phy_db_entry	cfg;
+	struct iwl_phy_db_entry	calib_nch;
+	struct iwl_phy_db_entry	calib_ch;
+	struct iwl_phy_db_entry	calib_ch_group_papd[IWL_NUM_PAPD_CH_GROUPS];
+	struct iwl_phy_db_entry	calib_ch_group_txp[IWL_NUM_TXP_CH_GROUPS];
+
+	u32 channel_num;
+	u32 channel_size;
+
+	struct iwl_trans *trans;
+};
+
+enum iwl_phy_db_section_type {
+	IWL_PHY_DB_CFG = 1,
+	IWL_PHY_DB_CALIB_NCH,
+	IWL_PHY_DB_CALIB_CH,
+	IWL_PHY_DB_CALIB_CHG_PAPD,
+	IWL_PHY_DB_CALIB_CHG_TXP,
+	IWL_PHY_DB_MAX
+};
+
+#define PHY_DB_CMD 0x6c /* TEMP API - The actual is 0x8c */
+
+/*
+ * phy db - configure operational ucode
+ */
+struct iwl_phy_db_cmd {
+	__le16 type;
+	__le16 length;
+	u8 data[];
+} __packed;
+
+/* for parsing of tx power channel group data that comes from the firmware*/
+struct iwl_phy_db_chg_txp {
+	__le32 space;
+	__le16 max_channel_idx;
+} __packed;
+
+/*
+ * phy db - Receieve phy db chunk after calibrations
+ */
+struct iwl_calib_res_notif_phy_db {
+	__le16 type;
+	__le16 length;
+	u8 data[];
+} __packed;
+
+#define IWL_PHY_DB_STATIC_PIC cpu_to_le32(0x21436587)
+static inline void iwl_phy_db_test_pic(__le32 pic)
+{
+	WARN_ON(IWL_PHY_DB_STATIC_PIC != pic);
+}
+
+struct iwl_phy_db *iwl_phy_db_init(struct iwl_trans *trans)
+{
+	struct iwl_phy_db *phy_db = kzalloc(sizeof(struct iwl_phy_db),
+					    GFP_KERNEL);
+
+	if (!phy_db)
+		return phy_db;
+
+	phy_db->trans = trans;
+
+	/* TODO: add default values of the phy db. */
+	return phy_db;
+}
+EXPORT_SYMBOL(iwl_phy_db_init);
+
+/*
+ * get phy db section: returns a pointer to a phy db section specified by
+ * type and channel group id.
+ */
+static struct iwl_phy_db_entry *
+iwl_phy_db_get_section(struct iwl_phy_db *phy_db,
+		       enum iwl_phy_db_section_type type,
+		       u16 chg_id)
+{
+	if (!phy_db || type >= IWL_PHY_DB_MAX)
+		return NULL;
+
+	switch (type) {
+	case IWL_PHY_DB_CFG:
+		return &phy_db->cfg;
+	case IWL_PHY_DB_CALIB_NCH:
+		return &phy_db->calib_nch;
+	case IWL_PHY_DB_CALIB_CH:
+		return &phy_db->calib_ch;
+	case IWL_PHY_DB_CALIB_CHG_PAPD:
+		if (chg_id >= IWL_NUM_PAPD_CH_GROUPS)
+			return NULL;
+		return &phy_db->calib_ch_group_papd[chg_id];
+	case IWL_PHY_DB_CALIB_CHG_TXP:
+		if (chg_id >= IWL_NUM_TXP_CH_GROUPS)
+			return NULL;
+		return &phy_db->calib_ch_group_txp[chg_id];
+	default:
+		return NULL;
+	}
+	return NULL;
+}
+
+static void iwl_phy_db_free_section(struct iwl_phy_db *phy_db,
+				    enum iwl_phy_db_section_type type,
+				    u16 chg_id)
+{
+	struct iwl_phy_db_entry *entry =
+				iwl_phy_db_get_section(phy_db, type, chg_id);
+	if (!entry)
+		return;
+
+	kfree(entry->data);
+	entry->data = NULL;
+	entry->size = 0;
+}
+
+void iwl_phy_db_free(struct iwl_phy_db *phy_db)
+{
+	int i;
+
+	if (!phy_db)
+		return;
+
+	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CFG, 0);
+	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_NCH, 0);
+	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CH, 0);
+	for (i = 0; i < IWL_NUM_PAPD_CH_GROUPS; i++)
+		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_PAPD, i);
+	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++)
+		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_TXP, i);
+
+	kfree(phy_db);
+}
+EXPORT_SYMBOL(iwl_phy_db_free);
+
+int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
+			   gfp_t alloc_ctx)
+{
+	struct iwl_calib_res_notif_phy_db *phy_db_notif =
+			(struct iwl_calib_res_notif_phy_db *)pkt->data;
+	enum iwl_phy_db_section_type type = le16_to_cpu(phy_db_notif->type);
+	u16 size  = le16_to_cpu(phy_db_notif->length);
+	struct iwl_phy_db_entry *entry;
+	u16 chg_id = 0;
+
+	if (!phy_db)
+		return -EINVAL;
+
+	if (type == IWL_PHY_DB_CALIB_CHG_PAPD ||
+	    type == IWL_PHY_DB_CALIB_CHG_TXP)
+		chg_id = le16_to_cpup((__le16 *)phy_db_notif->data);
+
+	entry = iwl_phy_db_get_section(phy_db, type, chg_id);
+	if (!entry)
+		return -EINVAL;
+
+	kfree(entry->data);
+	entry->data = kmemdup(phy_db_notif->data, size, alloc_ctx);
+	if (!entry->data) {
+		entry->size = 0;
+		return -ENOMEM;
+	}
+
+	entry->size = size;
+
+	if (type == IWL_PHY_DB_CALIB_CH) {
+		phy_db->channel_num =
+			le32_to_cpup((__le32 *)phy_db_notif->data);
+		phy_db->channel_size =
+			(size - CHANNEL_NUM_SIZE) / phy_db->channel_num;
+	}
+
+	/* Test PIC */
+	if (type != IWL_PHY_DB_CFG)
+		iwl_phy_db_test_pic(*(((__le32 *)phy_db_notif->data) +
+				      (size / sizeof(__le32)) - 1));
+
+	IWL_DEBUG_INFO(phy_db->trans,
+		       "%s(%d): [PHYDB]SET: Type %d , Size: %d\n",
+		       __func__, __LINE__, type, size);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_phy_db_set_section);
+
+static int is_valid_channel(u16 ch_id)
+{
+	if (ch_id <= 14 ||
+	    (36 <= ch_id && ch_id <= 64 && ch_id % 4 == 0) ||
+	    (100 <= ch_id && ch_id <= 140 && ch_id % 4 == 0) ||
+	    (145 <= ch_id && ch_id <= 165 && ch_id % 4 == 1))
+		return 1;
+	return 0;
+}
+
+static u8 ch_id_to_ch_index(u16 ch_id)
+{
+	if (WARN_ON(!is_valid_channel(ch_id)))
+		return 0xff;
+
+	if (ch_id <= 14)
+		return ch_id - 1;
+	if (ch_id <= 64)
+		return (ch_id + 20) / 4;
+	if (ch_id <= 140)
+		return (ch_id - 12) / 4;
+	return (ch_id - 13) / 4;
+}
+
+
+static u16 channel_id_to_papd(u16 ch_id)
+{
+	if (WARN_ON(!is_valid_channel(ch_id)))
+		return 0xff;
+
+	if (1 <= ch_id && ch_id <= 14)
+		return 0;
+	if (36 <= ch_id && ch_id <= 64)
+		return 1;
+	if (100 <= ch_id && ch_id <= 140)
+		return 2;
+	return 3;
+}
+
+static u16 channel_id_to_txp(struct iwl_phy_db *phy_db, u16 ch_id)
+{
+	struct iwl_phy_db_chg_txp *txp_chg;
+	int i;
+	u8 ch_index = ch_id_to_ch_index(ch_id);
+	if (ch_index == 0xff)
+		return 0xff;
+
+	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++) {
+		txp_chg = (void *)phy_db->calib_ch_group_txp[i].data;
+		if (!txp_chg)
+			return 0xff;
+		/*
+		 * Looking for the first channel group that its max channel is
+		 * higher then wanted channel.
+		 */
+		if (le16_to_cpu(txp_chg->max_channel_idx) >= ch_index)
+			return i;
+	}
+	return 0xff;
+}
+static
+int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
+				u32 type, u8 **data, u16 *size, u16 ch_id)
+{
+	struct iwl_phy_db_entry *entry;
+	u32 channel_num;
+	u32 channel_size;
+	u16 ch_group_id = 0;
+	u16 index;
+
+	if (!phy_db)
+		return -EINVAL;
+
+	/* find wanted channel group */
+	if (type == IWL_PHY_DB_CALIB_CHG_PAPD)
+		ch_group_id = channel_id_to_papd(ch_id);
+	else if (type == IWL_PHY_DB_CALIB_CHG_TXP)
+		ch_group_id = channel_id_to_txp(phy_db, ch_id);
+
+	entry = iwl_phy_db_get_section(phy_db, type, ch_group_id);
+	if (!entry)
+		return -EINVAL;
+
+	if (type == IWL_PHY_DB_CALIB_CH) {
+		index = ch_id_to_ch_index(ch_id);
+		channel_num = phy_db->channel_num;
+		channel_size = phy_db->channel_size;
+		if (index >= channel_num) {
+			IWL_ERR(phy_db->trans, "Wrong channel number %d\n",
+				ch_id);
+			return -EINVAL;
+		}
+		*data = entry->data + CHANNEL_NUM_SIZE + index * channel_size;
+		*size = channel_size;
+	} else {
+		*data = entry->data;
+		*size = entry->size;
+	}
+
+	/* Test PIC */
+	if (type != IWL_PHY_DB_CFG)
+		iwl_phy_db_test_pic(*(((__le32 *)*data) +
+				      (*size / sizeof(__le32)) - 1));
+
+	IWL_DEBUG_INFO(phy_db->trans,
+		       "%s(%d): [PHYDB] GET: Type %d , Size: %d\n",
+		       __func__, __LINE__, type, *size);
+
+	return 0;
+}
+
+static int iwl_send_phy_db_cmd(struct iwl_phy_db *phy_db, u16 type,
+			       u16 length, void *data)
+{
+	struct iwl_phy_db_cmd phy_db_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = PHY_DB_CMD,
+		.flags = CMD_SYNC,
+	};
+
+	IWL_DEBUG_INFO(phy_db->trans,
+		       "Sending PHY-DB hcmd of type %d, of length %d\n",
+		       type, length);
+
+	/* Set phy db cmd variables */
+	phy_db_cmd.type = cpu_to_le16(type);
+	phy_db_cmd.length = cpu_to_le16(length);
+
+	/* Set hcmd variables */
+	cmd.data[0] = &phy_db_cmd;
+	cmd.len[0] = sizeof(struct iwl_phy_db_cmd);
+	cmd.data[1] = data;
+	cmd.len[1] = length;
+	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
+
+	return iwl_trans_send_cmd(phy_db->trans, &cmd);
+}
+
+static int iwl_phy_db_send_all_channel_groups(
+					struct iwl_phy_db *phy_db,
+					enum iwl_phy_db_section_type type,
+					u8 max_ch_groups)
+{
+	u16 i;
+	int err;
+	struct iwl_phy_db_entry *entry;
+
+	/* Send all the  channel specific groups to operational fw */
+	for (i = 0; i < max_ch_groups; i++) {
+		entry = iwl_phy_db_get_section(phy_db,
+					       type,
+					       i);
+		if (!entry)
+			return -EINVAL;
+
+		/* Send the requested PHY DB section */
+		err = iwl_send_phy_db_cmd(phy_db,
+					  type,
+					  entry->size,
+					  entry->data);
+		if (err) {
+			IWL_ERR(phy_db->trans,
+				"Can't SEND phy_db section %d (%d), err %d",
+				type, i, err);
+			return err;
+		}
+
+		IWL_DEBUG_INFO(phy_db->trans,
+			       "Sent PHY_DB HCMD, type = %d num = %d",
+			       type, i);
+	}
+
+	return 0;
+}
+
+int iwl_send_phy_db_data(struct iwl_phy_db *phy_db)
+{
+	u8 *data = NULL;
+	u16 size = 0;
+	int err;
+
+	IWL_DEBUG_INFO(phy_db->trans,
+		       "Sending phy db data and configuration to runtime image\n");
+
+	/* Send PHY DB CFG section */
+	err = iwl_phy_db_get_section_data(phy_db, IWL_PHY_DB_CFG,
+					  &data, &size, 0);
+	if (err) {
+		IWL_ERR(phy_db->trans, "Cannot get Phy DB cfg section\n");
+		return err;
+	}
+
+	err = iwl_send_phy_db_cmd(phy_db, IWL_PHY_DB_CFG, size, data);
+	if (err) {
+		IWL_ERR(phy_db->trans,
+			"Cannot send HCMD of  Phy DB cfg section\n");
+		return err;
+	}
+
+	err = iwl_phy_db_get_section_data(phy_db, IWL_PHY_DB_CALIB_NCH,
+					  &data, &size, 0);
+	if (err) {
+		IWL_ERR(phy_db->trans,
+			"Cannot get Phy DB non specific channel section\n");
+		return err;
+	}
+
+	err = iwl_send_phy_db_cmd(phy_db, IWL_PHY_DB_CALIB_NCH, size, data);
+	if (err) {
+		IWL_ERR(phy_db->trans,
+			"Cannot send HCMD of Phy DB non specific channel section\n");
+		return err;
+	}
+
+	/* Send all the TXP channel specific data */
+	err = iwl_phy_db_send_all_channel_groups(phy_db,
+						 IWL_PHY_DB_CALIB_CHG_PAPD,
+						 IWL_NUM_PAPD_CH_GROUPS);
+	if (err) {
+		IWL_ERR(phy_db->trans,
+			"Cannot send channel specific PAPD groups");
+		return err;
+	}
+
+	/* Send all the TXP channel specific data */
+	err = iwl_phy_db_send_all_channel_groups(phy_db,
+						 IWL_PHY_DB_CALIB_CHG_TXP,
+						 IWL_NUM_TXP_CH_GROUPS);
+	if (err) {
+		IWL_ERR(phy_db->trans,
+			"Cannot send channel specific TX power groups");
+		return err;
+	}
+
+	IWL_DEBUG_INFO(phy_db->trans,
+		       "Finished sending phy db non channel data\n");
+	return 0;
+}
+EXPORT_SYMBOL(iwl_send_phy_db_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
new file mode 100644
index 0000000..d0e43d9
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
@@ -0,0 +1,82 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#ifndef __IWL_PHYDB_H__
+#define __IWL_PHYDB_H__
+
+#include <linux/types.h>
+
+#include "iwl-op-mode.h"
+#include "iwl-trans.h"
+
+struct iwl_phy_db *iwl_phy_db_init(struct iwl_trans *trans);
+
+void iwl_phy_db_free(struct iwl_phy_db *phy_db);
+
+int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
+			   gfp_t alloc_ctx);
+
+
+int iwl_send_phy_db_data(struct iwl_phy_db *phy_db);
+
+#endif /* __IWL_PHYDB_H__ */
-- 
1.8.0

