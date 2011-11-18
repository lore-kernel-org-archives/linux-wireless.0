Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1KRIVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:25 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LPLx022592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:25 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 17/77] iwlegacy: rename remaining IWLs to ILs
Date: Fri, 18 Nov 2011 09:21:39 +0100
Message-Id: <1321604559-10707-17-git-send-email-sgruszka@redhat.com> (sfid-20111118_092133_967024_5759EB46)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also rename config names IWLWIFI_LEGACY to IWLEGACY

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/Makefile                    |    2 +-
 drivers/net/wireless/iwlegacy/Kconfig            |   26 ++++----
 drivers/net/wireless/iwlegacy/Makefile           |    8 +-
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h      |   34 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c         |   52 ++++++++--------
 drivers/net/wireless/iwlegacy/iwl-3945.h         |   10 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h |    2 +-
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h      |   46 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c     |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c      |    6 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c      |   58 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c         |   42 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965.h         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h     |   24 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.c         |   14 ++--
 drivers/net/wireless/iwlegacy/iwl-core.h         |    4 +-
 drivers/net/wireless/iwlegacy/iwl-debug.h        |   10 ++--
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h          |   26 ++++----
 drivers/net/wireless/iwlegacy/iwl-hcmd.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h         |   58 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-scan.c         |    6 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c          |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c           |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c     |   64 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c     |   71 ++++++++++-----------
 31 files changed, 299 insertions(+), 302 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index c1c0678..98db761 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -42,7 +42,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
 obj-$(CONFIG_MWL8K)	+= mwl8k.o
 
 obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
-obj-$(CONFIG_IWLWIFI_LEGACY)	+= iwlegacy/
+obj-$(CONFIG_IWLEGACY)	+= iwlegacy/
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54/
diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index 2a1ae10..b4be3b4 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -1,4 +1,4 @@
-config IWLWIFI_LEGACY
+config IWLEGACY
 	tristate
 	select FW_LOADER
 	select NEW_LEDS
@@ -7,13 +7,13 @@ config IWLWIFI_LEGACY
 	select MAC80211_LEDS
 
 menu "Debugging Options"
-	depends on IWLWIFI_LEGACY
+	depends on IWLEGACY
 
-config IWLWIFI_LEGACY_DEBUG
-	bool "Enable full debugging output in 4965 and 3945 drivers"
-	depends on IWLWIFI_LEGACY
+config IWLEGACY_DEBUG
+	bool "Enable full debugging output in iwlegacy (iwl 3945/4965) drivers"
+	depends on IWLEGACY
 	---help---
-	  This option will enable debug tracing output for the iwlwifilegacy
+	  This option will enable debug tracing output for the iwlegacy
 	  drivers.
 
 	  This will result in the kernel module being ~100k larger.  You can
@@ -29,17 +29,17 @@ config IWLWIFI_LEGACY_DEBUG
 		  % echo 0x43fff > /sys/class/net/wlan0/device/debug_level
 
 	  You can find the list of debug mask values in:
-		  drivers/net/wireless/iwlwifilegacy/iwl-debug.h
+		  drivers/net/wireless/iwlegacy/iwl-debug.h
 
 	  If this is your first time using this driver, you should say Y here
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
-config IWLWIFI_LEGACY_DEBUGFS
-        bool "4965 and 3945 debugfs support"
-        depends on IWLWIFI_LEGACY && MAC80211_DEBUGFS
+config IWLEGACY_DEBUGFS
+        bool "iwlegacy (iwl 3945/4965) debugfs support"
+        depends on IWLEGACY && MAC80211_DEBUGFS
         ---help---
-	  Enable creation of debugfs files for the iwlwifilegacy drivers. This
+	  Enable creation of debugfs files for the iwlegacy drivers. This
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
 
@@ -48,7 +48,7 @@ endmenu
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN (iwl4965)"
 	depends on PCI && MAC80211
-	select IWLWIFI_LEGACY
+	select IWLEGACY
 	---help---
 	  This option enables support for
 
@@ -76,7 +76,7 @@ config IWL4965
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on PCI && MAC80211
-	select IWLWIFI_LEGACY
+	select IWLEGACY
 	---help---
 	  Select to build the driver supporting the:
 
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index 4f67e45..49c4b36 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -1,8 +1,8 @@
-obj-$(CONFIG_IWLWIFI_LEGACY)	+= iwl-legacy.o
+obj-$(CONFIG_IWLEGACY)	+= iwl-legacy.o
 iwl-legacy-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwl-legacy-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwl-legacy-objs 		+= iwl-scan.o iwl-led.o
-iwl-legacy-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-debugfs.o
+iwl-legacy-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-debugfs.o
 
 iwl-legacy-objs += $(iwl-legacy-m)
 
@@ -12,11 +12,11 @@ iwl4965-objs		:= iwl-4965.o iwl4965-base.o iwl-4965-rs.o iwl-4965-led.o
 iwl4965-objs		+= iwl-4965-ucode.o iwl-4965-tx.o
 iwl4965-objs		+= iwl-4965-lib.o iwl-4965-rx.o iwl-4965-calib.o
 iwl4965-objs		+= iwl-4965-sta.o iwl-4965-eeprom.o
-iwl4965-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-4965-debugfs.o
+iwl4965-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-4965-debugfs.o
 
 # 3945
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
-iwl3945-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-3945-debugfs.o
+iwl3945-$(CONFIG_IWLEGACY_DEBUGFS) += iwl-3945-debugfs.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
index 54334ac..9d1a4a0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
@@ -30,7 +30,7 @@
 #include "iwl-core.h"
 #include "iwl-debug.h"
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 ssize_t il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos);
 ssize_t il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
index 67650ff..fcb466a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
@@ -72,7 +72,7 @@
 #include "iwl-eeprom.h"
 
 /* RSSI to dBm */
-#define IWL39_RSSI_OFFSET	95
+#define IL39_RSSI_OFFSET	95
 
 /*
  * EEPROM related constants, enums, and structures.
@@ -214,7 +214,7 @@ struct il3945_eeprom {
 	u8 reserved16[172];	/* fill out to full 1024 byte block */
 } __packed;
 
-#define IWL3945_EEPROM_IMG_SIZE 1024
+#define IL3945_EEPROM_IMG_SIZE 1024
 
 /* End of EEPROM */
 
@@ -222,8 +222,8 @@ struct il3945_eeprom {
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
 /* 4 DATA + 1 CMD. There are 2 HCCA queues that are not used. */
-#define IWL39_NUM_QUEUES        5
-#define IWL39_CMD_QUEUE_NUM	4
+#define IL39_NUM_QUEUES        5
+#define IL39_CMD_QUEUE_NUM	4
 
 #define IL_DEFAULT_TX_RETRY  15
 
@@ -245,27 +245,27 @@ struct il3945_eeprom {
 
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 3945's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
-#define IWL39_RTC_INST_LOWER_BOUND		(0x000000)
-#define IWL39_RTC_INST_UPPER_BOUND		(0x014000)
+#define IL39_RTC_INST_LOWER_BOUND		(0x000000)
+#define IL39_RTC_INST_UPPER_BOUND		(0x014000)
 
-#define IWL39_RTC_DATA_LOWER_BOUND		(0x800000)
-#define IWL39_RTC_DATA_UPPER_BOUND		(0x808000)
+#define IL39_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IL39_RTC_DATA_UPPER_BOUND		(0x808000)
 
-#define IWL39_RTC_INST_SIZE (IWL39_RTC_INST_UPPER_BOUND - \
-				IWL39_RTC_INST_LOWER_BOUND)
-#define IWL39_RTC_DATA_SIZE (IWL39_RTC_DATA_UPPER_BOUND - \
-				IWL39_RTC_DATA_LOWER_BOUND)
+#define IL39_RTC_INST_SIZE (IL39_RTC_INST_UPPER_BOUND - \
+				IL39_RTC_INST_LOWER_BOUND)
+#define IL39_RTC_DATA_SIZE (IL39_RTC_DATA_UPPER_BOUND - \
+				IL39_RTC_DATA_LOWER_BOUND)
 
-#define IWL39_MAX_INST_SIZE IWL39_RTC_INST_SIZE
-#define IWL39_MAX_DATA_SIZE IWL39_RTC_DATA_SIZE
+#define IL39_MAX_INST_SIZE IL39_RTC_INST_SIZE
+#define IL39_MAX_DATA_SIZE IL39_RTC_DATA_SIZE
 
 /* Size of uCode instruction memory in bootstrap state machine */
-#define IWL39_MAX_BSM_SIZE IWL39_RTC_INST_SIZE
+#define IL39_MAX_BSM_SIZE IL39_RTC_INST_SIZE
 
 static inline int il3945_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= IWL39_RTC_DATA_LOWER_BOUND &&
