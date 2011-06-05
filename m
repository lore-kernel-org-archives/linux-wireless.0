Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1FEXXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 19:23:16 -0400
Received: by iyb14 with SMTP id 14so2711158iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2011 16:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307311658-15853-4-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <1307311658-15853-4-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 6 Jun 2011 09:22:56 +1000
Message-ID: <BANLkTi=atiB_=_N3xSJBAjRGXjTV8a97CA@mail.gmail.com> (sfid-20110606_012326_297138_0CEBB0B6)
Subject: Re: [RFC][PATCH 03/10] bcma: add embedded bus
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke,

Minor nit:

On Mon, Jun 6, 2011 at 08:07, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This patch adds support for using bcma on an embedded bus. An embedded
> system like the bcm4716 could register this bus and it searches for the
> bcma cores then.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> index 70b39f7..9229615 100644
> --- a/drivers/bcma/scan.c
> +++ b/drivers/bcma/scan.c
> @@ -219,9 +219,34 @@ int bcma_bus_scan(struct bcma_bus *bus)
>        bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
>        bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
>        bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
> +       bus->nr_cores = (tmp & BCMA_CC_ID_NRCORES) >> BCMA_CC_ID_NRCORES_SHIFT;
> +
> +       /* If we are an embedded device we now know the number of avaliable
> +        * core and ioremap the correct space.
> +        */
> +       if (bus->hosttype == BCMA_HOSTTYPE_EMBEDDED) {
> +               iounmap(bus->mmio);
> +               mmio = ioremap(BCMA_ADDR_BASE, BCMA_CORE_SIZE * bus->nr_cores);
> +               if (!mmio)
> +                       return -ENOMEM;
> +               bus->mmio = mmio;
> +
> +               mmio = ioremap(BCMA_WRAP_BASE, BCMA_CORE_SIZE * bus->nr_cores);
> +               if (!mmio)
> +                       return -ENOMEM;
> +               bus->host_embedded = mmio;
> +       }
> +       /* reset it to 0 as we use it for counting */
> +       bus->nr_cores = 0;

Would it make sense to use a local variable for nr_cores, and only use
it within the BCMA_HOSTTYPE_EMBEDDED if statement, rather than
re-using bus->nr_cores and having to reset it?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
