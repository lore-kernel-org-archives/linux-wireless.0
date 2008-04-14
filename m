Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:55123 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbYDNHfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 03:35:47 -0400
Date: Mon, 14 Apr 2008 09:35:45 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	julian.calaby@gmail.com, david@woodhou.se, dwmw2@infradead.org,
	andreamrl@tiscali.it
Subject: Re: Update: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335 [Libertas]"
In-Reply-To: <1207943754.3364.1.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0804140910580.21835@bugs.comnets.uni-bremen.de> (sfid-20080414_083556_540315_AB49EFC0)
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
 <200803191124.03743.hs4233@mail.mn-solutions.de>
 <Pine.LNX.4.64.0803281122240.21835@bugs.comnets.uni-bremen.de>
 <1206992394.12973.39.camel@localhost.localdomain>
 <Pine.LNX.4.64.0804030921150.21835@bugs.comnets.uni-bremen.de>
 <1207943754.3364.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 11 Apr 2008, Dan Williams wrote:

> On Thu, 2008-04-03 at 09:25 +0200, Markus Becker wrote:
>> Hi Dan,
>>
>> I integrated your change requests. The issue with the
>> IEEE80211_CCK_RATE_1MB_MASK symbols I could not resolve yet, but I hope
>> this does not keep this patch from being applied.
>
> ; though it doesn't scan (always returns no results), and it apparently
> can't ever set the frequency, the command always times out.

Well, it can set the frequency, but only before doing scanning. This is 
where I do not get any further. I had a look at the malo BSD driver, they 
are doing the channel scanning similar. Help is appreciated on this issue.

> Also, it
> seems to hang the box on 'ifconfig wlan0 up' for some reason, and it's a
> hardlock without panics.  More debugging needed.

I had some locks as well during development. But with the current version, 
I did not experience and cannot reproduce the locks anymore. However, it 
might lock on other machines.

> Should the driver be named mrv8k or mrv8?  The directory is mrv8k, but
> the files are mrv8.  It should probably just use mrv8k everywhere.

OK, mrv8k it shall be.

