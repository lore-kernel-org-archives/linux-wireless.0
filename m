Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40089 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1D1I4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 04:56:08 -0400
Received: by pwi15 with SMTP id 15so1175635pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 01:56:05 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19897.11321.556139.837633@gargle.gargle.HOWL> (sfid-20110428_105613_389231_98A3B7FA)
Date: Thu, 28 Apr 2011 14:28:33 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Debugfs file location: <debugfs_mnt>/ieee80211/phy#/ath9k_htc/base_eeprom

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |  170 ++++++++++++++++++++++-
 1 files changed, 162 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 894e5ef..cff2d21 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -492,6 +492,158 @@ static const struct file_operations fops_debug = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath9k_htc_priv *priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct base_eep_header *pBase = NULL;
+	unsigned int len = 0, size = 1500;
+	ssize_t retval = 0;
+	char *buf;
+
+	/*
+	 * This can be done since all the 3 EEPROM families have the
+	 * same base header upto a certain point, and we are interested in
+	 * the data only upto that point.
+	 */
+
+	if (AR_SREV_9271(priv->ah))
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.map4k.baseEepHeader;
+	else if (priv->ah->hw_version.usbdev == AR9280_USB)
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.def.baseEepHeader;
+	else if (priv->ah->hw_version.usbdev == AR9287_USB)
+		pBase = (struct base_eep_header *)
+			&priv->ah->eeprom.map9287.baseEepHeader;
+
+	if (pBase == NULL) {
+		ath_err(common, "Unknown EEPROM type\n");
+		return 0;
+	}
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Major Version",
+			pBase->version >> 12);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Minor Version",
+			pBase->version & 0xFFF);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Checksum",
+			pBase->checksum);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Length",
+			pBase->length);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RegDomain1",
+			pBase->regDmn[0]);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RegDomain2",
+			pBase->regDmn[1]);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"TX Mask", pBase->txMask);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"RX Mask", pBase->rxMask);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Allow 5GHz",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Allow 2GHz",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Disable 2GHz HT20",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Disable 2GHz HT40",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Disable 5Ghz HT20",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Disable 5Ghz HT40",
+			!!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Big Endian",
+			!!(pBase->eepMisc & 0x01));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Cal Bin Major Ver",
+			(pBase->binBuildNumber >> 24) & 0xFF);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Cal Bin Minor Ver",
+			(pBase->binBuildNumber >> 16) & 0xFF);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n",
+			"Cal Bin Build",
+			(pBase->binBuildNumber >> 8) & 0xFF);
+
+	/*
+	 * UB91 specific data.
+	 */
+	if (AR_SREV_9271(priv->ah)) {
+		struct base_eep_header_4k *pBase4k =
+			&priv->ah->eeprom.map4k.baseEepHeader;
+
+		len += snprintf(buf + len, size - len,
+				"%20s : %10d\n",
+				"TX Gain type",
+				pBase4k->txGainType);
+	}
+
+	/*
+	 * UB95 specific data.
+	 */
+	if (priv->ah->hw_version.usbdev == AR9287_USB) {
+		struct base_eep_ar9287_header *pBase9287 =
+			&priv->ah->eeprom.map9287.baseEepHeader;
+
+		len += snprintf(buf + len, size - len,
+				"%20s : %10ddB\n",
+				"Power Table Offset",
+				pBase9287->pwrTableOffset);
+
+		len += snprintf(buf + len, size - len,
+				"%20s : %10d\n",
+				"OpenLoop Power Ctrl",
+				pBase9287->openLoopPwrCntl);
+	}
+
+	len += snprintf(buf + len, size - len,
+			"%20s : %02X:%02X:%02X:%02X:%02X:%02X\n",
+			"MacAddress",
+			pBase->macAddr[0], pBase->macAddr[1], pBase->macAddr[2],
+			pBase->macAddr[3], pBase->macAddr[4], pBase->macAddr[5]);
+	if (len > size)
+		len = size;
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+static const struct file_operations fops_base_eeprom = {
+	.read = read_file_base_eeprom,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -503,21 +655,23 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 		return -ENOMEM;
 
 	debugfs_create_file("tgt_int_stats", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_tgt_int_stats);
+			    priv, &fops_tgt_int_stats);
 	debugfs_create_file("tgt_tx_stats", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_tgt_tx_stats);
+			    priv, &fops_tgt_tx_stats);
 	debugfs_create_file("tgt_rx_stats", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_tgt_rx_stats);
+			    priv, &fops_tgt_rx_stats);
 	debugfs_create_file("xmit", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_xmit);
+			    priv, &fops_xmit);
 	debugfs_create_file("recv", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_recv);
+			    priv, &fops_recv);
 	debugfs_create_file("slot", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_slot);
+			    priv, &fops_slot);
 	debugfs_create_file("queue", S_IRUSR, priv->debug.debugfs_phy,
-				priv, &fops_queue);
+			    priv, &fops_queue);
 	debugfs_create_file("debug", S_IRUSR | S_IWUSR, priv->debug.debugfs_phy,
-				priv, &fops_debug);
+			    priv, &fops_debug);
+	debugfs_create_file("base_eeprom", S_IRUSR, priv->debug.debugfs_phy,
+			    priv, &fops_base_eeprom);
 
 	return 0;
 }
-- 
1.7.4.4

