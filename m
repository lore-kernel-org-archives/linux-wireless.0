Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:38827 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZIJVXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 17:23:39 -0400
Received: by fxm17 with SMTP id 17so422032fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 14:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909101934.50283.mb@bu3sch.de>
References: <200909101934.50283.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 10 Sep 2009 23:23:19 +0200
Message-ID: <69e28c910909101423j535c9cffq5b1be1cb00877645@mail.gmail.com>
Subject: Re: [PATCH] b43: Add Soft-MAC SDIO device support
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 7:34 PM, Michael Buesch <mb@bu3sch.de> wrote:
> From: Albert Herranz <albert_herranz@yahoo.es>
>
> This adds support for Soft-MAC SDIO devices to b43.
> The driver still lacks some fixes for SDIO devices, so it's currently
> marked as BROKEN.

Is it actually completely broken; or already testable, just incomplete?

>
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> Depends on the SSB SDIO patch.
>
>
> Index: wireless-testing/drivers/net/wireless/b43/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig      2009-09-10 19:23:09.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/Kconfig   2009-09-10 19:33:24.000000000 +0200
> @@ -61,11 +61,28 @@ config B43_PCMCIA
>
>          If unsure, say N.
>
> +config B43_SDIO
> +       bool "Broadcom 43xx SDIO device support (EXPERIMENTAL)"
> +       depends on B43 && SSB_SDIOHOST_POSSIBLE && EXPERIMENTAL && BROKEN
> +       select SSB_SDIOHOST
> +       ---help---
> +         Broadcom 43xx device support for Soft-MAC SDIO devices.
> +
> +         With this config option you can drive Soft-MAC b43 cards with a
> +         Secure Digital I/O interface.
> +         This includes the WLAN daughter card found on the Nintendo Wii
> +         video game console.
> +         Note that this does not support Broadcom 43xx Full-MAC devices.
> +
> +         It's safe to select Y here, even if you don't have a B43 SDIO device.
> +
> +         If unsure, say N.
> +
>  # Data transfers to the device via PIO
> -# This is only needed on PCMCIA devices. All others can do DMA properly.
> +# This is only needed on PCMCIA and SDIO devices. All others can do DMA properly.
>  config B43_PIO
>        bool
> -       depends on B43 && (B43_PCMCIA || B43_FORCE_PIO)
> +       depends on B43 && (B43_SDIO || B43_PCMCIA || B43_FORCE_PIO)
>        select SSB_BLOCKIO
>        default y
>
> Index: wireless-testing/drivers/net/wireless/b43/Makefile
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/Makefile     2009-09-10 19:23:09.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/Makefile  2009-09-10 19:23:20.000000000 +0200
> @@ -16,6 +16,7 @@ b43-$(CONFIG_B43_PIO)         += pio.o
>  b43-y                          += rfkill.o
>  b43-$(CONFIG_B43_LEDS)         += leds.o
>  b43-$(CONFIG_B43_PCMCIA)       += pcmcia.o
> +b43-$(CONFIG_B43_SDIO)         += sdio.o
>  b43-$(CONFIG_B43_DEBUG)                += debugfs.o
>
>  obj-$(CONFIG_B43)              += b43.o
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c       2009-09-10 19:23:09.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/main.c    2009-09-10 19:23:20.000000000 +0200
> @@ -8,6 +8,9 @@
>   Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
>   Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
>
> +  SDIO support
> +  Copyright (c) 2009 Albert Herranz <albert_herranz@yahoo.es>
> +
>   Some parts of the code in this file are derived from the ipw2200
>   driver  Copyright(c) 2003 - 2004 Intel Corporation.
>
> @@ -53,6 +56,8 @@
>  #include "xmit.h"
>  #include "lo.h"
>  #include "pcmcia.h"
> +#include "sdio.h"
> +#include <linux/mmc/sdio_func.h>
>
>  MODULE_DESCRIPTION("Broadcom B43 wireless driver");
>  MODULE_AUTHOR("Martin Langer");
> @@ -1587,7 +1592,7 @@ static void b43_beacon_update_trigger_wo
>        mutex_lock(&wl->mutex);
>        dev = wl->current_dev;
>        if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
> -               if (0 /*FIXME dev->dev->bus->bustype == SSB_BUSTYPE_SDIO*/) {
> +               if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
>                        /* wl->mutex is enough. */
>                        b43_do_beacon_update_trigger_work(dev);
>                        mmiowb();
> @@ -1905,6 +1910,27 @@ static irqreturn_t b43_interrupt_handler
>        return ret;
>  }
>
> +/* SDIO interrupt handler. This runs in process context. */
> +static void b43_sdio_interrupt_handler(struct b43_wldev *dev)
> +{
> +       struct b43_wl *wl = dev->wl;
> +       struct sdio_func *func = dev->dev->bus->host_sdio;
> +       irqreturn_t ret;
> +
> +       if (unlikely(b43_status(dev) < B43_STAT_STARTED))
> +               return;
> +
> +       mutex_lock(&wl->mutex);
> +       sdio_release_host(func);
> +
> +       ret = b43_do_interrupt(dev);
> +       if (ret == IRQ_WAKE_THREAD)
> +               b43_do_interrupt_thread(dev);
> +
> +       sdio_claim_host(func);
> +       mutex_unlock(&wl->mutex);
> +}
> +
>  void b43_do_release_fw(struct b43_firmware_file *fw)
>  {
>        release_firmware(fw->data);
> @@ -3828,7 +3854,7 @@ redo:
>
>        /* Disable interrupts on the device. */
>        b43_set_status(dev, B43_STAT_INITIALIZED);
> -       if (0 /*FIXME dev->dev->bus->bustype == SSB_BUSTYPE_SDIO*/) {
> +       if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
>                /* wl->mutex is locked. That is enough. */
>                b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, 0);
>                b43_read32(dev, B43_MMIO_GEN_IRQ_MASK); /* Flush */
> @@ -3858,7 +3884,10 @@ redo:
>                dev_kfree_skb(skb_dequeue(&wl->tx_queue));
>
>        b43_mac_suspend(dev);
> -       free_irq(dev->dev->irq, dev);
> +       if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO)
> +               b43_sdio_free_irq(dev);
> +       else
> +               free_irq(dev->dev->irq, dev);
>        b43_leds_exit(dev);
>        b43dbg(wl, "Wireless interface stopped\n");
>
> @@ -3873,12 +3902,20 @@ static int b43_wireless_core_start(struc
>        B43_WARN_ON(b43_status(dev) != B43_STAT_INITIALIZED);
>
>        drain_txstatus_queue(dev);
> -       err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
> -                                  b43_interrupt_thread_handler,
> -                                  IRQF_SHARED, KBUILD_MODNAME, dev);
> -       if (err) {
> -               b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
> -               goto out;
> +       if (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) {
> +               err = b43_sdio_request_irq(dev, b43_sdio_interrupt_handler);
> +               if (err) {
> +                       b43err(dev->wl, "Cannot request SDIO IRQ\n");
> +                       goto out;
> +               }
> +       } else {
> +               err = request_threaded_irq(dev->dev->irq, b43_interrupt_handler,
> +                                          b43_interrupt_thread_handler,
> +                                          IRQF_SHARED, KBUILD_MODNAME, dev);
> +               if (err) {
> +                       b43err(dev->wl, "Cannot request IRQ-%d\n", dev->dev->irq);
> +                       goto out;
> +               }
>        }
>
>        /* We are ready to run. */
> @@ -4270,7 +4307,9 @@ static int b43_wireless_core_init(struct
>        /* Maximum Contention Window */
>        b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
>
> -       if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) || B43_FORCE_PIO) {
> +       if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
> +           (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) ||
> +           B43_FORCE_PIO) {
>                dev->__using_pio_transfers = 1;
>                err = b43_pio_init(dev);
>        } else {
> @@ -4944,7 +4983,7 @@ static struct ssb_driver b43_ssb_driver
>  static void b43_print_driverinfo(void)
>  {
>        const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
> -                  *feat_leds = "";
> +                  *feat_leds = "", *feat_sdio = "";
>
>  #ifdef CONFIG_B43_PCI_AUTOSELECT
>        feat_pci = "P";
> @@ -4958,11 +4997,14 @@ static void b43_print_driverinfo(void)
>  #ifdef CONFIG_B43_LEDS
>        feat_leds = "L";
>  #endif
> +#ifdef CONFIG_B43_SDIO
> +       feat_sdio = "S";
> +#endif
>        printk(KERN_INFO "Broadcom 43xx driver loaded "
> -              "[ Features: %s%s%s%s, Firmware-ID: "
> +              "[ Features: %s%s%s%s%s, Firmware-ID: "
>               B43_SUPPORTED_FIRMWARE_ID " ]\n",
>               feat_pci, feat_pcmcia, feat_nphy,
> -              feat_leds);
> +              feat_leds, feat_sdio);
>  }
>
>  static int __init b43_init(void)
> @@ -4973,13 +5015,18 @@ static int __init b43_init(void)
>        err = b43_pcmcia_init();
>        if (err)
>                goto err_dfs_exit;
> -       err = ssb_driver_register(&b43_ssb_driver);
> +       err = b43_sdio_init();
>        if (err)
>                goto err_pcmcia_exit;
> +       err = ssb_driver_register(&b43_ssb_driver);
> +       if (err)
> +               goto err_sdio_exit;
>        b43_print_driverinfo();
>
>        return err;
>
> +err_sdio_exit:
> +       b43_sdio_exit();
>  err_pcmcia_exit:
>        b43_pcmcia_exit();
>  err_dfs_exit:
> @@ -4990,6 +5037,7 @@ err_dfs_exit:
>  static void __exit b43_exit(void)
>  {
>        ssb_driver_unregister(&b43_ssb_driver);
> +       b43_sdio_exit();
>        b43_pcmcia_exit();
>        b43_debugfs_exit();
>  }
> Index: wireless-testing/drivers/net/wireless/b43/sdio.c
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ wireless-testing/drivers/net/wireless/b43/sdio.c    2009-09-10 19:23:20.000000000 +0200
> @@ -0,0 +1,197 @@
> +/*
> + * Broadcom B43 wireless driver
> + *
> + * SDIO over Sonics Silicon Backplane bus glue for b43.
> + *
> + * Copyright (C) 2009 Albert Herranz
> + * Copyright (C) 2009 Michael Buesch <mb@bu3sch.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or (at
> + * your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/mmc/card.h>
> +#include <linux/mmc/sdio_func.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/ssb/ssb.h>
> +
> +#include "sdio.h"
> +#include "b43.h"
> +
> +
> +#define HNBU_CHIPID            0x01    /* vendor & device id */
> +
> +#define B43_SDIO_BLOCK_SIZE    64      /* rx fifo max size in bytes */
> +
> +
> +static const struct b43_sdio_quirk {
> +       u16 vendor;
> +       u16 device;
> +       unsigned int quirks;
> +} b43_sdio_quirks[] = {
> +       { 0x14E4, 0x4318, SSB_QUIRK_SDIO_READ_AFTER_WRITE32, },
> +       { },
> +};
> +
> +
> +static unsigned int b43_sdio_get_quirks(u16 vendor, u16 device)
> +{
> +       const struct b43_sdio_quirk *q;
> +
> +       for (q = b43_sdio_quirks; q->quirks; q++) {
> +               if (vendor == q->vendor && device == q->device)
> +                       return q->quirks;
> +       }
> +
> +       return 0;
> +}
> +
> +static void b43_sdio_interrupt_dispatcher(struct sdio_func *func)
> +{
> +       struct b43_sdio *sdio = sdio_get_drvdata(func);
> +       struct b43_wldev *dev = sdio->irq_handler_opaque;
> +
> +       sdio->irq_handler(dev);
> +}
> +
> +int b43_sdio_request_irq(struct b43_wldev *dev,
> +                        void (*handler)(struct b43_wldev *dev))
> +{
> +       struct ssb_bus *bus = dev->dev->bus;
> +       struct sdio_func *func = bus->host_sdio;
> +       struct b43_sdio *sdio = sdio_get_drvdata(func);
> +       int err;
> +
> +       sdio->irq_handler_opaque = dev;
> +       sdio->irq_handler = handler;
> +       sdio_claim_host(func);
> +       err = sdio_claim_irq(func, b43_sdio_interrupt_dispatcher);
> +       sdio_release_host(func);
> +
> +       return err;
> +}
> +
> +void b43_sdio_free_irq(struct b43_wldev *dev)
> +{
> +       struct ssb_bus *bus = dev->dev->bus;
> +       struct sdio_func *func = bus->host_sdio;
> +       struct b43_sdio *sdio = sdio_get_drvdata(func);
> +
> +       sdio_claim_host(func);
> +       sdio_release_irq(func);
> +       sdio_release_host(func);
> +       sdio->irq_handler_opaque = NULL;
> +       sdio->irq_handler = NULL;
> +}
> +
> +static int b43_sdio_probe(struct sdio_func *func,
> +                         const struct sdio_device_id *id)
> +{
> +       struct b43_sdio *sdio;
> +       struct sdio_func_tuple *tuple;
> +       u16 vendor = 0, device = 0;
> +       int error;
> +
> +       /* Look for the card chip identifier. */
> +       tuple = func->tuples;
> +       while (tuple) {
> +               switch (tuple->code) {
> +               case 0x80:
> +                       switch (tuple->data[0]) {
> +                       case HNBU_CHIPID:
> +                               if (tuple->size != 5)
> +                                       break;
> +                               vendor = tuple->data[1] | (tuple->data[2]<<8);
> +                               device = tuple->data[3] | (tuple->data[4]<<8);
> +                               dev_info(&func->dev, "Chip ID %04x:%04x\n",
> +                                        vendor, device);
> +                               break;
> +                       default:
> +                               break;
> +                       }
> +                       break;
> +               default:
> +                       break;
> +               }
> +               tuple = tuple->next;
> +       }
> +       if (!vendor || !device) {
> +               error = -ENODEV;
> +               goto out;
> +       }
> +
> +       sdio_claim_host(func);
> +       error = sdio_set_block_size(func, B43_SDIO_BLOCK_SIZE);
> +       if (error) {
> +               dev_err(&func->dev, "failed to set block size to %u bytes,"
> +                       " error %d\n", B43_SDIO_BLOCK_SIZE, error);
> +               goto err_release_host;
> +       }
> +       error = sdio_enable_func(func);
> +       if (error) {
> +               dev_err(&func->dev, "failed to enable func, error %d\n", error);
> +               goto err_release_host;
> +       }
> +       sdio_release_host(func);
> +
> +       sdio = kzalloc(sizeof(*sdio), GFP_KERNEL);
> +       if (!sdio) {
> +               error = -ENOMEM;
> +               dev_err(&func->dev, "failed to allocate ssb bus\n");
> +               goto err_disable_func;
> +       }
> +       error = ssb_bus_sdiobus_register(&sdio->ssb, func,
> +                                        b43_sdio_get_quirks(vendor, device));
> +       if (error) {
> +               dev_err(&func->dev, "failed to register ssb sdio bus,"
> +                       " error %d\n", error);
> +               goto err_free_ssb;
> +       }
> +       sdio_set_drvdata(func, sdio);
> +
> +       return 0;
> +
> +err_free_ssb:
> +       kfree(sdio);
> +err_disable_func:
> +       sdio_disable_func(func);
> +err_release_host:
> +       sdio_release_host(func);
> +out:
> +       return error;
> +}
> +
> +static void b43_sdio_remove(struct sdio_func *func)
> +{
> +       struct b43_sdio *sdio = sdio_get_drvdata(func);
> +
> +       ssb_bus_unregister(&sdio->ssb);
> +       sdio_disable_func(func);
> +       kfree(sdio);
> +       sdio_set_drvdata(func, NULL);
> +}
> +
> +static const struct sdio_device_id b43_sdio_ids[] = {
> +       { SDIO_DEVICE(0x02d0, 0x044b) }, /* Nintendo Wii WLAN daughter card */
> +       { },
> +};
> +
> +static struct sdio_driver b43_sdio_driver = {
> +       .name           = "b43-sdio",
> +       .id_table       = b43_sdio_ids,
> +       .probe          = b43_sdio_probe,
> +       .remove         = b43_sdio_remove,
> +};
> +
> +int b43_sdio_init(void)
> +{
> +       return sdio_register_driver(&b43_sdio_driver);
> +}
> +
> +void b43_sdio_exit(void)
> +{
> +       sdio_unregister_driver(&b43_sdio_driver);
> +}
> Index: wireless-testing/drivers/net/wireless/b43/sdio.h
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ wireless-testing/drivers/net/wireless/b43/sdio.h    2009-09-10 19:23:20.000000000 +0200
> @@ -0,0 +1,45 @@
> +#ifndef B43_SDIO_H_
> +#define B43_SDIO_H_
> +
> +#include <linux/ssb/ssb.h>
> +
> +struct b43_wldev;
> +
> +
> +#ifdef CONFIG_B43_SDIO
> +
> +struct b43_sdio {
> +       struct ssb_bus ssb;
> +       void *irq_handler_opaque;
> +       void (*irq_handler)(struct b43_wldev *dev);
> +};
> +
> +int b43_sdio_request_irq(struct b43_wldev *dev,
> +                        void (*handler)(struct b43_wldev *dev));
> +void b43_sdio_free_irq(struct b43_wldev *dev);
> +
> +int b43_sdio_init(void);
> +void b43_sdio_exit(void);
> +
> +
> +#else /* CONFIG_B43_SDIO */
> +
> +
> +int b43_sdio_request_irq(struct b43_wldev *dev,
> +                        void (*handler)(struct b43_wldev *dev))
> +{
> +       return -ENODEV;
> +}
> +void b43_sdio_free_irq(struct b43_wldev *dev)
> +{
> +}
> +static inline int b43_sdio_init(void)
> +{
> +       return 0;
> +}
> +static inline void b43_sdio_exit(void)
> +{
> +}
> +
> +#endif /* CONFIG_B43_SDIO */
> +#endif /* B43_SDIO_H_ */
>
>
> --
> Greetings, Michael.
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
