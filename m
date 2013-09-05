Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:39822 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935811Ab3IEMWM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 08:22:12 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: replace snprintf() with scnprintf()
Date: Thu,  5 Sep 2013 14:11:57 +0200
Message-Id: <1378383117-8903-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130905_142224_823426_8996C45E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the return value of snprintf() is used to calculate
remaining buffer-space, we wanted to use sncprintf() instead.

Indentation is adapted where possible. Some lines exceed the
line width limit, either they did it already before, or
since they can not be broken reasonably well.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  12 +-
 drivers/net/wireless/ath/ath9k/ath9k.h         |   4 +-
 drivers/net/wireless/ath/ath9k/debug.c         | 446 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/debug.h         |  12 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c     |  25 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |  10 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   8 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |  12 +-
 drivers/net/wireless/ath/ath9k/gpio.c          |  22 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 456 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/hw.c            |  22 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   4 +-
 drivers/net/wireless/ath/ath9k/rc.c            |  32 +-
 13 files changed, 534 insertions(+), 531 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f486480..004af89 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3424,12 +3424,12 @@ static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	struct ar9300_base_eep_hdr *pBase;
 
 	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "2GHz modal Header");
 		len = ar9003_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader2G);
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "5GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "5GHz modal Header");
 		len = ar9003_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader5G);
 		goto out;
@@ -3479,8 +3479,8 @@ static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	PR_EEP("Rx Gain", pBase->txrxgain & 0xf);
 	PR_EEP("SW Reg", le32_to_cpu(pBase->swreg));
 
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			ah->eeprom.ar9300_eep.macAddr);
+	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			 ah->eeprom.ar9300_eep.macAddr);
 out:
 	if (len > size)
 		len = size;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2ee35f6..2f19bd6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -459,8 +459,8 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 
 #define ATH_DUMP_BTCOEX(_s, _val)				\
 	do {							\
-		len += snprintf(buf + len, size - len,		\
-				"%20s : %10d\n", _s, (_val));	\
+		len += scnprintf(buf + len, size - len,		\
+				 "%20s : %10d\n", _s, (_val));	\
 	} while (0)
 
 enum bt_op_flags {
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c088744..1be2c78 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -104,37 +104,37 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 		return -ENOMEM;
 
 	if (common->disable_ani) {
-		len += snprintf(buf + len, size - len, "%s: %s\n",
-				"ANI", "DISABLED");
+		len += scnprintf(buf + len, size - len, "%s: %s\n",
+				 "ANI", "DISABLED");
 		goto exit;
 	}
 
-	len += snprintf(buf + len, size - len, "%15s: %s\n",
-			"ANI", "ENABLED");
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"ANI RESET", ah->stats.ast_ani_reset);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"SPUR UP", ah->stats.ast_ani_spurup);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"SPUR DOWN", ah->stats.ast_ani_spurup);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"OFDM WS-DET ON", ah->stats.ast_ani_ofdmon);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"MRC-CCK ON", ah->stats.ast_ani_ccklow);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"MRC-CCK OFF", ah->stats.ast_ani_cckhigh);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"FIR-STEP UP", ah->stats.ast_ani_stepup);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"FIR-STEP DOWN", ah->stats.ast_ani_stepdown);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"OFDM ERRORS", ah->stats.ast_ani_ofdmerrs);
-	len += snprintf(buf + len, size - len, "%15s: %u\n",
-			"CCK ERRORS", ah->stats.ast_ani_cckerrs);
+	len += scnprintf(buf + len, size - len, "%15s: %s\n",
+			 "ANI", "ENABLED");
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "ANI RESET", ah->stats.ast_ani_reset);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "SPUR UP", ah->stats.ast_ani_spurup);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "SPUR DOWN", ah->stats.ast_ani_spurup);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "OFDM WS-DET ON", ah->stats.ast_ani_ofdmon);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "MRC-CCK ON", ah->stats.ast_ani_ccklow);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "MRC-CCK OFF", ah->stats.ast_ani_cckhigh);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "FIR-STEP UP", ah->stats.ast_ani_stepup);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "FIR-STEP DOWN", ah->stats.ast_ani_stepdown);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "INV LISTENTIME", ah->stats.ast_ani_lneg_or_lzero);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "OFDM ERRORS", ah->stats.ast_ani_ofdmerrs);
+	len += scnprintf(buf + len, size - len, "%15s: %u\n",
+			 "CCK ERRORS", ah->stats.ast_ani_cckerrs);
 exit:
 	if (len > size)
 		len = size;
@@ -280,70 +280,70 @@ static ssize_t read_file_antenna_diversity(struct file *file,
 		return -ENOMEM;
 
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)) {
-		len += snprintf(buf + len, size - len, "%s\n",
-				"Antenna Diversity Combining is disabled");
+		len += scnprintf(buf + len, size - len, "%s\n",
+				 "Antenna Diversity Combining is disabled");
 		goto exit;
 	}
 
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_antdiv_comb_conf_get(ah, &div_ant_conf);
-	len += snprintf(buf + len, size - len, "Current MAIN config : %s\n",
-			lna_conf_str[div_ant_conf.main_lna_conf]);
-	len += snprintf(buf + len, size - len, "Current ALT config  : %s\n",
-			lna_conf_str[div_ant_conf.alt_lna_conf]);
-	len += snprintf(buf + len, size - len, "Average MAIN RSSI   : %d\n",
-			as_main->rssi_avg);
-	len += snprintf(buf + len, size - len, "Average ALT RSSI    : %d\n\n",
-			as_alt->rssi_avg);
+	len += scnprintf(buf + len, size - len, "Current MAIN config : %s\n",
+			 lna_conf_str[div_ant_conf.main_lna_conf]);
+	len += scnprintf(buf + len, size - len, "Current ALT config  : %s\n",
+			 lna_conf_str[div_ant_conf.alt_lna_conf]);
+	len += scnprintf(buf + len, size - len, "Average MAIN RSSI   : %d\n",
+			 as_main->rssi_avg);
+	len += scnprintf(buf + len, size - len, "Average ALT RSSI    : %d\n\n",
+			 as_alt->rssi_avg);
 	ath9k_ps_restore(sc);
 
