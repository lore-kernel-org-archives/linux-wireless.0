Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYKOKkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 05:40:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1L1Ia0-0000Ou-EY
	for linux-wireless@vger.kernel.org; Sat, 15 Nov 2008 11:40:42 +0100
Subject: [RFC] add ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 11:40:36 +0100
Message-Id: <1226745636.4120.48.camel@johannes.berg> (sfid-20081115_114058_317000_BACFDBB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ar9170 driver for Atheros 802.11n
USB hardware ("otus"). The driver currently has basic
functionality, it will always transmit at 1 or 6 MBit
rates and only supports managed mode.

TODO:
 * rate control/tx status!
 * figure out QoS (does firmware parse QoS control to get AC?)
 * implement IBSS mode
 * implement hardware crypto
 * implement AP mode
 * implement mesh mode
 * make LEDs blink
 * HT

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Do we want such a basic driver?

 MAINTAINERS                          |    6 
 drivers/net/wireless/Kconfig         |    1 
 drivers/net/wireless/Makefile        |    1 
 drivers/net/wireless/ar9170/Kconfig  |    9 
 drivers/net/wireless/ar9170/Makefile |    5 
 drivers/net/wireless/ar9170/ar9170.h |  162 ++++
 drivers/net/wireless/ar9170/cmd.c    |  149 ++++
 drivers/net/wireless/ar9170/eeprom.h |  179 ++++
 drivers/net/wireless/ar9170/hw.h     |  338 +++++++++
 drivers/net/wireless/ar9170/mac.c    |  172 ++++
 drivers/net/wireless/ar9170/main.c   | 1285 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ar9170/phy.c    | 1223 +++++++++++++++++++++++++++++++++
 12 files changed, 3530 insertions(+)

--- everything.orig/drivers/net/wireless/Kconfig	2008-11-13 14:09:17.000000000 +0100
+++ everything/drivers/net/wireless/Kconfig	2008-11-13 14:11:00.000000000 +0100
@@ -720,5 +720,6 @@ source "drivers/net/wireless/b43/Kconfig
 source "drivers/net/wireless/b43legacy/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/ar9170/Kconfig"
 
 endmenu
--- everything.orig/drivers/net/wireless/Makefile	2008-11-13 14:09:17.000000000 +0100
+++ everything/drivers/net/wireless/Makefile	2008-11-15 03:10:05.000000000 +0100
@@ -54,5 +54,6 @@ obj-$(CONFIG_P54_COMMON)	+= p54/
 
 obj-$(CONFIG_ATH5K)	+= ath5k/
 obj-$(CONFIG_ATH9K)	+= ath9k/
+obj-$(CONFIG_AR9170)	+= ar9170/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/Kconfig	2008-11-12 16:36:49.000000000 +0100
@@ -0,0 +1,9 @@
+config AR9170
+	tristate "Atheros 11n USB (ar9170)"
+	depends on WLAN_80211 && MAC80211
+	help
+	  This is a mac80211-based driver for the Atheros "otus" 802.11n
+	  (2.4 and 5 GHz) USB devices.
+
+	  Say Y if you have the hardware, or M to build a module called
+	  ar9170.ko.
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/Makefile	2008-11-15 11:29:37.000000000 +0100
@@ -0,0 +1,5 @@
+ar9170-objs += main.o cmd.o mac.o phy.o
+
+obj-$(CONFIG_AR9170) += ar9170.o
+
+ccflags-y += -D__CHECK_ENDIAN__
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/main.c	2008-11-15 11:38:05.000000000 +0100
@@ -0,0 +1,1285 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * Hardware and mac80211 interaction code
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/firmware.h>
+#include <linux/etherdevice.h>
+#include <net/mac80211.h>
+#include "ar9170.h"
+#include "hw.h"
+
+MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Atheros 802.11n USB wireless");
+MODULE_FIRMWARE("ar9170-1.fw");
+MODULE_FIRMWARE("ar9170-2.fw");
+
+static struct usb_device_id ar9170_ids[] = {
+	/* Atheros 9170 */
+	{ USB_DEVICE(0x0CF3, 0x9170) },
+	/* D-Link DWA 160A */
+	{ USB_DEVICE(0x07D1, 0x3C10) },
+	/* ?? */
+	{ USB_DEVICE(0x0846, 0x9010) },
+
+	/* terminate */
+	{}
+};
+MODULE_DEVICE_TABLE(usb, ar9170_ids);
+
+#define RATE(_bitrate, _hw_rate, _txpidx, _flags) {	\
+	.bitrate	= (_bitrate),			\
+	.flags		= (_flags),			\
+	.hw_value	= (_hw_rate) | (_txpidx) << 4,	\
+}
+
+static struct ieee80211_rate __ar9170_ratetable[] = {
+	RATE(10, 0, 0, 0),
+	RATE(20, 1, 1, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(55, 2, 2, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(110, 3, 3, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATE(60, 0xb, 0, 0),
+	RATE(90, 0xf, 0, 0),
+	RATE(120, 0xa, 0, 0),
+	RATE(180, 0xe, 0, 0),
+	RATE(240, 0x9, 0, 0),
+	RATE(360, 0xd, 1, 0),
+	RATE(480, 0x8, 2, 0),
+	RATE(540, 0xc, 3, 0),
+};
+#undef RATE
+
+#define ar9170_g_ratetable	(__ar9170_ratetable + 0)
+#define ar9170_g_ratetable_size	12
+#define ar9170_a_ratetable	(__ar9170_ratetable + 4)
+#define ar9170_a_ratetable_size	8
+
+/*
+ * NB: The hw_value is used as an index into the ar9170_phy_freq_params
+ *     array in phy.c so that we don't have to do frequency lookups!
+ */
+#define CHAN(_freq, _idx) {		\
+	.center_freq	= (_freq),	\
+	.hw_value	= (_idx),	\
+	.max_power	= 30, /* XXX */	\
+}
+
+static struct ieee80211_channel ar9170_2ghz_chantable[] = {
+	CHAN(2412,  0),
+	CHAN(2417,  1),
+	CHAN(2422,  2),
+	CHAN(2427,  3),
+	CHAN(2432,  4),
+	CHAN(2437,  5),
+	CHAN(2442,  6),
+	CHAN(2447,  7),
+	CHAN(2452,  8),
+	CHAN(2457,  9),
+	CHAN(2462, 10),
+	CHAN(2467, 11),
+	CHAN(2472, 12),
+	CHAN(2484, 13),
+};
+
+static struct ieee80211_channel ar9170_5ghz_chantable[] = {
+	CHAN(4920, 14),
+	CHAN(4940, 15),
+	CHAN(4960, 16),
+	CHAN(4980, 17),
+	CHAN(5040, 18),
+	CHAN(5060, 19),
+	CHAN(5080, 20),
+	CHAN(5180, 21),
+	CHAN(5200, 22),
+	CHAN(5220, 23),
+	CHAN(5240, 24),
+	CHAN(5260, 25),
+	CHAN(5280, 26),
+	CHAN(5300, 27),
+	CHAN(5320, 28),
+	CHAN(5500, 29),
+	CHAN(5520, 30),
+	CHAN(5540, 31),
+	CHAN(5560, 32),
+	CHAN(5580, 33),
+	CHAN(5600, 34),
+	CHAN(5620, 35),
+	CHAN(5640, 36),
+	CHAN(5660, 37),
+	CHAN(5680, 38),
+	CHAN(5700, 39),
+	CHAN(5745, 40),
+	CHAN(5765, 41),
+	CHAN(5785, 42),
+	CHAN(5805, 43),
+	CHAN(5825, 44),
+	CHAN(5170, 45),
+	CHAN(5190, 46),
+	CHAN(5210, 47),
+	CHAN(5230, 48),
+};
+#undef CHAN
+
+static struct ieee80211_supported_band ar9170_band_2GHz = {
+	.channels	= ar9170_2ghz_chantable,
+	.n_channels	= ARRAY_SIZE(ar9170_2ghz_chantable),
+	.bitrates	= ar9170_g_ratetable,
+	.n_bitrates	= ar9170_g_ratetable_size,
+};
+
+static struct ieee80211_supported_band ar9170_band_5GHz = {
+	.channels	= ar9170_5ghz_chantable,
+	.n_channels	= ARRAY_SIZE(ar9170_5ghz_chantable),
+	.bitrates	= ar9170_a_ratetable,
+	.n_bitrates	= ar9170_a_ratetable_size,
+};
+
+
+static int ar9170_op_start(struct ieee80211_hw *hw)
+{
+	struct ar9170 *ar = hw->priv;
+	int err;
+
+	mutex_lock(&ar->mutex);
+
+	err = ar9170_init_mac(ar);
+	if (err)
+		goto out;
+
+	err = ar9170_init_phy(ar, IEEE80211_BAND_2GHZ);
+	if (err)
+		goto out;
+
+	err = ar9170_init_rf(ar);
+	if (err)
+		goto out;
+
+	/* start DMA */
+	err = ar9170_write_reg(ar, 0x1c3d30, 0x100);
+	if (err)
+		goto out;
+
+	ar->started = true;
+ out:
+	mutex_unlock(&ar->mutex);
+
+	return err;
+}
+
+static void ar9170_op_stop(struct ieee80211_hw *hw)
+{
+	struct ar9170 *ar = hw->priv;
+
+	mutex_lock(&ar->mutex);
+
+	/* stop DMA */
+	ar9170_write_reg(ar, 0x1c3d30, 0);
+
+	ar->started = false;
+
+	mutex_unlock(&ar->mutex);
+}
+
+static void tx_urb_complete(struct urb *urb)
+{
+	struct sk_buff *skb = (void *)urb->context;
+
+	/*
+	 * For proper rate control we really need to provide
+	 * TX status callbacks. For now, don't.
+	 */
+	usb_free_urb(urb);
+	dev_kfree_skb_irq(skb);
+}
+
+static int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ar9170 *ar = hw->priv;
+	struct urb *urb = NULL;
+	struct ieee80211_hdr *hdr;
+	struct ar9170_tx_control *txc;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_rate *rate = NULL;
+	u32 power, chains;
+	u16 len;
+
+	hdr = (void *)skb->data;
+	info = IEEE80211_SKB_CB(skb);
+	len = skb->len;
+	txc = (void *)skb_push(skb, sizeof(*txc));
+
+	/* Length */
+	txc->length = cpu_to_le16(len + 4);
+	txc->phy_control = 0;
+	txc->mac_control = cpu_to_le16(AR9170_TX_MAC_HW_DURATION) |
+			   cpu_to_le16(AR9170_TX_MAC_BACKOFF);
+
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_NO_ACK);
+
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_CTS);
+	else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_PROT_RTS);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_GREEN_FIELD)
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_GREENFIELD);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_SHORT_PREAMBLE);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_BW_40MHZ);
+	/* this works because 40 MHz is 2 and dup is 3 */
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_DUP_DATA)
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_BW_40MHZ_DUP);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_SHORT_GI);
+
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		u32 r = info->control.rates[0].idx;
+		u8 *txpower;
+		r <<= AR9170_TX_PHY_MCS_SHIFT;
+		if (WARN_ON(r & ~AR9170_TX_PHY_MCS_MASK))
+			goto free;
+		txc->phy_control |= cpu_to_le32(r & AR9170_TX_PHY_MCS_MASK);
+		txc->phy_control |= cpu_to_le32(AR9170_TX_PHY_MOD_HT);
+
+		if (info->control.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
+			if (info->band == IEEE80211_BAND_5GHZ)
+				txpower = ar->power_5G_ht40;
+			else
+				txpower = ar->power_2G_ht40;
+		} else {
+			if (info->band == IEEE80211_BAND_5GHZ)
+				txpower = ar->power_5G_ht20;
+			else
+				txpower = ar->power_2G_ht20;
+		}
+
+		power = txpower[info->control.rates[0].idx & 7];
+	} else {
+		u8 *txpower;
+		u32 mod;
+		u32 phyrate;
+		u8 idx = info->control.rates[0].idx;
+
+		if (info->band != IEEE80211_BAND_2GHZ) {
+			idx += 4;
+			txpower = ar->power_5G_leg;
+			mod = AR9170_TX_PHY_MOD_OFDM;
+		} else {
+			if (idx < 4) {
+				txpower = ar->power_2G_cck;
+				mod = AR9170_TX_PHY_MOD_CCK;
+			} else {
+				mod = AR9170_TX_PHY_MOD_OFDM;
+				txpower = ar->power_2G_ofdm;
+			}
+		}
+
+		rate = &__ar9170_ratetable[idx];
+
+		phyrate = rate->hw_value & 0xF;
+		power = txpower[(rate->hw_value & 0x30) >> 4];
+		phyrate <<= AR9170_TX_PHY_MCS_SHIFT;
+
+		txc->phy_control |= cpu_to_le32(mod);
+		txc->phy_control |= cpu_to_le32(phyrate);
+	}
+
+	power <<= AR9170_TX_PHY_TX_PWR_SHIFT;
+	power &= AR9170_TX_PHY_TX_PWR_MASK;
+	txc->phy_control |= cpu_to_le32(power);
+
+	/* set TX chains */
+	if (ar->eeprom.tx_mask == 1) {
+		chains = AR9170_TX_PHY_TXCHAIN_1;
+	} else {
+		chains = AR9170_TX_PHY_TXCHAIN_2;
+
+		/* >= 36M legacy OFDM - use only one chain */
+		if (rate && rate->bitrate >= 360)
+			chains = AR9170_TX_PHY_TXCHAIN_1;
+	}
+	txc->phy_control |= cpu_to_le32(chains << AR9170_TX_PHY_TXCHAIN_SHIFT);
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb)
+		goto free;
+
+	info->rate_driver_data[0] = ar;
+
+	usb_fill_bulk_urb(urb, ar->udev,
+			  usb_sndbulkpipe(ar->udev, AR9170_EP_TX),
+			  skb->data, skb->len, tx_urb_complete, skb);
+
+	if (usb_submit_urb(urb, GFP_ATOMIC))
+		goto free;
+
+	return NETDEV_TX_OK;
+ free:
+	usb_free_urb(urb);
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static int ar9170_set_mac_reg(struct ar9170 *ar, const u32 reg, const u8 *mac)
+{
+	static const u8 zero[ETH_ALEN] = { 0 };
+
+	if (!mac)
+		mac = zero;
+
+	ar9170_regwrite_begin(ar);
+
+	ar9170_regwrite(reg,
+			(mac[3] << 24) | (mac[2] << 16) |
+			(mac[1] << 8) | mac[0]);
+
+	ar9170_regwrite(reg + 4, (mac[5] << 8) | mac[4]);
+
+	ar9170_regwrite_finish();
+
+	return ar9170_regwrite_result();
+}
+
+static int ar9170_op_add_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_if_init_conf *conf)
+{
+	struct ar9170 *ar = hw->priv;
+	int err = 0;
+
+	mutex_lock(&ar->mutex);
+
+	if (ar->have_iface) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	ar->have_iface = true;
+
+	err = ar9170_set_mac_reg(ar, AR9170_MAC_REG_MAC_ADDR_L,
+				 conf->mac_addr);
+
+ unlock:
+	mutex_unlock(&ar->mutex);
+	return err;
+}
+
+static void ar9170_op_remove_interface(struct ieee80211_hw *hw,
+				       struct ieee80211_if_init_conf *conf)
+{
+	struct ar9170 *ar = hw->priv;
+
+	mutex_lock(&ar->mutex);
+	ar->have_iface = false;
+	ar9170_set_mac_reg(ar, AR9170_MAC_REG_MAC_ADDR_L, NULL);
+	mutex_unlock(&ar->mutex);
+}
+
+static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct ar9170 *ar = hw->priv;
+	int err = 0;
+
+	mutex_lock(&ar->mutex);
+
+	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
+		/* TODO */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
+		/* TODO */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		/* TODO */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		/* TODO */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		err = ar9170_set_channel(ar, hw->conf.channel,
+					 AR9170_RFI_NONE, AR9170_BW_20);
+		if (err)
+			goto out;
+		/* adjust slot time for 5 GHz */
+		if (hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+			err = ar9170_write_reg(ar, AR9170_MAC_REG_SLOT_TIME,
+					       9 << 10);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
+		/* TODO */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_HT) {
+		/* TODO */
+	}
+
+ out:
+	mutex_unlock(&ar->mutex);
+
+	return err;
+}
+
+static int ar9170_op_config_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_if_conf *conf)
+{
+	struct ar9170 *ar = hw->priv;
+	int err = 0;
+
+	mutex_lock(&ar->mutex);
+
+	if (conf->changed & IEEE80211_IFCC_BSSID)
+		err = ar9170_set_mac_reg(ar, AR9170_MAC_REG_BSSID_L,
+					 conf->bssid);
+
+	/* XXX: beacon? */
+
+	mutex_unlock(&ar->mutex);
+
+	return err;
+}
+
+static void ar9170_set_filters(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170,
+					 filter_config_work);
+	int err;
+
+	mutex_lock(&ar->mutex);
+
+	ar9170_regwrite_begin(ar);
+
+	if (ar->cur_mc_hash != ar->want_mc_hash) {
+		ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_H, ar->want_mc_hash >> 32);
+		ar9170_regwrite(AR9170_MAC_REG_GROUP_HASH_TBL_L, ar->want_mc_hash);
+	}
+
+	if (ar->cur_filter != ar->want_filter)
+		ar9170_regwrite(AR9170_MAC_REG_FRAMETYPE_FILTER,
+				ar->want_filter);
+
+	ar9170_regwrite_finish();
+	err = ar9170_regwrite_result();
+	if (err)
+		goto out;
+
+	ar->cur_mc_hash = ar->want_mc_hash;
+	ar->cur_filter = ar->want_filter;
+ out:
+	mutex_unlock(&ar->mutex);
+}
+
+static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed_flags,
+				       unsigned int *new_flags,
+				       int mc_count, struct dev_mc_list *mclist)
+{
+	struct ar9170 *ar = hw->priv;
+	u64 mchash;
+	u32 filter;
+	int i;
+
+	/* mask supported flags */
+	*new_flags &= FIF_ALLMULTI | FIF_CONTROL | FIF_BCN_PRBRESP_PROMISC;
+
+	/*
+	 * We can support more by setting the sniffer bit and
+	 * then checking the error flags, later.
+	 */
+
+	if (*new_flags & FIF_ALLMULTI) {
+		mchash = ~0ULL;
+	} else {
+		/* always get broadcast frames */
+		mchash = 1ULL << (0xff>>2);
+
+		for (i = 0; i < mc_count; i++) {
+			if (WARN_ON(!mclist))
+				break;
+			mchash |= 1ULL << (mclist->dmi_addr[5] >> 2);
+			mclist = mclist->next;
+		}
+	}
+
+	filter = AR9170_MAC_REG_FTF_DEFAULTS;
+	if (*new_flags & FIF_CONTROL)
+		filter |= AR9170_MAC_REG_FTF_PSPOLL |
+			  AR9170_MAC_REG_FTF_RTS |
+			  AR9170_MAC_REG_FTF_CTS |
+			  AR9170_MAC_REG_FTF_ACK |
+			  AR9170_MAC_REG_FTF_CFE |
+			  AR9170_MAC_REG_FTF_CFE_ACK;
+	ar->want_filter = filter;
+	ar->want_mc_hash = mchash;
+	queue_work(ar->hw->workqueue, &ar->filter_config_work);
+}
+
+static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changed)
+{
+	struct ar9170 *ar = hw->priv;
+	int err = 0;
+
+	mutex_lock(&ar->mutex);
+
+	ar9170_regwrite_begin(ar);
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		/* TODO */
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		u32 slottime = 20;
+		if (bss_conf->use_short_slot)
+			slottime = 9;
+		ar9170_regwrite(AR9170_MAC_REG_SLOT_TIME, slottime << 10);
+	}
+
+	if (changed & BSS_CHANGED_HT) {
+		/* TODO */
+	}
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		u32 cck, ofdm;
+
+		if (hw->conf.channel->band == IEEE80211_BAND_5GHZ) {
+			ofdm = bss_conf->basic_rates;
+			cck = 0;
+		} else {
+			/* four cck rates */
+			cck = bss_conf->basic_rates & 0xf;
+			ofdm = bss_conf->basic_rates >> 4;
+		}
+		ar9170_regwrite(AR9170_MAC_REG_BASIC_RATE,
+				ofdm << 8 | cck);
+	}
+
+	ar9170_regwrite_finish();
+	err = ar9170_regwrite_result();
+
+	mutex_unlock(&ar->mutex);
+
+	WARN_ON(err);
+}
+
+static const struct ieee80211_ops ar9170_ops = {
+	.start			= ar9170_op_start,
+	.stop			= ar9170_op_stop,
+	.tx			= ar9170_op_tx,
+	.add_interface		= ar9170_op_add_interface,
+	.remove_interface	= ar9170_op_remove_interface,
+	.config			= ar9170_op_config,
+	.config_interface	= ar9170_op_config_interface,
+	.configure_filter	= ar9170_op_configure_filter,
+	.bss_info_changed	= ar9170_op_bss_info_changed,
+};
+
+static struct ar9170 *ar9170_alloc(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw;
+	struct ar9170 *ar;
+
+	hw = ieee80211_alloc_hw(sizeof(struct ar9170), &ar9170_ops);
+	if (!hw)
+		return ERR_PTR(-ENOMEM);
+
+	ar = hw->priv;
+	ar->hw = hw;
+	ar->udev = interface_to_usbdev(intf);
+	mutex_init(&ar->mutex);
+	spin_lock_init(&ar->cmdlock);
+	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
+
+	/* all hw supports 2.4 GHz, so set channel to 1 by default */
+	ar->channel = &ar9170_2ghz_chantable[0];
+
+	return ar;
+}
+
+static int ar9170_read_eeprom(struct usb_interface *intf, struct ar9170 *ar)
+{
+#define RW	8	/* number of words to read at once */
+#define RB	(sizeof(u32)  *RW)
+	DECLARE_MAC_BUF(mbuf);
+	u8 *eeprom = (void *)&ar->eeprom;
+	u8 *addr = ar->eeprom.mac_address;
+	__le32 offsets[RW];
+	int i, j, err, bands = 0;
+
+	BUILD_BUG_ON(sizeof(ar->eeprom) & 3);
+
+	BUILD_BUG_ON(RB > AR9170_MAX_CMD_LEN - 4);
+#ifndef __CHECKER__
+	/* don't want to handle trailing remains */
+	BUILD_BUG_ON(sizeof(ar->eeprom) % RB);
+#endif
+
+	for (i = 0; i < sizeof(ar->eeprom)/RB; i++) {
+		for (j = 0; j < RW; j++)
+			offsets[j] = cpu_to_le32(AR9170_EEPROM_START +
+						 RB * i + 4 * j);
+
+		err = ar9170_exec_cmd(ar, AR9170_CMD_RREG,
+				      RB, (u8 *) &offsets,
+				      RB, eeprom + RB * i);
+		if (err)
+			return err;
+	}
+
+#undef RW
+#undef RB
+
+	if (ar->eeprom.length == cpu_to_le16(0xFFFF))
+		return -ENODATA;
+
+	if (ar->eeprom.operating_flags & AR9170_OPFLAG_2GHZ) {
+		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &ar9170_band_2GHz;
+		bands++;
+	}
+	if (ar->eeprom.operating_flags & AR9170_OPFLAG_5GHZ) {
+		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &ar9170_band_5GHz;
+		bands++;
+	}
+	/*
+	 * I measured this, a bandswitch takes roughly
+	 * 135 ms and a frequency switch about 80.
+	 *
+	 * FIXME: measure these values again once EEPROM settings
+	 *	  are used, that will influence them!
+	 */
+	if (bands == 2)
+		ar->hw->channel_change_time = 135 * 1000;
+	else
+		ar->hw->channel_change_time = 80 * 1000;
+
+	/* second part of wiphy init */
+	SET_IEEE80211_PERM_ADDR(ar->hw, addr);
+
+	return 0;
+}
+
+static void ar9170_irq_completed(struct urb *urb)
+{
+	struct ar9170 *ar = urb->context;
+
+	print_hex_dump(KERN_DEBUG, "ar9170 irq: ", DUMP_PREFIX_OFFSET,
+		       16, 1, ar->ibuf, urb->actual_length, true);
+	usb_submit_urb(urb, GFP_KERNEL);
+}
+
+static int ar9170_irq_urb(struct usb_interface *intf,
+			  struct ar9170 *ar)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct urb *u;
+	int err;
+
+	if (WARN_ON(ar->iurb))
+		return -EBUSY;
+
+	u = usb_alloc_urb(0, GFP_KERNEL);
+
+	if (!u)
+		return -ENOMEM;
+
+	usb_fill_int_urb(u, udev, usb_rcvintpipe(udev, AR9170_EP_IRQ),
+			 ar->ibuf, sizeof(ar->ibuf), ar9170_irq_completed,
+			 ar, 4);
+
+	err = usb_submit_urb(u, GFP_KERNEL);
+	if (err) {
+		usb_free_urb(u);
+		return err;
+	}
+
+	ar->iurb = u;
+
+	return 0;
+}
+
+static void ar9170_cancel_irq_urb(struct ar9170 *ar)
+{
+	if (!ar->iurb)
+		return;
+
+	usb_kill_urb(ar->iurb);
+	usb_free_urb(ar->iurb);
+	ar->iurb = NULL;
+}
+
+static void ar9170_rx_completed(struct urb *urb);
+
+static int ar9170_prep_rx_urb(struct ar9170 *ar, struct urb *u, gfp_t gfp)
+{
+	struct sk_buff *skb;
+
+	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE + 32, gfp);
+	if (!skb)
+		return -ENOMEM;
+
+	/* reserve some space for mac80211's radiotap */
+	skb_reserve(skb, 32);
+
+	((void **)skb->cb)[0] = ar;
+
+	usb_fill_bulk_urb(u, ar->udev, usb_rcvbulkpipe(ar->udev, AR9170_EP_RX),
+			  skb->data, min(skb_tailroom(skb), 8192),
+			  ar9170_rx_completed, skb);
+
+	return 0;
+}
+
+static void ar9170_handle_command_response(struct ar9170 *ar, u8 *buf, int len)
+{
+	u8 type;
+	u32 in, out;
+
+	type = buf[1];
+
+	if ((type & 0xc0) != 0xc0) {
+		in = le32_to_cpup((__le32 *)buf);
+		out = le32_to_cpu(ar->cmdbuf[0]);
+
+		/* mask off length byte */
+		out &= ~0xFF;
+
+		if (ar->readlen >= 0) {
+			/* add expected length */
+			out |= ar->readlen;
+		} else {
+			/* add obtained length */
+			out |= in & 0xFF;
+		}
+
+		if (unlikely(out != in)) {
+			print_hex_dump(KERN_DEBUG, "ar9170 invalid resp: ",
+				       DUMP_PREFIX_OFFSET,
+				       16, 1, buf, len, true);
+			/*
+			 * Do not complete, then the command times out,
+			 * and we get a stack trace from there.
+			 */
+			return;
+		}
+
+		spin_lock(&ar->cmdlock);
+
+		if (ar->readbuf && ar->readlen > 0) {
+			memcpy(ar->readbuf, buf + 4, ar->readlen);
+			ar->readbuf = NULL;
+		}
+
+		complete(&ar->cmd_wait);
+		spin_unlock(&ar->cmdlock);
+	} else switch (type) {
+	case 0xc1:
+		/*
+		 * TX status notification:
+		 * bytes: 0c c1 .. .. M1 M2 M3 M4 M5 M6 R4 R3 R2 R1 S2 S1
+		 *
+		 * M1-M6 is the MAC address
+		 * R1-R4 is the transmit rate
+		 * S1-S2 is the transmit status
+		 *
+		 * ignored for now.
+		 */
+		break;
+	default:
+		/* all others also ignored for now */
+		break;
+	}
+}
+
+/*
+ * If the frame alignment is right (or the kernel has
+ * CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS), and there
+ * is only a single MPDU in the USB frame, then we can
+ * submit to mac80211 the SKB directly. However, since
+ * there may be multiple packets in one SKB in stream
+ * mode, and we need to observe the proper ordering,
+ * this is non-trivial.
+ */
+static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
+{
+	struct sk_buff *skb;
+	struct ar9170_rx_head *head = (void *)buf;
+	struct ar9170_rx_tail *tail;
+	struct ieee80211_rx_status status;
+	int mpdu_len, i;
+	u8 error, antennas = 0;
+
+	/* Received MPDU */
+	mpdu_len = len;
+	mpdu_len -= sizeof(struct ar9170_rx_head);
+	mpdu_len -= sizeof(struct ar9170_rx_tail);
+	BUILD_BUG_ON(sizeof(struct ar9170_rx_head) != 12);
+	BUILD_BUG_ON(sizeof(struct ar9170_rx_tail) != 24);
+
+	if (mpdu_len <= FCS_LEN)
+		return;
+
+	tail = (void *)(buf + sizeof(struct ar9170_rx_head) + mpdu_len);
+
+	for (i = 0; i < 3; i++)
+		if (tail->rssi[i] != 0x80)
+			antennas |= BIT(i);
+
+	/* post-process RSSI */
+	for (i = 0; i < 7; i++)
+		if (tail->rssi[i] & 0x80)
+			tail->rssi[i] = ((tail->rssi[i] & 0x7f) + 1) & 0x7f;
+
+	memset(&status, 0, sizeof(status));
+
+	status.band = ar->channel->band;
+	status.freq = ar->channel->center_freq;
+	status.signal = tail->rssi_combined;
+	status.antenna = antennas;
+
+	switch (tail->status & AR9170_RX_STATUS_MODULATION_MASK) {
+	case AR9170_RX_STATUS_MODULATION_CCK:
+		if (tail->status & AR9170_RX_STATUS_SHORT_PREAMBLE)
+			status.flag |= RX_FLAG_SHORTPRE;
+		switch (head->plcp[0]) {
+		case 0x0a:
+			status.rate_idx = 0;
+			break;
+		case 0x14:
+			status.rate_idx = 1;
+			break;
+		case 0x37:
+			status.rate_idx = 2;
+			break;
+		case 0x6e:
+			status.rate_idx = 3;
+			break;
+		default:
+			return;
+		}
+		break;
+	case AR9170_RX_STATUS_MODULATION_OFDM:
+		switch (head->plcp[0] & 0xF) {
+		case 0xB:
+			status.rate_idx = 0;
+			break;
+		case 0xF:
+			status.rate_idx = 1;
+			break;
+		case 0xA:
+			status.rate_idx = 2;
+			break;
+		case 0xE:
+			status.rate_idx = 3;
+			break;
+		case 0x9:
+			status.rate_idx = 4;
+			break;
+		case 0xD:
+			status.rate_idx = 5;
+			break;
+		case 0x8:
+			status.rate_idx = 6;
+			break;
+		case 0xC:
+			status.rate_idx = 7;
+			break;
+		default:
+			return;
+		}
+		if (status.band == IEEE80211_BAND_2GHZ)
+			status.rate_idx += 4;
+		break;
+	case AR9170_RX_STATUS_MODULATION_HT:
+	case AR9170_RX_STATUS_MODULATION_DUPOFDM:
+		/* XXX */
+		return;
+	}
+
+	error = tail->error;
+
+	if (error & AR9170_RX_ERROR_MMIC) {
+		status.flag |= RX_FLAG_MMIC_ERROR;
+		error &= ~AR9170_RX_ERROR_MMIC;
+	}
+
+	if (error & AR9170_RX_ERROR_PLCP) {
+		status.flag |= RX_FLAG_FAILED_PLCP_CRC;
+		error &= ~AR9170_RX_ERROR_PLCP;
+	}
+
+	if (error & AR9170_RX_ERROR_FCS) {
+		status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		error &= ~AR9170_RX_ERROR_FCS;
+	}
+
+	/* ignore wrong RA errors */
+	error &= ~AR9170_RX_ERROR_WRONG_RA;
+
+	/* drop any other error frames */
+	if (error)
+		return;
+
+	skb = dev_alloc_skb(mpdu_len + 32);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, 32);
+	memcpy(skb_put(skb, mpdu_len),
+	       buf + sizeof(struct ar9170_rx_head),
+	       mpdu_len);
+
+	ieee80211_rx_irqsafe(ar->hw, skb, &status);
+}
+
+static void ar9170_rx_completed(struct urb *urb)
+{
+	struct sk_buff *skb = urb->context;
+	struct ar9170 *ar = ((void **)skb->cb)[0];
+	int i, tlen = urb->actual_length, resplen;
+	u8 *tbuf = skb->data, *respbuf;
+
+	/* device died */
+	if (urb->status == -EOVERFLOW) {
+		printk(KERN_DEBUG "complete rx %p (%db, %d)\n", urb, tlen, urb->status);
+		return;
+	}
+
+	if (urb->status)
+		goto resubmit;
+
+	while (tlen >= 4) {
+		int clen = tbuf[1] << 8 | tbuf[0];
+		int wlen = (clen + 3) & ~3;
+
+		/*
+		 * parse stream (if any)
+		 */
+		if (tbuf[2] != 0 || tbuf[3] != 0x4e) {
+			printk(KERN_ERR "ar9170: missing tag!\n");
+			goto resubmit;
+		}
+		if (wlen > tlen - 4) {
+			printk(KERN_ERR "ar9170: invalid RX (%d, %d, %d)\n",
+			       clen, wlen, tlen);
+			print_hex_dump(KERN_DEBUG, "data: ",
+				       DUMP_PREFIX_OFFSET,
+				       16, 1, tbuf, tlen, true);
+			goto resubmit;
+		}
+		resplen = clen;
+		respbuf = tbuf + 4;
+		tbuf += wlen + 4;
+		tlen -= wlen + 4;
+
+		i = 0;
+
+		/* weird thing, but this is the same in the original driver */
+		while (resplen > 2 && i < 12 &&
+		       respbuf[0] == 0xff && respbuf[1] == 0xff) {
+			i += 2;
+			resplen -= 2;
+			respbuf += 2;
+		}
+
+		if (resplen < 4)
+			continue;
+
+		/* found the 6 * 0xffff marker? */
+		if (i == 12)
+			ar9170_handle_command_response(ar, respbuf, resplen);
+		else
+			ar9170_handle_mpdu(ar, respbuf, resplen);
+	}
+
+	if (tlen)
+		printk(KERN_ERR "ar9170: buffer remains!\n");
+
+ resubmit:
+	usb_submit_urb(urb, GFP_KERNEL);
+}
+
+static int ar9170_rx_urbs(struct usb_interface *intf, struct ar9170 *ar)
+{
+	struct urb *u;
+	int err, i;
+
+	if (WARN_ON(ar->rxurbs[0]))
+		return -EBUSY;
+
+	for (i = 0; i < AR9170_NUM_RX_URBS; i++) {
+		u = usb_alloc_urb(0, GFP_KERNEL);
+		if (!u)
+			goto nomem;
+
+		err = ar9170_prep_rx_urb(ar, u, GFP_KERNEL);
+		if (err)
+			goto nomem;
+
+		err = usb_submit_urb(u, GFP_KERNEL);
+		if (err)
+			printk(KERN_ERR "ar9170: submit RX urb failed\n");
+
+		ar->rxurbs[i] = u;
+	}
+
+	return 0;
+ nomem:
+	for (i = 0; i < AR9170_NUM_RX_URBS; i++) {
+		u = ar->rxurbs[i];
+		if (!u)
+			continue;
+
+		dev_kfree_skb(u->context);
+		usb_free_urb(u);
+		ar->rxurbs[i] = NULL;
+	}
+
+	return -ENOMEM;
+}
+
+static void ar9170_cancel_rx_urbs(struct ar9170 *ar)
+{
+	struct urb *u;
+	int i;
+
+	for (i = 0; i < AR9170_NUM_RX_URBS; i++) {
+		u = ar->rxurbs[i];
+		if (!u)
+			continue;
+
+		usb_kill_urb(u);
+		dev_kfree_skb(u->context);
+		usb_free_urb(u);
+		ar->rxurbs[i] = NULL;
+	}
+}
+
+static int ar9170_load_fw(struct ar9170 *ar, const struct firmware *fw,
+			  u32 addr, bool complete)
+{
+	size_t sz = fw->size;
+	int transfer, err;
+	char *buf = kmalloc(4096, GFP_KERNEL);
+	const char *data = fw->data;
+
+	if (!buf)
+		return -ENOMEM;
+
+	while (sz) {
+		transfer = min_t(int, sz, 4096);
+		memcpy(buf, data, transfer);
+		err = usb_control_msg(ar->udev,
+				      usb_sndctrlpipe(ar->udev, 0),
+				      0x30 /* FW DL */, 0x40 | USB_DIR_OUT,
+				      addr >> 8, 0, buf, transfer, 1000);
+		if (err >= 0 && err != transfer)
+			err = -EMSGSIZE;
+		if (err < 0)
+			return err;
+		sz -= transfer;
+		data += transfer;
+		addr += transfer;
+	}
+
+	if (complete) {
+		err = usb_control_msg(ar->udev,
+				      usb_sndctrlpipe(ar->udev, 0),
+				      0x31 /* FW DL COMPLETE */,
+				      0x40 | USB_DIR_OUT,
+				      0, 0, NULL, 0, 1000);
+		if (err)
+			return err;
+	}
+
+	kfree(buf);
+
+	return 0;
+}
+
+static int ar9170_upload_firmware(struct ar9170 *ar)
+{
+	const struct firmware *fw;
+	int err;
+
+	err = request_firmware(&fw, "ar9170-1.fw", &ar->udev->dev);
+	if (err) {
+		printk(KERN_DEBUG "ar9170: firmware part 1 not found\n");
+		return err;
+	}
+
+	err = ar9170_load_fw(ar, fw, 0x102800, false);
+	if (err) {
+		printk(KERN_DEBUG "ar9170: firmware part 1 upload failed\n");
+		return err;
+	}
+
+	release_firmware(fw);
+
+	/* let it settle */
+	msleep(1000);
+
+	err = request_firmware(&fw, "ar9170-2.fw", &ar->udev->dev);
+	if (err) {
+		printk(KERN_DEBUG "ar9170: firmware part 2 not found\n");
+		return err;
+	}
+
+	err = ar9170_load_fw(ar, fw, 0x200000, true);
+	if (err) {
+		printk(KERN_DEBUG "ar9170: firmware part 2 upload failed\n");
+		return err;
+	}
+
+	release_firmware(fw);
+
+	return 0;
+}
+
+static int ar9170_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct ar9170 *ar;
+	int err;
+
+	ar = ar9170_alloc(intf);
+	if (IS_ERR(ar)) {
+		err = PTR_ERR(ar);
+		goto out;
+	}
+
+	/* first part of wiphy init */
+	SET_IEEE80211_DEV(ar->hw, &udev->dev);
+	ar->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					 BIT(NL80211_IFTYPE_WDS);
+	ar->hw->flags |= IEEE80211_HW_RX_INCLUDES_FCS;
+	ar->hw->extra_tx_headroom = 8;
+
+	usb_set_intfdata(intf, ar);
+
+	mutex_lock(&ar->mutex);
+
+	err = ar9170_rx_urbs(intf, ar);
+	if (err)
+		goto err_unlock;
+
+	err = ar9170_irq_urb(intf, ar);
+	if (err)
+		goto err_unrx;
+
+	err = ar9170_upload_firmware(ar);
+	if (err)
+		goto err_unirq;
+
+	/* disable LEDs */
+	/* GPIO 0/1 mode: output, 2/3: input */
+	ar9170_write_reg(ar, AR9170_GPIO_REG_PORT_TYPE, 3);
+	/* GPIO 0/1 value: off */
+	ar9170_write_reg(ar, AR9170_GPIO_REG_DATA, 0);
+
+	/* try to read EEPROM, init MAC addr */
+	err = ar9170_read_eeprom(intf, ar);
+	if (err)
+		goto err_unirq;
+
+	mutex_unlock(&ar->mutex);
+
+	ieee80211_register_hw(ar->hw);
+
+	return 0;
+ err_unirq:
+	ar9170_cancel_irq_urb(ar);
+ err_unrx:
+	ar9170_cancel_rx_urbs(ar);
+ err_unlock:
+	mutex_unlock(&ar->mutex);
+	mutex_destroy(&ar->mutex);
+	ieee80211_free_hw(ar->hw);
+ out:
+	return err;
+}
+
+static void ar9170_disconnect(struct usb_interface *intf)
+{
+	struct ar9170 *ar = usb_get_intfdata(intf);
+
+	ieee80211_unregister_hw(ar->hw);
+
+	mutex_lock(&ar->mutex);
+
+	ar9170_cancel_irq_urb(ar);
+	ar9170_cancel_rx_urbs(ar);
+
+	mutex_unlock(&ar->mutex);
+
+	mutex_destroy(&ar->mutex);
+	ieee80211_free_hw(ar->hw);
+}
+
+static struct usb_driver ar9170_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = ar9170_probe,
+	.disconnect = ar9170_disconnect,
+	.id_table = ar9170_ids,
+};
+
+static int __init ar9170_init(void)
+{
+	return usb_register(&ar9170_driver);
+}
+
+static void __exit ar9170_exit(void)
+{
+	usb_deregister(&ar9170_driver);
+}
+
+module_init(ar9170_init);
+module_exit(ar9170_exit);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/ar9170.h	2008-11-15 11:30:25.000000000 +0100
@@ -0,0 +1,162 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * Driver specific definitions
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __AR9170_H
+#define __AR9170_H
+
+#include <linux/usb.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+#include <net/wireless.h>
+#include <net/mac80211.h>
+#include "eeprom.h"
+#include "hw.h"
+
+
+#define PAYLOAD_MAX	(AR9170_MAX_CMD_LEN/4 - 1)
+
+enum ar9170_bw {
+	AR9170_BW_20,
+	AR9170_BW_40_BELOW,
+	AR9170_BW_40_ABOVE,
+
+	__AR9170_NUM_BW,
+};
+
+enum ar9170_rf_init_mode {
+	AR9170_RFI_NONE,
+	AR9170_RFI_WARM,
+	AR9170_RFI_COLD,
+};
+
+#define AR9170_MAX_RX_BUFFER_SIZE		8192
+#define AR9170_NUM_RX_URBS			16
+
+struct ar9170 {
+	struct ieee80211_hw *hw;
+	struct usb_device *udev;
+	struct mutex mutex;
+	bool have_iface, started;
+
+	u64 usedkeys;
+
+	struct work_struct filter_config_work;
+	u64 cur_mc_hash, want_mc_hash;
+	u32 cur_filter, want_filter;
+	struct ieee80211_channel *channel;
+
+	spinlock_t cmdlock;
+	struct completion cmd_wait;
+	int readlen;
+	u8 *readbuf;
+
+	/* power calibration data */
+	u8 power_5G_leg[4];
+	u8 power_2G_cck[4];
+	u8 power_2G_ofdm[4];
+	u8 power_5G_ht20[8];
+	u8 power_5G_ht40[8];
+	u8 power_2G_ht20[8];
+	u8 power_2G_ht40[8];
+
+	struct urb *iurb;
+	u8 ibuf[64];
+
+	struct urb *rxurbs[AR9170_NUM_RX_URBS];
+
+	__le32 cmdbuf[PAYLOAD_MAX + 1];
+
+	struct ar9170_eeprom eeprom;
+};
+
+/* basic HW access */
+int ar9170_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
+		    int plen, u8 *payload, int outlen, u8 *out);
+int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val);
+int ar9170_read_reg(struct ar9170 *ar, u32 reg, u32 *val);
+int ar9170_echo_test(struct ar9170 *ar, u32 v);
+
+/*
+ * Macros to facilitate writing multiple registers in a single
+ * write-combining USB command. Note that when the first group
+ * fails the whole thing will fail without any others attempted,
+ * but you won't know which write in the group failed.
+ */
+#define ar9170_regwrite_begin(ar)					\
+{									\
+	int __nreg = 0, __err = 0;					\
+	struct ar9170 *__ar = ar;
+
+#define ar9170_regwrite(r, v) do {					\
+	__ar->cmdbuf[2 * __nreg + 1] = cpu_to_le32(r);			\
+	__ar->cmdbuf[2 * __nreg + 2] = cpu_to_le32(v);			\
+	__nreg++;							\
+	if (__nreg >= PAYLOAD_MAX/2) {					\
+		__err = ar9170_exec_cmd(__ar, AR9170_CMD_WREG,		\
+					8 * __nreg, 			\
+					(u8 *) &__ar->cmdbuf[1],	\
+					0, NULL);			\
+		__nreg = 0;						\
+		if (__err)						\
+			goto __regwrite_out;				\
+	}								\
+} while (0)
+
+#define ar9170_regwrite_finish()					\
+__regwrite_out:								\
+	if (__nreg) {							\
+		__err = ar9170_exec_cmd(__ar, AR9170_CMD_WREG,		\
+					8 * __nreg, 			\
+					(u8 *) &__ar->cmdbuf[1],	\
+					0, NULL);			\
+		__nreg = 0;						\
+	}
+
+#define ar9170_regwrite_result()					\
+	__err;								\
+}
+
+/* MAC */
+int ar9170_init_mac(struct ar9170 *ar);
+
+/* PHY / RF */
+int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band);
+int ar9170_init_rf(struct ar9170 *ar);
+int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
+		       enum ar9170_rf_init_mode rfi, enum ar9170_bw bw);
+
+#endif /* __AR9170_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/hw.h	2008-11-14 02:48:37.000000000 +0100
@@ -0,0 +1,338 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * Hardware-specific definitions
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __AR9170_HW_H
+#define __AR9170_HW_H
+
+#define AR9170_MAX_CMD_LEN	64
+
+enum ar9170_cmd {
+	AR9170_CMD_RREG		= 0x00,
+	AR9170_CMD_WREG		= 0x01,
+	AR9170_CMD_RMEM		= 0x02,
+	AR9170_CMD_WMEM		= 0x03,
+	AR9170_CMD_BITAND	= 0x04,
+	AR9170_CMD_BITOR	= 0x05,
+	AR9170_CMD_EKEY		= 0x28,
+	AR9170_CMD_DKEY		= 0x29,
+	AR9170_CMD_FREQUENCY	= 0x30,
+	AR9170_CMD_RF_INIT	= 0x31,
+	AR9170_CMD_SYNTH	= 0x32,
+	AR9170_CMD_FREQ_START	= 0x33,
+	AR9170_CMD_ECHO		= 0x80,
+	AR9170_CMD_TALLY	= 0x81,
+	AR9170_CMD_TALLY_APD	= 0x82,
+	AR9170_CMD_CONFIG	= 0x83,
+	AR9170_CMD_RESET	= 0x90,
+	AR9170_CMD_DKRESET	= 0x91,
+	AR9170_CMD_DKTX_STATUS	= 0x92,
+	AR9170_CMD_FDC		= 0xA0,
+	AR9170_CMD_WREEPROM	= 0xB0,
+	AR9170_CMD_WFLASH	= 0xB0,
+	AR9170_CMD_FLASH_ERASE	= 0xB1,
+	AR9170_CMD_FLASH_PROG	= 0xB2,
+	AR9170_CMD_FLASH_CHKSUM	= 0xB3,
+	AR9170_CMD_FLASH_READ	= 0xB4,
+	AR9170_CMD_FW_DL_INIT	= 0xB5,
+	AR9170_CMD_MEM_WREEPROM	= 0xBB,
+};
+
+/* endpoints */
+#define AR9170_EP_TX				1
+#define AR9170_EP_RX				2
+#define AR9170_EP_IRQ				3
+#define AR9170_EP_CMD				4
+
+#define AR9170_EEPROM_START			0x1600
+
+#define AR9170_GPIO_REG_BASE			0x1d0100
+#define AR9170_GPIO_REG_PORT_TYPE		AR9170_GPIO_REG_BASE
+#define AR9170_GPIO_REG_DATA			(AR9170_GPIO_REG_BASE + 4)
+
+#define AR9170_USB_REG_BASE			0x1e1000
+#define AR9170_USB_REG_DMA_CTL			(AR9170_USB_REG_BASE + 0x108)
+#define		AR9170_DMA_CTL_ENABLE_TO_DEVICE		0x1
+#define		AR9170_DMA_CTL_ENABLE_FROM_DEVICE	0x2
+#define		AR9170_DMA_CTL_HIGH_SPEED		0x4
+#define		AR9170_DMA_CTL_PACKET_MODE		0x8
+
+#define AR9170_USB_REG_MAX_AGG_UPLOAD		(AR9170_USB_REG_BASE + 0x110)
+#define AR9170_USB_REG_UPLOAD_TIME_CTL		(AR9170_USB_REG_BASE + 0x114)
+
+
+
+#define AR9170_MAC_REG_BASE			0x1c3000
+
+#define AR9170_MAC_REG_ATIM_WINDOW		(AR9170_MAC_REG_BASE + 0x51C)
+#define AR9170_MAC_REG_BCN_PERIOD		(AR9170_MAC_REG_BASE + 0x520)
+#define AR9170_MAC_REG_PRETBTT			(AR9170_MAC_REG_BASE + 0x524)
+
+#define AR9170_MAC_REG_MAC_ADDR_L		(AR9170_MAC_REG_BASE + 0x610)
+#define AR9170_MAC_REG_MAC_ADDR_H		(AR9170_MAC_REG_BASE + 0x614)
+#define AR9170_MAC_REG_BSSID_L			(AR9170_MAC_REG_BASE + 0x618)
+#define AR9170_MAC_REG_BSSID_H			(AR9170_MAC_REG_BASE + 0x61c)
+
+#define AR9170_MAC_REG_GROUP_HASH_TBL_L		(AR9170_MAC_REG_BASE + 0x624)
+#define AR9170_MAC_REG_GROUP_HASH_TBL_H		(AR9170_MAC_REG_BASE + 0x628)
+
+#define AR9170_MAC_REG_RX_TIMEOUT		(AR9170_MAC_REG_BASE + 0x62C)
+
+#define AR9170_MAC_REG_BASIC_RATE		(AR9170_MAC_REG_BASE + 0x630)
+#define AR9170_MAC_REG_MANDATORY_RATE		(AR9170_MAC_REG_BASE + 0x634)
+#define AR9170_MAC_REG_RTS_CTS_RATE		(AR9170_MAC_REG_BASE + 0x638)
+#define AR9170_MAC_REG_BACKOFF_PROTECT		(AR9170_MAC_REG_BASE + 0x63c)
+#define AR9170_MAC_REG_RX_THRESHOLD		(AR9170_MAC_REG_BASE + 0x640)
+#define AR9170_MAC_REG_RX_PE_DELAY		(AR9170_MAC_REG_BASE + 0x64C)
+
+#define AR9170_MAC_REG_DYNAMIC_SIFS_ACK		(AR9170_MAC_REG_BASE + 0x658)
+#define AR9170_MAC_REG_SNIFFER			(AR9170_MAC_REG_BASE + 0x674)
+#define AR9170_MAC_REG_ENCRYPTION		(AR9170_MAC_REG_BASE + 0x678)
+
+#define AR9170_MAC_REG_MISC_680			(AR9170_MAC_REG_BASE + 0x680)
+#define AR9170_MAC_REG_TX_UNDERRUN		(AR9170_MAC_REG_BASE + 0x688)
+
+#define AR9170_MAC_REG_FRAMETYPE_FILTER		(AR9170_MAC_REG_BASE + 0x68c)
+#define AR9170_MAC_REG_FTF_ASSOC_REQ		BIT(0)
+#define AR9170_MAC_REG_FTF_ASSOC_RESP		BIT(1)
+#define AR9170_MAC_REG_FTF_REASSOC_REQ		BIT(2)
+#define AR9170_MAC_REG_FTF_REASSOC_RESP		BIT(3)
+#define AR9170_MAC_REG_FTF_PRB_REQ		BIT(4)
+#define AR9170_MAC_REG_FTF_PRB_RESP		BIT(5)
+#define AR9170_MAC_REG_FTF_BEACON		BIT(8)
+#define AR9170_MAC_REG_FTF_ATIM			BIT(9)
+#define AR9170_MAC_REG_FTF_DEASSOC		BIT(10)
+#define AR9170_MAC_REG_FTF_AUTH			BIT(11)
+#define AR9170_MAC_REG_FTF_DEAUTH		BIT(12)
+#define AR9170_MAC_REG_FTF_BAR			BIT(24)
+#define AR9170_MAC_REG_FTF_PSPOLL		BIT(26)
+#define AR9170_MAC_REG_FTF_RTS			BIT(27)
+#define AR9170_MAC_REG_FTF_CTS			BIT(28)
+#define AR9170_MAC_REG_FTF_ACK			BIT(29)
+#define AR9170_MAC_REG_FTF_CFE			BIT(30)
+#define AR9170_MAC_REG_FTF_CFE_ACK		BIT(31)
+#define AR9170_MAC_REG_FTF_DEFAULTS		0x0500ffff
+
+#define AR9170_MAC_REG_RX_TOTAL			(AR9170_MAC_REG_BASE + 0x6A0)
+#define AR9170_MAC_REG_RX_CRC32			(AR9170_MAC_REG_BASE + 0x6A4)
+#define AR9170_MAC_REG_RX_CRC16			(AR9170_MAC_REG_BASE + 0x6A8)
+#define AR9170_MAC_REG_RX_ERR_UNI		(AR9170_MAC_REG_BASE + 0x6AC)
+#define AR9170_MAC_REG_RX_OVERRUN		(AR9170_MAC_REG_BASE + 0x6B0)
+#define AR9170_MAC_REG_RX_ERR_MUL		(AR9170_MAC_REG_BASE + 0x6BC)
+#define AR9170_MAC_REG_TX_RETRY			(AR9170_MAC_REG_BASE + 0x6CC)
+#define AR9170_MAC_REG_TX_TOTAL			(AR9170_MAC_REG_BASE + 0x6F4)
+
+
+#define AR9170_MAC_REG_ACK_EXTENSION		(AR9170_MAC_REG_BASE + 0x690)
+#define AR9170_MAC_REG_EIFS_AND_SIFS		(AR9170_MAC_REG_BASE + 0x698)
+
+#define AR9170_MAC_REG_SLOT_TIME		(AR9170_MAC_REG_BASE + 0x6F0)
+
+#define AR9170_MAC_REG_ROLL_CALL_TBL_L		(AR9170_MAC_REG_BASE + 0x704)
+#define AR9170_MAC_REG_ROLL_CALL_TBL_H		(AR9170_MAC_REG_BASE + 0x708)
+
+#define AR9170_MAC_REG_AC0_CW			(AR9170_MAC_REG_BASE + 0xB00)
+#define AR9170_MAC_REG_AC1_CW			(AR9170_MAC_REG_BASE + 0xB04)
+#define AR9170_MAC_REG_AC2_CW			(AR9170_MAC_REG_BASE + 0xB08)
+#define AR9170_MAC_REG_AC3_CW			(AR9170_MAC_REG_BASE + 0xB0C)
+#define AR9170_MAC_REG_AC4_CW			(AR9170_MAC_REG_BASE + 0xB10)
+#define AR9170_MAC_REG_AC1_AC0_AIFS		(AR9170_MAC_REG_BASE + 0xB14)
+#define AR9170_MAC_REG_AC3_AC2_AIFS		(AR9170_MAC_REG_BASE + 0xB18)
+
+#define AR9170_MAC_REG_RETRY_MAX		(AR9170_MAC_REG_BASE + 0xB28)
+
+#define AR9170_MAC_REG_FCS_SELECT		(AR9170_MAC_REG_BASE + 0xBB0)
+#define		AR9170_MAC_FCS_SWFCS		0x1
+#define		AR9170_MAC_FCS_FIFO_PROT	0x4
+
+
+#define AR9170_MAC_REG_TXOP_NOT_ENOUGH_IND	(AR9170_MAC_REG_BASE + 0xB30)
+
+#define AR9170_MAC_REG_AC1_AC0_TXOP		(AR9170_MAC_REG_BASE + 0xB44)
+#define AR9170_MAC_REG_AC3_AC2_TXOP		(AR9170_MAC_REG_BASE + 0xB48)
+
+#define AR9170_MAC_REG_ACK_TABLE		(AR9170_MAC_REG_BASE + 0xC00)
+#define AR9170_MAC_REG_AMPDU_RX_THRESH		(AR9170_MAC_REG_BASE + 0xC50)
+
+#define AR9170_MAC_REG_TXRX_MPI			(AR9170_MAC_REG_BASE + 0xD7C)
+#define		AR9170_MAC_TXRX_MPI_TX_MPI_MASK	0x0000000f
+#define		AR9170_MAC_TXRX_MPI_TX_TO_MASK	0x0000fff0
+#define		AR9170_MAC_TXRX_MPI_RX_MPI_MASK	0x000f0000
+#define		AR9170_MAC_TXRX_MPI_RX_TO_MASK	0xfff00000
+
+#define AR9170_MAC_REG_BCN_ADDR			(AR9170_MAC_REG_BASE + 0xD84)
+#define AR9170_MAC_REG_BCN_LENGTH		(AR9170_MAC_REG_BASE + 0xD88)
+#define AR9170_MAC_REG_BCN_PLCP			(AR9170_MAC_REG_BASE + 0xD90)
+#define AR9170_MAC_REG_BCN_CTRL			(AR9170_MAC_REG_BASE + 0xD94)
+#define AR9170_MAC_REG_BCN_HT1			(AR9170_MAC_REG_BASE + 0xDA0)
+#define AR9170_MAC_REG_BCN_HT2			(AR9170_MAC_REG_BASE + 0xDA4)
+
+
+#define AR9170_PWR_REG_BASE			0x1D4000
+
+#define AR9170_PWR_REG_CLOCK_SEL		(AR9170_PWR_REG_BASE + 0x008)
+#define		AR9170_PWR_CLK_AHB_40MHZ	0
+#define		AR9170_PWR_CLK_AHB_20_22MHZ	1
+#define		AR9170_PWR_CLK_AHB_40_44MHZ	2
+#define		AR9170_PWR_CLK_AHB_80_88MHZ	3
+#define		AR9170_PWR_CLK_DAC_160_INV_DLY	0x70
+
+
+struct ar9170_tx_control {
+	__le16 length;
+	__le16 mac_control;
+	__le32 phy_control;
+} __packed;
+
+/* these are either-or */
+#define AR9170_TX_MAC_PROT_RTS			0x0001
+#define AR9170_TX_MAC_PROT_CTS			0x0002
+
+#define AR9170_TX_MAC_NO_ACK			0x0004
+/* if unset, MAC will only do SIFS space before frame */
+#define AR9170_TX_MAC_BACKOFF			0x0008
+#define AR9170_TX_MAC_BURST			0x0010
+#define AR9170_TX_MAC_AGGR			0x0020
+
+/* encryption is a two-bit field */
+#define AR9170_TX_MAC_ENCR_NONE			0x0000
+#define AR9170_TX_MAC_ENCR_WEP			0x0040
+#define AR9170_TX_MAC_ENCR_TKIP			0x0080
+#define AR9170_TX_MAC_ENCR_AES			0x00c0
+
+#define AR9170_TX_MAC_MMIC			0x0100
+#define AR9170_TX_MAC_HW_DURATION		0x0200
+#define AR9170_TX_MAC_DISABLE_TXOP		0x1000
+#define AR9170_TX_MAC_TXOP_RIFS			0x2000
+#define AR9170_TX_MAC_IMM_AMPDU			0x4000
+
+
+/* either-or */
+#define AR9170_TX_PHY_MOD_CCK			0x00000000
+#define AR9170_TX_PHY_MOD_OFDM			0x00000001
+#define AR9170_TX_PHY_MOD_HT			0x00000002
+
+/* depends on modulation */
+#define AR9170_TX_PHY_SHORT_PREAMBLE		0x00000004
+#define AR9170_TX_PHY_GREENFIELD		0x00000004
+
+#define AR9170_TX_PHY_BW_SHIFT			3
+#define AR9170_TX_PHY_BW_MASK			(3 << AR9170_TX_PHY_BW_SHIFT)
+#define AR9170_TX_PHY_BW_20MHZ			0
+#define AR9170_TX_PHY_BW_40MHZ			2
+#define AR9170_TX_PHY_BW_40MHZ_DUP		3
+
+#define AR9170_TX_PHY_TX_PWR_SHIFT		9
+#define AR9170_TX_PHY_TX_PWR_MASK		(0x3f << AR9170_TX_PHY_TX_PWR_SHIFT)
+
+#define AR9170_TX_PHY_TX_HEAVY_CLIP_SHIFT	6
+#define AR9170_TX_PHY_TX_HEAVY_CLIP_MASK	(7 << AR9170_TX_PHY_TX_HEAVY_CLIP_SHIFT)
+
+#define AR9170_TX_PHY_TXCHAIN_SHIFT		15
+#define AR9170_TX_PHY_TXCHAIN_MASK		(7 << AR9170_TX_PHY_TXCHAIN_SHIFT)
+#define AR9170_TX_PHY_TXCHAIN_1			1
+/* use for cck, ofdm 6/9/12/18/24 and HT if capable */
+#define AR9170_TX_PHY_TXCHAIN_2			5
+
+#define AR9170_TX_PHY_MCS_SHIFT			18
+#define AR9170_TX_PHY_MCS_MASK			(0x7f << AR9170_TX_PHY_MCS_SHIFT)
+
+#define AR9170_TX_PHY_SHORT_GI			0x80000000
+
+
+struct ar9170_rx_head {
+	u8 plcp[12];
+};
+
+struct ar9170_rx_tail {
+	union {
+		struct {
+			u8 rssi_ant0, rssi_ant1, rssi_ant2,
+			   rssi_ant0x, rssi_ant1x, rssi_ant2x,
+			   rssi_combined;
+		};
+		u8 rssi[7];
+	};
+
+	u8 evm_stream0[6], evm_stream1[6];
+	u8 phy_err;
+	u8 SAidx, DAidx;
+	u8 error;
+	u8 status;
+};
+
+#define AR9170_ENC_ALG_NONE			0x0
+#define AR9170_ENC_ALG_WEP64			0x1
+#define AR9170_ENC_ALG_TKIP			0x2
+#define AR9170_ENC_ALG_AESCCMP			0x4
+#define AR9170_ENC_ALG_WEP128			0x5
+#define AR9170_ENC_ALG_WEP256			0x6
+#define AR9170_ENC_ALG_CENC			0x7
+
+#define AR9170_RX_ENC_SOFTWARE			0x8
+
+static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_tail *t)
+{
+	return (t->SAidx & 0xc0) >> 4 |
+	       (t->DAidx & 0xc0) >> 6;
+}
+
+#define AR9170_RX_STATUS_MODULATION_MASK	0x03
+#define AR9170_RX_STATUS_MODULATION_CCK		0x00
+#define AR9170_RX_STATUS_MODULATION_OFDM	0x01
+#define AR9170_RX_STATUS_MODULATION_HT		0x02
+#define AR9170_RX_STATUS_MODULATION_DUPOFDM	0x03
+
+/* depends on modulation */
+#define AR9170_RX_STATUS_SHORT_PREAMBLE		0x08
+#define AR9170_RX_STATUS_GREENFIELD		0x08
+
+#define AR9170_RX_STATUS_MPDU_MASK		0x30
+#define AR9170_RX_STATUS_MPDU_SINGLE		0x00
+#define AR9170_RX_STATUS_MPDU_FIRST		0x10
+#define AR9170_RX_STATUS_MPDU_MIDDLE		0x20
+#define AR9170_RX_STATUS_MPDU_LAST		0x30
+
+
+#define AR9170_RX_ERROR_RXTO			0x01
+#define AR9170_RX_ERROR_OVERRUN			0x02
+#define AR9170_RX_ERROR_DECRYPT			0x04
+#define AR9170_RX_ERROR_FCS			0x08
+#define AR9170_RX_ERROR_WRONG_RA		0x10
+#define AR9170_RX_ERROR_PLCP			0x20
+#define AR9170_RX_ERROR_MMIC			0x40
+
+#endif /* __AR9170_HW_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/mac.c	2008-11-15 11:29:17.000000000 +0100
@@ -0,0 +1,172 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * MAC programming
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "ar9170.h"
+
+
+static int ar9170_set_qos_defaults(struct ar9170 *ar)
+{
+	static const struct {
+		u16 cwmin, cwmax, aifs, txop;
+	} dp[5] = {
+		{ 15, 1023, 3*9 + 10, 0 },	/* BE */
+		{ 15, 1023, 7*9 + 10, 0 },	/* BK */
+		{ 7, 15, 2*9 + 10, 94 },	/* VI */
+		{ 3, 7, 2*9 + 10, 47 },		/* VO */
+		{ 3, 7, 2*9 + 10, 0 },		/* SPECIAL */
+	};
+
+	ar9170_regwrite_begin(ar);
+
+	ar9170_regwrite(AR9170_MAC_REG_AC0_CW, dp[0].cwmin | (dp[0].cwmax << 16));
+	ar9170_regwrite(AR9170_MAC_REG_AC1_CW, dp[1].cwmin | (dp[1].cwmax << 16));
+	ar9170_regwrite(AR9170_MAC_REG_AC2_CW, dp[2].cwmin | (dp[2].cwmax << 16));
+	ar9170_regwrite(AR9170_MAC_REG_AC3_CW, dp[3].cwmin | (dp[3].cwmax << 16));
+	ar9170_regwrite(AR9170_MAC_REG_AC4_CW, dp[4].cwmin | (dp[4].cwmax << 16));
+
+	ar9170_regwrite(AR9170_MAC_REG_AC1_AC0_AIFS,
+			dp[0].aifs | (dp[1].aifs << 12) | (dp[2].aifs << 24));
+	ar9170_regwrite(AR9170_MAC_REG_AC3_AC2_AIFS,
+			(dp[2].aifs >> 8) | (dp[3].aifs << 4) | (dp[4].aifs << 16));
+
+	ar9170_regwrite(AR9170_MAC_REG_AC1_AC0_TXOP,
+			dp[0].txop | (dp[1].txop << 16));
+	ar9170_regwrite(AR9170_MAC_REG_AC3_AC2_TXOP,
+			dp[2].txop | (dp[3].txop << 16));
+
+	ar9170_regwrite_finish();
+
+	return ar9170_regwrite_result();
+}
+
+int ar9170_init_mac(struct ar9170 *ar)
+{
+	int err;
+
+	ar9170_regwrite_begin(ar);
+
+	ar9170_regwrite(AR9170_MAC_REG_ACK_EXTENSION, 0x40);
+
+	ar9170_regwrite(AR9170_MAC_REG_RETRY_MAX, 0);
+
+	/* enable MMIC */
+	ar9170_regwrite(AR9170_MAC_REG_SNIFFER, 0x2000000);
+//	ar9170_regwrite(AR9170_MAC_REG_SNIFFER, 1);
+
+	ar9170_regwrite(AR9170_MAC_REG_RX_THRESHOLD, 0xc1f80);
+
+	ar9170_regwrite(AR9170_MAC_REG_RX_PE_DELAY, 0x70);
+	ar9170_regwrite(AR9170_MAC_REG_EIFS_AND_SIFS, 0xa144000);
+	ar9170_regwrite(AR9170_MAC_REG_SLOT_TIME, 9 << 10);
+
+	/* CF-END mode */
+	ar9170_regwrite(0x1c3b2c, 0x19000000);
+
+	/* NAV protects ACK only (in TXOP) */
+	ar9170_regwrite(0x1c3b38, 0x201);
+
+	/* Set Beacon PHY CTRL's TPC to 0x7, TA1=1 */
+	/* OTUS set AM to 0x1 */
+	ar9170_regwrite(AR9170_MAC_REG_BCN_HT1, 0x8000170);
+
+	ar9170_regwrite(AR9170_MAC_REG_BACKOFF_PROTECT, 0x105);
+
+	/* AGG test code*/
+	/* Aggregation MAX number and timeout */
+	ar9170_regwrite(0x1c3b9c, 0x10000a);
+
+	ar9170_regwrite(AR9170_MAC_REG_FRAMETYPE_FILTER,
+			AR9170_MAC_REG_FTF_DEFAULTS);
+
+	/* Enable deaggregator, response in sniffer mode */
+	ar9170_regwrite(0x1c3c40, 0x1 | 1<<30);
+
+	/* rate sets */
+	ar9170_regwrite(AR9170_MAC_REG_BASIC_RATE, 0x150f);
+	ar9170_regwrite(AR9170_MAC_REG_MANDATORY_RATE, 0x150f);
+	ar9170_regwrite(AR9170_MAC_REG_RTS_CTS_RATE, 0x10b01bb);
+
+	/* MIMO response control */
+	ar9170_regwrite(0x1c3694, 0x4003C1E);/* bit 26~28  otus-AM */
+
+	/* switch MAC to OTUS interface */
+	ar9170_regwrite(0x1c3600, 0x3);
+
+	ar9170_regwrite(AR9170_MAC_REG_AMPDU_RX_THRESH, 0xffff);
+
+	/* set PHY register read timeout (??) */
+	ar9170_regwrite(AR9170_MAC_REG_MISC_680, 0xf00008);
+
+	/* Disable Rx TimeOut, workaround for BB. */
+	ar9170_regwrite(AR9170_MAC_REG_RX_TIMEOUT, 0x0);
+
+	/* Set USB Rx stream mode MAX packet number to 2 */
+	ar9170_regwrite(AR9170_USB_REG_MAX_AGG_UPLOAD, 0x4);
+
+	/* Set USB Rx stream mode timeout to 10us */
+	ar9170_regwrite(AR9170_USB_REG_UPLOAD_TIME_CTL, 0x80);
+
+	/* Set CPU clock frequency to 88/80MHz */
+	ar9170_regwrite(AR9170_PWR_REG_CLOCK_SEL,
+			AR9170_PWR_CLK_AHB_80_88MHZ |
+			AR9170_PWR_CLK_DAC_160_INV_DLY);
+
+	/* Set WLAN DMA interrupt mode: generate int per packet */
+	ar9170_regwrite(AR9170_MAC_REG_TXRX_MPI, 0x110011);
+
+	ar9170_regwrite(AR9170_MAC_REG_FCS_SELECT,
+			AR9170_MAC_FCS_FIFO_PROT);
+
+	/* Disables the CF_END frame, undocumented register */
+	ar9170_regwrite(AR9170_MAC_REG_TXOP_NOT_ENOUGH_IND,
+			0x141E0F48);
+
+	/*
+	 * disable HW crypto entirely, otherwise we will
+	 * not see encrypted frames if the key isn't in
+	 * the key cache it seems
+	 */
+	ar9170_regwrite(AR9170_MAC_REG_ENCRYPTION, 0x70 | 1<<3);
+
+	ar9170_regwrite_finish();
+
+	err = ar9170_regwrite_result();
+	if (err)
+		return err;
+
+	return ar9170_set_qos_defaults(ar);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/phy.c	2008-11-15 03:01:22.000000000 +0100
@@ -0,0 +1,1223 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * PHY and RF code
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/bitrev.h>
+#include "ar9170.h"
+
+static int ar9170_init_power_cal(struct ar9170 *ar)
+{
+	ar9170_regwrite_begin(ar);
+
+	ar9170_regwrite(0x1bc000 + 0x993c, 0x7f);
+	ar9170_regwrite(0x1bc000 + 0x9934, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0x9938, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa234, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa238, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa38c, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa390, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa3cc, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa3d0, 0x3f3f3f3f);
+	ar9170_regwrite(0x1bc000 + 0xa3d4, 0x3f3f3f3f);
+
+	ar9170_regwrite_finish();
+	return ar9170_regwrite_result();
+}
+
+struct ar9170_phy_init {
+	u32 reg, _5ghz_20, _5ghz_40, _2ghz_40, _2ghz_20;
+};
+
+static struct ar9170_phy_init ar5416_phy_init[] = {
+	{ 0x1c5800, 0x00000007, 0x00000007, 0x00000007, 0x00000007, },
+	{ 0x1c5804, 0x00000300, 0x000003c4, 0x000003c4, 0x00000300, },
+	{ 0x1c5808, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c580c, 0xad848e19, 0xad848e19, 0xad848e19, 0xad848e19, },
+	{ 0x1c5810, 0x7d14e000, 0x7d14e000, 0x7d14e000, 0x7d14e000, },
+	{ 0x1c5814, 0x9c0a9f6b, 0x9c0a9f6b, 0x9c0a9f6b, 0x9c0a9f6b, },
+	{ 0x1c5818, 0x00000090, 0x00000090, 0x00000090, 0x00000090, },
+	{ 0x1c581c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5820, 0x02020200, 0x02020200, 0x02020200, 0x02020200, },
+	{ 0x1c5824, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, },
+	{ 0x1c5828, 0x0a020001, 0x0a020001, 0x0a020001, 0x0a020001, },
+	{ 0x1c582c, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, },
+	{ 0x1c5830, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5834, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, },
+	{ 0x1c5838, 0x00000007, 0x00000007, 0x00000007, 0x00000007, },
+	{ 0x1c583c, 0x00200400, 0x00200400, 0x00200400, 0x00200400, },
+	{ 0x1c5840, 0x206a002e, 0x206a002e, 0x206a002e, 0x206a002e, },
+	{ 0x1c5844, 0x1372161e, 0x13721c1e, 0x13721c24, 0x137216a4, },
+	{ 0x1c5848, 0x001a6a65, 0x001a6a65, 0x00197a68, 0x00197a68, },
+	{ 0x1c584c, 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c, },
+	{ 0x1c5850, 0x6c48b4e4, 0x6c48b4e4, 0x6c48b0e4, 0x6c48b0e4, },
+	{ 0x1c5854, 0x00000859, 0x00000859, 0x00000859, 0x00000859, },
+	{ 0x1c5858, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, },
+	{ 0x1c585c, 0x31395c5e, 0x31395c5e, 0x31395c5e, 0x31395c5e, },
+	{ 0x1c5860, 0x0004dd10, 0x0004dd10, 0x0004dd20, 0x0004dd20, },
+	{ 0x1c5868, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, },
+	{ 0x1c586c, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, },
+	{ 0x1c5900, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5904, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5908, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c590c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5914, 0x000007d0, 0x000007d0, 0x00000898, 0x00000898, },
+	{ 0x1c5918, 0x00000118, 0x00000230, 0x00000268, 0x00000134, },
+	{ 0x1c591c, 0x10000fff, 0x10000fff, 0x10000fff, 0x10000fff, },
+	{ 0x1c5920, 0x0510081c, 0x0510081c, 0x0510001c, 0x0510001c, },
+	{ 0x1c5924, 0xd0058a15, 0xd0058a15, 0xd0058a15, 0xd0058a15, },
+	{ 0x1c5928, 0x00000001, 0x00000001, 0x00000001, 0x00000001, },
+	{ 0x1c592c, 0x00000004, 0x00000004, 0x00000004, 0x00000004, },
+	{ 0x1c5934, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c5938, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c593c, 0x0000007f, 0x0000007f, 0x0000007f, 0x0000007f, },
+	{ 0x1c5944, 0xdfb81020, 0xdfb81020, 0xdfb81020, 0xdfb81020, },
+	{ 0x1c5948, 0x9280b212, 0x9280b212, 0x9280b212, 0x9280b212, },
+	{ 0x1c594c, 0x00020028, 0x00020028, 0x00020028, 0x00020028, },
+	{ 0x1c5954, 0x5d50e188, 0x5d50e188, 0x5d50e188, 0x5d50e188, },
+	{ 0x1c5958, 0x00081fff, 0x00081fff, 0x00081fff, 0x00081fff, },
+	{ 0x1c5960, 0x00009b40, 0x00009b40, 0x00009b40, 0x00009b40, },
+	{ 0x1c5964, 0x00001120, 0x00001120, 0x00001120, 0x00001120, },
+	{ 0x1c5970, 0x190fb515, 0x190fb515, 0x190fb515, 0x190fb515, },
+	{ 0x1c5974, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5978, 0x00000001, 0x00000001, 0x00000001, 0x00000001, },
+	{ 0x1c597c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5980, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5984, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5988, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c598c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5990, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5994, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5998, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c599c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59a0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59a4, 0x00000007, 0x00000007, 0x00000007, 0x00000007, },
+	{ 0x1c59a8, 0x001fff00, 0x001fff00, 0x001fff00, 0x001fff00, },
+	{ 0x1c59ac, 0x006f00c4, 0x006f00c4, 0x006f00c4, 0x006f00c4, },
+	{ 0x1c59b0, 0x03051000, 0x03051000, 0x03051000, 0x03051000, },
+	{ 0x1c59b4, 0x00000820, 0x00000820, 0x00000820, 0x00000820, },
+	{ 0x1c59c0, 0x038919be, 0x038919be, 0x038919be, 0x038919be, },
+	{ 0x1c59c4, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77, },
+	{ 0x1c59c8, 0x60f6532c, 0x60f6532c, 0x60f6532c, 0x60f6532c, },
+	{ 0x1c59cc, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8, },
+	{ 0x1c59d0, 0x00046384, 0x00046384, 0x00046384, 0x00046384, },
+	{ 0x1c59d4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59d8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59dc, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59e0, 0x00000200, 0x00000200, 0x00000200, 0x00000200, },
+	{ 0x1c59e4, 0x64646464, 0x64646464, 0x64646464, 0x64646464, },
+	{ 0x1c59e8, 0x3c787878, 0x3c787878, 0x3c787878, 0x3c787878, },
+	{ 0x1c59ec, 0x000000aa, 0x000000aa, 0x000000aa, 0x000000aa, },
+	{ 0x1c59f0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c59fc, 0x00001042, 0x00001042, 0x00001042, 0x00001042, },
+	{ 0x1c5a00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5a04, 0x00000040, 0x00000040, 0x00000040, 0x00000040, },
+	{ 0x1c5a08, 0x00000080, 0x00000080, 0x00000080, 0x00000080, },
+	{ 0x1c5a0c, 0x000001a1, 0x000001a1, 0x00000141, 0x00000141, },
+	{ 0x1c5a10, 0x000001e1, 0x000001e1, 0x00000181, 0x00000181, },
+	{ 0x1c5a14, 0x00000021, 0x00000021, 0x000001c1, 0x000001c1, },
+	{ 0x1c5a18, 0x00000061, 0x00000061, 0x00000001, 0x00000001, },
+	{ 0x1c5a1c, 0x00000168, 0x00000168, 0x00000041, 0x00000041, },
+	{ 0x1c5a20, 0x000001a8, 0x000001a8, 0x000001a8, 0x000001a8, },
+	{ 0x1c5a24, 0x000001e8, 0x000001e8, 0x000001e8, 0x000001e8, },
+	{ 0x1c5a28, 0x00000028, 0x00000028, 0x00000028, 0x00000028, },
+	{ 0x1c5a2c, 0x00000068, 0x00000068, 0x00000068, 0x00000068, },
+	{ 0x1c5a30, 0x00000189, 0x00000189, 0x000000a8, 0x000000a8, },
+	{ 0x1c5a34, 0x000001c9, 0x000001c9, 0x00000169, 0x00000169, },
+	{ 0x1c5a38, 0x00000009, 0x00000009, 0x000001a9, 0x000001a9, },
+	{ 0x1c5a3c, 0x00000049, 0x00000049, 0x000001e9, 0x000001e9, },
+	{ 0x1c5a40, 0x00000089, 0x00000089, 0x00000029, 0x00000029, },
+	{ 0x1c5a44, 0x00000170, 0x00000170, 0x00000069, 0x00000069, },
+	{ 0x1c5a48, 0x000001b0, 0x000001b0, 0x00000190, 0x00000190, },
+	{ 0x1c5a4c, 0x000001f0, 0x000001f0, 0x000001d0, 0x000001d0, },
+	{ 0x1c5a50, 0x00000030, 0x00000030, 0x00000010, 0x00000010, },
+	{ 0x1c5a54, 0x00000070, 0x00000070, 0x00000050, 0x00000050, },
+	{ 0x1c5a58, 0x00000191, 0x00000191, 0x00000090, 0x00000090, },
+	{ 0x1c5a5c, 0x000001d1, 0x000001d1, 0x00000151, 0x00000151, },
+	{ 0x1c5a60, 0x00000011, 0x00000011, 0x00000191, 0x00000191, },
+	{ 0x1c5a64, 0x00000051, 0x00000051, 0x000001d1, 0x000001d1, },
+	{ 0x1c5a68, 0x00000091, 0x00000091, 0x00000011, 0x00000011, },
+	{ 0x1c5a6c, 0x000001b8, 0x000001b8, 0x00000051, 0x00000051, },
+	{ 0x1c5a70, 0x000001f8, 0x000001f8, 0x00000198, 0x00000198, },
+	{ 0x1c5a74, 0x00000038, 0x00000038, 0x000001d8, 0x000001d8, },
+	{ 0x1c5a78, 0x00000078, 0x00000078, 0x00000018, 0x00000018, },
+	{ 0x1c5a7c, 0x00000199, 0x00000199, 0x00000058, 0x00000058, },
+	{ 0x1c5a80, 0x000001d9, 0x000001d9, 0x00000098, 0x00000098, },
+	{ 0x1c5a84, 0x00000019, 0x00000019, 0x00000159, 0x00000159, },
+	{ 0x1c5a88, 0x00000059, 0x00000059, 0x00000199, 0x00000199, },
+	{ 0x1c5a8c, 0x00000099, 0x00000099, 0x000001d9, 0x000001d9, },
+	{ 0x1c5a90, 0x000000d9, 0x000000d9, 0x00000019, 0x00000019, },
+	{ 0x1c5a94, 0x000000f9, 0x000000f9, 0x00000059, 0x00000059, },
+	{ 0x1c5a98, 0x000000f9, 0x000000f9, 0x00000099, 0x00000099, },
+	{ 0x1c5a9c, 0x000000f9, 0x000000f9, 0x000000d9, 0x000000d9, },
+	{ 0x1c5aa0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5aa4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5aa8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5aac, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ab0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ab4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ab8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5abc, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ac0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ac4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ac8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5acc, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ad0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ad4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ad8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5adc, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ae0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ae4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5ae8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5aec, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5af0, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5af4, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5af8, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5afc, 0x000000f9, 0x000000f9, 0x000000f9, 0x000000f9, },
+	{ 0x1c5b00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5b04, 0x00000001, 0x00000001, 0x00000001, 0x00000001, },
+	{ 0x1c5b08, 0x00000002, 0x00000002, 0x00000002, 0x00000002, },
+	{ 0x1c5b0c, 0x00000003, 0x00000003, 0x00000003, 0x00000003, },
+	{ 0x1c5b10, 0x00000004, 0x00000004, 0x00000004, 0x00000004, },
+	{ 0x1c5b14, 0x00000005, 0x00000005, 0x00000005, 0x00000005, },
+	{ 0x1c5b18, 0x00000008, 0x00000008, 0x00000008, 0x00000008, },
+	{ 0x1c5b1c, 0x00000009, 0x00000009, 0x00000009, 0x00000009, },
+	{ 0x1c5b20, 0x0000000a, 0x0000000a, 0x0000000a, 0x0000000a, },
+	{ 0x1c5b24, 0x0000000b, 0x0000000b, 0x0000000b, 0x0000000b, },
+	{ 0x1c5b28, 0x0000000c, 0x0000000c, 0x0000000c, 0x0000000c, },
+	{ 0x1c5b2c, 0x0000000d, 0x0000000d, 0x0000000d, 0x0000000d, },
+	{ 0x1c5b30, 0x00000010, 0x00000010, 0x00000010, 0x00000010, },
+	{ 0x1c5b34, 0x00000011, 0x00000011, 0x00000011, 0x00000011, },
+	{ 0x1c5b38, 0x00000012, 0x00000012, 0x00000012, 0x00000012, },
+	{ 0x1c5b3c, 0x00000013, 0x00000013, 0x00000013, 0x00000013, },
+	{ 0x1c5b40, 0x00000014, 0x00000014, 0x00000014, 0x00000014, },
+	{ 0x1c5b44, 0x00000015, 0x00000015, 0x00000015, 0x00000015, },
+	{ 0x1c5b48, 0x00000018, 0x00000018, 0x00000018, 0x00000018, },
+	{ 0x1c5b4c, 0x00000019, 0x00000019, 0x00000019, 0x00000019, },
+	{ 0x1c5b50, 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a, },
+	{ 0x1c5b54, 0x0000001b, 0x0000001b, 0x0000001b, 0x0000001b, },
+	{ 0x1c5b58, 0x0000001c, 0x0000001c, 0x0000001c, 0x0000001c, },
+	{ 0x1c5b5c, 0x0000001d, 0x0000001d, 0x0000001d, 0x0000001d, },
+	{ 0x1c5b60, 0x00000020, 0x00000020, 0x00000020, 0x00000020, },
+	{ 0x1c5b64, 0x00000021, 0x00000021, 0x00000021, 0x00000021, },
+	{ 0x1c5b68, 0x00000022, 0x00000022, 0x00000022, 0x00000022, },
+	{ 0x1c5b6c, 0x00000023, 0x00000023, 0x00000023, 0x00000023, },
+	{ 0x1c5b70, 0x00000024, 0x00000024, 0x00000024, 0x00000024, },
+	{ 0x1c5b74, 0x00000025, 0x00000025, 0x00000025, 0x00000025, },
+	{ 0x1c5b78, 0x00000028, 0x00000028, 0x00000028, 0x00000028, },
+	{ 0x1c5b7c, 0x00000029, 0x00000029, 0x00000029, 0x00000029, },
+	{ 0x1c5b80, 0x0000002a, 0x0000002a, 0x0000002a, 0x0000002a, },
+	{ 0x1c5b84, 0x0000002b, 0x0000002b, 0x0000002b, 0x0000002b, },
+	{ 0x1c5b88, 0x0000002c, 0x0000002c, 0x0000002c, 0x0000002c, },
+	{ 0x1c5b8c, 0x0000002d, 0x0000002d, 0x0000002d, 0x0000002d, },
+	{ 0x1c5b90, 0x00000030, 0x00000030, 0x00000030, 0x00000030, },
+	{ 0x1c5b94, 0x00000031, 0x00000031, 0x00000031, 0x00000031, },
+	{ 0x1c5b98, 0x00000032, 0x00000032, 0x00000032, 0x00000032, },
+	{ 0x1c5b9c, 0x00000033, 0x00000033, 0x00000033, 0x00000033, },
+	{ 0x1c5ba0, 0x00000034, 0x00000034, 0x00000034, 0x00000034, },
+	{ 0x1c5ba4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5ba8, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bac, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bb0, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bb4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bb8, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bbc, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bc0, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bc4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bc8, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bcc, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bd0, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bd4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bd8, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bdc, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5be0, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5be4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5be8, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bec, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bf0, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bf4, 0x00000035, 0x00000035, 0x00000035, 0x00000035, },
+	{ 0x1c5bf8, 0x00000010, 0x00000010, 0x00000010, 0x00000010, },
+	{ 0x1c5bfc, 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a, },
+	{ 0x1c5c00, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c0c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c10, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c14, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c18, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c1c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c20, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c24, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c28, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c2c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c30, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c34, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c38, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5c3c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5cf0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5cf4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5cf8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c5cfc, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6200, 0x00000008, 0x00000008, 0x0000000e, 0x0000000e, },
+	{ 0x1c6204, 0x00000440, 0x00000440, 0x00000440, 0x00000440, },
+	{ 0x1c6208, 0xd6be4788, 0xd6be4788, 0xd03e4788, 0xd03e4788, },
+	{ 0x1c620c, 0x012e8160, 0x012e8160, 0x012a8160, 0x012a8160, },
+	{ 0x1c6210, 0x40806333, 0x40806333, 0x40806333, 0x40806333, },
+	{ 0x1c6214, 0x00106c10, 0x00106c10, 0x00106c10, 0x00106c10, },
+	{ 0x1c6218, 0x009c4060, 0x009c4060, 0x009c4060, 0x009c4060, },
+	{ 0x1c621c, 0x1883800a, 0x1883800a, 0x1883800a, 0x1883800a, },
+	{ 0x1c6220, 0x018830c6, 0x018830c6, 0x018830c6, 0x018830c6, },
+	{ 0x1c6224, 0x00000400, 0x00000400, 0x00000400, 0x00000400, },
+	{ 0x1c6228, 0x000009b5, 0x000009b5, 0x000009b5, 0x000009b5, },
+	{ 0x1c622c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6230, 0x00000108, 0x00000210, 0x00000210, 0x00000108, },
+	{ 0x1c6234, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c6238, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c623c, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, },
+	{ 0x1c6240, 0x38490a20, 0x38490a20, 0x38490a20, 0x38490a20, },
+	{ 0x1c6244, 0x00007bb6, 0x00007bb6, 0x00007bb6, 0x00007bb6, },
+	{ 0x1c6248, 0x0fff3ffc, 0x0fff3ffc, 0x0fff3ffc, 0x0fff3ffc, },
+	{ 0x1c624c, 0x00000001, 0x00000001, 0x00000001, 0x00000001, },
+	{ 0x1c6250, 0x0000a000, 0x0000a000, 0x0000a000, 0x0000a000, },
+	{ 0x1c6254, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6258, 0x0cc75380, 0x0cc75380, 0x0cc75380, 0x0cc75380, },
+	{ 0x1c625c, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, 0x0f0f0f01, },
+	{ 0x1c6260, 0xdfa91f01, 0xdfa91f01, 0xdfa91f01, 0xdfa91f01, },
+	{ 0x1c6264, 0x00418a11, 0x00418a11, 0x00418a11, 0x00418a11, },
+	{ 0x1c6268, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c626c, 0x09249126, 0x09249126, 0x09249126, 0x09249126, },
+	{ 0x1c6274, 0x0a1a9caa, 0x0a1a9caa, 0x0a1a7caa, 0x0a1a7caa, },
+	{ 0x1c6278, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, },
+	{ 0x1c627c, 0x051701ce, 0x051701ce, 0x051701ce, 0x051701ce, },
+	{ 0x1c6300, 0x18010000, 0x18010000, 0x18010000, 0x18010000, },
+	{ 0x1c6304, 0x30032602, 0x30032602, 0x2e032402, 0x2e032402, },
+	{ 0x1c6308, 0x48073e06, 0x48073e06, 0x4a0a3c06, 0x4a0a3c06, },
+	{ 0x1c630c, 0x560b4c0a, 0x560b4c0a, 0x621a540b, 0x621a540b, },
+	{ 0x1c6310, 0x641a600f, 0x641a600f, 0x764f6c1b, 0x764f6c1b, },
+	{ 0x1c6314, 0x7a4f6e1b, 0x7a4f6e1b, 0x845b7a5a, 0x845b7a5a, },
+	{ 0x1c6318, 0x8c5b7e5a, 0x8c5b7e5a, 0x950f8ccf, 0x950f8ccf, },
+	{ 0x1c631c, 0x9d0f96cf, 0x9d0f96cf, 0xa5cf9b4f, 0xa5cf9b4f, },
+	{ 0x1c6320, 0xb51fa69f, 0xb51fa69f, 0xbddfaf1f, 0xbddfaf1f, },
+	{ 0x1c6324, 0xcb3fbd07, 0xcb3fbcbf, 0xd1ffc93f, 0xd1ffc93f, },
+	{ 0x1c6328, 0x0000d7bf, 0x0000d7bf, 0x00000000, 0x00000000, },
+	{ 0x1c632c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6330, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6334, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6338, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c633c, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6340, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6344, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c6348, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, },
+	{ 0x1c634c, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, },
+	{ 0x1c6350, 0x3fffffff, 0x3fffffff, 0x3fffffff, 0x3fffffff, },
+	{ 0x1c6354, 0x0003ffff, 0x0003ffff, 0x0003ffff, 0x0003ffff, },
+	{ 0x1c6358, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, 0x79a8aa1f, },
+	{ 0x1c6388, 0x08000000, 0x08000000, 0x08000000, 0x08000000, },
+	{ 0x1c638c, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c6390, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c6394, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, },
+	{ 0x1c6398, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce, },
+	{ 0x1c639c, 0x00000007, 0x00000007, 0x00000007, 0x00000007, },
+	{ 0x1c63a0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63a4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63a8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63ac, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63b0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63b4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63b8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63bc, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63c0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63c4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63c8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63cc, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c63d0, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c63d4, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, 0x3f3f3f3f, },
+	{ 0x1c63d8, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
+	{ 0x1c63dc, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, },
+	{ 0x1c63e0, 0x000000c0, 0x000000c0, 0x000000c0, 0x000000c0, },
+	{ 0x1c6848, 0x00180a65, 0x00180a65, 0x00180a68, 0x00180a68, },
+	{ 0x1c6920, 0x0510001c, 0x0510001c, 0x0510001c, 0x0510001c, },
+	{ 0x1c6960, 0x00009b40, 0x00009b40, 0x00009b40, 0x00009b40, },
+	{ 0x1c720c, 0x012e8160, 0x012e8160, 0x012a8160, 0x012a8160, },
+	{ 0x1c726c, 0x09249126, 0x09249126, 0x09249126, 0x09249126, },
+	{ 0x1c7848, 0x00180a65, 0x00180a65, 0x00180a68, 0x00180a68, },
+	{ 0x1c7920, 0x0510001c, 0x0510001c, 0x0510001c, 0x0510001c, },
+	{ 0x1c7960, 0x00009b40, 0x00009b40, 0x00009b40, 0x00009b40, },
+	{ 0x1c820c, 0x012e8160, 0x012e8160, 0x012a8160, 0x012a8160, },
+	{ 0x1c826c, 0x09249126, 0x09249126, 0x09249126, 0x09249126, },
+/*	{ 0x1c8864, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, }, */
+	{ 0x1c8864, 0x0001c600, 0x0001c600, 0x0001c600, 0x0001c600, },
+	{ 0x1c895c, 0x004b6a8e, 0x004b6a8e, 0x004b6a8e, 0x004b6a8e, },
+	{ 0x1c8968, 0x000003ce, 0x000003ce, 0x000003ce, 0x000003ce, },
+	{ 0x1c89bc, 0x00181400, 0x00181400, 0x00181400, 0x00181400, },
+	{ 0x1c9270, 0x00820820, 0x00820820, 0x00820820, 0x00820820, },
+	{ 0x1c935c, 0x066c420f, 0x066c420f, 0x066c420f, 0x066c420f, },
+	{ 0x1c9360, 0x0f282207, 0x0f282207, 0x0f282207, 0x0f282207, },
+	{ 0x1c9364, 0x17601685, 0x17601685, 0x17601685, 0x17601685, },
+	{ 0x1c9368, 0x1f801104, 0x1f801104, 0x1f801104, 0x1f801104, },
+	{ 0x1c936c, 0x37a00c03, 0x37a00c03, 0x37a00c03, 0x37a00c03, },
+	{ 0x1c9370, 0x3fc40883, 0x3fc40883, 0x3fc40883, 0x3fc40883, },
+	{ 0x1c9374, 0x57c00803, 0x57c00803, 0x57c00803, 0x57c00803, },
+	{ 0x1c9378, 0x5fd80682, 0x5fd80682, 0x5fd80682, 0x5fd80682, },
+	{ 0x1c937c, 0x7fe00482, 0x7fe00482, 0x7fe00482, 0x7fe00482, },
+	{ 0x1c9380, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, 0x7f3c7bba, },
+	{ 0x1c9384, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, }
+};
+
+int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
+{
+	int i, err;
+	u32 val;
+	bool is_2ghz = band == IEEE80211_BAND_2GHZ;
+	bool is_40mhz = false; /* XXX: for now */
+
+	ar9170_regwrite_begin(ar);
+
+	for (i = 0; i < ARRAY_SIZE(ar5416_phy_init); i++) {
+		if (is_40mhz) {
+			if (is_2ghz)
+				val = ar5416_phy_init[i]._2ghz_40;
+			else
+				val = ar5416_phy_init[i]._5ghz_40;
+		} else {
+			if (is_2ghz)
+				val = ar5416_phy_init[i]._2ghz_20;
+			else
+				val = ar5416_phy_init[i]._5ghz_20;
+		}
+
+		ar9170_regwrite(ar5416_phy_init[i].reg, val);
+	}
+
+	ar9170_regwrite_finish();
+	err = ar9170_regwrite_result();
+	if (err)
+		return err;
+
+	/* XXX: use EEPROM data here! */
+
+	err = ar9170_init_power_cal(ar);
+	if (err)
+		return err;
+
+	/* XXX: remove magic! */
+	if (is_2ghz)
+		err = ar9170_write_reg(ar, 0x1d4014, 0x5163);
+	else
+		err = ar9170_write_reg(ar, 0x1d4014, 0x5143);
+
+	return err;
+}
+
+struct ar9170_rf_init {
+	u32 reg, _5ghz, _2ghz;
+};
+
+static struct ar9170_rf_init ar9170_rf_init[] = {
+     /* bank 0 */
+     { 0x1c58b0,  0x1e5795e5,  0x1e5795e5},
+     { 0x1c58e0,  0x02008020,  0x02008020},
+     /* bank 1 */
+     { 0x1c58b0,  0x02108421,  0x02108421},
+     { 0x1c58ec,  0x00000008,  0x00000008},
+     /* bank 2 */
+     { 0x1c58b0,  0x0e73ff17,  0x0e73ff17},
+     { 0x1c58e0,  0x00000420,  0x00000420},
+     /* bank 3 */
+     { 0x1c58f0,  0x01400018,  0x01c00018},
+     /* bank 4 */
+     { 0x1c58b0,  0x000001a1,  0x000001a1},
+     { 0x1c58e8,  0x00000001,  0x00000001},
+     /* bank 5 */
+     { 0x1c58b0,  0x00000013,  0x00000013},
+     { 0x1c58e4,  0x00000002,  0x00000002},
+     /* bank 6 */
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00004000,  0x00004000},
+     { 0x1c58b0,  0x00006c00,  0x00006c00},
+     { 0x1c58b0,  0x00002c00,  0x00002c00},
+     { 0x1c58b0,  0x00004800,  0x00004800},
+     { 0x1c58b0,  0x00004000,  0x00004000},
+     { 0x1c58b0,  0x00006000,  0x00006000},
+     { 0x1c58b0,  0x00001000,  0x00001000},
+     { 0x1c58b0,  0x00004000,  0x00004000},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00087c00,  0x00087c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00005400,  0x00005400},
+     { 0x1c58b0,  0x00000c00,  0x00000c00},
+     { 0x1c58b0,  0x00001800,  0x00001800},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00006c00,  0x00006c00},
+     { 0x1c58b0,  0x00006c00,  0x00006c00},
+     { 0x1c58b0,  0x00007c00,  0x00007c00},
+     { 0x1c58b0,  0x00002c00,  0x00002c00},
+     { 0x1c58b0,  0x00003c00,  0x00003c00},
+     { 0x1c58b0,  0x00003800,  0x00003800},
+     { 0x1c58b0,  0x00001c00,  0x00001c00},
+     { 0x1c58b0,  0x00000800,  0x00000800},
+     { 0x1c58b0,  0x00000408,  0x00000408},
+     { 0x1c58b0,  0x00004c15,  0x00004c15},
+     { 0x1c58b0,  0x00004188,  0x00004188},
+     { 0x1c58b0,  0x0000201e,  0x0000201e},
+     { 0x1c58b0,  0x00010408,  0x00010408},
+     { 0x1c58b0,  0x00000801,  0x00000801},
+     { 0x1c58b0,  0x00000c08,  0x00000c08},
+     { 0x1c58b0,  0x0000181e,  0x0000181e},
+     { 0x1c58b0,  0x00001016,  0x00001016},
+     { 0x1c58b0,  0x00002800,  0x00002800},
+     { 0x1c58b0,  0x00004010,  0x00004010},
+     { 0x1c58b0,  0x0000081c,  0x0000081c},
+     { 0x1c58b0,  0x00000115,  0x00000115},
+     { 0x1c58b0,  0x00000015,  0x00000015},
+     { 0x1c58b0,  0x00000066,  0x00000066},
+     { 0x1c58b0,  0x0000001c,  0x0000001c},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000004,  0x00000004},
+     { 0x1c58b0,  0x00000015,  0x00000015},
+     { 0x1c58b0,  0x0000001f,  0x0000001f},
+     { 0x1c58e0,  0x00000000,  0x00000400},
+     /* bank 7 */
+     { 0x1c58b0,  0x000000a0,  0x000000a0},
+     { 0x1c58b0,  0x00000000,  0x00000000},
+     { 0x1c58b0,  0x00000040,  0x00000040},
+     { 0x1c58f0,  0x0000001c,  0x0000001c},
+};
+
+static int ar9170_init_rf_banks_0_7(struct ar9170 *ar, bool band5ghz)
+{
+	int err, i;
+
+	ar9170_regwrite_begin(ar);
+
+	for (i = 0; i < ARRAY_SIZE(ar9170_rf_init); i++)
+		ar9170_regwrite(ar9170_rf_init[i].reg,
+				band5ghz ? ar9170_rf_init[i]._5ghz
+					 : ar9170_rf_init[i]._2ghz);
+
+	ar9170_regwrite_finish();
+	err = ar9170_regwrite_result();
+	if (err)
+		printk(KERN_DEBUG "ar9170: rf init failed\n");
+	return err;
+}
+
+static int ar9170_init_rf_bank4_pwr(struct ar9170 *ar, bool band5ghz,
+				    u32 freq, enum ar9170_bw bw)
+{
+	int err;
+	u32 d0, d1, td0, td1, fd0, fd1;
+	u8 chansel;
+	u8 refsel0 = 1, refsel1 = 0;
+	u8 lf_synth = 0;
+
+	switch (bw) {
+	case AR9170_BW_40_ABOVE:
+		freq += 10;
+		break;
+	case AR9170_BW_40_BELOW:
+		freq -= 10;
+		break;
+	case AR9170_BW_20:
+		break;
+	case __AR9170_NUM_BW:
+		BUG();
+	}
+
+	if (band5ghz) {
+		if (freq % 10) {
+			chansel = (freq - 4800) / 5;
+		} else {
+			chansel = ((freq - 4800) / 10) * 2;
+			refsel0 = 0;
+			refsel1 = 1;
+		}
+		chansel = byte_rev_table[chansel];
+	} else {
+		if (freq == 2484) {
+			chansel = 10 + (freq - 2274) / 5;
+			lf_synth = 1;
+		} else
+			chansel = 16 + (freq - 2272) / 5;
+		chansel *= 4;
+		chansel = byte_rev_table[chansel];
+	}
+
+	d1 =	chansel;
+	d0 =	0x21 |
+		refsel0 << 3 |
+		refsel1 << 2 |
+		lf_synth << 1;
+	td0 =	d0 & 0x1f;
+	td1 =	d1 & 0x1f;
+	fd0 =	td1 << 5 | td0;
+
+	td0 =	(d0 >> 5) & 0x7;
+	td1 =	(d1 >> 5) & 0x7;
+	fd1 =	td1 << 5 | td0;
+
+	ar9170_regwrite_begin(ar);
+
+	ar9170_regwrite(0x1c58b0, fd0);
+	ar9170_regwrite(0x1c58e8, fd1);
+
+	ar9170_regwrite_finish();
+	err = ar9170_regwrite_result();
+	if (err)
+		return err;
+
+	msleep(10);
+
+	return 0;
+}
+
+struct ar9170_phy_freq_params {
+	u8 coeff_exp;
+	u16 coeff_man;
+	u8 coeff_exp_shgi;
+	u16 coeff_man_shgi;
+};
+
+struct ar9170_phy_freq_entry {
+	u16 freq;
+	struct ar9170_phy_freq_params params[__AR9170_NUM_BW];
+};
+
+/* NB: must be in sync with channel tables in main! */
+static const struct ar9170_phy_freq_entry ar9170_phy_freq_params[] = {
+/*
+ *	freq,
+ *		20MHz,
+ *		40MHz (below),
+ *		40Mhz (above),
+ */
+	{ 2412, {
+		{ 3, 21737, 3, 19563, },
+		{ 3, 21827, 3, 19644, },
+		{ 3, 21647, 3, 19482, },
+	} },
+	{ 2417, {
+		{ 3, 21692, 3, 19523, },
+		{ 3, 21782, 3, 19604, },
+		{ 3, 21602, 3, 19442, },
+	} },
+	{ 2422, {
+		{ 3, 21647, 3, 19482, },
+		{ 3, 21737, 3, 19563, },
+		{ 3, 21558, 3, 19402, },
+	} },
+	{ 2427, {
+		{ 3, 21602, 3, 19442, },
+		{ 3, 21692, 3, 19523, },
+		{ 3, 21514, 3, 19362, },
+	} },
+	{ 2432, {
+		{ 3, 21558, 3, 19402, },
+		{ 3, 21647, 3, 19482, },
+		{ 3, 21470, 3, 19323, },
+	} },
+	{ 2437, {
+		{ 3, 21514, 3, 19362, },
+		{ 3, 21602, 3, 19442, },
+		{ 3, 21426, 3, 19283, },
+	} },
+	{ 2442, {
+		{ 3, 21470, 3, 19323, },
+		{ 3, 21558, 3, 19402, },
+		{ 3, 21382, 3, 19244, },
+	} },
+	{ 2447, {
+		{ 3, 21426, 3, 19283, },
+		{ 3, 21514, 3, 19362, },
+		{ 3, 21339, 3, 19205, },
+	} },
+	{ 2452, {
+		{ 3, 21382, 3, 19244, },
+		{ 3, 21470, 3, 19323, },
+		{ 3, 21295, 3, 19166, },
+	} },
+	{ 2457, {
+		{ 3, 21339, 3, 19205, },
+		{ 3, 21426, 3, 19283, },
+		{ 3, 21252, 3, 19127, },
+	} },
+	{ 2462, {
+		{ 3, 21295, 3, 19166, },
+		{ 3, 21382, 3, 19244, },
+		{ 3, 21209, 3, 19088, },
+	} },
+	{ 2467, {
+		{ 3, 21252, 3, 19127, },
+		{ 3, 21339, 3, 19205, },
+		{ 3, 21166, 3, 19050, },
+	} },
+	{ 2472, {
+		{ 3, 21209, 3, 19088, },
+		{ 3, 21295, 3, 19166, },
+		{ 3, 21124, 3, 19011, },
+	} },
+	{ 2484, {
+		{ 3, 21107, 3, 18996, },
+		{ 3, 21192, 3, 19073, },
+		{ 3, 21022, 3, 18920, },
+	} },
+	{ 4920, {
+		{ 4, 21313, 4, 19181, },
+		{ 4, 21356, 4, 19220, },
+		{ 4, 21269, 4, 19142, },
+	} },
+	{ 4940, {
+		{ 4, 21226, 4, 19104, },
+		{ 4, 21269, 4, 19142, },
+		{ 4, 21183, 4, 19065, },
+	} },
+	{ 4960, {
+		{ 4, 21141, 4, 19027, },
+		{ 4, 21183, 4, 19065, },
+		{ 4, 21098, 4, 18988, },
+	} },
+	{ 4980, {
+		{ 4, 21056, 4, 18950, },
+		{ 4, 21098, 4, 18988, },
+		{ 4, 21014, 4, 18912, },
+	} },
+	{ 5040, {
+		{ 4, 20805, 4, 18725, },
+		{ 4, 20846, 4, 18762, },
+		{ 4, 20764, 4, 18687, },
+	} },
+	{ 5060, {
+		{ 4, 20723, 4, 18651, },
+		{ 4, 20764, 4, 18687, },
+		{ 4, 20682, 4, 18614, },
+	} },
+	{ 5080, {
+		{ 4, 20641, 4, 18577, },
+		{ 4, 20682, 4, 18614, },
+		{ 4, 20601, 4, 18541, },
+	} },
+	{ 5180, {
+		{ 4, 20243, 4, 18219, },
+		{ 4, 20282, 4, 18254, },
+		{ 4, 20204, 4, 18183, },
+	} },
+	{ 5200, {
+		{ 4, 20165, 4, 18148, },
+		{ 4, 20204, 4, 18183, },
+		{ 4, 20126, 4, 18114, },
+	} },
+	{ 5220, {
+		{ 4, 20088, 4, 18079, },
+		{ 4, 20126, 4, 18114, },
+		{ 4, 20049, 4, 18044, },
+	} },
+	{ 5240, {
+		{ 4, 20011, 4, 18010, },
+		{ 4, 20049, 4, 18044, },
+		{ 4, 19973, 4, 17976, },
+	} },
+	{ 5260, {
+		{ 4, 19935, 4, 17941, },
+		{ 4, 19973, 4, 17976, },
+		{ 4, 19897, 4, 17907, },
+	} },
+	{ 5280, {
+		{ 4, 19859, 4, 17873, },
+		{ 4, 19897, 4, 17907, },
+		{ 4, 19822, 4, 17840, },
+	} },
+	{ 5300, {
+		{ 4, 19784, 4, 17806, },
+		{ 4, 19822, 4, 17840, },
+		{ 4, 19747, 4, 17772, },
+	} },
+	{ 5320, {
+		{ 4, 19710, 4, 17739, },
+		{ 4, 19747, 4, 17772, },
+		{ 4, 19673, 4, 17706, },
+	} },
+	{ 5500, {
+		{ 4, 19065, 4, 17159, },
+		{ 4, 19100, 4, 17190, },
+		{ 4, 19030, 4, 17127, },
+	} },
+	{ 5520, {
+		{ 4, 18996, 4, 17096, },
+		{ 4, 19030, 4, 17127, },
+		{ 4, 18962, 4, 17065, },
+	} },
+	{ 5540, {
+		{ 4, 18927, 4, 17035, },
+		{ 4, 18962, 4, 17065, },
+		{ 4, 18893, 4, 17004, },
+	} },
+	{ 5560, {
+		{ 4, 18859, 4, 16973, },
+		{ 4, 18893, 4, 17004, },
+		{ 4, 18825, 4, 16943, },
+	} },
+	{ 5580, {
+		{ 4, 18792, 4, 16913, },
+		{ 4, 18825, 4, 16943, },
+		{ 4, 18758, 4, 16882, },
+	} },
+	{ 5600, {
+		{ 4, 18725, 4, 16852, },
+		{ 4, 18758, 4, 16882, },
+		{ 4, 18691, 4, 16822, },
+	} },
+	{ 5620, {
+		{ 4, 18658, 4, 16792, },
+		{ 4, 18691, 4, 16822, },
+		{ 4, 18625, 4, 16762, },
+	} },
+	{ 5640, {
+		{ 4, 18592, 4, 16733, },
+		{ 4, 18625, 4, 16762, },
+		{ 4, 18559, 4, 16703, },
+	} },
+	{ 5660, {
+		{ 4, 18526, 4, 16673, },
+		{ 4, 18559, 4, 16703, },
+		{ 4, 18493, 4, 16644, },
+	} },
+	{ 5680, {
+		{ 4, 18461, 4, 16615, },
+		{ 4, 18493, 4, 16644, },
+		{ 4, 18428, 4, 16586, },
+	} },
+	{ 5700, {
+		{ 4, 18396, 4, 16556, },
+		{ 4, 18428, 4, 16586, },
+		{ 4, 18364, 4, 16527, },
+	} },
+	{ 5745, {
+		{ 4, 18252, 4, 16427, },
+		{ 4, 18284, 4, 16455, },
+		{ 4, 18220, 4, 16398, },
+	} },
+	{ 5765, {
+		{ 4, 18189, 5, 32740, },
+		{ 4, 18220, 4, 16398, },
+		{ 4, 18157, 5, 32683, },
+	} },
+	{ 5785, {
+		{ 4, 18126, 5, 32626, },
+		{ 4, 18157, 5, 32683, },
+		{ 4, 18094, 5, 32570, },
+	} },
+	{ 5805, {
+		{ 4, 18063, 5, 32514, },
+		{ 4, 18094, 5, 32570, },
+		{ 4, 18032, 5, 32458, },
+	} },
+	{ 5825, {
+		{ 4, 18001, 5, 32402, },
+		{ 4, 18032, 5, 32458, },
+		{ 4, 17970, 5, 32347, },
+	} },
+	{ 5170, {
+		{ 4, 20282, 4, 18254, },
+		{ 4, 20321, 4, 18289, },
+		{ 4, 20243, 4, 18219, },
+	} },
+	{ 5190, {
+		{ 4, 20204, 4, 18183, },
+		{ 4, 20243, 4, 18219, },
+		{ 4, 20165, 4, 18148, },
+	} },
+	{ 5210, {
+		{ 4, 20126, 4, 18114, },
+		{ 4, 20165, 4, 18148, },
+		{ 4, 20088, 4, 18079, },
+	} },
+	{ 5230, {
+		{ 4, 20049, 4, 18044, },
+		{ 4, 20088, 4, 18079, },
+		{ 4, 20011, 4, 18010, },
+	} },
+};
+
+static const struct ar9170_phy_freq_params *
+ar9170_get_hw_dyn_params(struct ieee80211_channel *channel,
+			 enum ar9170_bw bw)
+{
+	unsigned int chanidx = 0;
+	u16 freq = 2412;
+
+	if (channel) {
+		chanidx = channel->hw_value;
+		freq = channel->center_freq;
+	}
+
+	BUG_ON(chanidx >= ARRAY_SIZE(ar9170_phy_freq_params));
+
+	BUILD_BUG_ON(__AR9170_NUM_BW != 3);
+
+	WARN_ON(ar9170_phy_freq_params[chanidx].freq != freq);
+
+	return &ar9170_phy_freq_params[chanidx].params[bw];
+}
+
+
+int ar9170_init_rf(struct ar9170 *ar)
+{
+	const struct ar9170_phy_freq_params *freqpar;
+	__le32 cmd[7];
+	int err;
+
+	err = ar9170_init_rf_banks_0_7(ar, false);
+	if (err)
+		return err;
+
+	err = ar9170_init_rf_bank4_pwr(ar, false, 2412, AR9170_BW_20);
+	if (err)
+		return err;
+
+	freqpar = ar9170_get_hw_dyn_params(NULL, AR9170_BW_20);
+
+	cmd[0] = cpu_to_le32(2412 * 1000);
+	cmd[1] = cpu_to_le32(0);
+	cmd[2] = cpu_to_le32(1);
+	cmd[3] = cpu_to_le32(freqpar->coeff_exp);
+	cmd[4] = cpu_to_le32(freqpar->coeff_man);
+	cmd[5] = cpu_to_le32(freqpar->coeff_exp_shgi);
+	cmd[6] = cpu_to_le32(freqpar->coeff_man_shgi);
+
+	/* RF_INIT echoes the command back to us */
+	err = ar9170_exec_cmd(ar, AR9170_CMD_RF_INIT,
+			      sizeof(cmd), (u8 *)cmd,
+			      sizeof(cmd), (u8 *)cmd);
+	if (err)
+		return err;
+
+	msleep(1000);
+
+	return ar9170_echo_test(ar, 0xaabbccdd);
+}
+
+static int ar9170_find_freq_idx(int nfreqs, u8 *freqs, u8 f)
+{
+	int idx = nfreqs - 2;
+
+	while (idx >= 0) {
+		if (f >= freqs[idx])
+			return idx;
+		idx--;
+	}
+
+	return 0;
+}
+
+static s32 ar9170_interpolate_s32(s32 x, s32 x1, s32 y1, s32 x2, s32 y2)
+{
+	/* nothing to interpolate, it's horizontal */
+	if (y2 == y1)
+		return y1;
+
+	/* check if we hit one of the edges */
+	if (x == x1)
+		return y1;
+	if (x == x2)
+		return y2;
+
+	/* x1 == x2 is bad, hopefully == x */
+	if (x2 == x1)
+		return y1;
+
+	return y1 + (((y2 - y1) * (x - x1)) / (x2 - x1));
+}
+
+static u8 ar9170_interpolate_u8(u8 x, u8 x1, u8 y1, u8 x2, u8 y2)
+{
+#define SHIFT		8
+	s32 y;
+
+	y = ar9170_interpolate_s32(x << SHIFT,
+				   x1 << SHIFT, y1 << SHIFT,
+				   x2 << SHIFT, y2 << SHIFT);
+
+	/*
+	 * XXX: unwrap this expression
+	 *	Isn't it just DIV_ROUND_UP(y, 1<<SHIFT)?
+	 *	Can we rely on the compiler to optimise away the div?
+	 */
+	return (y >> SHIFT) + ((y & (1<<(SHIFT-1))) >> (SHIFT - 1));
+#undef SHIFT
+}
+
+static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
+{
+	struct ar9170_calibration_target_power_legacy *ctpl;
+	struct ar9170_calibration_target_power_ht *ctph;
+	u8 *ctpres;
+	int ntargets;
+	int idx, i, n;
+	u8 ackpower, ackchains, f;
+	u8 pwr_freqs[AR5416_MAX_NUM_TGT_PWRS];
+
+	if (freq < 3000)
+		f = freq - 2300;
+	else
+		f = (freq - 4800)/5;
+
+	/*
+	 * cycle through the various modes
+	 *
+	 * legacy modes first: 5G, 2G CCK, 2G OFDM
+	 */
+	for (i = 0; i < 3; i++) {
+		switch (i) {
+		case 0: /* 5 GHz legacy */
+			ctpl = &ar->eeprom.cal_tgt_pwr_5G[0];
+			ntargets = AR5416_NUM_5G_TARGET_PWRS;
+			ctpres = ar->power_5G_leg;
+			break;
+		case 1: /* 2.4 GHz CCK */
+			ctpl = &ar->eeprom.cal_tgt_pwr_2G_cck[0];
+			ntargets = AR5416_NUM_2G_CCK_TARGET_PWRS;
+			ctpres = ar->power_2G_cck;
+			break;
+		case 2: /* 2.4 GHz OFDM */
+			ctpl = &ar->eeprom.cal_tgt_pwr_2G_ofdm[0];
+			ntargets = AR5416_NUM_2G_OFDM_TARGET_PWRS;
+			ctpres = ar->power_2G_ofdm;
+			break;
+		default:
+			BUG();
+		}
+
+		for (n = 0; n < ntargets; n++) {
+			if (ctpl[n].freq == 0xff)
+				break;
+			pwr_freqs[n] = ctpl[n].freq;
+		}
+		ntargets = n;
+		idx = ar9170_find_freq_idx(ntargets, pwr_freqs, f);
+		for (n = 0; n < 4; n++)
+			ctpres[n] = ar9170_interpolate_u8(
+					f,
+					ctpl[idx + 0].freq,
+					ctpl[idx + 0].power[n],
+					ctpl[idx + 1].freq,
+					ctpl[idx + 1].power[n]);
+	}
+
+	/*
+	 * HT modes now: 5G HT20, 5G HT40, 2G CCK, 2G OFDM, 2G HT20, 2G HT40
+	 */
+	for (i = 0; i < 4; i++) {
+		switch (i) {
+		case 0: /* 5 GHz HT 20 */
+			ctph = &ar->eeprom.cal_tgt_pwr_5G_ht20[0];
+			ntargets = AR5416_NUM_5G_TARGET_PWRS;
+			ctpres = ar->power_5G_ht20;
+			break;
+		case 1: /* 5 GHz HT 40 */
+			ctph = &ar->eeprom.cal_tgt_pwr_5G_ht40[0];
+			ntargets = AR5416_NUM_5G_TARGET_PWRS;
+			ctpres = ar->power_5G_ht40;
+			break;
+		case 2: /* 2.4 GHz HT 20 */
+			ctph = &ar->eeprom.cal_tgt_pwr_2G_ht20[0];
+			ntargets = AR5416_NUM_2G_OFDM_TARGET_PWRS;
+			ctpres = ar->power_2G_ht20;
+			break;
+		case 3: /* 2.4 GHz HT 40 */
+			ctph = &ar->eeprom.cal_tgt_pwr_2G_ht40[0];
+			ntargets = AR5416_NUM_2G_OFDM_TARGET_PWRS;
+			ctpres = ar->power_2G_ht40;
+			break;
+		default:
+			BUG();
+		}
+
+		for (n = 0; n < ntargets; n++) {
+			if (ctph[n].freq == 0xff)
+				break;
+			pwr_freqs[n] = ctph[n].freq;
+		}
+		ntargets = n;
+		idx = ar9170_find_freq_idx(ntargets, pwr_freqs, f);
+		for (n = 0; n < 8; n++)
+			ctpres[n] = ar9170_interpolate_u8(
+					f,
+					ctph[idx + 0].freq,
+					ctph[idx + 0].power[n],
+					ctph[idx + 1].freq,
+					ctph[idx + 1].power[n]);
+	}
+
+	/* set ACK/CTS TX power */
+	ar9170_regwrite_begin(ar);
+
+	if (ar->eeprom.tx_mask != 1)
+		ackchains = AR9170_TX_PHY_TXCHAIN_2;
+	else
+		ackchains = AR9170_TX_PHY_TXCHAIN_1;
+
+	if (freq < 3000)
+		ackpower = ar->power_2G_ofdm[0] & 0x3f;
+	else
+		ackpower = ar->power_5G_leg[0] & 0x3f;
+
+	ar9170_regwrite(0x1c3694, ackpower << 20 | ackchains << 26);
+	ar9170_regwrite(0x1c3bb4, ackpower << 5 | ackchains << 11 |
+				  ackpower << 21 | ackchains << 27);
+
+	ar9170_regwrite_finish();
+	return ar9170_regwrite_result();
+}
+
+int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
+		       enum ar9170_rf_init_mode rfi, enum ar9170_bw bw)
+{
+	const struct ar9170_phy_freq_params *freqpar;
+	u32 cmd, tmp, offs;
+	__le32 vals[8];
+	int err;
+	bool bandswitch;
+
+	/* clear BB heavy click enable */
+	err = ar9170_write_reg(ar, 0x1c59e0, 0x200);
+	if (err)
+		return err;
+
+	/* may be NULL at first setup */
+	if (ar->channel)
+		bandswitch = ar->channel->band != channel->band;
+	else
+		bandswitch = true;
+
+	/* HW workaround */
+	if (!ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] &&
+	    channel->center_freq <= 2417)
+		bandswitch = true;
+
+	err = ar9170_exec_cmd(ar, AR9170_CMD_FREQ_START, 0, NULL, 0, NULL);
+	if (err)
+		return err;
+
+	if (rfi != AR9170_RFI_NONE || bandswitch) {
+		u32 val = 0x400;
+
+		if (rfi == AR9170_RFI_COLD)
+			val = 0x800;
+
+		/* warm/cold reset BB/ADDA */
+		err = ar9170_write_reg(ar, 0x1d4004, val);
+		if (err)
+			return err;
+
+		err = ar9170_write_reg(ar, 0x1d4004, 0x0);
+		if (err)
+			return err;
+
+		err = ar9170_init_phy(ar, channel->band);
+		if (err)
+			return err;
+
+		err = ar9170_init_rf_banks_0_7(ar,
+			channel->band == IEEE80211_BAND_5GHZ);
+		if (err)
+			return err;
+
+		cmd = AR9170_CMD_RF_INIT;
+	} else {
+		cmd = AR9170_CMD_FREQUENCY;
+	}
+
+	err = ar9170_init_rf_bank4_pwr(ar,
+		channel->band == IEEE80211_BAND_5GHZ,
+		channel->center_freq, bw);
+	if (err)
+		return err;
+
+	switch (bw) {
+	case AR9170_BW_20:
+		tmp = 0x240;
+		offs = 0;
+		break;
+	case AR9170_BW_40_BELOW:
+		tmp = 0x2c4;
+		offs = 3;
+		break;
+	case AR9170_BW_40_ABOVE:
+		tmp = 0x2d4;
+		offs = 1;
+		break;
+	default:
+		BUG();
+		return -ENOSYS;
+	}
+
+	if (0 /* 2 streams capable */)
+		tmp |= 0x100;
+
+	err = ar9170_write_reg(ar, 0x1c5804, tmp);
+	if (err)
+		return err;
+
+	err = ar9170_set_power_cal(ar, channel->center_freq, bw);
+	if (err)
+		return err;
+
+	freqpar = ar9170_get_hw_dyn_params(channel, bw);
+
+	vals[0] = cpu_to_le32(channel->center_freq * 1000);
+	vals[1] = cpu_to_le32(bw == AR9170_BW_20 ? 0 : 1);
+	vals[2] = cpu_to_le32(offs << 2 | 1);
+	vals[3] = cpu_to_le32(freqpar->coeff_exp);
+	vals[4] = cpu_to_le32(freqpar->coeff_man);
+	vals[5] = cpu_to_le32(freqpar->coeff_exp_shgi);
+	vals[6] = cpu_to_le32(freqpar->coeff_man_shgi);
+	vals[7] = cpu_to_le32(1000);
+
+	err = ar9170_exec_cmd(ar, cmd,
+			      sizeof(vals), (u8 *)vals,
+			      -1, NULL);
+	if (err)
+		return err;
+
+	ar->channel = channel;
+	return 0;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/eeprom.h	2008-11-15 02:19:00.000000000 +0100
@@ -0,0 +1,179 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * EEPROM layout
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __AR9170_EEPROM_H
+#define __AR9170_EEPROM_H
+
+#define AR5416_MAX_CHAINS		2
+#define AR5416_MODAL_SPURS		5
+
+struct ar9170_eeprom_modal {
+	__le32	antCtrlChain[AR5416_MAX_CHAINS];
+	__le32	antCtrlCommon;
+	s8	antennaGainCh[AR5416_MAX_CHAINS];
+	u8	switchSettling;
+	u8	txRxAttenCh[AR5416_MAX_CHAINS];
+	u8	rxTxMarginCh[AR5416_MAX_CHAINS];
+	s8	adcDesiredSize;
+	s8	pgaDesiredSize;
+	u8	xlnaGainCh[AR5416_MAX_CHAINS];
+	u8	txEndToXpaOff;
+	u8	txEndToRxOn;
+	u8	txFrameToXpaOn;
+	u8	thresh62;
+	s8	noiseFloorThreshCh[AR5416_MAX_CHAINS];
+	u8	xpdGain;
+	u8	xpd;
+	s8	iqCalICh[AR5416_MAX_CHAINS];
+	s8	iqCalQCh[AR5416_MAX_CHAINS];
+	u8	pdGainOverlap;
+	u8	ob;
+	u8	db;
+	u8	xpaBiasLvl;
+	u8	pwrDecreaseFor2Chain;
+	u8	pwrDecreaseFor3Chain;
+	u8	txFrameToDataStart;
+	u8	txFrameToPaOn;
+	u8	ht40PowerIncForPdadc;
+	u8	bswAtten[AR5416_MAX_CHAINS];
+	u8	bswMargin[AR5416_MAX_CHAINS];
+	u8	swSettleHt40;
+	u8	reserved[22];
+	struct spur_channel {
+		__le16 spurChan;
+		u8	spurRangeLow;
+		u8	spurRangeHigh;
+	} __packed spur_channels[AR5416_MODAL_SPURS];
+} __packed;
+
+#define AR5416_NUM_PD_GAINS		4
+#define AR5416_PD_GAIN_ICEPTS		5
+
+struct ar9170_calibration_data_per_freq {
+	u8	pwr_pdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	u8	vpd_pdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+} __packed;
+
+#define AR5416_NUM_5G_CAL_PIERS		8
+#define AR5416_NUM_2G_CAL_PIERS		4
+
+#define AR5416_NUM_5G_TARGET_PWRS	8
+#define AR5416_NUM_2G_CCK_TARGET_PWRS	3
+#define AR5416_NUM_2G_OFDM_TARGET_PWRS	4
+#define AR5416_MAX_NUM_TGT_PWRS		8
+
+struct ar9170_calibration_target_power_legacy {
+	u8	freq;
+	u8	power[4];
+} __packed;
+
+struct ar9170_calibration_target_power_ht {
+	u8	freq;
+	u8	power[8];
+} __packed;
+
+#define AR5416_NUM_CTLS			24
+
+struct ar9170_calctl_edges {
+	u8	channel;
+#define AR9170_CALCTL_EDGE_FLAGS	0xC0
+	u8	power_flags;
+} __packed;
+
+#define AR5416_NUM_BAND_EDGES		8
+
+struct ar9170_calctl_data {
+	struct ar9170_calctl_edges
+		control_edges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
+} __packed;
+
+
+struct ar9170_eeprom {
+	__le16	length;
+	__le16	checksum;
+	__le16	version;
+	u8	operating_flags;
+#define AR9170_OPFLAG_5GHZ 		1
+#define AR9170_OPFLAG_2GHZ 		2
+	u8	misc;
+	__le16	reg_domain[2];
+	u8	mac_address[6];
+	u8	rx_mask;
+	u8	tx_mask;
+	__le16	rf_silent;
+	__le16	bluetooth_options;
+	__le16	device_capabilities;
+	__le32	build_number;
+	u8	deviceType;
+	u8	reserved[33];
+
+	u8	customer_data[64];
+
+	struct ar9170_eeprom_modal
+		modal_header[2];
+
+	u8	cal_freq_pier_5G[AR5416_NUM_5G_CAL_PIERS];
+	u8	cal_freq_pier_2G[AR5416_NUM_2G_CAL_PIERS];
+
+	struct ar9170_calibration_data_per_freq
+		cal_pier_data_5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS],
+		cal_pier_data_2G[AR5416_MAX_CHAINS][AR5416_NUM_2G_CAL_PIERS];
+
+	/* power calibration data */
+	struct ar9170_calibration_target_power_legacy
+		cal_tgt_pwr_5G[AR5416_NUM_5G_TARGET_PWRS];
+	struct ar9170_calibration_target_power_ht
+		cal_tgt_pwr_5G_ht20[AR5416_NUM_5G_TARGET_PWRS],
+		cal_tgt_pwr_5G_ht40[AR5416_NUM_5G_TARGET_PWRS];
+
+	struct ar9170_calibration_target_power_legacy
+		cal_tgt_pwr_2G_cck[AR5416_NUM_2G_CCK_TARGET_PWRS],
+		cal_tgt_pwr_2G_ofdm[AR5416_NUM_2G_OFDM_TARGET_PWRS];
+	struct ar9170_calibration_target_power_ht
+		cal_tgt_pwr_2G_ht20[AR5416_NUM_2G_OFDM_TARGET_PWRS],
+		cal_tgt_pwr_2G_ht40[AR5416_NUM_2G_OFDM_TARGET_PWRS];
+
+	/* conformance testing limits */
+	u8	ctl_index[AR5416_NUM_CTLS];
+	struct ar9170_calctl_data
+		ctl_data[AR5416_NUM_CTLS];
+
+	u8	pad;
+	__le16	subsystem_id;
+} __packed;
+
+#endif /* __AR9170_EEPROM_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/ar9170/cmd.c	2008-11-15 11:32:13.000000000 +0100
@@ -0,0 +1,149 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * Basic USB HW access functions
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ar9170.h"
+
+int ar9170_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
+		    int plen, u8 *payload, int outlen, u8 *out)
+{
+	int err, actual;
+	unsigned long flags;
+
+	WARN_ON(!mutex_is_locked(&ar->mutex));
+
+	if (WARN_ON(plen > AR9170_MAX_CMD_LEN - 4))
+		return -EINVAL;
+
+	ar->cmdbuf[0] = cpu_to_le32(plen);
+	ar->cmdbuf[0] |= cpu_to_le32(cmd << 8);
+	/* writing multiple regs fills this buffer already */
+	if (plen && payload != (u8 *)(&ar->cmdbuf[1]))
+		memcpy(&ar->cmdbuf[1], payload, plen);
+
+	spin_lock_irqsave(&ar->cmdlock, flags);
+	init_completion(&ar->cmd_wait);
+	ar->readbuf = (u8 *)out;
+	ar->readlen = outlen;
+	spin_unlock_irqrestore(&ar->cmdlock, flags);
+
+	err = usb_interrupt_msg(ar->udev,
+				usb_sndbulkpipe(ar->udev, AR9170_EP_CMD),
+				ar->cmdbuf, plen + 4, &actual, 1000);
+	if (err)
+		return err;
+
+	err = wait_for_completion_timeout(&ar->cmd_wait, HZ/5);
+	if (err == 0)
+		err = -ETIMEDOUT;
+	if (err < 0) {
+		dump_stack();
+		/* invalidate to avoid completing the next prematurely */
+		spin_lock_irqsave(&ar->cmdlock, flags);
+		ar->readbuf = NULL;
+		ar->readlen = -1;
+		spin_unlock_irqrestore(&ar->cmdlock, flags);
+		return err;
+	}
+
+	if (outlen >= 0 && ar->readlen != outlen)
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val)
+{
+	__le32 buf[2] = {
+		cpu_to_le32(reg),
+		cpu_to_le32(val),
+	};
+
+	return ar9170_exec_cmd(ar, AR9170_CMD_WREG,
+			       8, (u8 *) buf,
+			       0, NULL);
+}
+
+static int ar9170_read_mreg(struct ar9170 *ar, int nregs,
+			    const u32 *regs, u32 *out)
+{
+	int i, err;
+	__le32 *offs, *res;
+
+	/* abuse "out" for the register offsets, must be same length */
+	offs = (__le32 *)out;
+	for (i = 0; i < nregs; i++)
+		offs[i] = cpu_to_le32(regs[i]);
+
+	/* also use the same buffer for the input */
+	res = (__le32 *)out;
+
+	err = ar9170_exec_cmd(ar, AR9170_CMD_RREG,
+			      4 * nregs, (u8 *)offs,
+			      4 * nregs, (u8 *)res);
+	if (err)
+		return err;
+
+	/* convert result to cpu endian */
+	for (i = 0; i < nregs; i++)
+		out[i] = le32_to_cpu(res[i]);
+
+	return 0;
+}
+
+int ar9170_read_reg(struct ar9170 *ar, u32 reg, u32 *val)
+{
+	return ar9170_read_mreg(ar, 1, &reg, val);
+}
+
+int ar9170_echo_test(struct ar9170 *ar, u32 v)
+{
+	__le32 echobuf = cpu_to_le32(v);
+	__le32 echores;
+	int err;
+
+	err = ar9170_exec_cmd(ar, AR9170_CMD_ECHO,
+			      4, (u8 *)&echobuf,
+			      4, (u8 *)&echores);
+	if (err)
+		return err;
+
+	if (echobuf != echores)
+		return -EINVAL;
+
+	return 0;
+}
--- everything.orig/MAINTAINERS	2008-11-13 14:09:17.000000000 +0100
+++ everything/MAINTAINERS	2008-11-13 14:11:00.000000000 +0100
@@ -435,6 +435,12 @@ M:	johannes@sipsolutions.net
 L:	linux-input@vger.kernel.org
 S:	Maintained
 
+AR9170 ATHEROS 802.11N USB WIRELESS DRIVER
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+
 ARC FRAMEBUFFER DRIVER
 P:	Jaya Kumar
 M:	jayalk@intworks.biz


