Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbbKLTrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:47:41 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: David Lin <dlin@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>, Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
Date: Thu, 12 Nov 2015 14:47:40 -0500
In-Reply-To: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com> (David
	Lin's message of "Thu, 12 Nov 2015 03:51:03 +0000")
Message-ID: <wrfjh9kryp7n.fsf@redhat.com> (sfid-20151112_204747_499721_534CCBBC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@marvell.com> writes:
> This patch provides the mwlwifi driver for Marvell 8863, 8864 and 8897
> chipsets.
> This driver was developed as part of the openwrt.org project to support
> Linksys WRT1900AC and is maintained on https://github.com/kaloz/mwlwifi.
>
> The mwlwifi driver differs from existing mwifiex driver:
> o mwlwifi is a "softmac driver" using the kernel? mac802.11 subsystem
> to provide full AP/Wireless Bridge functionality (routers).
> o mwifiex is a "fullmac driver" which provides a comprehensive set of
> client functions (laptops/embedded devices)
> o only mwlwifi supports Marvell AP chip 886X series
>
> NOTE: Users with Marvell 88W8897 chipsets currently should enable
> (CONFIG=Y or M) either CONFIG_MWIFIEX or CONFIG_MWLWIFI, NOT BOTH.

I didn't get very far reading through this - but there was a few bits
that stood out like a sore thumb.

> mwlwifi driver leveraged code from existing MWL8K driver in the
> following areas:
> - 802.11n setting for mac80211
> - Functions needed to hook up to mac80211
> - Interactions with mac80211 to establish BA streams
> - Partial firmware APIs, some data fields
> - Method to pass Rx packets to mac80211 except 11ac rates
>
> In addition, mwlwifi driver supports:
> - future scalability and future development (refactored source code)
> - Marvell 802.11ac chipsets, including combo BT devices
> - 802.11ac related settings and functions
> - concurrent AP+STA functionalities with single firmware per chip
> - firmware APIs for the supported chipset
> - communicating new mac80211 settings to firmware
> - Different TX/RX datapath where applicable
> - A-MSDU and A-MPDU
> - mac80211-based MESH (work in progress)
> - Refined the code to establish BA streams
>
> NOTE: MWLWIFI will be organized under new vendor specific folder/marvell,
> as per request of the gate keeper and community.
>
> Signed-off-by: David Lin <dlin@marvell.com>
> ---
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 27b27c0..7c32f0a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6629,6 +6629,12 @@ L:	linux-wireless@vger.kernel.org
>  S:	Odd Fixes
>  F:	drivers/net/wireless/mwl8k.c
>  
> +MARVELL MWLWIFI WIRELESS DRIVER
> +M:	David Lin <dlin@marvell.com>
> +L:	linux-wireless@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/wireless/marvell/mwlwifi
> +
>  MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
>  M:	Nicolas Pitre <nico@fluxnic.net>
>  S:	Odd Fixes
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index f9f9422..d599b35 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -285,5 +285,6 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
>  source "drivers/net/wireless/mwifiex/Kconfig"
>  source "drivers/net/wireless/cw1200/Kconfig"
>  source "drivers/net/wireless/rsi/Kconfig"
> +source "drivers/net/wireless/marvell/Kconfig"
>  
>  endif # WLAN
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 740fdd3..71504a7 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -60,3 +60,5 @@ obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
>  
>  obj-$(CONFIG_CW1200)	+= cw1200/
>  obj-$(CONFIG_RSI_91X)	+= rsi/
> +
> +obj-$(CONFIG_WL_MARVELL)	+= marvell/
> diff --git a/drivers/net/wireless/marvell/Kconfig
> b/drivers/net/wireless/marvell/Kconfig
> new file mode 100644
> index 0000000..d73e642
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/Kconfig
> @@ -0,0 +1,8 @@
> +menuconfig WL_MARVELL
> +	bool "Marvell Wireless LAN support"
> +	---help---
> +	  Enable community drivers for Marvell Wi-Fi devices.
> +
> +if WL_MARVELL
> +source "drivers/net/wireless/marvell/mwlwifi/Kconfig"
> +endif # WL_MARVELL
> diff --git a/drivers/net/wireless/marvell/Makefile
> b/drivers/net/wireless/marvell/Makefile
> new file mode 100644
> index 0000000..70d1b3f
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_MWLWIFI)	+= mwlwifi/
> diff --git a/drivers/net/wireless/marvell/mwlwifi/Kconfig
> b/drivers/net/wireless/marvell/mwlwifi/Kconfig
> new file mode 100644
> index 0000000..a9bcb9c
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/Kconfig
> @@ -0,0 +1,23 @@
> +config MWLWIFI
> + tristate "Marvell Avastar 88W8864/88W8897 PCIe driver (mac80211
> compatible)"
> +	depends on PCI && MAC80211
> +	select FW_LOADER
> +	---help---
> +		Select to build the driver supporting the:
> +
> +		Marvell Wireless Wi-Fi 88W8864 modules
> +		Marvell Wireless Wi-Fi 88W8897 modules
> +
> +		This driver uses the kernel's mac80211 subsystem.
> +
> + If you want to compile the driver as a module (= code which can be
> + inserted in and removed from the running kernel whenever you want),
> + say M here and read <file:Documentation/kbuild/modules.txt>.  The
> +		module will be called mwlwifi.
> +
> + NOTE: Selecting this driver may cause conflict with MWIFIEX driver
> +		that also operates on the same part number 88W8897. Users should
> +		select either MWIFIEX or MWLWIFI, not both. MWIFIEX is fullmac,
> + supporting more comprehensive client functions for laptops/embedded
> +		devices. MWLWIFI is mac80211-based for full AP/Wireless Bridge.
> +
> diff --git a/drivers/net/wireless/marvell/mwlwifi/Makefile
> b/drivers/net/wireless/marvell/mwlwifi/Makefile
> new file mode 100644
> index 0000000..88f7efd
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/Makefile
> @@ -0,0 +1,12 @@
> +obj-$(CONFIG_MWLWIFI)	+= mwlwifi.o
> +
> +mwlwifi-objs		+= main.o
> +mwlwifi-objs		+= mac80211.o
> +mwlwifi-objs		+= fwdl.o
> +mwlwifi-objs		+= fwcmd.o
> +mwlwifi-objs		+= tx.o
> +mwlwifi-objs		+= rx.o
> +mwlwifi-objs		+= isr.o
> +mwlwifi-$(CONFIG_DEBUG_FS) += debugfs.o
> +
> +ccflags-y += -D__CHECK_ENDIAN__
> diff --git a/drivers/net/wireless/marvell/mwlwifi/debugfs.c
> b/drivers/net/wireless/marvell/mwlwifi/debugfs.c
> new file mode 100644
> index 0000000..997461a
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/debugfs.c
> @@ -0,0 +1,433 @@
> +/*
> + * Copyright (C) 2006-2015, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell International
> + * Ltd. under the terms of the GNU General Public License Version 2, June 1991
> + * (the "License").  You may use, redistribute and/or modify this File in
> + * accordance with the terms and conditions of the License, a copy of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file implements debug fs related functions. */
> +
> +#include <linux/debugfs.h>
> +
> +#include "sysadpt.h"
> +#include "dev.h"
> +#include "hostcmd.h"
> +#include "fwcmd.h"
> +#include "debugfs.h"
> +
> +#define MWLWIFI_DEBUGFS_ADD_FILE(name) do { \
> +	if (!debugfs_create_file(#name, 0644, priv->debugfs_phy, \
> +				 priv, &mwl_debugfs_##name##_fops)) \
> +		return; \
> +} while (0)

This macros relies on implicit arguments which is just bad and doesn't
really do anything except for obfuscating the code.

> +#define MWLWIFI_DEBUGFS_FILE_OPS(name) \
> +static const struct file_operations mwl_debugfs_##name##_fops = { \
> +	.read = mwl_debugfs_##name##_read, \
> +	.write = mwl_debugfs_##name##_write, \
> +	.open = simple_open, \
> +}
> +
> +#define MWLWIFI_DEBUGFS_FILE_READ_OPS(name) \
> +static const struct file_operations mwl_debugfs_##name##_fops = { \
> +	.read = mwl_debugfs_##name##_read, \
> +	.open = simple_open, \
> +}
> +
> +#define MWLWIFI_DEBUGFS_FILE_WRITE_OPS(name) \
> +static const struct file_operations mwl_debugfs_##name##_fops = { \
> +	.write = mwl_debugfs_##name##_write, \
> +	.open = simple_open, \
> +}