-	len += snprintf(buf + len, size - len, "Packet Receive Cnt:\n");
-	len += snprintf(buf + len, size - len, "-------------------\n");
-
-	len += snprintf(buf + len, size - len, "%30s%15s\n",
-			"MAIN", "ALT");
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"TOTAL COUNT",
-			as_main->recv_cnt,
-			as_alt->recv_cnt);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1",
-			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1],
-			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA2",
-			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2],
-			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1 + LNA2",
-			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
-			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1 - LNA2",
-			as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
-			as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
-
-	len += snprintf(buf + len, size - len, "\nLNA Config Attempts:\n");
-	len += snprintf(buf + len, size - len, "--------------------\n");
-
-	len += snprintf(buf + len, size - len, "%30s%15s\n",
-			"MAIN", "ALT");
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1",
-			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1],
-			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA2",
-			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2],
-			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1 + LNA2",
-			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
-			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
-	len += snprintf(buf + len, size - len, "%-14s:%15d%15d\n",
-			"LNA1 - LNA2",
-			as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
-			as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+	len += scnprintf(buf + len, size - len, "Packet Receive Cnt:\n");
+	len += scnprintf(buf + len, size - len, "-------------------\n");
+
+	len += scnprintf(buf + len, size - len, "%30s%15s\n",
+			 "MAIN", "ALT");
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "TOTAL COUNT",
+			 as_main->recv_cnt,
+			 as_alt->recv_cnt);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1",
+			 as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1],
+			 as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA2",
+			 as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2],
+			 as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA2]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1 + LNA2",
+			 as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
+			 as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1 - LNA2",
+			 as_main->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
+			 as_alt->lna_recv_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
+
+	len += scnprintf(buf + len, size - len, "\nLNA Config Attempts:\n");
+	len += scnprintf(buf + len, size - len, "--------------------\n");
+
+	len += scnprintf(buf + len, size - len, "%30s%15s\n",
+			 "MAIN", "ALT");
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1",
+			 as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1],
+			 as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA2",
+			 as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2],
+			 as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA2]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1 + LNA2",
+			 as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2],
+			 as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2]);
+	len += scnprintf(buf + len, size - len, "%-14s:%15d%15d\n",
+			 "LNA1 - LNA2",
+			 as_main->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2],
+			 as_alt->lna_attempt_cnt[ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2]);
 
 exit:
 	if (len > size)
@@ -385,21 +385,21 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
-			"Raw DMA Debug values:\n");
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
+			 "Raw DMA Debug values:\n");
 
 	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
 		if (i % 4 == 0)
-			len += snprintf(buf + len, DMA_BUF_LEN - len, "\n");
+			len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n");
 
 		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
-		len += snprintf(buf + len, DMA_BUF_LEN - len, "%d: %08x ",
-				i, val[i]);
+		len += scnprintf(buf + len, DMA_BUF_LEN - len, "%d: %08x ",
+				 i, val[i]);
 	}
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len, "\n\n");
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
-			"Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
+	len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n\n");
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
+			 "Num QCU: chain_st fsp_ok fsp_st DCU: chain_st\n");
 
 	for (i = 0; i < ATH9K_NUM_QUEUES; i++, qcuOffset += 4, dcuOffset += 5) {
 		if (i == 8) {
@@ -412,39 +412,39 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			dcuBase++;
 		}
 
-		len += snprintf(buf + len, DMA_BUF_LEN - len,
-			"%2d          %2x      %1x     %2x           %2x\n",
-			i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
-			(*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
-			val[2] & (0x7 << (i * 3)) >> (i * 3),
-			(*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
+		len += scnprintf(buf + len, DMA_BUF_LEN - len,
+			 "%2d          %2x      %1x     %2x           %2x\n",
+			 i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
+			 (*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
+			 val[2] & (0x7 << (i * 3)) >> (i * 3),
+			 (*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
 	}
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len, "\n");
+	len += scnprintf(buf + len, DMA_BUF_LEN - len, "\n");
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"qcu_stitch state:   %2x    qcu_fetch state:        %2x\n",
 		(val[3] & 0x003c0000) >> 18, (val[3] & 0x03c00000) >> 22);
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"qcu_complete state: %2x    dcu_complete state:     %2x\n",
 		(val[3] & 0x1c000000) >> 26, (val[6] & 0x3));
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"dcu_arb state:      %2x    dcu_fp state:           %2x\n",
 		(val[5] & 0x06000000) >> 25, (val[5] & 0x38000000) >> 27);
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"chan_idle_dur:     %3d    chan_idle_dur_valid:     %1d\n",
 		(val[6] & 0x000003fc) >> 2, (val[6] & 0x00000400) >> 10);
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"txfifo_valid_0:      %1d    txfifo_valid_1:          %1d\n",
 		(val[6] & 0x00000800) >> 11, (val[6] & 0x00001000) >> 12);
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
 		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x\n",
