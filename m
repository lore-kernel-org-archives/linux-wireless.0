Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2BCQdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:33:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 23/25] iwlegacy: merge il_base_params into il_cfg
Date: Fri,  3 Feb 2012 17:31:59 +0100
Message-Id: <1328286721-11309-24-git-send-email-sgruszka@redhat.com> (sfid-20120203_173334_375537_5AC90462)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c       |   30 +++++++++++++----------
 drivers/net/wireless/iwlegacy/4965-calib.c |   14 +++++-----
 drivers/net/wireless/iwlegacy/4965-mac.c   |    8 +++---
 drivers/net/wireless/iwlegacy/4965.c       |   37 +++++++++++++---------------
 drivers/net/wireless/iwlegacy/common.c     |   28 ++++++++++----------
 drivers/net/wireless/iwlegacy/common.h     |   31 ++++++++++++-----------
 drivers/net/wireless/iwlegacy/debug.c      |   16 ++++++------
 7 files changed, 83 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 918cbef..7c21a57 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2398,7 +2398,7 @@ il3945_hw_set_hw_params(struct il_priv *il)
 	il->hw_params.bcast_id = IL3945_BROADCAST_ID;
 
 	/* Assign number of Usable TX queues */
-	il->hw_params.max_txq_num = il->cfg->base_params->num_of_queues;
+	il->hw_params.max_txq_num = il->cfg->num_of_queues;
 
 	il->hw_params.tfd_size = sizeof(struct il3945_tfd);
 	il->hw_params.rx_page_order = get_order(IL_RX_BUF_SIZE_3K);
@@ -2693,16 +2693,6 @@ const struct il_ops il3945_ops = {
 	.legacy = &il3945_legacy_ops,
 };
 