Again here - you use thiese wrappers once, just declare the structs
explicitly rather than this macro wrapping dance.

> +static int print_mac_addr(char *p, u8 *mac_addr)
> +{
> +	int i;
> +	char *str = p;
> +
> +	str += sprintf(str, "mac address: %02x", mac_addr[0]);
> +	for (i = 1; i < ETH_ALEN; i++)
> +		str += sprintf(str, ":%02x", mac_addr[i]);
> +	str += sprintf(str, "\n");
> +
> +	return (str - p);
> +}
> +
> +static int dump_data(char *p, u8 *data, int len, char *title)
> +{
> +	char *str = p;
> +	int cur_byte = 0;
> +	int i;
> +
> +	str += sprintf(str, "%s\n", title);
> +	for (cur_byte = 0; cur_byte < len; cur_byte += 8) {
> +		if ((cur_byte + 8) < len) {
> +			for (i = 0; i < 8; i++)
> +				str += sprintf(str, "0x%02x ",
> +					       *(data + cur_byte + i));
> +			str += sprintf(str, "\n");
> +		} else {
> +			for (i = 0; i < (len - cur_byte); i++)
> +				str += sprintf(str, "0x%02x ",
> +					       *(data + cur_byte + i));
> +			str += sprintf(str, "\n");
> +			break;
> +		}
> +	}
> +
> +	return (str - p);
> +}
> +
> +static ssize_t mwl_debugfs_info_read(struct file *file, char __user *ubuf,
> +				     size_t count, loff_t *ppos)
> +{
> +	struct mwl_priv *priv = (struct mwl_priv *)file->private_data;
> +	unsigned long page = get_zeroed_page(GFP_KERNEL);
> +	char *p = (char *)page;
> +	ssize_t ret;
> +
> +	if (!p)
> +		return -ENOMEM;
> +
> +	p += sprintf(p, "\n");
> +	p += sprintf(p, "driver name: %s\n", MWL_DRV_NAME);
> +	p += sprintf(p, "chip type: %s\n",
> +		     (priv->chip_type == MWL8864) ? "88W8864" : "88W8897");
> +	p += sprintf(p, "hw version: %X\n", priv->hw_data.hw_version);
> +	p += sprintf(p, "driver version: %s\n", MWL_DRV_VERSION);
> +	p += sprintf(p, "firmware version: 0x%08x\n",
> +		     priv->hw_data.fw_release_num);
> +	p += print_mac_addr(p, priv->hw_data.mac_addr);
> +	p += sprintf(p, "2g: %s\n", priv->disable_2g ? "disable" : "enable");
> +	p += sprintf(p, "5g: %s\n", priv->disable_5g ? "disable" : "enable");
> +	p += sprintf(p, "antenna: %d %d\n",
> +		     (priv->antenna_tx == ANTENNA_TX_4_AUTO) ? 4 : 2,
> +		     (priv->antenna_rx == ANTENNA_TX_4_AUTO) ? 4 : 2);
> +	p += sprintf(p, "irq number: %d\n", priv->irq);
> +	p += sprintf(p, "iobase0: %p\n", priv->iobase0);
> +	p += sprintf(p, "iobase1: %p\n", priv->iobase1);
> +	p += sprintf(p, "tx limit: %d\n", priv->txq_limit);
> +	p += sprintf(p, "rx limit: %d\n", priv->recv_limit);
> +	p += sprintf(p, "ap macid support: %08x\n",
> +		     priv->ap_macids_supported);
> +	p += sprintf(p, "sta macid support: %08x\n",
> +		     priv->sta_macids_supported);
> +	p += sprintf(p, "macid used: %08x\n", priv->macids_used);
> +	p += sprintf(p, "mfg mode: %s\n", priv->mfg_mode ? "true" : "false");
> +	p += sprintf(p, "\n");
> +
> +	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
> +				      (unsigned long)p - page);
> +	free_page(page);
> +
> +	return ret;
> +}
> +
> +static ssize_t mwl_debugfs_vif_read(struct file *file, char __user *ubuf,
> +				    size_t count, loff_t *ppos)
> +{
> +	struct mwl_priv *priv = (struct mwl_priv *)file->private_data;
> +	unsigned long page = get_zeroed_page(GFP_KERNEL);
> +	char *p = (char *)page;
> +	struct mwl_vif *mwl_vif;
> +	struct ieee80211_vif *vif;
> +	char ssid[IEEE80211_MAX_SSID_LEN + 1];
> +	ssize_t ret;
> +
> +	if (!p)
> +		return -ENOMEM;
> +
> +	p += sprintf(p, "\n");
> +	spin_lock_bh(&priv->vif_lock);
> +	list_for_each_entry(mwl_vif, &priv->vif_list, list) {
> +		vif = container_of((char *)mwl_vif, struct ieee80211_vif,
> +				   drv_priv[0]);
> +		p += sprintf(p, "macid: %d\n", mwl_vif->macid);
> +		switch (vif->type) {
> +		case NL80211_IFTYPE_AP:
> +			p += sprintf(p, "type: ap\n");
> +			memcpy(ssid, vif->bss_conf.ssid,
> +			       vif->bss_conf.ssid_len);
> +			ssid[vif->bss_conf.ssid_len] = 0;
> +			p += sprintf(p, "ssid: %s\n", ssid);
> +			p += print_mac_addr(p, mwl_vif->bssid);
> +			break;
> +		case NL80211_IFTYPE_MESH_POINT:
> +			p += sprintf(p, "type: mesh\n");
> +			p += print_mac_addr(p, mwl_vif->bssid);
> +			break;
> +		case NL80211_IFTYPE_STATION:
> +			p += sprintf(p, "type: sta\n");
> +			p += print_mac_addr(p, mwl_vif->sta_mac);
> +			break;
> +		default:
> +			p += sprintf(p, "type: unknown\n");
> +			break;
> +		}
> +		p += sprintf(p, "hw_crypto_enabled: %s\n",
> +			     mwl_vif->is_hw_crypto_enabled ? "true" : "false");
> +		p += sprintf(p, "key idx: %d\n", mwl_vif->keyidx);
> +		p += sprintf(p, "IV: %08x%04x\n", mwl_vif->iv32, mwl_vif->iv16);
> +		p += dump_data(p, mwl_vif->beacon_info.ie_wmm_ptr,
> +			       mwl_vif->beacon_info.ie_wmm_len, "WMM:");
> +		p += dump_data(p, mwl_vif->beacon_info.ie_rsn_ptr,
> +			       mwl_vif->beacon_info.ie_rsn_len, "RSN:");
> +		p += dump_data(p, mwl_vif->beacon_info.ie_rsn48_ptr,
> +			       mwl_vif->beacon_info.ie_rsn48_len, "RSN48:");
> +		p += dump_data(p, mwl_vif->beacon_info.ie_ht_ptr,
> +			       mwl_vif->beacon_info.ie_ht_len, "HT:");
> +		p += dump_data(p, mwl_vif->beacon_info.ie_vht_ptr,
> +			       mwl_vif->beacon_info.ie_vht_len, "VHT:");
> +		p += sprintf(p, "\n");
> +	}
> +	spin_unlock_bh(&priv->vif_lock);

I hope there is no way that the number of vifs can get to the point
where you overflow the page allocated since there is no cap on the
sprintf() usage in dump_data().

> +
> +MWLWIFI_DEBUGFS_FILE_READ_OPS(info);
> +MWLWIFI_DEBUGFS_FILE_READ_OPS(vif);
> +MWLWIFI_DEBUGFS_FILE_READ_OPS(sta);
> +MWLWIFI_DEBUGFS_FILE_READ_OPS(ampdu);
> +MWLWIFI_DEBUGFS_FILE_OPS(regrdwr);
> +
> +void mwl_debugfs_init(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +
> +	if (!priv->debugfs_phy)
> +		priv->debugfs_phy = debugfs_create_dir("mwlwifi",
> +						       hw->wiphy->debugfsdir);
> +
> +	if (!priv->debugfs_phy)
> +		return;
> +
> +	MWLWIFI_DEBUGFS_ADD_FILE(info);
> +	MWLWIFI_DEBUGFS_ADD_FILE(vif);
> +	MWLWIFI_DEBUGFS_ADD_FILE(sta);
> +	MWLWIFI_DEBUGFS_ADD_FILE(ampdu);
> +	MWLWIFI_DEBUGFS_ADD_FILE(regrdwr);
> +}
> +
> +void mwl_debugfs_remove(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +
> +	debugfs_remove(priv->debugfs_phy);
> +	priv->debugfs_phy = NULL;
> +}
> diff --git a/drivers/net/wireless/marvell/mwlwifi/debugfs.h
> b/drivers/net/wireless/marvell/mwlwifi/debugfs.h
> new file mode 100644
> index 0000000..dfc2a3c
> --- /dev/null
> +++ b/drivers/net/wireless/marvell/mwlwifi/debugfs.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2006-2015, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell International
> + * Ltd. under the terms of the GNU General Public License Version 2, June 1991
> + * (the "License").  You may use, redistribute and/or modify this File in
> + * accordance with the terms and conditions of the License, a copy of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file defines debug fs related functions. */
> +
> +#ifndef _debugfs_h_
> +#define _debugfs_h_

The general convention is to user upper-case for the these - not a
biggie though.

> +struct mwl_priv {
> +	struct ieee80211_hw *hw;
> +	struct firmware *fw_ucode;
> +	int chip_type;
> +
> +	struct device_node *dt_node;
> +	struct device_node *pwr_node;
> +	bool disable_2g;
> +	bool disable_5g;
> +	int antenna_tx;
> +	int antenna_rx;
> +
> +	struct mwl_tx_pwr_tbl tx_pwr_tbl[SYSADPT_MAX_NUM_CHANNELS];
> +	bool cdd;
> +	u16 txantenna2;
> +	u8 powinited;
> +	u16 max_tx_pow[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* max tx power (dBm) */
> +	u16 target_powers[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* target powers   */
> +	u8 cal_tbl[200];
> +
> +	struct pci_dev *pdev;
> +	void __iomem *iobase0; /* MEM Base Address Register 0  */
> +	void __iomem *iobase1; /* MEM Base Address Register 1  */
> +	u32 next_bar_num;
> +
> +	spinlock_t fwcmd_lock;       /* for firmware command         */
> +	unsigned short *pcmd_buf;    /* pointer to CmdBuf (virtual)  */
> +	dma_addr_t pphys_cmd_buf;    /* pointer to CmdBuf (physical) */
> +	bool in_send_cmd;
> +
> +	int irq;
> +	struct mwl_hw_data hw_data;  /* Adapter HW specific info     */
> +
> +	/* various descriptor data */
> +	spinlock_t tx_desc_lock;     /* for tx descriptor data       */
> +	spinlock_t rx_desc_lock;     /* for rx descriptor data       */

You probably don't want to declare these two right next to each other,
if you expect the RX and TX paths of the code to be able to run in
parallel.

Spin locks are not guaranteed to be cache line aligned or cache line
sized, so you can end up with cache line ping pongs between CPUs in this
case.

> +	struct mwl_desc_data desc_data[SYSADPT_NUM_OF_DESC_DATA];
> +	struct sk_buff_head txq[SYSADPT_NUM_OF_DESC_DATA];
> +	struct sk_buff_head delay_q;
> +	/* number of descriptors owned by fw at any one time */
> +	int fw_desc_cnt[SYSADPT_NUM_OF_DESC_DATA];
> +
> +	struct tasklet_struct tx_task;
> +	struct tasklet_struct rx_task;
> +	struct tasklet_struct qe_task;
> +	int txq_limit;
> +	bool is_tx_schedule;
> +	int recv_limit;
> +	bool is_rx_schedule;
> +	bool is_qe_schedule;
> +	s8 noise;                    /* Most recently reported noise in dBm */
> +	struct ieee80211_supported_band band_24;
> +	struct ieee80211_channel channels_24[BAND_24_CHANNEL_NUM];
> +	struct ieee80211_rate rates_24[BAND_24_RATE_NUM];
> +	struct ieee80211_supported_band band_50;
> +	struct ieee80211_channel channels_50[BAND_50_CHANNEL_NUM];
> +	struct ieee80211_rate rates_50[BAND_50_RATE_NUM];
> +
> +	u32 ap_macids_supported;
> +	u32 sta_macids_supported;
> +	u32 macids_used;
> +	spinlock_t vif_lock;         /* for private interface info   */
> +	struct list_head vif_list;   /* List of interfaces.          */
> +	u32 running_bsses;           /* bitmap of running BSSes      */
> +
> +	spinlock_t sta_lock;         /* for private sta info         */
> +	struct list_head sta_list;   /* List of stations             */

These two are awfully close together too. You might just get away with
it on x86_64, given list_head is 16 bytes, but the x86_64 packing rules
are odd, so I am never quite sure. On x86_32 it will certainly bite you
- provided vif_lock and sta_lock can get taken from two different paths.

> +
> +	bool radio_on;
> +	bool radio_short_preamble;
> +	bool wmm_enabled;
> +	struct ieee80211_tx_queue_params wmm_params[SYSADPT_TX_WMM_QUEUES];
> +
> +	/* Ampdu stream information */
> +	u8 num_ampdu_queues;
> +	spinlock_t stream_lock;      /* for ampdu stream             */
> +	struct mwl_ampdu_stream ampdu[SYSADPT_TX_AMPDU_QUEUES];
> +	struct work_struct watchdog_ba_handle;
> +
> +	bool mfg_mode;
> +
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *debugfs_phy;
> +	u32 reg_type;
> +	u32 reg_offset;
> +	u32 reg_value;
> +#endif
> +};
[snip]

> +static void mwl_fwcmd_parse_beacon(struct mwl_priv *priv,
> +				   struct mwl_vif *vif, u8 *beacon, int len)
> +{
> +	struct ieee80211_mgmt *mgmt;
> +	struct beacon_info *beacon_info;
> +	int baselen;
> +	u8 *pos;
> +	size_t left;
> +	bool elem_parse_failed;
> +
> +	mgmt = (struct ieee80211_mgmt *)beacon;
> +
> +	baselen = (u8 *)mgmt->u.beacon.variable - (u8 *)mgmt;
> +	if (baselen > len)
> +		return;
> +
> +	beacon_info = &vif->beacon_info;
> +	memset(beacon_info, 0, sizeof(struct beacon_info));
> +	beacon_info->valid = false;
> +	beacon_info->ie_ht_ptr = &beacon_info->ie_list_ht[0];
> +	beacon_info->ie_vht_ptr = &beacon_info->ie_list_vht[0];
> +
> +	beacon_info->cap_info = le16_to_cpu(mgmt->u.beacon.capab_info);
> +
> +	pos = (u8 *)mgmt->u.beacon.variable;
> +	left = len - baselen;
> +
> +	elem_parse_failed = false;
> +
> +	while (left >= 2) {
> +		u8 id, elen;
> +
> +		id = *pos++;
> +		elen = *pos++;
> +		left -= 2;
> +
> +		if (elen > left) {
> +			elem_parse_failed = true;
> +			break;
> +		}
> +
> +		switch (id) {
> +		case WLAN_EID_SUPP_RATES:
> +		case WLAN_EID_EXT_SUPP_RATES:
> +			{
> +			int idx, bi, oi;
> +			u8 rate;
> +
> +			for (bi = 0; bi < SYSADPT_MAX_DATA_RATES_G;
> +			     bi++) {
> +				if (beacon_info->b_rate_set[bi] == 0)
> +					break;
> +			}
> +
> +			for (oi = 0; oi < SYSADPT_MAX_DATA_RATES_G;
> +			     oi++) {
> +				if (beacon_info->op_rate_set[oi] == 0)
> +					break;
> +			}
> +
> +			for (idx = 0; idx < elen; idx++) {
> +				rate = pos[idx];
> +				if ((rate & 0x80) != 0) {
> +					if (bi < SYSADPT_MAX_DATA_RATES_G)
> +						beacon_info->b_rate_set[bi++]
> +							= rate & 0x7f;
> +					else {
> +						elem_parse_failed = true;
> +						break;
> +					}
> +				}
> +				if (oi < SYSADPT_MAX_DATA_RATES_G)
> +					beacon_info->op_rate_set[oi++] =
> +						rate & 0x7f;
> +				else {
> +					elem_parse_failed = true;
> +					break;
> +				}
> +			}
> +			}
> +			break;
> +		case WLAN_EID_RSN:
> +			beacon_info->ie_rsn48_len = (elen + 2);
> +			beacon_info->ie_rsn48_ptr = (pos - 2);
> +			break;
> +		case WLAN_EID_HT_CAPABILITY:
> +		case WLAN_EID_HT_OPERATION:
> +		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
> +		case WLAN_EID_EXT_CAPABILITY:
> +			beacon_info->ie_ht_len += (elen + 2);
> +			if (beacon_info->ie_ht_len >
> +			    sizeof(beacon_info->ie_list_ht)) {
> +				elem_parse_failed = true;
> +			} else {
> +				*beacon_info->ie_ht_ptr++ = id;
> +				*beacon_info->ie_ht_ptr++ = elen;
> +				memcpy(beacon_info->ie_ht_ptr, pos, elen);
> +				beacon_info->ie_ht_ptr += elen;
> +			}
> +			break;
> +#ifdef CONFIG_MAC80211_MESH
> +		case WLAN_EID_MESH_CONFIG:
> +			beacon_info->ie_meshcfg_len = (elen + 2);
> +			beacon_info->ie_meshcfg_ptr = (pos - 2);
> +			break;
> +		case WLAN_EID_MESH_ID:
> +			beacon_info->ie_meshid_len = (elen + 2);
> +			beacon_info->ie_meshid_ptr = (pos - 2);
> +			break;
> +		case WLAN_EID_CHAN_SWITCH_PARAM:
> +			beacon_info->ie_meshchsw_len = (elen + 2);
> +			beacon_info->ie_meshchsw_ptr = (pos - 2);
> +			break;
> +#endif
> +		case WLAN_EID_VHT_CAPABILITY:
> +		case WLAN_EID_VHT_OPERATION:
> +		case WLAN_EID_OPMODE_NOTIF:
> +			beacon_info->ie_vht_len += (elen + 2);
> +			if (beacon_info->ie_vht_len >
> +			    sizeof(beacon_info->ie_list_vht)) {
> +				elem_parse_failed = true;
> +			} else {
> +				*beacon_info->ie_vht_ptr++ = id;
> +				*beacon_info->ie_vht_ptr++ = elen;
> +				memcpy(beacon_info->ie_vht_ptr, pos, elen);
> +				beacon_info->ie_vht_ptr += elen;
> +			}
> +			break;
> +		case WLAN_EID_VENDOR_SPECIFIC:
> +			if ((pos[0] == 0x00) && (pos[1] == 0x50) &&
> +			    (pos[2] == 0xf2)) {
> +				if (pos[3] == 0x01) {
> +					beacon_info->ie_rsn_len = (elen + 2);
> +					beacon_info->ie_rsn_ptr = (pos - 2);
> +				}
> +
> +				if (pos[3] == 0x02) {
> +					beacon_info->ie_wmm_len = (elen + 2);
> +					beacon_info->ie_wmm_ptr = (pos - 2);
> +				}
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		left -= elen;
> +		pos += elen;
> +	}
> +
> +	if (!elem_parse_failed) {
> +		beacon_info->ie_ht_ptr = &beacon_info->ie_list_ht[0];
> +		beacon_info->ie_vht_ptr = &beacon_info->ie_list_vht[0];
> +		beacon_info->valid = true;
> +	}
> +}

Any reason you're not using cfg80211_find_ie() here? Seems to be
re-inventing the wheel to me.

> +void mwl_fwcmd_reset(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +
> +	if (mwl_fwcmd_chk_adapter(priv))
> +		writel(ISR_RESET,
> +		       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
> +}
> +
> +void mwl_fwcmd_int_enable(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +
> +	if (mwl_fwcmd_chk_adapter(priv)) {
> +		writel(0x00,
> +		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);
> +		writel((MACREG_A2HRIC_BIT_MASK),
> +		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);

Please avoid superfluous use of parentheses.

> +int mwl_fwcmd_get_hw_specs(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +	struct hostcmd_cmd_get_hw_spec *pcmd;
> +	int retry;
> +	int i;
> +
> +	if (priv->mfg_mode)
> +		return 0;
> +
> +	pcmd = (struct hostcmd_cmd_get_hw_spec *)&priv->pcmd_buf[0];
> +
> +	spin_lock_bh(&priv->fwcmd_lock);
> +
> +	wiphy_debug(hw->wiphy, "pcmd = %p\n", pcmd);
> +	memset(pcmd, 0x00, sizeof(*pcmd));
> +	eth_broadcast_addr(pcmd->permanent_addr);
> +	pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_GET_HW_SPEC);
> +	pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> +	pcmd->fw_awake_cookie = cpu_to_le32(priv->pphys_cmd_buf + 2048);
> +
> +	retry = 0;
> +	while (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_GET_HW_SPEC)) {
> +		if (retry++ > MAX_WAIT_GET_HW_SPECS_ITERATONS) {
> +			wiphy_err(hw->wiphy, "can't get hw specs\n");
> +			spin_unlock_bh(&priv->fwcmd_lock);
> +			return -EIO;
> +		}
> +
> +		mdelay(1000);
> +		wiphy_debug(hw->wiphy,
> +			    "repeat command = %p\n", pcmd);
> +	}

*cough* mdelay(1000) while holding a spin lock and within in a while()
*loop? *cough*

This needs a little cleaning up. Please have a look at
Documentation/timers/timers-howto.txt

> +
> +	ether_addr_copy(&priv->hw_data.mac_addr[0], pcmd->permanent_addr);
> +	priv->desc_data[0].wcb_base =
> +		le32_to_cpu(pcmd->wcb_base0) & 0x0000ffff;
> +	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
> +		priv->desc_data[i].wcb_base =
> +			le32_to_cpu(pcmd->wcb_base[i - 1]) & 0x0000ffff;
> +	priv->desc_data[0].rx_desc_read =
> +		le32_to_cpu(pcmd->rxpd_rd_ptr) & 0x0000ffff;
> +	priv->desc_data[0].rx_desc_write =
> +		le32_to_cpu(pcmd->rxpd_wr_ptr) & 0x0000ffff;
> +	priv->hw_data.region_code = le16_to_cpu(pcmd->region_code) & 0x00ff;
> +	priv->hw_data.fw_release_num = le32_to_cpu(pcmd->fw_release_num);
> +	priv->hw_data.max_num_tx_desc = le16_to_cpu(pcmd->num_wcb);
> +	priv->hw_data.max_num_mc_addr = le16_to_cpu(pcmd->num_mcast_addr);
> +	priv->hw_data.num_antennas = le16_to_cpu(pcmd->num_antenna);
> +	priv->hw_data.hw_version = pcmd->version;
> +	priv->hw_data.host_interface = pcmd->host_if;
> +
> +	spin_unlock_bh(&priv->fwcmd_lock);
> +
> +	return 0;
> +}
> +
> +int mwl_fwcmd_set_hw_specs(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +	struct hostcmd_cmd_set_hw_spec *pcmd;
> +	int i;
> +
> +	if (priv->mfg_mode)
> +		return 0;
> +
> +	pcmd = (struct hostcmd_cmd_set_hw_spec *)&priv->pcmd_buf[0];
> +
> +	spin_lock_bh(&priv->fwcmd_lock);
> +
> +	memset(pcmd, 0x00, sizeof(*pcmd));
> +	pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_SET_HW_SPEC);
> +	pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> +	pcmd->wcb_base[0] = cpu_to_le32(priv->desc_data[0].pphys_tx_ring);
> +	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
> +		pcmd->wcb_base[i] =
> +			cpu_to_le32(priv->desc_data[i].pphys_tx_ring);
> +	pcmd->tx_wcb_num_per_queue = cpu_to_le32(SYSADPT_MAX_NUM_TX_DESC);
> +	pcmd->num_tx_queues = cpu_to_le32(SYSADPT_NUM_OF_DESC_DATA);
> +	pcmd->total_rx_wcb = cpu_to_le32(SYSADPT_MAX_NUM_RX_DESC);
> +	pcmd->rxpd_wr_ptr = cpu_to_le32(priv->desc_data[0].pphys_rx_ring);
> +	pcmd->features = 0;
> +
> +	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_HW_SPEC)) {
> +		spin_unlock_bh(&priv->fwcmd_lock);
> +		wiphy_err(hw->wiphy, "failed execution\n");
> +		return -EIO;
> +	}
> +
> +	spin_unlock_bh(&priv->fwcmd_lock);
> +
> +	return 0;
> +}

It looks like fwcmd_lock() is used in this way in every instance. Could
you not allocate a pool of command buffers, put them on a list, and
only take the lock while you pull them out and reinsert them back into
the list?

If you need to hold a lock during firmware command execution, you
probably should switch to a mutex mechanism rather than spin locks.

> +
> +int mwl_fwcmd_get_stat(struct ieee80211_hw *hw,
> +		       struct ieee80211_low_level_stats *stats)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +	struct hostcmd_cmd_802_11_get_stat *pcmd;
> +
> +	pcmd = (struct hostcmd_cmd_802_11_get_stat *)&priv->pcmd_buf[0];
> +
> +	spin_lock_bh(&priv->fwcmd_lock);
> +
> +	memset(pcmd, 0x00, sizeof(*pcmd));
> +	pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_802_11_GET_STAT);
> +	pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> +
> +	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_GET_STAT)) {
> +		spin_unlock_bh(&priv->fwcmd_lock);
> +		wiphy_err(hw->wiphy, "failed execution\n");
> +		return -EIO;
> +	}
> +
> +	stats->dot11ACKFailureCount =
> +		le32_to_cpu(pcmd->ack_failures);
> +	stats->dot11RTSFailureCount =
> +		le32_to_cpu(pcmd->rts_failures);
> +	stats->dot11FCSErrorCount =
> +		le32_to_cpu(pcmd->rx_fcs_errors);
> +	stats->dot11RTSSuccessCount =
> +		le32_to_cpu(pcmd->rts_successes);
> +
> +	spin_unlock_bh(&priv->fwcmd_lock);
> +
> +	return 0;
> +}
> +
> +int mwl_fwcmd_radio_enable(struct ieee80211_hw *hw)
> +{
> +	return mwl_fwcmd_802_11_radio_control(hw->priv, true, false);
> +}
> +
> +int mwl_fwcmd_radio_disable(struct ieee80211_hw *hw)
> +{
> +	return mwl_fwcmd_802_11_radio_control(hw->priv, false, false);
> +}

These last two makes me think you only use the spin lock for buffer
management and not the command execution itself?

I am out of time for today, I'll try to see if I can find more time
later - please look into fixing the above.

Jes
