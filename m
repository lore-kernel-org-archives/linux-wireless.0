Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2FFNXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 25/29] iwlwifi: refactor EEPROM reading/parsing
Date: Wed,  6 Jun 2012 15:22:06 +0200
Message-Id: <1338988930-11561-25-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152401_458277_1671B4DF)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The EEPROM reading/parsing code is all mixed in
the driver today, and the EEPROM is parsed only
when we access data from it. This is problematic
because the NVM needs to be parsed and that is
independent of reading it. Also, the NVM format
for new devices will be different and probably
require a new parser.

Therefore refactor the reading and parsing and
create two independent components. Reading the
EEPROM requires direct hardware accesses and
therefore access to the transport, but parsing
is independent and can be done on an NVM blob.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile           |    1 +
 drivers/net/wireless/iwlwifi/dvm/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h          |    5 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c        |   17 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      |   23 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h          |  128 +--
 drivers/net/wireless/iwlwifi/dvm/devices.c      |  128 +--
 drivers/net/wireless/iwlwifi/dvm/eeprom.c       | 1163 -----------------------
 drivers/net/wireless/iwlwifi/dvm/eeprom.h       |  269 ------
 drivers/net/wireless/iwlwifi/dvm/lib.c          |    8 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |    9 +-
 drivers/net/wireless/iwlwifi/dvm/main.c         |  301 ++----
 drivers/net/wireless/iwlwifi/dvm/power.c        |    1 -
 drivers/net/wireless/iwlwifi/dvm/rs.c           |   44 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c           |    1 -
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |    4 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c         |   10 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c          |   30 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c     |   10 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c           |    1 -
 drivers/net/wireless/iwlwifi/dvm/tx.c           |   10 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c        |   25 +-
 drivers/net/wireless/iwlwifi/iwl-config.h       |   19 +
 drivers/net/wireless/iwlwifi/iwl-debug.h        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  900 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |  138 +++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c  |  463 +++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h  |   70 ++
 drivers/net/wireless/iwlwifi/pcie/1000.c        |   14 +
 drivers/net/wireless/iwlwifi/pcie/2000.c        |   17 +
 drivers/net/wireless/iwlwifi/pcie/5000.c        |   15 +
 drivers/net/wireless/iwlwifi/pcie/6000.c        |   19 +
 32 files changed, 1854 insertions(+), 1996 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/dvm/eeprom.c
 delete mode 100644 drivers/net/wireless/iwlwifi/dvm/eeprom.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 7ba6b8d..98c8f64 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -8,6 +8,7 @@ iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
 iwlwifi-objs		+= iwl-notif-wait.o
+iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-objs		+= pcie/1000.o pcie/2000.o pcie/5000.o pcie/6000.o
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/Makefile b/drivers/net/wireless/iwlwifi/dvm/Makefile
index 13f8282..5ff76b2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/dvm/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_IWLDVM)	+= iwldvm.o
 iwldvm-objs		+= main.o rs.o mac80211.o ucode.o tx.o
 iwldvm-objs		+= lib.o calib.o tt.o sta.o rx.o
 
-iwldvm-objs		+= eeprom.o power.o
+iwldvm-objs		+= power.o
 iwldvm-objs		+= scan.o led.o
 iwldvm-objs		+= rxon.o devices.o
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 9a8dd1a..2ae3608 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -92,7 +92,6 @@ extern struct iwl_lib_ops iwl6030_lib;
 #define STATUS_CT_KILL		1
 #define STATUS_ALIVE		2
 #define STATUS_READY		3
-#define STATUS_GEO_CONFIGURED	4
 #define STATUS_EXIT_PENDING	5
 #define STATUS_STATISTICS	6
 #define STATUS_SCANNING		7
@@ -443,10 +442,8 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
 {
-	/* The adapter is 'ready' if READY and GEO_CONFIGURED bits are
-	 * set but EXIT_PENDING is not */
+	/* The adapter is 'ready' if READY EXIT_PENDING is not set */
 	return test_bit(STATUS_READY, &priv->status) &&
-	       test_bit(STATUS_GEO_CONFIGURED, &priv->status) &&
 	       !test_bit(STATUS_EXIT_PENDING, &priv->status);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index 7eb3fa3..f2dd671 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -833,14 +833,14 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	active_chains &= priv->hw_params.valid_rx_ant;
+	active_chains &= priv->eeprom_data->valid_rx_ant;
 
 	num_tx_chains = 0;
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		/* loops on all the bits of
 		 * priv->hw_setting.valid_tx_ant */
 		u8 ant_msk = (1 << i);
-		if (!(priv->hw_params.valid_tx_ant & ant_msk))
+		if (!(priv->eeprom_data->valid_tx_ant & ant_msk))
 			continue;
 
 		num_tx_chains++;
@@ -854,7 +854,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 			 * connect the first valid tx chain
 			 */
 			first_chain =
-				find_first_chain(priv->hw_params.valid_tx_ant);
+				find_first_chain(priv->eeprom_data->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
 			IWL_DEBUG_CALIB(priv,
@@ -864,13 +864,13 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 		}
 	}
 
-	if (active_chains != priv->hw_params.valid_rx_ant &&
+	if (active_chains != priv->eeprom_data->valid_rx_ant &&
 	    active_chains != priv->chain_noise_data.active_chains)
 		IWL_DEBUG_CALIB(priv,
 				"Detected that not all antennas are connected! "
 				"Connected: %#x, valid: %#x.\n",
 				active_chains,
-				priv->hw_params.valid_rx_ant);
+				priv->eeprom_data->valid_rx_ant);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
 	data->active_chains = active_chains;
@@ -1055,7 +1055,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Disable disconnected antenna algorithm for advanced
 		   bt coex, assuming valid antennas are connected */
-		data->active_chains = priv->hw_params.valid_rx_ant;
+		data->active_chains = priv->eeprom_data->valid_rx_ant;
 		for (i = 0; i < NUM_RX_CHAINS; i++)
 			if (!(data->active_chains & (1<<i)))
 				data->disconn_array[i] = 1;
@@ -1084,8 +1084,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "min_average_noise = %d, antenna %d\n",
 			min_average_noise, min_average_noise_antenna_i);
 
