Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57898 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3DATbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:31:01 -0400
Date: Mon, 1 Apr 2013 15:24:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	John Crispin <blogic@openwrt.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2x00pci: fix build error on Ralink RT3x5x SoCs
Message-ID: <20130401192414.GE3526@tuxdriver.com> (sfid-20130401_213110_238557_5CF7097D)
References: <1364568747-28907-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364568747-28907-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I reckon that this is OK, since it is mostly just moving code around
to satisfy build requirements.  But, it doesn't seem to apply to the
wireless.git tree...?

On Fri, Mar 29, 2013 at 03:52:27PM +0100, Gabor Juhos wrote:
> The rt2800pci driver supports the built-in wireless
> MAC of the Ralink RT3x5x SoCs. However building the
> driver for these SoCs leads to the following error:
> 
>     LD      init/built-in.o
>   drivers/built-in.o: In function `rt2800pci_rxdone_tasklet':
>   <...>/drivers/net/wireless/rt2x00/rt2800pci.c:1012: undefined reference to `rt2x00pci_rxdone'
>   drivers/built-in.o:(.rodata+0x4780): undefined reference to `rt2x00pci_initialize'
>   drivers/built-in.o:(.rodata+0x4784): undefined reference to `rt2x00pci_uninitialize'
>   drivers/built-in.o:(.rodata+0x47bc): undefined reference to `rt2x00pci_flush_queue'
>   drivers/built-in.o:(.rodata+0x4818): undefined reference to `rt2x00pci_regbusy_read'
>   make[5]: *** [vmlinux] Error 1
> 
> The missing functions are provided by the rt2x00pci
> module. This module is only selected by the rt2800pci
> driver if PCI support is enabled in the kernel, because
> some parts of the rt2x00pci code depends on PCI support.
> 
> PCI support is not available on the RT3x5x SoCs because
> those have no PCI host controller at all.
> 
> Move the non PCI specific code from rt2x00pci into a
> separate module. This makes it possible to use that
> code even if PCI support is disabled. The affected
> functions are used by all of the rt2x00 PCI drivers
> so select the new module for those drivers.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
> Note:
> 
> This patch can be used as a replacement of the
> 'rt2x00: make the driver build for Ralink SoC'
> patch [1] from John Crispin.
> 
> I have sent a similar patch to the rt2x00 list
> three days ago, but that is too intrusive for
> 3.9. This version fixes the original problem in
> the same way, but does not changes the function
> prefixes from rt2x00pci to rt2x00mmio in order
> to keep the patch small. The prefix change can
> be done later.
> 
> If this version is still too intrusive, John's
> patch [1] should be applied to 3.9 as a temporary
> fix in order to avoid the build error.
> 
> Although checkpatch.pl throws several warnings
> (mainly about block comment styles), but those
> are caused by the existing code. The patch simply
> moves the code from one file to another.
> 
> -Gabor
> 
> 1. https://patchwork.kernel.org/patch/2309521/
> 2. http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-March/005837.html
> ---
>  drivers/net/wireless/rt2x00/Kconfig      |    7 +
>  drivers/net/wireless/rt2x00/Makefile     |    1 +
>  drivers/net/wireless/rt2x00/rt2400pci.c  |    1 +
>  drivers/net/wireless/rt2x00/rt2500pci.c  |    1 +
>  drivers/net/wireless/rt2x00/rt2800pci.c  |    1 +
>  drivers/net/wireless/rt2x00/rt2x00mmio.c |  216 ++++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00mmio.h |  119 ++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2x00pci.c  |  176 ------------------------
>  drivers/net/wireless/rt2x00/rt2x00pci.h  |   88 ------------
>  drivers/net/wireless/rt2x00/rt61pci.c    |    1 +
>  10 files changed, 347 insertions(+), 264 deletions(-)
>  create mode 100644 drivers/net/wireless/rt2x00/rt2x00mmio.c
>  create mode 100644 drivers/net/wireless/rt2x00/rt2x00mmio.h
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index ffe61d5..9b915d3 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -20,6 +20,7 @@ if RT2X00
>  config RT2400PCI
>  	tristate "Ralink rt2400 (PCI/PCMCIA) support"
>  	depends on PCI
> +	select RT2X00_LIB_MMIO
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -31,6 +32,7 @@ config RT2400PCI
>  config RT2500PCI
>  	tristate "Ralink rt2500 (PCI/PCMCIA) support"
>  	depends on PCI
> +	select RT2X00_LIB_MMIO
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -43,6 +45,7 @@ config RT61PCI
>  	tristate "Ralink rt2501/rt61 (PCI/PCMCIA) support"
>  	depends on PCI
>  	select RT2X00_LIB_PCI
> +	select RT2X00_LIB_MMIO
>  	select RT2X00_LIB_FIRMWARE
>  	select RT2X00_LIB_CRYPTO
>  	select CRC_ITU_T
> @@ -57,6 +60,7 @@ config RT2800PCI
>  	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
>  	depends on PCI || SOC_RT288X || SOC_RT305X
>  	select RT2800_LIB
> +	select RT2X00_LIB_MMIO
>  	select RT2X00_LIB_PCI if PCI
>  	select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
>  	select RT2X00_LIB_FIRMWARE
> @@ -192,6 +196,9 @@ endif
>  config RT2800_LIB
>  	tristate
>  
> +config RT2X00_LIB_MMIO
> +	tristate
> +
>  config RT2X00_LIB_PCI
>  	tristate
>  	select RT2X00_LIB
> diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
> index 349d5b8..f069d8b 100644
> --- a/drivers/net/wireless/rt2x00/Makefile
> +++ b/drivers/net/wireless/rt2x00/Makefile
> @@ -9,6 +9,7 @@ rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)	+= rt2x00firmware.o
>  rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)	+= rt2x00leds.o
>  
>  obj-$(CONFIG_RT2X00_LIB)		+= rt2x00lib.o
> +obj-$(CONFIG_RT2X00_LIB_MMIO)		+= rt2x00mmio.o
>  obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
>  obj-$(CONFIG_RT2X00_LIB_SOC)		+= rt2x00soc.o
>  obj-$(CONFIG_RT2X00_LIB_USB)		+= rt2x00usb.o
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 221beaa..dcfb54e 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -34,6 +34,7 @@
>  #include <linux/slab.h>
>  
>  #include "rt2x00.h"
> +#include "rt2x00mmio.h"
>  #include "rt2x00pci.h"
>  #include "rt2400pci.h"
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 39edc59..e1d2dc9 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -34,6 +34,7 @@
>  #include <linux/slab.h>
>  
>  #include "rt2x00.h"
> +#include "rt2x00mmio.h"
>  #include "rt2x00pci.h"
>  #include "rt2500pci.h"
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index f732ded..565a80d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -41,6 +41,7 @@
>  #include <linux/eeprom_93cx6.h>
>  
>  #include "rt2x00.h"
> +#include "rt2x00mmio.h"
>  #include "rt2x00pci.h"
>  #include "rt2x00soc.h"
>  #include "rt2800lib.h"
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.c b/drivers/net/wireless/rt2x00/rt2x00mmio.c
> new file mode 100644
> index 0000000..d84a680
> --- /dev/null
> +++ b/drivers/net/wireless/rt2x00/rt2x00mmio.c
> @@ -0,0 +1,216 @@
> +/*
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	<http://rt2x00.serialmonkey.com>
> +
> +	This program is free software; you can redistribute it and/or modify
> +	it under the terms of the GNU General Public License as published by
> +	the Free Software Foundation; either version 2 of the License, or
> +	(at your option) any later version.
> +
> +	This program is distributed in the hope that it will be useful,
> +	but WITHOUT ANY WARRANTY; without even the implied warranty of
> +	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +	GNU General Public License for more details.
> +
> +	You should have received a copy of the GNU General Public License
> +	along with this program; if not, write to the
> +	Free Software Foundation, Inc.,
> +	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +/*
> +	Module: rt2x00mmio
> +	Abstract: rt2x00 generic mmio device routines.
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +
> +#include "rt2x00.h"
> +#include "rt2x00mmio.h"
> +
> +/*
> + * Register access.
> + */
> +int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
> +			   const unsigned int offset,
> +			   const struct rt2x00_field32 field,
> +			   u32 *reg)
> +{
> +	unsigned int i;
> +
> +	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
> +		return 0;
> +
> +	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +		rt2x00pci_register_read(rt2x00dev, offset, reg);
> +		if (!rt2x00_get_field32(*reg, field))
> +			return 1;
> +		udelay(REGISTER_BUSY_DELAY);
> +	}
> +
> +	printk_once(KERN_ERR "%s() Indirect register access failed: "
> +	      "offset=0x%.08x, value=0x%.08x\n", __func__, offset, *reg);
> +	*reg = ~0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
> +
> +bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct data_queue *queue = rt2x00dev->rx;
> +	struct queue_entry *entry;
> +	struct queue_entry_priv_pci *entry_priv;
> +	struct skb_frame_desc *skbdesc;
> +	int max_rx = 16;
> +
> +	while (--max_rx) {
> +		entry = rt2x00queue_get_entry(queue, Q_INDEX);
> +		entry_priv = entry->priv_data;
> +
> +		if (rt2x00dev->ops->lib->get_entry_state(entry))
> +			break;
> +
> +		/*
> +		 * Fill in desc fields of the skb descriptor
> +		 */
> +		skbdesc = get_skb_frame_desc(entry->skb);
> +		skbdesc->desc = entry_priv->desc;
> +		skbdesc->desc_len = entry->queue->desc_size;
> +
> +		/*
> +		 * DMA is already done, notify rt2x00lib that
> +		 * it finished successfully.
> +		 */
> +		rt2x00lib_dmastart(entry);
> +		rt2x00lib_dmadone(entry);
> +
> +		/*
> +		 * Send the frame to rt2x00lib for further processing.
> +		 */
> +		rt2x00lib_rxdone(entry, GFP_ATOMIC);
> +	}
> +
> +	return !max_rx;
> +}
> +EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
> +
> +void rt2x00pci_flush_queue(struct data_queue *queue, bool drop)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; !rt2x00queue_empty(queue) && i < 10; i++)
> +		msleep(10);
> +}
> +EXPORT_SYMBOL_GPL(rt2x00pci_flush_queue);
> +
> +/*
> + * Device initialization handlers.
> + */
> +static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
> +				     struct data_queue *queue)
> +{
> +	struct queue_entry_priv_pci *entry_priv;
> +	void *addr;
> +	dma_addr_t dma;
> +	unsigned int i;
> +
> +	/*
> +	 * Allocate DMA memory for descriptor and buffer.
> +	 */
> +	addr = dma_alloc_coherent(rt2x00dev->dev,
> +				  queue->limit * queue->desc_size,
> +				  &dma, GFP_KERNEL);
> +	if (!addr)
> +		return -ENOMEM;
> +
> +	memset(addr, 0, queue->limit * queue->desc_size);
> +
> +	/*
> +	 * Initialize all queue entries to contain valid addresses.
> +	 */
> +	for (i = 0; i < queue->limit; i++) {
> +		entry_priv = queue->entries[i].priv_data;
> +		entry_priv->desc = addr + i * queue->desc_size;
> +		entry_priv->desc_dma = dma + i * queue->desc_size;
> +	}
> +
> +	return 0;
> +}
> +
> +static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
> +				     struct data_queue *queue)
> +{
> +	struct queue_entry_priv_pci *entry_priv =
> +	    queue->entries[0].priv_data;
> +
> +	if (entry_priv->desc)
> +		dma_free_coherent(rt2x00dev->dev,
> +				  queue->limit * queue->desc_size,
> +				  entry_priv->desc, entry_priv->desc_dma);
> +	entry_priv->desc = NULL;
> +}
> +
> +int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct data_queue *queue;
> +	int status;
> +
> +	/*
> +	 * Allocate DMA
> +	 */
> +	queue_for_each(rt2x00dev, queue) {
> +		status = rt2x00pci_alloc_queue_dma(rt2x00dev, queue);
> +		if (status)
> +			goto exit;
> +	}
> +
> +	/*
> +	 * Register interrupt handler.
> +	 */
> +	status = request_irq(rt2x00dev->irq,
> +			     rt2x00dev->ops->lib->irq_handler,
> +			     IRQF_SHARED, rt2x00dev->name, rt2x00dev);
> +	if (status) {
> +		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
> +		      rt2x00dev->irq, status);
> +		goto exit;
> +	}
> +
> +	return 0;
> +
> +exit:
> +	queue_for_each(rt2x00dev, queue)
> +		rt2x00pci_free_queue_dma(rt2x00dev, queue);
> +
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(rt2x00pci_initialize);
> +
> +void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct data_queue *queue;
> +
> +	/*
> +	 * Free irq line.
> +	 */
> +	free_irq(rt2x00dev->irq, rt2x00dev);
> +
> +	/*
> +	 * Free DMA
> +	 */
> +	queue_for_each(rt2x00dev, queue)
> +		rt2x00pci_free_queue_dma(rt2x00dev, queue);
> +}
> +EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
> +
> +/*
> + * rt2x00mmio module information.
> + */
> +MODULE_AUTHOR(DRV_PROJECT);
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_DESCRIPTION("rt2x00 mmio library");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.h b/drivers/net/wireless/rt2x00/rt2x00mmio.h
> new file mode 100644
> index 0000000..4ecaf60
> --- /dev/null
> +++ b/drivers/net/wireless/rt2x00/rt2x00mmio.h
> @@ -0,0 +1,119 @@
> +/*
> +	Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +	<http://rt2x00.serialmonkey.com>
> +
> +	This program is free software; you can redistribute it and/or modify
> +	it under the terms of the GNU General Public License as published by
> +	the Free Software Foundation; either version 2 of the License, or
> +	(at your option) any later version.
> +
> +	This program is distributed in the hope that it will be useful,
> +	but WITHOUT ANY WARRANTY; without even the implied warranty of
> +	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +	GNU General Public License for more details.
> +
> +	You should have received a copy of the GNU General Public License
> +	along with this program; if not, write to the
> +	Free Software Foundation, Inc.,
> +	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +/*
> +	Module: rt2x00mmio
> +	Abstract: Data structures for the rt2x00mmio module.
> + */
> +
> +#ifndef RT2X00MMIO_H
> +#define RT2X00MMIO_H
> +
> +#include <linux/io.h>
> +
> +/*
> + * Register access.
> + */
> +static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
> +					   const unsigned int offset,
> +					   u32 *value)
> +{
> +	*value = readl(rt2x00dev->csr.base + offset);
> +}
> +
> +static inline void rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
> +						const unsigned int offset,
> +						void *value, const u32 length)
> +{
> +	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
> +}
> +
> +static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
> +					    const unsigned int offset,
> +					    u32 value)
> +{
> +	writel(value, rt2x00dev->csr.base + offset);
> +}
> +
> +static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
> +						 const unsigned int offset,
> +						 const void *value,
> +						 const u32 length)
> +{
> +	__iowrite32_copy(rt2x00dev->csr.base + offset, value, length >> 2);
> +}
> +
> +/**
> + * rt2x00pci_regbusy_read - Read from register with busy check
> + * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
> + * @offset: Register offset
> + * @field: Field to check if register is busy
> + * @reg: Pointer to where register contents should be stored
> + *
> + * This function will read the given register, and checks if the
> + * register is busy. If it is, it will sleep for a couple of
> + * microseconds before reading the register again. If the register
> + * is not read after a certain timeout, this function will return
> + * FALSE.
> + */
> +int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
> +			   const unsigned int offset,
> +			   const struct rt2x00_field32 field,
> +			   u32 *reg);
> +
> +/**
> + * struct queue_entry_priv_pci: Per entry PCI specific information
> + *
> + * @desc: Pointer to device descriptor
> + * @desc_dma: DMA pointer to &desc.
> + * @data: Pointer to device's entry memory.
> + * @data_dma: DMA pointer to &data.
> + */
> +struct queue_entry_priv_pci {
> +	__le32 *desc;
> +	dma_addr_t desc_dma;
> +};
> +
> +/**
> + * rt2x00pci_rxdone - Handle RX done events
> + * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
> + *
> + * Returns true if there are still rx frames pending and false if all
> + * pending rx frames were processed.
> + */
> +bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
> +
> +/**
> + * rt2x00pci_flush_queue - Flush data queue
> + * @queue: Data queue to stop
> + * @drop: True to drop all pending frames.
> + *
> + * This will wait for a maximum of 100ms, waiting for the queues
> + * to become empty.
> + */
> +void rt2x00pci_flush_queue(struct data_queue *queue, bool drop);
> +
> +/*
> + * Device initialization handlers.
> + */
> +int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev);
> +void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev);
> +
> +#endif /* RT2X00MMIO_H */
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index b1c673e..e87865e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -33,182 +33,6 @@
>  #include "rt2x00pci.h"
>  
>  /*
> - * Register access.
> - */
> -int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
> -			   const unsigned int offset,
> -			   const struct rt2x00_field32 field,
> -			   u32 *reg)
> -{
> -	unsigned int i;
> -
> -	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
> -		return 0;
> -
> -	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> -		rt2x00pci_register_read(rt2x00dev, offset, reg);
> -		if (!rt2x00_get_field32(*reg, field))
> -			return 1;
> -		udelay(REGISTER_BUSY_DELAY);
> -	}
> -
> -	printk_once(KERN_ERR "%s() Indirect register access failed: "
> -	      "offset=0x%.08x, value=0x%.08x\n", __func__, offset, *reg);
> -	*reg = ~0;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(rt2x00pci_regbusy_read);
> -
> -bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct data_queue *queue = rt2x00dev->rx;
> -	struct queue_entry *entry;
> -	struct queue_entry_priv_pci *entry_priv;
> -	struct skb_frame_desc *skbdesc;
> -	int max_rx = 16;
> -
> -	while (--max_rx) {
> -		entry = rt2x00queue_get_entry(queue, Q_INDEX);
> -		entry_priv = entry->priv_data;
> -
> -		if (rt2x00dev->ops->lib->get_entry_state(entry))
> -			break;
> -
> -		/*
> -		 * Fill in desc fields of the skb descriptor
> -		 */
> -		skbdesc = get_skb_frame_desc(entry->skb);
> -		skbdesc->desc = entry_priv->desc;
> -		skbdesc->desc_len = entry->queue->desc_size;
> -
> -		/*
> -		 * DMA is already done, notify rt2x00lib that
> -		 * it finished successfully.
> -		 */
> -		rt2x00lib_dmastart(entry);
> -		rt2x00lib_dmadone(entry);
> -
> -		/*
> -		 * Send the frame to rt2x00lib for further processing.
> -		 */
> -		rt2x00lib_rxdone(entry, GFP_ATOMIC);
> -	}
> -
> -	return !max_rx;
> -}
> -EXPORT_SYMBOL_GPL(rt2x00pci_rxdone);
> -
> -void rt2x00pci_flush_queue(struct data_queue *queue, bool drop)
> -{
> -	unsigned int i;
> -
> -	for (i = 0; !rt2x00queue_empty(queue) && i < 10; i++)
> -		msleep(10);
> -}
> -EXPORT_SYMBOL_GPL(rt2x00pci_flush_queue);
> -
> -/*
> - * Device initialization handlers.
> - */
> -static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
> -				     struct data_queue *queue)
> -{
> -	struct queue_entry_priv_pci *entry_priv;
> -	void *addr;
> -	dma_addr_t dma;
> -	unsigned int i;
> -
> -	/*
> -	 * Allocate DMA memory for descriptor and buffer.
> -	 */
> -	addr = dma_alloc_coherent(rt2x00dev->dev,
> -				  queue->limit * queue->desc_size,
> -				  &dma, GFP_KERNEL);
> -	if (!addr)
> -		return -ENOMEM;
> -
> -	memset(addr, 0, queue->limit * queue->desc_size);
> -
> -	/*
> -	 * Initialize all queue entries to contain valid addresses.
> -	 */
> -	for (i = 0; i < queue->limit; i++) {
> -		entry_priv = queue->entries[i].priv_data;
> -		entry_priv->desc = addr + i * queue->desc_size;
> -		entry_priv->desc_dma = dma + i * queue->desc_size;
> -	}
> -
> -	return 0;
> -}
> -
> -static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
> -				     struct data_queue *queue)
> -{
> -	struct queue_entry_priv_pci *entry_priv =
> -	    queue->entries[0].priv_data;
> -
> -	if (entry_priv->desc)
> -		dma_free_coherent(rt2x00dev->dev,
> -				  queue->limit * queue->desc_size,
> -				  entry_priv->desc, entry_priv->desc_dma);
> -	entry_priv->desc = NULL;
> -}
> -
> -int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct data_queue *queue;
> -	int status;
> -
> -	/*
> -	 * Allocate DMA
> -	 */
> -	queue_for_each(rt2x00dev, queue) {
> -		status = rt2x00pci_alloc_queue_dma(rt2x00dev, queue);
> -		if (status)
> -			goto exit;
> -	}
> -
> -	/*
> -	 * Register interrupt handler.
> -	 */
> -	status = request_irq(rt2x00dev->irq,
> -			     rt2x00dev->ops->lib->irq_handler,
> -			     IRQF_SHARED, rt2x00dev->name, rt2x00dev);
> -	if (status) {
> -		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
> -		      rt2x00dev->irq, status);
> -		goto exit;
> -	}
> -
> -	return 0;
> -
> -exit:
> -	queue_for_each(rt2x00dev, queue)
> -		rt2x00pci_free_queue_dma(rt2x00dev, queue);
> -
> -	return status;
> -}
> -EXPORT_SYMBOL_GPL(rt2x00pci_initialize);
> -
> -void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct data_queue *queue;
> -
> -	/*
> -	 * Free irq line.
> -	 */
> -	free_irq(rt2x00dev->irq, rt2x00dev);
> -
> -	/*
> -	 * Free DMA
> -	 */
> -	queue_for_each(rt2x00dev, queue)
> -		rt2x00pci_free_queue_dma(rt2x00dev, queue);
> -}
> -EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
> -
> -/*
>   * PCI driver handlers.
>   */
>  static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
> index e2c99f2..60d90b2 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
> @@ -36,94 +36,6 @@
>  #define PCI_DEVICE_DATA(__ops)	.driver_data = (kernel_ulong_t)(__ops)
>  
>  /*
> - * Register access.
> - */
> -static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
> -					   const unsigned int offset,
> -					   u32 *value)
> -{
> -	*value = readl(rt2x00dev->csr.base + offset);
> -}
> -
> -static inline void rt2x00pci_register_multiread(struct rt2x00_dev *rt2x00dev,
> -						const unsigned int offset,
> -						void *value, const u32 length)
> -{
> -	memcpy_fromio(value, rt2x00dev->csr.base + offset, length);
> -}
> -
> -static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
> -					    const unsigned int offset,
> -					    u32 value)
> -{
> -	writel(value, rt2x00dev->csr.base + offset);
> -}
> -
> -static inline void rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
> -						 const unsigned int offset,
> -						 const void *value,
> -						 const u32 length)
> -{
> -	__iowrite32_copy(rt2x00dev->csr.base + offset, value, length >> 2);
> -}
> -
> -/**
> - * rt2x00pci_regbusy_read - Read from register with busy check
> - * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
> - * @offset: Register offset
> - * @field: Field to check if register is busy
> - * @reg: Pointer to where register contents should be stored
> - *
> - * This function will read the given register, and checks if the
> - * register is busy. If it is, it will sleep for a couple of
> - * microseconds before reading the register again. If the register
> - * is not read after a certain timeout, this function will return
> - * FALSE.
> - */
> -int rt2x00pci_regbusy_read(struct rt2x00_dev *rt2x00dev,
> -			   const unsigned int offset,
> -			   const struct rt2x00_field32 field,
> -			   u32 *reg);
> -
> -/**
> - * struct queue_entry_priv_pci: Per entry PCI specific information
> - *
> - * @desc: Pointer to device descriptor
> - * @desc_dma: DMA pointer to &desc.
> - * @data: Pointer to device's entry memory.
> - * @data_dma: DMA pointer to &data.
> - */
> -struct queue_entry_priv_pci {
> -	__le32 *desc;
> -	dma_addr_t desc_dma;
> -};
> -
> -/**
> - * rt2x00pci_rxdone - Handle RX done events
> - * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
> - *
> - * Returns true if there are still rx frames pending and false if all
> - * pending rx frames were processed.
> - */
> -bool rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev);
> -
> -/**
> - * rt2x00pci_flush_queue - Flush data queue
> - * @queue: Data queue to stop
> - * @drop: True to drop all pending frames.
> - *
> - * This will wait for a maximum of 100ms, waiting for the queues
> - * to become empty.
> - */
> -void rt2x00pci_flush_queue(struct data_queue *queue, bool drop);
> -
> -/*
> - * Device initialization handlers.
> - */
> -int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev);
> -void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev);
> -
> -/*
>   * PCI driver handlers.
>   */
>  int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops);
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index f95792c..9e3c8ff 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -35,6 +35,7 @@
>  #include <linux/eeprom_93cx6.h>
>  
>  #include "rt2x00.h"
> +#include "rt2x00mmio.h"
>  #include "rt2x00pci.h"
>  #include "rt61pci.h"
>  
> -- 
> 1.7.10
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