-static struct il_base_params il3945_base_params = {
-	.eeprom_size = IL3945_EEPROM_IMG_SIZE,
-	.num_of_queues = IL39_NUM_QUEUES,
-	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
-	.set_l0s = false,
-	.use_bsm = true,
-	.led_compensation = 64,
-	.wd_timeout = IL_DEF_WD_TIMEOUT,
-};
-
 static struct il_cfg il3945_bg_cfg = {
 	.name = "3945BG",
 	.fw_name_pre = IL3945_FW_PRE,
@@ -2711,8 +2701,15 @@ static struct il_cfg il3945_bg_cfg = {
 	.sku = IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.mod_params = &il3945_mod_params,
-	.base_params = &il3945_base_params,
 	.led_mode = IL_LED_BLINK,
+
+	.eeprom_size = IL3945_EEPROM_IMG_SIZE,
+	.num_of_queues = IL39_NUM_QUEUES,
+	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
+	.set_l0s = false,
+	.use_bsm = true,
+	.led_compensation = 64,
+	.wd_timeout = IL_DEF_WD_TIMEOUT
 };
 
 static struct il_cfg il3945_abg_cfg = {
@@ -2723,8 +2720,15 @@ static struct il_cfg il3945_abg_cfg = {
 	.sku = IL_SKU_A | IL_SKU_G,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.mod_params = &il3945_mod_params,
-	.base_params = &il3945_base_params,
 	.led_mode = IL_LED_BLINK,
+
+	.eeprom_size = IL3945_EEPROM_IMG_SIZE,
+	.num_of_queues = IL39_NUM_QUEUES,
+	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
+	.set_l0s = false,
+	.use_bsm = true,
+	.led_compensation = 64,
+	.wd_timeout = IL_DEF_WD_TIMEOUT
 };
 
 DEFINE_PCI_DEVICE_TABLE(il3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index bfb361d..fe91715 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -627,13 +627,13 @@ il4965_find_disconn_antenna(struct il_priv *il, u32 * average_sig,
 
 	average_sig[0] =
 	    data->chain_signal_a /
-	    il->cfg->base_params->chain_noise_num_beacons;
+	    il->cfg->chain_noise_num_beacons;
 	average_sig[1] =
 	    data->chain_signal_b /
-	    il->cfg->base_params->chain_noise_num_beacons;
+	    il->cfg->chain_noise_num_beacons;
 	average_sig[2] =
 	    data->chain_signal_c /
-	    il->cfg->base_params->chain_noise_num_beacons;
+	    il->cfg->chain_noise_num_beacons;
 
 	if (average_sig[0] >= average_sig[1]) {
 		max_average_sig = average_sig[0];
@@ -886,7 +886,7 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	/* If this is the "chain_noise_num_beacons", determine:
 	 * 1)  Disconnected antennas (using signal strengths)
 	 * 2)  Differential gain (using silence noise) to balance receivers */
-	if (data->beacon_count != il->cfg->base_params->chain_noise_num_beacons)
+	if (data->beacon_count != il->cfg->chain_noise_num_beacons)
 		return;
 
 	/* Analyze signal for disconnected antenna */
@@ -894,11 +894,11 @@ il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 
 	/* Analyze noise for rx balance */
 	average_noise[0] =
-	    data->chain_noise_a / il->cfg->base_params->chain_noise_num_beacons;
+	    data->chain_noise_a / il->cfg->chain_noise_num_beacons;
 	average_noise[1] =
-	    data->chain_noise_b / il->cfg->base_params->chain_noise_num_beacons;
+	    data->chain_noise_b / il->cfg->chain_noise_num_beacons;
 	average_noise[2] =
-	    data->chain_noise_c / il->cfg->base_params->chain_noise_num_beacons;
+	    data->chain_noise_c / il->cfg->chain_noise_num_beacons;
 
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		if (!data->disconn_array[i] &&
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2bf743f..49dd1e0 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2150,11 +2150,11 @@ il4965_txq_agg_enable(struct il_priv *il, int txq_id, int tx_fifo, int sta_id,
 
 	if ((IL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IL49_FIRST_AMPDU_QUEUE +
-	     il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
+	     il->cfg->num_of_ampdu_queues <= txq_id)) {
 		IL_WARN("queue number out of range: %d, must be %d to %d\n",
 			txq_id, IL49_FIRST_AMPDU_QUEUE,
 			IL49_FIRST_AMPDU_QUEUE +
-			il->cfg->base_params->num_of_ampdu_queues - 1);
+			il->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -2278,11 +2278,11 @@ il4965_txq_agg_disable(struct il_priv *il, u16 txq_id, u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IL49_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IL49_FIRST_AMPDU_QUEUE +
-	     il->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
+	     il->cfg->num_of_ampdu_queues <= txq_id)) {
 		IL_WARN("queue number out of range: %d, must be %d to %d\n",
 			txq_id, IL49_FIRST_AMPDU_QUEUE,
 			IL49_FIRST_AMPDU_QUEUE +
-			il->cfg->base_params->num_of_ampdu_queues - 1);
+			il->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 27feb53..cf1d016 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -614,13 +614,13 @@ il4965_hw_set_hw_params(struct il_priv *il)
 {
 	if (il->cfg->mod_params->num_of_queues >= IL_MIN_NUM_QUEUES &&
 	    il->cfg->mod_params->num_of_queues <= IL49_NUM_QUEUES)
-		il->cfg->base_params->num_of_queues =
+		il->cfg->num_of_queues =
 		    il->cfg->mod_params->num_of_queues;
 
-	il->hw_params.max_txq_num = il->cfg->base_params->num_of_queues;
+	il->hw_params.max_txq_num = il->cfg->num_of_queues;
 	il->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
 	il->hw_params.scd_bc_tbls_size =
-	    il->cfg->base_params->num_of_queues *
+	    il->cfg->num_of_queues *
 	    sizeof(struct il4965_scd_bc_tbl);
 	il->hw_params.tfd_size = sizeof(struct il_tfd);
 	il->hw_params.max_stations = IL4965_STATION_COUNT;
@@ -2331,22 +2331,6 @@ const struct il_ops il4965_ops = {
 	.legacy = &il4965_legacy_ops,
 };
 
-static struct il_base_params il4965_base_params = {
-	.eeprom_size = IL4965_EEPROM_IMG_SIZE,
-	.num_of_queues = IL49_NUM_QUEUES,
-	.num_of_ampdu_queues = IL49_NUM_AMPDU_QUEUES,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = true,
-	.led_compensation = 61,
-	.chain_noise_num_beacons = IL4965_CAL_NUM_BEACONS,
-	.wd_timeout = IL_DEF_WD_TIMEOUT,
-	.temperature_kelvin = true,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
-};
-
 struct il_cfg il4965_cfg = {
 	.name = "Intel(R) Wireless WiFi Link 4965AGN",
 	.fw_name_pre = IL4965_FW_PRE,
@@ -2358,13 +2342,26 @@ struct il_cfg il4965_cfg = {
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.mod_params = &il4965_mod_params,
-	.base_params = &il4965_base_params,
 	.led_mode = IL_LED_BLINK,
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
 	 */
 	.scan_rx_antennas[IEEE80211_BAND_5GHZ] = ANT_BC,
+
+	.eeprom_size = IL4965_EEPROM_IMG_SIZE,
+	.num_of_queues = IL49_NUM_QUEUES,
+	.num_of_ampdu_queues = IL49_NUM_AMPDU_QUEUES,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = true,
+	.led_compensation = 61,
+	.chain_noise_num_beacons = IL4965_CAL_NUM_BEACONS,
+	.wd_timeout = IL_DEF_WD_TIMEOUT,
+	.temperature_kelvin = true,
+	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 3bd1833..1173521 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -512,13 +512,13 @@ il_led_cmd(struct il_priv *il, unsigned long on, unsigned long off)
 	}
 
 	D_LED("Led blink time compensation=%u\n",
-	      il->cfg->base_params->led_compensation);
+	      il->cfg->led_compensation);
 	led_cmd.on =
 	    il_blink_compensation(il, on,
-				  il->cfg->base_params->led_compensation);
+				  il->cfg->led_compensation);
 	led_cmd.off =
 	    il_blink_compensation(il, off,
-				  il->cfg->base_params->led_compensation);
+				  il->cfg->led_compensation);
 
 	ret = il->ops->led->cmd(il, &led_cmd);
 	if (!ret) {
@@ -691,7 +691,7 @@ il_eeprom_verify_signature(struct il_priv *il)
 const u8 *
 il_eeprom_query_addr(const struct il_priv *il, size_t offset)
 {
-	BUG_ON(offset >= il->cfg->base_params->eeprom_size);
+	BUG_ON(offset >= il->cfg->eeprom_size);
 	return &il->eeprom[offset];
 }
 EXPORT_SYMBOL(il_eeprom_query_addr);
@@ -722,7 +722,7 @@ il_eeprom_init(struct il_priv *il)
 	u16 addr;
 
 	/* allocate eeprom */
-	sz = il->cfg->base_params->eeprom_size;
+	sz = il->cfg->eeprom_size;
 	D_EEPROM("NVM size = %d\n", sz);
 	il->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!il->eeprom) {
@@ -4218,7 +4218,7 @@ il_apm_init(struct il_priv *il)
 	 * If not (unlikely), enable L0S, so there is at least some
 	 *    power savings, even without L1.
 	 */
-	if (il->cfg->base_params->set_l0s) {
+	if (il->cfg->set_l0s) {
 		lctl = il_pcie_link_ctl(il);
 		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 		    PCI_CFG_LINK_CTRL_VAL_L1_EN) {
@@ -4235,9 +4235,9 @@ il_apm_init(struct il_priv *il)
 	}
 
 	/* Configure analog phase-lock-loop before activating to D0A */
-	if (il->cfg->base_params->pll_cfg_val)
+	if (il->cfg->pll_cfg_val)
 		il_set_bit(il, CSR_ANA_PLL_CFG,
-			   il->cfg->base_params->pll_cfg_val);
+			   il->cfg->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -4267,7 +4267,7 @@ il_apm_init(struct il_priv *il)
 	 * do not disable clocks.  This preserves any hardware bits already
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
-	if (il->cfg->base_params->use_bsm)
+	if (il->cfg->use_bsm)
 		il_wr_prph(il, APMG_CLK_EN_REG,
 			   APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
 	else
@@ -4565,7 +4565,7 @@ il_alloc_txq_mem(struct il_priv *il)
 	if (!il->txq)
 		il->txq =
 		    kzalloc(sizeof(struct il_tx_queue) *
-			    il->cfg->base_params->num_of_queues, GFP_KERNEL);
+			    il->cfg->num_of_queues, GFP_KERNEL);
 	if (!il->txq) {
 		IL_ERR("Not enough memory for txq\n");
 		return -ENOMEM;
@@ -4942,11 +4942,11 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 
 	timeout =
 	    txq->time_stamp +
-	    msecs_to_jiffies(il->cfg->base_params->wd_timeout);
+	    msecs_to_jiffies(il->cfg->wd_timeout);
 
 	if (time_after(jiffies, timeout)) {
 		IL_ERR("Queue %d stuck for %u ms.\n", q->id,
-		       il->cfg->base_params->wd_timeout);
+		       il->cfg->wd_timeout);
 		ret = il_force_reset(il, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
@@ -4974,7 +4974,7 @@ il_bg_watchdog(unsigned long data)
 	if (test_bit(S_EXIT_PENDING, &il->status))
 		return;
 
-	timeout = il->cfg->base_params->wd_timeout;
+	timeout = il->cfg->wd_timeout;
 	if (timeout == 0)
 		return;
 
@@ -5001,7 +5001,7 @@ EXPORT_SYMBOL(il_bg_watchdog);
 void
 il_setup_watchdog(struct il_priv *il)
 {
-	unsigned int timeout = il->cfg->base_params->wd_timeout;
+	unsigned int timeout = il->cfg->wd_timeout;
 
 	if (timeout)
 		mod_timer(&il->watchdog,
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 2af8610..21ed70a 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1695,21 +1695,6 @@ struct il_mod_params {
  *	chain noise calibration operation
  */
 struct il_base_params {
-	int eeprom_size;
-	int num_of_queues;	/* def: HW dependent */
-	int num_of_ampdu_queues;	/* def: HW dependent */
-	/* for il_apm_init() */
-	u32 pll_cfg_val;
-	bool set_l0s;
-	bool use_bsm;
-
-	u16 led_compensation;
-	int chain_noise_num_beacons;
-	unsigned int wd_timeout;
-	bool temperature_kelvin;
-	const bool ucode_tracing;
-	const bool sensitivity_calib_by_driver;
-	const bool chain_noise_calib_by_driver;
 };
 
 #define IL_LED_SOLID 11
@@ -1784,6 +1769,22 @@ struct il_cfg {
 	/* params likely to change within a device family */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	enum il_led_mode led_mode;
+
+	int eeprom_size;
+	int num_of_queues;		/* def: HW dependent */
+	int num_of_ampdu_queues;	/* def: HW dependent */
+	/* for il_apm_init() */
+	u32 pll_cfg_val;
+	bool set_l0s;
+	bool use_bsm;
+
+	u16 led_compensation;
+	int chain_noise_num_beacons;
+	unsigned int wd_timeout;
+	bool temperature_kelvin;
+	const bool ucode_tracing;
+	const bool sensitivity_calib_by_driver;
+	const bool chain_noise_calib_by_driver;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index 4fb769c..bb7c956 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -361,7 +361,7 @@ il_dbgfs_nvm_read(struct file *file, char __user *user_buf, size_t count,
 	const u8 *ptr;
 	char *buf;
 	u16 eeprom_ver;
-	size_t eeprom_len = il->cfg->base_params->eeprom_size;
+	size_t eeprom_len = il->cfg->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
@@ -727,7 +727,7 @@ il_dbgfs_traffic_log_read(struct file *file, char __user *user_buf,
 	char *buf;
 	int bufsz =
 	    ((IL_TRAFFIC_ENTRIES * IL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-	    (il->cfg->base_params->num_of_queues * 32 * 8) + 400;
+	    (il->cfg->num_of_queues * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
@@ -833,7 +833,7 @@ il_dbgfs_tx_queue_read(struct file *file, char __user *user_buf, size_t count,
 	int cnt;
 	int ret;
 	const size_t bufsz =
-	    sizeof(char) * 64 * il->cfg->base_params->num_of_queues;
+	    sizeof(char) * 64 * il->cfg->num_of_queues;
 
 	if (!il->txq) {
 		IL_ERR("txq not ready\n");
@@ -1293,7 +1293,7 @@ il_dbgfs_wd_timeout_write(struct file *file, const char __user *user_buf,
 	if (timeout < 0 || timeout > IL_MAX_WD_TIMEOUT)
 		timeout = IL_DEF_WD_TIMEOUT;
 
-	il->cfg->base_params->wd_timeout = timeout;
+	il->cfg->wd_timeout = timeout;
 	il_setup_watchdog(il);
 	return count;
 }
@@ -1367,17 +1367,17 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
 
-	if (il->cfg->base_params->sensitivity_calib_by_driver)
+	if (il->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-	if (il->cfg->base_params->chain_noise_calib_by_driver)
+	if (il->cfg->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
-	if (il->cfg->base_params->sensitivity_calib_by_driver)
+	if (il->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &il->disable_sens_cal);
-	if (il->cfg->base_params->chain_noise_calib_by_driver)
+	if (il->cfg->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 				 &il->disable_chain_noise_cal);
 	DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf, &il->disable_tx_power_cal);
-- 
1.7.1

