Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21470 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2GWEU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 00:20:57 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20492.53472.318382.889445@gargle.gargle.HOWL> (sfid-20120723_062102_575036_67E7E467)
Date: Mon, 23 Jul 2012 09:49:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath: Remove EEPROM dump functions
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be done from userspace.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 118 -------
 drivers/net/wireless/ath/ath9k/debug.c         |  60 ----
 drivers/net/wireless/ath/ath9k/eeprom.h        |   2 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     | 112 -------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   | 106 ------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    | 131 --------
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 434 -------------------------
 7 files changed, 963 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b5c8450..0385b72 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3374,123 +3374,6 @@ static bool ath9k_hw_ar9300_fill_eeprom(struct ath_hw *ah)
 	return true;
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
-static u32 ar9003_dump_modal_eeprom(char *buf, u32 len, u32 size,
-				    struct ar9300_modal_eep_header *modal_hdr)
-{
-	PR_EEP("Chain0 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[0]));
-	PR_EEP("Chain1 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[1]));
-	PR_EEP("Chain2 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[2]));
-	PR_EEP("Ant. Common Control", le32_to_cpu(modal_hdr->antCtrlCommon));
-	PR_EEP("Ant. Common Control2", le32_to_cpu(modal_hdr->antCtrlCommon2));
-	PR_EEP("Ant. Gain", modal_hdr->antennaGain);
-	PR_EEP("Switch Settle", modal_hdr->switchSettling);
-	PR_EEP("Chain0 xatten1DB", modal_hdr->xatten1DB[0]);
-	PR_EEP("Chain1 xatten1DB", modal_hdr->xatten1DB[1]);
-	PR_EEP("Chain2 xatten1DB", modal_hdr->xatten1DB[2]);
-	PR_EEP("Chain0 xatten1Margin", modal_hdr->xatten1Margin[0]);
-	PR_EEP("Chain1 xatten1Margin", modal_hdr->xatten1Margin[1]);
-	PR_EEP("Chain2 xatten1Margin", modal_hdr->xatten1Margin[2]);
-	PR_EEP("Temp Slope", modal_hdr->tempSlope);
-	PR_EEP("Volt Slope", modal_hdr->voltSlope);
-	PR_EEP("spur Channels0", modal_hdr->spurChans[0]);
-	PR_EEP("spur Channels1", modal_hdr->spurChans[1]);
-	PR_EEP("spur Channels2", modal_hdr->spurChans[2]);
-	PR_EEP("spur Channels3", modal_hdr->spurChans[3]);
-	PR_EEP("spur Channels4", modal_hdr->spurChans[4]);
-	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
-	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
-	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
-	PR_EEP("Quick Drop", modal_hdr->quick_drop);
-	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
-	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
-	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
-	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
-	PR_EEP("txClip", modal_hdr->txClip);
-	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
-
-	return len;
-}
-
-static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	struct ar9300_base_eep_hdr *pBase;
-
-	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
-		len = ar9003_dump_modal_eeprom(buf, len, size,
-						&eep->modalHeader2G);
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "5GHz modal Header");
-		len = ar9003_dump_modal_eeprom(buf, len, size,
-						&eep->modalHeader5G);
-		goto out;
-	}
-
-	pBase = &eep->baseEepHeader;
-
-	PR_EEP("EEPROM Version", ah->eeprom.ar9300_eep.eepromVersion);
-	PR_EEP("RegDomain1", le16_to_cpu(pBase->regDmn[0]));
-	PR_EEP("RegDomain2", le16_to_cpu(pBase->regDmn[1]));
-	PR_EEP("TX Mask", (pBase->txrxMask >> 4));
-	PR_EEP("RX Mask", (pBase->txrxMask & 0x0f));
-	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags.opFlags &
-				AR5416_OPFLAGS_11A));
-	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags.opFlags &
-				AR5416_OPFLAGS_11G));
-	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags.opFlags &
-					AR5416_OPFLAGS_N_2G_HT20));
-	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags.opFlags &
-					AR5416_OPFLAGS_N_2G_HT40));
-	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags.opFlags &
-					AR5416_OPFLAGS_N_5G_HT20));
-	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags.opFlags &
-					AR5416_OPFLAGS_N_5G_HT40));
-	PR_EEP("Big Endian", !!(pBase->opCapFlags.eepMisc & 0x01));
-	PR_EEP("RF Silent", pBase->rfSilent);
-	PR_EEP("BT option", pBase->blueToothOptions);
-	PR_EEP("Device Cap", pBase->deviceCap);
-	PR_EEP("Device Type", pBase->deviceType);
-	PR_EEP("Power Table Offset", pBase->pwrTableOffset);
-	PR_EEP("Tuning Caps1", pBase->params_for_tuning_caps[0]);
-	PR_EEP("Tuning Caps2", pBase->params_for_tuning_caps[1]);
-	PR_EEP("Enable Tx Temp Comp", !!(pBase->featureEnable & BIT(0)));
-	PR_EEP("Enable Tx Volt Comp", !!(pBase->featureEnable & BIT(1)));
-	PR_EEP("Enable fast clock", !!(pBase->featureEnable & BIT(2)));
-	PR_EEP("Enable doubling", !!(pBase->featureEnable & BIT(3)));
-	PR_EEP("Internal regulator", !!(pBase->featureEnable & BIT(4)));
-	PR_EEP("Enable Paprd", !!(pBase->featureEnable & BIT(5)));
-	PR_EEP("Driver Strength", !!(pBase->miscConfiguration & BIT(0)));
-	PR_EEP("Quick Drop", !!(pBase->miscConfiguration & BIT(1)));
-	PR_EEP("Chain mask Reduce", (pBase->miscConfiguration >> 0x3) & 0x1);
-	PR_EEP("Write enable Gpio", pBase->eepromWriteEnableGpio);
-	PR_EEP("WLAN Disable Gpio", pBase->wlanDisableGpio);
-	PR_EEP("WLAN LED Gpio", pBase->wlanLedGpio);
-	PR_EEP("Rx Band Select Gpio", pBase->rxBandSelectGpio);
-	PR_EEP("Tx Gain", pBase->txrxgain >> 4);
-	PR_EEP("Rx Gain", pBase->txrxgain & 0xf);
-	PR_EEP("SW Reg", le32_to_cpu(pBase->swreg));
-
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			ah->eeprom.ar9300_eep.macAddr);
-out:
-	if (len > size)
-		len = size;
-
-	return len;
-}
-#else
-static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	return 0;
-}
-#endif
-
 /* XXX: review hardware docs */
 static int ath9k_hw_ar9300_get_eeprom_ver(struct ath_hw *ah)
 {
@@ -5157,7 +5040,6 @@ const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
 	.fill_eeprom = ath9k_hw_ar9300_fill_eeprom,
-	.dump_eeprom = ath9k_hw_ar9003_dump_eeprom,
 	.get_eeprom_ver = ath9k_hw_ar9300_get_eeprom_ver,
 	.get_eeprom_rev = ath9k_hw_ar9300_get_eeprom_rev,
 	.set_board_values = ath9k_hw_ar9300_set_board_values,
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 68b643c..275ac7c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1199,62 +1199,6 @@ static const struct file_operations fops_dump_nfcal = {
 	.llseek = default_llseek,
 };
 
-static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
-				     size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	u32 len = 0, size = 1500;
-	ssize_t retval = 0;
-	char *buf;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	len = ah->eep_ops->dump_eeprom(ah, true, buf, len, size);
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
-static ssize_t read_file_modal_eeprom(struct file *file, char __user *user_buf,
-				      size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	struct ath_hw *ah = sc->sc_ah;
-	u32 len = 0, size = 6000;
-	char *buf;
-	size_t retval;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len = ah->eep_ops->dump_eeprom(ah, false, buf, len, size);
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-static const struct file_operations fops_modal_eeprom = {
-	.read = read_file_modal_eeprom,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 
 void ath9k_debug_samp_bb_mac(struct ath_softc *sc)
@@ -1588,10 +1532,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_regdump);
 	debugfs_create_file("dump_nfcal", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dump_nfcal);
-	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_base_eeprom);
-	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_modal_eeprom);
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_samps);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 484b313..4bd7d89 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -642,8 +642,6 @@ struct eeprom_ops {
 	int (*check_eeprom)(struct ath_hw *hw);
 	u32 (*get_eeprom)(struct ath_hw *hw, enum eeprom_param param);
 	bool (*fill_eeprom)(struct ath_hw *hw);
-	u32 (*dump_eeprom)(struct ath_hw *hw, bool dump_base_hdr, u8 *buf,
-			   u32 len, u32 size);
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index a850f44..f220e12 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -71,117 +71,6 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_4k_fill_eeprom(ah);
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
-static u32 ath9k_dump_4k_modal_eeprom(char *buf, u32 len, u32 size,
-				      struct modal_eep_4k_header *modal_hdr)
-{
-	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
-	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
-	PR_EEP("Switch Settle", modal_hdr->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
-	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
-	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
-	PR_EEP("PGA Desired size", modal_hdr->pgaDesiredSize);
-	PR_EEP("Chain0 xlna Gain", modal_hdr->xlnaGainCh[0]);
-	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
-	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
-	PR_EEP("xpdGain", modal_hdr->xpdGain);
-	PR_EEP("External PD", modal_hdr->xpd);
-	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
-	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
-	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
-	PR_EEP("O/D Bias Version", modal_hdr->version);
-	PR_EEP("CCK OutputBias", modal_hdr->ob_0);
-	PR_EEP("BPSK OutputBias", modal_hdr->ob_1);
-	PR_EEP("QPSK OutputBias", modal_hdr->ob_2);
-	PR_EEP("16QAM OutputBias", modal_hdr->ob_3);
-	PR_EEP("64QAM OutputBias", modal_hdr->ob_4);
-	PR_EEP("CCK Driver1_Bias", modal_hdr->db1_0);
-	PR_EEP("BPSK Driver1_Bias", modal_hdr->db1_1);
-	PR_EEP("QPSK Driver1_Bias", modal_hdr->db1_2);
-	PR_EEP("16QAM Driver1_Bias", modal_hdr->db1_3);
-	PR_EEP("64QAM Driver1_Bias", modal_hdr->db1_4);
-	PR_EEP("CCK Driver2_Bias", modal_hdr->db2_0);
-	PR_EEP("BPSK Driver2_Bias", modal_hdr->db2_1);
-	PR_EEP("QPSK Driver2_Bias", modal_hdr->db2_2);
-	PR_EEP("16QAM Driver2_Bias", modal_hdr->db2_3);
-	PR_EEP("64QAM Driver2_Bias", modal_hdr->db2_4);
-	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
-	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
-	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
-	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
-	PR_EEP("Chain0 xatten2Db", modal_hdr->xatten2Db[0]);
-	PR_EEP("Chain0 xatten2Margin", modal_hdr->xatten2Margin[0]);
-	PR_EEP("Ant. Diversity ctl1", modal_hdr->antdiv_ctl1);
-	PR_EEP("Ant. Diversity ctl2", modal_hdr->antdiv_ctl2);
-	PR_EEP("TX Diversity", modal_hdr->tx_diversity);
-
-	return len;
-}
-
-static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
-
-	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
-		len = ath9k_dump_4k_modal_eeprom(buf, len, size,
-						  &eep->modalHeader);
-		goto out;
-	}
-
-	PR_EEP("Major Version", pBase->version >> 12);
-	PR_EEP("Minor Version", pBase->version & 0xFFF);
-	PR_EEP("Checksum", pBase->checksum);
-	PR_EEP("Length", pBase->length);
-	PR_EEP("RegDomain1", pBase->regDmn[0]);
-	PR_EEP("RegDomain2", pBase->regDmn[1]);
-	PR_EEP("TX Mask", pBase->txMask);
-	PR_EEP("RX Mask", pBase->rxMask);
-	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
-	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
-	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT20));
-	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT40));
-	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT20));
-	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT40));
-	PR_EEP("Big Endian", !!(pBase->eepMisc & 0x01));
-	PR_EEP("Cal Bin Major Ver", (pBase->binBuildNumber >> 24) & 0xFF);
-	PR_EEP("Cal Bin Minor Ver", (pBase->binBuildNumber >> 16) & 0xFF);
-	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
-	PR_EEP("TX Gain type", pBase->txGainType);
-
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
-
-out:
-	if (len > size)
-		len = size;
-
-	return len;
-}
-#else
-static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	return 0;
-}
-#endif
-
-
 #undef SIZE_EEPROM_4K
 
 static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