-			REG_READ_D(ah, AR_OBS_BUS_1));
-	len += snprintf(buf + len, DMA_BUF_LEN - len,
-			"AR_CR: 0x%x\n", REG_READ_D(ah, AR_CR));
+	len += scnprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x\n",
+			 REG_READ_D(ah, AR_OBS_BUS_1));
+	len += scnprintf(buf + len, DMA_BUF_LEN - len,
+			 "AR_CR: 0x%x\n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
@@ -530,9 +530,9 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 
 #define PR_IS(a, s)						\
 	do {							\
-		len += snprintf(buf + len, mxlen - len,		\
-				"%21s: %10u\n", a,		\
-				sc->debug.stats.istats.s);	\
+		len += scnprintf(buf + len, mxlen - len,	\
+				 "%21s: %10u\n", a,		\
+				 sc->debug.stats.istats.s);	\
 	} while (0)
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
@@ -563,8 +563,8 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	PR_IS("GENTIMER", gen_timer);
 	PR_IS("TOTAL", total);
 
-	len += snprintf(buf + len, mxlen - len,
-			"SYNC_CAUSE stats:\n");
+	len += scnprintf(buf + len, mxlen - len,
+			 "SYNC_CAUSE stats:\n");
 
 	PR_IS("Sync-All", sync_cause_all);
 	PR_IS("RTC-IRQ", sync_rtc_irq);
@@ -655,16 +655,16 @@ static ssize_t print_queue(struct ath_softc *sc, struct ath_txq *txq,
 
 	ath_txq_lock(sc, txq);
 
-	len += snprintf(buf + len, size - len, "%s: %d ",
-			"qnum", txq->axq_qnum);
-	len += snprintf(buf + len, size - len, "%s: %2d ",
-			"qdepth", txq->axq_depth);
-	len += snprintf(buf + len, size - len, "%s: %2d ",
-			"ampdu-depth", txq->axq_ampdu_depth);
-	len += snprintf(buf + len, size - len, "%s: %3d ",
-			"pending", txq->pending_frames);
-	len += snprintf(buf + len, size - len, "%s: %d\n",
-			"stopped", txq->stopped);
+	len += scnprintf(buf + len, size - len, "%s: %d ",
+			 "qnum", txq->axq_qnum);
+	len += scnprintf(buf + len, size - len, "%s: %2d ",
+			 "qdepth", txq->axq_depth);
+	len += scnprintf(buf + len, size - len, "%s: %2d ",
+			 "ampdu-depth", txq->axq_ampdu_depth);
+	len += scnprintf(buf + len, size - len, "%s: %3d ",
+			 "pending", txq->pending_frames);
+	len += scnprintf(buf + len, size - len, "%s: %d\n",
+			 "stopped", txq->stopped);
 
 	ath_txq_unlock(sc, txq);
 	return len;
@@ -687,11 +687,11 @@ static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		txq = sc->tx.txq_map[i];
-		len += snprintf(buf + len, size - len, "(%s):  ", qname[i]);
+		len += scnprintf(buf + len, size - len, "(%s):  ", qname[i]);
 		len += print_queue(sc, txq, buf + len, size - len);
 	}
 
-	len += snprintf(buf + len, size - len, "(CAB): ");
+	len += scnprintf(buf + len, size - len, "(CAB): ");
 	len += print_queue(sc, sc->beacon.cabq, buf + len, size - len);
 
 	if (len > size)
@@ -716,80 +716,82 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	unsigned int reg;
 	u32 rxfilter;
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"BSSID: %pM\n", common->curbssid);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"BSSID-MASK: %pM\n", common->bssidmask);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"OPMODE: %s\n", ath_opmode_to_string(sc->sc_ah->opmode));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "BSSID: %pM\n", common->curbssid);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "BSSID-MASK: %pM\n", common->bssidmask);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "OPMODE: %s\n",
+			 ath_opmode_to_string(sc->sc_ah->opmode));
 
 	ath9k_ps_wakeup(sc);
 	rxfilter = ath9k_hw_getrxfilter(sc->sc_ah);
 	ath9k_ps_restore(sc);
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"RXFILTER: 0x%x", rxfilter);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "RXFILTER: 0x%x", rxfilter);
 
 	if (rxfilter & ATH9K_RX_FILTER_UCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
+		len += scnprintf(buf + len, sizeof(buf) - len, " UCAST");
 	if (rxfilter & ATH9K_RX_FILTER_MCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");
+		len += scnprintf(buf + len, sizeof(buf) - len, " MCAST");
 	if (rxfilter & ATH9K_RX_FILTER_BCAST)
-		len += snprintf(buf + len, sizeof(buf) - len, " BCAST");
+		len += scnprintf(buf + len, sizeof(buf) - len, " BCAST");
 	if (rxfilter & ATH9K_RX_FILTER_CONTROL)
-		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL");
+		len += scnprintf(buf + len, sizeof(buf) - len, " CONTROL");
 	if (rxfilter & ATH9K_RX_FILTER_BEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " BEACON");
+		len += scnprintf(buf + len, sizeof(buf) - len, " BEACON");
 	if (rxfilter & ATH9K_RX_FILTER_PROM)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROM");
+		len += scnprintf(buf + len, sizeof(buf) - len, " PROM");
 	if (rxfilter & ATH9K_RX_FILTER_PROBEREQ)
-		len += snprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
+		len += scnprintf(buf + len, sizeof(buf) - len, " PROBEREQ");
 	if (rxfilter & ATH9K_RX_FILTER_PHYERR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYERR");
+		len += scnprintf(buf + len, sizeof(buf) - len, " PHYERR");
 	if (rxfilter & ATH9K_RX_FILTER_MYBEACON)
-		len += snprintf(buf + len, sizeof(buf) - len, " MYBEACON");
+		len += scnprintf(buf + len, sizeof(buf) - len, " MYBEACON");
 	if (rxfilter & ATH9K_RX_FILTER_COMP_BAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
+		len += scnprintf(buf + len, sizeof(buf) - len, " COMP_BAR");
 	if (rxfilter & ATH9K_RX_FILTER_PSPOLL)
-		len += snprintf(buf + len, sizeof(buf) - len, " PSPOLL");
+		len += scnprintf(buf + len, sizeof(buf) - len, " PSPOLL");
 	if (rxfilter & ATH9K_RX_FILTER_PHYRADAR)
-		len += snprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
+		len += scnprintf(buf + len, sizeof(buf) - len, " PHYRADAR");
 	if (rxfilter & ATH9K_RX_FILTER_MCAST_BCAST_ALL)
-		len += snprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
+		len += scnprintf(buf + len, sizeof(buf) - len, " MCAST_BCAST_ALL");
 	if (rxfilter & ATH9K_RX_FILTER_CONTROL_WRAPPER)
-		len += snprintf(buf + len, sizeof(buf) - len, " CONTROL_WRAPPER");
+		len += scnprintf(buf + len, sizeof(buf) - len, " CONTROL_WRAPPER");
 
-	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
 
 	reg = sc->sc_ah->imask;
 
-	len += snprintf(buf + len, sizeof(buf) - len, "INTERRUPT-MASK: 0x%x", reg);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "INTERRUPT-MASK: 0x%x", reg);
 
 	if (reg & ATH9K_INT_SWBA)
-		len += snprintf(buf + len, sizeof(buf) - len, " SWBA");
+		len += scnprintf(buf + len, sizeof(buf) - len, " SWBA");
 	if (reg & ATH9K_INT_BMISS)
-		len += snprintf(buf + len, sizeof(buf) - len, " BMISS");
+		len += scnprintf(buf + len, sizeof(buf) - len, " BMISS");
 	if (reg & ATH9K_INT_CST)
-		len += snprintf(buf + len, sizeof(buf) - len, " CST");
+		len += scnprintf(buf + len, sizeof(buf) - len, " CST");
 	if (reg & ATH9K_INT_RX)
-		len += snprintf(buf + len, sizeof(buf) - len, " RX");
+		len += scnprintf(buf + len, sizeof(buf) - len, " RX");
 	if (reg & ATH9K_INT_RXHP)
-		len += snprintf(buf + len, sizeof(buf) - len, " RXHP");
+		len += scnprintf(buf + len, sizeof(buf) - len, " RXHP");
 	if (reg & ATH9K_INT_RXLP)
-		len += snprintf(buf + len, sizeof(buf) - len, " RXLP");
+		len += scnprintf(buf + len, sizeof(buf) - len, " RXLP");
 	if (reg & ATH9K_INT_BB_WATCHDOG)
-		len += snprintf(buf + len, sizeof(buf) - len, " BB_WATCHDOG");
+		len += scnprintf(buf + len, sizeof(buf) - len, " BB_WATCHDOG");
 
-	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
 
 	ath9k_calculate_iter_data(hw, NULL, &iter_data);
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
-			" ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
-			iter_data.naps, iter_data.nstations, iter_data.nmeshes,
-			iter_data.nwds, iter_data.nadhocs,
-			sc->nvifs, sc->nbcnvifs);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "VIF-COUNTS: AP: %i STA: %i MESH: %i WDS: %i"
+			 " ADHOC: %i TOTAL: %hi BEACON-VIF: %hi\n",
+			 iter_data.naps, iter_data.nstations, iter_data.nmeshes,
+			 iter_data.nwds, iter_data.nadhocs,
+			 sc->nvifs, sc->nbcnvifs);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -805,27 +807,27 @@ static ssize_t read_file_reset(struct file *file, char __user *user_buf,
 	char buf[512];
 	unsigned int len = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "Baseband Hang",
-			sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "Baseband Watchdog",
-			sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "Fatal HW Error",
-			sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "TX HW error",
-			sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "TX Path Hang",
-			sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "PLL RX Hang",
-			sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%17s: %2d\n", "MCI Reset",
-			sc->debug.stats.reset[RESET_TYPE_MCI]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "Baseband Hang",
+			 sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "Baseband Watchdog",
+			 sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "Fatal HW Error",
+			 sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "TX HW error",
+			 sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "TX Path Hang",
+			 sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "PLL RX Hang",
+			 sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "MCI Reset",
+			 sc->debug.stats.reset[RESET_TYPE_MCI]);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -902,14 +904,14 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 #define PHY_ERR(s, p) \
-	len += snprintf(buf + len, size - len, "%22s : %10u\n", s, \
-			sc->debug.stats.rxstats.phy_err_stats[p]);
+	len += scnprintf(buf + len, size - len, "%22s : %10u\n", s, \
+			 sc->debug.stats.rxstats.phy_err_stats[p]);
 
 #define RXS_ERR(s, e)					    \
 	do {						    \
-		len += snprintf(buf + len, size - len,	    \
-				"%22s : %10u\n", s,	    \
-				sc->debug.stats.rxstats.e); \
+		len += scnprintf(buf + len, size - len,	    \
+				 "%22s : %10u\n", s,	    \
+				 sc->debug.stats.rxstats.e);\
 	} while (0)
 
 	struct ath_softc *sc = file->private_data;
@@ -1439,22 +1441,22 @@ static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
 	if (!buf)
 		return -ENOMEM;
 
-	len += snprintf(buf + len, size - len,
-			"Channel Noise Floor : %d\n", ah->noise);
-	len += snprintf(buf + len, size - len,
-			"Chain | privNF | # Readings | NF Readings\n");
+	len += scnprintf(buf + len, size - len,
+			 "Channel Noise Floor : %d\n", ah->noise);
+	len += scnprintf(buf + len, size - len,
+			 "Chain | privNF | # Readings | NF Readings\n");
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (!(chainmask & (1 << i)) ||
 		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
 			continue;
 
 		nread = AR_PHY_CCA_FILTERWINDOW_LENGTH - h[i].invalidNFcount;
-		len += snprintf(buf + len, size - len, " %d\t %d\t %d\t\t",
-				i, h[i].privNF, nread);
+		len += scnprintf(buf + len, size - len, " %d\t %d\t %d\t\t",
+				 i, h[i].privNF, nread);
 		for (j = 0; j < nread; j++)
-			len += snprintf(buf + len, size - len,
-					" %d", h[i].nfCalBuffer[j]);
-		len += snprintf(buf + len, size - len, "\n");
+			len += scnprintf(buf + len, size - len,
+					 " %d", h[i].nfCalBuffer[j]);
+		len += scnprintf(buf + len, size - len, "\n");
 	}
 
 	if (len > size)
@@ -1543,8 +1545,8 @@ static ssize_t read_file_btcoex(struct file *file, char __user *user_buf,
 		return -ENOMEM;
 
 	if (!sc->sc_ah->common.btcoex_enabled) {
-		len = snprintf(buf, size, "%s\n",
-			       "BTCOEX is disabled");
+		len = scnprintf(buf, size, "%s\n",
+				"BTCOEX is disabled");
 		goto exit;
 	}
 
@@ -1582,43 +1584,43 @@ static ssize_t read_file_node_stat(struct file *file, char __user *user_buf,
 		return -ENOMEM;
 
 	if (!an->sta->ht_cap.ht_supported) {
-		len = snprintf(buf, size, "%s\n",
-			       "HT not supported");
+		len = scnprintf(buf, size, "%s\n",
+				"HT not supported");
 		goto exit;
 	}
 
-	len = snprintf(buf, size, "Max-AMPDU: %d\n",
-		       an->maxampdu);
-	len += snprintf(buf + len, size - len, "MPDU Density: %d\n\n",
-			an->mpdudensity);
+	len = scnprintf(buf, size, "Max-AMPDU: %d\n",
+			an->maxampdu);
+	len += scnprintf(buf + len, size - len, "MPDU Density: %d\n\n",
+			 an->mpdudensity);
 
-	len += snprintf(buf + len, size - len,
-			"%2s%7s\n", "AC", "SCHED");
+	len += scnprintf(buf + len, size - len,
+			 "%2s%7s\n", "AC", "SCHED");
 
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
 		txq = ac->txq;
 		ath_txq_lock(sc, txq);
-		len += snprintf(buf + len, size - len,
-				"%2d%7d\n",
-				acno, ac->sched);
+		len += scnprintf(buf + len, size - len,
+				 "%2d%7d\n",
+				 acno, ac->sched);
 		ath_txq_unlock(sc, txq);
 	}
 
-	len += snprintf(buf + len, size - len,
-			"\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
-			"TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
-			"BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
+	len += scnprintf(buf + len, size - len,
+			 "\n%3s%11s%10s%10s%10s%10s%9s%6s%8s\n",
+			 "TID", "SEQ_START", "SEQ_NEXT", "BAW_SIZE",
+			 "BAW_HEAD", "BAW_TAIL", "BAR_IDX", "SCHED", "PAUSED");
 
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 		txq = tid->ac->txq;
 		ath_txq_lock(sc, txq);
-		len += snprintf(buf + len, size - len,
-				"%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
-				tid->tidno, tid->seq_start, tid->seq_next,
-				tid->baw_size, tid->baw_head, tid->baw_tail,
-				tid->bar_index, tid->sched, tid->paused);
+		len += scnprintf(buf + len, size - len,
+				 "%3d%11d%10d%10d%10d%10d%9d%6d%8d\n",
+				 tid->tidno, tid->seq_start, tid->seq_next,
+				 tid->baw_size, tid->baw_head, tid->baw_tail,
+				 tid->bar_index, tid->sched, tid->paused);
 		ath_txq_unlock(sc, txq);
 	}
 exit:
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 6e1556f..d6e3fa4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -193,12 +193,12 @@ struct ath_tx_stats {
 #define TXSTATS sc->debug.stats.txstats
 #define PR(str, elem)							\
 	do {								\
-		len += snprintf(buf + len, size - len,			\
-				"%s%13u%11u%10u%10u\n", str,		\
-				TXSTATS[PR_QNUM(IEEE80211_AC_BE)].elem,	\
-				TXSTATS[PR_QNUM(IEEE80211_AC_BK)].elem,	\
-				TXSTATS[PR_QNUM(IEEE80211_AC_VI)].elem,	\
-				TXSTATS[PR_QNUM(IEEE80211_AC_VO)].elem); \
+		len += scnprintf(buf + len, size - len,			\
+				 "%s%13u%11u%10u%10u\n", str,		\
+				 TXSTATS[PR_QNUM(IEEE80211_AC_BE)].elem,\
+				 TXSTATS[PR_QNUM(IEEE80211_AC_BK)].elem,\
+				 TXSTATS[PR_QNUM(IEEE80211_AC_VI)].elem,\
+				 TXSTATS[PR_QNUM(IEEE80211_AC_VO)].elem); \
 	} while(0)
 
 #define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 1aa0d92..371b999 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -25,11 +25,11 @@
 struct ath_dfs_pool_stats global_dfs_pool_stats = { 0 };
 
 #define ATH9K_DFS_STAT(s, p) \
-	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
-			sc->debug.stats.dfs_stats.p);
+	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			 sc->debug.stats.dfs_stats.p);
 #define ATH9K_DFS_POOL_STAT(s, p) \
-	len += snprintf(buf + len, size - len, "%28s : %10u\n", s, \
-			global_dfs_pool_stats.p);
+	len += scnprintf(buf + len, size - len, "%28s : %10u\n", s, \
+			 global_dfs_pool_stats.p);
 
 static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
@@ -44,12 +44,12 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += snprintf(buf + len, size - len, "DFS support for "
-			"macVersion = 0x%x, macRev = 0x%x: %s\n",
-			hw_ver->macVersion, hw_ver->macRev,
-			(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
+	len += scnprintf(buf + len, size - len, "DFS support for "
+			 "macVersion = 0x%x, macRev = 0x%x: %s\n",
+			 hw_ver->macVersion, hw_ver->macRev,
+			 (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
 					"enabled" : "disabled");
-	len += snprintf(buf + len, size - len, "Pulse detector statistics:\n");
+	len += scnprintf(buf + len, size - len, "Pulse detector statistics:\n");
 	ATH9K_DFS_STAT("pulse events reported   ", pulses_total);
 	ATH9K_DFS_STAT("invalid pulse events    ", pulses_no_dfs);
 	ATH9K_DFS_STAT("DFS pulses detected     ", pulses_detected);
@@ -59,11 +59,12 @@ static ssize_t read_file_dfs(struct file *file, char __user *user_buf,
 	ATH9K_DFS_STAT("Primary channel pulses  ", pri_phy_errors);
 	ATH9K_DFS_STAT("Secondary channel pulses", ext_phy_errors);
 	ATH9K_DFS_STAT("Dual channel pulses     ", dc_phy_errors);
-	len += snprintf(buf + len, size - len, "Radar detector statistics "
-			"(current DFS region: %d)\n", sc->dfs_detector->region);
+	len += scnprintf(buf + len, size - len, "Radar detector statistics "
+			 "(current DFS region: %d)\n",
+			 sc->dfs_detector->region);
 	ATH9K_DFS_STAT("Pulse events processed  ", pulses_processed);
 	ATH9K_DFS_STAT("Radars detected         ", radar_detected);
-	len += snprintf(buf + len, size - len, "Global Pool statistics:\n");
+	len += scnprintf(buf + len, size - len, "Global Pool statistics:\n");
 	ATH9K_DFS_POOL_STAT("Pool references         ", pool_reference);
 	ATH9K_DFS_POOL_STAT("Pulses allocated        ", pulse_allocated);
 	ATH9K_DFS_POOL_STAT("Pulses alloc error      ", pulse_alloc_error);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 9ea8e4b..b409171 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -129,10 +129,10 @@ static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
 
 	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "2GHz modal Header");
 		len = ath9k_dump_4k_modal_eeprom(buf, len, size,
-						  &eep->modalHeader);
+						 &eep->modalHeader);
 		goto out;
 	}
 
@@ -160,8 +160,8 @@ static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
 	PR_EEP("TX Gain type", pBase->txGainType);
 
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
+	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			 pBase->macAddr);
 
 out:
 	if (len > size)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 3ae1f3d..e1d0c21 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -125,8 +125,8 @@ static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
 
 	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "2GHz modal Header");
 		len = ar9287_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader);
 		goto out;