-	iwlagn_gain_computation(priv, average_noise,
-				find_first_chain(priv->hw_params.valid_rx_ant));
+	iwlagn_gain_computation(
+		priv, average_noise,
+		find_first_chain(priv->eeprom_data->valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 2268add..8a2d9e6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -303,13 +303,13 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	const u8 *ptr;
 	char *buf;
 	u16 eeprom_ver;
-	size_t eeprom_len = priv->cfg->base_params->eeprom_size;
+	size_t eeprom_len = priv->eeprom_blob_size;
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16)
 		return -ENODATA;
 
-	ptr = priv->eeprom;
+	ptr = priv->eeprom_blob;
 	if (!ptr)
 		return -ENOMEM;
 
@@ -318,11 +318,9 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
-			"version: 0x%x\n",
-			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-			 ? "OTP" : "EEPROM", eeprom_ver);
+	eeprom_ver = priv->eeprom_data->eeprom_version;
+	pos += scnprintf(buf + pos, buf_size - pos,
+			 "NVM version: 0x%x\n", eeprom_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
 		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
@@ -347,9 +345,6 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 	char *buf;
 	ssize_t ret;
 
-	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
-		return -EAGAIN;
-
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -422,8 +417,6 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 		test_bit(STATUS_ALIVE, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_READY:\t\t %d\n",
 		test_bit(STATUS_READY, &priv->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_GEO_CONFIGURED:\t %d\n",
-		test_bit(STATUS_GEO_CONFIGURED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
 		test_bit(STATUS_EXIT_PENDING, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
@@ -1337,17 +1330,17 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 	if (tx->tx_power.ant_a || tx->tx_power.ant_b || tx->tx_power.ant_c) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"tx power: (1/2 dB step)\n");
-		if ((priv->hw_params.valid_tx_ant & ANT_A) &&
+		if ((priv->eeprom_data->valid_tx_ant & ANT_A) &&
 		    tx->tx_power.ant_a)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna A:",
 					tx->tx_power.ant_a);
-		if ((priv->hw_params.valid_tx_ant & ANT_B) &&
+		if ((priv->eeprom_data->valid_tx_ant & ANT_B) &&
 		    tx->tx_power.ant_b)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna B:",
 					tx->tx_power.ant_b);
-		if ((priv->hw_params.valid_tx_ant & ANT_C) &&
+		if ((priv->eeprom_data->valid_tx_ant & ANT_C) &&
 		    tx->tx_power.ant_c)
 			pos += scnprintf(buf + pos, bufsz - pos,
 					fmt_hex, "antenna C:",
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index c29e637..89f2e10 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 
 #include "iwl-fw.h"
+#include "iwl-eeprom-parse.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 #include "iwl-agn-hw.h"
@@ -46,7 +47,6 @@
 #include "iwl-notif-wait.h"
 #include "iwl-trans.h"
 
-#include "eeprom.h"
 #include "led.h"
 #include "power.h"
 #include "rs.h"
@@ -89,33 +89,6 @@
 #define IWL_NUM_SCAN_RATES         (2)
 
 /*
- * One for each channel, holds all channel setup data
- * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
- *     with one another!
- */
-struct iwl_channel_info {
-	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl_eeprom_channel ht40_eeprom;	/* EEPROM regulatory limit for
-						 * HT40 channel */
-
-	u8 channel;	  /* channel number */
-	u8 flags;	  /* flags copied from EEPROM */
-	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) limit */
-	s8 min_power;	  /* always 0 */
-	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
-
-	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
-	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	enum ieee80211_band band;
-
-	/* HT40 channel info */
-	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
-	u8 ht40_flags;		/* flags copied from EEPROM */
-	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
-};
-
-/*
  * Minimum number of queues. MAX_NUM is defined in hw specific files.
  * Set the minimum to accommodate
  *  - 4 standard TX queues
@@ -154,29 +127,6 @@ union iwl_ht_rate_supp {
 	};
 };
 
-#define CFG_HT_RX_AMPDU_FACTOR_8K   (0x0)
-#define CFG_HT_RX_AMPDU_FACTOR_16K  (0x1)
-#define CFG_HT_RX_AMPDU_FACTOR_32K  (0x2)
-#define CFG_HT_RX_AMPDU_FACTOR_64K  (0x3)
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  CFG_HT_RX_AMPDU_FACTOR_64K
-#define CFG_HT_RX_AMPDU_FACTOR_MAX  CFG_HT_RX_AMPDU_FACTOR_64K
-#define CFG_HT_RX_AMPDU_FACTOR_MIN  CFG_HT_RX_AMPDU_FACTOR_8K
-
-/*
- * Maximal MPDU density for TX aggregation
- * 4 - 2us density
- * 5 - 4us density
- * 6 - 8us density
- * 7 - 16us density
- */
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x4)
-#define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_8USEC   (0x6)
-#define CFG_HT_MPDU_DENSITY_16USEC  (0x7)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
-#define CFG_HT_MPDU_DENSITY_MAX CFG_HT_MPDU_DENSITY_16USEC
-#define CFG_HT_MPDU_DENSITY_MIN     (0x1)
-
 struct iwl_ht_config {
 	bool single_chain_sufficient;
 	enum ieee80211_smps_mode smps; /* current smps mode */
@@ -446,23 +396,6 @@ enum {
 	MEASUREMENT_ACTIVE = (1 << 1),
 };
 
-enum iwl_nvm_type {
-	NVM_DEVICE_TYPE_EEPROM = 0,
-	NVM_DEVICE_TYPE_OTP,
-};
-
-/*
- * Two types of OTP memory access modes
- *   IWL_OTP_ACCESS_ABSOLUTE - absolute address mode,
- * 			        based on physical memory addressing
- *   IWL_OTP_ACCESS_RELATIVE - relative address mode,
- * 			       based on logical memory addressing
- */
-enum iwl_access_mode {
-	IWL_OTP_ACCESS_ABSOLUTE,
-	IWL_OTP_ACCESS_RELATIVE,
-};
-
 /* reply_tx_statistics (for _agn devices) */
 struct reply_tx_error_statistics {
 	u32 pp_delay;
@@ -633,8 +566,6 @@ enum iwl_scan_type {
  *
  * @tx_chains_num: Number of TX chains
  * @rx_chains_num: Number of RX chains
- * @valid_tx_ant: usable antennas for TX
- * @valid_rx_ant: usable antennas for RX
  * @sku: sku read from EEPROM
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
@@ -645,8 +576,6 @@ enum iwl_scan_type {
 struct iwl_hw_params {
 	u8  tx_chains_num;
 	u8  rx_chains_num;
-	u8  valid_tx_ant;
-	u8  valid_rx_ant;
 	bool use_rts_for_aggregation;
 	u16 sku;
 	u32 ct_kill_threshold;
@@ -663,9 +592,6 @@ struct iwl_lib_ops {
 	/* device specific configuration */
 	void (*nic_config)(struct iwl_priv *priv);
 
-	/* eeprom operations (as defined in eeprom.h) */
-	struct iwl_eeprom_ops eeprom_ops;
-
 	/* temperature */
 	void (*temperature)(struct iwl_priv *priv);
 };
@@ -734,8 +660,6 @@ struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
-	struct ieee80211_channel *ieee_channels;
-	struct ieee80211_rate *ieee_rates;
 
 	struct list_head calib_results;
 
@@ -754,8 +678,6 @@ struct iwl_priv {
 
 	struct iwl_notif_wait_data notif_wait;
 
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
-
 	/* spectrum measurement report caching */
 	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
@@ -786,11 +708,6 @@ struct iwl_priv {
 	bool ucode_loaded;
 	bool init_ucode_run;		/* Don't run init uCode again */
 
-	/* we allocate array of iwl_channel_info for NIC's valid channels.
-	 *    Access via channel # using indirect index array */
-	struct iwl_channel_info *channel_info;	/* channel info array */
-	u8 channel_count;	/* # of channels */
-
 	u8 plcp_delta_threshold;
 
 	/* thermal calibration */
@@ -950,10 +867,8 @@ struct iwl_priv {
 
 	struct delayed_work scan_check;
 
-	/* TX Power */
+	/* TX Power settings */
 	s8 tx_power_user_lmt;
-	s8 tx_power_device_lmt;
-	s8 tx_power_lmt_in_half_dbm; /* max tx power in half-dBm format */
 	s8 tx_power_next;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -964,9 +879,10 @@ struct iwl_priv {
 	void *wowlan_sram;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
-	/* eeprom -- this is in the card's little endian byte order */
-	u8 *eeprom;
-	enum iwl_nvm_type nvm_device_type;
+	struct iwl_eeprom_data *eeprom_data;
+	/* eeprom blob for debugfs/testmode */
+	u8 *eeprom_blob;
+	size_t eeprom_blob_size;
 
 	struct work_struct txpower_work;
 	u32 calib_disabled;
@@ -1034,36 +950,4 @@ static inline int iwl_is_any_associated(struct iwl_priv *priv)
 	return false;
 }
 
-static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
-{
-	if (ch_info == NULL)
-		return 0;
-	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
-}
-
-static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
-}
-
-static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
-{
-	return ch_info->band == IEEE80211_BAND_5GHZ;
-}
-
-static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
-{
-	return ch_info->band == IEEE80211_BAND_2GHZ;
-}
-
-static inline int is_channel_passive(const struct iwl_channel_info *ch)
-{
-	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
-}
-
-static inline int is_channel_ibss(const struct iwl_channel_info *ch)
-{
-	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
-}
-
 #endif				/* __iwl_dev_h__ */
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index ddf053c..747e576 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -29,11 +29,48 @@
  */
 #include "iwl-io.h"
 #include "iwl-prph.h"
+#include "iwl-eeprom-parse.h"
 
 #include "agn.h"
 #include "dev.h"
 #include "commands.h"
 
+
+#define EEPROM_RF_CONFIG_TYPE_MAX      0x3
+
+static void iwl_rf_config(struct iwl_priv *priv)
+{
+	u16 radio_cfg = priv->eeprom_data->radio_cfg;
+
+	/* write radio config values to register */
+	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
+		u32 reg_val =
+			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
+			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
+			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
+				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
+
+		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
+				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
+
+		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
+			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
+			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
+			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+	} else {
+		WARN_ON(1);
+	}
+
+	/* set CSR_HW_CONFIG_REG for uCode use */
+	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
+		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+}
+
 /*
  * 1000 series
  * ===========
@@ -180,17 +217,6 @@ static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
 	.nic_config = iwl1000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-	},
 	.temperature = iwlagn_temperature,
 };
 
@@ -251,36 +277,12 @@ static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.nic_config = iwl2000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-		.enhanced_txpower = true,
-	},
 	.temperature = iwlagn_temperature,
 };
 
 struct iwl_lib_ops iwl2030_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.nic_config = iwl2000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-		.enhanced_txpower = true,
-	},
 	.temperature = iwlagn_temperature,
 };
 
@@ -357,11 +359,9 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 static s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
 	u16 temperature, voltage;
-	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(priv,
-				EEPROM_KELVIN_TEMPERATURE);
 
-	temperature = le16_to_cpu(temp_calib[0]);
-	voltage = le16_to_cpu(temp_calib[1]);
+	temperature = le16_to_cpu(priv->eeprom_data->kelvin_temperature);
+	voltage = le16_to_cpu(priv->eeprom_data->kelvin_voltage);
 
 	/* offset = temp - volt / coeff */
 	return (s32)(temperature -
@@ -478,17 +478,6 @@ struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-	},
 	.temperature = iwlagn_temperature,
 };
 
@@ -496,17 +485,6 @@ struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-	},
 	.temperature = iwl5150_temperature,
 };
 
@@ -541,13 +519,13 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		break;
 	case IWL_DEVICE_FAMILY_6050:
 		/* Indicate calibration version to uCode. */
-		if (iwl_eeprom_calib_version(priv) >= 6)
+		if (priv->eeprom_data->calib_version >= 6)
 			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		break;
 	case IWL_DEVICE_FAMILY_6150:
 		/* Indicate calibration version to uCode. */
-		if (iwl_eeprom_calib_version(priv) >= 6)
+		if (priv->eeprom_data->calib_version >= 6)
 			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
@@ -658,18 +636,6 @@ struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-		.enhanced_txpower = true,
-	},
 	.temperature = iwlagn_temperature,
 };
 
@@ -677,17 +643,5 @@ struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-		.enhanced_txpower = true,
-	},
 	.temperature = iwlagn_temperature,
 };
diff --git a/drivers/net/wireless/iwlwifi/dvm/eeprom.c b/drivers/net/wireless/iwlwifi/dvm/eeprom.c
deleted file mode 100644
index b382b16..0000000
--- a/drivers/net/wireless/iwlwifi/dvm/eeprom.c
+++ /dev/null
@@ -1,1163 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
-#include <net/mac80211.h>
-#include "iwl-io.h"
-#include "iwl-prph.h"
-#include "iwl-debug.h"
-#include "dev.h"
-#include "agn.h"
-#include "eeprom.h"
-
-/************************** EEPROM BANDS ****************************
- *
- * The iwl_eeprom_band definitions below provide the mapping from the
- * EEPROM contents to the specific channel number supported for each
- * band.
- *
- * For example, iwl_priv->eeprom.band_3_channels[4] from the band_3
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
-const u8 iwl_eeprom_band_1[14] = {
-	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
-};
-
-/* 5.2 GHz bands */
-static const u8 iwl_eeprom_band_2[] = {	/* 4915-5080MHz */
-	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
-};
-
-static const u8 iwl_eeprom_band_3[] = {	/* 5170-5320MHz */
-	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
-};
-
-static const u8 iwl_eeprom_band_4[] = {	/* 5500-5700MHz */
-	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
-};
-
-static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
-	145, 149, 153, 157, 161, 165
-};
-
-static const u8 iwl_eeprom_band_6[] = {       /* 2.4 ht40 channel */
-	1, 2, 3, 4, 5, 6, 7
-};
-
-static const u8 iwl_eeprom_band_7[] = {       /* 5.2 ht40 channel */
-	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
-};
-
-/******************************************************************************
- *
- * generic NVM functions
- *
-******************************************************************************/
-
-/*
- * The device's EEPROM semaphore prevents conflicts between driver and uCode
- * when accessing the EEPROM; each access is a series of pulses to/from the
- * EEPROM chip, not a single event, so even reads could conflict if they
- * weren't arbitrated by the semaphore.
- */
-
-#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
-#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
-
-static int iwl_eeprom_acquire_semaphore(struct iwl_trans *trans)
-{
-	u16 count;
-	int ret;
-
-	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
-		/* Request semaphore */
-		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
-			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-		/* See if we got it */
-		ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-				EEPROM_SEM_TIMEOUT);
-		if (ret >= 0) {
-			IWL_DEBUG_EEPROM(trans,
-				"Acquired semaphore after %d tries.\n",
-				count+1);
-			return ret;
-		}
-	}
-
-	return ret;
-}
-
-static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
-{
-	iwl_clear_bit(trans, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-}
-
-static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
-{
-	u32 gp = iwl_read32(priv->trans, CSR_EEPROM_GP) &
-			   CSR_EEPROM_GP_VALID_MSK;
-	int ret = 0;
-
-	IWL_DEBUG_EEPROM(priv, "EEPROM signature=0x%08x\n", gp);
-	switch (gp) {
-	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
-		if (priv->nvm_device_type != NVM_DEVICE_TYPE_OTP) {
-			IWL_ERR(priv, "EEPROM with bad signature: 0x%08x\n",
-				gp);
-			ret = -ENOENT;
-		}
-		break;
-	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
-	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
-		if (priv->nvm_device_type != NVM_DEVICE_TYPE_EEPROM) {
-			IWL_ERR(priv, "OTP with bad signature: 0x%08x\n", gp);
-			ret = -ENOENT;
-		}
-		break;
-	case CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP:
-	default:
-		IWL_ERR(priv, "bad EEPROM/OTP signature, type=%s, "
-			"EEPROM_GP=0x%08x\n",
-			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-			? "OTP" : "EEPROM", gp);
-		ret = -ENOENT;
-		break;
-	}
-	return ret;
-}
-
-u16 iwl_eeprom_query16(struct iwl_priv *priv, size_t offset)
-{
-	if (!priv->eeprom)
-		return 0;
-	return (u16)priv->eeprom[offset] | ((u16)priv->eeprom[offset + 1] << 8);
-}
-
-int iwl_eeprom_check_version(struct iwl_priv *priv)
-{
-	u16 eeprom_ver;
-	u16 calib_ver;
-
-	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-	calib_ver = iwl_eeprom_calib_version(priv);
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
-int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
-{
-	u16 radio_cfg;
-
-	priv->hw_params.sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
-	    !priv->cfg->ht_params) {
-		IWL_ERR(priv, "Invalid 11n configuration\n");
-		return -EINVAL;
-	}
-
-	if (!priv->hw_params.sku) {
-		IWL_ERR(priv, "Invalid device sku\n");
-		return -EINVAL;
-	}
-
-	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->hw_params.sku);
-
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
-
-	priv->hw_params.valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
-	priv->hw_params.valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(radio_cfg);
-
-	/* check overrides (some devices have wrong EEPROM) */
-	if (priv->cfg->valid_tx_ant)
-		priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	if (priv->cfg->valid_rx_ant)
-		priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
-
-	if (!priv->hw_params.valid_tx_ant || !priv->hw_params.valid_rx_ant) {
-		IWL_ERR(priv, "Invalid chain (0x%X, 0x%X)\n",
-			priv->hw_params.valid_tx_ant,
-			priv->hw_params.valid_rx_ant);
-		return -EINVAL;
-	}
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (priv->cfg->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
-	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
-		 priv->hw_params.valid_tx_ant, priv->hw_params.valid_rx_ant);
-
-	return 0;
-}
-
-u16 iwl_eeprom_calib_version(struct iwl_priv *priv)
-{
-	struct iwl_eeprom_calib_hdr *hdr;
-
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
-							EEPROM_CALIB_ALL);
-	return hdr->version;
-}
-
-static u32 eeprom_indirect_address(struct iwl_priv *priv, u32 address)
-{
-	u16 offset = 0;
-
-	if ((address & INDIRECT_ADDRESS) == 0)
-		return address;
-
-	switch (address & INDIRECT_TYPE_MSK) {
-	case INDIRECT_HOST:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_HOST);
-		break;
-	case INDIRECT_GENERAL:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_GENERAL);
-		break;
-	case INDIRECT_REGULATORY:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_REGULATORY);
-		break;
-	case INDIRECT_TXP_LIMIT:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT);
-		break;
-	case INDIRECT_TXP_LIMIT_SIZE:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_TXP_LIMIT_SIZE);
-		break;
-	case INDIRECT_CALIBRATION:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_CALIBRATION);
-		break;
-	case INDIRECT_PROCESS_ADJST:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_PROCESS_ADJST);
-		break;
-	case INDIRECT_OTHERS:
-		offset = iwl_eeprom_query16(priv, EEPROM_LINK_OTHERS);
-		break;
-	default:
-		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
-		address & INDIRECT_TYPE_MSK);
-		break;
-	}
-
-	/* translate the offset from words to byte */
-	return (address & ADDRESS_MSK) + (offset << 1);
-}
-
-const u8 *iwl_eeprom_query_addr(struct iwl_priv *priv, size_t offset)
-{
-	u32 address = eeprom_indirect_address(priv, offset);
-	BUG_ON(address >= priv->cfg->base_params->eeprom_size);
-	return &priv->eeprom[address];
-}
-
-void iwl_eeprom_get_mac(struct iwl_priv *priv, u8 *mac)
-{
-	const u8 *addr = iwl_eeprom_query_addr(priv,
-					EEPROM_MAC_ADDRESS);
-	memcpy(mac, addr, ETH_ALEN);
-}
-
-/******************************************************************************
- *
- * OTP related functions
- *
-******************************************************************************/
-
-static void iwl_set_otp_access(struct iwl_trans *trans,
-			       enum iwl_access_mode mode)
-{
-	iwl_read32(trans, CSR_OTP_GP_REG);
-
-	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
-		iwl_clear_bit(trans, CSR_OTP_GP_REG,
-			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
-	else
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
-}
-
-static int iwl_get_nvm_type(struct iwl_trans *trans, u32 hw_rev)
-{
-	u32 otpgp;
-	int nvm_type;
-
-	/* OTP only valid for CP/PP and after */
-	switch (hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_NONE:
-		IWL_ERR(trans, "Unknown hardware type\n");
-		return -ENOENT;
-	case CSR_HW_REV_TYPE_5300:
-	case CSR_HW_REV_TYPE_5350:
-	case CSR_HW_REV_TYPE_5100:
-	case CSR_HW_REV_TYPE_5150:
-		nvm_type = NVM_DEVICE_TYPE_EEPROM;
-		break;
-	default:
-		otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
-		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
-			nvm_type = NVM_DEVICE_TYPE_OTP;
-		else
-			nvm_type = NVM_DEVICE_TYPE_EEPROM;
-		break;
-	}
-	return  nvm_type;
-}
-
-static int iwl_init_otp_access(struct iwl_trans *trans)
-{
-	int ret;
-
-	/* Enable 40MHz radio clock */
-	iwl_write32(trans, CSR_GP_CNTRL,
-		    iwl_read32(trans, CSR_GP_CNTRL) |
-		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/* wait for clock to be ready */
-	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
-				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-				 25000);
-	if (ret < 0)
-		IWL_ERR(trans, "Time out access OTP\n");
-	else {
-		iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
-				  APMG_PS_CTRL_VAL_RESET_REQ);
-		udelay(5);
-		iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
-				    APMG_PS_CTRL_VAL_RESET_REQ);
-
-		/*
-		 * CSR auto clock gate disable bit -
-		 * this is only applicable for HW with OTP shadow RAM
-		 */
-		if (trans->cfg->base_params->shadow_ram_support)
-			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
-				CSR_RESET_LINK_PWR_MGMT_DISABLED);
-	}
-	return ret;
-}
-
-static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
-			     __le16 *eeprom_data)
-{
-	int ret = 0;
-	u32 r;
-	u32 otpgp;
-
-	iwl_write32(trans, CSR_EEPROM_REG,
-		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
-				 CSR_EEPROM_REG_READ_VALID_MSK,
-				 CSR_EEPROM_REG_READ_VALID_MSK,
-				 IWL_EEPROM_ACCESS_TIMEOUT);
-	if (ret < 0) {
-		IWL_ERR(trans, "Time out reading OTP[%d]\n", addr);
-		return ret;
-	}
-	r = iwl_read32(trans, CSR_EEPROM_REG);
-	/* check for ECC errors: */
-	otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
-	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
-		/* stop in this case */
-		/* set the uncorrectable OTP ECC bit for acknowledgement */
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
-		IWL_ERR(trans, "Uncorrectable OTP ECC error, abort OTP read\n");
-		return -EINVAL;
-	}
-	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
-		/* continue in this case */
-		/* set the correctable OTP ECC bit for acknowledgement */
-		iwl_set_bit(trans, CSR_OTP_GP_REG,
-				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
-		IWL_ERR(trans, "Correctable OTP ECC error, continue read\n");
-	}
-	*eeprom_data = cpu_to_le16(r >> 16);
-	return 0;
-}
-
-/*
- * iwl_is_otp_empty: check for empty OTP
- */
-static bool iwl_is_otp_empty(struct iwl_trans *trans)
-{
-	u16 next_link_addr = 0;
-	__le16 link_value;
-	bool is_empty = false;
-
-	/* locate the beginning of OTP link list */
-	if (!iwl_read_otp_word(trans, next_link_addr, &link_value)) {
-		if (!link_value) {
-			IWL_ERR(trans, "OTP is empty\n");
-			is_empty = true;
-		}
-	} else {
-		IWL_ERR(trans, "Unable to read first block of OTP list.\n");
-		is_empty = true;
-	}
-
-	return is_empty;
-}
-
-
-/*
- * iwl_find_otp_image: find EEPROM image in OTP
- *   finding the OTP block that contains the EEPROM image.
- *   the last valid block on the link list (the block _before_ the last block)
- *   is the block we should read and used to configure the device.
- *   If all the available OTP blocks are full, the last block will be the block
- *   we should read and used to configure the device.
- *   only perform this operation if shadow RAM is disabled
- */
-static int iwl_find_otp_image(struct iwl_trans *trans,
-					u16 *validblockaddr)
-{
-	u16 next_link_addr = 0, valid_addr;
-	__le16 link_value = 0;
-	int usedblocks = 0;
-
-	/* set addressing mode to absolute to traverse the link list */
-	iwl_set_otp_access(trans, IWL_OTP_ACCESS_ABSOLUTE);
-
-	/* checking for empty OTP or error */
-	if (iwl_is_otp_empty(trans))
-		return -EINVAL;
-
-	/*
-	 * start traverse link list
-	 * until reach the max number of OTP blocks
-	 * different devices have different number of OTP blocks
-	 */
-	do {
-		/* save current valid block address
-		 * check for more block on the link list
-		 */
-		valid_addr = next_link_addr;
-		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
-		IWL_DEBUG_EEPROM(trans, "OTP blocks %d addr 0x%x\n",
-			       usedblocks, next_link_addr);
-		if (iwl_read_otp_word(trans, next_link_addr, &link_value))
-			return -EINVAL;
-		if (!link_value) {
-			/*
-			 * reach the end of link list, return success and
-			 * set address point to the starting address
-			 * of the image
-			 */
-			*validblockaddr = valid_addr;
-			/* skip first 2 bytes (link list pointer) */
-			*validblockaddr += 2;
-			return 0;
-		}
-		/* more in the link list, continue */
-		usedblocks++;
-	} while (usedblocks <= trans->cfg->base_params->max_ll_items);
-
-	/* OTP has no valid blocks */
-	IWL_DEBUG_EEPROM(trans, "OTP has no valid blocks\n");
-	return -EINVAL;
-}
-
-/******************************************************************************
- *
- * Tx Power related functions
- *
-******************************************************************************/
-/**
- * iwl_get_max_txpower_avg - get the highest tx power from all chains.
- *     find the highest tx power from all chains for the channel
- */
-static s8 iwl_get_max_txpower_avg(const struct iwl_cfg *cfg,
-		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
-		int element, s8 *max_txpower_in_half_dbm)
-{
-	s8 max_txpower_avg = 0; /* (dBm) */
-
-	/* Take the highest tx power from any valid chains */
-	if ((cfg->valid_tx_ant & ANT_A) &&
-	    (enhanced_txpower[element].chain_a_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_a_max;
-	if ((cfg->valid_tx_ant & ANT_B) &&
-	    (enhanced_txpower[element].chain_b_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_b_max;
-	if ((cfg->valid_tx_ant & ANT_C) &&
-	    (enhanced_txpower[element].chain_c_max > max_txpower_avg))
-		max_txpower_avg = enhanced_txpower[element].chain_c_max;
-	if (((cfg->valid_tx_ant == ANT_AB) |
-	    (cfg->valid_tx_ant == ANT_BC) |
-	    (cfg->valid_tx_ant == ANT_AC)) &&
-	    (enhanced_txpower[element].mimo2_max > max_txpower_avg))
-		max_txpower_avg =  enhanced_txpower[element].mimo2_max;
-	if ((cfg->valid_tx_ant == ANT_ABC) &&
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
-static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
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
-		max_txp_avg = iwl_get_max_txpower_avg(priv->cfg, txp_array, idx,
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
-
-/**
- * iwl_eeprom_init - read EEPROM contents
- *
- * Load the EEPROM contents from adapter into priv->eeprom
- *
- * NOTE:  This routine uses the non-debug IO access functions.
- */
-int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
-{
-	__le16 *e;
-	u32 gp = iwl_read32(priv->trans, CSR_EEPROM_GP);
-	int sz;
-	int ret;
-	u16 addr;
-	u16 validblockaddr = 0;
-	u16 cache_addr = 0;
-
-	priv->nvm_device_type = iwl_get_nvm_type(priv->trans, hw_rev);
-	if (priv->nvm_device_type == -ENOENT)
-		return -ENOENT;
-	/* allocate eeprom */
-	sz = priv->cfg->base_params->eeprom_size;
-	IWL_DEBUG_EEPROM(priv, "NVM size = %d\n", sz);
-	priv->eeprom = kzalloc(sz, GFP_KERNEL);
-	if (!priv->eeprom) {
-		ret = -ENOMEM;
-		goto alloc_err;
-	}
-	e = (__le16 *)priv->eeprom;
-
-	ret = iwl_eeprom_verify_signature(priv);
-	if (ret < 0) {
-		IWL_ERR(priv, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
-		ret = -ENOENT;
-		goto err;
-	}
-
-	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl_eeprom_acquire_semaphore(priv->trans);
-	if (ret < 0) {
-		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
-		ret = -ENOENT;
-		goto err;
-	}
-
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
-
-		ret = iwl_init_otp_access(priv->trans);
-		if (ret) {
-			IWL_ERR(priv, "Failed to initialize OTP access.\n");
-			ret = -ENOENT;
-			goto done;
-		}
-		iwl_write32(priv->trans, CSR_EEPROM_GP,
-			    iwl_read32(priv->trans, CSR_EEPROM_GP) &
-			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
-
-		iwl_set_bit(priv->trans, CSR_OTP_GP_REG,
-			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
-			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
-		/* traversing the linked list if no shadow ram supported */
-		if (!priv->cfg->base_params->shadow_ram_support) {
-			if (iwl_find_otp_image(priv->trans, &validblockaddr)) {
-				ret = -ENOENT;
-				goto done;
-			}
-		}
-		for (addr = validblockaddr; addr < validblockaddr + sz;
-		     addr += sizeof(u16)) {
-			__le16 eeprom_data;
-
-			ret = iwl_read_otp_word(priv->trans, addr,
-						&eeprom_data);
-			if (ret)
-				goto done;
-			e[cache_addr / 2] = eeprom_data;
-			cache_addr += sizeof(u16);
-		}
-	} else {
-		/* eeprom is an array of 16bit values */
-		for (addr = 0; addr < sz; addr += sizeof(u16)) {
-			u32 r;
-
-			iwl_write32(priv->trans, CSR_EEPROM_REG,
-				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-
-			ret = iwl_poll_bit(priv->trans, CSR_EEPROM_REG,
-						  CSR_EEPROM_REG_READ_VALID_MSK,
-						  CSR_EEPROM_REG_READ_VALID_MSK,
-						  IWL_EEPROM_ACCESS_TIMEOUT);
-			if (ret < 0) {
-				IWL_ERR(priv,
-					"Time out reading EEPROM[%d]\n", addr);
-				goto done;
-			}
-			r = iwl_read32(priv->trans, CSR_EEPROM_REG);
-			e[addr / 2] = cpu_to_le16(r >> 16);
-		}
-	}
-
-	IWL_DEBUG_EEPROM(priv, "NVM Type: %s, version: 0x%x\n",
-		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-		       ? "OTP" : "EEPROM",
-		       iwl_eeprom_query16(priv, EEPROM_VERSION));
-
-	ret = 0;
-done:
-	iwl_eeprom_release_semaphore(priv->trans);
-
-err:
-	if (ret)
-		iwl_eeprom_free(priv);
-alloc_err:
-	return ret;
-}
-
-void iwl_eeprom_free(struct iwl_priv *priv)
-{
-	kfree(priv->eeprom);
-	priv->eeprom = NULL;
-}
-
-static void iwl_init_band_reference(struct iwl_priv *priv,
-			int eep_band, int *eeprom_ch_count,
-			const struct iwl_eeprom_channel **eeprom_ch_info,
-			const u8 **eeprom_ch_index)
-{
-	u32 offset = priv->lib->
-			eeprom_ops.regulatory_bands[eep_band - 1];
-	switch (eep_band) {
-	case 1:		/* 2.4GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_1;
-		break;
-	case 2:		/* 4.9GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_2;
-		break;
-	case 3:		/* 5.2GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_3;
-		break;
-	case 4:		/* 5.5GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_4;
-		break;
-	case 5:		/* 5.7GHz band */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_5;
-		break;
-	case 6:		/* 2.4GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_6;
-		break;
-	case 7:		/* 5 GHz ht40 channels */
-		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
-		*eeprom_ch_info = (struct iwl_eeprom_channel *)
-				iwl_eeprom_query_addr(priv, offset);
-		*eeprom_ch_index = iwl_eeprom_band_7;
-		break;
-	default:
-		BUG();
-		return;
-	}
-}
-
-#define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
-			    ? # x " " : "")
-/**
- * iwl_mod_ht40_chan_info - Copy ht40 channel info into driver's priv.
- *
- * Does not set up a command, or touch hardware.
- */
-static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
-			      enum ieee80211_band band, u16 channel,
-			      const struct iwl_eeprom_channel *eeprom_ch,
-			      u8 clear_ht40_extension_channel)
-{
-	struct iwl_channel_info *ch_info;
-
-	ch_info = (struct iwl_channel_info *)
-			iwl_get_channel_info(priv, band, channel);
-
-	if (!is_channel_valid(ch_info))
-		return -1;
-
-	IWL_DEBUG_EEPROM(priv, "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm):"
-			" Ad-Hoc %ssupported\n",
-			ch_info->channel,
-			is_channel_a_band(ch_info) ?
-			"5.2" : "2.4",
-			CHECK_AND_PRINT(IBSS),
-			CHECK_AND_PRINT(ACTIVE),
-			CHECK_AND_PRINT(RADAR),
-			CHECK_AND_PRINT(WIDE),
-			CHECK_AND_PRINT(DFS),
-			eeprom_ch->flags,
-			eeprom_ch->max_power_avg,
-			((eeprom_ch->flags & EEPROM_CHANNEL_IBSS)
-			 && !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ?
-			"" : "not ");
-
-	ch_info->ht40_eeprom = *eeprom_ch;
-	ch_info->ht40_max_power_avg = eeprom_ch->max_power_avg;
-	ch_info->ht40_flags = eeprom_ch->flags;
-	if (eeprom_ch->flags & EEPROM_CHANNEL_VALID)
-		ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
-
-	return 0;
-}
-
-#define CHECK_AND_PRINT_I(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
-			    ? # x " " : "")
-
-/**
- * iwl_init_channel_map - Set up driver's info for all possible channels
- */
-int iwl_init_channel_map(struct iwl_priv *priv)
-{
-	int eeprom_ch_count = 0;
-	const u8 *eeprom_ch_index = NULL;
-	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
-	int band, ch;
-	struct iwl_channel_info *ch_info;
-
-	if (priv->channel_count) {
-		IWL_DEBUG_EEPROM(priv, "Channel map already initialized.\n");
-		return 0;
-	}
-
-	IWL_DEBUG_EEPROM(priv, "Initializing regulatory info from EEPROM\n");
-
-	priv->channel_count =
-	    ARRAY_SIZE(iwl_eeprom_band_1) +
-	    ARRAY_SIZE(iwl_eeprom_band_2) +
-	    ARRAY_SIZE(iwl_eeprom_band_3) +
-	    ARRAY_SIZE(iwl_eeprom_band_4) +
-	    ARRAY_SIZE(iwl_eeprom_band_5);
-
-	IWL_DEBUG_EEPROM(priv, "Parsing data for %d channels.\n",
-			priv->channel_count);
-
-	priv->channel_info = kcalloc(priv->channel_count,
-				     sizeof(struct iwl_channel_info),
-				     GFP_KERNEL);
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
-		iwl_init_band_reference(priv, band, &eeprom_ch_count,
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
-			/* First write that ht40 is not enabled, and then enable
-			 * one by one */
-			ch_info->ht40_extension_channel =
-					IEEE80211_CHAN_NO_HT40;
-
-			if (!(is_channel_valid(ch_info))) {
-				IWL_DEBUG_EEPROM(priv,
-					       "Ch. %d Flags %x [%sGHz] - "
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
-			IWL_DEBUG_EEPROM(priv, "Ch. %d [%sGHz] "
-				       "%s%s%s%s%s%s(0x%02x %ddBm):"
-				       " Ad-Hoc %ssupported\n",
-				       ch_info->channel,
-				       is_channel_a_band(ch_info) ?
-				       "5.2" : "2.4",
-				       CHECK_AND_PRINT_I(VALID),
-				       CHECK_AND_PRINT_I(IBSS),
-				       CHECK_AND_PRINT_I(ACTIVE),
-				       CHECK_AND_PRINT_I(RADAR),
-				       CHECK_AND_PRINT_I(WIDE),
-				       CHECK_AND_PRINT_I(DFS),
-				       eeprom_ch_info[ch].flags,
-				       eeprom_ch_info[ch].max_power_avg,
-				       ((eeprom_ch_info[ch].
-					 flags & EEPROM_CHANNEL_IBSS)
-					&& !(eeprom_ch_info[ch].
-					     flags & EEPROM_CHANNEL_RADAR))
-				       ? "" : "not ");
-
-			ch_info++;
-		}
-	}
-
-	/* Check if we do have HT40 channels */
-	if (priv->lib->eeprom_ops.regulatory_bands[5] ==
-	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    priv->lib->eeprom_ops.regulatory_bands[6] ==
-	    EEPROM_REGULATORY_BAND_NO_HT40)
-		return 0;
-
-	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
-	for (band = 6; band <= 7; band++) {
-		enum ieee80211_band ieeeband;
-
-		iwl_init_band_reference(priv, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
-
-		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
-		ieeeband =
-			(band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-
-		/* Loop through each band adding each of the channels */
-		for (ch = 0; ch < eeprom_ch_count; ch++) {
-			/* Set up driver's info for lower half */
-			iwl_mod_ht40_chan_info(priv, ieeeband,
-						eeprom_ch_index[ch],
-						&eeprom_ch_info[ch],
-						IEEE80211_CHAN_NO_HT40PLUS);
-
-			/* Set up driver's info for upper half */
-			iwl_mod_ht40_chan_info(priv, ieeeband,
-						eeprom_ch_index[ch] + 4,
-						&eeprom_ch_info[ch],
-						IEEE80211_CHAN_NO_HT40MINUS);
-		}
-	}
-
-	/* for newer device (6000 series and up)
-	 * EEPROM contain enhanced tx power information
-	 * driver need to process addition information
-	 * to determine the max channel tx power limits
-	 */
-	if (priv->lib->eeprom_ops.enhanced_txpower)
-		iwl_eeprom_enhanced_txpower(priv);
-
-	return 0;
-}
-
-/*
- * iwl_free_channel_map - undo allocations in iwl_init_channel_map
- */
-void iwl_free_channel_map(struct iwl_priv *priv)
-{
-	kfree(priv->channel_info);
-	priv->channel_count = 0;
-}
-
-/**
- * iwl_get_channel_info - Find driver's private channel info
- *
- * Based on band and channel number.
- */
-const struct iwl_channel_info *iwl_get_channel_info(const struct iwl_priv *priv,
-					enum ieee80211_band band, u16 channel)
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
-	case IEEE80211_BAND_2GHZ:
-		if (channel >= 1 && channel <= 14)
-			return &priv->channel_info[channel - 1];
-		break;
-	default:
-		BUG();
-	}
-
-	return NULL;
-}
-
-void iwl_rf_config(struct iwl_priv *priv)
-{
-	u16 radio_cfg;
-
-	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
-
-	/* write radio config values to register */
-	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		u32 reg_val =
-			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_TYPE |
-			EEPROM_RF_CFG_STEP_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_STEP |
-			EEPROM_RF_CFG_DASH_MSK(radio_cfg) <<
-				CSR_HW_IF_CONFIG_REG_POS_PHY_DASH;
-
-		iwl_set_bits_mask(priv->trans, CSR_HW_IF_CONFIG_REG,
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_TYPE |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_STEP |
-				  CSR_HW_IF_CONFIG_REG_MSK_PHY_DASH, reg_val);
-
-		IWL_INFO(priv, "Radio type=0x%x-0x%x-0x%x\n",
-			 EEPROM_RF_CFG_TYPE_MSK(radio_cfg),
-			 EEPROM_RF_CFG_STEP_MSK(radio_cfg),
-			 EEPROM_RF_CFG_DASH_MSK(radio_cfg));
-	} else
-		WARN_ON(1);
-
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
-}
diff --git a/drivers/net/wireless/iwlwifi/dvm/eeprom.h b/drivers/net/wireless/iwlwifi/dvm/eeprom.h
deleted file mode 100644
index 64bfd94..0000000
--- a/drivers/net/wireless/iwlwifi/dvm/eeprom.h
+++ /dev/null
@@ -1,269 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
-#ifndef __iwl_eeprom_h__
-#define __iwl_eeprom_h__
-
-#include <net/mac80211.h>
-
-struct iwl_priv;
-
-/*
- * EEPROM access time values:
- *
- * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG.
- * Driver then polls CSR_EEPROM_REG for CSR_EEPROM_REG_READ_VALID_MSK (0x1).
- * When polling, wait 10 uSec between polling loops, up to a maximum 5000 uSec.
- * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
- */
-#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-
-#define IWL_EEPROM_SEM_TIMEOUT 		10   /* microseconds */
-#define IWL_EEPROM_SEM_RETRY_LIMIT	1000 /* number of attempts (not time) */
-
-
-/*
- * Regulatory channel usage flags in EEPROM struct iwl4965_eeprom_channel.flags.
- *
- * IBSS and/or AP operation is allowed *only* on those channels with
- * (VALID && IBSS && ACTIVE && !RADAR).  This restriction is in place because
- * RADAR detection is not supported by the 4965 driver, but is a
- * requirement for establishing a new network for legal operation on channels
- * requiring RADAR detection or restricting ACTIVE scanning.
- *
- * NOTE:  "WIDE" flag does not indicate anything about "HT40" 40 MHz channels.
- *        It only indicates that 20 MHz channel use is supported; HT40 channel
- *        usage is indicated by a separate set of regulatory flags for each
- *        HT40 channel pair.
- *
- * NOTE:  Using a channel inappropriately will result in a uCode error!
- */
-#define IWL_NUM_TX_CALIB_GROUPS 5
-enum {
-	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
-	EEPROM_CHANNEL_IBSS = (1 << 1),		/* usable as an IBSS channel */
-	/* Bit 2 Reserved */
-	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
-	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
-	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	/* Bit 6 Reserved (was Narrow Channel) */
-	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
-};
-
-/* SKU Capabilities */
-#define EEPROM_SKU_CAP_BAND_24GHZ			(1 << 4)
-#define EEPROM_SKU_CAP_BAND_52GHZ			(1 << 5)
-#define EEPROM_SKU_CAP_11N_ENABLE	                (1 << 6)
-#define EEPROM_SKU_CAP_AMT_ENABLE			(1 << 7)
-#define EEPROM_SKU_CAP_IPAN_ENABLE	                (1 << 8)
-
-/* *regulatory* channel data format in eeprom, one for each channel.
- * There are separate entries for HT40 (40 MHz) vs. normal (20 MHz) channels. */
-struct iwl_eeprom_channel {
-	u8 flags;		/* EEPROM_CHANNEL_* flags copied from EEPROM */
-	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
-} __packed;
-
-enum iwl_eeprom_enhanced_txpwr_flags {
-	IWL_EEPROM_ENH_TXP_FL_VALID		= BIT(0),
-	IWL_EEPROM_ENH_TXP_FL_BAND_52G		= BIT(1),
-	IWL_EEPROM_ENH_TXP_FL_OFDM		= BIT(2),
-	IWL_EEPROM_ENH_TXP_FL_40MHZ		= BIT(3),
-	IWL_EEPROM_ENH_TXP_FL_HT_AP		= BIT(4),
-	IWL_EEPROM_ENH_TXP_FL_RES1		= BIT(5),
-	IWL_EEPROM_ENH_TXP_FL_RES2		= BIT(6),
-	IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE	= BIT(7),
-};
-
-/**
- * iwl_eeprom_enhanced_txpwr structure
- *    This structure presents the enhanced regulatory tx power limit layout
- *    in eeprom image
- *    Enhanced regulatory tx power portion of eeprom image can be broken down
- *    into individual structures; each one is 8 bytes in size and contain the
- *    following information
- * @flags: entry flags
- * @channel: channel number
- * @chain_a_max_pwr: chain a max power in 1/2 dBm
- * @chain_b_max_pwr: chain b max power in 1/2 dBm
- * @chain_c_max_pwr: chain c max power in 1/2 dBm
- * @delta_20_in_40: 20-in-40 deltas (hi/lo)
- * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
- * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
- *
- */
-struct iwl_eeprom_enhanced_txpwr {
-	u8 flags;
-	u8 channel;
-	s8 chain_a_max;
-	s8 chain_b_max;
-	s8 chain_c_max;
-	u8 delta_20_in_40;
-	s8 mimo2_max;
-	s8 mimo3_max;
-} __packed;
-
-/* calibration */
-struct iwl_eeprom_calib_hdr {
-	u8 version;
-	u8 pa_type;
-	__le16 voltage;
-} __packed;
-
-#define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
-#define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
-
-/* temperature */
-#define EEPROM_KELVIN_TEMPERATURE	((2*0x12A) | EEPROM_CALIB_ALL)
-#define EEPROM_RAW_TEMPERATURE		((2*0x12B) | EEPROM_CALIB_ALL)
-
-
-/* agn links */
-#define EEPROM_LINK_HOST             (2*0x64)
-#define EEPROM_LINK_GENERAL          (2*0x65)
-#define EEPROM_LINK_REGULATORY       (2*0x66)
-#define EEPROM_LINK_CALIBRATION      (2*0x67)
-#define EEPROM_LINK_PROCESS_ADJST    (2*0x68)
-#define EEPROM_LINK_OTHERS           (2*0x69)
-#define EEPROM_LINK_TXP_LIMIT        (2*0x6a)
-#define EEPROM_LINK_TXP_LIMIT_SIZE   (2*0x6b)
-
-/* agn regulatory - indirect access */
-#define EEPROM_REG_BAND_1_CHANNELS       ((0x08)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 28 bytes */
-#define EEPROM_REG_BAND_2_CHANNELS       ((0x26)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 26 bytes */
-#define EEPROM_REG_BAND_3_CHANNELS       ((0x42)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
-#define EEPROM_REG_BAND_4_CHANNELS       ((0x5C)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22 bytes */
-#define EEPROM_REG_BAND_5_CHANNELS       ((0x74)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 12 bytes */
-#define EEPROM_REG_BAND_24_HT40_CHANNELS  ((0x82)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-#define EEPROM_REG_BAND_52_HT40_CHANNELS  ((0x92)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
-
-/* 6000 regulatory - indirect access */
-#define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
-/* 2.4 GHz */
-extern const u8 iwl_eeprom_band_1[14];
-
-#define ADDRESS_MSK                 0x0000FFFF
-#define INDIRECT_TYPE_MSK           0x000F0000
-#define INDIRECT_HOST               0x00010000
-#define INDIRECT_GENERAL            0x00020000
-#define INDIRECT_REGULATORY         0x00030000
-#define INDIRECT_CALIBRATION        0x00040000
-#define INDIRECT_PROCESS_ADJST      0x00050000
-#define INDIRECT_OTHERS             0x00060000
-#define INDIRECT_TXP_LIMIT          0x00070000
-#define INDIRECT_TXP_LIMIT_SIZE     0x00080000
-#define INDIRECT_ADDRESS            0x00100000
-
-/* General */
-#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
-#define EEPROM_SUBSYSTEM_ID		    (2*0x0A)	/* 2 bytes */
-#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
-#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
-#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
-#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 2  bytes */
-#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
-#define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
-#define EEPROM_NUM_MAC_ADDRESS              (2*0x4C)	/* 2  bytes */
-
-/* The following masks are to be applied on EEPROM_RADIO_CONFIG */
-#define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
-#define EEPROM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
-#define EEPROM_RF_CFG_DASH_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
-#define EEPROM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
-#define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
-#define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
-
-#define EEPROM_RF_CONFIG_TYPE_MAX	0x3
-
-#define EEPROM_REGULATORY_BAND_NO_HT40			(0)
-
-struct iwl_eeprom_ops {
-	const u32 regulatory_bands[7];
-	bool enhanced_txpower;
-};
-
-
-int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev);
-void iwl_eeprom_free(struct iwl_priv *priv);
-int iwl_eeprom_check_version(struct iwl_priv *priv);
-int iwl_eeprom_init_hw_params(struct iwl_priv *priv);
-u16 iwl_eeprom_calib_version(struct iwl_priv *priv);
-const u8 *iwl_eeprom_query_addr(struct iwl_priv *priv, size_t offset);
-u16 iwl_eeprom_query16(struct iwl_priv *priv, size_t offset);
-void iwl_eeprom_get_mac(struct iwl_priv *priv, u8 *mac);
-int iwl_init_channel_map(struct iwl_priv *priv);
-void iwl_free_channel_map(struct iwl_priv *priv);
-const struct iwl_channel_info *iwl_get_channel_info(
-		const struct iwl_priv *priv,
-		enum ieee80211_band band, u16 channel);
-void iwl_rf_config(struct iwl_priv *priv);
-
-#endif  /* __iwl_eeprom_h__ */
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 4ac9af7..cb1ca7a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -59,8 +59,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
 
-	if (priv->tx_power_lmt_in_half_dbm &&
-	    priv->tx_power_lmt_in_half_dbm < tx_power_cmd.global_lmt) {
+	if (tx_power_cmd.global_lmt > priv->eeprom_data->max_tx_pwr_half_dbm) {
 		/*
 		 * For the newer devices which using enhanced/extend tx power
 		 * table in EEPROM, the format is in half dBm. driver need to
@@ -72,7 +71,8 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 		 * "tx_power_user_lmt" is higher than EEPROM value (in
 		 * half-dBm format), lower the tx power based on EEPROM
 		 */
-		tx_power_cmd.global_lmt = priv->tx_power_lmt_in_half_dbm;
+		tx_power_cmd.global_lmt =
+			priv->eeprom_data->max_tx_pwr_half_dbm;
 	}
 	tx_power_cmd.flags = IWLAGN_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWLAGN_TX_POWER_AUTO;
@@ -824,7 +824,7 @@ void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (priv->chain_noise_data.active_chains)
 		active_chains = priv->chain_noise_data.active_chains;
 	else
-		active_chains = priv->hw_params.valid_rx_ant;
+		active_chains = priv->eeprom_data->valid_rx_ant;
 
 	if (priv->cfg->bt_params &&
 	    priv->cfg->bt_params->advanced_bt_coexist &&
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 32a823d..f60be39 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -48,7 +48,6 @@
 #include "iwl-op-mode.h"
 #include "iwl-modparams.h"
 
-#include "eeprom.h"
 #include "dev.h"
 #include "calib.h"
 #include "agn.h"
@@ -238,12 +237,12 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_channels)
+	if (priv->eeprom_data->bands[IEEE80211_BAND_2GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
-			&priv->bands[IEEE80211_BAND_2GHZ];
-	if (priv->bands[IEEE80211_BAND_5GHZ].n_channels)
+			&priv->eeprom_data->bands[IEEE80211_BAND_2GHZ];
+	if (priv->eeprom_data->bands[IEEE80211_BAND_5GHZ].n_channels)
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			&priv->bands[IEEE80211_BAND_5GHZ];
+			&priv->eeprom_data->bands[IEEE80211_BAND_5GHZ];
 
 	hw->wiphy->hw_version = priv->trans->hw_id;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 10a2800..ebdc8b9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -44,13 +44,14 @@
 
 #include <asm/div64.h>
 
+#include "iwl-eeprom-read.h"
+#include "iwl-eeprom-parse.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
 
-#include "eeprom.h"
 #include "dev.h"
 #include "calib.h"
 #include "agn.h"
@@ -180,7 +181,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		rate = info->control.rates[0].idx;
 
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-					      priv->hw_params.valid_tx_ant);
+					      priv->eeprom_data->valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* In mac80211, rates for 5 GHz start at 0 */
@@ -814,7 +815,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	ieee80211_wake_queues(priv->hw);
 
 	/* Configure Tx antenna selection based on H/W config */
-	iwlagn_send_tx_ant_config(priv, priv->hw_params.valid_tx_ant);
+	iwlagn_send_tx_ant_config(priv, priv->eeprom_data->valid_tx_ant);
 
 	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
@@ -938,8 +939,6 @@ void iwl_down(struct iwl_priv *priv)
 	/* Clear out all status bits but a few that are stable across reset */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
 				STATUS_FW_ERROR |
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
@@ -1126,227 +1125,14 @@ void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	del_timer_sync(&priv->ucode_trace);
 }
 
-static void iwl_init_hw_rates(struct ieee80211_rate *rates)
-{
-	int i;
-
-	for (i = 0; i < IWL_RATE_COUNT_LEGACY; i++) {
-		rates[i].bitrate = iwl_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
-		rates[i].hw_value_short = i;
-		rates[i].flags = 0;
-		if ((i >= IWL_FIRST_CCK_RATE) && (i <= IWL_LAST_CCK_RATE)) {
-			/*
-			 * If CCK != 1M then set short preamble rate flag.
-			 */
-			rates[i].flags |=
-				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
-					0 : IEEE80211_RATE_SHORT_PREAMBLE;
-		}
-	}
-}
-
-#define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
-#define MAX_BIT_RATE_20_MHZ 72 /* Mbps */
-static void iwl_init_ht_hw_capab(const struct iwl_priv *priv,
-			      struct ieee80211_sta_ht_cap *ht_info,
-			      enum ieee80211_band band)
-{
-	u16 max_bit_rate = 0;
-	u8 rx_chains_num = priv->hw_params.rx_chains_num;
-	u8 tx_chains_num = priv->hw_params.tx_chains_num;
-
-	ht_info->cap = 0;
-	ht_info->ht_supported = false;
-	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-
-	if (!priv->cfg->ht_params)
-		return;
-
-	ht_info->ht_supported = true;
-
-	if (priv->cfg->ht_params->ht_greenfield_support)
-		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
-	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-	max_bit_rate = MAX_BIT_RATE_20_MHZ;
-	if (priv->cfg->ht_params->ht40_bands & BIT(band)) {
-		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
-		ht_info->mcs.rx_mask[4] = 0x01;
-		max_bit_rate = MAX_BIT_RATE_40_MHZ;
-	}
-
-	if (iwlwifi_mod_params.amsdu_size_8K)
-		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
-
-	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-
-	ht_info->mcs.rx_mask[0] = 0xFF;
-	if (rx_chains_num >= 2)
-		ht_info->mcs.rx_mask[1] = 0xFF;
-	if (rx_chains_num >= 3)
-		ht_info->mcs.rx_mask[2] = 0xFF;
-
-	/* Highest supported Rx data rate */
-	max_bit_rate *= rx_chains_num;
-	WARN_ON(max_bit_rate & ~IEEE80211_HT_MCS_RX_HIGHEST_MASK);
-	ht_info->mcs.rx_highest = cpu_to_le16(max_bit_rate);
-
-	/* Tx MCS capabilities */
-	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-	if (tx_chains_num != rx_chains_num) {
-		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
-		ht_info->mcs.tx_params |= ((tx_chains_num - 1) <<
-				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
-	}
-}
-
-/**
- * iwl_init_geos - Initialize mac80211's geo/channel info based from eeprom
- */
-static int iwl_init_geos(struct iwl_priv *priv)
-{
-	struct iwl_channel_info *ch;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *channels;
-	struct ieee80211_channel *geo_ch;
-	struct ieee80211_rate *rates;
-	int i = 0;
-	s8 max_tx_power = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-
-	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
-	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
-		IWL_DEBUG_INFO(priv, "Geography modes already initialized.\n");
-		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-		return 0;
-	}
-
-	channels = kcalloc(priv->channel_count,
-			   sizeof(struct ieee80211_channel), GFP_KERNEL);
-	if (!channels)
-		return -ENOMEM;
-
-	rates = kcalloc(IWL_RATE_COUNT_LEGACY, sizeof(struct ieee80211_rate),
-			GFP_KERNEL);
-	if (!rates) {
-		kfree(channels);
-		return -ENOMEM;
-	}
-
-	/* 5.2GHz channels start after the 2.4GHz channels */
-	sband = &priv->bands[IEEE80211_BAND_5GHZ];
-	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
-	/* just OFDM */
-	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
-	sband->n_bitrates = IWL_RATE_COUNT_LEGACY - IWL_FIRST_OFDM_RATE;
-
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
-					 IEEE80211_BAND_5GHZ);
-
-	sband = &priv->bands[IEEE80211_BAND_2GHZ];
-	sband->channels = channels;
-	/* OFDM & CCK */
-	sband->bitrates = rates;
-	sband->n_bitrates = IWL_RATE_COUNT_LEGACY;
-
-	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE)
-		iwl_init_ht_hw_capab(priv, &sband->ht_cap,
-					 IEEE80211_BAND_2GHZ);
-
-	priv->ieee_channels = channels;
-	priv->ieee_rates = rates;
-
-	for (i = 0;  i < priv->channel_count; i++) {
-		ch = &priv->channel_info[i];
-
-		/* FIXME: might be removed if scan is OK */
-		if (!is_channel_valid(ch))
-			continue;
-
-		sband =  &priv->bands[ch->band];
-
-		geo_ch = &sband->channels[sband->n_channels++];
-
-		geo_ch->center_freq =
-			ieee80211_channel_to_frequency(ch->channel, ch->band);
-		geo_ch->max_power = ch->max_power_avg;
-		geo_ch->max_antenna_gain = 0xff;
-		geo_ch->hw_value = ch->channel;
-
-		if (is_channel_valid(ch)) {
-			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
-				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
-
-			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
-				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-			if (ch->flags & EEPROM_CHANNEL_RADAR)
-				geo_ch->flags |= IEEE80211_CHAN_RADAR;
-
-			geo_ch->flags |= ch->ht40_extension_channel;
-
-			if (ch->max_power_avg > max_tx_power)
-				max_tx_power = ch->max_power_avg;
-		} else {
-			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
-		}
-
-		IWL_DEBUG_INFO(priv, "Channel %d Freq=%d[%sGHz] %s flag=0x%X\n",
-				ch->channel, geo_ch->center_freq,
-				is_channel_a_band(ch) ?  "5.2" : "2.4",
-				geo_ch->flags & IEEE80211_CHAN_DISABLED ?
-				"restricted" : "valid",
-				 geo_ch->flags);
-	}
-
-	priv->tx_power_device_lmt = max_tx_power;
-	priv->tx_power_user_lmt = max_tx_power;
-	priv->tx_power_next = max_tx_power;
-
-	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
-	     priv->hw_params.sku & EEPROM_SKU_CAP_BAND_52GHZ) {
-		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
-			"Please send your %s to maintainer.\n",
-			priv->trans->hw_id_str);
-		priv->hw_params.sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
-	}
-
-	if (iwlwifi_mod_params.disable_5ghz)
-		priv->bands[IEEE80211_BAND_5GHZ].n_channels = 0;
-
-	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
-		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
-
-	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
-
-	return 0;
-}
-
-/*
- * iwl_free_geos - undo allocations in iwl_init_geos
- */
-static void iwl_free_geos(struct iwl_priv *priv)
-{
-	kfree(priv->ieee_channels);
-	kfree(priv->ieee_rates);
-	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
-}
-
 static int iwl_init_drv(struct iwl_priv *priv)
 {
-	int ret;
-
 	spin_lock_init(&priv->sta_lock);
 
 	mutex_init(&priv->mutex);
 
 	INIT_LIST_HEAD(&priv->calib_results);
 
-	priv->ieee_channels = NULL;
-	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
 
 	priv->plcp_delta_threshold =
@@ -1377,31 +1163,11 @@ static int iwl_init_drv(struct iwl_priv *priv)
 		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
 	}
 
-	ret = iwl_init_channel_map(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
-		goto err;
-	}
-
-	ret = iwl_init_geos(priv);
-	if (ret) {
-		IWL_ERR(priv, "initializing geos failed: %d\n", ret);
-		goto err_free_channel_map;
-	}
-	iwl_init_hw_rates(priv->ieee_rates);
-
 	return 0;
-
-err_free_channel_map:
-	iwl_free_channel_map(priv);
-err:
-	return ret;
 }
 
 static void iwl_uninit_drv(struct iwl_priv *priv)
 {
-	iwl_free_geos(priv);
-	iwl_free_channel_map(priv);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
 	kfree(rcu_dereference_raw(priv->noa_data));
@@ -1460,6 +1226,42 @@ static void iwl_option_config(struct iwl_priv *priv)
 #endif
 }
 
+static int iwl_eeprom_init_hw_params(struct iwl_priv *priv)
+{
+	u16 radio_cfg;
+
+	priv->hw_params.sku = priv->eeprom_data->sku;
+
+	if (priv->hw_params.sku & EEPROM_SKU_CAP_11N_ENABLE &&
+	    !priv->cfg->ht_params) {
+		IWL_ERR(priv, "Invalid 11n configuration\n");
+		return -EINVAL;
+	}
+
+	if (!priv->hw_params.sku) {
+		IWL_ERR(priv, "Invalid device sku\n");
+		return -EINVAL;
+	}
+
+	IWL_INFO(priv, "Device SKU: 0x%X\n", priv->hw_params.sku);
+
+	radio_cfg = priv->eeprom_data->radio_cfg;
+
+	priv->hw_params.tx_chains_num =
+		num_of_ant(priv->eeprom_data->valid_tx_ant);
+	if (priv->cfg->rx_with_siso_diversity)
+		priv->hw_params.rx_chains_num = 1;
+	else
+		priv->hw_params.rx_chains_num =
+			num_of_ant(priv->eeprom_data->valid_rx_ant);
+
+	IWL_INFO(priv, "Valid Tx ant: 0x%X, Valid Rx ant: 0x%X\n",
+		 priv->eeprom_data->valid_tx_ant,
+		 priv->eeprom_data->valid_rx_ant);
+
+	return 0;
+}
+
 static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 						 const struct iwl_cfg *cfg,
 						 const struct iwl_fw *fw)
@@ -1605,25 +1407,33 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		goto out_free_hw;
 
 	/* Read the EEPROM */
-	if (iwl_eeprom_init(priv, priv->trans->hw_rev)) {
+	if (iwl_read_eeprom(priv->trans, &priv->eeprom_blob,
+			    &priv->eeprom_blob_size)) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_hw;
 	}
+
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(priv->trans, false);
 
-	if (iwl_eeprom_check_version(priv))
+	priv->eeprom_data = iwl_parse_eeprom_data(priv->trans->dev, priv->cfg,
+						  priv->eeprom_blob,
+						  priv->eeprom_blob_size);
+	if (!priv->eeprom_data)
+		goto out_free_eeprom_blob;
+
+	if (iwl_eeprom_check_version(priv->eeprom_data, priv->trans))
 		goto out_free_eeprom;
 
 	if (iwl_eeprom_init_hw_params(priv))
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
-	iwl_eeprom_get_mac(priv, priv->addresses[0].addr);
+	memcpy(priv->addresses[0].addr, priv->eeprom_data->hw_addr, ETH_ALEN);
 	IWL_DEBUG_INFO(priv, "MAC address: %pM\n", priv->addresses[0].addr);
 	priv->hw->wiphy->addresses = priv->addresses;
 	priv->hw->wiphy->n_addresses = 1;
-	num_mac = iwl_eeprom_query16(priv, EEPROM_NUM_MAC_ADDRESS);
+	num_mac = priv->eeprom_data->n_hw_addrs;
 	if (num_mac > 1) {
 		memcpy(priv->addresses[1].addr, priv->addresses[0].addr,
 		       ETH_ALEN);
@@ -1717,8 +1527,10 @@ out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	iwl_uninit_drv(priv);
+out_free_eeprom_blob:
+	kfree(priv->eeprom_blob);
 out_free_eeprom:
-	iwl_eeprom_free(priv);
+	iwl_free_eeprom_data(priv->eeprom_data);
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
@@ -1743,7 +1555,8 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	priv->ucode_loaded = false;
 	iwl_trans_stop_device(priv->trans);
 
-	iwl_eeprom_free(priv);
+	kfree(priv->eeprom_blob);
+	iwl_free_eeprom_data(priv->eeprom_data);
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index 72c9407..518cf37 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -36,7 +36,6 @@
 #include "iwl-debug.h"
 #include "iwl-trans.h"
 #include "iwl-modparams.h"
-#include "eeprom.h"
 #include "dev.h"
 #include "agn.h"
 #include "commands.h"
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index af10291..6fddd27 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -817,7 +817,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 
 		if (num_of_ant(tbl->ant_type) > 1)
 			tbl->ant_type =
-			    first_antenna(priv->hw_params.valid_tx_ant);
+			    first_antenna(priv->eeprom_data->valid_tx_ant);
 
 		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
@@ -1445,7 +1445,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
@@ -1463,7 +1463,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2 &&
 		    tbl->action != IWL_LEGACY_SWITCH_SISO)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
@@ -1487,7 +1487,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 		else if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_LEGACY_SWITCH_SISO;
 		valid_tx_ant =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 	}
 
 	start_action = tbl->action;
@@ -1621,7 +1621,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
@@ -1639,7 +1639,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
 		/* avoid antenna B and MIMO */
 		valid_tx_ant =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 		if (tbl->action != IWL_SISO_SWITCH_ANTENNA1)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 		break;
@@ -1657,7 +1657,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	/* configure as 1x1 if bt full concurrency */
 	if (priv->bt_full_concurrent) {
 		valid_tx_ant =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 		if (tbl->action >= IWL_LEGACY_SWITCH_ANTENNA2)
 			tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	}
@@ -1793,7 +1793,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	u8 update_search_tbl_counter = 0;
 	int ret;
@@ -1963,7 +1963,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action;
-	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	u8 valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	u8 tx_chains_num = priv->hw_params.tx_chains_num;
 	int ret;
 	u8 update_search_tbl_counter = 0;
@@ -2697,7 +2697,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 
 	i = lq_sta->last_txrate_idx;
 
-	valid_tx_ant = priv->hw_params.valid_tx_ant;
+	valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 
 	if (!lq_sta->search_better_tbl)
 		active_tbl = lq_sta->active_tbl;
@@ -2891,15 +2891,15 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	/* These values will be overridden later */
 	lq_sta->lq.general_params.single_stream_ant_msk =
-		first_antenna(priv->hw_params.valid_tx_ant);
+		first_antenna(priv->eeprom_data->valid_tx_ant);
 	lq_sta->lq.general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
+		priv->eeprom_data->valid_tx_ant &
+		~first_antenna(priv->eeprom_data->valid_tx_ant);
 	if (!lq_sta->lq.general_params.dual_stream_ant_msk) {
 		lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->eeprom_data->valid_tx_ant) == 2) {
 		lq_sta->lq.general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
+			priv->eeprom_data->valid_tx_ant;
 	}
 
 	/* as default allow aggregation for all tids */
@@ -2945,7 +2945,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	if (priv && priv->bt_full_concurrent) {
 		/* 1x1 only */
 		tbl_type.ant_type =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 	}
 
 	/* How many times should we repeat the initial rate? */
@@ -2977,7 +2977,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv->bt_full_concurrent)
 			valid_tx_ant = ANT_A;
 		else
-			valid_tx_ant = priv->hw_params.valid_tx_ant;
+			valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	}
 
 	/* Fill rest of rate table */
