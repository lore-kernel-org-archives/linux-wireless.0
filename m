Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33623 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2LKVkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 16:40:49 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1871444wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 13:40:47 -0800 (PST)
References: <20121211100350.GA7813@earthship.arig>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121211100350.GA7813@earthship.arig>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <555EAC65-09DC-466A-AAC8-4896E08D9F5D@gmail.com> (sfid-20121211_224054_064964_5A25AF9D)
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<juhosg@openwrt.org>" <juhosg@openwrt.org>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<helmut.schaa@googlemail.com>" <helmut.schaa@googlemail.com>,
	"<john@phrozen.org>" <john@phrozen.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: allow overriding eeprom through platform_data
Date: Tue, 11 Dec 2012 22:40:45 +0100
To: Daniel Golle <dgolle@allnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On 11 dec. 2012, at 11:03, Daniel Golle <dgolle@allnet.de> wrote:

> 
> Signed-off-by: Daniel Golle <dgolle@allnet.de>

We really need a proper patch description, explaining why the patch is needed. You explained in the intro [0 / 3], but that one isn't committed to git. So, to have some proper information in the git log we need the info included in the patch itself.

See also below for some concerns on the changes themselves.


> 
> create mode 100644 drivers/net/wireless/rt2x00/rt2x00eeprom.c
> create mode 100644 include/linux/rt2x00_platform.h
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index c7548da..e3b9dab 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -60,6 +60,7 @@ config RT2800PCI
>    select RT2X00_LIB_PCI if PCI
>    select RT2X00_LIB_SOC if RALINK_RT288X || RALINK_RT305X
>    select RT2X00_LIB_FIRMWARE
> +    select RT2X00_LIB_EEPROM
>    select RT2X00_LIB_CRYPTO
>    select CRC_CCITT
>    select EEPROM_93CX6
> @@ -212,6 +213,9 @@ config RT2X00_LIB_FIRMWARE
> config RT2X00_LIB_CRYPTO
>    boolean
> 
> +config RT2X00_LIB_EEPROM
> +    boolean
> +
> config RT2X00_LIB_LEDS
>    boolean
>    default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)

I find the approach very complicated, with all the general facilities that are only used by rt2800. Why not read the eeprom file directly from rt2800pci.c, with an directly coded call to request_firmware, instead of reading it at another place and then only copying it later.


> diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
> index 349d5b8..7ea55a4 100644
> --- a/drivers/net/wireless/rt2x00/Makefile
> +++ b/drivers/net/wireless/rt2x00/Makefile
> @@ -7,6 +7,7 @@ rt2x00lib-$(CONFIG_RT2X00_LIB_DEBUGFS)    += rt2x00debug.o
> rt2x00lib-$(CONFIG_RT2X00_LIB_CRYPTO)    += rt2x00crypto.o
> rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)    += rt2x00firmware.o
> rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)    += rt2x00leds.o
> +rt2x00lib-$(CONFIG_RT2X00_LIB_EEPROM)    += rt2x00eeprom.o
> 
> obj-$(CONFIG_RT2X00_LIB)        += rt2x00lib.o
> obj-$(CONFIG_RT2X00_LIB_PCI)        += rt2x00pci.o
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 9224d87..cad50cd 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -89,20 +89,10 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
>    rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> }
> 
> -#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
> -static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
> -{
> -    void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
> -
> -    memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
> -
> -    iounmap(base_addr);
> -}
> -#else
> -static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
> +static void rt2800pci_read_eeprom_file(struct rt2x00_dev *rt2x00dev)
> {
> +    memcpy(rt2x00dev->eeprom, rt2x00dev->eeprom_file->data, EEPROM_SIZE);
> }
> -#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */

I meant with the previous comment to read the file right here, instead of at a different place in the code.

