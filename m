Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37633 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1FSWw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 18:52:56 -0400
Received: by iwn6 with SMTP id 6so734957iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 15:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308520209-668-4-git-send-email-hauke@hauke-m.de>
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de> <1308520209-668-4-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 20 Jun 2011 08:52:36 +1000
Message-ID: <BANLkTinfFHwd++rxb0wn266dQhF=7ANmhQ@mail.gmail.com> (sfid-20110620_005259_992442_814D4B2F)
Subject: Re: [RFC v2 03/12] bcma: add functions to scan cores needed on SoCs
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de, sshtylyov@mvista.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke,

Couple of minor points

On Mon, Jun 20, 2011 at 07:50, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The chip common and mips core have to be setup early in the boot
> process to get the cpu clock.
> bcma_bus_earyl_register() gets pointers to some space to store the core

Spelling: s/earyl/early/

> data and searches for the chip common and mips core and initializes
> chip common. After that was done and the kernel is out of early boot we
> just have to run bcma_bus_register() and it will search for the other
> cores, initialize and register them.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> index 12a75ab..6416bbc 100644
> --- a/drivers/bcma/bcma_private.h
> +++ b/drivers/bcma/bcma_private.h
> @@ -15,9 +15,16 @@ struct bcma_bus;
>  /* main.c */
>  extern int bcma_bus_register(struct bcma_bus *bus);
>  extern void bcma_bus_unregister(struct bcma_bus *bus);
> +int __init bcma_bus_earyl_register(struct bcma_bus *bus,
> +                                  struct bcma_device *core_cc,
> +                                  struct bcma_device *core_mips);

Here too.

> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> index 7970553..4ebb186 100644
> --- a/drivers/bcma/scan.c
> +++ b/drivers/bcma/scan.c
> @@ -332,9 +361,10 @@ int bcma_bus_scan(struct bcma_bus *bus)
>        u32 erombase;
>        u32 __iomem *eromptr, *eromend;
>
> -       int err;
> +       int err, core_num = 0;
>
> -       bcma_init_bus(bus);
> +       if (!bus->init_done)
> +               bcma_init_bus(bus);

For consistency with the core init functions, should this test go in
bcma_init_bus()?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