@@ -1102,7 +991,6 @@ const struct eeprom_ops eep_4k_ops = {
 	.check_eeprom		= ath9k_hw_4k_check_eeprom,
 	.get_eeprom		= ath9k_hw_4k_get_eeprom,
 	.fill_eeprom		= ath9k_hw_4k_fill_eeprom,
-	.dump_eeprom		= ath9k_hw_4k_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_4k_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_4k_set_board_values,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index cd742fb..59edbcc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -75,111 +75,6 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_ar9287_fill_eeprom(ah);
 }
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
-static u32 ar9287_dump_modal_eeprom(char *buf, u32 len, u32 size,
-				    struct modal_eep_ar9287_header *modal_hdr)
-{
-	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
-	PR_EEP("Chain1 Ant. Control", modal_hdr->antCtrlChain[1]);
-	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
-	PR_EEP("Chain1 Ant. Gain", modal_hdr->antennaGainCh[1]);
-	PR_EEP("Switch Settle", modal_hdr->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
-	PR_EEP("Chain1 TxRxAtten", modal_hdr->txRxAttenCh[1]);
-	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
-	PR_EEP("Chain1 RxTxMargin", modal_hdr->rxTxMarginCh[1]);
-	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
-	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
-	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
-	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
-	PR_EEP("xpdGain", modal_hdr->xpdGain);
-	PR_EEP("External PD", modal_hdr->xpd);
-	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
-	PR_EEP("Chain1 I Coefficient", modal_hdr->iqCalICh[1]);
-	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
-	PR_EEP("Chain1 Q Coefficient", modal_hdr->iqCalQCh[1]);
-	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
-	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
-	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
-	PR_EEP("Chain1 bswAtten", modal_hdr->bswAtten[1]);
-	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
-	PR_EEP("Chain1 bswMargin", modal_hdr->bswMargin[1]);
-	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
-	PR_EEP("AR92x7 Version", modal_hdr->version);
-	PR_EEP("DriverBias1", modal_hdr->db1);
-	PR_EEP("DriverBias2", modal_hdr->db1);
-	PR_EEP("CCK OutputBias", modal_hdr->ob_cck);
-	PR_EEP("PSK OutputBias", modal_hdr->ob_psk);
-	PR_EEP("QAM OutputBias", modal_hdr->ob_qam);
-	PR_EEP("PAL_OFF OutputBias", modal_hdr->ob_pal_off);
-
-	return len;
-}
-
-static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
-	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
-
-	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
-		len = ar9287_dump_modal_eeprom(buf, len, size,
-						&eep->modalHeader);
-		goto out;
-	}
-
-	PR_EEP("Major Version", pBase->version >> 12);
-	PR_EEP("Minor Version", pBase->version & 0xFFF);
-	PR_EEP("Checksum", pBase->checksum);
-	PR_EEP("Length", pBase->length);
-	PR_EEP("RegDomain1", pBase->regDmn[0]);
-	PR_EEP("RegDomain2", pBase->regDmn[1]);
-	PR_EEP("TX Mask", pBase->txMask);
-	PR_EEP("RX Mask", pBase->rxMask);
-	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
-	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
-	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT20));
-	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT40));
-	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT20));
-	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT40));
-	PR_EEP("Big Endian", !!(pBase->eepMisc & 0x01));
-	PR_EEP("Cal Bin Major Ver", (pBase->binBuildNumber >> 24) & 0xFF);
-	PR_EEP("Cal Bin Minor Ver", (pBase->binBuildNumber >> 16) & 0xFF);
-	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
-	PR_EEP("Power Table Offset", pBase->pwrTableOffset);
-	PR_EEP("OpenLoop Power Ctrl", pBase->openLoopPwrCntl);
-
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
-
-out:
-	if (len > size)
-		len = size;
-
-	return len;
-}
-#else
-static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				       u8 *buf, u32 len, u32 size)
-{
-	return 0;
-}
-#endif
-
-
 static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 {
 	u32 sum = 0, el, integer;
@@ -1040,7 +935,6 @@ const struct eeprom_ops eep_ar9287_ops = {
 	.check_eeprom		= ath9k_hw_ar9287_check_eeprom,
 	.get_eeprom		= ath9k_hw_ar9287_get_eeprom,
 	.fill_eeprom		= ath9k_hw_ar9287_fill_eeprom,
-	.dump_eeprom		= ath9k_hw_ar9287_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_ar9287_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_ar9287_set_board_values,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 56290f3..0ac82a1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -132,136 +132,6 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 
 #undef SIZE_EEPROM_DEF
 
-#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
-static u32 ath9k_def_dump_modal_eeprom(char *buf, u32 len, u32 size,
-				       struct modal_eep_header *modal_hdr)
-{
-	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
-	PR_EEP("Chain1 Ant. Control", modal_hdr->antCtrlChain[1]);
-	PR_EEP("Chain2 Ant. Control", modal_hdr->antCtrlChain[2]);
-	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
-	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
-	PR_EEP("Chain1 Ant. Gain", modal_hdr->antennaGainCh[1]);
-	PR_EEP("Chain2 Ant. Gain", modal_hdr->antennaGainCh[2]);
-	PR_EEP("Switch Settle", modal_hdr->switchSettling);
-	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
-	PR_EEP("Chain1 TxRxAtten", modal_hdr->txRxAttenCh[1]);
-	PR_EEP("Chain2 TxRxAtten", modal_hdr->txRxAttenCh[2]);
-	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
-	PR_EEP("Chain1 RxTxMargin", modal_hdr->rxTxMarginCh[1]);
-	PR_EEP("Chain2 RxTxMargin", modal_hdr->rxTxMarginCh[2]);
-	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
-	PR_EEP("PGA Desired size", modal_hdr->pgaDesiredSize);
-	PR_EEP("Chain0 xlna Gain", modal_hdr->xlnaGainCh[0]);
-	PR_EEP("Chain1 xlna Gain", modal_hdr->xlnaGainCh[1]);
-	PR_EEP("Chain2 xlna Gain", modal_hdr->xlnaGainCh[2]);
-	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
-	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
-	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
-	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
-	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
-	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
-	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
-	PR_EEP("xpdGain", modal_hdr->xpdGain);
-	PR_EEP("External PD", modal_hdr->xpd);
-	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
-	PR_EEP("Chain1 I Coefficient", modal_hdr->iqCalICh[1]);
-	PR_EEP("Chain2 I Coefficient", modal_hdr->iqCalICh[2]);
-	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
-	PR_EEP("Chain1 Q Coefficient", modal_hdr->iqCalQCh[1]);
-	PR_EEP("Chain2 Q Coefficient", modal_hdr->iqCalQCh[2]);
-	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
-	PR_EEP("Chain0 OutputBias", modal_hdr->ob);
-	PR_EEP("Chain0 DriverBias", modal_hdr->db);
-	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
-	PR_EEP("2chain pwr decrease", modal_hdr->pwrDecreaseFor2Chain);
-	PR_EEP("3chain pwr decrease", modal_hdr->pwrDecreaseFor3Chain);
-	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
-	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
-	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
-	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
-	PR_EEP("Chain1 bswAtten", modal_hdr->bswAtten[1]);
-	PR_EEP("Chain2 bswAtten", modal_hdr->bswAtten[2]);
-	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
-	PR_EEP("Chain1 bswMargin", modal_hdr->bswMargin[1]);
-	PR_EEP("Chain2 bswMargin", modal_hdr->bswMargin[2]);
-	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
-	PR_EEP("Chain0 xatten2Db", modal_hdr->xatten2Db[0]);
-	PR_EEP("Chain1 xatten2Db", modal_hdr->xatten2Db[1]);
-	PR_EEP("Chain2 xatten2Db", modal_hdr->xatten2Db[2]);
-	PR_EEP("Chain0 xatten2Margin", modal_hdr->xatten2Margin[0]);
-	PR_EEP("Chain1 xatten2Margin", modal_hdr->xatten2Margin[1]);
-	PR_EEP("Chain2 xatten2Margin", modal_hdr->xatten2Margin[2]);
-	PR_EEP("Chain1 OutputBias", modal_hdr->ob_ch1);
-	PR_EEP("Chain1 DriverBias", modal_hdr->db_ch1);
-	PR_EEP("LNA Control", modal_hdr->lna_ctl);
-	PR_EEP("XPA Bias Freq0", modal_hdr->xpaBiasLvlFreq[0]);
-	PR_EEP("XPA Bias Freq1", modal_hdr->xpaBiasLvlFreq[1]);
-	PR_EEP("XPA Bias Freq2", modal_hdr->xpaBiasLvlFreq[2]);
-
-	return len;
-}
-
-static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				    u8 *buf, u32 len, u32 size)
-{
-	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
-	struct base_eep_header *pBase = &eep->baseEepHeader;
-
-	if (!dump_base_hdr) {
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "2GHz modal Header");
-		len = ath9k_def_dump_modal_eeprom(buf, len, size,
-						   &eep->modalHeader[0]);
-		len += snprintf(buf + len, size - len,
-				"%20s :\n", "5GHz modal Header");
-		len = ath9k_def_dump_modal_eeprom(buf, len, size,
-						   &eep->modalHeader[1]);
-		goto out;
-	}
-
-	PR_EEP("Major Version", pBase->version >> 12);
-	PR_EEP("Minor Version", pBase->version & 0xFFF);
-	PR_EEP("Checksum", pBase->checksum);
-	PR_EEP("Length", pBase->length);
-	PR_EEP("RegDomain1", pBase->regDmn[0]);
-	PR_EEP("RegDomain2", pBase->regDmn[1]);
-	PR_EEP("TX Mask", pBase->txMask);
-	PR_EEP("RX Mask", pBase->rxMask);
-	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
-	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
-	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT20));
-	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_2G_HT40));
-	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT20));
-	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags &
-					AR5416_OPFLAGS_N_5G_HT40));
-	PR_EEP("Big Endian", !!(pBase->eepMisc & 0x01));
-	PR_EEP("Cal Bin Major Ver", (pBase->binBuildNumber >> 24) & 0xFF);
-	PR_EEP("Cal Bin Minor Ver", (pBase->binBuildNumber >> 16) & 0xFF);
-	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
-	PR_EEP("OpenLoop Power Ctrl", pBase->openLoopPwrCntl);
-
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
-
-out:
-	if (len > size)
-		len = size;
-
-	return len;
-}
-#else
-static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
-				    u8 *buf, u32 len, u32 size)
-{
-	return 0;
-}
-#endif
-
-
 static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep =
