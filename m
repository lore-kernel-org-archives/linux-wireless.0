Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52681 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab1G2MIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:08:11 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 01/13] ath9k_hw: Add dump_eeprom support for AR9003
Date: Fri, 29 Jul 2011 17:38:08 +0530
Message-ID: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140819_200542_228B4165)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  128 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/eeprom.h        |    2 +
 drivers/net/wireless/ath/ath9k/hw.h            |    6 +
 3 files changed, 136 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d109c25..e216712 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3418,6 +3418,133 @@ static bool ath9k_hw_ar9300_fill_eeprom(struct ath_hw *ah)
 	return true;
 }
 
+#if defined(CONFIG_ATH9K_DEBUGFS) || defined(CONFIG_ATH9K_HTC_DEBUGFS)
+static u32 ar9003_dump_modal_eeprom(char *buf, u32 len, u32 size,
+				    struct ar9300_modal_eep_header *modal_hdr)
+{
+	PR_EEP("Chain0 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[0]));
+	PR_EEP("Chain1 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[1]));
+	PR_EEP("Chain2 Ant. Control", le16_to_cpu(modal_hdr->antCtrlChain[2]));
+	PR_EEP("Ant. Common Control", le32_to_cpu(modal_hdr->antCtrlCommon));
+	PR_EEP("Ant. Common Control2", le32_to_cpu(modal_hdr->antCtrlCommon2));
+	PR_EEP("Ant. Gain", modal_hdr->antennaGain);
+	PR_EEP("Switch Settle", modal_hdr->switchSettling);
+	PR_EEP("Chain0 xatten1DB", modal_hdr->xatten1DB[0]);
+	PR_EEP("Chain1 xatten1DB", modal_hdr->xatten1DB[1]);
+	PR_EEP("Chain2 xatten1DB", modal_hdr->xatten1DB[2]);
+	PR_EEP("Chain0 xatten1Margin", modal_hdr->xatten1Margin[0]);
+	PR_EEP("Chain1 xatten1Margin", modal_hdr->xatten1Margin[1]);
+	PR_EEP("Chain2 xatten1Margin", modal_hdr->xatten1Margin[2]);
+	PR_EEP("Temp Slope", modal_hdr->tempSlope);
+	PR_EEP("Volt Slope", modal_hdr->voltSlope);
+	PR_EEP("spur Channels0", modal_hdr->spurChans[0]);
+	PR_EEP("spur Channels1", modal_hdr->spurChans[1]);
+	PR_EEP("spur Channels2", modal_hdr->spurChans[2]);
+	PR_EEP("spur Channels3", modal_hdr->spurChans[3]);
+	PR_EEP("spur Channels4", modal_hdr->spurChans[4]);
+	PR_EEP("Chain0 NF Threshold", modal_hdr->noiseFloorThreshCh[0]);
+	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
+	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
+	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
+	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
+	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
+	PR_EEP("txFrameToXpaOn", modal_hdr->txFrameToXpaOn);
+	PR_EEP("txClip", modal_hdr->txClip);
+	PR_EEP("ADC Desired size", modal_hdr->adcDesiredSize);
+	PR_EEP("Chain0 ob", modal_hdr->ob[0]);
+	PR_EEP("Chain1 ob", modal_hdr->ob[1]);
+	PR_EEP("Chain2 ob", modal_hdr->ob[2]);
+
+	PR_EEP("Chain0 db_stage2", modal_hdr->db_stage2[0]);
+	PR_EEP("Chain1 db_stage2", modal_hdr->db_stage2[1]);
+	PR_EEP("Chain2 db_stage2", modal_hdr->db_stage2[2]);
+	PR_EEP("Chain0 db_stage3", modal_hdr->db_stage3[0]);
+	PR_EEP("Chain1 db_stage3", modal_hdr->db_stage3[1]);
+	PR_EEP("Chain2 db_stage3", modal_hdr->db_stage3[2]);
+	PR_EEP("Chain0 db_stage4", modal_hdr->db_stage4[0]);
+	PR_EEP("Chain1 db_stage4", modal_hdr->db_stage4[1]);
+	PR_EEP("Chain2 db_stage4", modal_hdr->db_stage4[2]);
+
+	return len;
+}
+
+static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct ar9300_base_eep_hdr *pBase;
+
+	if (!dump_base_hdr) {
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "2GHz modal Header");
+		len += ar9003_dump_modal_eeprom(buf, len, size,
+						&eep->modalHeader2G);
+		len += snprintf(buf + len, size - len,
+				"%20s :\n", "5GHz modal Header");
+		len += ar9003_dump_modal_eeprom(buf, len, size,
+						&eep->modalHeader5G);
+		goto out;
+	}
+
+	pBase = &eep->baseEepHeader;
+
+	PR_EEP("EEPROM Version", ah->eeprom.ar9300_eep.eepromVersion);
+	PR_EEP("RegDomain1", le16_to_cpu(pBase->regDmn[0]));
+	PR_EEP("RegDomain2", le16_to_cpu(pBase->regDmn[1]));
+	PR_EEP("TX Mask", (pBase->txrxMask >> 4));
+	PR_EEP("RX Mask", (pBase->txrxMask & 0x0f));
+	PR_EEP("Allow 5GHz", !!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_11A));
+	PR_EEP("Allow 2GHz", !!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_11G));
+	PR_EEP("Disable 2GHz HT20", !!(pBase->opCapFlags.opFlags &
+					AR5416_OPFLAGS_N_2G_HT20));
+	PR_EEP("Disable 2GHz HT40", !!(pBase->opCapFlags.opFlags &
+					AR5416_OPFLAGS_N_2G_HT40));
+	PR_EEP("Disable 5Ghz HT20", !!(pBase->opCapFlags.opFlags &
+					AR5416_OPFLAGS_N_5G_HT20));
+	PR_EEP("Disable 5Ghz HT40", !!(pBase->opCapFlags.opFlags &
+					AR5416_OPFLAGS_N_5G_HT40));
+	PR_EEP("Big Endian", !!(pBase->opCapFlags.eepMisc & 0x01));
+	PR_EEP("RF Silent", pBase->rfSilent);
+	PR_EEP("BT option", pBase->blueToothOptions);
+	PR_EEP("Device Cap", pBase->deviceCap);
+	PR_EEP("Device Type", pBase->deviceType);
+	PR_EEP("Power Table Offset", pBase->pwrTableOffset);
+	PR_EEP("Tuning Caps1", pBase->params_for_tuning_caps[0]);
+	PR_EEP("Tuning Caps2", pBase->params_for_tuning_caps[1]);
+	PR_EEP("Enable Tx Temp Comp", !!(pBase->featureEnable & BIT(0)));
+	PR_EEP("Enable Tx Volt Comp", !!(pBase->featureEnable & BIT(1)));
+	PR_EEP("Enable fast clock", !!(pBase->featureEnable & BIT(2)));
+	PR_EEP("Enable doubling", !!(pBase->featureEnable & BIT(3)));
+	PR_EEP("Internal regulator", !!(pBase->featureEnable & BIT(4)));
+	PR_EEP("Enable Paprd", !!(pBase->featureEnable & BIT(5)));
+	PR_EEP("Driver Strength", !!(pBase->miscConfiguration & BIT(0)));
+	PR_EEP("Chain mask Reduce", (pBase->miscConfiguration >> 0x3) & 0x1);
+	PR_EEP("Write enable Gpio", pBase->eepromWriteEnableGpio);
+	PR_EEP("WLAN Disable Gpio", pBase->wlanDisableGpio);
+	PR_EEP("WLAN LED Gpio", pBase->wlanLedGpio);
+	PR_EEP("Rx Band Select Gpio", pBase->rxBandSelectGpio);
+	PR_EEP("Tx Gain", pBase->txrxgain >> 4);
+	PR_EEP("Rx Gain", pBase->txrxgain & 0xf);
+	PR_EEP("SW Reg", le32_to_cpu(pBase->swreg));
+
+	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			ah->eeprom.ar9300_eep.macAddr);
+out:
+	if (len > size)
+		len = size;
+
+	return len;
+}
+#else
+static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
+				       u8 *buf, u32 len, u32 size)
+{
+	return 0;
+}
+#endif
+
 /* XXX: review hardware docs */
 static int ath9k_hw_ar9300_get_eeprom_ver(struct ath_hw *ah)
 {
@@ -5015,6 +5142,7 @@ const struct eeprom_ops eep_ar9300_ops = {
 	.check_eeprom = ath9k_hw_ar9300_check_eeprom,
 	.get_eeprom = ath9k_hw_ar9300_get_eeprom,
 	.fill_eeprom = ath9k_hw_ar9300_fill_eeprom,
+	.dump_eeprom = ath9k_hw_ar9003_dump_eeprom,
 	.get_eeprom_ver = ath9k_hw_ar9300_get_eeprom_ver,
 	.get_eeprom_rev = ath9k_hw_ar9300_get_eeprom_rev,
 	.set_board_values = ath9k_hw_ar9300_set_board_values,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index de99c0d..a3c7d0c2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -649,6 +649,8 @@ struct eeprom_ops {
 	int (*check_eeprom)(struct ath_hw *hw);
 	u32 (*get_eeprom)(struct ath_hw *hw, enum eeprom_param param);
 	bool (*fill_eeprom)(struct ath_hw *hw);
+	u32 (*dump_eeprom)(struct ath_hw *hw, bool dump_base_hdr, u8 *buf,
+			   u32 len, u32 size);
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6acd0f9..6f3abcd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -93,6 +93,12 @@
 			(_ah)->reg_ops.write_flush((_ah));	\
 	} while (0)
 
+#define PR_EEP(_s, _val)						\
+	do {								\
+		len += snprintf(buf + len, size - len, "%20s : %10d\n",	\
+				_s, (_val));				\
+	} while (0)
+
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
 #define REG_RMW_FIELD(_a, _r, _f, _v) \
-- 
1.7.6

