Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:64454 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbASHTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 02:19:43 -0500
Received: by mail-la0-f49.google.com with SMTP id hs14so27110939lab.8
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 23:19:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54BBFBCA.7000104@hauke-m.de>
References: <1421442493-32133-1-git-send-email-zajec5@gmail.com>
	<54BBFBCA.7000104@hauke-m.de>
Date: Mon, 19 Jan 2015 08:19:42 +0100
Message-ID: <CACna6rzbbog6rWNKR0BVnMbnSmmo=BNoueXuAXEGrNaOBXcB8Q@mail.gmail.com> (sfid-20150119_081947_357141_BD944EE5)
Subject: Re: [PATCH] bcma: use standard bus scanning during early register
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 January 2015 at 19:30, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 01/16/2015 10:08 PM, Rafał Miłecki wrote:
>> Starting with kernel 3.19-rc1 early registration of bcma on MIPS is done
>> a bit later, with memory allocator available. This allows us to simplify
>> code by using standard bus scanning method.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Thanks for changing the bcm47xx mips target and making this possible.
> This patches looks good, just some small comments.
>> ---
>>  drivers/bcma/bcma_private.h   |  7 +----
>>  drivers/bcma/host_soc.c       |  2 +-
>>  drivers/bcma/main.c           | 33 +++++++----------------
>>  drivers/bcma/scan.c           | 61 +++----------------------------------------
>>  include/linux/bcma/bcma_soc.h |  2 --
>>  5 files changed, 14 insertions(+), 91 deletions(-)
>>
>> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
>> index 59422b5..3f314c9 100644
>> --- a/drivers/bcma/bcma_private.h
>> +++ b/drivers/bcma/bcma_private.h
>> @@ -28,9 +28,7 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core);
>>  void bcma_init_bus(struct bcma_bus *bus);
>>  int bcma_bus_register(struct bcma_bus *bus);
>>  void bcma_bus_unregister(struct bcma_bus *bus);
>> -int __init bcma_bus_early_register(struct bcma_bus *bus,
>> -                                struct bcma_device *core_cc,
>> -                                struct bcma_device *core_mips);
>> +int __init bcma_bus_early_register(struct bcma_bus *bus);
>>  #ifdef CONFIG_PM
>>  int bcma_bus_suspend(struct bcma_bus *bus);
>>  int bcma_bus_resume(struct bcma_bus *bus);
>> @@ -39,9 +37,6 @@ int bcma_bus_resume(struct bcma_bus *bus);
>>  /* scan.c */
>>  void bcma_detect_chip(struct bcma_bus *bus);
>>  int bcma_bus_scan(struct bcma_bus *bus);
>> -int __init bcma_bus_scan_early(struct bcma_bus *bus,
>> -                            struct bcma_device_id *match,
>> -                            struct bcma_device *core);
>>
>>  /* sprom.c */
>>  int bcma_sprom_get(struct bcma_bus *bus);
>> diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
>> index 335cbcf..2dce347 100644
>> --- a/drivers/bcma/host_soc.c
>> +++ b/drivers/bcma/host_soc.c
>> @@ -193,7 +193,7 @@ int __init bcma_host_soc_init(struct bcma_soc *soc)
>>       int err;
>>
>>       /* Scan bus and initialize it */
>> -     err = bcma_bus_early_register(bus, &soc->core_cc, &soc->core_mips);
>> +     err = bcma_bus_early_register(bus);
>>       if (err)
>>               iounmap(bus->mmio);
>>
>> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
>> index c166d44..c3c5e0a 100644
>> --- a/drivers/bcma/main.c
>> +++ b/drivers/bcma/main.c
>> @@ -489,35 +489,20 @@ void bcma_bus_unregister(struct bcma_bus *bus)
>>       kfree(cores[0]);
>>  }
>>
>> -int __init bcma_bus_early_register(struct bcma_bus *bus,
>> -                                struct bcma_device *core_cc,
>> -                                struct bcma_device *core_mips)
>> +/*
>> + * This is a special version of bus registration function designed for SoCs.
>> + * It scans bus and performs basic initialization of main cores only.
>> + * Please note it requires memory allocation, however it won't try to sleep.
>> + */
>> +int __init bcma_bus_early_register(struct bcma_bus *bus)
>>  {
>>       int err;
>>       struct bcma_device *core;
>> -     struct bcma_device_id match;
>> -
>> -     match.manuf = BCMA_MANUF_BCM;
>> -     match.id = bcma_cc_core_id(bus);
>> -     match.class = BCMA_CL_SIM;
>> -     match.rev = BCMA_ANY_REV;
>> -
>> -     /* Scan for chip common core */
>> -     err = bcma_bus_scan_early(bus, &match, core_cc);
>> -     if (err) {
>> -             bcma_err(bus, "Failed to scan for common core: %d\n", err);
>> -             return -1;
>> -     }
>> -
>> -     match.manuf = BCMA_MANUF_MIPS;
>> -     match.id = BCMA_CORE_MIPS_74K;
>> -     match.class = BCMA_CL_SIM;
>> -     match.rev = BCMA_ANY_REV;
>>
>> -     /* Scan for mips core */
>> -     err = bcma_bus_scan_early(bus, &match, core_mips);
>> +     /* Scan for devices (cores) */
>> +     err = bcma_bus_scan(bus);
>>       if (err) {
>> -             bcma_err(bus, "Failed to scan for mips core: %d\n", err);
>> +             bcma_err(bus, "Failed to scan bus: %d\n", err);
>>               return -1;
>>       }
>>
>> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
>> index 5328ee5..1138226 100644
>> --- a/drivers/bcma/scan.c
>> +++ b/drivers/bcma/scan.c
>> @@ -461,6 +461,9 @@ int bcma_bus_scan(struct bcma_bus *bus)
>>
>>       int err, core_num = 0;
>>
> add comment:
> skip if the bus was already scanned
>> +     if (bus->nr_cores)
>> +             return 0;
>> +
>>       erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
>>       if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
>>               eromptr = ioremap_nocache(erombase, BCMA_CORE_SIZE);
>> @@ -519,61 +522,3 @@ out:
>>
>>       return err;
>>  }
>> -
>> -int __init bcma_bus_scan_early(struct bcma_bus *bus,
>> -                            struct bcma_device_id *match,
>> -                            struct bcma_device *core)
>> -{
>> -     u32 erombase;
>> -     u32 __iomem *eromptr, *eromend;
>> -
>> -     int err = -ENODEV;
>> -     int core_num = 0;
>> -
>> -     erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
>> -     if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
>> -             eromptr = ioremap_nocache(erombase, BCMA_CORE_SIZE);
>> -             if (!eromptr)
>> -                     return -ENOMEM;
>> -     } else {
>> -             eromptr = bus->mmio;
>> -     }
>> -
>> -     eromend = eromptr + BCMA_CORE_SIZE / sizeof(u32);
>> -
>> -     bcma_scan_switch_core(bus, erombase);
>> -
>> -     while (eromptr < eromend) {
>> -             memset(core, 0, sizeof(*core));
>> -             INIT_LIST_HEAD(&core->list);
>> -             core->bus = bus;
>> -
>> -             err = bcma_get_next_core(bus, &eromptr, match, core_num, core);
>> -             if (err == -ENODEV) {
>> -                     core_num++;
>> -                     continue;
>> -             } else if (err == -ENXIO)
>> -                     continue;
>> -             else if (err == -ESPIPE)
>> -                     break;
>> -             else if (err < 0)
>> -                     goto out;
>> -
>> -             core->core_index = core_num++;
>> -             bus->nr_cores++;
>> -             bcma_info(bus, "Core %d found: %s (manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
>> -                       core->core_index, bcma_device_name(&core->id),
>> -                       core->id.manuf, core->id.id, core->id.rev,
>> -                       core->id.class);
>> -
>> -             list_add_tail(&core->list, &bus->cores);
>> -             err = 0;
>> -             break;
>> -     }
>> -
>> -out:
>> -     if (bus->hosttype == BCMA_HOSTTYPE_SOC)
>> -             iounmap(eromptr);
>> -
>> -     return err;
>> -}
>> diff --git a/include/linux/bcma/bcma_soc.h b/include/linux/bcma/bcma_soc.h
>> index f24d245..1b5fc0c 100644
>> --- a/include/linux/bcma/bcma_soc.h
>> +++ b/include/linux/bcma/bcma_soc.h
>> @@ -5,8 +5,6 @@
>>
>>  struct bcma_soc {
>>       struct bcma_bus bus;
>> -     struct bcma_device core_cc;
>> -     struct bcma_device core_mips;
>>  };
>
> Why not remove struct bcma_soc completely? it was only created to hold
> the bus and the two cores.

This is on my list, however it'll also affect
arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
so I wanted to handle it in a separated patch. Just to make
cross-drivers patches clean.

-- 
Rafał
