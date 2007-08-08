Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbXHHHh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 20/28] iwlwifi: remove BIT_FMT and BIT_ARG
Date: Wed,  8 Aug 2007 15:33:37 +0800
Message-Id: <11865584733882-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186558470949-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945.c    |    8 +++-----
 drivers/net/wireless/iwl-4965.c    |   15 ++++++---------
 drivers/net/wireless/iwl-base.c    |   24 +++++++++---------------
 drivers/net/wireless/iwl-helpers.h |   25 ++-----------------------
 4 files changed, 20 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index ce9688c..6cec308 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -659,11 +659,9 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	/* CCK */
 	cmd->cmd.tx.supp_rates[1] = (rate_mask >> 8) & 0xF;
 
-	IWL_DEBUG_RATE("Tx sta id: %d, rate: %d (plcp), flags: " BIT_FMT16 " "
-		       "cck/ofdm mask: 0x%x/0x%x\n",
-		       sta_id,
-		       cmd->cmd.tx.rate,
-		       BIT_ARG16(le32_to_cpu(cmd->cmd.tx.tx_flags)),
+	IWL_DEBUG_RATE("Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
+		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
+		       cmd->cmd.tx.rate, le32_to_cpu(cmd->cmd.tx.tx_flags),
 		       cmd->cmd.tx.supp_rates[1], cmd->cmd.tx.supp_rates[0]);
 }
 
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 258879c..76c0c98 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -310,7 +310,7 @@ int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode, u16 channel,
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(" BIT_FMT8
+	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
 			" %ddBm): Ad-Hoc %ssupported\n",
 			ch_info->channel,
 			is_channel_a_band(ch_info) ?
@@ -321,14 +321,11 @@ int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode, u16 channel,
 			CHECK_AND_PRINT(WIDE),
 			CHECK_AND_PRINT(NARROW),
 			CHECK_AND_PRINT(DFS),
-			BIT_ARG8(eeprom_ch->flags),
-			eeprom_ch->
-			max_power_avg,
-			((eeprom_ch->
-			flags & EEPROM_CHANNEL_IBSS)
-			&& !(eeprom_ch->
-			flags & EEPROM_CHANNEL_RADAR))
-			? "" : "not ");
+			eeprom_ch->flags,
+			eeprom_ch->max_power_avg,
+			((eeprom_ch->flags & EEPROM_CHANNEL_IBSS)
+			 && !(eeprom_ch->flags & EEPROM_CHANNEL_RADAR)) ?
+			"" : "not ");
 
 	ch_info->fat_eeprom = *eeprom_ch;
 	ch_info->fat_max_power_avg = eeprom_ch->max_power_avg;
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 94d5ac8..7514928 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -4702,18 +4702,13 @@ static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
 	printk_buf(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
-	IWL_DEBUG_RADIO("u32 flags: 0x%08X " BIT_FMT32 "\n",
-			le32_to_cpu(rxon->flags),
-			BIT_ARG32(le32_to_cpu(rxon->flags)));
-	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x " BIT_FMT32 "\n",
-			le32_to_cpu(rxon->filter_flags),
-			BIT_ARG32(le32_to_cpu(rxon->filter_flags)));
+	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
+	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
+			le32_to_cpu(rxon->filter_flags));
 	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
-	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x " BIT_FMT8 "\n",
-			rxon->ofdm_basic_rates,
-			BIT_ARG8(rxon->ofdm_basic_rates));
-	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x " BIT_FMT8 "\n",
-			rxon->cck_basic_rates, BIT_ARG8(rxon->cck_basic_rates));
+	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x\n",
+			rxon->ofdm_basic_rates);
+	IWL_DEBUG_RADIO("u8 cck_basic_rates: 0x%02x\n", rxon->cck_basic_rates);
 	IWL_DEBUG_RADIO("u8[6] node_addr: " MAC_FMT "\n",
 			MAC_ARG(rxon->node_addr));
 	IWL_DEBUG_RADIO("u8[6] bssid_addr: " MAC_FMT "\n",
@@ -5421,7 +5416,7 @@ static int iwl_init_channel_map(struct iwl_priv *priv)
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
-			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(" BIT_FMT8
+			IWL_DEBUG_INFO("Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x"
 				       " %ddBm): Ad-Hoc %ssupported\n",
 				       ch_info->channel,
 				       is_channel_a_band(ch_info) ?
@@ -5432,9 +5427,8 @@ static int iwl_init_channel_map(struct iwl_priv *priv)
 				       CHECK_AND_PRINT(WIDE),
 				       CHECK_AND_PRINT(NARROW),
 				       CHECK_AND_PRINT(DFS),
-				       BIT_ARG8(eeprom_ch_info[ch].flags),
-				       eeprom_ch_info[ch].
-				       max_power_avg,
+				       eeprom_ch_info[ch].flags,
+				       eeprom_ch_info[ch].max_power_avg,
 				       ((eeprom_ch_info[ch].
 					 flags & EEPROM_CHANNEL_IBSS)
 					&& !(eeprom_ch_info[ch].
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index 6281e3d..46084f2 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -85,14 +85,14 @@ static inline void iwl_set_bits(__le32 *dst, u8 pos, u8 len, int val)
 {
 	u32 tmp = le32_to_cpu(*dst);
 
-	tmp &= ~((1UL << (pos + len)) - (1UL << pos));
+	tmp &= ~(((1UL << len) - 1) << pos);
 	tmp |= (val & ((1UL << len) - 1)) << pos;
 	*dst = cpu_to_le32(tmp);
 }
 
 static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
 {
-	u32 tmp = le16_to_cpu(*dst);
+	u16 tmp = le16_to_cpu(*dst);
 
 	tmp &= ~((1UL << (pos + len)) - (1UL << pos));
 	tmp |= (val & ((1UL << len) - 1)) << pos;
@@ -133,27 +133,6 @@ static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
 	iwl_get_bits((s).IWL_ ## sym ## _SYM, IWL_ ## sym ## _POS, \
 		      IWL_ ## sym ## _LEN)
 
-/* Debug and printf string expansion helpers for printing bitfields */
-#define BIT_FMT8 "%c%c%c%c-%c%c%c%c"
-#define BIT_FMT16 BIT_FMT8 ":" BIT_FMT8
-#define BIT_FMT32 BIT_FMT16 " " BIT_FMT16
-
-#define BITC(x, y) (((x>>y) & 1) ? '1' : '0')
-#define BIT_ARG8(x) \
-BITC(x, 7), BITC(x, 6), BITC(x, 5), BITC(x, 4), \
-BITC(x, 3), BITC(x, 2), BITC(x, 1), BITC(x, 0)
-
-#define BIT_ARG16(x) \
-BITC(x, 15), BITC(x, 14), BITC(x, 13), BITC(x, 12), \
-BITC(x, 11), BITC(x, 10), BITC(x, 9), BITC(x, 8), \
-BIT_ARG8(x)
-
-#define BIT_ARG32(x) \
-BITC(x, 31), BITC(x, 30), BITC(x, 29), BITC(x, 28), \
-BITC(x, 27), BITC(x, 26), BITC(x, 25), BITC(x, 24), \
-BITC(x, 23), BITC(x, 22), BITC(x, 21), BITC(x, 20), \
-BITC(x, 19), BITC(x, 18), BITC(x, 17), BITC(x, 16), \
-BIT_ARG16(x)
 
 #define KELVIN_TO_CELSIUS(x) ((x)-273)
 #define CELSIUS_TO_KELVIN(x) ((x)+273)
-- 
1.5.2