@@ -157,8 +157,8 @@ static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	PR_EEP("Power Table Offset", pBase->pwrTableOffset);
 	PR_EEP("OpenLoop Power Ctrl", pBase->openLoopPwrCntl);
 
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
+	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			 pBase->macAddr);
 
 out:
 	if (len > size)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 1c25368..39107e3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -205,12 +205,12 @@ static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	struct base_eep_header *pBase = &eep->baseEepHeader;
 
 	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "2GHz modal Header");
 		len = ath9k_def_dump_modal_eeprom(buf, len, size,
 						   &eep->modalHeader[0]);
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "5GHz modal Header");
+		len += scnprintf(buf + len, size - len,
+				 "%20s :\n", "5GHz modal Header");
 		len = ath9k_def_dump_modal_eeprom(buf, len, size,
 						   &eep->modalHeader[1]);
 		goto out;
@@ -240,8 +240,8 @@ static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
 	PR_EEP("OpenLoop Power Ctrl", pBase->openLoopPwrCntl);
 
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
+	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			 pBase->macAddr);
 
 out:
 	if (len > size)
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4b412aa..c34f212 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -522,22 +522,22 @@ static int ath9k_dump_mci_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 	ATH_DUMP_BTCOEX("Concurrent Tx", btcoex_hw->mci.concur_tx);
 	ATH_DUMP_BTCOEX("Concurrent RSSI cnt", btcoex->rssi_count);
 
