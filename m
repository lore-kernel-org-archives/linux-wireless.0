Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64229 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbaEKIFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:30 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 04/10] ath9k_htc: use ath9k_cmn_debug_base_eeprom
Date: Sun, 11 May 2014 10:04:34 +0200
Message-Id: <1399795480-7459-5-git-send-email-linux@rempel-privat.de> (sfid-20140511_100549_704367_DDD86F70)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 138 +------------------------
 1 file changed, 1 insertion(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index a573239..c5071bb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -486,141 +486,6 @@ static const struct file_operations fops_debug = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct ath9k_htc_priv *priv = file->private_data;
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct base_eep_header *pBase = NULL;
-	unsigned int len = 0, size = 1500;
-	ssize_t retval = 0;
-	char *buf;
-
-	pBase = ath9k_htc_get_eeprom_base(priv);
-
-	if (pBase == NULL) {
-		ath_err(common, "Unknown EEPROM type\n");
-		return 0;
-	}
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "Major Version",
-			 pBase->version >> 12);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "Minor Version",
-			 pBase->version & 0xFFF);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "Checksum",
-			 pBase->checksum);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "Length",
-			 pBase->length);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "RegDomain1",
-			 pBase->regDmn[0]);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n", "RegDomain2",
-			 pBase->regDmn[1]);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "TX Mask", pBase->txMask);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "RX Mask", pBase->rxMask);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Allow 5GHz",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Allow 2GHz",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Disable 2GHz HT20",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Disable 2GHz HT40",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Disable 5Ghz HT20",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Disable 5Ghz HT40",
-			 !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Big Endian",
-			 !!(pBase->eepMisc & 0x01));
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Cal Bin Major Ver",
-			 (pBase->binBuildNumber >> 24) & 0xFF);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Cal Bin Minor Ver",
-			 (pBase->binBuildNumber >> 16) & 0xFF);
-	len += scnprintf(buf + len, size - len,
-			 "%20s : %10d\n",
-			 "Cal Bin Build",
-			 (pBase->binBuildNumber >> 8) & 0xFF);
-
-	/*
-	 * UB91 specific data.
-	 */
-	if (AR_SREV_9271(priv->ah)) {
-		struct base_eep_header_4k *pBase4k =
-			&priv->ah->eeprom.map4k.baseEepHeader;
-
-		len += scnprintf(buf + len, size - len,
-				 "%20s : %10d\n",
-				 "TX Gain type",
-				 pBase4k->txGainType);
-	}
-
-	/*
-	 * UB95 specific data.
-	 */
-	if (priv->ah->hw_version.usbdev == AR9287_USB) {
-		struct base_eep_ar9287_header *pBase9287 =
-			&priv->ah->eeprom.map9287.baseEepHeader;
-
-		len += scnprintf(buf + len, size - len,
-				 "%20s : %10ddB\n",
-				 "Power Table Offset",
-				 pBase9287->pwrTableOffset);
-
-		len += scnprintf(buf + len, size - len,
-				 "%20s : %10d\n",
-				 "OpenLoop Power Ctrl",
-				 pBase9287->openLoopPwrCntl);
-	}
-
-	len += scnprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			 pBase->macAddr);
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static const struct file_operations fops_base_eeprom = {
-	.read = read_file_base_eeprom,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 /* Ethtool support for get-stats */
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
 static const char ath9k_htc_gstrings_stats[][ETH_GSTRING_LEN] = {
@@ -727,9 +592,8 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 			    priv, &fops_queue);
 	debugfs_create_file("debug", S_IRUSR | S_IWUSR, priv->debug.debugfs_phy,
 			    priv, &fops_debug);
-	debugfs_create_file("base_eeprom", S_IRUSR, priv->debug.debugfs_phy,
-			    priv, &fops_base_eeprom);
 
+	ath9k_cmn_debug_base_eeprom(priv->debug.debugfs_phy, priv->ah);
 	ath9k_cmn_debug_modal_eeprom(priv->debug.debugfs_phy, priv->ah);
 
 	return 0;
-- 
1.9.1