@@ -3011,7 +3011,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 		if (priv && priv->bt_full_concurrent) {
 			/* 1x1 only */
 			tbl_type.ant_type =
-			    first_antenna(priv->hw_params.valid_tx_ant);
+			    first_antenna(priv->eeprom_data->valid_tx_ant);
 		}
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -3098,7 +3098,7 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 	u8 ant_sel_tx;
 
 	priv = lq_sta->drv;
-	valid_tx_ant = priv->hw_params.valid_tx_ant;
+	valid_tx_ant = priv->eeprom_data->valid_tx_ant;
 	if (lq_sta->dbg_fixed_rate) {
 		ant_sel_tx =
 		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
@@ -3169,9 +3169,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "fixed rate 0x%X\n",
 			lq_sta->dbg_fixed_rate);
 	desc += sprintf(buff+desc, "valid_tx_ant %s%s%s\n",
-	    (priv->hw_params.valid_tx_ant & ANT_A) ? "ANT_A," : "",
-	    (priv->hw_params.valid_tx_ant & ANT_B) ? "ANT_B," : "",
-	    (priv->hw_params.valid_tx_ant & ANT_C) ? "ANT_C" : "");
+	    (priv->eeprom_data->valid_tx_ant & ANT_A) ? "ANT_A," : "",
+	    (priv->eeprom_data->valid_tx_ant & ANT_B) ? "ANT_B," : "",
+	    (priv->eeprom_data->valid_tx_ant & ANT_C) ? "ANT_C" : "");
 	desc += sprintf(buff+desc, "lq type %s\n",
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index d619802..0ed90bb8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -33,7 +33,6 @@
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 #include "iwl-io.h"
-#include "eeprom.h"
 #include "dev.h"
 #include "calib.h"
 #include "agn.h"
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 4f55689..6ee940f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -420,10 +420,10 @@ static int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (tx_power > priv->tx_power_device_lmt) {
+	if (tx_power > DIV_ROUND_UP(priv->eeprom_data->max_tx_pwr_half_dbm, 2)) {
 		IWL_WARN(priv,
 			"Requested user TXPOWER %d above upper limit %d.\n",
-			 tx_power, priv->tx_power_device_lmt);
+			 tx_power, priv->eeprom_data->max_tx_pwr_half_dbm);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 7ee7f32..2f271c9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -30,7 +30,6 @@
 #include <linux/etherdevice.h>
 #include <net/mac80211.h>
 
-#include "eeprom.h"
 #include "dev.h"
 #include "agn.h"
 
@@ -65,7 +64,6 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	 * to receive scan abort command or it does not perform
 	 * hardware scan currently */
 	if (!test_bit(STATUS_READY, &priv->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
 	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
 	    test_bit(STATUS_FW_ERROR, &priv->status))
 		return -EIO;
@@ -648,12 +646,12 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u16 rx_chain = 0;
 	enum ieee80211_band band;
 	u8 n_probes = 0;
-	u8 rx_ant = priv->hw_params.valid_rx_ant;
+	u8 rx_ant = priv->eeprom_data->valid_rx_ant;
 	u8 rate;
 	bool is_active = false;
 	int  chan_mod;
 	u8 active_chains;
-	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
+	u8 scan_tx_antennas = priv->eeprom_data->valid_tx_ant;
 	int ret;
 	int scan_cmd_size = sizeof(struct iwl_scan_cmd) +
 			    MAX_SCAN_CHANNEL * sizeof(struct iwl_scan_channel) +
@@ -863,7 +861,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	/* MIMO is not used here, but value is required */
 	rx_chain |=
-		priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+		priv->eeprom_data->valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
@@ -980,7 +978,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
-	u8 ant_idx = fls(priv->hw_params.valid_tx_ant) - 1;
+	u8 ant_idx = fls(priv->eeprom_data->valid_tx_ant) - 1;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
 		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = ant_idx;
 	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index c6b343f..286ce4e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -177,17 +177,23 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
 		return false;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (priv->disable_ht40)
+		return false;
+#endif
+
 	/*
-	 * We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
-	 * the bit will not set if it is pure 40MHz case
+	 * Remainder of this function checks ht_cap, but if it's
+	 * NULL then we can do HT40 (special case for RXON)
 	 */
-	if (ht_cap && !ht_cap->ht_supported)
+	if (!ht_cap)
+		return true;
+
+	if (!ht_cap->ht_supported)
 		return false;
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (priv->disable_ht40)
+	if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		return false;
-#endif
 
 	return true;
 }
@@ -627,23 +633,23 @@ static void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
 
-	rate_flags |= first_antenna(priv->hw_params.valid_tx_ant) <<
+	rate_flags |= first_antenna(priv->eeprom_data->valid_tx_ant) <<
 				RATE_MCS_ANT_POS;
 	rate_n_flags = iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		link_cmd->rs_table[i].rate_n_flags = rate_n_flags;
 
 	link_cmd->general_params.single_stream_ant_msk =
-			first_antenna(priv->hw_params.valid_tx_ant);
+			first_antenna(priv->eeprom_data->valid_tx_ant);
 
 	link_cmd->general_params.dual_stream_ant_msk =
-		priv->hw_params.valid_tx_ant &
-		~first_antenna(priv->hw_params.valid_tx_ant);
+		priv->eeprom_data->valid_tx_ant &
+		~first_antenna(priv->eeprom_data->valid_tx_ant);
 	if (!link_cmd->general_params.dual_stream_ant_msk) {
 		link_cmd->general_params.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+	} else if (num_of_ant(priv->eeprom_data->valid_tx_ant) == 2) {
 		link_cmd->general_params.dual_stream_ant_msk =
-			priv->hw_params.valid_tx_ant;
+			priv->eeprom_data->valid_tx_ant;
 	}
 
 	link_cmd->agg_params.agg_dis_start_th =
diff --git a/drivers/net/wireless/iwlwifi/dvm/testmode.c b/drivers/net/wireless/iwlwifi/dvm/testmode.c
index 59cfe9a..a7b5959 100644
--- a/drivers/net/wireless/iwlwifi/dvm/testmode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/testmode.c
@@ -534,9 +534,9 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_EEPROM:
-		if (priv->eeprom) {
+		if (priv->eeprom_blob) {
 			skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy,
-				priv->cfg->base_params->eeprom_size + 20);
+				priv->eeprom_blob_size + 20);
 			if (!skb) {
 				IWL_ERR(priv, "Memory allocation fail\n");
 				return -ENOMEM;
@@ -544,15 +544,15 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 			if (nla_put_u32(skb, IWL_TM_ATTR_COMMAND,
 					IWL_TM_CMD_DEV2APP_EEPROM_RSP) ||
 			    nla_put(skb, IWL_TM_ATTR_EEPROM,
-				    priv->cfg->base_params->eeprom_size,
-				    priv->eeprom))
+				    priv->eeprom_blob_size,
+				    priv->eeprom_blob))
 				goto nla_put_failure;
 			status = cfg80211_testmode_reply(skb);
 			if (status < 0)
 				IWL_ERR(priv, "Error sending msg : %d\n",
 					status);
 		} else