-		addr < IWL39_RTC_DATA_UPPER_BOUND);
+	return (addr >= IL39_RTC_DATA_LOWER_BOUND &&
+		addr < IL39_RTC_DATA_UPPER_BOUND);
 }
 
 /* Base physical address of il3945_shared is provided to FH_TSSR_CBB_BASE
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index afa6be8..345beb7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -90,7 +90,7 @@ static struct il3945_tpt_entry il3945_tpt_table_g[] = {
 #define IL_RATE_MAX_WINDOW          62
 #define IL_RATE_FLUSH		(3*HZ)
 #define IL_RATE_WIN_FLUSH       (HZ/2)
-#define IWL39_RATE_HIGH_TH          11520
+#define IL39_RATE_HIGH_TH          11520
 #define IL_SUCCESS_UP_TH	   8960
 #define IL_SUCCESS_DOWN_TH	  10880
 #define IL_RATE_MIN_FAILURE_TH       6
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index fb69b74..78e81b6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -200,7 +200,7 @@ static int il3945_hwrate_to_plcp_idx(u8 plcp)
 	return -1;
 }
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_3945_STATUS_FAIL_ ## x: return #x
 
 static const char *il3945_get_tx_fail_reason(u32 status)
@@ -281,7 +281,7 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 	struct il_queue *q = &txq->q;
 	struct il_tx_info *tx_info;
 
-	BUG_ON(txq_id == IWL39_CMD_QUEUE_NUM);
+	BUG_ON(txq_id == IL39_CMD_QUEUE_NUM);
 
 	for (index = il_queue_inc_wrap(index, q->n_bd);
 		q->read_ptr != index;
@@ -294,7 +294,7 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 	}
 
 	if (il_queue_space(q) > q->low_mark && txq_id >= 0 &&
-	    txq_id != IWL39_CMD_QUEUE_NUM && il->mac80211_registered)
+	    txq_id != IL39_CMD_QUEUE_NUM && il->mac80211_registered)
 		il_wake_queue(il, txq);
 }
 
@@ -361,7 +361,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
  *  RX handler implementations
  *
  *****************************************************************************/
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 static void il3945_accumulative_statistics(struct il_priv *il,
 					    __le32 *stats)
 {
@@ -403,7 +403,7 @@ void il3945_hw_rx_statistics(struct il_priv *il,
 	D_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il3945_notif_statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	il3945_accumulative_statistics(il, (__le32 *)&pkt->u.raw);
 #endif
 
@@ -417,7 +417,7 @@ void il3945_reply_statistics(struct il_priv *il,
 	__le32 *flag = (__le32 *)&pkt->u.raw;
 
 	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 		memset(&il->_3945.accum_statistics, 0,
 			sizeof(struct il3945_notif_statistics));
 		memset(&il->_3945.delta_statistics, 0,
@@ -468,7 +468,7 @@ static void il3945_pass_packet_to_mac80211(struct il_priv *il,
 	__le16 fc = hdr->frame_control;
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely(len + IWL39_RX_FRAME_SIZE >
+	if (unlikely(len + IL39_RX_FRAME_SIZE >
 		     PAGE_SIZE << il->hw_params.rx_page_order)) {
 		D_DROP("Corruption detected!\n");
 		return;
@@ -552,7 +552,7 @@ static void il3945_rx_reply_rx(struct il_priv *il,
 
 
 	/* Convert 3945's rssi indicator to dBm */
-	rx_status.signal = rx_stats->rssi - IWL39_RSSI_OFFSET;
+	rx_status.signal = rx_stats->rssi - IL39_RSSI_OFFSET;
 
 	D_STATS("Rssi %d sig_avg %d noise_diff %d\n",
 			rx_status.signal, rx_stats_sig_avg,
@@ -698,7 +698,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 		data_retry_limit = IL_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
 
-	if (tx_id >= IWL39_CMD_QUEUE_NUM)
+	if (tx_id >= IL39_CMD_QUEUE_NUM)
 		rts_retry_limit = 3;
 	else
 		rts_retry_limit = 7;
@@ -849,7 +849,7 @@ static int il3945_txq_ctx_reset(struct il_priv *il)
 
 	/* Tx queue(s) */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == IWL39_CMD_QUEUE_NUM) ?
+		slots_num = (txq_id == IL39_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		rc = il_tx_queue_init(il, &il->txq[txq_id],
 						slots_num, txq_id);
@@ -1010,7 +1010,7 @@ void il3945_hw_txq_ctx_free(struct il_priv *il)
 	if (il->txq)
 		for (txq_id = 0; txq_id < il->hw_params.max_txq_num;
 		     txq_id++)
-			if (txq_id == IWL39_CMD_QUEUE_NUM)
+			if (txq_id == IL39_CMD_QUEUE_NUM)
 				il_cmd_queue_free(il);
 			else
 				il_tx_queue_free(il, txq_id);
@@ -1402,7 +1402,7 @@ static int il3945_send_tx_power(struct il_priv *il)
 	/* fill cmd with power settings for all rates for current channel */
 	/* Fill OFDM rate */
 	for (rate_idx = IL_FIRST_OFDM_RATE, i = 0;
-	     rate_idx <= IWL39_LAST_OFDM_RATE; rate_idx++, i++) {
+	     rate_idx <= IL39_LAST_OFDM_RATE; rate_idx++, i++) {
 
 		txpower.power[i].tpc = ch_info->power_info[i].tpc;
 		txpower.power[i].rate = il3945_rates[rate_idx].plcp;
@@ -2400,14 +2400,14 @@ int il3945_hw_set_hw_params(struct il_priv *il)
 	il->hw_params.rx_page_order = get_order(IL_RX_BUF_SIZE_3K);
 	il->hw_params.max_rxq_size = RX_QUEUE_SIZE;
 	il->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
-	il->hw_params.max_stations = IWL3945_STATION_COUNT;
-	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IWL3945_BROADCAST_ID;
+	il->hw_params.max_stations = IL3945_STATION_COUNT;
+	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IL3945_BROADCAST_ID;
 
 	il->sta_key_max_num = STA_KEY_MAX_NUM;
 
 	il->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
-	il->hw_params.max_beacon_itrvl = IWL39_MAX_UCODE_BEACON_INTERVAL;
-	il->hw_params.beacon_time_tsf_bits = IWL3945_EXT_BEACON_TIME_POS;
+	il->hw_params.max_beacon_itrvl = IL39_MAX_UCODE_BEACON_INTERVAL;
+	il->hw_params.beacon_time_tsf_bits = IL3945_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
@@ -2569,7 +2569,7 @@ static int il3945_load_bsm(struct il_priv *il)
 	D_INFO("Begin load bsm\n");
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
-	if (len > IWL39_MAX_BSM_SIZE)
+	if (len > IL39_MAX_BSM_SIZE)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
@@ -2601,7 +2601,7 @@ static int il3945_load_bsm(struct il_priv *il)
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	il_wr_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
 	il_wr_prph(il, BSM_WR_MEM_DST_REG,
-				 IWL39_RTC_INST_LOWER_BOUND);
+				 IL39_RTC_INST_LOWER_BOUND);
 	il_wr_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
@@ -2692,8 +2692,8 @@ static const struct il_ops il3945_ops = {
 };
 
 static struct il_base_params il3945_base_params = {
-	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
-	.num_of_queues = IWL39_NUM_QUEUES,
+	.eeprom_size = IL3945_EEPROM_IMG_SIZE,
+	.num_of_queues = IL39_NUM_QUEUES,
 	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
 	.set_l0s = false,
 	.use_bsm = true,
@@ -2703,9 +2703,9 @@ static struct il_base_params il3945_base_params = {
 
 static struct il_cfg il3945_bg_cfg = {
 	.name = "3945BG",
-	.fw_name_pre = IWL3945_FW_PRE,
-	.ucode_api_max = IWL3945_UCODE_API_MAX,
-	.ucode_api_min = IWL3945_UCODE_API_MIN,
+	.fw_name_pre = IL3945_FW_PRE,
+	.ucode_api_max = IL3945_UCODE_API_MAX,
+	.ucode_api_min = IL3945_UCODE_API_MIN,
 	.sku = IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &il3945_ops,
@@ -2716,9 +2716,9 @@ static struct il_cfg il3945_bg_cfg = {
 
 static struct il_cfg il3945_abg_cfg = {
 	.name = "3945ABG",
-	.fw_name_pre = IWL3945_FW_PRE,
-	.ucode_api_max = IWL3945_UCODE_API_MAX,
-	.ucode_api_min = IWL3945_UCODE_API_MIN,
+	.fw_name_pre = IL3945_FW_PRE,
+	.ucode_api_max = IL3945_UCODE_API_MAX,
+	.ucode_api_min = IL3945_UCODE_API_MIN,
 	.sku = IL_SKU_A|IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &il3945_ops,
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.h b/drivers/net/wireless/iwlegacy/iwl-3945.h
index abe778b..6c68f59 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.h
@@ -49,14 +49,14 @@ extern const struct pci_device_id il3945_hw_card_ids[];
 #include "iwl-led.h"
 
 /* Highest firmware API version supported */
-#define IWL3945_UCODE_API_MAX 2
+#define IL3945_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
-#define IWL3945_UCODE_API_MIN 1
+#define IL3945_UCODE_API_MIN 1
 
-#define IWL3945_FW_PRE	"iwlwifi-3945-"
-#define _IWL3945_MODULE_FIRMWARE(api) IWL3945_FW_PRE #api ".ucode"
-#define IWL3945_MODULE_FIRMWARE(api) _IWL3945_MODULE_FIRMWARE(api)
+#define IL3945_FW_PRE	"iwlwifi-3945-"
+#define _IL3945_MODULE_FIRMWARE(api) IL3945_FW_PRE #api ".ucode"
+#define IL3945_MODULE_FIRMWARE(api) _IL3945_MODULE_FIRMWARE(api)
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
index ca1cf58..284604c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
@@ -30,7 +30,7 @@
 #include "iwl-core.h"
 #include "iwl-debug.h"
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos);
 ssize_t il4965_ucode_tx_stats_read(struct file *file, char __user *user_buf,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index b21c004..ecebc69 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -72,38 +72,38 @@
 #include "iwl-fh.h"
 
 /* EEPROM */
-#define IWL4965_EEPROM_IMG_SIZE			1024
+#define IL4965_EEPROM_IMG_SIZE			1024
 
 /*
  * uCode queue management definitions ...
  * The first queue used for block-ack aggregation is #7 (4965 only).
  * All block-ack aggregation queues should map to Tx DMA/FIFO channel 7.
  */
-#define IWL49_FIRST_AMPDU_QUEUE	7
+#define IL49_FIRST_AMPDU_QUEUE	7
 
 /* Sizes and addresses for instruction and data memory (SRAM) in
  * 4965's embedded processor.  Driver access is via HBUS_TARG_MEM_* regs. */
-#define IWL49_RTC_INST_LOWER_BOUND		(0x000000)
-#define IWL49_RTC_INST_UPPER_BOUND		(0x018000)
+#define IL49_RTC_INST_LOWER_BOUND		(0x000000)
+#define IL49_RTC_INST_UPPER_BOUND		(0x018000)
 
-#define IWL49_RTC_DATA_LOWER_BOUND		(0x800000)
-#define IWL49_RTC_DATA_UPPER_BOUND		(0x80A000)
+#define IL49_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IL49_RTC_DATA_UPPER_BOUND		(0x80A000)
 
-#define IWL49_RTC_INST_SIZE  (IWL49_RTC_INST_UPPER_BOUND - \
-				IWL49_RTC_INST_LOWER_BOUND)
-#define IWL49_RTC_DATA_SIZE  (IWL49_RTC_DATA_UPPER_BOUND - \
-				IWL49_RTC_DATA_LOWER_BOUND)
+#define IL49_RTC_INST_SIZE  (IL49_RTC_INST_UPPER_BOUND - \
+				IL49_RTC_INST_LOWER_BOUND)
+#define IL49_RTC_DATA_SIZE  (IL49_RTC_DATA_UPPER_BOUND - \
+				IL49_RTC_DATA_LOWER_BOUND)
 
-#define IWL49_MAX_INST_SIZE IWL49_RTC_INST_SIZE
-#define IWL49_MAX_DATA_SIZE IWL49_RTC_DATA_SIZE
+#define IL49_MAX_INST_SIZE IL49_RTC_INST_SIZE
+#define IL49_MAX_DATA_SIZE IL49_RTC_DATA_SIZE
 
 /* Size of uCode instruction memory in bootstrap state machine */
-#define IWL49_MAX_BSM_SIZE BSM_SRAM_SIZE
+#define IL49_MAX_BSM_SIZE BSM_SRAM_SIZE
 
 static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= IWL49_RTC_DATA_LOWER_BOUND &&
-		addr < IWL49_RTC_DATA_UPPER_BOUND);
+	return (addr >= IL49_RTC_DATA_LOWER_BOUND &&
+		addr < IL49_RTC_DATA_UPPER_BOUND);
 }
 
 /********************* START TEMPERATURE *************************************/
@@ -760,10 +760,10 @@ enum {
  * up to 7 DMA channels (FIFOs).  Each Tx queue is supported by a circular array
  * in DRAM containing 256 Transmit Frame Descriptors (TFDs).
  */
-#define IWL49_NUM_FIFOS 	7
-#define IWL49_CMD_FIFO_NUM	4
-#define IWL49_NUM_QUEUES	16
-#define IWL49_NUM_AMPDU_QUEUES	8
+#define IL49_NUM_FIFOS	7
+#define IL49_CMD_FIFO_NUM	4
+#define IL49_NUM_QUEUES	16
+#define IL49_NUM_AMPDU_QUEUES	8
 
 
 /**
@@ -790,10 +790,10 @@ struct il4965_scd_bc_tbl {
 } __packed;
 
 
-#define IWL4965_RTC_INST_LOWER_BOUND		(0x000000)
+#define IL4965_RTC_INST_LOWER_BOUND		(0x000000)
 
 /* RSSI to dBm */
-#define IWL4965_RSSI_OFFSET	44
+#define IL4965_RSSI_OFFSET	44
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
@@ -802,10 +802,10 @@ struct il4965_scd_bc_tbl {
 #define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
 #define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
 
-#define IWL4965_DEFAULT_TX_RETRY  15
+#define IL4965_DEFAULT_TX_RETRY  15
 
 /* EEPROM */
-#define IWL4965_FIRST_AMPDU_QUEUE	10
+#define IL4965_FIRST_AMPDU_QUEUE	10
 
 
 #endif /* !__il_4965_hw_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index 8bb2b62..964d9bb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -438,12 +438,12 @@ static int il4965_calc_rssi(struct il_priv *il,
 	 *   contents are always there, not configurable by host.  */
 	struct il4965_rx_non_cfg_phy *ncphy =
 	    (struct il4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy_buf;
-	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL49_AGC_DB_MASK)
-			>> IWL49_AGC_DB_POS;
+	u32 agc = (le16_to_cpu(ncphy->agc_info) & IL49_AGC_DB_MASK)
+			>> IL49_AGC_DB_POS;
 
 	u32 valid_antennae =
-	    (le16_to_cpu(rx_resp->phy_flags) & IWL49_RX_PHY_FLAGS_ANTENNAE_MASK)
-			>> IWL49_RX_PHY_FLAGS_ANTENNAE_OFFSET;
+	    (le16_to_cpu(rx_resp->phy_flags) & IL49_RX_PHY_FLAGS_ANTENNAE_MASK)
+			>> IL49_RX_PHY_FLAGS_ANTENNAE_OFFSET;
 	u8 max_rssi = 0;
 	u32 i;
 
@@ -462,7 +462,7 @@ static int il4965_calc_rssi(struct il_priv *il,
 
 	/* dBm = max_rssi dB - agc dB - constant.
 	 * Higher AGC (higher radio gain) means lower signal. */
-	return max_rssi - agc - IWL4965_RSSI_OFFSET;
+	return max_rssi - agc - IL4965_RSSI_OFFSET;
 }
 
 
@@ -1152,7 +1152,7 @@ static const char *il4965_get_fh_string(int cmd)
 int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 {
 	int i;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	int pos = 0;
 	size_t bufsz = 0;
 #endif
@@ -1167,7 +1167,7 @@ int il4965_dump_fh(struct il_priv *il, char **buf, bool display)
 		FH_TSSR_TX_STATUS_REG,
 		FH_TSSR_TX_ERROR_REG
 	};
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (display) {
 		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
 		*buf = kmalloc(bufsz, GFP_KERNEL);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index c2f4230..9c8cc32 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -40,7 +40,7 @@
 #include "iwl-core.h"
 #include "iwl-4965.h"
 
-#define IWL4965_RS_NAME "iwl-4965-rs"
+#define IL4965_RS_NAME "iwl-4965-rs"
 
 #define NUM_TRY_BEFORE_ANT_TOGGLE 1
 #define IL_NUMBER_TRY      1
@@ -2837,7 +2837,7 @@ il4965_rs_rate_init_stub(void *il_r, struct ieee80211_supported_band *sband,
 }
 static struct rate_control_ops rs_4965_ops = {
 	.module = NULL,
-	.name = IWL4965_RS_NAME,
+	.name = IL4965_RS_NAME,
 	.tx_status = il4965_rs_tx_status,
 	.get_rate = il4965_rs_get_rate,
 	.rate_init = il4965_rs_rate_init_stub,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index 45e8a24..2181ec0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -105,7 +105,7 @@ static void il4965_rx_calc_noise(struct il_priv *il)
 			last_rx_noise);
 }
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 /*
  *  based on the assumption of all statistics counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
@@ -169,7 +169,7 @@ void il4965_rx_statistics(struct il_priv *il,
 		   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag &
 		   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	il4965_accumulative_statistics(il, (__le32 *)&pkt->u.stats);
 #endif
 
@@ -201,7 +201,7 @@ void il4965_reply_statistics(struct il_priv *il,
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 		memset(&il->_4965.accum_statistics, 0,
 			sizeof(struct il_notif_statistics));
 		memset(&il->_4965.delta_statistics, 0,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index a32a4f3..5f6a4ba 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -171,7 +171,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	if (ieee80211_is_probe_resp(fc))
 		data_retry_limit = 3;
 	else
-		data_retry_limit = IWL4965_DEFAULT_TX_RETRY;
+		data_retry_limit = IL4965_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
 
 	/* Set retry limit on RTS packets */
@@ -304,7 +304,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	fc = hdr->frame_control;
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (ieee80211_is_auth(fc))
 		D_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
@@ -754,9 +754,9 @@ static void il4965_tx_queue_stop_scheduler(struct il_priv *il,
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	il_wr_prph(il,
-		IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+		IL49_SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 /**
@@ -772,7 +772,7 @@ static int il4965_tx_queue_set_q2ratid(struct il_priv *il, u16 ra_tid,
 	scd_q2ratid = ra_tid & IL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = il->scd_base_addr +
-			IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
+			IL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
 
 	tbl_dw = il_read_targ_mem(il, tbl_dw_addr);
 
@@ -789,7 +789,7 @@ static int il4965_tx_queue_set_q2ratid(struct il_priv *il, u16 ra_tid,
 /**
  * il4965_tx_queue_agg_enable - Set up & enable aggregation for selected queue
  *
- * NOTE:  txq_id must be greater than IWL49_FIRST_AMPDU_QUEUE,
+ * NOTE:  txq_id must be greater than IL49_FIRST_AMPDU_QUEUE,
  *        i.e. it must be one of the higher queues used for aggregation
  */
 static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
@@ -799,13 +799,13 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 	u16 ra_tid;
 	int ret;
 
-	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE +
+	if ((IL49_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IL49_FIRST_AMPDU_QUEUE +
 		il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IL_WARN(
 			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL49_FIRST_AMPDU_QUEUE,
-			IWL49_FIRST_AMPDU_QUEUE +
+			txq_id, IL49_FIRST_AMPDU_QUEUE,
+			IL49_FIRST_AMPDU_QUEUE +
 			il->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
@@ -826,7 +826,7 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 	il4965_tx_queue_set_q2ratid(il, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	il_set_bits_prph(il, IWL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+	il_set_bits_prph(il, IL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -836,16 +836,16 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 
 	/* Set up Tx window size and frame limit for this queue */
 	il_write_targ_mem(il,
-		il->scd_base_addr + IWL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id),
-		(SCD_WIN_SIZE << IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
-		IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+		il->scd_base_addr + IL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id),
+		(SCD_WIN_SIZE << IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
+		IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 	il_write_targ_mem(il, il->scd_base_addr +
-		IWL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
-		(SCD_FRAME_LIMIT << IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
-		& IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
+		IL49_SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
+		(SCD_FRAME_LIMIT << IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
+		& IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
-	il_set_bits_prph(il, IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
+	il_set_bits_prph(il, IL49_SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	il4965_tx_queue_set_status(il, &il->txq[txq_id], tx_fifo, 1);
@@ -922,19 +922,19 @@ int il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 }
 
 /**
- * txq_id must be greater than IWL49_FIRST_AMPDU_QUEUE
+ * txq_id must be greater than IL49_FIRST_AMPDU_QUEUE
  * il->lock must be held by the caller
  */
 static int il4965_txq_agg_disable(struct il_priv *il, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
-	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE +
+	if ((IL49_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IL49_FIRST_AMPDU_QUEUE +
 		il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IL_WARN(
 			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL49_FIRST_AMPDU_QUEUE,
-			IWL49_FIRST_AMPDU_QUEUE +
+			txq_id, IL49_FIRST_AMPDU_QUEUE,
+			IL49_FIRST_AMPDU_QUEUE +
 			il->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
@@ -942,7 +942,7 @@ static int il4965_txq_agg_disable(struct il_priv *il, u16 txq_id,
 	il4965_tx_queue_stop_scheduler(il, txq_id);
 
 	il_clear_bits_prph(il,
-			IWL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+			IL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
 	il->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	il->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
@@ -950,7 +950,7 @@ static int il4965_txq_agg_disable(struct il_priv *il, u16 txq_id,
 	il4965_set_wr_ptrs(il, txq_id, ssn_idx);
 
 	il_clear_bits_prph(il,
-			 IWL49_SCD_INTERRUPT_MASK, (1 << txq_id));
+			 IL49_SCD_INTERRUPT_MASK, (1 << txq_id));
 	il_txq_ctx_deactivate(il, txq_id);
 	il4965_tx_queue_set_status(il, &il->txq[txq_id], tx_fifo, 0);
 
@@ -1134,7 +1134,7 @@ int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index)
 			nfreed++;
 
 		il4965_tx_status(il, tx_info,
-				 txq_id >= IWL4965_FIRST_AMPDU_QUEUE);
+				 txq_id >= IL4965_FIRST_AMPDU_QUEUE);
 		tx_info->skb = NULL;
 
 		il->cfg->ops->lib->txq_free_tfd(il, txq);
@@ -1331,7 +1331,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 const char *il4965_get_tx_fail_reason(u32 status)
 {
 #define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
@@ -1368,4 +1368,4 @@ const char *il4965_get_tx_fail_reason(u32 status)
 #undef TX_STATUS_FAIL
 #undef TX_STATUS_POSTPONE
 }
-#endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
+#endif /* CONFIG_IWLEGACY_DEBUG */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
index bb0b7f5..633caf5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
@@ -62,7 +62,7 @@ il4965_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
 		il_wr(il, HBUS_TARG_MEM_RADDR,
-			i + IWL4965_RTC_INST_LOWER_BOUND);
+			i + IL4965_RTC_INST_LOWER_BOUND);
 		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			ret = -EIO;
@@ -90,7 +90,7 @@ static int il4965_verify_inst_full(struct il_priv *il, __le32 *image,
 	D_INFO("ucode inst image size is %u\n", len);
 
 	il_wr(il, HBUS_TARG_MEM_RADDR,
-			   IWL4965_RTC_INST_LOWER_BOUND);
+			   IL4965_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 3706e47..f345171 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -52,14 +52,14 @@ static int il4965_send_tx_power(struct il_priv *il);
 static int il4965_hw_get_temperature(struct il_priv *il);
 
 /* Highest firmware API version supported */
-#define IWL4965_UCODE_API_MAX 2
+#define IL4965_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
-#define IWL4965_UCODE_API_MIN 2
+#define IL4965_UCODE_API_MIN 2
 
-#define IWL4965_FW_PRE "iwlwifi-4965-"
-#define _IWL4965_MODULE_FIRMWARE(api) IWL4965_FW_PRE #api ".ucode"
-#define IWL4965_MODULE_FIRMWARE(api) _IWL4965_MODULE_FIRMWARE(api)
+#define IL4965_FW_PRE "iwlwifi-4965-"
+#define _IL4965_MODULE_FIRMWARE(api) IL4965_FW_PRE #api ".ucode"
+#define IL4965_MODULE_FIRMWARE(api) _IL4965_MODULE_FIRMWARE(api)
 
 /* check contents of special bootstrap uCode SRAM */
 static int il4965_verify_bsm(struct il_priv *il)
@@ -142,7 +142,7 @@ static int il4965_load_bsm(struct il_priv *il)
 	il->ucode_type = UCODE_RT;
 
 	/* make sure bootstrap program is no larger than BSM's SRAM size */
-	if (len > IWL49_MAX_BSM_SIZE)
+	if (len > IL49_MAX_BSM_SIZE)
 		return -EINVAL;
 
 	/* Tell bootstrap uCode where to find the "Initialize" uCode
@@ -174,7 +174,7 @@ static int il4965_load_bsm(struct il_priv *il)
 	/* Tell BSM to copy from BSM SRAM into instruction SRAM, when asked */
 	il_wr_prph(il, BSM_WR_MEM_SRC_REG, 0x0);
 	il_wr_prph(il,
-			BSM_WR_MEM_DST_REG, IWL49_RTC_INST_LOWER_BOUND);
+			BSM_WR_MEM_DST_REG, IL49_RTC_INST_LOWER_BOUND);
 	il_wr_prph(il, BSM_WR_DWCOUNT_REG, len / sizeof(u32));
 
 	/* Load bootstrap code into instruction SRAM now,
@@ -392,7 +392,7 @@ static void il4965_set_ct_threshold(struct il_priv *il)
 static int il4965_hw_set_hw_params(struct il_priv *il)
 {
 	if (il->cfg->mod_params->num_of_queues >= IL_MIN_NUM_QUEUES &&
-	    il->cfg->mod_params->num_of_queues <= IWL49_NUM_QUEUES)
+	    il->cfg->mod_params->num_of_queues <= IL49_NUM_QUEUES)
 		il->cfg->base_params->num_of_queues =
 			il->cfg->mod_params->num_of_queues;
 
@@ -402,10 +402,10 @@ static int il4965_hw_set_hw_params(struct il_priv *il)
 			il->cfg->base_params->num_of_queues *
 			sizeof(struct il4965_scd_bc_tbl);
 	il->hw_params.tfd_size = sizeof(struct il_tfd);
-	il->hw_params.max_stations = IWL4965_STATION_COUNT;
-	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IWL4965_BROADCAST_ID;
-	il->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
-	il->hw_params.max_inst_size = IWL49_RTC_INST_SIZE;
+	il->hw_params.max_stations = IL4965_STATION_COUNT;
+	il->contexts[IL_RXON_CTX_BSS].bcast_sta_id = IL4965_BROADCAST_ID;
+	il->hw_params.max_data_size = IL49_RTC_DATA_SIZE;
+	il->hw_params.max_inst_size = IL49_RTC_INST_SIZE;
 	il->hw_params.max_bsm_size = BSM_SRAM_SIZE;
 	il->hw_params.ht40_channel = BIT(IEEE80211_BAND_5GHZ);
 
@@ -419,7 +419,7 @@ static int il4965_hw_set_hw_params(struct il_priv *il)
 	il4965_set_ct_threshold(il);
 
 	il->hw_params.sens = &il4965_sensitivity;
-	il->hw_params.beacon_time_tsf_bits = IWL4965_EXT_BEACON_TIME_POS;
+	il->hw_params.beacon_time_tsf_bits = IL4965_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
@@ -2143,14 +2143,14 @@ static const struct il_ops il4965_ops = {
 };
 
 static struct il_base_params il4965_base_params = {
-	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
-	.num_of_queues = IWL49_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
+	.eeprom_size = IL4965_EEPROM_IMG_SIZE,
+	.num_of_queues = IL49_NUM_QUEUES,
+	.num_of_ampdu_queues = IL49_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = true,
 	.led_compensation = 61,
-	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
+	.chain_noise_num_beacons = IL4965_CAL_NUM_BEACONS,
 	.wd_timeout = IL_DEF_WD_TIMEOUT,
 	.temperature_kelvin = true,
 	.ucode_tracing = true,
@@ -2160,9 +2160,9 @@ static struct il_base_params il4965_base_params = {
 
 struct il_cfg il4965_cfg = {
 	.name = "Intel(R) Wireless WiFi Link 4965AGN",
-	.fw_name_pre = IWL4965_FW_PRE,
-	.ucode_api_max = IWL4965_UCODE_API_MAX,
-	.ucode_api_min = IWL4965_UCODE_API_MIN,
+	.fw_name_pre = IL4965_FW_PRE,
+	.ucode_api_max = IL4965_UCODE_API_MAX,
+	.ucode_api_min = IL4965_UCODE_API_MIN,
 	.sku = IL_SKU_A|IL_SKU_G|IL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
@@ -2180,4 +2180,4 @@ struct il_cfg il4965_cfg = {
 };
 
 /* Module firmware */
-MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE(IWL4965_UCODE_API_MAX));
+MODULE_FIRMWARE(IL4965_MODULE_FIRMWARE(IL4965_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index 56bfdb0..0b92c28 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -189,7 +189,7 @@ int il4965_manage_ibss_station(struct il_priv *il,
 /* hcmd */
 int il4965_send_beacon_cmd(struct il_priv *il);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 const char *il4965_get_tx_fail_reason(u32 status);
 #else
 static inline const char *
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 347d402..61acafb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -746,7 +746,7 @@ struct il4965_rxon_assoc_cmd {
 
 #define IL_CONN_MAX_LISTEN_INTERVAL	10
 #define IL_MAX_UCODE_BEACON_INTERVAL	4 /* 4096 */
-#define IWL39_MAX_UCODE_BEACON_INTERVAL	1 /* 1024 */
+#define IL39_MAX_UCODE_BEACON_INTERVAL	1 /* 1024 */
 
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
@@ -854,10 +854,10 @@ struct il_qosparam_cmd {
 /* Special, dedicated locations within device's station table */
 #define	IL_AP_ID		0
 #define	IL_STA_ID		2
-#define	IWL3945_BROADCAST_ID	24
-#define IWL3945_STATION_COUNT	25
-#define IWL4965_BROADCAST_ID	31
-#define	IWL4965_STATION_COUNT	32
+#define	IL3945_BROADCAST_ID	24
+#define IL3945_STATION_COUNT	25
+#define IL4965_BROADCAST_ID	31
+#define	IL4965_STATION_COUNT	32
 
 #define	IL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IL_INVALID_STATION	255
@@ -1208,15 +1208,15 @@ struct il3945_rx_frame {
 	struct il3945_rx_frame_end end;
 } __packed;
 
-#define IWL39_RX_FRAME_SIZE	(4 + sizeof(struct il3945_rx_frame))
+#define IL39_RX_FRAME_SIZE	(4 + sizeof(struct il3945_rx_frame))
 
 /* Fixed (non-configurable) rx data from phy */
 
-#define IWL49_RX_RES_PHY_CNT 14
-#define IWL49_RX_PHY_FLAGS_ANTENNAE_OFFSET	(4)
-#define IWL49_RX_PHY_FLAGS_ANTENNAE_MASK	(0x70)
-#define IWL49_AGC_DB_MASK			(0x3f80)	/* MASK(7,13) */
-#define IWL49_AGC_DB_POS			(7)
+#define IL49_RX_RES_PHY_CNT 14
+#define IL49_RX_PHY_FLAGS_ANTENNAE_OFFSET	(4)
+#define IL49_RX_PHY_FLAGS_ANTENNAE_MASK	(0x70)
+#define IL49_AGC_DB_MASK			(0x3f80)	/* MASK(7,13) */
+#define IL49_AGC_DB_POS			(7)
 struct il4965_rx_non_cfg_phy {
 	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
 	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
@@ -2407,7 +2407,7 @@ struct il3945_scan_channel {
 } __packed;
 
 /* set number of direct probes u8 type */
-#define IWL39_SCAN_PROBE_MASK(n) ((BIT(n) | (BIT(n) - BIT(1))))
+#define IL39_SCAN_PROBE_MASK(n) ((BIT(n) | (BIT(n) - BIT(1))))
 
 struct il_scan_channel {
 	/*
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index acbd5a8..395918e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -315,7 +315,7 @@ bool il_is_ht40_tx_allowed(struct il_priv *il,
 	if (ht_cap && !ht_cap->ht_supported)
 		return false;
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	if (il->disable_ht40)
 		return false;
 #endif
@@ -888,7 +888,7 @@ void il_rx_csa(struct il_priv *il, struct il_rx_mem_buffer *rxb)
 }
 EXPORT_SYMBOL(il_rx_csa);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 void il_print_rx_config_cmd(struct il_priv *il,
 			     struct il_rxon_context *ctx)
 {
@@ -930,7 +930,7 @@ void il_irq_handle_error(struct il_priv *il)
 	il->cfg->ops->lib->dump_nic_error_log(il);
 	if (il->cfg->ops->lib->dump_fh)
 		il->cfg->ops->lib->dump_fh(il, NULL, false);
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_FW_ERRORS)
 		il_print_rx_config_cmd(il,
 					&il->contexts[IL_RXON_CTX_BSS]);
@@ -1208,7 +1208,7 @@ EXPORT_SYMBOL(il_send_statistics_request);
 void il_rx_pm_sleep_notif(struct il_priv *il,
 			   struct il_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	D_RX("sleep mode: %d, src: %d\n",
@@ -1467,7 +1467,7 @@ void il_txq_mem(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_txq_mem);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 
 #define IL_TRAFFIC_DUMP_SIZE	(IL_TRAFFIC_ENTRY_SIZE * IL_TRAFFIC_ENTRIES)
 
@@ -1611,11 +1611,11 @@ void il_clear_traffic_stats(struct il_priv *il)
 }
 
 /*
- * if CONFIG_IWLWIFI_LEGACY_DEBUGFS defined,
+ * if CONFIG_IWLEGACY_DEBUGFS defined,
  * il_update_stats function will
  * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass
  * Use debugFs to display the rx/rx_statistics
- * if CONFIG_IWLWIFI_LEGACY_DEBUGFS not being defined, then no MGMT and CTRL
+ * if CONFIG_IWLEGACY_DEBUGFS not being defined, then no MGMT and CTRL
  * information will be recorded, but DATA pkt still will be recorded
  * for the reason of il_led.c need to control the led blinking based on
  * number of tx and rx data.
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 1803954..487cebf 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -329,7 +329,7 @@ int il_mac_change_interface(struct ieee80211_hw *hw,
 int il_alloc_txq_mem(struct il_priv *il);
 void il_txq_mem(struct il_priv *il);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 int il_alloc_traffic_mem(struct il_priv *il);
 void il_free_traffic_mem(struct il_priv *il);
 void il_reset_traffic_log(struct il_priv *il);
@@ -513,7 +513,7 @@ extern const struct dev_pm_ops il_pm_ops;
 *  Error Handling Debugging
 ******************************************************/
 void il4965_dump_nic_error_log(struct il_priv *il);
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 void il_print_rx_config_cmd(struct il_priv *il,
 			     struct il_rxon_context *ctx);
 #else
diff --git a/drivers/net/wireless/iwlegacy/iwl-debug.h b/drivers/net/wireless/iwlegacy/iwl-debug.h
index 77467de..c58003a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debug.h
+++ b/drivers/net/wireless/iwlegacy/iwl-debug.h
@@ -42,7 +42,7 @@ do {									\
 		       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);		\
 } while (0)
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 #define IL_DBG(level, fmt, args...)					\
 do {									\
 	if (il_get_debug_level(il) & level)				\
@@ -63,9 +63,9 @@ do {									\
 static inline void il_print_hex_dump(struct il_priv *il, int level,
 				      const void *p, u32 len)
 {}
-#endif				/* CONFIG_IWLWIFI_LEGACY_DEBUG */
+#endif				/* CONFIG_IWLEGACY_DEBUG */
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 int il_dbgfs_register(struct il_priv *il, const char *name);
 void il_dbgfs_unregister(struct il_priv *il);
 #else
@@ -77,7 +77,7 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 static inline void il_dbgfs_unregister(struct il_priv *il)
 {
 }
-#endif				/* CONFIG_IWLWIFI_LEGACY_DEBUGFS */
+#endif				/* CONFIG_IWLEGACY_DEBUGFS */
 
 /*
  * To use the debug system:
@@ -99,7 +99,7 @@ static inline void il_dbgfs_unregister(struct il_priv *il)
  *	/sys/module/iwl3945/parameters/debug
  * 	/sys/class/net/wlan0/device/debug_level
  *
- * when CONFIG_IWLWIFI_LEGACY_DEBUG=y.
+ * when CONFIG_IWLEGACY_DEBUG=y.
  */
 
 /* 0x0000000F - 0x00000001 */
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index cd15e67..736b00b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -535,7 +535,7 @@ static ssize_t il_dbgfs_interrupt_read(struct file *file,
 			"\tLast Restarting Code:  0x%X\n",
 			il->isr_stats.err_code);
 	}
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
 		il->isr_stats.sch);
 	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 2e2e3f3..0aa4a12 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -185,7 +185,7 @@ struct il4965_channel_tgh_info {
 	s64 last_radar_time;
 };
 
-#define IWL4965_MAX_RATE (33)
+#define IL4965_MAX_RATE (33)
 
 struct il3945_clip_group {
 	/* maximum power level to prevent clipping for each rate, derived by
@@ -246,7 +246,7 @@ struct il_channel_info {
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
 	 *   remembering/modifying gain settings (indexes). */
-	struct il3945_channel_power_info power_info[IWL4965_MAX_RATE];
+	struct il3945_channel_power_info power_info[IL4965_MAX_RATE];
 
 	/* Radio/DSP gain settings for each scan rate, for directed scans. */
 	struct il3945_scan_power_info scan_pwr_info[IL_NUM_SCAN_RATES];
@@ -670,7 +670,7 @@ struct il_dma_ptr {
 
 /* Sensitivity and chain noise calibration */
 #define INITIALIZATION_VALUE		0xFFFF
-#define IWL4965_CAL_NUM_BEACONS		20
+#define IL4965_CAL_NUM_BEACONS		20
 #define IL_CAL_NUM_BEACONS		16
 #define MAXIMUM_ALLOWED_PATHLOSS	15
 
@@ -847,7 +847,7 @@ enum il_ctrl_stats {
 };
 
 struct traffic_stats {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	u32 mgmt[MANAGEMENT_MAX];
 	u32 ctrl[CONTROL_MAX];
 	u32 data_cnt;
@@ -891,13 +891,13 @@ struct il_force_reset {
  * bits 31:24 - extended
  * bits 23:0  - interval
  */
-#define IWL3945_EXT_BEACON_TIME_POS	24
+#define IL3945_EXT_BEACON_TIME_POS	24
 /*
  * for _4965 devices
  * bits 31:22 - extended
  * bits 21:0  - interval
  */
-#define IWL4965_EXT_BEACON_TIME_POS	22
+#define IL4965_EXT_BEACON_TIME_POS	22
 
 enum il_rxon_context_id {
 	IL_RXON_CTX_BSS,
@@ -1141,7 +1141,7 @@ struct il_priv {
 			struct delayed_work rfkill_poll;
 
 			struct il3945_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 			struct il3945_notif_statistics accum_statistics;
 			struct il3945_notif_statistics delta_statistics;
 			struct il3945_notif_statistics max_delta;
@@ -1179,7 +1179,7 @@ struct il_priv {
 			u8 phy_calib_chain_noise_gain_cmd;
 
 			struct il_notif_statistics statistics;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 			struct il_notif_statistics accum_statistics;
 			struct il_notif_statistics delta_statistics;
 			struct il_notif_statistics max_delta;
@@ -1217,12 +1217,12 @@ struct il_priv {
 	s8 tx_power_next;
 
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	/* debugging info */
 	u32 debug_level; /* per device debugging will override global
 			    il_debug_level if set */
-#endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUGFS
+#endif /* CONFIG_IWLEGACY_DEBUG */
+#ifdef CONFIG_IWLEGACY_DEBUGFS
 	/* debugfs */
 	u16 tx_traffic_idx;
 	u16 rx_traffic_idx;
@@ -1231,7 +1231,7 @@ struct il_priv {
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
 	bool disable_ht40;
-#endif /* CONFIG_IWLWIFI_LEGACY_DEBUGFS */
+#endif /* CONFIG_IWLEGACY_DEBUGFS */
 
 	struct work_struct txpower_work;
 	u32 disable_sens_cal;
@@ -1257,7 +1257,7 @@ static inline void il_txq_ctx_deactivate(struct il_priv *il, int txq_id)
 	clear_bit(txq_id, &il->txq_ctx_active_msk);
 }
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 /*
  * il_get_debug_level: Return active debug level for device
  *
diff --git a/drivers/net/wireless/iwlegacy/iwl-hcmd.c b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
index 8f87bd8..6ccd37f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlegacy/iwl-hcmd.c
@@ -100,7 +100,7 @@ static void il_generic_cmd_callback(struct il_priv *il,
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	switch (cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index 5da7d41..f24b6b8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -97,7 +97,7 @@ enum {
 
 enum {
 	IL_FIRST_OFDM_RATE = IL_RATE_6M_INDEX,
-	IWL39_LAST_OFDM_RATE = IL_RATE_54M_INDEX,
+	IL39_LAST_OFDM_RATE = IL_RATE_54M_INDEX,
 	IL_LAST_OFDM_RATE = IL_RATE_60M_INDEX,
 	IL_FIRST_CCK_RATE = IL_RATE_1M_INDEX,
 	IL_LAST_CCK_RATE = IL_RATE_11M_INDEX,
diff --git a/drivers/net/wireless/iwlegacy/iwl-prph.h b/drivers/net/wireless/iwlegacy/iwl-prph.h
index 96788a1..caa3837 100644
--- a/drivers/net/wireless/iwlegacy/iwl-prph.h
+++ b/drivers/net/wireless/iwlegacy/iwl-prph.h
@@ -320,19 +320,19 @@
  * can keep track of at one time when creating block-ack chains of frames.
  * Note that "64" matches the number of ack bits in a block-ack packet.
  * Driver should use SCD_WIN_SIZE and SCD_FRAME_LIMIT values to initialize
- * IWL49_SCD_CONTEXT_QUEUE_OFFSET(x) values.
+ * IL49_SCD_CONTEXT_QUEUE_OFFSET(x) values.
  */
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
 
 /* SCD registers are internal, must be accessed via HBUS_TARG_PRPH regs */
-#define IWL49_SCD_START_OFFSET		0xa02c00
+#define IL49_SCD_START_OFFSET		0xa02c00
 
 /*
  * 4965 tells driver SRAM address for internal scheduler structs via this reg.
  * Value is valid only after "Alive" response from uCode.
  */
-#define IWL49_SCD_SRAM_BASE_ADDR           (IWL49_SCD_START_OFFSET + 0x0)
+#define IL49_SCD_SRAM_BASE_ADDR           (IL49_SCD_START_OFFSET + 0x0)
 
 /*
  * Driver may need to update queue-empty bits after changing queue's
@@ -343,7 +343,7 @@
  * 15-00:  Empty state, one for each queue -- 1: empty, 0: non-empty
  * NOTE:  This register is not used by Linux driver.
  */
-#define IWL49_SCD_EMPTY_BITS               (IWL49_SCD_START_OFFSET + 0x4)
+#define IL49_SCD_EMPTY_BITS               (IL49_SCD_START_OFFSET + 0x4)
 
 /*
  * Physical base address of array of byte count (BC) circular buffers (CBs).
@@ -355,7 +355,7 @@
  * Bit fields:
  * 25-00:  Byte Count CB physical address [35:10], must be 1024-byte aligned.
  */
-#define IWL49_SCD_DRAM_BASE_ADDR           (IWL49_SCD_START_OFFSET + 0x10)
+#define IL49_SCD_DRAM_BASE_ADDR           (IL49_SCD_START_OFFSET + 0x10)
 
 /*
  * Enables any/all Tx DMA/FIFO channels.
@@ -364,7 +364,7 @@
  * Bit fields:
  *  7- 0:  Enable (1), disable (0), one bit for each channel 0-7
  */
-#define IWL49_SCD_TXFACT                   (IWL49_SCD_START_OFFSET + 0x1c)
+#define IL49_SCD_TXFACT                   (IL49_SCD_START_OFFSET + 0x1c)
 /*
  * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
  * Initialized and updated by driver as new TFDs are added to queue.
@@ -372,7 +372,7 @@
  *        Start Sequence Number; index = (SSN & 0xff)
  * NOTE:  Alternative to HBUS_TARG_WRPTR, which is what Linux driver uses?
  */
-#define IWL49_SCD_QUEUE_WRPTR(x)  (IWL49_SCD_START_OFFSET + 0x24 + (x) * 4)
+#define IL49_SCD_QUEUE_WRPTR(x)  (IL49_SCD_START_OFFSET + 0x24 + (x) * 4)
 
 /*
  * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
@@ -380,7 +380,7 @@
  * For Scheduler-ACK mode, index indicates first frame in Tx window.
  * Initialized by driver, updated by scheduler.
  */
-#define IWL49_SCD_QUEUE_RDPTR(x)  (IWL49_SCD_START_OFFSET + 0x64 + (x) * 4)
+#define IL49_SCD_QUEUE_RDPTR(x)  (IL49_SCD_START_OFFSET + 0x64 + (x) * 4)
 
 /*
  * Select which queues work in chain mode (1) vs. not (0).
@@ -391,7 +391,7 @@
  * NOTE:  If driver sets up queue for chain mode, it should be also set up
  *        Scheduler-ACK mode as well, via SCD_QUEUE_STATUS_BITS(x).
  */
-#define IWL49_SCD_QUEUECHAIN_SEL  (IWL49_SCD_START_OFFSET + 0xd0)
+#define IL49_SCD_QUEUECHAIN_SEL  (IL49_SCD_START_OFFSET + 0xd0)
 
 /*
  * Select which queues interrupt driver when scheduler increments
@@ -402,7 +402,7 @@
  * NOTE:  This functionality is apparently a no-op; driver relies on interrupts
  *        from Rx queue to read Tx command responses and update Tx queues.
  */
-#define IWL49_SCD_INTERRUPT_MASK  (IWL49_SCD_START_OFFSET + 0xe4)
+#define IL49_SCD_INTERRUPT_MASK  (IL49_SCD_START_OFFSET + 0xe4)
 
 /*
  * Queue search status registers.  One for each queue.
@@ -423,18 +423,18 @@
  * NOTE:  If enabling Scheduler-ACK mode, chain mode should also be enabled
  *        via SCD_QUEUECHAIN_SEL.
  */
-#define IWL49_SCD_QUEUE_STATUS_BITS(x)\
-	(IWL49_SCD_START_OFFSET + 0x104 + (x) * 4)
+#define IL49_SCD_QUEUE_STATUS_BITS(x)\
+	(IL49_SCD_START_OFFSET + 0x104 + (x) * 4)
 
 /* Bit field positions */
-#define IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE	(0)
-#define IWL49_SCD_QUEUE_STTS_REG_POS_TXF	(1)
-#define IWL49_SCD_QUEUE_STTS_REG_POS_WSL	(5)
-#define IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK	(8)
+#define IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE	(0)
+#define IL49_SCD_QUEUE_STTS_REG_POS_TXF	(1)
+#define IL49_SCD_QUEUE_STTS_REG_POS_WSL	(5)
+#define IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK	(8)
 
 /* Write masks */
-#define IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
-#define IWL49_SCD_QUEUE_STTS_REG_MSK		(0x0007FC00)
+#define IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN	(10)
+#define IL49_SCD_QUEUE_STTS_REG_MSK		(0x0007FC00)
 
 /**
  * 4965 internal SRAM structures for scheduler, shared with driver ...
@@ -470,14 +470,14 @@
  * Init must be done after driver receives "Alive" response from 4965 uCode,
  * and when setting up queue for aggregation.
  */
-#define IWL49_SCD_CONTEXT_DATA_OFFSET			0x380
-#define IWL49_SCD_CONTEXT_QUEUE_OFFSET(x) \
-			(IWL49_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+#define IL49_SCD_CONTEXT_DATA_OFFSET			0x380
+#define IL49_SCD_CONTEXT_QUEUE_OFFSET(x) \
+			(IL49_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
 
-#define IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
-#define IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
-#define IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
-#define IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+#define IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS		(0)
+#define IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK		(0x0000007F)
+#define IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
+#define IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
 /*
  * Tx Status Bitmap
@@ -486,7 +486,7 @@
  * "Alive" notification from uCode.  Area is used only by device itself;
  * no other support (besides clearing) is required from driver.
  */
-#define IWL49_SCD_TX_STTS_BITMAP_OFFSET		0x400
+#define IL49_SCD_TX_STTS_BITMAP_OFFSET		0x400
 
 /*
  * RAxTID to queue translation mapping.
@@ -508,11 +508,11 @@
  * must read a dword-aligned value from device SRAM, replace the 16-bit map
  * value of interest, and write the dword value back into device SRAM.
  */
-#define IWL49_SCD_TRANSLATE_TBL_OFFSET		0x500
+#define IL49_SCD_TRANSLATE_TBL_OFFSET		0x500
 
 /* Find translation table dword to read/write for given queue */
-#define IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((IWL49_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
+#define IL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
+	((IL49_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffffffc)
 
 #define IL_SCD_TXFIFO_POS_TID			(0)
 #define IL_SCD_TXFIFO_POS_RA			(4)
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index e352a18..e4e5fbb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -185,7 +185,7 @@ EXPORT_SYMBOL(il_scan_cancel_timeout);
 static void il_rx_reply_scan(struct il_priv *il,
 			      struct il_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il_scanreq_notification *notif =
 	    (struct il_scanreq_notification *)pkt->u.raw;
@@ -216,7 +216,7 @@ static void il_rx_scan_start_notif(struct il_priv *il,
 static void il_rx_scan_results_notif(struct il_priv *il,
 				      struct il_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il_scanresults_notification *notif =
 	    (struct il_scanresults_notification *)pkt->u.raw;
@@ -239,7 +239,7 @@ static void il_rx_scan_complete_notif(struct il_priv *il,
 				       struct il_rx_mem_buffer *rxb)
 {
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 #endif
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index cca467c..68c43b0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -681,7 +681,7 @@ void il_dealloc_bcast_stations(struct il_priv *il)
 }
 EXPORT_SYMBOL_GPL(il_dealloc_bcast_stations);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 static void il_dump_lq_cmd(struct il_priv *il,
 			   struct il_link_quality_cmd *lq)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 0d3515d..5312059 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -507,7 +507,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	if (idx == TFD_CMD_SLOTS)
 		len = IL_MAX_CMD_SIZE;
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	switch (out_cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index ec9a93c..2d1f22a 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -68,7 +68,7 @@
 #define DRV_DESCRIPTION	\
 "Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 #define VD "d"
 #else
 #define VD
@@ -500,7 +500,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	fc = hdr->frame_control;
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (ieee80211_is_auth(fc))
 		D_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_req(fc))
@@ -783,7 +783,7 @@ static void il3945_rx_reply_alive(struct il_priv *il,
 static void il3945_rx_reply_add_sta(struct il_priv *il,
 				 struct il_rx_mem_buffer *rxb)
 {
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 #endif
 
@@ -795,7 +795,7 @@ static void il3945_rx_beacon_notif(struct il_priv *il,
 {
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il3945_beacon_notif *beacon = &(pkt->u.beacon_status);
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	u8 rate = beacon->beacon_notify_hdr.rate;
 
 	D_RX("beacon status %x retries %d iss %d "
@@ -1410,7 +1410,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	u32 inta, handled = 0;
 	u32 inta_fh;
 	unsigned long flags;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -1428,7 +1428,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
 	_il_wr(il, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
 		inta_mask = _il_rd(il, CSR_INT_MASK);
@@ -1463,7 +1463,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
@@ -1541,7 +1541,7 @@ static void il3945_irq_tasklet(struct il_priv *il)
 	if (test_bit(STATUS_INT_ENABLED, &il->status))
 		il_enable_interrupts(il);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		inta = _il_rd(il, CSR_INT);
 		inta_mask = _il_rd(il, CSR_INT_MASK);
@@ -1612,12 +1612,12 @@ static int il3945_get_channels_for_scan(struct il_priv *il,
 		 * hearing clear Rx packet).*/
 		if (IL_UCODE_API(il->ucode_ver) >= 2) {
 			if (n_probes)
-				scan_ch->type |= IWL39_SCAN_PROBE_MASK(n_probes);
+				scan_ch->type |= IL39_SCAN_PROBE_MASK(n_probes);
 		} else {
 			/* uCode v1 does not allow setting direct probe bits on
 			 * passive channel. */
 			if ((scan_ch->type & 1) && n_probes)
-				scan_ch->type |= IWL39_SCAN_PROBE_MASK(n_probes);
+				scan_ch->type |= IL39_SCAN_PROBE_MASK(n_probes);
 		}
 
 		/* Set txpower levels to defaults */
@@ -1659,7 +1659,7 @@ static void il3945_init_hw_rates(struct il_priv *il,
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
-		if (i > IWL39_LAST_OFDM_RATE || i < IL_FIRST_OFDM_RATE) {
+		if (i > IL39_LAST_OFDM_RATE || i < IL_FIRST_OFDM_RATE) {
 			/*
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
@@ -1699,7 +1699,7 @@ static int il3945_verify_inst_full(struct il_priv *il, __le32 *image, u32 len)
 	D_INFO("ucode inst image size is %u\n", len);
 
 	il_wr(il, HBUS_TARG_MEM_RADDR,
-			       IWL39_RTC_INST_LOWER_BOUND);
+			       IL39_RTC_INST_LOWER_BOUND);
 
 	errcnt = 0;
 	for (; len > 0; len -= sizeof(u32), image++) {
@@ -1746,7 +1746,7 @@ static int il3945_verify_inst_sparse(struct il_priv *il, __le32 *image, u32 len)
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IL_DL_IO is set */
 		il_wr(il, HBUS_TARG_MEM_RADDR,
-			i + IWL39_RTC_INST_LOWER_BOUND);
+			i + IL39_RTC_INST_LOWER_BOUND);
 		val = _il_rd(il, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 #if 0 /* Enable this if you want to see details */
@@ -1820,7 +1820,7 @@ static void il3945_nic_start(struct il_priv *il)
 	_il_wr(il, CSR_RESET, 0);
 }
 
-#define IWL3945_UCODE_GET(item)						\
+#define IL3945_UCODE_GET(item)						\
 static u32 il3945_ucode_get_##item(const struct il_ucode_header *ucode)\
 {									\
 	return le32_to_cpu(ucode->v1.item);				\
@@ -1836,11 +1836,11 @@ static u8 *il3945_ucode_get_data(const struct il_ucode_header *ucode)
 	return (u8 *) ucode->v1.data;
 }
 
-IWL3945_UCODE_GET(inst_size);
-IWL3945_UCODE_GET(data_size);
-IWL3945_UCODE_GET(init_size);
-IWL3945_UCODE_GET(init_data_size);
-IWL3945_UCODE_GET(boot_size);
+IL3945_UCODE_GET(inst_size);
+IL3945_UCODE_GET(data_size);
+IL3945_UCODE_GET(init_size);
+IL3945_UCODE_GET(init_data_size);
+IL3945_UCODE_GET(boot_size);
 
 /**
  * il3945_read_ucode - Read uCode images from disk file.
@@ -1967,34 +1967,34 @@ static int il3945_read_ucode(struct il_priv *il)
 	}
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (inst_size > IWL39_MAX_INST_SIZE) {
+	if (inst_size > IL39_MAX_INST_SIZE) {
 		D_INFO("uCode instr len %d too large to fit in\n",
 			       inst_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
 
-	if (data_size > IWL39_MAX_DATA_SIZE) {
+	if (data_size > IL39_MAX_DATA_SIZE) {
 		D_INFO("uCode data len %d too large to fit in\n",
 			       data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_size > IWL39_MAX_INST_SIZE) {
+	if (init_size > IL39_MAX_INST_SIZE) {
 		D_INFO(
 				"uCode init instr len %d too large to fit in\n",
 				init_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (init_data_size > IWL39_MAX_DATA_SIZE) {
+	if (init_data_size > IL39_MAX_DATA_SIZE) {
 		D_INFO(
 				"uCode init data len %d too large to fit in\n",
 				init_data_size);
 		ret = -EINVAL;
 		goto err_release;
 	}
-	if (boot_size > IWL39_MAX_BSM_SIZE) {
+	if (boot_size > IL39_MAX_BSM_SIZE) {
 		D_INFO(
 				"uCode boot instr len %d too large to fit in\n",
 				boot_size);
@@ -3118,7 +3118,7 @@ static void il3945_configure_filter(struct ieee80211_hw *hw,
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -3160,7 +3160,7 @@ static ssize_t il3945_store_debug_level(struct device *d,
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 			il3945_show_debug_level, il3945_store_debug_level);
 
-#endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
+#endif /* CONFIG_IWLEGACY_DEBUG */
 
 static ssize_t il3945_show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
@@ -3495,7 +3495,7 @@ static struct attribute *il3945_sysfs_entries[] = {
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
 	NULL
@@ -3583,7 +3583,7 @@ err:
 	return ret;
 }
 
-#define IWL3945_MAX_PROBE_REQUEST	200
+#define IL3945_MAX_PROBE_REQUEST	200
 
 static int il3945_setup_mac(struct il_priv *il)
 {
@@ -3607,7 +3607,7 @@ static int il3945_setup_mac(struct il_priv *il)
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX_3945;
 	/* we create the 802.11 header and a zero-length SSID element */
-	hw->wiphy->max_scan_ie_len = IWL3945_MAX_PROBE_REQUEST - 24 - 2;
+	hw->wiphy->max_scan_ie_len = IL3945_MAX_PROBE_REQUEST - 24 - 2;
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
@@ -3656,7 +3656,7 @@ static int il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *en
 	il = hw->priv;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	il->cmd_queue = IWL39_CMD_QUEUE_NUM;
+	il->cmd_queue = IL39_CMD_QUEUE_NUM;
 
 	/* 3945 has only one valid context */
 	il->valid_contexts = BIT(IL_RXON_CTX_BSS);
@@ -3992,7 +3992,7 @@ static void __exit il3945_exit(void)
 	il3945_rate_control_unregister();
 }
 
-MODULE_FIRMWARE(IWL3945_MODULE_FIRMWARE(IWL3945_UCODE_API_MAX));
+MODULE_FIRMWARE(IL3945_MODULE_FIRMWARE(IL3945_UCODE_API_MAX));
 
 module_param_named(antenna, il3945_mod_params.antenna, int, S_IRUGO);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
@@ -4002,7 +4002,7 @@ MODULE_PARM_DESC(swcrypto,
 module_param_named(disable_hw_scan, il3945_mod_params.disable_hw_scan,
 		int, S_IRUGO);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 0f7d44c..ddf4200 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -72,7 +72,7 @@
  */
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi 4965 driver for Linux"
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 #define VD "d"
 #else
 #define VD
@@ -493,7 +493,7 @@ static void il4965_rx_beacon_notif(struct il_priv *il,
 	struct il_rx_packet *pkt = rxb_addr(rxb);
 	struct il4965_beacon_notif *beacon =
 		(struct il4965_beacon_notif *)pkt->u.raw;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	u8 rate = il4965_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
 	D_RX("beacon status %x retries %d iss %d "
@@ -778,7 +778,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	u32 inta_fh;
 	unsigned long flags;
 	u32 i;
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	u32 inta_mask;
 #endif
 
@@ -796,7 +796,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	inta_fh = _il_rd(il, CSR_FH_INT_STATUS);
 	_il_wr(il, CSR_FH_INT_STATUS, inta_fh);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & IL_DL_ISR) {
 		/* just for debug */
 		inta_mask = _il_rd(il, CSR_INT_MASK);
@@ -831,7 +831,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 		return;
 	}
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
@@ -946,7 +946,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
 	else if (handled & CSR_INT_BIT_RF_KILL)
 		il_enable_rfkill_int(il);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	if (il_get_debug_level(il) & (IL_DL_ISR)) {
 		inta = _il_rd(il, CSR_INT);
 		inta_mask = _il_rd(il, CSR_INT_MASK);
@@ -964,7 +964,7 @@ static void il4965_irq_tasklet(struct il_priv *il)
  *
  *****************************************************************************/
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 
 /*
  * The following adds a new attribute to the sysfs representation
@@ -1007,7 +1007,7 @@ static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 			il4965_show_debug_level, il4965_store_debug_level);
 
 
-#endif /* CONFIG_IWLWIFI_LEGACY_DEBUG */
+#endif /* CONFIG_IWLEGACY_DEBUG */
 
 
 static ssize_t il4965_show_temperature(struct device *d,
@@ -1062,7 +1062,7 @@ static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO,
 static struct attribute *il_sysfs_entries[] = {
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
 	NULL
@@ -1607,7 +1607,7 @@ static const s8 default_queue_to_tx_fifo[] = {
 	IL_TX_FIFO_VI,
 	IL_TX_FIFO_BE,
 	IL_TX_FIFO_BK,
-	IWL49_CMD_FIFO_NUM,
+	IL49_CMD_FIFO_NUM,
 	IL_TX_FIFO_UNUSED,
 	IL_TX_FIFO_UNUSED,
 };
@@ -1623,18 +1623,18 @@ static int il4965_alive_notify(struct il_priv *il)
 
 	/* Clear 4965's internal Tx Scheduler data base */
 	il->scd_base_addr = il_rd_prph(il,
-					IWL49_SCD_SRAM_BASE_ADDR);
-	a = il->scd_base_addr + IWL49_SCD_CONTEXT_DATA_OFFSET;
-	for (; a < il->scd_base_addr + IWL49_SCD_TX_STTS_BITMAP_OFFSET; a += 4)
+					IL49_SCD_SRAM_BASE_ADDR);
+	a = il->scd_base_addr + IL49_SCD_CONTEXT_DATA_OFFSET;
+	for (; a < il->scd_base_addr + IL49_SCD_TX_STTS_BITMAP_OFFSET; a += 4)
 		il_write_targ_mem(il, a, 0);
-	for (; a < il->scd_base_addr + IWL49_SCD_TRANSLATE_TBL_OFFSET; a += 4)
+	for (; a < il->scd_base_addr + IL49_SCD_TRANSLATE_TBL_OFFSET; a += 4)
 		il_write_targ_mem(il, a, 0);
 	for (; a < il->scd_base_addr +
-	       IWL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(il->hw_params.max_txq_num); a += 4)
+	       IL49_SCD_TRANSLATE_TBL_OFFSET_QUEUE(il->hw_params.max_txq_num); a += 4)
 		il_write_targ_mem(il, a, 0);
 
 	/* Tel 4965 where to find Tx byte count tables */
-	il_wr_prph(il, IWL49_SCD_DRAM_BASE_ADDR,
+	il_wr_prph(il, IL49_SCD_DRAM_BASE_ADDR,
 			il->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
@@ -1650,32 +1650,32 @@ static int il4965_alive_notify(struct il_priv *il)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	/* Disable chain mode for all queues */
-	il_wr_prph(il, IWL49_SCD_QUEUECHAIN_SEL, 0);
+	il_wr_prph(il, IL49_SCD_QUEUECHAIN_SEL, 0);
 
 	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < il->hw_params.max_txq_num; i++) {
 
 		/* TFD circular buffer read/write indexes */
-		il_wr_prph(il, IWL49_SCD_QUEUE_RDPTR(i), 0);
+		il_wr_prph(il, IL49_SCD_QUEUE_RDPTR(i), 0);
 		il_wr(il, HBUS_TARG_WRPTR, 0 | (i << 8));
 
 		/* Max Tx Window size for Scheduler-ACK mode */
 		il_write_targ_mem(il, il->scd_base_addr +
-				IWL49_SCD_CONTEXT_QUEUE_OFFSET(i),
+				IL49_SCD_CONTEXT_QUEUE_OFFSET(i),
 				(SCD_WIN_SIZE <<
-				IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
-				IWL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+				IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
+				IL49_SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 		/* Frame limit */
 		il_write_targ_mem(il, il->scd_base_addr +
-				IWL49_SCD_CONTEXT_QUEUE_OFFSET(i) +
+				IL49_SCD_CONTEXT_QUEUE_OFFSET(i) +
 				sizeof(u32),
 				(SCD_FRAME_LIMIT <<
-				IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				IWL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
+				IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				IL49_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	}
-	il_wr_prph(il, IWL49_SCD_INTERRUPT_MASK,
+	il_wr_prph(il, IL49_SCD_INTERRUPT_MASK,
 				 (1 << il->hw_params.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
@@ -2733,7 +2733,7 @@ void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 index)
 {
 	il_wr(il, HBUS_TARG_WRPTR,
 			     (index & 0xff) | (txq_id << 8));
-	il_wr_prph(il, IWL49_SCD_QUEUE_RDPTR(txq_id), index);
+	il_wr_prph(il, IL49_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void il4965_tx_queue_set_status(struct il_priv *il,
@@ -2746,12 +2746,12 @@ void il4965_tx_queue_set_status(struct il_priv *il,
 	int active = test_bit(txq_id, &il->txq_ctx_active_msk) ? 1 : 0;
 
 	/* Set up and activate */
-	il_wr_prph(il, IWL49_SCD_QUEUE_STATUS_BITS(txq_id),
-			 (active << IWL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			 (tx_fifo_id << IWL49_SCD_QUEUE_STTS_REG_POS_TXF) |
-			 (scd_retry << IWL49_SCD_QUEUE_STTS_REG_POS_WSL) |
-			 (scd_retry << IWL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
-			 IWL49_SCD_QUEUE_STTS_REG_MSK);
+	il_wr_prph(il, IL49_SCD_QUEUE_STATUS_BITS(txq_id),
+			 (active << IL49_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			 (tx_fifo_id << IL49_SCD_QUEUE_STTS_REG_POS_TXF) |
+			 (scd_retry << IL49_SCD_QUEUE_STTS_REG_POS_WSL) |
+			 (scd_retry << IL49_SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
+			 IL49_SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
@@ -3195,7 +3195,7 @@ static void __devexit il4965_pci_remove(struct pci_dev *pdev)
  */
 void il4965_txq_set_sched(struct il_priv *il, u32 mask)
 {
-	il_wr_prph(il, IWL49_SCD_TXFACT, mask);
+	il_wr_prph(il, IL49_SCD_TXFACT, mask);
 }
 
 /*****************************************************************************
@@ -3206,11 +3206,8 @@ void il4965_txq_set_sched(struct il_priv *il, u32 mask)
 
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 static DEFINE_PCI_DEVICE_TABLE(il4965_hw_card_ids) = {
-#if defined(CONFIG_IWL4965_MODULE) || defined(CONFIG_IWL4965)
 	{IL_PCI_DEVICE(0x4229, PCI_ANY_ID, il4965_cfg)},
 	{IL_PCI_DEVICE(0x4230, PCI_ANY_ID, il4965_cfg)},
-#endif /* CONFIG_IWL4965 */
-
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, il4965_hw_card_ids);
@@ -3258,7 +3255,7 @@ static void __exit il4965_exit(void)
 module_exit(il4965_exit);
 module_init(il4965_init);
 
-#ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
+#ifdef CONFIG_IWLEGACY_DEBUG
 module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
-- 
1.7.1