> 
> #ifdef CONFIG_PCI
> static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
> @@ -322,6 +312,20 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
> }
> 
> /*
> + * EEPROM file functions.
> + */
> +static char *rt2800pci_get_eeprom_file_name(struct rt2x00_dev *rt2x00dev)
> +{
> +    struct rt2x00_platform_data *pdata;
> +
> +    pdata = rt2x00dev->dev->platform_data;
> +    if (pdata)
> +        return pdata->eeprom_file_name;
> +
> +    return NULL;
> +}
> +
> +/*

That would make this redundant.

>  * Initialization functions.
>  */
> static bool rt2800pci_get_entry_state(struct queue_entry *entry)
> @@ -972,8 +976,9 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
>  */
> static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
> {
> -    if (rt2x00_is_soc(rt2x00dev))
> -        rt2800pci_read_eeprom_soc(rt2x00dev);
> +    if (rt2x00_is_soc(rt2x00dev) ||
> +        test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
> +        rt2800pci_read_eeprom_file(rt2x00dev);
>    else if (rt2800pci_efuse_detect(rt2x00dev))
>        rt2800pci_read_eeprom_efuse(rt2x00dev);
>    else
> @@ -1033,6 +1038,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
>    .get_firmware_name    = rt2800pci_get_firmware_name,
>    .check_firmware        = rt2800_check_firmware,
>    .load_firmware        = rt2800_load_firmware,
> +    .get_eeprom_file_name   = rt2800pci_get_eeprom_file_name,
>    .initialize        = rt2x00pci_initialize,
>    .uninitialize        = rt2x00pci_uninitialize,
>    .get_entry_state    = rt2800pci_get_entry_state,

And this part as well.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 0751b35..355cff5 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -39,6 +39,7 @@
> #include <linux/input-polldev.h>
> #include <linux/kfifo.h>
> #include <linux/hrtimer.h>
> +#include <linux/rt2x00_platform.h>
> 
> #include <net/mac80211.h>
> 
> @@ -560,6 +561,7 @@ struct rt2x00lib_ops {
>                   const u8 *data, const size_t len);
>    int (*load_firmware) (struct rt2x00_dev *rt2x00dev,
>                  const u8 *data, const size_t len);
> +    char *(*get_eeprom_file_name) (struct rt2x00_dev *rt2x00dev);
> 
>    /*
>     * Device initialization/deinitialization handlers.
> @@ -720,6 +722,7 @@ enum rt2x00_capability_flags {
>    REQUIRE_SW_SEQNO,
>    REQUIRE_HT_TX_DESC,
>    REQUIRE_PS_AUTOWAKE,
> +    REQUIRE_EEPROM_FILE,
> 
>    /*
>     * Capabilities
> @@ -989,6 +992,11 @@ struct rt2x00_dev {
>    const struct firmware *fw;
> 
>    /*
> +     * EEPROM image.
> +     */
> +    const struct firmware *eeprom_file;
> +
> +    /*
>     * FIFO for storing tx status reports between isr and tasklet.
>     */
>    DECLARE_KFIFO_PTR(txstatus_fifo, u32);

And this would not be needed at all, as the struct firmware could be local to the firmware reading function.

> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 3248b42..d454488 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1207,6 +1207,10 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
> 
>    rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> 
> +    retval = rt2x00lib_load_eeprom_file(rt2x00dev);
> +    if (retval)
> +        goto exit;
> +
>    /*
>     * Initialize work.
>     */
> @@ -1331,6 +1335,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>     */
>    if (rt2x00dev->drv_data)
>        kfree(rt2x00dev->drv_data);
> +
> +    /*
> +     * Free EEPROM image.
> +     */
> +    rt2x00lib_free_eeprom_file(rt2x00dev);
> }
> EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00eeprom.c b/drivers/net/wireless/rt2x00/rt2x00eeprom.c
> new file mode 100644
> index 0000000..d80eff4
> --- /dev/null
> +++ b/drivers/net/wireless/rt2x00/rt2x00eeprom.c
> @@ -0,0 +1,98 @@
> +/*
> +    Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
> +    Copyright (C) 2004 - 2009 Gertjan van Wingerde <gwingerde@gmail.com>
> +    <http://rt2x00.serialmonkey.com>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the
> +    Free Software Foundation, Inc.,
> +    59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +/*
> +    Module: rt2x00lib
> +    Abstract: rt2x00 eeprom file loading routines.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include "rt2x00.h"
> +#include "rt2x00lib.h"
> +
> +static int rt2x00lib_request_eeprom_file(struct rt2x00_dev *rt2x00dev)
> +{
> +    const struct firmware *ee;
> +    char *ee_name;
> +    int retval;
> +
> +    ee_name = rt2x00dev->ops->lib->get_eeprom_file_name(rt2x00dev);
> +    if (!ee_name) {
> +        ERROR(rt2x00dev,
> +              "Invalid EEPROM filename.\n"
> +              "Please file bug report to %s.\n", DRV_PROJECT);
> +        return -EINVAL;
> +    }
> +
> +    INFO(rt2x00dev, "Loading EEPROM data from '%s'.\n", ee_name);
> +
> +    retval = request_firmware(&ee, ee_name, rt2x00dev->dev);
> +    if (retval) {
> +        ERROR(rt2x00dev, "Failed to request EEPROM.\n");
> +        return retval;
> +    }

And here is the biggest problem of this patch. Request_firmware is synchronous and will fail when userspace isn't up yet. For built-in versions of the driver userspace isn't up yet at this point of time, so this will fail then.

> +
> +    if (!ee || !ee->size || !ee->data) {
> +        ERROR(rt2x00dev, "Failed to read EEPROM file.\n");
> +        retval = -ENOENT;
> +        goto err_exit;
> +    }
> +
> +    if (ee->size != rt2x00dev->ops->eeprom_size) {
> +        ERROR(rt2x00dev,
> +              "EEPROM file size is invalid, it should be %d bytes\n",
> +              rt2x00dev->ops->eeprom_size);
> +        retval = -EINVAL;
> +        goto err_release_ee;
> +    }
> +
> +    rt2x00dev->eeprom_file = ee;
> +    return 0;
> +
> +err_release_ee:
> +    release_firmware(ee);
> +err_exit:
> +    return retval;
> +}
> +
> +int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev)
> +{
> +    int retval;
> +
> +    if (!test_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags))
> +        return 0;
> +
> +    if (!rt2x00dev->eeprom_file) {
> +        retval = rt2x00lib_request_eeprom_file(rt2x00dev);
> +        if (retval)
> +            return retval;
> +    }
> +
> +    return 0;
> +}
> +
> +void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev)
> +{
> +    release_firmware(rt2x00dev->eeprom_file);
> +    rt2x00dev->eeprom_file = NULL;
> +}
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index a093598..fc9ad6f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -322,6 +322,22 @@ static inline void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
> #endif /* CONFIG_RT2X00_LIB_FIRMWARE */
> 
> /*
> + * EEPROM file handlers.
> + */
> +#ifdef CONFIG_RT2X00_LIB_EEPROM
> +int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev);
> +void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev);
> +#else
> +static inline int rt2x00lib_load_eeprom_file(struct rt2x00_dev *rt2x00dev)
> +{
> +    return 0;
> +}
> +static inline void rt2x00lib_free_eeprom_file(struct rt2x00_dev *rt2x00dev)
> +{
> +}
> +#endif /* CONFIG_RT2X00_LIB_EEPROM_FILE */
> +
> +/*
>  * Debugfs handlers.
>  */
> #ifdef CONFIG_RT2X00_LIB_DEBUGFS
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index a0c8cae..ceadf87 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -254,6 +254,7 @@ exit:
> int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
> {
>    struct ieee80211_hw *hw;
> +    struct rt2x00_platform_data *pdata;
>    struct rt2x00_dev *rt2x00dev;
>    int retval;
>    u16 chip;
> @@ -297,6 +298,12 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct rt2x00_ops *ops)
>    rt2x00dev->irq = pci_dev->irq;
>    rt2x00dev->name = pci_name(pci_dev);
> 
> +    /* if we get passed the name of a eeprom_file_name, then use this in
> +       favour of the eeprom */
> +    pdata = rt2x00dev->dev->platform_data;
> +    if (pdata && pdata->eeprom_file_name)
> +        set_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags);
> +
>    if (pci_is_pcie(pci_dev))
>        rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
>    else
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
> index 2aa5c38..43dfc8f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
> @@ -94,6 +94,7 @@ int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
>    rt2x00dev->hw = hw;
>    rt2x00dev->irq = platform_get_irq(pdev, 0);
>    rt2x00dev->name = pdev->dev.driver->name;
> +    set_bit(REQUIRE_EEPROM_FILE, &rt2x00dev->cap_flags);
> 
>    rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_SOC);
> 
> diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platform.h
> new file mode 100644
> index 0000000..80effa7
> --- /dev/null
> +++ b/include/linux/rt2x00_platform.h
> @@ -0,0 +1,19 @@
> +/*
> + * Platform data definition for the rt2x00 driver
> + *
> + * Copyright (C) 2011 Gabor Juhos <juhosg@openwrt.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef _RT2X00_PLATFORM_H
> +#define _RT2X00_PLATFORM_H
> +
> +struct rt2x00_platform_data {
> +    char *eeprom_file_name;
> +};
> +
> +#endif /* _RT2X00_PLATFORM_H */
> -- 
> 1.8.0.1
> 
