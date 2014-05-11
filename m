Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54863 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757662AbaEKIF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:28 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 02/10] ath9k_htc: use ath9k_cmn_debug_modal_eeprom
Date: Sun, 11 May 2014 10:04:32 +0200
Message-Id: <1399795480-7459-3-git-send-email-linux@rempel-privat.de> (sfid-20140511_100550_349634_91788742)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 286 +------------------------
 1 file changed, 2 insertions(+), 284 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index fb071ee..a573239 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -621,288 +621,6 @@ static const struct file_operations fops_base_eeprom = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_4k_modal_eeprom(struct file *file,
-				    char __user *user_buf,
-				    size_t count, loff_t *ppos)
-{
-#define PR_EEP(_s, _val)						\
-	do {								\
-		len += scnprintf(buf + len, size - len, "%20s : %10d\n",\
-				 _s, (_val));				\
-	} while (0)
-
-	struct ath9k_htc_priv *priv = file->private_data;
-	struct modal_eep_4k_header *pModal = &priv->ah->eeprom.map4k.modalHeader;
-	unsigned int len = 0, size = 2048;
-	ssize_t retval = 0;
-	char *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	PR_EEP("Chain0 Ant. Control", pModal->antCtrlChain[0]);
-	PR_EEP("Ant. Common Control", pModal->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", pModal->antennaGainCh[0]);
-	PR_EEP("Switch Settle", pModal->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", pModal->txRxAttenCh[0]);
-	PR_EEP("Chain0 RxTxMargin", pModal->rxTxMarginCh[0]);
-	PR_EEP("ADC Desired size", pModal->adcDesiredSize);
-	PR_EEP("PGA Desired size", pModal->pgaDesiredSize);
-	PR_EEP("Chain0 xlna Gain", pModal->xlnaGainCh[0]);
-	PR_EEP("txEndToXpaOff", pModal->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", pModal->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", pModal->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", pModal->thresh62);
-	PR_EEP("Chain0 NF Threshold", pModal->noiseFloorThreshCh[0]);
-	PR_EEP("xpdGain", pModal->xpdGain);
-	PR_EEP("External PD", pModal->xpd);
-	PR_EEP("Chain0 I Coefficient", pModal->iqCalICh[0]);
-	PR_EEP("Chain0 Q Coefficient", pModal->iqCalQCh[0]);
-	PR_EEP("pdGainOverlap", pModal->pdGainOverlap);
-	PR_EEP("O/D Bias Version", pModal->version);
-	PR_EEP("CCK OutputBias", pModal->ob_0);
-	PR_EEP("BPSK OutputBias", pModal->ob_1);
-	PR_EEP("QPSK OutputBias", pModal->ob_2);
-	PR_EEP("16QAM OutputBias", pModal->ob_3);
-	PR_EEP("64QAM OutputBias", pModal->ob_4);
-	PR_EEP("CCK Driver1_Bias", pModal->db1_0);
-	PR_EEP("BPSK Driver1_Bias", pModal->db1_1);
-	PR_EEP("QPSK Driver1_Bias", pModal->db1_2);
-	PR_EEP("16QAM Driver1_Bias", pModal->db1_3);
-	PR_EEP("64QAM Driver1_Bias", pModal->db1_4);
-	PR_EEP("CCK Driver2_Bias", pModal->db2_0);
-	PR_EEP("BPSK Driver2_Bias", pModal->db2_1);
-	PR_EEP("QPSK Driver2_Bias", pModal->db2_2);
-	PR_EEP("16QAM Driver2_Bias", pModal->db2_3);
-	PR_EEP("64QAM Driver2_Bias", pModal->db2_4);
-	PR_EEP("xPA Bias Level", pModal->xpaBiasLvl);
-	PR_EEP("txFrameToDataStart", pModal->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", pModal->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", pModal->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", pModal->bswAtten[0]);
-	PR_EEP("Chain0 bswMargin", pModal->bswMargin[0]);
-	PR_EEP("HT40 Switch Settle", pModal->swSettleHt40);
-	PR_EEP("Chain0 xatten2Db", pModal->xatten2Db[0]);
-	PR_EEP("Chain0 xatten2Margin", pModal->xatten2Margin[0]);
-	PR_EEP("Ant. Diversity ctl1", pModal->antdiv_ctl1);
-	PR_EEP("Ant. Diversity ctl2", pModal->antdiv_ctl2);
-	PR_EEP("TX Diversity", pModal->tx_diversity);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-
-#undef PR_EEP
-}
-
-static ssize_t read_def_modal_eeprom(struct file *file,
-				     char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-#define PR_EEP(_s, _val)						\
-	do {								\
-		if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {		\
-			pModal = &priv->ah->eeprom.def.modalHeader[1];	\
-			len += scnprintf(buf + len, size - len, "%20s : %8d%7s", \
-					 _s, (_val), "|");		\
-		}							\
-		if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {		\
-			pModal = &priv->ah->eeprom.def.modalHeader[0];	\
-			len += scnprintf(buf + len, size - len, "%9d\n",\
-					(_val));			\
-		}							\
-	} while (0)
-
-	struct ath9k_htc_priv *priv = file->private_data;
-	struct base_eep_header *pBase = &priv->ah->eeprom.def.baseEepHeader;
-	struct modal_eep_header *pModal = NULL;
-	unsigned int len = 0, size = 3500;
-	ssize_t retval = 0;
-	char *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len += scnprintf(buf + len, size - len,
-			 "%31s %15s\n", "2G", "5G");
-	len += scnprintf(buf + len, size - len,
-			 "%32s %16s\n", "====", "====\n");
-
-	PR_EEP("Chain0 Ant. Control", pModal->antCtrlChain[0]);
-	PR_EEP("Chain1 Ant. Control", pModal->antCtrlChain[1]);
-	PR_EEP("Chain2 Ant. Control", pModal->antCtrlChain[2]);
-	PR_EEP("Ant. Common Control", pModal->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", pModal->antennaGainCh[0]);
-	PR_EEP("Chain1 Ant. Gain", pModal->antennaGainCh[1]);
-	PR_EEP("Chain2 Ant. Gain", pModal->antennaGainCh[2]);
-	PR_EEP("Switch Settle", pModal->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", pModal->txRxAttenCh[0]);
-	PR_EEP("Chain1 TxRxAtten", pModal->txRxAttenCh[1]);
-	PR_EEP("Chain2 TxRxAtten", pModal->txRxAttenCh[2]);
-	PR_EEP("Chain0 RxTxMargin", pModal->rxTxMarginCh[0]);
-	PR_EEP("Chain1 RxTxMargin", pModal->rxTxMarginCh[1]);
-	PR_EEP("Chain2 RxTxMargin", pModal->rxTxMarginCh[2]);
-	PR_EEP("ADC Desired size", pModal->adcDesiredSize);
-	PR_EEP("PGA Desired size", pModal->pgaDesiredSize);
-	PR_EEP("Chain0 xlna Gain", pModal->xlnaGainCh[0]);
-	PR_EEP("Chain1 xlna Gain", pModal->xlnaGainCh[1]);
-	PR_EEP("Chain2 xlna Gain", pModal->xlnaGainCh[2]);
-	PR_EEP("txEndToXpaOff", pModal->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", pModal->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", pModal->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", pModal->thresh62);
-	PR_EEP("Chain0 NF Threshold", pModal->noiseFloorThreshCh[0]);
-	PR_EEP("Chain1 NF Threshold", pModal->noiseFloorThreshCh[1]);
-	PR_EEP("Chain2 NF Threshold", pModal->noiseFloorThreshCh[2]);
-	PR_EEP("xpdGain", pModal->xpdGain);
-	PR_EEP("External PD", pModal->xpd);
-	PR_EEP("Chain0 I Coefficient", pModal->iqCalICh[0]);
-	PR_EEP("Chain1 I Coefficient", pModal->iqCalICh[1]);
-	PR_EEP("Chain2 I Coefficient", pModal->iqCalICh[2]);
-	PR_EEP("Chain0 Q Coefficient", pModal->iqCalQCh[0]);
-	PR_EEP("Chain1 Q Coefficient", pModal->iqCalQCh[1]);
-	PR_EEP("Chain2 Q Coefficient", pModal->iqCalQCh[2]);
-	PR_EEP("pdGainOverlap", pModal->pdGainOverlap);
-	PR_EEP("Chain0 OutputBias", pModal->ob);
-	PR_EEP("Chain0 DriverBias", pModal->db);
-	PR_EEP("xPA Bias Level", pModal->xpaBiasLvl);
-	PR_EEP("2chain pwr decrease", pModal->pwrDecreaseFor2Chain);
-	PR_EEP("3chain pwr decrease", pModal->pwrDecreaseFor3Chain);
-	PR_EEP("txFrameToDataStart", pModal->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", pModal->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", pModal->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", pModal->bswAtten[0]);
-	PR_EEP("Chain1 bswAtten", pModal->bswAtten[1]);
-	PR_EEP("Chain2 bswAtten", pModal->bswAtten[2]);
-	PR_EEP("Chain0 bswMargin", pModal->bswMargin[0]);
-	PR_EEP("Chain1 bswMargin", pModal->bswMargin[1]);
-	PR_EEP("Chain2 bswMargin", pModal->bswMargin[2]);
-	PR_EEP("HT40 Switch Settle", pModal->swSettleHt40);
-	PR_EEP("Chain0 xatten2Db", pModal->xatten2Db[0]);
-	PR_EEP("Chain1 xatten2Db", pModal->xatten2Db[1]);
-	PR_EEP("Chain2 xatten2Db", pModal->xatten2Db[2]);
-	PR_EEP("Chain0 xatten2Margin", pModal->xatten2Margin[0]);
-	PR_EEP("Chain1 xatten2Margin", pModal->xatten2Margin[1]);
-	PR_EEP("Chain2 xatten2Margin", pModal->xatten2Margin[2]);
-	PR_EEP("Chain1 OutputBias", pModal->ob_ch1);
-	PR_EEP("Chain1 DriverBias", pModal->db_ch1);
-	PR_EEP("LNA Control", pModal->lna_ctl);
-	PR_EEP("XPA Bias Freq0", pModal->xpaBiasLvlFreq[0]);
-	PR_EEP("XPA Bias Freq1", pModal->xpaBiasLvlFreq[1]);
-	PR_EEP("XPA Bias Freq2", pModal->xpaBiasLvlFreq[2]);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-
-#undef PR_EEP
-}
-
-static ssize_t read_9287_modal_eeprom(struct file *file,
-				      char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-#define PR_EEP(_s, _val)						\
-	do {								\
-		len += scnprintf(buf + len, size - len, "%20s : %10d\n",\
-				 _s, (_val));				\
-	} while (0)
-
-	struct ath9k_htc_priv *priv = file->private_data;
-	struct modal_eep_ar9287_header *pModal = &priv->ah->eeprom.map9287.modalHeader;
-	unsigned int len = 0, size = 3000;
-	ssize_t retval = 0;
-	char *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	PR_EEP("Chain0 Ant. Control", pModal->antCtrlChain[0]);
-	PR_EEP("Chain1 Ant. Control", pModal->antCtrlChain[1]);
-	PR_EEP("Ant. Common Control", pModal->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", pModal->antennaGainCh[0]);
-	PR_EEP("Chain1 Ant. Gain", pModal->antennaGainCh[1]);
-	PR_EEP("Switch Settle", pModal->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", pModal->txRxAttenCh[0]);
-	PR_EEP("Chain1 TxRxAtten", pModal->txRxAttenCh[1]);
-	PR_EEP("Chain0 RxTxMargin", pModal->rxTxMarginCh[0]);
-	PR_EEP("Chain1 RxTxMargin", pModal->rxTxMarginCh[1]);
-	PR_EEP("ADC Desired size", pModal->adcDesiredSize);
-	PR_EEP("txEndToXpaOff", pModal->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", pModal->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", pModal->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", pModal->thresh62);
-	PR_EEP("Chain0 NF Threshold", pModal->noiseFloorThreshCh[0]);
-	PR_EEP("Chain1 NF Threshold", pModal->noiseFloorThreshCh[1]);
-	PR_EEP("xpdGain", pModal->xpdGain);
-	PR_EEP("External PD", pModal->xpd);
-	PR_EEP("Chain0 I Coefficient", pModal->iqCalICh[0]);
-	PR_EEP("Chain1 I Coefficient", pModal->iqCalICh[1]);
-	PR_EEP("Chain0 Q Coefficient", pModal->iqCalQCh[0]);
-	PR_EEP("Chain1 Q Coefficient", pModal->iqCalQCh[1]);
-	PR_EEP("pdGainOverlap", pModal->pdGainOverlap);
-	PR_EEP("xPA Bias Level", pModal->xpaBiasLvl);
-	PR_EEP("txFrameToDataStart", pModal->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", pModal->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", pModal->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", pModal->bswAtten[0]);
-	PR_EEP("Chain1 bswAtten", pModal->bswAtten[1]);
-	PR_EEP("Chain0 bswMargin", pModal->bswMargin[0]);
-	PR_EEP("Chain1 bswMargin", pModal->bswMargin[1]);
-	PR_EEP("HT40 Switch Settle", pModal->swSettleHt40);
-	PR_EEP("AR92x7 Version", pModal->version);
-	PR_EEP("DriverBias1", pModal->db1);
-	PR_EEP("DriverBias2", pModal->db1);
-	PR_EEP("CCK OutputBias", pModal->ob_cck);
-	PR_EEP("PSK OutputBias", pModal->ob_psk);
-	PR_EEP("QAM OutputBias", pModal->ob_qam);
-	PR_EEP("PAL_OFF OutputBias", pModal->ob_pal_off);
-
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-
-#undef PR_EEP
-}
-
-static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-	struct ath9k_htc_priv *priv = file->private_data;
-
-	if (AR_SREV_9271(priv->ah))
-		return read_4k_modal_eeprom(file, user_buf, count, ppos);
-	else if (priv->ah->hw_version.usbdev == AR9280_USB)
-		return read_def_modal_eeprom(file, user_buf, count, ppos);
-	else if (priv->ah->hw_version.usbdev == AR9287_USB)
-		return read_9287_modal_eeprom(file, user_buf, count, ppos);
-
-	return 0;
-}
-
-static const struct file_operations fops_modal_eeprom = {
-	.read = read_file_modal_eeprom,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-
 /* Ethtool support for get-stats */
 #define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
 static const char ath9k_htc_gstrings_stats[][ETH_GSTRING_LEN] = {
@@ -1011,8 +729,8 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 			    priv, &fops_debug);
 	debugfs_create_file("base_eeprom", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_base_eeprom);
-	debugfs_create_file("modal_eeprom", S_IRUSR, priv->debug.debugfs_phy,
-			    priv, &fops_modal_eeprom);
+
+	ath9k_cmn_debug_modal_eeprom(priv->debug.debugfs_phy, priv->ah);
 
 	return 0;
 }
-- 
1.9.1

