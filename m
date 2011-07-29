Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45807 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1G2MIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:38 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 03/13] ath9k_hw: Add dump_eeprom support for AR9287
Date: Fri, 29 Jul 2011 17:38:10 +0530
Message-ID: <1311941300-2590-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140843_639067_80EF3C81)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |  106 ++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index d6f6b19..4f6a4e0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -76,6 +76,111 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 		return __ath9k_hw_ar9287_fill_eeprom(ah);
 }
 
+#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+static u32 ar9287_dump_modal_eeprom(char *buf, u32 len, u32 size,
+				    struct modal_eep_ar9287_header *modal_hdr)
+{
+	PR_EEP("Chain0 Ant. Control", modal_hdr->antCtrlChain[0]);
+	PR_EEP("Chain1 Ant. Control", modal_hdr->antCtrlChain[1]);
+	PR_EEP("Ant. Common Control", modal_hdr->antCtrlCommon);
+	PR_EEP("Chain0 Ant. Gain", modal_hdr->antennaGainCh[0]);
+	PR_EEP("Chain1 Ant. Gain", modal_hdr->antennaGainCh[1]);
+	PR_EEP("Switch Settle", modal_hdr->switchSettling);
+	PR_EEP("Chain0 TxRxAtten", modal_hdr->txRxAttenCh[0]);
+	PR_EEP("Chain1 TxRxAtten", modal_hdr->txRxAttenCh[1]);
+	PR_EEP("Chain0 RxTxMargin", modal_hdr->rxTxMarginCh[0]);
+	PR_EEP("Chain1 RxTxMargin", modal_hdr->rxTxMarginCh[1]);
+	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
+	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
+	PR_EEP("txEndToRxOn", modal_hdr->txEndToRxOn);
+	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
+	PR_EEP("CCA Threshold)", modal_hdr->thresh62);
+	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
+	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
+	PR_EEP("xpdGain", modal_hdr->xpdGain);
+	PR_EEP("External PD", modal_hdr->xpd);
+	PR_EEP("Chain0 I Coefficient", modal_hdr->iqCalICh[0]);
+	PR_EEP("Chain1 I Coefficient", modal_hdr->iqCalICh[1]);
+	PR_EEP("Chain0 Q Coefficient", modal_hdr->iqCalQCh[0]);
+	PR_EEP("Chain1 Q Coefficient", modal_hdr->iqCalQCh[1]);
+	PR_EEP("pdGainOverlap", modal_hdr->pdGainOverlap);
+	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
+	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
+	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
+	PR_EEP("HT40 Power Inc.", modal_hdr->ht40PowerIncForPdadc);
+	PR_EEP("Chain0 bswAtten", modal_hdr->bswAtten[0]);
+	PR_EEP("Chain1 bswAtten", modal_hdr->bswAtten[1]);
+	PR_EEP("Chain0 bswMargin", modal_hdr->bswMargin[0]);
+	PR_EEP("Chain1 bswMargin", modal_hdr->bswMargin[1]);
+	PR_EEP("HT40 Switch Settle", modal_hdr->swSettleHt40);
+	PR_EEP("AR92x7 Version", modal_hdr->version);
+	PR_EEP("DriverBias1", modal_hdr->db1);
+	PR_EEP("DriverBias2", modal_hdr->db1);
+	PR_EEP("CCK OutputBias", modal_hdr->ob_cck);
+	PR_EEP("PSK OutputBias", modal_hdr->ob_psk);
+	PR_EEP("QAM OutputBias", modal_hdr->ob_qam);
+	PR_EEP("PAL_OFF OutputBias", modal_hdr->ob_pal_off);
+
+	return len;
+}
+
+static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
+	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
+
+	if (!dump_base_hdr) {
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "2GHz modal Header");
+		len += ar9287_dump_modal_eeprom(buf, len, size,
+						&eep->modalHeader);
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
+	PR_EEP("Power Table Offset", pBase->pwrTableOffset);
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
+static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	return 0;
+}
+#endif
+
+
 static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 {
 	u32 sum = 0, el, integer;
@@ -1003,6 +1108,7 @@ const struct eeprom_ops eep_ar9287_ops = {
 	.check_eeprom		= ath9k_hw_ar9287_check_eeprom,
 	.get_eeprom		= ath9k_hw_ar9287_get_eeprom,
 	.fill_eeprom		= ath9k_hw_ar9287_fill_eeprom,
+	.dump_eeprom		= ath9k_hw_ar9287_dump_eeprom,
 	.get_eeprom_ver		= ath9k_hw_ar9287_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_ar9287_set_board_values,
-- 
1.7.6