@@ -1384,7 +1254,6 @@ const struct eeprom_ops eep_def_ops = {
 	.check_eeprom		= ath9k_hw_def_check_eeprom,
 	.get_eeprom		= ath9k_hw_def_get_eeprom,
 	.fill_eeprom		= ath9k_hw_def_fill_eeprom,
-	.dump_eeprom		= ath9k_hw_def_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_def_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_def_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_def_set_board_values,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 3035deb..9a1524d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -486,436 +486,6 @@ static const struct file_operations fops_debug = {
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
-	/*
-	 * This can be done since all the 3 EEPROM families have the
-	 * same base header upto a certain point, and we are interested in
-	 * the data only upto that point.
-	 */
-
-	if (AR_SREV_9271(priv->ah))
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.map4k.baseEepHeader;
-	else if (priv->ah->hw_version.usbdev == AR9280_USB)
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.def.baseEepHeader;
-	else if (priv->ah->hw_version.usbdev == AR9287_USB)
-		pBase = (struct base_eep_header *)
-			&priv->ah->eeprom.map9287.baseEepHeader;
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
-
-	/*
-	 * UB91 specific data.
-	 */
-	if (AR_SREV_9271(priv->ah)) {
-		struct base_eep_header_4k *pBase4k =
-			&priv->ah->eeprom.map4k.baseEepHeader;
-
-		len += snprintf(buf + len, size - len,
-				"%20s : %10d\n",
-				"TX Gain type",
-				pBase4k->txGainType);
-	}
-
-	/*
-	 * UB95 specific data.
-	 */
-	if (priv->ah->hw_version.usbdev == AR9287_USB) {
-		struct base_eep_ar9287_header *pBase9287 =
-			&priv->ah->eeprom.map9287.baseEepHeader;
-
-		len += snprintf(buf + len, size - len,
-				"%20s : %10ddB\n",
-				"Power Table Offset",
-				pBase9287->pwrTableOffset);
-
-		len += snprintf(buf + len, size - len,
-				"%20s : %10d\n",
-				"OpenLoop Power Ctrl",
-				pBase9287->openLoopPwrCntl);
-	}
-
-	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
-			pBase->macAddr);
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
-static ssize_t read_4k_modal_eeprom(struct file *file,
-				    char __user *user_buf,
-				    size_t count, loff_t *ppos)
-{
-#define PR_EEP(_s, _val)						\
-	do {								\
-		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
-				_s, (_val));				\
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
-			len += snprintf(buf + len, size - len, "%20s : %8d%7s", \
-					_s, (_val), "|");		\
-		}							\
-		if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {		\
-			pModal = &priv->ah->eeprom.def.modalHeader[0];	\
-			len += snprintf(buf + len, size - len, "%9d\n", \
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
-	len += snprintf(buf + len, size - len,
-			"%31s %15s\n", "2G", "5G");
-	len += snprintf(buf + len, size - len,
-			"%32s %16s\n", "====", "====\n");
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
-		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
-				_s, (_val));				\
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
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -942,10 +512,6 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 			    priv, &fops_queue);
 	debugfs_create_file("debug", S_IRUSR | S_IWUSR, priv->debug.debugfs_phy,
 			    priv, &fops_debug);
-	debugfs_create_file("base_eeprom", S_IRUSR, priv->debug.debugfs_phy,
-			    priv, &fops_base_eeprom);
-	debugfs_create_file("modal_eeprom", S_IRUSR, priv->debug.debugfs_phy,
-			    priv, &fops_modal_eeprom);
 
 	return 0;
 }
-- 
1.7.11.2