-	len += snprintf(buf + len, size - len, "BT Weights: ");
+	len += scnprintf(buf + len, size - len, "BT Weights: ");
 	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
-		len += snprintf(buf + len, size - len, "%08x ",
-				btcoex_hw->bt_weight[i]);
-	len += snprintf(buf + len, size - len, "\n");
-	len += snprintf(buf + len, size - len, "WLAN Weights: ");
+		len += scnprintf(buf + len, size - len, "%08x ",
+				 btcoex_hw->bt_weight[i]);
+	len += scnprintf(buf + len, size - len, "\n");
+	len += scnprintf(buf + len, size - len, "WLAN Weights: ");
 	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
-		len += snprintf(buf + len, size - len, "%08x ",
-				btcoex_hw->wlan_weight[i]);
-	len += snprintf(buf + len, size - len, "\n");
-	len += snprintf(buf + len, size - len, "Tx Priorities: ");
+		len += scnprintf(buf + len, size - len, "%08x ",
+				 btcoex_hw->wlan_weight[i]);
+	len += scnprintf(buf + len, size - len, "\n");
+	len += scnprintf(buf + len, size - len, "Tx Priorities: ");
 	for (i = 0; i < ATH_BTCOEX_STOMP_MAX; i++)
-		len += snprintf(buf + len, size - len, "%08x ",
+		len += scnprintf(buf + len, size - len, "%08x ",
 				btcoex_hw->tx_prio[i]);
 
-	len += snprintf(buf + len, size - len, "\n");
+	len += scnprintf(buf + len, size - len, "\n");
 
 	return len;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index c1b45e2..fb071ee 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -37,29 +37,29 @@ static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
 
 	ath9k_htc_ps_restore(priv);
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "RX",
-			be32_to_cpu(cmd_rsp.rx));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "RX",
+			 be32_to_cpu(cmd_rsp.rx));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "RXORN",
-			be32_to_cpu(cmd_rsp.rxorn));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "RXORN",
+			 be32_to_cpu(cmd_rsp.rxorn));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "RXEOL",
-			be32_to_cpu(cmd_rsp.rxeol));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "RXEOL",
+			 be32_to_cpu(cmd_rsp.rxeol));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "TXURN",
-			be32_to_cpu(cmd_rsp.txurn));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "TXURN",
+			 be32_to_cpu(cmd_rsp.txurn));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "TXTO",
-			be32_to_cpu(cmd_rsp.txto));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "TXTO",
+			 be32_to_cpu(cmd_rsp.txto));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "CST",
-			be32_to_cpu(cmd_rsp.cst));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "CST",
+			 be32_to_cpu(cmd_rsp.cst));
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -95,41 +95,41 @@ static ssize_t read_file_tgt_tx_stats(struct file *file, char __user *user_buf,
 
 	ath9k_htc_ps_restore(priv);
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "Xretries",
-			be32_to_cpu(cmd_rsp.xretries));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "Xretries",
+			 be32_to_cpu(cmd_rsp.xretries));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "FifoErr",
-			be32_to_cpu(cmd_rsp.fifoerr));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "FifoErr",
+			 be32_to_cpu(cmd_rsp.fifoerr));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "Filtered",
-			be32_to_cpu(cmd_rsp.filtered));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "Filtered",
+			 be32_to_cpu(cmd_rsp.filtered));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "TimerExp",
-			be32_to_cpu(cmd_rsp.timer_exp));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "TimerExp",
+			 be32_to_cpu(cmd_rsp.timer_exp));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "ShortRetries",
-			be32_to_cpu(cmd_rsp.shortretries));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "ShortRetries",
+			 be32_to_cpu(cmd_rsp.shortretries));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "LongRetries",
-			be32_to_cpu(cmd_rsp.longretries));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "LongRetries",
+			 be32_to_cpu(cmd_rsp.longretries));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "QueueNull",
-			be32_to_cpu(cmd_rsp.qnull));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "QueueNull",
+			 be32_to_cpu(cmd_rsp.qnull));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "EncapFail",
-			be32_to_cpu(cmd_rsp.encap_fail));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "EncapFail",
+			 be32_to_cpu(cmd_rsp.encap_fail));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "NoBuf",
-			be32_to_cpu(cmd_rsp.nobuf));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "NoBuf",
+			 be32_to_cpu(cmd_rsp.nobuf));
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -165,17 +165,17 @@ static ssize_t read_file_tgt_rx_stats(struct file *file, char __user *user_buf,
 
 	ath9k_htc_ps_restore(priv);
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "NoBuf",
-			be32_to_cpu(cmd_rsp.nobuf));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "NoBuf",
+			 be32_to_cpu(cmd_rsp.nobuf));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "HostSend",
-			be32_to_cpu(cmd_rsp.host_send));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "HostSend",
+			 be32_to_cpu(cmd_rsp.host_send));
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "HostDone",
-			be32_to_cpu(cmd_rsp.host_done));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "HostDone",
+			 be32_to_cpu(cmd_rsp.host_done));
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -197,37 +197,37 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	char buf[512];
 	unsigned int len = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "Buffers queued",
