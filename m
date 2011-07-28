Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G1R32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:29:28 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/9] ath9k: Dump base eeprom header for AR9003
Date: Thu, 28 Jul 2011 22:59:28 +0530
Message-ID: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_192934_238784_EF94ED20)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debugfs file location:
<debugfs_mnt>/ieee80211/phy#/ath9k/base_eeprom

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |  147 ++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index d1eb896..df71c72 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1163,6 +1163,151 @@ static const struct file_operations fops_regdump = {
 	.llseek = default_llseek,/* read accesses f_pos */
 };
 
+static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ar9300_base_eep_hdr *pBase = NULL;
+	unsigned int len = 0, size = 1500;
+	ssize_t retval = 0;
+	char *buf;
+
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		return 0;
+
+	pBase = (struct ar9300_base_eep_hdr *)
+			&ah->eeprom.ar9300_eep.baseEepHeader;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "EEPROM Version",
+			ah->eeprom.ar9300_eep.eepromVersion);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RegDomain1",
+			le16_to_cpu(pBase->regDmn[0]));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RegDomain2",
+			le16_to_cpu(pBase->regDmn[1]));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "TX Mask",
+			(pBase->txrxMask >> 4));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RX Mask",
+			(pBase->txrxMask & 0x0f));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Allow 5GHz",
+			!!(pBase->opCapFlags.opFlags & AR5416_OPFLAGS_11A));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Allow 2GHz",
+			!!(pBase->opCapFlags.opFlags & AR5416_OPFLAGS_11G));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Disable 2GHz HT20",
+			!!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_N_2G_HT20));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Disable 2GHz HT40",
+			!!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_N_2G_HT40));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Disable 5Ghz HT20",
+			!!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_N_5G_HT20));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Disable 5Ghz HT40",
+			!!(pBase->opCapFlags.opFlags &
+				AR5416_OPFLAGS_N_5G_HT40));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Big Endian",
+			!!(pBase->opCapFlags.eepMisc & 0x01));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "RF Silent",
+			pBase->rfSilent);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "BT option",
+			pBase->blueToothOptions);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Device Cap",
+			pBase->deviceCap);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Device Type",
+			pBase->deviceType);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Power Table Offset",
+			pBase->pwrTableOffset);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Tuning Caps1",
+			pBase->params_for_tuning_caps[0]);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Tuning Caps2",
+			pBase->params_for_tuning_caps[1]);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Enable Tx Temp Comp",
+			!!(pBase->featureEnable & BIT(0)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Enable Tx Volt Comp",
+			!!(pBase->featureEnable & BIT(1)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Enable fast clock",
+			!!(pBase->featureEnable & BIT(2)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Enable doubling",
+			!!(pBase->featureEnable & BIT(3)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Internal regulator",
+			!!(pBase->featureEnable & BIT(4)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Enable Paprd",
+			!!(pBase->featureEnable & BIT(5)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Driver Strength",
+			!!(pBase->miscConfiguration & BIT(0)));
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Chain mask Reduce",
+			(pBase->miscConfiguration >> 0x3) & 0x1);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Write enable Gpio",
+			pBase->eepromWriteEnableGpio);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "WLAN Disable Gpio",
+			pBase->wlanDisableGpio);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "WLAN LED Gpio",
+			pBase->wlanLedGpio);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Rx Band Select Gpio",
+			pBase->rxBandSelectGpio);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Tx Gain",
+			pBase->txrxgain >> 4);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "Rx Gain",
+			pBase->txrxgain & 0xf);
+	len += snprintf(buf + len, size - len,
+			"%20s : %10d\n", "SW Reg",
+			le32_to_cpu(pBase->swreg));
+
+	len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
+			ah->eeprom.ar9300_eep.macAddr);
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
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1206,6 +1351,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &ah->config.cwm_ignore_extcca);
 	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
+	debugfs_create_file("base_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
+			    &fops_base_eeprom);
 
 	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-- 
1.7.6

