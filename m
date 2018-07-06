Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932352AbeGFLEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:04:08 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 08/12] mt76x0: eeprom files
Date: Fri,  6 Jul 2018 13:03:45 +0200
Message-Id: <1530875029-26274-9-git-send-email-sgruszka@redhat.com> (sfid-20180706_130420_731163_6D6FEDF9)
In-Reply-To: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add eeprom files of mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 445 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h | 149 +++++++
 2 files changed, 594 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
new file mode 100644
index 000000000000..1ecd018f12b8
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -0,0 +1,445 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/of.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/etherdevice.h>
+#include <asm/unaligned.h>
+#include "mt76x0.h"
+#include "eeprom.h"
+
+static bool
+field_valid(u8 val)
+{
+	return val != 0xff;
+}
+
+static s8
+field_validate(u8 val)
+{
+	if (!field_valid(val))
+		return 0;
+
+	return val;
+}
+
+static inline int
+sign_extend(u32 val, unsigned int size)
+{
+	bool sign = val & BIT(size - 1);
+
+	val &= BIT(size - 1) - 1;
+
+	return sign ? val : -val;
+}
+
+static int
+mt76x0_efuse_read(struct mt76x0_dev *dev, u16 addr, u8 *data,
+		   enum mt76x0_eeprom_access_modes mode)
+{
+	u32 val;
+	int i;
+
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
+	val &= ~(MT_EFUSE_CTRL_AIN |
+		 MT_EFUSE_CTRL_MODE);
+	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
+	       FIELD_PREP(MT_EFUSE_CTRL_MODE, mode) |
+	       MT_EFUSE_CTRL_KICK;
+	mt76_wr(dev, MT_EFUSE_CTRL, val);
+
+	if (!mt76_poll(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
+		return -ETIMEDOUT;
+
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
+	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
+		/* Parts of eeprom not in the usage map (0x80-0xc0,0xf0)
+		 * will not return valid data but it's ok.
+		 */
+		memset(data, 0xff, 16);
+		return 0;
+	}
+
+	for (i = 0; i < 4; i++) {
+		val = mt76_rr(dev, MT_EFUSE_DATA(i));
+		put_unaligned_le32(val, data + 4 * i);
+	}
+
+	return 0;
+}
+
+static int
+mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
+{
+	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
+	u8 data[map_reads * 16];
+	int ret, i;
+	u32 start = 0, end = 0, cnt_free;
+
+	for (i = 0; i < map_reads; i++) {
+		ret = mt76x0_efuse_read(dev, MT_EE_USAGE_MAP_START + i * 16,
+					 data + i * 16, MT_EE_PHYSICAL_READ);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < MT_EFUSE_USAGE_MAP_SIZE; i++)
+		if (!data[i]) {
+			if (!start)
+				start = MT_EE_USAGE_MAP_START + i;
+			end = MT_EE_USAGE_MAP_START + i;
+		}
+	cnt_free = end - start + 1;
+
+	if (MT_EFUSE_USAGE_MAP_SIZE - cnt_free < 5) {
+		dev_err(dev->mt76.dev, "Error: your device needs default EEPROM file and this driver doesn't support it!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void
+mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	enum mt76x2_board_type { BOARD_TYPE_2GHZ = 1, BOARD_TYPE_5GHZ = 2 };
+	u16 nic_conf0 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_0);
+	u16 nic_conf1 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_1);
+
+	dev_dbg(dev->mt76.dev, "NIC_CONF0: %04x NIC_CONF1: %04x\n", nic_conf0, nic_conf1);
+
+	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, nic_conf0)) {
+	case BOARD_TYPE_5GHZ:
+		dev->ee->has_5ghz = true;
+		break;
+	case BOARD_TYPE_2GHZ:
+		dev->ee->has_2ghz = true;
+		break;
+	default:
+		dev->ee->has_2ghz = true;
+		dev->ee->has_5ghz = true;
+		break;
+	}
+
+	dev_dbg(dev->mt76.dev, "Has 2GHZ %d 5GHZ %d\n", dev->ee->has_2ghz, dev->ee->has_5ghz);
+
+	if (!field_valid(nic_conf1 & 0xff))
+		nic_conf1 &= 0xff00;
+
+	if (nic_conf1 & MT_EE_NIC_CONF_1_HW_RF_CTRL)
+		dev_err(dev->mt76.dev,
+			"Error: this driver does not support HW RF ctrl\n");
+
+	if (!field_valid(nic_conf0 >> 8))
+		return;
+
+	if (FIELD_GET(MT_EE_NIC_CONF_0_RX_PATH, nic_conf0) > 1 ||
+	    FIELD_GET(MT_EE_NIC_CONF_0_TX_PATH, nic_conf0) > 1)
+		dev_err(dev->mt76.dev,
+			"Error: device has more than 1 RX/TX stream!\n");
+
+	dev->ee->pa_type = FIELD_GET(MT_EE_NIC_CONF_0_PA_TYPE, nic_conf0);
+	dev_dbg(dev->mt76.dev, "PA Type %d\n", dev->ee->pa_type);
+}
+
+static int
+mt76x0_set_macaddr(struct mt76x0_dev *dev, const u8 *eeprom)
+{
+	const void *src = eeprom + MT_EE_MAC_ADDR;
+
+	ether_addr_copy(dev->macaddr, src);
+
+	if (!is_valid_ether_addr(dev->macaddr)) {
+		eth_random_addr(dev->macaddr);
+		dev_info(dev->mt76.dev,
+			 "Invalid MAC address, using random address %pM\n",
+			 dev->macaddr);
+	}
+
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
+	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dev->macaddr + 4) |
+		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+
+	return 0;
+}
+
+static void
+mt76x0_set_temp_offset(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	u8 temp = eeprom[MT_EE_TEMP_OFFSET];
+
+	if (field_valid(temp))
+		dev->ee->temp_off = sign_extend(temp, 8);
+	else
+		dev->ee->temp_off = -10;
+}
+
+static void
+mt76x0_set_country_reg(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	/* Note: - region 31 is not valid for mt76x0 (see rtmp_init.c)
+	 *	 - comments in rtmp_def.h are incorrect (see rt_channel.c)
+	 */
+	static const struct reg_channel_bounds chan_bounds[] = {
+		/* EEPROM country regions 0 - 7 */
+		{  1, 11 },	{  1, 13 },	{ 10,  2 },	{ 10,  4 },
+		{ 14,  1 },	{  1, 14 },	{  3,  7 },	{  5,  9 },
+		/* EEPROM country regions 32 - 33 */
+		{  1, 11 },	{  1, 14 }
+	};
+	u8 val = eeprom[MT_EE_COUNTRY_REGION_2GHZ];
+	int idx = -1;
+
+	dev_dbg(dev->mt76.dev, "REG 2GHZ %u REG 5GHZ %u\n", val, eeprom[MT_EE_COUNTRY_REGION_5GHZ]);
+	if (val < 8)
+		idx = val;
+	if (val > 31 && val < 33)
+		idx = val - 32 + 8;
+
+	if (idx != -1)
+		dev_info(dev->mt76.dev,
+			 "EEPROM country region %02hhx (channels %hhd-%hhd)\n",
+			 val, chan_bounds[idx].start,
+			 chan_bounds[idx].start + chan_bounds[idx].num - 1);
+	else
+		idx = 5; /* channels 1 - 14 */
+
+	dev->ee->reg = chan_bounds[idx];
+
+	/* TODO: country region 33 is special - phy should be set to B-mode
+	 *	 before entering channel 14 (see sta/connect.c)
+	 */
+}
+
+static void
+mt76x0_set_rf_freq_off(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	u8 comp;
+
+	dev->ee->rf_freq_off = field_validate(eeprom[MT_EE_FREQ_OFFSET]);
+	comp = field_validate(eeprom[MT_EE_FREQ_OFFSET_COMPENSATION]);
+
+	if (comp & BIT(7))
+		dev->ee->rf_freq_off -= comp & 0x7f;
+	else
+		dev->ee->rf_freq_off += comp;
+}
+
+static void
+mt76x0_set_lna_gain(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	s8 gain;
+
+	dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN_2GHZ];
+	dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN_5GHZ_0];
+
+	gain = eeprom[MT_EE_LNA_GAIN_5GHZ_1];
+	if (gain == 0xff || gain == 0)
+		dev->ee->lna_gain_5ghz[1] = dev->ee->lna_gain_5ghz[0];
+	else
+		dev->ee->lna_gain_5ghz[1] = gain;
+
+	gain = eeprom[MT_EE_LNA_GAIN_5GHZ_2];
+	if (gain == 0xff || gain == 0)
+		dev->ee->lna_gain_5ghz[2] = dev->ee->lna_gain_5ghz[0];
+	else
+		dev->ee->lna_gain_5ghz[2] = gain;
+}
+
+static void
+mt76x0_set_rssi_offset(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	int i;
+	s8 *rssi_offset = dev->ee->rssi_offset_2ghz;
+
+	for (i = 0; i < 2; i++) {
+		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET + i];
+
+		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
+			dev_warn(dev->mt76.dev,
+				 "Warning: EEPROM RSSI is invalid %02hhx\n",
+				 rssi_offset[i]);
+			rssi_offset[i] = 0;
+		}
+	}
+
+	rssi_offset = dev->ee->rssi_offset_5ghz;
+
+	for (i = 0; i < 3; i++) {
+		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_5GHZ + i];
+
+		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
+			dev_warn(dev->mt76.dev,
+				 "Warning: EEPROM RSSI is invalid %02hhx\n",
+				 rssi_offset[i]);
+			rssi_offset[i] = 0;
+		}
+	}
+}
+
+static u32
+calc_bw40_power_rate(u32 value, int delta)
+{
+	u32 ret = 0;
+	int i, tmp;
+
+	for (i = 0; i < 4; i++) {
+		tmp = s6_to_int((value >> i*8) & 0xff) + delta;
+		ret |= (u32)(int_to_s6(tmp)) << i*8;
+	}
+
+	return ret;
+}
+
+static s8
+get_delta(u8 val)
+{
+	s8 ret;
+
+	if (!field_valid(val) || !(val & BIT(7)))
+		return 0;
+
+	ret = val & 0x1f;
+	if (ret > 8)
+		ret = 8;
+	if (val & BIT(6))
+		ret = -ret;
+
+	return ret;
+}
+
+static void
+mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	s8 bw40_delta_2g, bw40_delta_5g;
+	u32 val;
+	int i;
+
+	bw40_delta_2g = get_delta(eeprom[MT_EE_TX_POWER_DELTA_BW40]);
+	bw40_delta_5g = get_delta(eeprom[MT_EE_TX_POWER_DELTA_BW40 + 1]);
+
+	for (i = 0; i < 5; i++) {
+		val = get_unaligned_le32(eeprom + MT_EE_TX_POWER_BYRATE(i));
+
+		/* Skip last 16 bits. */
+		if (i == 4)
+			val &= 0x0000ffff;
+
+		dev->ee->tx_pwr_cfg_2g[i][0] = val;
+		dev->ee->tx_pwr_cfg_2g[i][1] = calc_bw40_power_rate(val, bw40_delta_2g);
+	}
+
+	/* Reading per rate tx power for 5 GHz band is a bit more complex. Note
+	 * we mix 16 bit and 32 bit reads and sometimes do shifts.
+	 */
+	val = get_unaligned_le16(eeprom + 0x120);
+	val <<= 16;
+	dev->ee->tx_pwr_cfg_5g[0][0] = val;
+	dev->ee->tx_pwr_cfg_5g[0][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+
+	val = get_unaligned_le32(eeprom + 0x122);
+	dev->ee->tx_pwr_cfg_5g[1][0] = val;
+	dev->ee->tx_pwr_cfg_5g[1][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+
+	val = get_unaligned_le16(eeprom + 0x126);
+	dev->ee->tx_pwr_cfg_5g[2][0] = val;
+	dev->ee->tx_pwr_cfg_5g[2][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+
+	val = get_unaligned_le16(eeprom + 0xec);
+	val <<= 16;
+	dev->ee->tx_pwr_cfg_5g[3][0] = val;
+	dev->ee->tx_pwr_cfg_5g[3][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+
+	val = get_unaligned_le16(eeprom + 0xee);
+	dev->ee->tx_pwr_cfg_5g[4][0] = val;
+	dev->ee->tx_pwr_cfg_5g[4][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+}
+
+static void
+mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev, u8 *eeprom)
+{
+	int i;
+	u8 tx_pwr;
+
+	for (i = 0; i < 14; i++) {
+		tx_pwr = eeprom[MT_EE_TX_POWER_OFFSET_2GHZ + i];
+		if (tx_pwr <= 0x3f && tx_pwr > 0)
+			dev->ee->tx_pwr_per_chan[i] = tx_pwr;
+		else
+			dev->ee->tx_pwr_per_chan[i] = 5;
+	}
+
+	for (i = 0; i < 40; i++) {
+		tx_pwr = eeprom[MT_EE_TX_POWER_OFFSET_5GHZ + i];
+		if (tx_pwr <= 0x3f && tx_pwr > 0)
+			dev->ee->tx_pwr_per_chan[14 + i] = tx_pwr;
+		else
+			dev->ee->tx_pwr_per_chan[14 + i] = 5;
+	}
+
+	dev->ee->tx_pwr_per_chan[54] = dev->ee->tx_pwr_per_chan[22];
+	dev->ee->tx_pwr_per_chan[55] = dev->ee->tx_pwr_per_chan[28];
+	dev->ee->tx_pwr_per_chan[56] = dev->ee->tx_pwr_per_chan[34];
+	dev->ee->tx_pwr_per_chan[57] = dev->ee->tx_pwr_per_chan[44];
+}
+
+int
+mt76x0_eeprom_init(struct mt76x0_dev *dev)
+{
+	u8 *eeprom;
+	int i, ret;
+
+	ret = mt76x0_efuse_physical_size_check(dev);
+	if (ret)
+		return ret;
+
+	dev->ee = devm_kzalloc(dev->mt76.dev, sizeof(*dev->ee), GFP_KERNEL);
+	if (!dev->ee)
+		return -ENOMEM;
+
+	eeprom = kmalloc(MT76X0_EEPROM_SIZE, GFP_KERNEL);
+	if (!eeprom)
+		return -ENOMEM;
+
+	for (i = 0; i + 16 <= MT76X0_EEPROM_SIZE; i += 16) {
+		ret = mt76x0_efuse_read(dev, i, eeprom + i, MT_EE_READ);
+		if (ret)
+			goto out;
+	}
+
+	if (eeprom[MT_EE_VERSION_EE] > MT76X0U_EE_MAX_VER)
+		dev_warn(dev->mt76.dev,
+			 "Warning: unsupported EEPROM version %02hhx\n",
+			 eeprom[MT_EE_VERSION_EE]);
+	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
+		 eeprom[MT_EE_VERSION_EE], eeprom[MT_EE_VERSION_FAE]);
+
+	mt76x0_set_macaddr(dev, eeprom);
+	mt76x0_set_chip_cap(dev, eeprom);
+	mt76x0_set_country_reg(dev, eeprom);
+	mt76x0_set_rf_freq_off(dev, eeprom);
+	mt76x0_set_temp_offset(dev, eeprom);
+	mt76x0_set_lna_gain(dev, eeprom);
+	mt76x0_set_rssi_offset(dev, eeprom);
+	dev->chainmask = 0x0101;
+
+	mt76x0_set_tx_power_per_rate(dev, eeprom);
+	mt76x0_set_tx_power_per_chan(dev, eeprom);
+
+out:
+	kfree(eeprom);
+	return ret;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
new file mode 100644
index 000000000000..e37b573aed7b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -0,0 +1,149 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MT76X0U_EEPROM_H
+#define __MT76X0U_EEPROM_H
+
+struct mt76x0_dev;
+
+#define MT76X0U_EE_MAX_VER			0x0c
+#define MT76X0_EEPROM_SIZE			512
+
+#define MT76X0U_DEFAULT_TX_POWER		6
+
+enum mt76_eeprom_field {
+	MT_EE_CHIP_ID =				0x00,
+	MT_EE_VERSION_FAE =			0x02,
+	MT_EE_VERSION_EE =			0x03,
+	MT_EE_MAC_ADDR =			0x04,
+	MT_EE_NIC_CONF_0 =			0x34,
+	MT_EE_NIC_CONF_1 =			0x36,
+	MT_EE_COUNTRY_REGION_5GHZ =		0x38,
+	MT_EE_COUNTRY_REGION_2GHZ =		0x39,
+	MT_EE_FREQ_OFFSET =			0x3a,
+	MT_EE_NIC_CONF_2 =			0x42,
+
+	MT_EE_LNA_GAIN_2GHZ =			0x44,
+	MT_EE_LNA_GAIN_5GHZ_0 =			0x45,
+	MT_EE_RSSI_OFFSET =			0x46,
+	MT_EE_RSSI_OFFSET_5GHZ =		0x4a,
+	MT_EE_LNA_GAIN_5GHZ_1 =			0x49,
+	MT_EE_LNA_GAIN_5GHZ_2 =			0x4d,
+
+	MT_EE_TX_POWER_DELTA_BW40 =		0x50,
+
+	MT_EE_TX_POWER_OFFSET_2GHZ =		0x52,
+
+	MT_EE_TX_TSSI_SLOPE =			0x6e,
+	MT_EE_TX_TSSI_OFFSET_GROUP =		0x6f,
+	MT_EE_TX_TSSI_OFFSET =			0x76,
+
+	MT_EE_TX_POWER_OFFSET_5GHZ =		0x78,
+
+	MT_EE_TEMP_OFFSET =			0xd1,
+	MT_EE_FREQ_OFFSET_COMPENSATION =	0xdb,
+	MT_EE_TX_POWER_BYRATE_BASE =		0xde,
+
+	MT_EE_TX_POWER_BYRATE_BASE_5GHZ =	0x120,
+
+	MT_EE_USAGE_MAP_START =			0x1e0,
+	MT_EE_USAGE_MAP_END =			0x1fc,
+};
+
+#define MT_EE_NIC_CONF_0_RX_PATH		GENMASK(3, 0)
+#define MT_EE_NIC_CONF_0_TX_PATH		GENMASK(7, 4)
+#define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
+#define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
+
+#define MT_EE_NIC_CONF_1_HW_RF_CTRL		BIT(0)
+#define MT_EE_NIC_CONF_1_TEMP_TX_ALC		BIT(1)
+#define MT_EE_NIC_CONF_1_LNA_EXT_2G		BIT(2)
+#define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
+#define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
+
+#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
+#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
+#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
+#define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
+#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
+#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
+
+#define MT_EE_TX_POWER_BYRATE(i)		(MT_EE_TX_POWER_BYRATE_BASE + \
+						 (i) * 4)
+
+#define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END -	\
+						 MT_EE_USAGE_MAP_START + 1)
+
+enum mt76x0_eeprom_access_modes {
+	MT_EE_READ = 0,
+	MT_EE_PHYSICAL_READ = 1,
+};
+
+struct reg_channel_bounds {
+	u8 start;
+	u8 num;
+};
+
+struct mt76x0_eeprom_params {
+	u8 rf_freq_off;
+	s16 temp_off;
+	s8 rssi_offset_2ghz[2];
+	s8 rssi_offset_5ghz[3];
+	s8 lna_gain_2ghz;
+	s8 lna_gain_5ghz[3];
+	u8 pa_type;
+
+	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
+	u32 tx_pwr_cfg_2g[5][2];
+	u32 tx_pwr_cfg_5g[5][2];
+
+	u8 tx_pwr_per_chan[58];
+
+	struct reg_channel_bounds reg;
+
+	bool has_2ghz;
+	bool has_5ghz;
+};
+
+int mt76x0_eeprom_init(struct mt76x0_dev *dev);
+
+static inline u32 s6_validate(u32 reg)
+{
+	WARN_ON(reg & ~GENMASK(5, 0));
+	return reg & GENMASK(5, 0);
+}
+
+static inline int s6_to_int(u32 reg)
+{
+	int s6;
+
+	s6 = s6_validate(reg);
+	if (s6 & BIT(5))
+		s6 -= BIT(6);
+
+	return s6;
+}
+
+static inline u32 int_to_s6(int val)
+{
+	if (val < -0x20)
+		return 0x20;
+	if (val > 0x1f)
+		return 0x1f;
+
+	return val & 0x3f;
+}
+
+#endif
-- 
1.9.3