-			priv->debug.tx_stats.buf_queued);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "Buffers completed",
-			priv->debug.tx_stats.buf_completed);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "SKBs queued",
-			priv->debug.tx_stats.skb_queued);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "SKBs success",
-			priv->debug.tx_stats.skb_success);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "SKBs failed",
-			priv->debug.tx_stats.skb_failed);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "CAB queued",
-			priv->debug.tx_stats.cab_queued);
-
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "BE queued",
-			priv->debug.tx_stats.queue_stats[IEEE80211_AC_BE]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "BK queued",
-			priv->debug.tx_stats.queue_stats[IEEE80211_AC_BK]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "VI queued",
-			priv->debug.tx_stats.queue_stats[IEEE80211_AC_VI]);
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"%20s : %10u\n", "VO queued",
-			priv->debug.tx_stats.queue_stats[IEEE80211_AC_VO]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "Buffers queued",
+			 priv->debug.tx_stats.buf_queued);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "Buffers completed",
+			 priv->debug.tx_stats.buf_completed);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "SKBs queued",
+			 priv->debug.tx_stats.skb_queued);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "SKBs success",
+			 priv->debug.tx_stats.skb_success);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "SKBs failed",
+			 priv->debug.tx_stats.skb_failed);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "CAB queued",
+			 priv->debug.tx_stats.cab_queued);
+
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "BE queued",
+			 priv->debug.tx_stats.queue_stats[IEEE80211_AC_BE]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "BK queued",
+			 priv->debug.tx_stats.queue_stats[IEEE80211_AC_BK]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "VI queued",
+			 priv->debug.tx_stats.queue_stats[IEEE80211_AC_VI]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%20s : %10u\n", "VO queued",
+			 priv->debug.tx_stats.queue_stats[IEEE80211_AC_VO]);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
@@ -273,8 +273,8 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 #define PHY_ERR(s, p)							\
-	len += snprintf(buf + len, size - len, "%20s : %10u\n", s,	\
-			priv->debug.rx_stats.err_phy_stats[p]);
+	len += scnprintf(buf + len, size - len, "%20s : %10u\n", s,	\
+			 priv->debug.rx_stats.err_phy_stats[p]);
 
 	struct ath9k_htc_priv *priv = file->private_data;
 	char *buf;
