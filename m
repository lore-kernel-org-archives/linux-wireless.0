Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1G2MId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 02/13] ath9k_hw: Add dump_eeprom support for eeprom_4k
Date: Fri, 29 Jul 2011 17:38:09 +0530
Message-ID: <1311941300-2590-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140837_589833_F4682C3A)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c |  112 ++++++++++++++++++++++++++++
 1 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 47cc950..b996779 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -72,6 +72,117 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_4k_fill_eeprom(ah);
 }
 
+#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+static u32 ath9k_dump_4k_modal_eeprom(char *buf, u32 len, u32 size,
+				      struct modal_eep_4k_header *modal_hdr)
+{
+	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
+	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
+	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
+	PR_EEP("Switch Settle", modal_hdr->switchSettling);
+	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
+	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
+	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
+	PR_EEP("PGA Desired size", modal_hdr->pgaDesiredSize);
+	PR_EEP("Chain0 xlna Gain", modal_hdr->xlnaGainCh[0]);
+	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
+	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
+	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
+	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
+	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
+	PR_EEP("xpdGain", modal_hdr->xpdGain);
+	PR_EEP("External PD", modal_hdr->xpd);
+	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
+	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
+	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
+	PR_EEP("O/D Bias Version", modal_hdr->version);
+	PR_EEP("CCK OutputBias", modal_hdr->ob_0);
+	PR_EEP("BPSK OutputBias", modal_hdr->ob_1);
+	PR_EEP("QPSK OutputBias", modal_hdr->ob_2);
+	PR_EEP("16QAM OutputBias", modal_hdr->ob_3);
+	PR_EEP("64QAM OutputBias", modal_hdr->ob_4);
+	PR_EEP("CCK Driver1_Bias", modal_hdr->db1_0);
+	PR_EEP("BPSK Driver1_Bias", modal_hdr->db1_1);
+	PR_EEP("QPSK Driver1_Bias", modal_hdr->db1_2);
+	PR_EEP("16QAM Driver1_Bias", modal_hdr->db1_3);
+	PR_EEP("64QAM Driver1_Bias", modal_hdr->db1_4);
+	PR_EEP("CCK Driver2_Bias", modal_hdr->db2_0);
+	PR_EEP("BPSK Driver2_Bias", modal_hdr->db2_1);
+	PR_EEP("QPSK Driver2_Bias", modal_hdr->db2_2);
+	PR_EEP("16QAM Driver2_Bias", modal_hdr->db2_3);
+	PR_EEP("64QAM Driver2_Bias", modal_hdr->db2_4);
+	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
+	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
+	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
+	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
+	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
+	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
+	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
+	PR_EEP("Chain0 xatten2Db", modal_hdr->xatten2Db[0]);
+	PR_EEP("Chain0 xatten2Margin", modal_hdr->xatten2Margin[0]);
+	PR_EEP("Ant. Diversity ctl1", modal_hdr->antdiv_ctl1);
+	PR_EEP("Ant. Diversity ctl2", modal_hdr->antdiv_ctl2);
+	PR_EEP("TX Diversity", modal_hdr->tx_diversity);
+
+	return len;
+}
+
+static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
+	struct base_eep_header_4k *pBase = &eep->baseEepHeader;
+
+	if (!dump_base_hdr) {
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "2GHz modal Header");
+		len += ath9k_dump_4k_modal_eeprom(buf, len, size,
+						  &eep->modalHeader);
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
+	PR_EEP("TX Gain type", pBase->txGainType);
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
+static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	return 0;
+}
+#endif
+
+
 #undef SIZE_EEPROM_4K
 
 static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
@@ -1063,6 +1174,7 @@ const struct eeprom_ops eep_4k_ops = {
 	.check_eeprom		= ath9k_hw_4k_check_eeprom,
 	.get_eeprom		= ath9k_hw_4k_get_eeprom,
 	.fill_eeprom		= ath9k_hw_4k_fill_eeprom,
+	.dump_eeprom		= ath9k_hw_4k_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_4k_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_4k_set_board_values,
-- 
1.7.6