-			return -EFAULT;
+			return -ENODATA;
 		break;
 
 	case IWL_TM_CMD_APP2DEV_FIXRATE_REQ:
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index 5541889..eb86443 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -36,7 +36,6 @@
 #include "iwl-modparams.h"
 #include "iwl-debug.h"
 #include "agn.h"
-#include "eeprom.h"
 #include "dev.h"
 #include "commands.h"
 #include "tt.h"
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 7e3bd62..0dfaf64 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -186,7 +186,8 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	rate_idx = info->control.rates[0].idx;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
 			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
-		rate_idx = rate_lowest_index(&priv->bands[info->band],
+		rate_idx = rate_lowest_index(
+				&priv->eeprom_data->bands[info->band],
 				info->control.sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
@@ -206,10 +207,11 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-				first_antenna(priv->hw_params.valid_tx_ant));
+				first_antenna(priv->eeprom_data->valid_tx_ant));
 	} else
-		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
-						priv->hw_params.valid_tx_ant);
+		priv->mgmt_tx_ant = iwl_toggle_tx_ant(
+					priv, priv->mgmt_tx_ant,
+					priv->eeprom_data->valid_tx_ant);
 	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
 
 	/* Set the rate in the TX cmd */
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 5a2e186..b3a314b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -61,8 +61,7 @@ iwl_get_ucode_image(struct iwl_priv *priv, enum iwl_ucode_type ucode_type)
 static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