@@ -285,37 +285,37 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "SKBs allocated",
-			priv->debug.rx_stats.skb_allocated);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "SKBs completed",
-			priv->debug.rx_stats.skb_completed);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "SKBs Dropped",
-			priv->debug.rx_stats.skb_dropped);
-
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "CRC ERR",
-			priv->debug.rx_stats.err_crc);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "DECRYPT CRC ERR",
-			priv->debug.rx_stats.err_decrypt_crc);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "MIC ERR",
-			priv->debug.rx_stats.err_mic);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "PRE-DELIM CRC ERR",
-			priv->debug.rx_stats.err_pre_delim);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "POST-DELIM CRC ERR",
-			priv->debug.rx_stats.err_post_delim);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "DECRYPT BUSY ERR",
-			priv->debug.rx_stats.err_decrypt_busy);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10u\n", "TOTAL PHY ERR",
-			priv->debug.rx_stats.err_phy);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "SKBs allocated",
+			 priv->debug.rx_stats.skb_allocated);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "SKBs completed",
+			 priv->debug.rx_stats.skb_completed);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "SKBs Dropped",
+			 priv->debug.rx_stats.skb_dropped);
+
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "CRC ERR",
+			 priv->debug.rx_stats.err_crc);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "DECRYPT CRC ERR",
+			 priv->debug.rx_stats.err_decrypt_crc);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "MIC ERR",
+			 priv->debug.rx_stats.err_mic);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "PRE-DELIM CRC ERR",
+			 priv->debug.rx_stats.err_pre_delim);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "POST-DELIM CRC ERR",
+			 priv->debug.rx_stats.err_post_delim);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "DECRYPT BUSY ERR",
+			 priv->debug.rx_stats.err_decrypt_busy);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10u\n", "TOTAL PHY ERR",
+			 priv->debug.rx_stats.err_phy);
 
 
 	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
