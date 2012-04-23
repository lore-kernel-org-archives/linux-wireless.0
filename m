Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab2DWVwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/29] iwlwifi: remove debugfs logspam
Date: Mon, 23 Apr 2012 14:47:19 -0700
Message-Id: <1335217660-21950-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235357_970993_B29F58F2)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There really is no point in printing very verbose
error messages when somebody tries to access a
debugfs file before it is ready. Or even worse,
printing verbose messages when memory allocation
fails which *already* prints a huge warning.

Remove all IWL_ERR messages from debugfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |   67 ++++++------------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    9 +--
 2 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c93f4e7..11ca48e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -230,10 +230,8 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
-		if (!priv->ucode_loaded) {
-			IWL_ERR(priv, "No uCode has been loadded.\n");
+		if (!priv->ucode_loaded)
 			return -EINVAL;
-		}
 		img = &priv->fw->img[priv->cur_ucode];
 		priv->dbgfs_sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
 	}
@@ -411,23 +409,18 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	size_t eeprom_len = priv->cfg->base_params->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
-	if (eeprom_len % 16) {
-		IWL_ERR(priv, "NVM size is not multiple of 16.\n");
+	if (eeprom_len % 16)
 		return -ENODATA;
-	}
 
 	ptr = priv->eeprom;
-	if (!ptr) {
-		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
+	if (!ptr)
 		return -ENOMEM;
-	}
 
 	/* 4 characters for byte 0xYY */
 	buf = kzalloc(buf_size, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
+
 	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
 	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
 			"version: 0x%x\n",
@@ -461,10 +454,8 @@ static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
 	if (supp_band) {
@@ -566,10 +557,8 @@ static ssize_t iwl_dbgfs_rx_handlers_read(struct file *file,
 	ssize_t ret;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	for (cnt = 0; cnt < REPLY_MAX; cnt++) {
 		if (priv->rx_handlers_stats[cnt] > 0)
@@ -683,11 +672,8 @@ static ssize_t iwl_dbgfs_disable_ht40_write(struct file *file,
 		return -EFAULT;
 	if (!iwl_is_any_associated(priv))
 		priv->disable_ht40 = ht40 ? true : false;
-	else {
-		IWL_ERR(priv, "Sta associated with AP - "
-			"Change to 40MHz channel support is not allowed\n");
+	else
 		return -EINVAL;
-	}
 
 	return count;
 }
@@ -834,10 +820,8 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	ssize_t ret;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 	if (priv->tx_traffic && iwl_have_debug_level(IWL_DL_TX)) {
 		ptr = priv->tx_traffic;
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -950,10 +934,8 @@ static ssize_t iwl_dbgfs_ucode_rx_stats_read(struct file *file,
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	/*
 	 * the statistic information display here is based on
@@ -1379,10 +1361,8 @@ static ssize_t iwl_dbgfs_ucode_tx_stats_read(struct file *file,
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	/* the statistic information display here is based on
 	 * the last statistics notification from uCode
@@ -1581,10 +1561,8 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	/* the statistic information display here is based on
 	 * the last statistics notification from uCode
@@ -1707,16 +1685,11 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
 	mutex_unlock(&priv->mutex);
 
-	if (ret) {
-		IWL_ERR(priv,
-			"Error sending statistics request: %zd\n", ret);
+	if (ret)
 		return -EAGAIN;
-	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	/*
 	 * the statistic information display here is based on
@@ -1793,10 +1766,8 @@ static ssize_t iwl_dbgfs_reply_tx_error_read(struct file *file,
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_TX_Error:\n");
 	pos += scnprintf(buf + pos, bufsz - pos, "%s:\t\t\t\t%u\n",
@@ -1936,10 +1907,8 @@ static ssize_t iwl_dbgfs_sensitivity_read(struct file *file,
 
 	data = &priv->sensitivity_data;
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	pos += scnprintf(buf + pos, bufsz - pos, "auto_corr_ofdm:\t\t\t %u\n",
 			data->auto_corr_ofdm);
@@ -2017,10 +1986,8 @@ static ssize_t iwl_dbgfs_chain_noise_read(struct file *file,
 
 	data = &priv->chain_noise_data;
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(priv, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	pos += scnprintf(buf + pos, bufsz - pos, "active_chains:\t\t\t %u\n",
 			data->active_chains);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 2a9fb98..e0c93cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1825,10 +1825,9 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 
 	bufsz = sizeof(char) * 64 * trans->cfg->base_params->num_of_queues;
 
-	if (!trans_pcie->txq) {
-		IWL_ERR(trans, "txq not ready\n");
+	if (!trans_pcie->txq)
 		return -EAGAIN;
-	}
+
 	buf = kzalloc(bufsz, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -1889,10 +1888,8 @@ static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 	ssize_t ret;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IWL_ERR(trans, "Can not allocate Buffer\n");
+	if (!buf)
 		return -ENOMEM;
-	}
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			"Interrupt Statistics Report:\n");
-- 
1.7.0.4

