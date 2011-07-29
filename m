Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59522 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1G2MIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:44 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 04/13] ath9k_hw: Add dump_eeprom support for eeprom_def
Date: Fri, 29 Jul 2011 17:38:11 +0530
Message-ID: <1311941300-2590-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140848_086498_84F8B8F7)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |  131 +++++++++++++++++++++++++++
 1 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index b9540a9..4986740 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -133,6 +133,136 @@ static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 
 #undef SIZE_EEPROM_DEF
 
+#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+static u32 ath9k_def_dump_modal_eeprom(char *buf, u32 len, u32 size,
+				       struct modal_eep_header *modal_hdr)
+{
+	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
+	PR_EEP("Chain1 Ant. Control", modal_hdr->antCtrlChain[1]);
+	PR_EEP("Chain2 Ant. Control", modal_hdr->antCtrlChain[2]);
+	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
+	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
+	PR_EEP("Chain1 Ant. Gain", modal_hdr->antennaGainCh[1]);
+	PR_EEP("Chain2 Ant. Gain", modal_hdr->antennaGainCh[2]);
+	PR_EEP("Switch Settle", modal_hdr->switchSettling);
+	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
+	PR_EEP("Chain1 TxRxAtten", modal_hdr->txRxAttenCh[1]);
+	PR_EEP("Chain2 TxRxAtten", modal_hdr->txRxAttenCh[2]);
+	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
+	PR_EEP("Chain1 RxTxMargin", modal_hdr->rxTxMarginCh[1]);
+	PR_EEP("Chain2 RxTxMargin", modal_hdr->rxTxMarginCh[2]);
+	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
+	PR_EEP("PGA Desired size", modal_hdr->pgaDesiredSize);
+	PR_EEP("Chain0 xlna Gain", modal_hdr->xlnaGainCh[0]);
+	PR_EEP("Chain1 xlna Gain", modal_hdr->xlnaGainCh[1]);
+	PR_EEP("Chain2 xlna Gain", modal_hdr->xlnaGainCh[2]);
+	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
+	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
+	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
+	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
+	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
+	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
+	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
+	PR_EEP("xpdGain", modal_hdr->xpdGain);
+	PR_EEP("External PD", modal_hdr->xpd);
+	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
+	PR_EEP("Chain1 I Coefficient", modal_hdr->iqCalICh[1]);
+	PR_EEP("Chain2 I Coefficient", modal_hdr->iqCalICh[2]);
+	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
+	PR_EEP("Chain1 Q Coefficient", modal_hdr->iqCalQCh[1]);
+	PR_EEP("Chain2 Q Coefficient", modal_hdr->iqCalQCh[2]);
+	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
+	PR_EEP("Chain0 OutputBias", modal_hdr->ob);
+	PR_EEP("Chain0 DriverBias", modal_hdr->db);
+	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
+	PR_EEP("2chain pwr decrease", modal_hdr->pwrDecreaseFor2Chain);
+	PR_EEP("3chain pwr decrease", modal_hdr->pwrDecreaseFor3Chain);
+	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
+	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
+	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
+	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
+	PR_EEP("Chain1 bswAtten", modal_hdr->bswAtten[1]);
+	PR_EEP("Chain2 bswAtten", modal_hdr->bswAtten[2]);
+	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
+	PR_EEP("Chain1 bswMargin", modal_hdr->bswMargin[1]);
+	PR_EEP("Chain2 bswMargin", modal_hdr->bswMargin[2]);
+	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
+	PR_EEP("Chain0 xatten2Db", modal_hdr->xatten2Db[0]);
+	PR_EEP("Chain1 xatten2Db", modal_hdr->xatten2Db[1]);
+	PR_EEP("Chain2 xatten2Db", modal_hdr->xatten2Db[2]);
+	PR_EEP("Chain0 xatten2Margin", modal_hdr->xatten2Margin[0]);
+	PR_EEP("Chain1 xatten2Margin", modal_hdr->xatten2Margin[1]);
+	PR_EEP("Chain2 xatten2Margin", modal_hdr->xatten2Margin[2]);
+	PR_EEP("Chain1 OutputBias", modal_hdr->ob_ch1);
+	PR_EEP("Chain1 DriverBias", modal_hdr->db_ch1);
+	PR_EEP("LNA Control", modal_hdr->lna_ctl);
+	PR_EEP("XPA Bias Freq0", modal_hdr->xpaBiasLvlFreq[0]);
+	PR_EEP("XPA Bias Freq1", modal_hdr->xpaBiasLvlFreq[1]);
+	PR_EEP("XPA Bias Freq2", modal_hdr->xpaBiasLvlFreq[2]);
+
+	return len;
+}
+
+static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				    u8 *buf, u32 len, u32 size)
+{
+	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
+	struct base_eep_header *pBase = &eep->baseEepHeader;
+
+	if (!dump_base_hdr) {
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "2GHz modal Header");
+		len += ath9k_def_dump_modal_eeprom(buf, len, size,
+						   &eep->modalHeader[0]);
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "5GHz modal Header");
+		len += ath9k_def_dump_modal_eeprom(buf, len, size,
+						   &eep->modalHeader[1]);
+		goto out;
+	}
+
+	PR_EEP("Major Version", pBase->version >> 12);
+	PR_EEP("Minor Version", pBase->version & 0xFFF);
+	PR_EEP("Checksum", pBase->checksum);
+	PR_EEP("Length", pBase->length);
+	PR_EEP("RegDomain1", pBase->regDmn[0]);
+	PR_EEP("RegDomain2", pBase->regDmn[1]);
+	PR_EEP("TX Mask", pBase->txMask);
+	PR_EEP("RX Mask", pBase->rxMask);
+	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags &
+					AR5416_OPFLAGS_N_2G_HT20));
+	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags &
+					AR5416_OPFLAGS_N_2G_HT40));
+	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags &
+					AR5416_OPFLAGS_N_5G_HT20));
+	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags &
+					AR5416_OPFLAGS_N_5G_HT40));
+	PR_EEP("Big Endian", !!(pBase->eepMisc & 0x01));
+	PR_EEP("Cal Bin Major Ver", (pBase->binBuildNumber >> 24) & 0xFF);
+	PR_EEP("Cal Bin Minor Ver", (pBase->binBuildNumber >> 16) & 0xFF);
+	PR_EEP("Cal Bin Build", (pBase->binBuildNumber >> 8) & 0xFF);
+	PR_EEP("OpenLoop Power Ctrl", pBase->openLoopPwrCntl);
+
+	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			pBase->macAddr);
+
+out:
+	if (len > size)
+		len = size;
+
+	return len;
+}
+#else
+static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				    u8 *buf, u32 len, u32 size)
+{
+	return 0;
+}
+#endif
+
+
 static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep =
@@ -1336,6 +1466,7 @@ const struct eeprom_ops eep_def_ops = {
 	.check_eeprom		= ath9k_hw_def_check_eeprom,
 	.get_eeprom		= ath9k_hw_def_get_eeprom,
 	.fill_eeprom		= ath9k_hw_def_fill_eeprom,
+	.dump_eeprom		= ath9k_hw_def_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_def_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_def_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_def_set_board_values,
-- 
1.7.6