@@ -372,16 +372,16 @@ static ssize_t read_file_slot(struct file *file, char __user *user_buf,
 
 	spin_lock_bh(&priv->tx.tx_lock);
 
-	len += snprintf(buf + len, sizeof(buf) - len, "TX slot bitmap : ");
+	len += scnprintf(buf + len, sizeof(buf) - len, "TX slot bitmap : ");
 
 	len += bitmap_scnprintf(buf + len, sizeof(buf) - len,
 			       priv->tx.tx_slot, MAX_TX_BUF_NUM);
 
-	len += snprintf(buf + len, sizeof(buf) - len, "\n");
+	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
 
-	len += snprintf(buf + len, sizeof(buf) - len,
-			"Used slots     : %d\n",
-			bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "Used slots     : %d\n",
+			 bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
 
 	spin_unlock_bh(&priv->tx.tx_lock);
 
@@ -405,30 +405,30 @@ static ssize_t read_file_queue(struct file *file, char __user *user_buf,
 	char buf[512];
 	unsigned int len = 0;
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Mgmt endpoint", skb_queue_len(&priv->tx.mgmt_ep_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Mgmt endpoint", skb_queue_len(&priv->tx.mgmt_ep_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Cab endpoint", skb_queue_len(&priv->tx.cab_ep_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Cab endpoint", skb_queue_len(&priv->tx.cab_ep_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Data BE endpoint", skb_queue_len(&priv->tx.data_be_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Data BE endpoint", skb_queue_len(&priv->tx.data_be_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Data BK endpoint", skb_queue_len(&priv->tx.data_bk_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Data BK endpoint", skb_queue_len(&priv->tx.data_bk_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Data VI endpoint", skb_queue_len(&priv->tx.data_vi_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Data VI endpoint", skb_queue_len(&priv->tx.data_vi_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Data VO endpoint", skb_queue_len(&priv->tx.data_vo_queue));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Data VO endpoint", skb_queue_len(&priv->tx.data_vo_queue));
 
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Failed queue", skb_queue_len(&priv->tx.tx_failed));
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Failed queue", skb_queue_len(&priv->tx.tx_failed));
 
 	spin_lock_bh(&priv->tx.tx_lock);
-	len += snprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
-			"Queued count", priv->tx.queued_cnt);
+	len += scnprintf(buf + len, sizeof(buf) - len, "%20s : %10u\n",
+			 "Queued count", priv->tx.queued_cnt);
 	spin_unlock_bh(&priv->tx.tx_lock);
 
 	if (len > sizeof(buf))
@@ -507,70 +507,70 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "Major Version",
-			pBase->version >> 12);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "Minor Version",
-			pBase->version & 0xFFF);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "Checksum",
-			pBase->checksum);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "Length",
-			pBase->length);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "RegDomain1",
-			pBase->regDmn[0]);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n", "RegDomain2",
-			pBase->regDmn[1]);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"TX Mask", pBase->txMask);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"RX Mask", pBase->rxMask);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Allow 5GHz",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Allow 2GHz",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Disable 2GHz HT20",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Disable 2GHz HT40",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Disable 5Ghz HT20",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Disable 5Ghz HT40",
-			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Big Endian",
-			!!(pBase->eepMisc & 0x01));
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Cal Bin Major Ver",
-			(pBase->binBuildNumber >> 24) & 0xFF);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Cal Bin Minor Ver",
-			(pBase->binBuildNumber >> 16) & 0xFF);
-	len += snprintf(buf + len, size - len,
-			"%20s : %10d\n",
-			"Cal Bin Build",
-			(pBase->binBuildNumber >> 8) & 0xFF);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "Major Version",
+			 pBase->version >> 12);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "Minor Version",
+			 pBase->version & 0xFFF);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "Checksum",
+			 pBase->checksum);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "Length",
+			 pBase->length);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "RegDomain1",
+			 pBase->regDmn[0]);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n", "RegDomain2",
+			 pBase->regDmn[1]);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "TX Mask", pBase->txMask);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "RX Mask", pBase->rxMask);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Allow 5GHz",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Allow 2GHz",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Disable 2GHz HT20",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Disable 2GHz HT40",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Disable 5Ghz HT20",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Disable 5Ghz HT40",
+			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Big Endian",
+			 !!(pBase->eepMisc & 0x01));
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Cal Bin Major Ver",
+			 (pBase->binBuildNumber >> 24) & 0xFF);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Cal Bin Minor Ver",
+			 (pBase->binBuildNumber >> 16) & 0xFF);
+	len += scnprintf(buf + len, size - len,
+			 "%20s : %10d\n",
+			 "Cal Bin Build",
+			 (pBase->binBuildNumber >> 8) & 0xFF);
 
 	/*
 	 * UB91 specific data.
@@ -579,10 +579,10 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 		struct base_eep_header_4k *pBase4k =
 			&priv->ah->eeprom.map4k.baseEepHeader;
 
-		len += snprintf(buf + len, size - len,
-				"%20s : %10d\n",
-				"TX Gain type",
-				pBase4k->txGainType);
+		len += scnprintf(buf + len, size - len,
+				 "%20s : %10d\n",
+				 "TX Gain type",
+				 pBase4k->txGainType);
 	}
 
 	/*
@@ -592,19 +592,19 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
 		struct base_eep_ar9287_header *pBase9287 =
 			&priv->ah->eeprom.map9287.baseEepHeader;
 
-		len += snprintf(buf + len, size - len,
-				"%20s : %10ddB\n",
-				"Power Table Offset",
-				pBase9287->pwrTableOffset);
+		len += scnprintf(buf + len, size - len,
+				 "%20s : %10ddB\n",
+				 "Power Table Offset",
+				 pBase9287->pwrTableOffset);
 
-		len += snprintf(buf + len, size - len,
-				"%20s : %10d\n",
-				"OpenLoop Power Ctrl",
-				pBase9287->openLoopPwrCntl);
+		len += scnprintf(buf + len, size - len,
+				 "%20s : %10d\n",
+				 "OpenLoop Power Ctrl",
+				 pBase9287->openLoopPwrCntl);
 	}
 
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
+	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			 pBase->macAddr);
 	if (len > size)
 		len = size;
 
@@ -627,8 +627,8 @@ static ssize_t read_4k_modal_eeprom(struct file *file,
 {
 #define PR_EEP(_s, _val)						\
 	do {								\
-		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
-				_s, (_val));				\
+		len += scnprintf(buf + len, size - len, "%20s : %10d\n",\
+				 _s, (_val));				\
 	} while (0)
 
 	struct ath9k_htc_priv *priv = file->private_data;
@@ -708,12 +708,12 @@ static ssize_t read_def_modal_eeprom(struct file *file,
 	do {								\
 		if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {		\
 			pModal = &priv->ah->eeprom.def.modalHeader[1];	\
-			len += snprintf(buf + len, size - len, "%20s : %8d%7s", \
-					_s, (_val), "|");		\
+			len += scnprintf(buf + len, size - len, "%20s : %8d%7s", \
+					 _s, (_val), "|");		\
 		}							\
 		if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {		\
 			pModal = &priv->ah->eeprom.def.modalHeader[0];	\
-			len += snprintf(buf + len, size - len, "%9d\n", \
+			len += scnprintf(buf + len, size - len, "%9d\n",\
 					(_val));			\
 		}							\
 	} while (0)
@@ -729,10 +729,10 @@ static ssize_t read_def_modal_eeprom(struct file *file,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += snprintf(buf + len, size - len,
-			"%31s %15s\n", "2G", "5G");
-	len += snprintf(buf + len, size - len,
-			"%32s %16s\n", "====", "====\n");
+	len += scnprintf(buf + len, size - len,
+			 "%31s %15s\n", "2G", "5G");
+	len += scnprintf(buf + len, size - len,
+			 "%32s %16s\n", "====", "====\n");
 
 	PR_EEP("Chain0 Ant. Control", pModal->antCtrlChain[0]);
 	PR_EEP("Chain1 Ant. Control", pModal->antCtrlChain[1]);
@@ -814,8 +814,8 @@ static ssize_t read_9287_modal_eeprom(struct file *file,
 {
 #define PR_EEP(_s, _val)						\
 	do {								\
-		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
-				_s, (_val));				\
+		len += scnprintf(buf + len, size - len, "%20s : %10d\n",\
+				 _s, (_val));				\
 	} while (0)
 
 	struct ath9k_htc_priv *priv = file->private_data;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ecc6ec4..10d6c7b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3240,19 +3240,19 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 
 	/* chipsets >= AR9280 are single-chip */
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		used = snprintf(hw_name, len,
-			       "Atheros AR%s Rev:%x",
-			       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
-			       ah->hw_version.macRev);
+		used = scnprintf(hw_name, len,
+				 "Atheros AR%s Rev:%x",
+				 ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
+				 ah->hw_version.macRev);
 	}
 	else {
-		used = snprintf(hw_name, len,
-			       "Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x",
-			       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
-			       ah->hw_version.macRev,
-			       ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
-						AR_RADIO_SREV_MAJOR)),
-			       ah->hw_version.phyRev);
+		used = scnprintf(hw_name, len,
+				 "Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x",
+				 ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
+				 ah->hw_version.macRev,
+				 ath9k_hw_rf_name((ah->hw_version.analog5GhzRev
+						  & AR_RADIO_SREV_MAJOR)),
+				 ah->hw_version.phyRev);
 	}
 
 	hw_name[used] = '\0';
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 69a907b..ab2f1ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -98,8 +98,8 @@
 
 #define PR_EEP(_s, _val)						\
 	do {								\
-		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
-				_s, (_val));				\
+		len += scnprintf(buf + len, size - len, "%20s : %10d\n",\
+				 _s, (_val));				\
 	} while (0)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index d3d7c51..d829bb6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1387,31 +1387,31 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 		int used_mcs = 0, used_htmode = 0;
 
 		if (WLAN_RC_PHY_HT(rc->rate_table->info[i].phy)) {
-			used_mcs = snprintf(mcs, 5, "%d",
-				rc->rate_table->info[i].ratecode);
+			used_mcs = scnprintf(mcs, 5, "%d",
+					     rc->rate_table->info[i].ratecode);
 
 			if (WLAN_RC_PHY_40(rc->rate_table->info[i].phy))
-				used_htmode = snprintf(htmode, 5, "HT40");
+				used_htmode = scnprintf(htmode, 5, "HT40");
 			else if (WLAN_RC_PHY_20(rc->rate_table->info[i].phy))
-				used_htmode = snprintf(htmode, 5, "HT20");
+				used_htmode = scnprintf(htmode, 5, "HT20");
 			else
-				used_htmode = snprintf(htmode, 5, "????");
+				used_htmode = scnprintf(htmode, 5, "????");
 		}
 
 		mcs[used_mcs] = '\0';
 		htmode[used_htmode] = '\0';
 
-		len += snprintf(buf + len, max - len,
-			"%6s %6s %3u.%d: "
-			"%10u %10u %10u %10u\n",
-			htmode,
-			mcs,
-			ratekbps / 1000,
-			(ratekbps % 1000) / 100,
-			stats->success,
-			stats->retries,
-			stats->xretries,
-			stats->per);
+		len += scnprintf(buf + len, max - len,
+				 "%6s %6s %3u.%d: "
+				 "%10u %10u %10u %10u\n",
+				 htmode,
+				 mcs,
+				 ratekbps / 1000,
+				 (ratekbps % 1000) / 100,
+				 stats->success,
+				 stats->retries,
+				 stats->xretries,
+				 stats->per);
 	}
 
 	if (len > max)
-- 
1.8.1.2