> Also, at the top of mrv8.h, you'll want to:
>
> -	printk(KERN_DEBUG "%s - " __msg, ##__args)
> +	printk(KERN_DEBUG __msg " - ", ##__args)
>
> to get rid of compile format warnings when debugging is turned on.
> Again, thanks for picking this up, it can only get better.

OK.

> Dan

Here comes the next one (Nothing done on locks and channel scanning for 
now):

Signed-off-by: Markus Becker <mab@comnets.uni-bremen.de>

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fa8ab13..9d6cc65 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -753,5 +753,6 @@ source "drivers/net/wireless/b43/Kconfig"
  source "drivers/net/wireless/b43legacy/Kconfig"
  source "drivers/net/wireless/zd1211rw/Kconfig"
  source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/mrv8k/Kconfig"

  endmenu
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 3af665d..0c4002b 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -67,3 +67,4 @@ obj-$(CONFIG_P54_USB)		+= p54usb.o
  obj-$(CONFIG_P54_PCI)		+= p54pci.o

  obj-$(CONFIG_ATH5K)	+= ath5k/
+obj-$(CONFIG_MRV8K) += mrv8k/
diff --git a/drivers/net/wireless/mrv8k/Kconfig b/drivers/net/wireless/mrv8k/Kconfig
new file mode 100644
index 0000000..35f1bd6
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/Kconfig
@@ -0,0 +1,19 @@
+config MRV8K
+	tristate "Marvell 88w8335 Libertas PCMCIA-wireless support"
+	depends on PCMCIA && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select FW_LOADER
+	---help---
+	  This is an experimental driver for the Marvell 88w8335 Libertas wireless
+	  chip, present in many PCMCIA-wireless adapters.
+
+	  Device firmware is required alongside this driver. You can download
+	  the firmware cutter from http://www.saillard.org/linux/mrv8k/files/
+
+config MRV8K_DEBUG
+	bool "Marvell 88w8335 Libertas debugging"
+	depends on MRV8K
+	---help---
+	  MRV8K debugging messages. Choosing Y will result in additional debug
+	  messages being saved to your kernel logs, which may help debug any
+	  problems.
+
diff --git a/drivers/net/wireless/mrv8k/Makefile b/drivers/net/wireless/mrv8k/Makefile
new file mode 100644
index 0000000..6bf5a1b
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MRV8K) += mrv8k.o
diff --git a/drivers/net/wireless/mrv8k/README b/drivers/net/wireless/mrv8k/README
new file mode 100644
index 0000000..f964115
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/README
@@ -0,0 +1,31 @@
+Linux driver for Marvell Libertas PCI wireless chipset
+Copyright(c) Andrea Merello, 2007
+Released unter the terms of GPL license
+
+--------------------------------------------------------------------
+Currently this driver is under development and can't be considered
+finished.
+It's currently using the d80211 stack, so you will need a kernel from
+wireless-dev git tree.
+As the Marvell chip can do MAC handling (at least partially) in HW it
+is possible I will change, and d80211 stack will become unnecessary.
+For now FullMAC implementation in firmware is not used.
+
+For now the driver supports only BSS STA mode and monitor mode. 
+Scan, sw encryption and MAC address changing should also work.
+
+Monitor mode is mostly functional, but not perfect, as FW filters certain 
+packets. It is possible to see frames sent to all MAC addresses in any BSS
+on the selected channel, but certain particular frames, like ACKs are
+not passed by the card to upper layer. It is unsure if there is any way
+to obtain this.
+
+IBSS and AP mode are currently disabled.
+
+----IMPORTANT NOTE----
+For using this driver you will need marvell firmware. 
+You can obtain it using the utility for firmware extracting published
+my Luc Saillard on his website or using the firmware package for BSD
+malo driver.
+The driver will load the firmware while loading the module (this may
+change in future) and it is normal it will take several seconds.
diff --git a/drivers/net/wireless/mrv8k/TODO b/drivers/net/wireless/mrv8k/TODO
new file mode 100644
index 0000000..28ee8dc
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/TODO
@@ -0,0 +1,5 @@
+Check for the RX reschedule
+Check for TX skb free ------ should be ok
+Check for SSI and NF
+Check for rates and txpower
+
diff --git a/drivers/net/wireless/mrv8k/mrv8k.c b/drivers/net/wireless/mrv8k/mrv8k.c
new file mode 100644
index 0000000..a86ea9f
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/mrv8k.c
@@ -0,0 +1,1671 @@
+/*
+	d80211 Marvell Libertas PCI driver
+
+	Copyright (c) 2007 Andrea Merello <andreamrl@tiscali.it>
+
+	Based on existent mrv8k linux alpha driver
+	Copyright (c) 2005 Luc Saillard <luc@saillard.org>
+
+	Based on BSD malo driver
+	Copyright (c) 2006 Claudio Jeker <claudio@openbsd.org>
+	Copyright (c) 2006 Marcus Glocker <mglocker@openbsd.org>
+	(no code has been copyed. Hw programming methods
+	magic values, and card specific programming details
+	had been looked at)
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; see the file COPYING.  If not, write to
+	the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+	Boston, MA 02110-1301, USA.
+
+*/
+
+#include <linux/firmware.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+#include <asm/semaphore.h>
+#include <net/mac80211.h>
+#include <net/ieee80211_radiotap.h>
+
+#include "mrv8k.h"
+
+MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+
+static struct pci_device_id mrv_pci_tbl[] = {
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA4, 0x11AB, 0, 0, WL3563 },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA5, 0x16AB, 0, 0, WL3563 },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA6, 0x16AB, 0, 0, WL3563 },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x1FA7, 0x16AB, 0, 0, WL3563 },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x138f, 0x1043, 0, 0, WL138G },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x128f, 0x1043, 0, 0, WL138G },
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, 0x108f, 0x1043, 0, 0, WL138G },
+	/* NETGEAR WG311v3 802.11g Wireless PCI Adapter */
+	{PCI_VENDOR_ID_MARVELL, 0x1faa, PCI_ANY_ID, PCI_ANY_ID, 0x6b00, 0x1385, W8335},
+	{PCI_VENDOR_ID_MARVELL, 0x1faa, PCI_ANY_ID, PCI_ANY_ID, 0, 0, W8335},
+	{PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_W8K, PCI_ANY_ID, PCI_ANY_ID, 0, 0, WLGENERIC },
+	{0,}
+};
+
+static void mrv_deinit_cmd(struct mrv_priv *priv)
+{
+	if (priv->cmd_virt)
+		pci_free_consistent(priv->pdev,
+			MRV_CMD_PKT_SIZE,
+			priv->cmd_virt, priv->cmd_dma);
+
+	if (priv->magic_virt)
+		pci_free_consistent(priv->pdev, 4,
+			priv->magic_virt, priv->magic_dma);
+}
+
+static void mrv_free_rx_ring(struct mrv_priv *priv)
+{
+	int i;
+	for (i = 0; i < MRV_RX_DESC_NUM; i++) {
+		dev_kfree_skb(priv->rx_skb[i]);
+		pci_free_consistent(priv->pdev,
+			sizeof(struct mrv_rx_descriptor),
+			priv->rx_ring_virt[i],
+			priv->rx_ring_dma[i]);
+	}
+
+}
+
+static void mrv_free_tx_ring(struct mrv_priv *priv)
+{
+	int i, j;
+	for (i = 0; i < MRV_TX_DESC_NUM; i++)
+		pci_free_consistent(priv->pdev,
+			sizeof(struct mrv_tx_descriptor),
+			priv->tx_ring_virt[i],
+			priv->tx_ring_dma[i]);
+
+	for (i = 0; i < priv->tx_pending; i++) {
+		j = priv->tx_r_idx;
+		dev_kfree_skb(priv->tx_skb[j]);
+		if (j == MRV_TX_DESC_NUM - 1)
+			j = 0;
+		else
+			j++;
+	}
+}
+
+static int mrv_init_cmd(struct mrv_priv *priv)
+{
+	void *v;
+	dma_addr_t p;
+	v = pci_alloc_consistent(priv->pdev, MRV_CMD_PKT_SIZE, &p);
+	priv->cmd_virt = v;
+
+	if (v == NULL) {
+		printk(KERN_ERR"Can't allocate CMD memory\n");
+		return -ENOMEM;
+	}
+
+	priv->cmd_dma = p;
+	v = pci_alloc_consistent(priv->pdev, 4, &p);
+	priv->magic_virt = v;
+
+	if (v == NULL) {
+		printk(KERN_ERR"Can't allocate MAGIC memory\n");
+		return -ENOMEM;
+	}
+
+	priv->magic_dma = p;
+	*priv->magic_virt = cpu_to_le32(MRV_CMD_MAGIC);
+
+	return 0;
+}
+
+static void _mrv_send_cmd(struct mrv_priv *priv, u32 addr)
+{
+	DEBUG_PRINTK("_mrv_send_cmd\n");
+	wmb();
+	mrv_reg_write32(priv, MRV_REG_CMD_PTR,  addr);
+	mrv_reg_mb(priv);
+	mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, 2);
+	mrv_reg_mb(priv);
+}
+
+static inline void mrv_send_cmd(struct mrv_priv *priv)
+{
+	DEBUG_PRINTK("mrv_send_cmd\n");
+	_mrv_send_cmd(priv, priv->cmd_dma);
+}
+
+static int mrv_send_cmd_sync(struct mrv_priv *priv)
+{
+	int err;
+
+	DEBUG_PRINTK("mrv_send_cmd_sync\n");
+	down(&priv->cmd_sem);
+	err = 0;
+	priv->cmd_status = 0x10000;
+	mrv_send_cmd(priv);
+
+	DEBUG_PRINTK("mrv_send_cmd_time\n");
+	wait_event_interruptible_timeout(priv->wait_command_queue,
+					 (priv->cmd_status != 0x10000), 500);
+	DEBUG_PRINTK("mrv_send_cmd_timeout\n");
+
+	if (priv->cmd_status == 0x10000) {
+		printk(KERN_ERR"Command timeout\n");
+		err = -1;
+	} else if (priv->cmd_status == 3) {
+		printk(KERN_WARNING"Command deferred!\n");
+		err = 0;
+	} else if (priv->cmd_status != 0) {
+		printk(KERN_ERR"Command failed with status %x\n", priv->cmd_status);
+		err = -1;
+	} else {
+		printk(KERN_ERR"status %x\n", priv->cmd_status);
+	}
+
+	up(&priv->cmd_sem);
+
+	return err;
+}
+
+static inline struct mrv_cmd_hdr *mrv_cmd(struct mrv_priv *priv,
+					  int cmd,
+					  int len,
+					  int status,
+					  int sq)
+{
+	struct mrv_cmd_hdr *ret;
+
+	DEBUG_PRINTK("mrv_cmd %x %x %x %x\n", cmd, len, status, sq);
+
+	ret = (struct mrv_cmd_hdr *)priv->cmd_virt;
+	ret->type = cpu_to_le16(cmd);
+	ret->len = cpu_to_le16(len);
+	ret->status = cpu_to_le16(status);
+	ret->sq = cpu_to_le16(sq);
+	return ret;
+}
+
+static int mrv_upload_fw(struct mrv_priv *priv)
+{
+	struct mrv_cmd_hdr  *cmd;
+	u8 *cmd_data;
+	const struct firmware *img = NULL;
+	int i, j, sq, err;
+
+	err = request_firmware(&img, FW_BOOT_FILENAME, &priv->pdev->dev);
+	if (err < 0) {
+		printk(KERN_ERR"request_firmware for boot img failed: Reason %d\n", err);
+		return err;
+	}
+
+	mrv_reg_write32(priv, MRV_REG_STATUS, 0);
+	mrv_reg_mb(priv);
+	mrv_mem_write16(priv, MRV_MEM_CMD_BOOT, MRV_CMD_FW);
+	mrv_mem_write16(priv, MRV_MEM_CMD_BOOT+2, img->size);
+	mrv_mem_write32(priv, MRV_MEM_CMD_BOOT+4, 0);
+
+	for (i = 0; i < img->size; i++)
+		mrv_mem_write8(priv, MRV_MEM_CMD_BOOT+8+i, (img->data)[i]);
+
+	release_firmware(img);
+
+	_mrv_send_cmd(priv, MRV_HWMEM_CMD_BOOT);
+
+	for (i = 0; i < 500; i++) {
+		if (mrv_reg_read32(priv, MRV_REG_STATUS) == 0x5)
+		mdelay(1);
+			break;
+	}
+	if (i == 10) {
+		printk(KERN_ERR"Timeout while loading boot fw \n");
+		return -1;
+	}
+	DEBUG_PRINTK("Bootstrap loaded OK, jumping in..\n");
+	mrv_mem_write16(priv, MRV_MEM_CMD_BOOT, MRV_CMD_FW);
+	mrv_mem_write16(priv, MRV_MEM_CMD_BOOT+2, 0);
+	mrv_mem_write32(priv, MRV_MEM_CMD_BOOT+4, 0);
+
+	_mrv_send_cmd(priv, MRV_HWMEM_CMD_BOOT);
+
+	/* the boot code is stupid enought that it does not report any status when it
+	 * loads correctly and become alive. Wait 1 second..*/
+	msleep(1000);
+
+	err = request_firmware(&img, FW_FIRMWARE_FILENAME, &priv->pdev->dev);
+	if (err < 0) {
+		printk(KERN_ERR"request_firmware for fw img2 failed: Reason %d\n", err);
+		return err;
+	}
+
+	sq = 1;
+	for (i = 0; (i+256) < img->size; i += 256) {
+		mrv_reg_write32(priv, MRV_REG_STATUS, 0);
+		mrv_reg_mb(priv);
+		cmd = mrv_cmd(priv, MRV_CMD_FW, 256, 0, sq++);
+		cmd_data = MRV_CMD_PAYLOAD(cmd) ;
+		memcpy(cmd_data, img->data + i, 256);
+		mrv_send_cmd(priv);
+		for (j = 0; j < 500; j++) {
+			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
+			  break;
+			mdelay(1);
+		}
+		if (j == 500) {
+			printk(KERN_ERR"Boot FW has failed to transfer real FW\n");
+			return -2;
+		}
+	}
+
+	if (i < img->size) {
+		mrv_reg_write32(priv, MRV_REG_STATUS, 0);
+		mrv_reg_mb(priv);
+		cmd = mrv_cmd(priv, MRV_CMD_FW, img->size - i, 0, sq++);
+		cmd_data = MRV_CMD_PAYLOAD(cmd) ;
+		memcpy(cmd_data, img->data + i, img->size - i);
+		mrv_send_cmd(priv);
+		for (j = 0; j < 500; j++) {
+			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
+			  break;
+			mdelay(1);
+		}
+		if (j == 500) {
+			printk(KERN_ERR"Boot FW has failed to transfer last real FW chunk\n");
+			return -2;
+		}
+	}
+
+	release_firmware(img);
+
+	cmd = mrv_cmd(priv, MRV_CMD_FW, 0, 0, sq);
+
+	mrv_send_cmd(priv);
+	msleep(100);
+
+	for (i = 0; i < 200; i++) {
+		mrv_reg_write32(priv, MRV_REG_CMD_PTR, 0x5a);
+		mrv_reg_mb(priv);
+		if (mrv_reg_read32(priv, MRV_REG_STATUS) == MRV_FW_SIGNATURE)
+			break;
+		mdelay(10);
+	}
+
+	if (i == 200) {
+		printk(KERN_ERR"FW is not alive or returned error %x \n",
+			mrv_reg_read32(priv, MRV_REG_STATUS));
+		return -1;
+	}
+
+	priv->fw_load = 1;
+	printk(KERN_INFO"Firmware for mrv loaded successfully\n");
+
+	return 0;
+}
+
+static void mrv_int_enable(struct mrv_priv *priv)
+{
+	mrv_reg_write32(priv, MRV_REG_INTA_MASK, MRV_INTA_MASK);
+	mrv_reg_write32(priv, MRV_REG_INTB_MASK, MRV_INTB_MASK);
+	mrv_reg_mb(priv);
+}
+
+static void mrv_int_disable(struct mrv_priv *priv)
+{
+	mrv_reg_write32(priv, MRV_REG_INTA_MASK, 0);
+	mrv_reg_write32(priv, MRV_REG_INTB_MASK, 0);
+	mrv_reg_mb(priv);
+}
+
+static int mrv_tx(struct ieee80211_hw *dev,
+		  struct sk_buff *skb,
+		  struct ieee80211_tx_control *control)
+{
+	struct ieee80211_hdr *hdr;
+	struct mrv_tx_descriptor *txd;
+	unsigned long flags;
+	struct mrv_priv *priv = dev->priv;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	if (skb->len < sizeof(struct ieee80211_hdr)) {
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
+		return NETDEV_TX_OK;
+	}
+
+	if (priv->tx_pending >= (MRV_TX_DESC_NUM-2)) {
+		ieee80211_stop_queue(dev, 0);
+	}
+
+	if (skb_headroom(skb) < dev->extra_tx_headroom) {
+		if (pskb_expand_head(skb, dev->extra_tx_headroom, 0, GFP_ATOMIC)) {
+			printk(KERN_ERR "failed to allocate room for TX "
+			       "header\n");
+			kfree_skb(skb);
+			spin_unlock_irqrestore(&priv->tx_lock, flags);
+			return -ENOMEM;
+		}
+	}
+
+	priv->tx_pending++;
+	priv->tx_skb[priv->tx_w_idx] = skb;
+	txd = priv->tx_ring_virt[priv->tx_w_idx];
+
+	if (priv->tx_w_idx == MRV_TX_DESC_NUM-1)
+		priv->tx_w_idx = 0;
+	else
+		priv->tx_w_idx++;
+
+	memcpy(txd->dest_addr,
+		ieee80211_get_DA((struct ieee80211_hdr *)skb->data), 6);
+
+	skb_push(skb, dev->extra_tx_headroom);
+
+	*((u16 *)skb->data) = cpu_to_le16(skb->len) - 32;
+
+	memcpy(skb->data+2, skb->data+8, 24); /* move 80211 header */
+	hdr = (struct ieee80211_hdr *)skb->data + 2;
+	memcpy(skb->data+2+24, &(hdr->addr4), 6); /* copy addr4 */
+
+	txd->len = cpu_to_le16(skb->len);
+
+	txd->dma_addr = cpu_to_le32(pci_map_single(priv->pdev,
+			skb->data, skb->len, PCI_DMA_TODEVICE));
+
+	txd->priority = control->queue;
+	/*txd->rate = control->tx_rate;*/
+
+	txd->status = cpu_to_le16(1);
+	txd->fwowner = cpu_to_le16(0x8000);
+	wmb();
+	mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, 1);
+	mrv_reg_mb(priv);
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+
+	return NETDEV_TX_OK;
+}
+
+static void mrv_tx_cb_tasklet(struct mrv_priv *priv)
+{
+	struct mrv_tx_descriptor *txd;
+	int status;
+	unsigned long flags;
+	struct ieee80211_tx_status tx_status = { {0} };
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	while (priv->tx_r_idx != priv->tx_w_idx) {
+		txd = priv->tx_ring_virt[priv->tx_r_idx];
+
+		if (le16_to_cpu(txd->fwowner) & 0x8000)
+			break;
+
+		status = le16_to_cpu(txd->status) & 0x1;
+		if (status == 0)
+		  tx_status.excessive_retries = 1;
+		tx_status.queue_number = txd->priority;
+
+		pci_unmap_single(priv->pdev, txd->dma_addr,
+			priv->tx_skb[priv->tx_r_idx]->len, PCI_DMA_TODEVICE);
+
+		ieee80211_tx_status_irqsafe(priv->dev,
+			priv->tx_skb[priv->tx_r_idx], &tx_status);
+
+		priv->tx_pending--;
+
+		if (priv->tx_pending == MRV_TX_DESC_NUM-2)
+			ieee80211_wake_queue(priv->dev, 0);
+
+		if (priv->tx_r_idx == MRV_TX_DESC_NUM-1)
+			priv->tx_r_idx = 0;
+		else
+			priv->tx_r_idx++;
+	}
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+}
+
+static void mrv_rx_tasklet(struct mrv_priv *priv)
+{
+	int len, count = 0;
+	struct ieee80211_rx_status rx_status = {0};
+	struct mrv_rx_descriptor *rxd;
+	struct sk_buff *skb;
+
+	for (count = 0; count < MRV_MAX_RX_INT; count++) {
+		rxd = priv->rx_ring_virt[priv->rx_idx];
+		skb = priv->rx_skb[priv->rx_idx];
+
+		if ((rxd->drvowner & 0x80) == 0)
+			break;
+		if (mrv_mem_read32(priv, priv->rx_hw_dma_r) ==
+			mrv_mem_read32(priv, priv->rx_hw_dma_w))
+			break;
+
+		len = le16_to_cpu(rxd->datalen);
+
+		if (len > 3) {
+
+			rx_status.ssi = rxd->rssi;
+			/*		rx_status.antenna = (hdr->signal >> 7) & 1;
+			rx_status.signal = quality;
+			rx_status.rate = rxd->rate;
+			rx_status.freq = mrv_channels[rxd->chan -1].freq;
+			rx_status.channel = rxd->chan;
+			rx_status.phymode = priv->dev->conf.phymode;
+			rx_status.mactime = le64_to_cpu(hdr->mac_time);*/
+
+			pci_unmap_single(priv->pdev, rxd->dma_data,
+				MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE);
+
+			/*This is the madness of how firmware reworks packets...
+			* So we have to cut out this damn garbage the firmware
+			* puts at the beginning and in the middle of packets.....
+			*/
+			skb_put(skb, len);
+			skb_pull(skb, 2);
+
+			if (skb->len > 30) {
+				memcpy(skb->data + 24, skb->data + 30, skb->len - 6);
+				skb_trim(skb, skb->len - 6);
+			}
+			/*if (skb->len < 50) {
+			  printk("\n.........");
+			  for(i=0;i<skb->len;i++)
+			  printk("%x ", skb->data[i]);
+			  }
+			*/
+			ieee80211_rx_irqsafe(priv->dev, skb, &rx_status);
+
+			/*TODO check for failure */
+			skb = dev_alloc_skb(MRV_RX_PAYLOAD_LEN);
+			priv->rx_skb[priv->rx_idx] = skb;
+
+			rxd->dma_data = cpu_to_le32(pci_map_single(priv->pdev,
+					skb->data, MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE));
+		}
+
+		rxd->drvowner = 0;
+
+		if (priv->rx_idx == MRV_RX_DESC_NUM-1)
+			priv->rx_idx = 0;
+		else
+			priv->rx_idx++;
+		wmb();
+		mrv_mem_write32(priv, priv->rx_hw_dma_r, priv->rx_ring_dma[priv->rx_idx]);
+	}
+
+	/*rxd = priv->rx_ring_virt[priv->rx_idx];
+	  if (priv->up && ((rxd->drvowner & 0x80)!= 0))
+	  tasklet_schedule(&priv->mrv_rx_tasklet);*/
+}
+
+irqreturn_t mrv_interrupt(int irq, void *data)
+{
+	struct mrv_priv *priv = (struct mrv_priv *) data;
+	struct mrv_cmd_hdr *cmd;
+	unsigned int status;
+	unsigned int flags;
+
+	spin_lock_irqsave(&priv->irq_th_lock, flags);
+
+	if (!priv->fw_load) {
+		spin_unlock_irqrestore(&priv->irq_th_lock, flags);
+		return IRQ_NONE;
+	}
+
+	mrv_int_disable(priv);
+
+	status = mrv_reg_read32(priv, MRV_REG_ISR);
+
+	if (status == MRV_INVALID_STATUS_1) {
+		spin_unlock_irqrestore(&priv->irq_th_lock, flags);
+		mrv_int_enable(priv);
+		return IRQ_NONE;
+
+	}
+	status &= MRV_INTA_MASK;
+
+	if (status == MRV_INVALID_STATUS_2) {
+		spin_unlock_irqrestore(&priv->irq_th_lock, flags);
+		mrv_int_enable(priv);
+		return IRQ_NONE;
+	}
+
+	if (status & MRV_CMD_DONE_INT) {
+		cmd = (struct mrv_cmd_hdr *)priv->cmd_virt;
+		priv->cmd_status = le16_to_cpu(cmd->status);
+		wake_up_interruptible(&priv->wait_command_queue);
+	}
+
+	if (status & MRV_RX_INT)
+		tasklet_schedule(&priv->mrv_rx_tasklet);
+
+	if (status & MRV_TX_INT)
+		tasklet_schedule(&priv->mrv_tx_cb_tasklet);
+
+	status = status & ~(MRV_CMD_DONE_INT|MRV_RX_INT|MRV_TX_INT);
+
+	mrv_reg_write32(priv, MRV_REG_ISR, status);
+	mrv_reg_mb(priv);
+
+	mrv_int_enable(priv);
+	spin_unlock_irqrestore(&priv->irq_th_lock, flags);
+	return IRQ_HANDLED;
+}
+
+/*
+static void dump_reg(struct mrv_priv *priv)
+{
+
+	 0 HIU host interf 0c pci interf
+	 2 CIU
+	 4 SQRAM
+	 6 SDRAM
+	 8 FEMAC
+	 a WLMAC. a0 WLMACTXCONFIG ,a2 WLMACRXCONFIG
+	 c LBU. c2 eeprom, c4 rf, c6 BB, c8 lsbu
+	 d GPIO. d8, pwrmgmt
+	 e DMA
+
+	int i;
+	for (i = 0; i < 0xfff; i++) {
+		if ( i % 18 == 0) printk("\n");
+		printk("%4x= %2x, ", i, mrv_reg_read8(priv, i));
+	}
+}
+*/
+
+static int mrv_hw_start(struct mrv_priv *priv)
+{
+	int err;
+
+	err = request_irq(priv->pdev->irq, &mrv_interrupt, IRQF_SHARED,
+			  DRV_NAME, priv);
+	if (err) {
+		printk(KERN_ERR"Error calling request_irq: %d.\n",
+		       priv->pdev->irq);
+		return err;
+	}
+
+	mrv_reg_read32(priv, MRV_REG_ISR);
+	mrv_reg_write32(priv, MRV_REG_ISR, 0);
+	mrv_reg_write32(priv, 0xc20, 0x800f);
+	mrv_reg_write32(priv, 0xc24, 0x800f);
+	mrv_int_disable(priv);
+
+	err = mrv_upload_fw(priv);
+
+	if (err) {
+		free_irq(priv->pdev->irq, priv);
+		return err;
+	}
+
+	mrv_int_enable(priv);
+
+	return 0;
+}
+
+static void mrv_hw_halt(struct mrv_priv *priv)
+{
+	mrv_reg_write32(priv, MRV_REG_GEN_ARM_INT, (1 << 15));
+	mrv_reg_mb(priv);
+	mrv_int_disable(priv);
+	free_irq(priv->pdev->irq, priv);
+}
+
+static int mrv_set_antenna(struct mrv_priv *priv, int rtx, int param)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_antenna *data;
+
+	DEBUG_PRINTK("mrv_set_Antenna\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_ANTENNA,
+		MRV_CMD_SET_ANTENNA_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_antenna *)MRV_CMD_PAYLOAD(cmd);
+
+	data->rtx = cpu_to_le16(rtx);
+	data->param = cpu_to_le16(param);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set antenna\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_txpower(struct mrv_priv *priv, int param)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_txpower *data;
+
+	DEBUG_PRINTK(KERN_ERR"mrv_set_txpower\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_TXPOWER,
+		MRV_CMD_SET_TXPOWER_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_txpower *)MRV_CMD_PAYLOAD(cmd);
+
+	data->txpower = cpu_to_le16(param);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set txpower\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_radio(struct mrv_priv *priv, int enable, int preamble)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_radio *data;
+
+	DEBUG_PRINTK("mrv_set_radio\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_RADIO,
+		MRV_CMD_SET_RADIO_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_radio *)MRV_CMD_PAYLOAD(cmd);
+
+	data->flag = cpu_to_le16(1);
+	data->preamble = cpu_to_le16(preamble);
+	data->enable = cpu_to_le16(enable);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set radio\n");
+		return -1;
+	}
+	return 0;
+}
+
+
+static int mrv_set_allowed_rates(struct mrv_priv *priv, int allowg)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_rates *data;
+	int i;
+
+	DEBUG_PRINTK("mrv_set_allowed_rates\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_RATES,
+		MRV_CMD_SET_RATES_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_rates *)MRV_CMD_PAYLOAD(cmd);
+
+	data->fixedrate = 0;
+	data->fixedindex = 0;
+
+	for (i = 0; i < 4; i++)
+		data->rates[i] = i;
+
+	for (; i < 14; i++)
+		if (allowg)
+			data->rates[i] = i;
+		else
+			data->rates[i] = 0;
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set rates\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_slot(struct mrv_priv *priv, int shortslot)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_slot *data;
+
+	DEBUG_PRINTK("mrv_set_slot\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_SLOT,
+		MRV_CMD_SET_SLOT_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_slot *)MRV_CMD_PAYLOAD(cmd);
+
+	data->action = cpu_to_le16(1);
+	data->shortslot = shortslot;
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set slot\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_prescan(struct mrv_priv *priv)
+{
+	struct mrv_cmd_hdr  *cmd;
+
+	DEBUG_PRINTK("mrv_set_prescan\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_PRESCAN,
+		MRV_CMD_SET_PRESCAN_SZ, 0, 1);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set prescan\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_postscan(struct mrv_priv *priv)
+{
+	struct mrv_cmd_hdr  *cmd;
+
+	DEBUG_PRINTK("mrv_set_postscan\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_POSTSCAN,
+		MRV_CMD_SET_POSTSCAN_SZ, 0, 1);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set postscan\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_channel(struct mrv_priv *priv,
+			   struct ieee80211_channel *channel)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_channel *data;
+	int ch;
+
+	ch = ieee80211_frequency_to_channel(channel->center_freq);
+
+	DEBUG_PRINTK("mrv_set_channel %i\n", ch);
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_CHANNEL,
+		MRV_CMD_SET_CHANNEL_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_channel *)MRV_CMD_PAYLOAD(cmd);
+
+	data->flag = cpu_to_le16(1);
+	data->ch = ch;
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set channel\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int mrv_set_mac_addr(struct mrv_priv *priv, u8 addr[6])
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_mac_addr *data;
+
+	DEBUG_PRINTK("mrv_set_mac\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_MAC_ADDR,
+		MRV_CMD_SET_MAC_ADDR_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_mac_addr *)MRV_CMD_PAYLOAD(cmd);
+
+	memcpy(data->addr, addr, 6);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set mac address\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mrv_set_bssid(struct mrv_priv *priv, u8 addr[6])
+{
+	int i;
+	u32 reg;
+
+	DEBUG_PRINTK("mrv_set_bssid\n");
+
+	reg = mrv_reg_read32(priv, MRV_REG_RX_MODE);
+
+	if (is_valid_ether_addr(addr)) {
+		for (i = 0; i < 6; i++)
+			mrv_reg_write8(priv, MRV_REG_BSSID, addr[i]);
+
+		reg &= ~(2);
+	} else {
+		reg |= (2);
+	}
+
+	mrv_reg_write32(priv, MRV_REG_RX_MODE, reg);
+}
+
+static int mrv_read_config(struct mrv_priv *priv)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_get_config *data;
+	int i;
+
+	DEBUG_PRINTK("mrv_read_config\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_GET_CONFIG,
+		      MRV_CMD_GET_CONFIG_SZ, 0, 1);
+
+	data = (struct mrv_cmd_get_config *)MRV_CMD_PAYLOAD(cmd);
+	data->magic = cpu_to_le32(priv->magic_dma);
+
+	for (i = 0; i < MRV_CMD_GET_CONFIG_SZ; i++)
+		((u8 *)data)[i] = 0;
+
+	for (i = 0; i < 6; i++)
+		data->mac_adr[i] = 0xff;
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not read CFG\n");
+		return -1;
+	}
+
+	priv->ant_num = le16_to_cpu(data->ant_num);
+	priv->fw_ver = le32_to_cpu(data->fw_ver);
+	priv->hw_ver = le16_to_cpu(data->hw_ver);
+	priv->tx_ring_num = le16_to_cpu(data->tx_ring_num);
+	priv->region_code = le16_to_cpu(data->region_code);
+	priv->tx_hw_dma0 = le32_to_cpu(data->tx_ring0) & 0xffff;
+	priv->tx_hw_dma1 = le32_to_cpu(data->tx_ring1) & 0xffff;
+	priv->tx_hw_dma2 = le32_to_cpu(data->tx_ring2) & 0xffff;
+	priv->tx_hw_dma3 = le32_to_cpu(data->tx_ring3) & 0xffff;
+	priv->rx_hw_dma_r = le32_to_cpu(data->rx_ring_r) & 0xffff;
+	priv->rx_hw_dma_w = le32_to_cpu(data->rx_ring_w) & 0xffff;
+
+	SET_IEEE80211_PERM_ADDR(priv->dev, data->mac_adr);
+	printk(KERN_INFO"Card mac address is "MAC_FMT"\n",
+	       priv->dev->wiphy->perm_addr[0],
+	       priv->dev->wiphy->perm_addr[1],
+	       priv->dev->wiphy->perm_addr[2],
+	       priv->dev->wiphy->perm_addr[3],
+	       priv->dev->wiphy->perm_addr[4],
+	       priv->dev->wiphy->perm_addr[5]);
+	printk(KERN_INFO"Fw V %x, Hw V %x, Antennas: %x, Region code %d\n",
+			priv->fw_ver, priv->hw_ver, priv->ant_num, priv->region_code);
+	DEBUG_PRINTK("~mrv_read_config\n");
+	return 0;
+}
+
+static int mrv_alloc_rxring(struct mrv_priv *priv)
+{
+	struct mrv_rx_descriptor *v;/*,*_v;*/
+	dma_addr_t p;/*,_p;*/
+	int i;
+	DEBUG_PRINTK("mrv_alloc_rxring\n");
+
+	/*_v = (struct mrv_rx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_rx_descriptor), &_p);*/
+	for (i = 0; i < MRV_RX_DESC_NUM; i++) {
+		v = (struct mrv_rx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_rx_descriptor), &p);
+		/*		v = _v + i; p= _p + i*sizeof(struct mrv_rx_descriptor );*/
+		if (v == NULL) {
+			printk(KERN_ERR"Can't allocate RX descriptor memory\n");
+			/*FIXME dealloc what we done */
+			return -ENOMEM;
+		}
+
+		v->drvowner = 0;
+		v->status = cpu_to_le16(1);
+
+		priv->rx_ring_dma[i] = p;
+		priv->rx_ring_virt[i] = v;
+		priv->rx_skb[i] = dev_alloc_skb(MRV_RX_PAYLOAD_LEN);
+
+		if (priv->rx_skb[i] == NULL) {
+			printk(KERN_ERR"Can't allocate RX skb memory\n");
+			/*FIXME dealloc what we done */
+			return -ENOMEM;
+		}
+
+		priv->rx_ring_virt[i]->dma_data = cpu_to_le32(
+				pci_map_single(priv->pdev, priv->rx_skb[i]->data,
+				MRV_RX_PAYLOAD_LEN, PCI_DMA_FROMDEVICE));
+
+		if (i != 0)
+			priv->rx_ring_virt[i-1]->dma_next = cpu_to_le32(p);
+	}
+	priv->rx_ring_virt[i-1]->dma_next = cpu_to_le32(priv->rx_ring_dma[0]);
+	priv->rx_idx = 0;
+
+	DEBUG_PRINTK("~mrv_alloc_rxring\n");
+	return 0;
+}
+
+static int mrv_alloc_txring(struct mrv_priv *priv)
+{
+	struct mrv_tx_descriptor *v;/*,*_v;*/
+	dma_addr_t p;/*,_p;*/
+	int i;
+
+	DEBUG_PRINTK("mrv_alloc_txring\n");
+	for (i = 0; i < MRV_TX_DESC_NUM; i++) {
+		v = (struct mrv_tx_descriptor *) pci_alloc_consistent(priv->pdev, sizeof(struct mrv_tx_descriptor), &p);
+		/*		v = _v + i; p= _p + i*sizeof(struct mrv_tx_descriptor );*/
+		if (v == NULL) {
+			printk(KERN_ERR"Can't allocate TX descriptor memory\n");
+			/*FIXME dealloc what we done */
+			return -ENOMEM;
+		}
+
+		priv->tx_ring_dma[i] = p;
+		priv->tx_ring_virt[i] = v;
+
+		if (i != 0)
+			priv->tx_ring_virt[i-1]->dma_next = cpu_to_le32(p);
+	}
+	priv->tx_ring_virt[i-1]->dma_next = cpu_to_le32(priv->tx_ring_dma[0]);
+	priv->tx_r_idx = 0;
+	priv->tx_w_idx = 0;
+	priv->tx_pending = 0;
+
+	DEBUG_PRINTK("~mrv_alloc_txring\n");
+	return 0;
+}
+
+static void mrv_set_dma_rings(struct mrv_priv *priv)
+{
+	DEBUG_PRINTK("mrv_set_dma_rings %i, %x\n", priv->rx_hw_dma_r,
+		 priv->rx_ring_dma[0]);
+	mrv_mem_write32(priv, priv->rx_hw_dma_r, priv->rx_ring_dma[0]);
+	DEBUG_PRINTK("mrv_set_dma_rings 1\n");
+	mrv_mem_write32(priv, priv->rx_hw_dma_w, priv->rx_ring_dma[0]);
+	DEBUG_PRINTK("mrv_set_dma_rings 2\n");
+	mrv_mem_write32(priv, priv->tx_hw_dma0, priv->tx_ring_dma[0]);
+	DEBUG_PRINTK("~mrv_set_dma_rings\n");
+}
+
+static void mrv_stop(struct ieee80211_hw *dev)
+{
+	struct mrv_priv *priv = dev->priv;
+	DEBUG_PRINTK("mrv_stop\n");
+
+	priv->up = 0;
+	tasklet_disable(&priv->mrv_rx_tasklet);
+	tasklet_disable(&priv->mrv_tx_cb_tasklet);
+	mrv_mem_write32(priv, priv->tx_hw_dma0, 0);
+	mrv_mem_write32(priv, priv->rx_hw_dma_r, 0);
+	mrv_mem_write32(priv, priv->rx_hw_dma_w, 0);
+	mrv_reg_mb(priv);
+	msleep(100); /* random */
+	tasklet_kill(&priv->mrv_rx_tasklet);
+	tasklet_kill(&priv->mrv_tx_cb_tasklet);
+	mrv_free_rx_ring(priv);
+	mrv_free_tx_ring(priv);
+}
+
+static int mrv_start(struct ieee80211_hw *dev)
+{
+	struct mrv_priv *priv = dev->priv;
+	DEBUG_PRINTK("mrv_start\n");
+
+	priv->up = 1;
+	DEBUG_PRINTK("mrv_start after up\n");
+	tasklet_enable(&priv->mrv_rx_tasklet);
+	tasklet_enable(&priv->mrv_tx_cb_tasklet);
+	DEBUG_PRINTK("mrv_start after tasklet\n");
+	mrv_alloc_rxring(priv);
+	mrv_alloc_txring(priv);
+	DEBUG_PRINTK("mrv_start after rings\n");
+
+	mrv_set_dma_rings(priv);
+	DEBUG_PRINTK("mrv_start after hw\n");
+
+	/* Suspect that all commands must be sent AFTER set radio. Including the
+	 * get_hw_spec. But radio should be already enabled by default. Just make
+	 * sure we use AUTO preamble here
+	*/
+
+	/*
+	if (mrv_set_prescan(priv)) {
+	  printk(KERN_ERR"Failed to prescan\n");
+	  return -1;
+	} else {
+	  printk(KERN_ERR"Succeeded to prescan\n");
+	  }*/
+
+	/*mrv_set_channel(priv, 5);*/
+	DEBUG_PRINTK("mrv_start after channel\n");
+	mrv_set_antenna(priv, MRV_ANTENNA_RXA, 0xffff);
+	mrv_set_antenna(priv, MRV_ANTENNA_TXA, 0x2);
+	DEBUG_PRINTK("mrv_start after antenna\n");
+
+	if (priv->ant_num == 2) {
+		mrv_set_antenna(priv, MRV_ANTENNA_RXB, 0xffff);
+		mrv_set_antenna(priv, MRV_ANTENNA_TXB, 0x2);
+	}
+	DEBUG_PRINTK("mrv_start after antenna2\n");
+
+	mrv_set_radio(priv, 1, MRV_PREAMBLE_AUTO);
+	DEBUG_PRINTK("mrv_start after radio\n");
+
+	mrv_set_txpower(priv, 10);
+
+	DEBUG_PRINTK("~mrv_start\n");
+	return 0;
+}
+
+static void mrv_set_promisc(struct mrv_priv *priv, int enable)
+{
+	u32 reg;
+	DEBUG_PRINTK("mrv_set_promisc %i\n", enable);
+
+	reg = mrv_reg_read32(priv, MRV_REG_RX_MODE);
+	if (enable)
+		reg |= 1;
+	else
+		reg &= ~1;
+	mrv_reg_write32(priv, MRV_REG_RX_MODE, reg);
+}
+
+
+static void mrv_configure_filter(struct ieee80211_hw *dev,
+				 unsigned int changed_flags,
+				 unsigned int *total_flags,
+				 int mc_count, struct dev_mc_list *mclist)
+{
+	DEBUG_PRINTK("mrv_configure_filter %x\n", changed_flags);
+	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+
+	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+		if (*total_flags & FIF_PROMISC_IN_BSS) {
+		  mrv_set_promisc(dev->priv, 1);
+		} else {
+		  mrv_set_promisc(dev->priv, 0);
+		}
+	}
+	DEBUG_PRINTK("~mrv_configure_filter\n");
+}
+
+static int mrv_config_interface(struct ieee80211_hw *dev,
+				struct ieee80211_vif *vif,
+				struct ieee80211_if_conf *conf)
+{
+	struct mrv_priv *priv = dev->priv;
+	int err = 0;
+
+	DEBUG_PRINTK("mrv_config_interf\n");
+	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	mrv_set_bssid(priv, priv->bssid);
+	DEBUG_PRINTK("~mrv_config_interf\n");
+
+	return err;
+}
+
+static int mrv_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+{
+	struct mrv_priv *priv = dev->priv;
+	int err;
+
+	DEBUG_PRINTK("mrv_config: center_freq %i\n", conf->channel->center_freq);
+
+	err = mrv_set_channel(priv, conf->channel);
+	if (err) {
+		printk(KERN_ERR"~Failed to set channel\n");
+		return -1;
+	} else {
+	  DEBUG_PRINTK("Succeeded setting channel\n");
+	}
+	/* TODO in monitor mode make sure it use IEEE80211G mode */
+	/*if (conf->phymode == MODE_IEEE80211G)
+		err = mrv_set_allowed_rates(priv, 1);
+	else
+		err = mrv_set_allowed_rates(priv, 0);
+
+	if (err) {
+		printk(KERN_ERR"~Failed to set rates\n");
+		return -1;
+	}
+	*/
+	err = mrv_set_slot(priv, conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME);
+	if (err) {
+		printk(KERN_ERR"~Failed to set slot\n");
+		return -1;
+	}
+	/*we must set again bssid filter after changing ch ?*/
+	mrv_set_bssid(priv, priv->bssid);
+
+	/* we must set the promisc mode *after* changing ch */
+	/*mrv_set_promisc(priv,priv->mode == IEEE80211_IF_TYPE_MNTR);*/
+	mrv_set_promisc(priv, 1);
+
+	/*mrv_set_postscan(priv);*/
+
+	DEBUG_PRINTK("~mrv_config\n");
+
+	return 0;
+}
+
+static int mrv_set_rts_threshold(struct ieee80211_hw *dev, u32 val)
+{
+	struct mrv_cmd_hdr  *cmd;
+	struct mrv_cmd_set_rts_threshold *data;
+	struct mrv_priv *priv = dev->priv;
+
+	DEBUG_PRINTK("set_rts\n");
+
+	cmd = mrv_cmd(priv, MRV_CMD_SET_RTS_THRESHOLD,
+		MRV_CMD_SET_RTS_THRESHOLD_SZ, 0, 1);
+
+	data = (struct mrv_cmd_set_rts_threshold *)MRV_CMD_PAYLOAD(cmd);
+
+	data->threshold = cpu_to_le32(val);
+
+	if (mrv_send_cmd_sync(priv)) {
+		printk(KERN_ERR"Could not set rts threshold\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mrv_remove_interface(struct ieee80211_hw *dev,
+				 struct ieee80211_if_init_conf *conf)
+{
+	struct mrv_priv *priv = dev->priv;
+	DEBUG_PRINTK("mrv_remove_interface\n");
+	priv->mode = IEEE80211_IF_TYPE_INVALID;
+	DEBUG_PRINTK("~mrv_remove_interface\n");
+}
+
+static int mrv_add_interface(struct ieee80211_hw *dev,
+			     struct ieee80211_if_init_conf *conf)
+{
+	struct mrv_priv *priv = dev->priv;
+	u8 bssid[] = {0, 0, 0, 0, 0, 0};
+
+	DEBUG_PRINTK("mrv_add_interface\n");
+	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
+	if (priv->mode != IEEE80211_IF_TYPE_INVALID /*IEEE80211_IF_TYPE_MGMT*/)
+		return -1;
+
+	memcpy(priv->bssid, bssid, ETH_ALEN);
+	priv->mode = conf->type;
+	mrv_set_mac_addr(priv, conf->mac_addr);
+
+	return 0;
+}
+
+static void mrv_set_d80211_stuff(struct mrv_priv *priv)
+{
+	DEBUG_PRINTK("mrv_set_d80211_stuff\n");
+	/*memcpy(priv->channels, mrv_channels, sizeof(mrv_channels));
+	memcpy(priv->rates, mrv_rates, sizeof(mrv_rates));
+	priv->modes[0].mode = MODE_IEEE80211G;
+	priv->modes[0].num_rates = ARRAY_SIZE(mrv_rates);
+	priv->modes[0].rates = priv->rates;
+	priv->modes[0].num_channels = ARRAY_SIZE(mrv_channels);
+	priv->modes[0].channels = priv->channels;
+	priv->modes[1].mode = MODE_IEEE80211B;
+	priv->modes[1].num_rates = 4;
+	priv->modes[1].rates = priv->rates;
+	priv->modes[1].num_channels = ARRAY_SIZE(mrv_channels);
+	priv->modes[1].channels = priv->channels;*/
+	priv->dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING /*|
+		     IEEE80211_HW_WEP_INCLUDE_IV |
+		     IEEE80211_HW_DATA_NULLFUNC_ACK*/;
+	priv->dev->extra_tx_headroom = 8; /* 6 bytes addr4, 2 bytes FW len */
+	priv->dev->queues = 1;
+	priv->dev->max_rssi = 100; /* just to avoid dividing by zero */
+	/*priv->dev->channel_change_time = 300000;*/
+	priv->mode = IEEE80211_IF_TYPE_INVALID/*IEEE80211_IF_TYPE_MGMT*/;
+	/*priv->mode = IEEE80211_IF_TYPE_STA;*/
+	DEBUG_PRINTK("~mrv_set_d80211_stuff\n");
+}
+
+static struct ieee80211_ops mrv_ops = {
+	.tx			= mrv_tx,
+	.start			= mrv_start,
+	.stop			= mrv_stop,
+	.add_interface		= mrv_add_interface,
+	.remove_interface	= mrv_remove_interface,
+	.config			= mrv_config,
+	.config_interface	= mrv_config_interface,
+	.configure_filter	= mrv_configure_filter,
+	.set_rts_threshold	= mrv_set_rts_threshold,
+
+};
+
+const struct mrv_rate mrv_supported_rates[12] = {
+	{ .bitrate = 10,
+	  .hw_value = 0 | (1<<4),
+	  /*.flags = IEEE80211_CCK_RATE_1MB_MASK*/
+	},
+	{ .bitrate = 20,
+	  .hw_value = 1 | (1<<4),
+	  /*.flags = IEEE80211_CCK_RATE_2MB_MASK*/
+	},
+	{ .bitrate = 55,
+	  .hw_value = 2 | (1<<4),
+	  /*.flags = IEEE80211_CCK_RATE_5MB_MASK*/
+	},
+	{ .bitrate = 110,
+	  .hw_value = 3 | (1<<4),
+	  /*.flags = IEEE80211_CCK_RATE_11MB_MASK*/
+	},
+	{ .bitrate = 60,
+	  .hw_value = 4 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_6MB_MASK*/
+	},
+	{ .bitrate = 90,
+	  .hw_value = 5 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_9MB_MASK*/
+	},
+	{ .bitrate = 120,
+	  .hw_value = 6 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_12MB_MASK*/
+	},
+	{ .bitrate = 180,
+	  .hw_value = 7 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_18MB_MASK*/
+	},
+	{ .bitrate = 240,
+	  .hw_value = 8 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_24MB_MASK*/
+	},
+	{ .bitrate = 360,
+	  .hw_value = 9 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_36MB_MASK*/
+	},
+	{ .bitrate = 480,
+	  .hw_value = 10 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_48MB_MASK*/
+	},
+	{ .bitrate = 540,
+	  .hw_value = 11 | (1<<4),
+	  /*.flags = IEEE80211_OFDM_RATE_54MB_MASK*/
+	},
+};
+
+static unsigned int
+mrv_copy_channels(struct mrv_hw *mh,
+		  struct ieee80211_channel *channels,
+		  unsigned int max)
+{
+	unsigned int i, count, freq, ch;
+	DEBUG_PRINTK("mrv_copy_channels\n");
+
+	count = 0;
+	for (i = 0; i < 14; i++) {
+		ch = i + 1;
+		freq = ieee80211chan2mhz(ch);
+
+		DEBUG_PRINTK("mrv_copy_channel %i\n", i);
+		/* Write channel info and increment counter */
+		channels[count].center_freq = freq;
+		channels[count].band = IEEE80211_BAND_2GHZ;
+		count++;
+	}
+	DEBUG_PRINTK("~mrv_copy_channels\n");
+	return count;
+}
+
+static unsigned int
+mrv_copy_rates(struct ieee80211_rate *rates,
+	       const struct mrv_rate *rt,
+	       unsigned int max)
+{
+	unsigned int i, count;
+	DEBUG_PRINTK("mrv_copy_rates\n");
+
+	if (rt == NULL) {
+		DEBUG_PRINTK("~mrv_copy_rates (rt == NULL)\n");
+		return 0;
+	}
+	for (i = 0, count = 0; i < 12 && max > 0; i++) {
+		DEBUG_PRINTK("mrv_copy_rate %i: %i\n", i, rt[i].bitrate);
+		rates[count].bitrate = rt[i].bitrate;
+		rates[count].hw_value = rt[i].hw_value;
+		/*rates[count].flags = rt->flags;*/
+		count++;
+		max--;
+	}
+
+	DEBUG_PRINTK("~mrv_copy_rates\n");
+	return count;
+}
+
+void
+mrv_debug_dump_bands(struct mrv_priv *mp)
+{
+	unsigned int b, i;
+
+	BUG_ON(!mp->sbands);
+
+	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+		struct ieee80211_supported_band *band = &mp->sbands[b];
+		char bname[5];
+		switch (band->band) {
+		case IEEE80211_BAND_2GHZ:
+			strcpy(bname, "2 GHz");
+			break;
+		case IEEE80211_BAND_5GHZ:
+			strcpy(bname, "5 GHz");
+			break;
+		default:
+			DEBUG_PRINTK("Band not supported: %d\n",
+				     band->band);
+			return;
+		}
+		DEBUG_PRINTK("Band %s: channels %d, rates %d\n",
+			     bname,
+			     band->n_channels,
+			     band->n_bitrates);
+		DEBUG_PRINTK(" channels:\n");
+		for (i = 0; i < band->n_channels; i++)
+			DEBUG_PRINTK("	ch %3d freq %d hwv %.4x fl %.4x\n",
+				     ieee80211_frequency_to_channel(
+						band->channels[i].center_freq),
+				     band->channels[i].center_freq,
+				     band->channels[i].hw_value,
+				     band->channels[i].flags);
+		DEBUG_PRINTK(" rates:\n");
+		for (i = 0; i < band->n_bitrates; i++)
+			DEBUG_PRINTK("	bitr %4d hw_val %.4x fl %.4x hw_val_short %.4x\n",
+					band->bitrates[i].bitrate,
+					band->bitrates[i].hw_value,
+					band->bitrates[i].flags,
+					band->bitrates[i].hw_value_short);
+	}
+}
+
+static int
+mrv_getchannels(struct ieee80211_hw *hw)
+{
+	struct mrv_priv *mrv_priv = hw->priv;
+	struct mrv_hw *mh = mrv_priv->mh;
+	struct ieee80211_supported_band *sbands = mrv_priv->sbands;
+	/*const struct mrv_rate_table *hw_rates;*/
+	unsigned int max_r, max_c, count_r, count_c;
+
+	struct ieee80211_supported_band *sbandg =
+	  &sbands[IEEE80211_BAND_2GHZ];
+	/*struct ieee80211_supported_band *sbanda =
+	  &sbands[IEEE80211_BAND_5GHZ];*/
+
+	BUILD_BUG_ON(ARRAY_SIZE(mrv_priv->sbands) < IEEE80211_NUM_BANDS);
+
+	DEBUG_PRINTK("mrv_getchannels\n");
+
+	max_r = ARRAY_SIZE(mrv_priv->rates);
+	max_c = ARRAY_SIZE(mrv_priv->channels);
+	count_r = count_c = 0;
+
+	/* 2GHz band */
+
+		sbandg->bitrates = mrv_priv->rates;
+		sbandg->channels = mrv_priv->channels;
+
+		sbandg->band = IEEE80211_BAND_2GHZ;
+		sbandg->n_channels = mrv_copy_channels(mh, sbandg->channels,
+						       max_c);
+
+		/*hw_rates = mrv_hw_get_rate_table(mh, mode2g);*/
+		sbandg->n_bitrates = mrv_copy_rates(sbandg->bitrates,
+						    mrv_supported_rates, max_r);
+		DEBUG_PRINTK("mrv_getchannels n_bitrates %i\n",
+			     sbandg->n_bitrates);
+
+		count_c = sbandg->n_channels;
+		count_r = sbandg->n_bitrates;
+
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sbandg;
+
+		max_r -= count_r;
+		max_c -= count_c;
+
+	/* 5GHz band */
+		/*
+		sbanda->bitrates = &mrv_priv->rates[count_r];
+		sbanda->channels = &mrv_priv->channels[count_c];
+
+		sbanda->band = IEEE80211_BAND_5GHZ;
+		sbanda->n_channels = 0; //mrv_copy_channels(mh, sbanda->channels,
+					 AR5K_MODE_11A, max_c);//
+
+		//hw_rates = mrv_hw_get_rate_table(mh, AR5K_MODE_11A);
+		sbanda->n_bitrates = 0; //ath5k_copy_rates(sbanda->bitrates,
+					hw_rates, max_r);//
+
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sbanda;
+		*/
+		mrv_debug_dump_bands(mrv_priv);
+
+		DEBUG_PRINTK("~mrv_getchannels\n");
+	return 0;
+}
+
+static int __devinit mrv_init_one(struct pci_dev *pdev,
+				  const struct pci_device_id *ent)
+{
+	struct ieee80211_hw *dev = NULL;
+	struct mrv_priv *priv;
+	unsigned long bar1_start, bar1_len, bar1_flags;
+	unsigned long bar2_start, bar2_len, bar2_flags;
+	void *bar1_addr = NULL, *bar2_addr = NULL;
+	int err;
+
+	DEBUG_PRINTK("mrv_init_one\n");
+
+	err = pci_enable_device(pdev);
+
+	bar1_start = pci_resource_start(pdev, 0);
+	bar1_len = pci_resource_len(pdev, 0);
+	bar1_flags = pci_resource_flags(pdev, 0);
+
+	if (!(bar1_flags & IORESOURCE_MEM)) {
+		printk(KERN_ERR"bar1 resource type is not memory\n");
+		err = -ENODEV;
+		goto fail_disable_device;
+	}
+
+	bar2_start = pci_resource_start(pdev, 1);
+	bar2_len = pci_resource_len(pdev, 1);
+	bar2_flags = pci_resource_flags(pdev, 1);
+
+	if (!(bar2_flags & IORESOURCE_MEM)) {
+		printk(KERN_ERR"bar1 resource type is not memory\n");
+		err = -ENODEV;
+		goto fail_disable_device;
+	}
+
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	if (err) {
+		printk(KERN_ERR"No usable DMA configuration.\n");
+		goto fail_disable_device;
+	}
+
+	bar1_addr = ioremap_nocache(bar1_start, bar1_len);
+	if (bar1_addr == NULL) {
+		printk(KERN_ERR"Error calling ioremap for bar1.\n");
+		err = -EIO;
+		goto fail_disable_device;
+	}
+
+	bar2_addr = ioremap_nocache(bar2_start, bar2_len);
+	if (bar2_addr == NULL) {
+		printk(KERN_ERR"Error calling ioremap for bar2.\n");
+		err = -EIO;
+		goto fail_iounmap;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		printk(KERN_ERR"Error calling pci_request_regions.\n");
+		goto fail_iounmap;
+	}
+	pci_set_master(pdev);
+	err = pci_set_mwi(pdev);
+
+
+	dev = ieee80211_alloc_hw(sizeof(*priv), &mrv_ops);
+	if (!dev) {
+		printk(KERN_ERR "%s : can't allocate d80211 \n", pci_name(pdev));
+		err = -ENOMEM;
+		goto fail_release_regions;
+	}
+
+	priv = dev->priv;
+	priv->pdev = pdev;
+	priv->dev = dev;
+
+	/*SET_MODULE_OWNER(dev);*/
+
+	SET_IEEE80211_DEV(dev, &pdev->dev);
+	pci_set_drvdata(pdev, dev);
+
+	priv->bar1 = bar1_addr;
+	priv->bar1_phys = bar1_start;
+	priv->bar2 = bar2_addr;
+	priv->bar2_phys = bar2_start;
+
+	sema_init(&priv->cmd_sem, 1);
+
+	tasklet_init(&priv->mrv_rx_tasklet,
+		     (void(*)(unsigned long)) mrv_rx_tasklet,
+		     (unsigned long)priv);
+
+	tasklet_init(&priv->mrv_tx_cb_tasklet,
+		     (void(*)(unsigned long)) mrv_tx_cb_tasklet,
+		     (unsigned long)priv);
+
+	tasklet_disable(&priv->mrv_rx_tasklet);
+	tasklet_disable(&priv->mrv_tx_cb_tasklet);
+
+	init_waitqueue_head(&priv->wait_command_queue);
+
+	spin_lock_init(&priv->irq_th_lock);
+	spin_lock_init(&priv->tx_lock);
+
+	priv->fw_load = 0;
+	priv->up = 0;
+
+	mrv_init_cmd(priv);
+
+	err = mrv_hw_start(priv);
+	if (err)
+		goto fail_deinit_hw;
+
+	mrv_read_config(priv);
+
+	mrv_set_d80211_stuff(priv);
+
+	err = mrv_getchannels(dev);
+	if (err) {
+		printk(KERN_ERR"%s can't register hwmodes\n", pci_name(pdev));
+		goto fail_stop_hw;
+	}
+	/*
+	err = ieee80211_register_hwmode(dev, &priv->modes[0]);
+	if (err) {
+		printk(KERN_ERR"%s can't register hwmode\n", pci_name(pdev));
+		goto fail_stop_hw;
+	}
+
+	err = ieee80211_register_hwmode(dev, &priv->modes[1]);
+	if (err) {
+		printk(KERN_ERR"%s can't register hwmode\n", pci_name(pdev));
+		goto fail_stop_hw;
+	}
+	*/
+
+	DEBUG_PRINTK("ieee80211_register_hw\n");
+	err = ieee80211_register_hw(dev);
+	if (err) {
+		printk(KERN_ERR"%s can't register HW\n", pci_name(pdev));
+		goto fail_stop_hw;
+	}
+
+	DEBUG_PRINTK("~mrv_init_one\n");
+	return 0;
+fail_stop_hw:
+	mrv_hw_halt(priv);
+fail_deinit_hw:
+	mrv_deinit_cmd(priv);
+	pci_set_drvdata(pdev, NULL);
+	ieee80211_free_hw(dev);
+fail_release_regions:
+	pci_release_regions(pdev);
+fail_iounmap:
+	if (bar1_addr)
+		iounmap(bar1_addr);
+	if (bar2_addr)
+		iounmap(bar2_addr);
+fail_disable_device:
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+
+	return err;
+}
+
+static void __devexit mrv_remove_one(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
+	struct mrv_priv *priv;
+
+	DEBUG_PRINTK("mrv_remove\n");
+	if (dev) {
+		priv = dev->priv;
+		mrv_hw_halt(priv);
+
+		ieee80211_unregister_hw(dev);
+		mrv_deinit_cmd(priv);
+
+		if (priv->bar1)
+			iounmap(priv->bar1);
+		if (priv->bar2)
+			iounmap(priv->bar2);
+
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+
+		pci_set_drvdata(pdev, NULL);
+
+		ieee80211_free_hw(dev);
+	 }
+}
+
+
+static struct pci_driver mrv_pci_driver = {
+	.name		= DRV_NAME,
+	.id_table		= mrv_pci_tbl,
+	.probe		= mrv_init_one,
+	.remove		= __devexit_p(mrv_remove_one),
+};
+
+
+static int __init mrv_init_module(void)
+{
+	printk(KERN_INFO"%s\n", DRV_DESCRIPTION);
+	printk(KERN_INFO"%s\n", DRV_COPYRIGHT);
+
+	return pci_register_driver(&mrv_pci_driver);
+}
+
+static void __exit mrv_cleanup_module(void)
+{
+	pci_unregister_driver(&mrv_pci_driver);
+}
+
+module_init(mrv_init_module);
+module_exit(mrv_cleanup_module);
+
diff --git a/drivers/net/wireless/mrv8k/mrv8k.h b/drivers/net/wireless/mrv8k/mrv8k.h
new file mode 100644
index 0000000..743babd
--- /dev/null
+++ b/drivers/net/wireless/mrv8k/mrv8k.h
@@ -0,0 +1,370 @@
+/*
+	d80211 Marvell Libertas PCI driver
+
+	Adoption for wireless-testing.
+	Copyright (c) 2008 Markus Becker <mab@comnets.uni-bremen.de>
+
+	Copyright (c) 2007 Andrea Merello <andreamrl@tiscali.it>
+
+	Based on existent mrv8k driver
+	Copyright (c) 2005 Luc Saillard <luc@saillard.org>
+
+	Based on BSD malo driver (no code has been copyed. Programming
+	methods, magic values, and card specific programming details
+	has been looked at)
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; see the file COPYING.  If not, write to
+	the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+	Boston, MA 02110-1301, USA.
+
+*/
+
+#define DRV_COPYRIGHT   "Andrea Merello <andreamrl *at* tiscali.it>\nMarkus Becker <mab *at* comnets.uni-bremen.de>"
+#define DRV_DESCRIPTION "mac80211 Marvell Libertas PCI/PCMCIA driver"
+#define DRV_VERSION 	"0.1"
+#define DRV_NAME	"mrv8k"
+#define FW_FIRMWARE_FILENAME "mrv8k-f.fw"
+#define FW_BOOT_FILENAME     "mrv8k-b.fw"
+
+#ifdef CONFIG_MRV8K_DEBUG
+#define DEBUG_PRINTK(__msg, __args...)	\
+	printk(KERN_DEBUG __msg " - ", ##__args)
+#else
+#define DEBUG_PRINTK(__msg, __args...)	\
+	do { } while (0)
+#endif /* CONFIG_MRV8K_DEBUG */
+
+#define MRV_CMD_PKT_SIZE	512
+#define MRV_CMD_MAGIC		0xAA55AA55
+#define MRV_FW_SIGNATURE	0xf0f1f2f4
+
+/* it is intentional we add sizeof(mrv_cmd_hdr) to all commands, but we don't add the header len
+ * when we send the MRV_CMD_FW. Bootloader don't want the header len, while firmware seems to
+ * need it
+ */
+#define MRV_CMD_FW			0x001
+#define MRV_CMD_GET_CONFIG		0x003
+#define MRV_CMD_GET_CONFIG_SZ		(sizeof(struct mrv_cmd_get_config)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_RADIO		0x01c
+#define MRV_CMD_SET_RADIO_SZ		(sizeof(struct mrv_cmd_set_radio)+sizeof(struct mrv_cmd_hdr))
+#define MRV_PREAMBLE_AUTO		5
+#define MRV_PREAMBLE_SHORT		1
+#define MRV_PREAMBLE_LONG		3
+#define MRV_CMD_SET_TXPOWER		0x01e
+#define MRV_CMD_SET_TXPOWER_SZ		(sizeof(struct mrv_cmd_set_txpower)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_ANTENNA		0x020
+#define MRV_CMD_SET_ANTENNA_SZ		(sizeof(struct mrv_cmd_set_antenna)+sizeof(struct mrv_cmd_hdr))
+#define MRV_ANTENNA_RXA			1
+#define MRV_ANTENNA_TXA			2
+#define MRV_ANTENNA_RXB			4
+#define MRV_ANTENNA_TXB			8
+
+#define MRV_CMD_SET_PRESCAN		0x0107
+#define MRV_CMD_SET_PRESCAN_SZ		sizeof(struct mrv_cmd_hdr)
+#define MRV_CMD_SET_POSTSCAN		0x0108
+#define MRV_CMD_SET_POSTSCAN_SZ		sizeof(struct mrv_cmd_hdr)
+
+#define MRV_CMD_SET_CHANNEL 		0x10a /*0x1d for usb*/
+#define MRV_CMD_SET_CHANNEL_SZ		(sizeof(struct mrv_cmd_set_channel)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_RATES		0x110 /*0x22 0x76 0x7f about rates USB*/
+#define MRV_CMD_SET_RATES_SZ		(sizeof(struct mrv_cmd_set_rates)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_RTS_THRESHOLD	0x113
+#define MRV_CMD_SET_RTS_THRESHOLD_SZ	(sizeof(struct mrv_cmd_set_rts_threshold)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_SLOT		0x114
+#define MRV_CMD_SET_SLOT_SZ		(sizeof(struct mrv_cmd_set_slot)+sizeof(struct mrv_cmd_hdr))
+#define MRV_CMD_SET_MAC_ADDR		0x202
+#define MRV_CMD_SET_MAC_ADDR_SZ		(sizeof(struct mrv_cmd_set_mac_addr)+sizeof(struct mrv_cmd_hdr))
+
+#define MRV_CMD_PAYLOAD(x) (((u8 *)x) + sizeof(struct mrv_cmd_hdr))
+
+
+#define MRV_INTA_MASK 0x1f
+#define MRV_INTB_MASK 0x1f
+
+#define MRV_REG_CMD_PTR			0xc10
+#define MRV_REG_STATUS			0xc14
+#define MRV_REG_GEN_ARM_INT		0xc18
+#define MRV_REG_INTA_MASK		0xc34
+#define MRV_REG_INTB_MASK		0xc3c
+#define MRV_REG_ISR			0xc30
+#define MRV_REG_RX_MODE			0xa300
+#define MRV_REG_BSSID			0xa530
+#define MRV_MEM_CMD_BOOT		0xbef8
+#define MRV_HWMEM_CMD_BOOT	(0xc0000000 | MRV_MEM_CMD_BOOT)
+
+#define PCI_DEVICE_ID_MARVELL_W8K (0x1FA6)
+#define WL3563 0
+#define WL138G 1
+#define W8335 2
+#define WLGENERIC 3
+
+#define MRV_RX_DESC_NUM		128
+#define MRV_RX_PAYLOAD_LEN	(2342 + 8)
+#define MRV_MAX_RX_INT		128
+
+#define MRV_TX_DESC_NUM		128
+
+#define MRV_INVALID_STATUS_1	0xFFFFFFFF
+#define MRV_INVALID_STATUS_2	0
+#define MRV_TX_INT		0x1
+#define MRV_RX_INT		0x2
+#define MRV_CMD_DONE_INT	0x4
+
+struct mrv_rate {
+  unsigned short flags;
+  unsigned short bitrate; /* In 100kbit/s */
+  unsigned short hw_value;
+};
+
+struct mrv_hw {
+  unsigned int supported_bands;
+  unsigned int supported_rates;
+
+  unsigned int num_channels;
+
+  const u8 *tx_power_a;
+  const u8 *tx_power_bg;
+  u8 tx_power_default;
+};
+
+struct mrv_rx_descriptor {
+	u8	drvowner;
+	u8	rssi;
+	u8	status;			/* Need to be set to 1 */
+	u8	chan;
+	__le16	datalen;
+	u8	rsvd0;
+	u8	rate;
+	__le32	dma_data;		/* Point to the dma buffer use to transfer the data */
+	__le32	dma_next;		/* Point to the next dma buffer to transfer control data */
+	__le16	qos;
+	__le16	rsvd1;
+} __attribute__((packed));
+
+struct mrv_tx_descriptor {
+	__le16	status;
+	__le16	fwowner;
+	u8	rate;
+	u8	priority;
+	__le16	qos;
+	__le32	dma_addr;
+	__le16	len;
+	u8	dest_addr[6];
+	__le32	dma_next;
+	__le32	rsvd0;
+	__le32	rsvd1;
+} __attribute__((packed));
+
+struct mrv_priv {
+	struct pci_dev *pdev;
+	struct ieee80211_hw *dev;
+	void *bar1;
+	unsigned long bar1_phys;
+	void *bar2;
+	unsigned long bar2_phys;
+
+	u8 *cmd_virt;
+	dma_addr_t cmd_dma;
+	__le32 *magic_virt;
+	dma_addr_t magic_dma;
+
+	int cmd_status;
+	struct semaphore cmd_sem;
+
+	struct tasklet_struct mrv_rx_tasklet;
+	struct tasklet_struct mrv_tx_cb_tasklet;
+	spinlock_t irq_th_lock;
+	spinlock_t tx_lock;
+	wait_queue_head_t wait_command_queue;
+
+	int ant_num;
+	int fw_ver;
+	int hw_ver;
+	int tx_ring_num;
+	int region_code;
+	int tx_hw_dma0;
+	int tx_hw_dma1;
+	int tx_hw_dma2;
+	int tx_hw_dma3;
+	int rx_hw_dma_r;
+	int rx_hw_dma_w;
+
+	struct sk_buff *rx_skb[MRV_RX_DESC_NUM];
+	struct mrv_rx_descriptor *rx_ring_virt[MRV_RX_DESC_NUM];
+	dma_addr_t rx_ring_dma[MRV_RX_DESC_NUM];
+	int rx_idx;
+
+	struct sk_buff *tx_skb[MRV_TX_DESC_NUM];
+	struct mrv_tx_descriptor *tx_ring_virt[MRV_TX_DESC_NUM];
+	dma_addr_t tx_ring_dma[MRV_TX_DESC_NUM];
+	int tx_w_idx;
+	int tx_r_idx;
+	int tx_pending;
+
+	u8 bssid[ETH_ALEN];
+	int mode;
+	int fw_load;
+	int up;
+
+  struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+  struct mrv_hw *mh;
+  struct ieee80211_rate rates[12];
+  struct ieee80211_channel channels[14];
+};
+
+static inline unsigned int mrv_reg_read8(struct mrv_priv *priv,
+					 unsigned int reg)
+{
+	return readb(priv->bar2 + reg);
+}
+static inline unsigned int mrv_reg_read16(struct mrv_priv *priv,
+					  unsigned int reg)
+{
+	return readw(priv->bar2 + reg);
+}
+static inline unsigned int mrv_reg_read32(struct mrv_priv *priv,
+					  unsigned int reg)
+{
+	return readl(priv->bar2 + reg);
+}
+
+static inline void mrv_reg_write8(struct mrv_priv *priv,
+				  unsigned int reg,
+				  __le32 value)
+{
+	writeb(value, (void *)(priv->bar2 + reg));
+}
+static inline void mrv_reg_write16(struct mrv_priv *priv,
+				   unsigned int reg,
+				   __le32 value)
+{
+	writew(value, (void *)(priv->bar2 + reg));
+}
+static inline void mrv_reg_write32(struct mrv_priv *priv,
+				   unsigned int reg,
+				   __le32 value)
+{
+	writel(value, (void *)(priv->bar2 + reg));
+}
+
+static inline unsigned int mrv_mem_read8(struct mrv_priv *priv,
+					 unsigned int reg)
+{
+	return readb(priv->bar1 + reg);
+}
+static inline unsigned int mrv_mem_read16(struct mrv_priv *priv,
+					  unsigned int reg)
+{
+	return readw(priv->bar1 + reg);
+}
+static inline unsigned int mrv_mem_read32(struct mrv_priv *priv,
+					  unsigned int reg)
+{
+	return readl(priv->bar1 + reg);
+}
+
+static inline void mrv_mem_write8(struct mrv_priv *priv,
+				  unsigned int reg,
+				  __le32 value)
+{
+	writeb(value, (void *)(priv->bar1 + reg));
+}
+static inline void mrv_mem_write16(struct mrv_priv *priv,
+				   unsigned int reg,
+				   __le32 value)
+{
+	writew(value, (void *)(priv->bar1 + reg));
+}
+static inline void mrv_mem_write32(struct mrv_priv *priv,
+				   unsigned int reg,
+				   __le32 value)
+{
+	writel(value, (void *)(priv->bar1 + reg));
+}
+static inline void mrv_reg_mb(struct mrv_priv *priv)
+{
+	mb();
+	mrv_reg_read8(priv, 0);
+}
+
+struct mrv_cmd_hdr {
+	__le16 type;
+	__le16 len;
+	__le16 sq;
+	__le16 status;
+} __attribute__ ((packed));
+
+struct mrv_cmd_get_config {
+	__le16	hw_ver;
+	__le16	tx_ring_num;
+	__le16	mcast_adr_num;
+	u8	mac_adr[6];
+	__le16	region_code;
+	__le16	ant_num;
+	__le32	fw_ver;
+	__le32	tx_ring0;
+	__le32	rx_ring_w;
+	__le32	rx_ring_r;
+	__le32	magic;
+	__le32	tx_ring1;
+	__le32	tx_ring2;
+	__le32	tx_ring3;
+} __attribute__((packed));
+
+struct mrv_cmd_set_channel {
+	__le16	flag;
+	u8	ch;
+  /*	__le16 rftype;
+	__le16 rsvd0;
+	u8	chlist[32];*/
+} __attribute__((packed));
+
+struct mrv_cmd_set_antenna {
+	__le16	rtx;
+	__le16	param;
+} __attribute__((packed));
+
+struct mrv_cmd_set_radio {
+	__le16	flag;
+	__le16	preamble;
+	__le16	enable;
+} __attribute__((packed));
+
+struct mrv_cmd_set_rates {
+	u8	fixedrate;
+	u8	fixedindex;
+	u8	rates[14];
+} __attribute__((packed));
+
+struct mrv_cmd_set_mac_addr {
+	u8	addr[6];
+} __attribute__((packed));
+
+struct mrv_cmd_set_txpower {
+	__le16	action;
+	__le16	txpower;
+	__le16	currentpowerlvl;
+	__le16	rsvd;
+	__le16	powers[8];
+} __attribute__((packed));
+
+struct mrv_cmd_set_rts_threshold{
+	__le32	threshold;
+} __attribute__((packed));
+
+
+struct mrv_cmd_set_slot {
+	__le16	action;
+	u8	shortslot;
+} __attribute__ ((packed));