-	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_XTAL);
+	__le16 *xtal_calib = priv->eeprom_data->xtal_calib;
 
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
@@ -73,12 +72,10 @@ static int iwl_set_Xtal_calib(struct iwl_priv *priv)
 static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
-	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(*offset_calib));
+	cmd.radio_sensor_offset = priv->eeprom_data->raw_temperature;
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 
@@ -90,27 +87,17 @@ static int iwl_set_temperature_offset_calib(struct iwl_priv *priv)
 static int iwl_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_v2_cmd cmd;
-	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv,
-				     EEPROM_KELVIN_TEMPERATURE);
-	__le16 *offset_calib_low =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
-	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
-							EEPROM_CALIB_ALL);
-	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
-		sizeof(*offset_calib_high));
-	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
-		sizeof(*offset_calib_low));
-	if (!(cmd.radio_sensor_offset_low)) {
+	cmd.radio_sensor_offset_high = priv->eeprom_data->kelvin_temperature;
+	cmd.radio_sensor_offset_low = priv->eeprom_data->raw_temperature;
+	if (!cmd.radio_sensor_offset_low) {
 		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
 		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
 	}
-	memcpy(&cmd.burntVoltageRef, &hdr->voltage,
-		sizeof(hdr->voltage));
+	cmd.burntVoltageRef = priv->eeprom_data->calib_voltage;
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_high));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index af3a461..e9accfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -194,6 +194,24 @@ struct iwl_ht_params {
 	u8 ht40_bands;
 };
 
+/*
+ * information on how to parse the EEPROM
+ */
+#define EEPROM_REG_BAND_1_CHANNELS		0x08
+#define EEPROM_REG_BAND_2_CHANNELS		0x26
+#define EEPROM_REG_BAND_3_CHANNELS		0x42
+#define EEPROM_REG_BAND_4_CHANNELS		0x5C
+#define EEPROM_REG_BAND_5_CHANNELS		0x74
+#define EEPROM_REG_BAND_24_HT40_CHANNELS	0x82
+#define EEPROM_REG_BAND_52_HT40_CHANNELS	0x92
+#define EEPROM_6000_REG_BAND_24_HT40_CHANNELS	0x80
+#define EEPROM_REGULATORY_BAND_NO_HT40		0
+
+struct iwl_eeprom_params {
+	const u8 regulatory_bands[7];
+	bool enhanced_txpower;
+};
+
 /**
  * struct iwl_cfg
  * @name: Offical name of the device
@@ -246,6 +264,7 @@ struct iwl_cfg {
 	/* params likely to change within a device family */
 	const struct iwl_ht_params *ht_params;
 	const struct iwl_bt_params *bt_params;
+	const struct iwl_eeprom_params *eeprom_params;
 	const bool need_temp_offset_calib; /* if used set to true */
 	const bool no_xtal_calib;
 	enum iwl_led_mode led_mode;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index f6bf91c..42b20b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -45,6 +45,7 @@ void __iwl_crit(struct device *dev, const char *fmt, ...) __printf(2, 3);
 
 /* No matter what is m (priv, bus, trans), this will work */
 #define IWL_ERR(m, f, a...) __iwl_err((m)->dev, false, false, f, ## a)
+#define IWL_ERR_DEV(d, f, a...) __iwl_err((d), false, false, f, ## a)
 #define IWL_WARN(m, f, a...) __iwl_warn((m)->dev, f, ## a)
 #define IWL_INFO(m, f, a...) __iwl_info((m)->dev, f, ## a)
 #define IWL_CRIT(m, f, a...) __iwl_crit((m)->dev, f, ## a)
