Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1GMUjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 16:39:49 -0400
Received: by ywe9 with SMTP id 9so2578202ywe.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 13:39:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310209563-6405-6-git-send-email-hauke@hauke-m.de>
References: <1310209563-6405-1-git-send-email-hauke@hauke-m.de> <1310209563-6405-6-git-send-email-hauke@hauke-m.de>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Wed, 13 Jul 2011 22:39:29 +0200
Message-ID: <CAOiHx=mpRNUtmLHFBw4n9XC4-cf4agc1tn4_twYFvz7=TQStzQ@mail.gmail.com> (sfid-20110713_223953_002244_A4F3B771)
Subject: Re: [PATCH 05/11] bcma: add mips driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2011 13:05, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 2ca5eeb..ba9a357 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -79,6 +79,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
>                case BCMA_CORE_CHIPCOMMON:
>                case BCMA_CORE_PCI:
>                case BCMA_CORE_PCIE:
> +               case BCMA_CORE_MIPS_74K:
>                        continue;
>                }
>
> @@ -138,6 +139,15 @@ int bcma_bus_register(struct bcma_bus *bus)
>                bcma_core_chipcommon_init(&bus->drv_cc);
>        }
>
> +#ifdef CONFIG_BCMA_DRIVER_MIPS
> +       /* Init MIPS core */
> +       core = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
> +       if (core) {
> +               bus->drv_mips.core = core;
> +               bcma_core_mips_init(&bus->drv_mips);
> +       }
> +#endif

You could avoid the ugly ifdefs here by moving it to
bcma_driver_mips.h and change

extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);

to
#ifdef CONFIG_BCMA_DRIVER_MIPS
extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);
#else
static inline void bcma_core_mips_init(struct bcma_drv_mips *mcore) { }
#endif

assuming the bus->drv_mips.core being set doesn't have any side
effects in the no mips core driver case.

> +
>        /* Init PCIE core */
>        core = bcma_find_core(bus, BCMA_CORE_PCIE);
>        if (core) {
> @@ -200,6 +210,15 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
>                bcma_core_chipcommon_init(&bus->drv_cc);
>        }
>
> +#ifdef CONFIG_BCMA_DRIVER_MIPS
> +       /* Init MIPS core */
> +       core = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
> +       if (core) {
> +               bus->drv_mips.core = core;
> +               bcma_core_mips_init(&bus->drv_mips);
> +       }
> +#endif

Ditto.