@@ -69,6 +70,8 @@ do {									\
 
 #define IWL_DEBUG(m, level, fmt, args...)				\
 	__iwl_dbg((m)->dev, level, false, __func__, fmt, ##args)
+#define IWL_DEBUG_DEV(dev, level, fmt, args...)				\
+	__iwl_dbg((dev), level, false, __func__, fmt, ##args)
 #define IWL_DEBUG_LIMIT(m, level, fmt, args...)				\
 	__iwl_dbg((m)->dev, level, true, __func__, fmt, ##args)
 
@@ -153,7 +156,7 @@ do {                                            			\
 #define IWL_DEBUG_LED(p, f, a...)	IWL_DEBUG(p, IWL_DL_LED, f, ## a)
 #define IWL_DEBUG_WEP(p, f, a...)	IWL_DEBUG(p, IWL_DL_WEP, f, ## a)
 #define IWL_DEBUG_HC(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD, f, ## a)
-#define IWL_DEBUG_EEPROM(p, f, a...)	IWL_DEBUG(p, IWL_DL_EEPROM, f, ## a)
+#define IWL_DEBUG_EEPROM(d, f, a...)	IWL_DEBUG_DEV(d, IWL_DL_EEPROM, f, ## a)
 #define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
 #define IWL_DEBUG_FW(p, f, a...)	IWL_DEBUG(p, IWL_DL_FW, f, ## a)
 #define IWL_DEBUG_RF_KILL(p, f, a...)	IWL_DEBUG(p, IWL_DL_RF_KILL, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
new file mode 100644
index 0000000..c87a05c
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -0,0 +1,900 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+#include "iwl-eeprom-parse.h"
+
+/* EEPROM offset definitions */
+
+/* indirect access definitions */
+#define ADDRESS_MSK                 0x0000FFFF
+#define INDIRECT_TYPE_MSK           0x000F0000
+#define INDIRECT_HOST               0x00010000
+#define INDIRECT_GENERAL            0x00020000
+#define INDIRECT_REGULATORY         0x00030000
+#define INDIRECT_CALIBRATION        0x00040000
+#define INDIRECT_PROCESS_ADJST      0x00050000
+#define INDIRECT_OTHERS             0x00060000
+#define INDIRECT_TXP_LIMIT          0x00070000
+#define INDIRECT_TXP_LIMIT_SIZE     0x00080000
+#define INDIRECT_ADDRESS            0x00100000
+
+/* corresponding link offsets in EEPROM */
+#define EEPROM_LINK_HOST             (2*0x64)
+#define EEPROM_LINK_GENERAL          (2*0x65)
+#define EEPROM_LINK_REGULATORY       (2*0x66)
+#define EEPROM_LINK_CALIBRATION      (2*0x67)
+#define EEPROM_LINK_PROCESS_ADJST    (2*0x68)
+#define EEPROM_LINK_OTHERS           (2*0x69)
+#define EEPROM_LINK_TXP_LIMIT        (2*0x6a)
+#define EEPROM_LINK_TXP_LIMIT_SIZE   (2*0x6b)
+
+/* General */
+#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
+#define EEPROM_SUBSYSTEM_ID		    (2*0x0A)	/* 2 bytes */
+#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
+#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
+#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
+#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
+#define EEPROM_SKU_CAP                      (2*0x45)	/* 2  bytes */
+#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
+#define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
+#define EEPROM_NUM_MAC_ADDRESS              (2*0x4C)	/* 2  bytes */
+
+/* calibration */
+struct iwl_eeprom_calib_hdr {
+	u8 version;
+	u8 pa_type;
+	__le16 voltage;
+} __packed;
+
+#define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
+#define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
+
+/* temperature */
+#define EEPROM_KELVIN_TEMPERATURE	((2*0x12A) | EEPROM_CALIB_ALL)
+#define EEPROM_RAW_TEMPERATURE		((2*0x12B) | EEPROM_CALIB_ALL)
+
+/*
+ * EEPROM bands
+ * These are the channel numbers from each band in the order
+ * that they are stored in the EEPROM band information. Note
+ * that EEPROM bands aren't the same as mac80211 bands, and
+ * there are even special "ht40 bands" in the EEPROM.
+ */
+static const u8 iwl_eeprom_band_1[14] = { /* 2.4 GHz */
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
+};
+
+static const u8 iwl_eeprom_band_2[] = {	/* 4915-5080MHz */
+	183, 184, 185, 187, 188, 189, 192, 196, 7, 8, 11, 12, 16
+};
+
+static const u8 iwl_eeprom_band_3[] = {	/* 5170-5320MHz */
+	34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
+};
+
+static const u8 iwl_eeprom_band_4[] = {	/* 5500-5700MHz */
+	100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
+};
+
+static const u8 iwl_eeprom_band_5[] = {	/* 5725-5825MHz */
+	145, 149, 153, 157, 161, 165
+};
+
+static const u8 iwl_eeprom_band_6[] = {	/* 2.4 ht40 channel */
+	1, 2, 3, 4, 5, 6, 7
+};
+
+static const u8 iwl_eeprom_band_7[] = {	/* 5.2 ht40 channel */
+	36, 44, 52, 60, 100, 108, 116, 124, 132, 149, 157
+};
+
+#define IWL_NUM_CHANNELS	(ARRAY_SIZE(iwl_eeprom_band_1) + \
+				 ARRAY_SIZE(iwl_eeprom_band_2) + \
+				 ARRAY_SIZE(iwl_eeprom_band_3) + \
+				 ARRAY_SIZE(iwl_eeprom_band_4) + \
+				 ARRAY_SIZE(iwl_eeprom_band_5))
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
+/* EEPROM reading functions */
+
+static u16 iwl_eeprom_query16(const u8 *eeprom, size_t eeprom_size, int offset)
+{
+	if (WARN_ON(offset + sizeof(u16) > eeprom_size))
+		return 0;
+	return le16_to_cpup((__le16 *)(eeprom + offset));
+}
+
+static u32 eeprom_indirect_address(const u8 *eeprom, size_t eeprom_size,
+				   u32 address)
+{
+	u16 offset = 0;
+
+	if ((address & INDIRECT_ADDRESS) == 0)
+		return address;
+
+	switch (address & INDIRECT_TYPE_MSK) {
+	case INDIRECT_HOST:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_HOST);
+		break;
+	case INDIRECT_GENERAL:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_GENERAL);
+		break;
+	case INDIRECT_REGULATORY:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_REGULATORY);
+		break;
+	case INDIRECT_TXP_LIMIT:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_TXP_LIMIT);
+		break;
+	case INDIRECT_TXP_LIMIT_SIZE:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_TXP_LIMIT_SIZE);
+		break;
+	case INDIRECT_CALIBRATION:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_CALIBRATION);
+		break;
+	case INDIRECT_PROCESS_ADJST:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_PROCESS_ADJST);
+		break;
+	case INDIRECT_OTHERS:
+		offset = iwl_eeprom_query16(eeprom, eeprom_size,
+					    EEPROM_LINK_OTHERS);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	/* translate the offset from words to byte */
+	return (address & ADDRESS_MSK) + (offset << 1);
+}
+
+static const u8 *iwl_eeprom_query_addr(const u8 *eeprom, size_t eeprom_size,
+				       u32 offset)
+{
+	u32 address = eeprom_indirect_address(eeprom, eeprom_size, offset);
+
+	if (WARN_ON(address >= eeprom_size))
+		return NULL;
+
+	return &eeprom[address];
+}
+
+static int iwl_eeprom_read_calib(const u8 *eeprom, size_t eeprom_size,
+				 struct iwl_eeprom_data *data)
+{
+	struct iwl_eeprom_calib_hdr *hdr;
+
+	hdr = (void *)iwl_eeprom_query_addr(eeprom, eeprom_size,
+					    EEPROM_CALIB_ALL);
+	if (!hdr)
+		return -ENODATA;
+	data->calib_version = hdr->version;
+	data->calib_voltage = hdr->voltage;
+
+	return 0;
+}
+
+/**
+ * enum iwl_eeprom_channel_flags - channel flags in EEPROM
+ * @EEPROM_CHANNEL_VALID: channel is usable for this SKU/geo
+ * @EEPROM_CHANNEL_IBSS: usable as an IBSS channel
+ * @EEPROM_CHANNEL_ACTIVE: active scanning allowed
+ * @EEPROM_CHANNEL_RADAR: radar detection required
+ * @EEPROM_CHANNEL_WIDE: 20 MHz channel okay (?)
+ * @EEPROM_CHANNEL_DFS: dynamic freq selection candidate
+ */
+enum iwl_eeprom_channel_flags {
+	EEPROM_CHANNEL_VALID = BIT(0),
+	EEPROM_CHANNEL_IBSS = BIT(1),
+	EEPROM_CHANNEL_ACTIVE = BIT(3),
+	EEPROM_CHANNEL_RADAR = BIT(4),
+	EEPROM_CHANNEL_WIDE = BIT(5),
+	EEPROM_CHANNEL_DFS = BIT(7),
+};
+
+/**
+ * struct iwl_eeprom_channel - EEPROM channel data
+ * @flags: %EEPROM_CHANNEL_* flags
+ * @max_power_avg: max power (in dBm) on this channel, at most 31 dBm
+ */
+struct iwl_eeprom_channel {
+	u8 flags;
+	s8 max_power_avg;
+} __packed;
+
+
+enum iwl_eeprom_enhanced_txpwr_flags {
+	IWL_EEPROM_ENH_TXP_FL_VALID = BIT(0),
+	IWL_EEPROM_ENH_TXP_FL_BAND_52G = BIT(1),
+	IWL_EEPROM_ENH_TXP_FL_OFDM = BIT(2),
+	IWL_EEPROM_ENH_TXP_FL_40MHZ = BIT(3),
+	IWL_EEPROM_ENH_TXP_FL_HT_AP = BIT(4),
+	IWL_EEPROM_ENH_TXP_FL_RES1 = BIT(5),
+	IWL_EEPROM_ENH_TXP_FL_RES2 = BIT(6),
+	IWL_EEPROM_ENH_TXP_FL_COMMON_TYPE = BIT(7),
+};
+
+/**
+ * iwl_eeprom_enhanced_txpwr structure
+ * @flags: entry flags
+ * @channel: channel number
+ * @chain_a_max_pwr: chain a max power in 1/2 dBm
+ * @chain_b_max_pwr: chain b max power in 1/2 dBm
+ * @chain_c_max_pwr: chain c max power in 1/2 dBm
+ * @delta_20_in_40: 20-in-40 deltas (hi/lo)
+ * @mimo2_max_pwr: mimo2 max power in 1/2 dBm
+ * @mimo3_max_pwr: mimo3 max power in 1/2 dBm
+ *
+ * This structure presents the enhanced regulatory tx power limit layout
+ * in an EEPROM image.
+ */
+struct iwl_eeprom_enhanced_txpwr {
+	u8 flags;
+	u8 channel;
+	s8 chain_a_max;
+	s8 chain_b_max;
+	s8 chain_c_max;
+	u8 delta_20_in_40;
+	s8 mimo2_max;
+	s8 mimo3_max;
+} __packed;
+
+static s8 iwl_get_max_txpwr_half_dbm(const struct iwl_eeprom_data *data,
+				     struct iwl_eeprom_enhanced_txpwr *txp)
+{
+	s8 result = 0; /* (.5 dBm) */
+
+	/* Take the highest tx power from any valid chains */
+	if (data->valid_tx_ant & ANT_A && txp->chain_a_max > result)
+		result = txp->chain_a_max;
+
+	if (data->valid_tx_ant & ANT_B && txp->chain_b_max > result)
+		result = txp->chain_b_max;
+
+	if (data->valid_tx_ant & ANT_C && txp->chain_c_max > result)
+		result = txp->chain_c_max;
+
+	if ((data->valid_tx_ant == ANT_AB ||
+	     data->valid_tx_ant == ANT_BC ||
+	     data->valid_tx_ant == ANT_AC) && txp->mimo2_max > result)
+		result = txp->mimo2_max;
+
+	if (data->valid_tx_ant == ANT_ABC && txp->mimo3_max > result)
+		result = txp->mimo3_max;
+
+	return result;
+}
+
+#define EEPROM_TXP_OFFS	(0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT)
+#define EEPROM_TXP_ENTRY_LEN sizeof(struct iwl_eeprom_enhanced_txpwr)
+#define EEPROM_TXP_SZ_OFFS (0x00 | INDIRECT_ADDRESS | INDIRECT_TXP_LIMIT_SIZE)
+
+#define TXP_CHECK_AND_PRINT(x) \
+	((txp->flags & IWL_EEPROM_ENH_TXP_FL_##x) ? # x " " : "")
+
+static void
+iwl_eeprom_enh_txp_read_element(struct iwl_eeprom_data *data,
+				struct iwl_eeprom_enhanced_txpwr *txp,
+				int n_channels, s8 max_txpower_avg)
+{
+	int ch_idx;
+	enum ieee80211_band band;
+
+	band = txp->flags & IWL_EEPROM_ENH_TXP_FL_BAND_52G ?
+		IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+
+	for (ch_idx = 0; ch_idx < n_channels; ch_idx++) {
+		struct ieee80211_channel *chan = &data->channels[ch_idx];
+
+		/* update matching channel or from common data only */
+		if (txp->channel != 0 && chan->hw_value != txp->channel)
+			continue;
+
+		/* update matching band only */
+		if (band != chan->band)
+			continue;
+
+		if (chan->max_power < max_txpower_avg &&
+		    !(txp->flags & IWL_EEPROM_ENH_TXP_FL_40MHZ))
+			chan->max_power = max_txpower_avg;
+	}
+}
+
+static void iwl_eeprom_enhanced_txpower(struct device *dev,
+					struct iwl_eeprom_data *data,
+					const u8 *eeprom, size_t eeprom_size,
+					int n_channels)
+{
+	struct iwl_eeprom_enhanced_txpwr *txp_array, *txp;
+	int idx, entries;
+	__le16 *txp_len;
+	s8 max_txp_avg_halfdbm;
+
+	BUILD_BUG_ON(sizeof(struct iwl_eeprom_enhanced_txpwr) != 8);
+
+	/* the length is in 16-bit words, but we want entries */
+	txp_len = (__le16 *)iwl_eeprom_query_addr(eeprom, eeprom_size,
+						  EEPROM_TXP_SZ_OFFS);
+	entries = le16_to_cpup(txp_len) * 2 / EEPROM_TXP_ENTRY_LEN;
+
+	txp_array = (void *)iwl_eeprom_query_addr(eeprom, eeprom_size,
+						  EEPROM_TXP_OFFS);
+
+	for (idx = 0; idx < entries; idx++) {
+		txp = &txp_array[idx];
+		/* skip invalid entries */
+		if (!(txp->flags & IWL_EEPROM_ENH_TXP_FL_VALID))
+			continue;
+
+		IWL_DEBUG_EEPROM(dev, "%s %d:\t %s%s%s%s%s%s%s%s (0x%02x)\n",
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
+		IWL_DEBUG_EEPROM(dev,
+				 "\t\t chain_A: 0x%02x chain_B: 0X%02x chain_C: 0X%02x\n",
+				 txp->chain_a_max, txp->chain_b_max,
+				 txp->chain_c_max);
+		IWL_DEBUG_EEPROM(dev,
+				 "\t\t MIMO2: 0x%02x MIMO3: 0x%02x High 20_on_40: 0x%02x Low 20_on_40: 0x%02x\n",
+				 txp->mimo2_max, txp->mimo3_max,
+				 ((txp->delta_20_in_40 & 0xf0) >> 4),
+				 (txp->delta_20_in_40 & 0x0f));
+
+		max_txp_avg_halfdbm = iwl_get_max_txpwr_half_dbm(data, txp);
+
+		iwl_eeprom_enh_txp_read_element(data, txp, n_channels,
+				DIV_ROUND_UP(max_txp_avg_halfdbm, 2));
+
+		if (max_txp_avg_halfdbm > data->max_tx_pwr_half_dbm)
+			data->max_tx_pwr_half_dbm = max_txp_avg_halfdbm;
+	}
+}
+
+static void iwl_init_band_reference(const struct iwl_cfg *cfg,
+				    const u8 *eeprom, size_t eeprom_size,
+				    int eeprom_band, int *eeprom_ch_count,
+				    const struct iwl_eeprom_channel **ch_info,
+				    const u8 **eeprom_ch_array)
+{
+	u32 offset = cfg->eeprom_params->regulatory_bands[eeprom_band - 1];
+
+	offset |= INDIRECT_ADDRESS | INDIRECT_REGULATORY;
+
+	*ch_info = (void *)iwl_eeprom_query_addr(eeprom, eeprom_size, offset);
+
+	switch (eeprom_band) {
+	case 1:		/* 2.4GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_1);
+		*eeprom_ch_array = iwl_eeprom_band_1;
+		break;
+	case 2:		/* 4.9GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_2);
+		*eeprom_ch_array = iwl_eeprom_band_2;
+		break;
+	case 3:		/* 5.2GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_3);
+		*eeprom_ch_array = iwl_eeprom_band_3;
+		break;
+	case 4:		/* 5.5GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_4);
+		*eeprom_ch_array = iwl_eeprom_band_4;
+		break;
+	case 5:		/* 5.7GHz band */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_5);
+		*eeprom_ch_array = iwl_eeprom_band_5;
+		break;
+	case 6:		/* 2.4GHz ht40 channels */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_6);
+		*eeprom_ch_array = iwl_eeprom_band_6;
+		break;
+	case 7:		/* 5 GHz ht40 channels */
+		*eeprom_ch_count = ARRAY_SIZE(iwl_eeprom_band_7);
+		*eeprom_ch_array = iwl_eeprom_band_7;
+		break;
+	default:
+		*eeprom_ch_count = 0;
+		*eeprom_ch_array = NULL;
+		WARN_ON(1);
+	}
+}
+
+#define CHECK_AND_PRINT(x) \
+	((eeprom_ch->flags & EEPROM_CHANNEL_##x) ? # x " " : "")
+
+static void iwl_mod_ht40_chan_info(struct device *dev,
+				   struct iwl_eeprom_data *data, int n_channels,
+				   enum ieee80211_band band, u16 channel,
+				   const struct iwl_eeprom_channel *eeprom_ch,
+				   u8 clear_ht40_extension_channel)
+{
+	struct ieee80211_channel *chan = NULL;
+	int i;
+
+	for (i = 0; i < n_channels; i++) {
+		if (data->channels[i].band != band)
+			continue;
+		if (data->channels[i].hw_value != channel)
+			continue;
+		chan = &data->channels[i];
+		break;
+	}
+
+	if (!chan)
+		return;
+
+	IWL_DEBUG_EEPROM(dev,
+			 "HT40 Ch. %d [%sGHz] %s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
+			 channel,
+			 band == IEEE80211_BAND_5GHZ ? "5.2" : "2.4",
+			 CHECK_AND_PRINT(IBSS),
+			 CHECK_AND_PRINT(ACTIVE),
+			 CHECK_AND_PRINT(RADAR),
+			 CHECK_AND_PRINT(WIDE),
+			 CHECK_AND_PRINT(DFS),
+			 eeprom_ch->flags,
+			 eeprom_ch->max_power_avg,
+			 ((eeprom_ch->flags & EEPROM_CHANNEL_IBSS) &&
+			  !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ? ""
+								      : "not ");
+
+	if (eeprom_ch->flags & EEPROM_CHANNEL_VALID)
+		chan->flags &= ~clear_ht40_extension_channel;
+}
+
+#define CHECK_AND_PRINT_I(x)	\
+	((eeprom_ch_info[ch_idx].flags & EEPROM_CHANNEL_##x) ? # x " " : "")
+
+static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
+				struct iwl_eeprom_data *data,
+				const u8 *eeprom, size_t eeprom_size)
+{
+	int band, ch_idx;
+	const struct iwl_eeprom_channel *eeprom_ch_info;
+	const u8 *eeprom_ch_array;
+	int eeprom_ch_count;
+	int n_channels = 0;
+
+	/*
+	 * Loop through the 5 EEPROM bands and add them to the parse list
+	 */
+	for (band = 1; band <= 5; band++) {
+		struct ieee80211_channel *channel;
+
+		iwl_init_band_reference(cfg, eeprom, eeprom_size, band,
+					&eeprom_ch_count, &eeprom_ch_info,
+					&eeprom_ch_array);
+
+		/* Loop through each band adding each of the channels */
+		for (ch_idx = 0; ch_idx < eeprom_ch_count; ch_idx++) {
+			const struct iwl_eeprom_channel *eeprom_ch;
+
+			eeprom_ch = &eeprom_ch_info[ch_idx];
+
+			if (!(eeprom_ch->flags & EEPROM_CHANNEL_VALID)) {
+				IWL_DEBUG_EEPROM(dev,
+						 "Ch. %d Flags %x [%sGHz] - No traffic\n",
+						 eeprom_ch_array[ch_idx],
+						 eeprom_ch_info[ch_idx].flags,
+						 (band != 1) ? "5.2" : "2.4");
+				continue;
+			}
+
+			channel = &data->channels[n_channels];
+			n_channels++;
+
+			channel->hw_value = eeprom_ch_array[ch_idx];
+			channel->band = (band == 1) ? IEEE80211_BAND_2GHZ
+						    : IEEE80211_BAND_5GHZ;
+			channel->center_freq =
+				ieee80211_channel_to_frequency(
+					channel->hw_value, channel->band);
+
+			/* set no-HT40, will enable as appropriate later */
+			channel->flags = IEEE80211_CHAN_NO_HT40;
+
+			if (!(eeprom_ch->flags & EEPROM_CHANNEL_IBSS))
+				channel->flags |= IEEE80211_CHAN_NO_IBSS;
+
+			if (!(eeprom_ch->flags & EEPROM_CHANNEL_ACTIVE))
+				channel->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+
+			if (eeprom_ch->flags & EEPROM_CHANNEL_RADAR)
+				channel->flags |= IEEE80211_CHAN_RADAR;
+
+			/* Initialize regulatory-based run-time data */
+			channel->max_power =
+				eeprom_ch_info[ch_idx].max_power_avg;
+			IWL_DEBUG_EEPROM(dev,
+					 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
+					 channel->hw_value,
+					 (band != 1) ? "5.2" : "2.4",
+					 CHECK_AND_PRINT_I(VALID),
+					 CHECK_AND_PRINT_I(IBSS),
+					 CHECK_AND_PRINT_I(ACTIVE),
+					 CHECK_AND_PRINT_I(RADAR),
+					 CHECK_AND_PRINT_I(WIDE),
+					 CHECK_AND_PRINT_I(DFS),
+					 eeprom_ch_info[ch_idx].flags,
+					 eeprom_ch_info[ch_idx].max_power_avg,
+					 ((eeprom_ch_info[ch_idx].flags &
+							EEPROM_CHANNEL_IBSS) &&
+					  !(eeprom_ch_info[ch_idx].flags &
+							EEPROM_CHANNEL_RADAR))
+						? "" : "not ");
+		}
+	}
+
+	if (cfg->eeprom_params->enhanced_txpower) {
+		/*
+		 * for newer device (6000 series and up)
+		 * EEPROM contain enhanced tx power information
+		 * driver need to process addition information
+		 * to determine the max channel tx power limits
+		 */
+		iwl_eeprom_enhanced_txpower(dev, data, eeprom, eeprom_size,
+					    n_channels);
+	} else {
+		/* All others use data from channel map */
+		int i;
+
+		data->max_tx_pwr_half_dbm = -128;
+
+		for (i = 0; i < n_channels; i++)
+			data->max_tx_pwr_half_dbm =
+				max_t(s8, data->max_tx_pwr_half_dbm,
+				      data->channels[i].max_power * 2);
+	}
+
+	/* Check if we do have HT40 channels */
+	if (cfg->eeprom_params->regulatory_bands[5] ==
+				EEPROM_REGULATORY_BAND_NO_HT40 &&
+	    cfg->eeprom_params->regulatory_bands[6] ==
+				EEPROM_REGULATORY_BAND_NO_HT40)
+		return n_channels;
+
+	/* Two additional EEPROM bands for 2.4 and 5 GHz HT40 channels */
+	for (band = 6; band <= 7; band++) {
+		enum ieee80211_band ieeeband;
+
+		iwl_init_band_reference(cfg, eeprom, eeprom_size, band,
+					&eeprom_ch_count, &eeprom_ch_info,
+					&eeprom_ch_array);
+
+		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
+		ieeeband = (band == 6) ? IEEE80211_BAND_2GHZ
+				       : IEEE80211_BAND_5GHZ;
+
+		/* Loop through each band adding each of the channels */
+		for (ch_idx = 0; ch_idx < eeprom_ch_count; ch_idx++) {
+			/* Set up driver's info for lower half */
+			iwl_mod_ht40_chan_info(dev, data, n_channels, ieeeband,
+					       eeprom_ch_array[ch_idx],
+					       &eeprom_ch_info[ch_idx],
+					       IEEE80211_CHAN_NO_HT40PLUS);
+
+			/* Set up driver's info for upper half */
+			iwl_mod_ht40_chan_info(dev, data, n_channels, ieeeband,
+					       eeprom_ch_array[ch_idx] + 4,
+					       &eeprom_ch_info[ch_idx],
+					       IEEE80211_CHAN_NO_HT40MINUS);
+		}
+	}
+
+	return n_channels;
+}
+
+static int iwl_init_sband_channels(struct iwl_eeprom_data *data,
+				   struct ieee80211_supported_band *sband,
+				   int n_channels, enum ieee80211_band band)
+{
+	struct ieee80211_channel *chan = &data->channels[0];
+	int n = 0, idx = 0;
+
+	while (chan->band != band && idx < n_channels)
+		chan = &data->channels[++idx];
+
+	sband->channels = &data->channels[idx];
+
+	while (chan->band == band && idx < n_channels) {
+		chan = &data->channels[++idx];
+		n++;
+	}
+
+	sband->n_channels = n;
+
+	return n;
+}
+
+#define MAX_BIT_RATE_40_MHZ	150 /* Mbps */
+#define MAX_BIT_RATE_20_MHZ	72 /* Mbps */
+
+static void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
+				 struct iwl_eeprom_data *data,
+				 struct ieee80211_sta_ht_cap *ht_info,
+				 enum ieee80211_band band)
+{
+	int max_bit_rate = 0;
+	u8 rx_chains;
+	u8 tx_chains;
+
+	tx_chains = hweight8(data->valid_tx_ant);
+	if (cfg->rx_with_siso_diversity)
+		rx_chains = 1;
+	else
+		rx_chains = hweight8(data->valid_rx_ant);
+
+	if (!(data->sku & EEPROM_SKU_CAP_11N_ENABLE) || !cfg->ht_params) {
+		ht_info->ht_supported = false;
+		return;
+	}
+
+	ht_info->ht_supported = true;
+	ht_info->cap = 0;
+
+	if (iwlwifi_mod_params.amsdu_size_8K)
+		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+
+	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_4;
+
+	ht_info->mcs.rx_mask[0] = 0xFF;
+	if (rx_chains >= 2)
+		ht_info->mcs.rx_mask[1] = 0xFF;
+	if (rx_chains >= 3)
+		ht_info->mcs.rx_mask[2] = 0xFF;
+
+	if (cfg->ht_params->ht_greenfield_support)
+		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
+	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
+
+	max_bit_rate = MAX_BIT_RATE_20_MHZ;
+
+	if (cfg->ht_params->ht40_bands & BIT(band)) {
+		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
+		ht_info->mcs.rx_mask[4] = 0x01;
+		max_bit_rate = MAX_BIT_RATE_40_MHZ;
+	}
+
+	/* Highest supported Rx data rate */
+	max_bit_rate *= rx_chains;
+	WARN_ON(max_bit_rate & ~IEEE80211_HT_MCS_RX_HIGHEST_MASK);
+	ht_info->mcs.rx_highest = cpu_to_le16(max_bit_rate);
+
+	/* Tx MCS capabilities */
+	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	if (tx_chains != rx_chains) {
+		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		ht_info->mcs.tx_params |= ((tx_chains - 1) <<
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	}
+}
+
+static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
+			    struct iwl_eeprom_data *data,
+			    const u8 *eeprom, size_t eeprom_size)
+{
+	int n_channels = iwl_init_channel_map(dev, cfg, data,
+					      eeprom, eeprom_size);
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
+		IWL_ERR_DEV(dev, "EEPROM: used only %d of %d channels\n",
+			    n_used, n_channels);
+}
+
+/* EEPROM data functions */
+
+struct iwl_eeprom_data *
+iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
+		      const u8 *eeprom, size_t eeprom_size)
+{
+	struct iwl_eeprom_data *data;
+	const void *tmp;
+
+	if (WARN_ON(!cfg || !cfg->eeprom_params))
+		return NULL;
+
+	data = kzalloc(sizeof(*data) +
+		       sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
+		       GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	/* get MAC address(es) */
+	tmp = iwl_eeprom_query_addr(eeprom, eeprom_size, EEPROM_MAC_ADDRESS);
+	if (!tmp)
+		goto err_free;
+	memcpy(data->hw_addr, tmp, ETH_ALEN);
+	data->n_hw_addrs = iwl_eeprom_query16(eeprom, eeprom_size,
+					      EEPROM_NUM_MAC_ADDRESS);
+
+	if (iwl_eeprom_read_calib(eeprom, eeprom_size, data))
+		goto err_free;
+
+	tmp = iwl_eeprom_query_addr(eeprom, eeprom_size, EEPROM_XTAL);
+	if (!tmp)
+		goto err_free;
+	memcpy(data->xtal_calib, tmp, sizeof(data->xtal_calib));
+
+	tmp = iwl_eeprom_query_addr(eeprom, eeprom_size,
+				    EEPROM_RAW_TEMPERATURE);
+	if (!tmp)
+		goto err_free;
+	data->raw_temperature = *(__le16 *)tmp;
+
+	tmp = iwl_eeprom_query_addr(eeprom, eeprom_size,
+				    EEPROM_KELVIN_TEMPERATURE);
+	if (!tmp)
+		goto err_free;
+	data->kelvin_temperature = *(__le16 *)tmp;
+	data->kelvin_voltage = *((__le16 *)tmp + 1);
+
+	data->radio_cfg = iwl_eeprom_query16(eeprom, eeprom_size,
+					     EEPROM_RADIO_CONFIG);
+	data->sku = iwl_eeprom_query16(eeprom, eeprom_size,
+				       EEPROM_SKU_CAP);
+	data->eeprom_version = iwl_eeprom_query16(eeprom, eeprom_size,
+						  EEPROM_VERSION);
+
+	data->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(data->radio_cfg);
+	data->valid_rx_ant = EEPROM_RF_CFG_RX_ANT_MSK(data->radio_cfg);
+
+	/* check overrides (some devices have wrong EEPROM) */
+	if (cfg->valid_tx_ant)
+		data->valid_tx_ant = cfg->valid_tx_ant;
+	if (cfg->valid_rx_ant)
+		data->valid_rx_ant = cfg->valid_rx_ant;
+
+	if (!data->valid_tx_ant || !data->valid_rx_ant) {
+		IWL_ERR_DEV(dev, "invalid antennas (0x%x, 0x%x)\n",
+			    data->valid_tx_ant, data->valid_rx_ant);
+		goto err_free;
+	}
+
+	iwl_init_sbands(dev, cfg, data, eeprom, eeprom_size);
+
+	return data;
+ err_free:
+	kfree(data);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iwl_parse_eeprom_data);
+
+/* helper functions */
+int iwl_eeprom_check_version(struct iwl_eeprom_data *data,
+			     struct iwl_trans *trans)
+{
+	if (data->eeprom_version >= trans->cfg->eeprom_ver ||
+	    data->calib_version >= trans->cfg->eeprom_calib_ver) {
+		IWL_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+			 data->eeprom_version, data->calib_version);
+		return 0;
+	}
+
+	IWL_ERR(trans,
+		"Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+		data->eeprom_version, trans->cfg->eeprom_ver,
+		data->calib_version,  trans->cfg->eeprom_calib_ver);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(iwl_eeprom_check_version);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
new file mode 100644
index 0000000..9c07c67
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -0,0 +1,138 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+#ifndef __iwl_eeprom_parse_h__
+#define __iwl_eeprom_parse_h__
+
+#include <linux/types.h>
+#include <linux/if_ether.h>
+#include "iwl-trans.h"
+
+/* SKU Capabilities (actual values from EEPROM definition) */
+#define EEPROM_SKU_CAP_BAND_24GHZ	(1 << 4)
+#define EEPROM_SKU_CAP_BAND_52GHZ	(1 << 5)
+#define EEPROM_SKU_CAP_11N_ENABLE	(1 << 6)
+#define EEPROM_SKU_CAP_AMT_ENABLE	(1 << 7)
+#define EEPROM_SKU_CAP_IPAN_ENABLE	(1 << 8)
+
+/* radio config bits (actual values from EEPROM definition) */
+#define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
+#define EEPROM_RF_CFG_STEP_MSK(x)   ((x >> 2)  & 0x3) /* bits 2-3   */
+#define EEPROM_RF_CFG_DASH_MSK(x)   ((x >> 4)  & 0x3) /* bits 4-5   */
+#define EEPROM_RF_CFG_PNUM_MSK(x)   ((x >> 6)  & 0x3) /* bits 6-7   */
+#define EEPROM_RF_CFG_TX_ANT_MSK(x) ((x >> 8)  & 0xF) /* bits 8-11  */
+#define EEPROM_RF_CFG_RX_ANT_MSK(x) ((x >> 12) & 0xF) /* bits 12-15 */
+
+struct iwl_eeprom_data {
+	int n_hw_addrs;
+	u8 hw_addr[ETH_ALEN];
+
+	u16 radio_config;
+
+	u8 calib_version;
+	__le16 calib_voltage;
+
+	__le16 raw_temperature;
+	__le16 kelvin_temperature;
+	__le16 kelvin_voltage;
+	__le16 xtal_calib[2];
+
+	u16 sku;
+	u16 radio_cfg;
+	u16 eeprom_version;
+	s8 max_tx_pwr_half_dbm;
+
+	u8 valid_tx_ant, valid_rx_ant;
+
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_channel channels[];
+};
+
+/**
+ * iwl_parse_eeprom_data - parse EEPROM data and return values
+ *
+ * @dev: device pointer we're parsing for, for debug only
+ * @cfg: device configuration for parsing and overrides
+ * @eeprom: the EEPROM data
+ * @eeprom_size: length of the EEPROM data
+ *
+ * This function parses all EEPROM values we need and then
+ * returns a (newly allocated) struct containing all the
+ * relevant values for driver use. The struct must be freed
+ * later with iwl_free_eeprom_data().
+ */
+struct iwl_eeprom_data *
+iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
+		      const u8 *eeprom, size_t eeprom_size);
+
+/**
+ * iwl_free_eeprom_data - free EEPROM data
+ * @data: the data to free
+ */
+static inline void iwl_free_eeprom_data(struct iwl_eeprom_data *data)
+{
+	kfree(data);
+}
+
+int iwl_eeprom_check_version(struct iwl_eeprom_data *data,
+			     struct iwl_trans *trans);
+
+#endif /* __iwl_eeprom_parse_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
new file mode 100644
index 0000000..27c7da3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
@@ -0,0 +1,463 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+
+#include "iwl-debug.h"
+#include "iwl-eeprom-read.h"
+#include "iwl-io.h"
+#include "iwl-prph.h"
+#include "iwl-csr.h"
+
+/*
+ * EEPROM access time values:
+ *
+ * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG.
+ * Driver then polls CSR_EEPROM_REG for CSR_EEPROM_REG_READ_VALID_MSK (0x1).
+ * When polling, wait 10 uSec between polling loops, up to a maximum 5000 uSec.
+ * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
+ */
+#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
+
+#define IWL_EEPROM_SEM_TIMEOUT		10   /* microseconds */
+#define IWL_EEPROM_SEM_RETRY_LIMIT	1000 /* number of attempts (not time) */
+
+
+/*
+ * The device's EEPROM semaphore prevents conflicts between driver and uCode
+ * when accessing the EEPROM; each access is a series of pulses to/from the
+ * EEPROM chip, not a single event, so even reads could conflict if they
+ * weren't arbitrated by the semaphore.
+ */
+
+#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
+#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
+
+static int iwl_eeprom_acquire_semaphore(struct iwl_trans *trans)
+{
+	u16 count;
+	int ret;
+
+	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
+		/* Request semaphore */
+		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
+			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+
+		/* See if we got it */
+		ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
+				EEPROM_SEM_TIMEOUT);
+		if (ret >= 0) {
+			IWL_DEBUG_EEPROM(trans->dev,
+					 "Acquired semaphore after %d tries.\n",
+					 count+1);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
+{
+	iwl_clear_bit(trans, CSR_HW_IF_CONFIG_REG,
+		      CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
+}
+
+static int iwl_eeprom_verify_signature(struct iwl_trans *trans, bool nvm_is_otp)
+{
+	u32 gp = iwl_read32(trans, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+
+	IWL_DEBUG_EEPROM(trans->dev, "EEPROM signature=0x%08x\n", gp);
+
+	switch (gp) {
+	case CSR_EEPROM_GP_BAD_SIG_EEP_GOOD_SIG_OTP:
+		if (!nvm_is_otp) {
+			IWL_ERR(trans, "EEPROM with bad signature: 0x%08x\n",
+				gp);
+			return -ENOENT;
+		}
+		return 0;
+	case CSR_EEPROM_GP_GOOD_SIG_EEP_LESS_THAN_4K:
+	case CSR_EEPROM_GP_GOOD_SIG_EEP_MORE_THAN_4K:
+		if (nvm_is_otp) {
+			IWL_ERR(trans, "OTP with bad signature: 0x%08x\n", gp);
+			return -ENOENT;
+		}
+		return 0;
+	case CSR_EEPROM_GP_BAD_SIGNATURE_BOTH_EEP_AND_OTP:
+	default:
+		IWL_ERR(trans,
+			"bad EEPROM/OTP signature, type=%s, EEPROM_GP=0x%08x\n",
+			nvm_is_otp ? "OTP" : "EEPROM", gp);
+		return -ENOENT;
+	}
+}
+
+/******************************************************************************
+ *
+ * OTP related functions
+ *
+******************************************************************************/
+
+static void iwl_set_otp_access_absolute(struct iwl_trans *trans)
+{
+	iwl_read32(trans, CSR_OTP_GP_REG);
+
+	iwl_clear_bit(trans, CSR_OTP_GP_REG,
+		      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+}
+
+static int iwl_nvm_is_otp(struct iwl_trans *trans)
+{
+	u32 otpgp;
+
+	/* OTP only valid for CP/PP and after */
+	switch (trans->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_NONE:
+		IWL_ERR(trans, "Unknown hardware type\n");
+		return -EIO;
+	case CSR_HW_REV_TYPE_5300:
+	case CSR_HW_REV_TYPE_5350:
+	case CSR_HW_REV_TYPE_5100:
+	case CSR_HW_REV_TYPE_5150:
+		return 0;
+	default:
+		otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
+		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
+			return 1;
+		return 0;
+	}
+}
+
+static int iwl_init_otp_access(struct iwl_trans *trans)
+{
+	int ret;
+
+	/* Enable 40MHz radio clock */
+	iwl_write32(trans, CSR_GP_CNTRL,
+		    iwl_read32(trans, CSR_GP_CNTRL) |
+		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/* wait for clock to be ready */
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			   25000);
+	if (ret < 0) {
+		IWL_ERR(trans, "Time out access OTP\n");
+	} else {
+		iwl_set_bits_prph(trans, APMG_PS_CTRL_REG,
+				  APMG_PS_CTRL_VAL_RESET_REQ);
+		udelay(5);
+		iwl_clear_bits_prph(trans, APMG_PS_CTRL_REG,
+				    APMG_PS_CTRL_VAL_RESET_REQ);
+
+		/*
+		 * CSR auto clock gate disable bit -
+		 * this is only applicable for HW with OTP shadow RAM
+		 */
+		if (trans->cfg->base_params->shadow_ram_support)
+			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+	}
+	return ret;
+}
+
+static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
+			     __le16 *eeprom_data)
+{
+	int ret = 0;
+	u32 r;
+	u32 otpgp;
+
+	iwl_write32(trans, CSR_EEPROM_REG,
+		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+	ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
+				 CSR_EEPROM_REG_READ_VALID_MSK,
+				 CSR_EEPROM_REG_READ_VALID_MSK,
+				 IWL_EEPROM_ACCESS_TIMEOUT);
+	if (ret < 0) {
+		IWL_ERR(trans, "Time out reading OTP[%d]\n", addr);
+		return ret;
+	}
+	r = iwl_read32(trans, CSR_EEPROM_REG);
+	/* check for ECC errors: */
+	otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
+	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
+		/* stop in this case */
+		/* set the uncorrectable OTP ECC bit for acknowledgement */
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
+			    CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+		IWL_ERR(trans, "Uncorrectable OTP ECC error, abort OTP read\n");
+		return -EINVAL;
+	}
+	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
+		/* continue in this case */
+		/* set the correctable OTP ECC bit for acknowledgement */
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
+			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
+		IWL_ERR(trans, "Correctable OTP ECC error, continue read\n");
+	}
+	*eeprom_data = cpu_to_le16(r >> 16);
+	return 0;
+}
+
+/*
+ * iwl_is_otp_empty: check for empty OTP
+ */
+static bool iwl_is_otp_empty(struct iwl_trans *trans)
+{
+	u16 next_link_addr = 0;
+	__le16 link_value;
+	bool is_empty = false;
+
+	/* locate the beginning of OTP link list */
+	if (!iwl_read_otp_word(trans, next_link_addr, &link_value)) {
+		if (!link_value) {
+			IWL_ERR(trans, "OTP is empty\n");
+			is_empty = true;
+		}
+	} else {
+		IWL_ERR(trans, "Unable to read first block of OTP list.\n");
+		is_empty = true;
+	}
+
+	return is_empty;
+}
+
+
+/*
+ * iwl_find_otp_image: find EEPROM image in OTP
+ *   finding the OTP block that contains the EEPROM image.
+ *   the last valid block on the link list (the block _before_ the last block)
+ *   is the block we should read and used to configure the device.
+ *   If all the available OTP blocks are full, the last block will be the block
+ *   we should read and used to configure the device.
+ *   only perform this operation if shadow RAM is disabled
+ */
+static int iwl_find_otp_image(struct iwl_trans *trans,
+					u16 *validblockaddr)
+{
+	u16 next_link_addr = 0, valid_addr;
+	__le16 link_value = 0;
+	int usedblocks = 0;
+
+	/* set addressing mode to absolute to traverse the link list */
+	iwl_set_otp_access_absolute(trans);
+
+	/* checking for empty OTP or error */
+	if (iwl_is_otp_empty(trans))
+		return -EINVAL;
+
+	/*
+	 * start traverse link list
+	 * until reach the max number of OTP blocks
+	 * different devices have different number of OTP blocks
+	 */
+	do {
+		/* save current valid block address
+		 * check for more block on the link list
+		 */
+		valid_addr = next_link_addr;
+		next_link_addr = le16_to_cpu(link_value) * sizeof(u16);
+		IWL_DEBUG_EEPROM(trans->dev, "OTP blocks %d addr 0x%x\n",
+				 usedblocks, next_link_addr);
+		if (iwl_read_otp_word(trans, next_link_addr, &link_value))
+			return -EINVAL;
+		if (!link_value) {
+			/*
+			 * reach the end of link list, return success and
+			 * set address point to the starting address
+			 * of the image
+			 */
+			*validblockaddr = valid_addr;
+			/* skip first 2 bytes (link list pointer) */
+			*validblockaddr += 2;
+			return 0;
+		}
+		/* more in the link list, continue */
+		usedblocks++;
+	} while (usedblocks <= trans->cfg->base_params->max_ll_items);
+
+	/* OTP has no valid blocks */
+	IWL_DEBUG_EEPROM(trans->dev, "OTP has no valid blocks\n");
+	return -EINVAL;
+}
+
+/**
+ * iwl_read_eeprom - read EEPROM contents
+ *
+ * Load the EEPROM contents from adapter and return it
+ * and its size.
+ *
+ * NOTE:  This routine uses the non-debug IO access functions.
+ */
+int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size)
+{
+	__le16 *e;
+	u32 gp = iwl_read32(trans, CSR_EEPROM_GP);
+	int sz;
+	int ret;
+	u16 addr;
+	u16 validblockaddr = 0;
+	u16 cache_addr = 0;
+	int nvm_is_otp;
+
+	if (!eeprom || !eeprom_size)
+		return -EINVAL;
+
+	nvm_is_otp = iwl_nvm_is_otp(trans);
+	if (nvm_is_otp < 0)
+		return nvm_is_otp;
+
+	sz = trans->cfg->base_params->eeprom_size;
+	IWL_DEBUG_EEPROM(trans->dev, "NVM size = %d\n", sz);
+
+	e = kmalloc(sz, GFP_KERNEL);
+	if (!e)
+		return -ENOMEM;
+
+	ret = iwl_eeprom_verify_signature(trans, nvm_is_otp);
+	if (ret < 0) {
+		IWL_ERR(trans, "EEPROM not found, EEPROM_GP=0x%08x\n", gp);
+		goto err_free;
+	}
+
+	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
+	ret = iwl_eeprom_acquire_semaphore(trans);
+	if (ret < 0) {
+		IWL_ERR(trans, "Failed to acquire EEPROM semaphore.\n");
+		goto err_free;
+	}
+
+	if (nvm_is_otp) {
+		ret = iwl_init_otp_access(trans);
+		if (ret) {
+			IWL_ERR(trans, "Failed to initialize OTP access.\n");
+			goto err_unlock;
+		}
+
+		iwl_write32(trans, CSR_EEPROM_GP,
+			    iwl_read32(trans, CSR_EEPROM_GP) &
+			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
+
+		iwl_set_bit(trans, CSR_OTP_GP_REG,
+			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
+			    CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
+		/* traversing the linked list if no shadow ram supported */
+		if (!trans->cfg->base_params->shadow_ram_support) {
+			ret = iwl_find_otp_image(trans, &validblockaddr);
+			if (ret)
+				goto err_unlock;
+		}
+		for (addr = validblockaddr; addr < validblockaddr + sz;
+		     addr += sizeof(u16)) {
+			__le16 eeprom_data;
+
+			ret = iwl_read_otp_word(trans, addr, &eeprom_data);
+			if (ret)
+				goto err_unlock;
+			e[cache_addr / 2] = eeprom_data;
+			cache_addr += sizeof(u16);
+		}
+	} else {
+		/* eeprom is an array of 16bit values */
+		for (addr = 0; addr < sz; addr += sizeof(u16)) {
+			u32 r;
+
+			iwl_write32(trans, CSR_EEPROM_REG,
+				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+
+			ret = iwl_poll_bit(trans, CSR_EEPROM_REG,
+					   CSR_EEPROM_REG_READ_VALID_MSK,
+					   CSR_EEPROM_REG_READ_VALID_MSK,
+					   IWL_EEPROM_ACCESS_TIMEOUT);
+			if (ret < 0) {
+				IWL_ERR(trans,
+					"Time out reading EEPROM[%d]\n", addr);
+				goto err_unlock;
+			}
+			r = iwl_read32(trans, CSR_EEPROM_REG);
+			e[addr / 2] = cpu_to_le16(r >> 16);
+		}
+	}
+
+	IWL_DEBUG_EEPROM(trans->dev, "NVM Type: %s\n",
+			 nvm_is_otp ? "OTP" : "EEPROM");
+
+	iwl_eeprom_release_semaphore(trans);
+
+	*eeprom_size = sz;
+	*eeprom = (u8 *)e;
+	return 0;
+
+ err_unlock:
+	iwl_eeprom_release_semaphore(trans);
+ err_free:
+	kfree(e);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iwl_read_eeprom);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
new file mode 100644
index 0000000..1337c9d
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
@@ -0,0 +1,70 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
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
+
+#ifndef __iwl_eeprom_h__
+#define __iwl_eeprom_h__
+
+#include "iwl-trans.h"
+
+int iwl_read_eeprom(struct iwl_trans *trans, u8 **eeprom, size_t *eeprom_size);
+
+#endif  /* __iwl_eeprom_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/1000.c b/drivers/net/wireless/iwlwifi/pcie/1000.c
index 174cf5e..0269ea6 100644
--- a/drivers/net/wireless/iwlwifi/pcie/1000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/1000.c
@@ -74,6 +74,18 @@ static const struct iwl_ht_params iwl1000_ht_params = {
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ),
 };
 
+static const struct iwl_eeprom_params iwl1000_eeprom_params = {
+	.regulatory_bands = {
+		EEPROM_REG_BAND_1_CHANNELS,
+		EEPROM_REG_BAND_2_CHANNELS,
+		EEPROM_REG_BAND_3_CHANNELS,
+		EEPROM_REG_BAND_4_CHANNELS,
+		EEPROM_REG_BAND_5_CHANNELS,
+		EEPROM_REG_BAND_24_HT40_CHANNELS,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+	}
+};
+
 #define IWL_DEVICE_1000						\
 	.fw_name_pre = IWL1000_FW_PRE,				\
 	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
@@ -85,6 +97,7 @@ static const struct iwl_ht_params iwl1000_ht_params = {
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.base_params = &iwl1000_base_params,			\
+	.eeprom_params = &iwl1000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
 
 const struct iwl_cfg iwl1000_bgn_cfg = {
@@ -109,6 +122,7 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.base_params = &iwl1000_base_params,			\
+	.eeprom_params = &iwl1000_eeprom_params,		\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.rx_with_siso_diversity = true
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/2000.c b/drivers/net/wireless/iwlwifi/pcie/2000.c
index 8d4d729..fd4e78f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/2000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/2000.c
@@ -117,6 +117,19 @@ static const struct iwl_bt_params iwl2030_bt_params = {
 	.bt_session_2 = true,
 };
 
+static const struct iwl_eeprom_params iwl20x0_eeprom_params = {
+	.regulatory_bands = {
+		EEPROM_REG_BAND_1_CHANNELS,
+		EEPROM_REG_BAND_2_CHANNELS,
+		EEPROM_REG_BAND_3_CHANNELS,
+		EEPROM_REG_BAND_4_CHANNELS,
+		EEPROM_REG_BAND_5_CHANNELS,
+		EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
+		EEPROM_REGULATORY_BAND_NO_HT40,
+	},
+	.enhanced_txpower = true,
+};
+
 #define IWL_DEVICE_2000						\
 	.fw_name_pre = IWL2000_FW_PRE,				\
 	.ucode_api_max = IWL2000_UCODE_API_MAX,			\
@@ -128,6 +141,7 @@ static const struct iwl_bt_params iwl2030_bt_params = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2000_base_params,			\
+	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE
@@ -156,6 +170,7 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
+	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
@@ -178,6 +193,7 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2000_base_params,			\
+	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
@@ -208,6 +224,7 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
+	.eeprom_params = &iwl20x0_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
diff --git a/drivers/net/wireless/iwlwifi/pcie/5000.c b/drivers/net/wireless/iwlwifi/pcie/5000.c
index 75d90a9..745a358 100644
--- a/drivers/net/wireless/iwlwifi/pcie/5000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/5000.c
@@ -72,6 +72,18 @@ static const struct iwl_ht_params iwl5000_ht_params = {
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
 
+static const struct iwl_eeprom_params iwl5000_eeprom_params = {
+	.regulatory_bands = {
+		EEPROM_REG_BAND_1_CHANNELS,
+		EEPROM_REG_BAND_2_CHANNELS,
+		EEPROM_REG_BAND_3_CHANNELS,
+		EEPROM_REG_BAND_4_CHANNELS,
+		EEPROM_REG_BAND_5_CHANNELS,
+		EEPROM_REG_BAND_24_HT40_CHANNELS,
+		EEPROM_REG_BAND_52_HT40_CHANNELS
+	},
+};
+
 #define IWL_DEVICE_5000						\
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
@@ -83,6 +95,7 @@ static const struct iwl_ht_params iwl5000_ht_params = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.base_params = &iwl5000_base_params,			\
+	.eeprom_params = &iwl5000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
 
 const struct iwl_cfg iwl5300_agn_cfg = {
@@ -129,6 +142,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.base_params = &iwl5000_base_params,
+	.eeprom_params = &iwl5000_eeprom_params,
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
 	.internal_wimax_coex = true,
@@ -145,6 +159,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.base_params = &iwl5000_base_params,			\
+	.eeprom_params = &iwl5000_eeprom_params,		\
 	.no_xtal_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
diff --git a/drivers/net/wireless/iwlwifi/pcie/6000.c b/drivers/net/wireless/iwlwifi/pcie/6000.c
index 7b9c02c..8dd8a6f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/6000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/6000.c
@@ -136,6 +136,19 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 	.bt_sco_disable = true,
 };
 
+static const struct iwl_eeprom_params iwl6000_eeprom_params = {
+	.regulatory_bands = {
+		EEPROM_REG_BAND_1_CHANNELS,
+		EEPROM_REG_BAND_2_CHANNELS,
+		EEPROM_REG_BAND_3_CHANNELS,
+		EEPROM_REG_BAND_4_CHANNELS,
+		EEPROM_REG_BAND_5_CHANNELS,
+		EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
+		EEPROM_REG_BAND_52_HT40_CHANNELS
+	},
+	.enhanced_txpower = true,
+};
+
 #define IWL_DEVICE_6005						\
 	.fw_name_pre = IWL6005_FW_PRE,				\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
@@ -147,6 +160,7 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE
 
@@ -202,6 +216,7 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true						\
@@ -274,6 +289,7 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.base_params = &iwl6000_base_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK
 
 const struct iwl_cfg iwl6000i_2agn_cfg = {
@@ -304,6 +320,7 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
@@ -328,6 +345,7 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
@@ -354,6 +372,7 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.base_params = &iwl6000_base_params,
+	.eeprom_params = &iwl6000_eeprom_params,
 	.ht_params = &iwl6000_ht_params,
 	.led_mode = IWL_LED_BLINK,
 };
-- 
1.7.10

