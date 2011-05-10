Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55734 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1EJXMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 19:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <1305063094-26656-2-git-send-email-hauke@hauke-m.de>
References: <1305063094-26656-1-git-send-email-hauke@hauke-m.de>
	<1305063094-26656-2-git-send-email-hauke@hauke-m.de>
Date: Wed, 11 May 2011 01:12:30 +0200
Message-ID: <BANLkTinZkCPQh84wy66nDmHpgwCO3Pvu3w@mail.gmail.com> (sfid-20110511_011246_120980_757E49B1)
Subject: Re: [PATCH v2 1/5] ssb: Change fallback sprom to callback mechanism.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/10 Hauke Mehrtens <hauke@hauke-m.de>:
> Some embedded devices like the Netgear WNDR3300 have two SSB based
> cards without an own sprom on the pci bus. We have to provide two
> different fallback sproms for these and this was not possible with the
> old solution. In the bcm47xx architecture the sprom data is stored in
> the nvram in the main flash storage. The architecture code will be able
> to fill the sprom with the stored data based on the bus where the
> device was found.
>
> The bcm63xx code should do the same thing as before, just using the new
> API.
>
> Acked-by: Michael Buesch <mb@bu3sch.de>
> CC: netdev@vger.kernel.org
> CC: linux-wireless@vger.kernel.org
> CC: Florian Fainelli <florian@openwrt.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>
> v2: * fix some checkpatch errors and warnings
>    * spelling issues
>
>  arch/mips/bcm63xx/boards/board_bcm963xx.c |   16 +++++++++-
>  drivers/ssb/pci.c                         |   16 +++++++---
>  drivers/ssb/sprom.c                       |   43 +++++++++++++++++------------
>  drivers/ssb/ssb_private.h                 |    3 +-
>  include/linux/ssb/ssb.h                   |    4 ++-
>  5 files changed, 55 insertions(+), 27 deletions(-)
>
> diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
> index 8dba8cf..40b223b 100644
> --- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
> +++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
> @@ -643,6 +643,17 @@ static struct ssb_sprom bcm63xx_sprom = {
>        .boardflags_lo          = 0x2848,
>        .boardflags_hi          = 0x0000,
>  };
> +
> +int bcm63xx_get_fallback_sprom(struct ssb_bus *bus, struct ssb_sprom *out)
> +{
> +       if (bus->bustype == SSB_BUSTYPE_PCI) {
> +               memcpy(out, &bcm63xx_sprom, sizeof(struct ssb_sprom));
> +               return 0;
> +       } else {
> +               printk(KERN_ERR PFX "unable to fill SPROM for given bustype.\n");
> +               return -EINVAL;
> +       }
> +}
>  #endif
>
>  /*
> @@ -793,8 +804,9 @@ void __init board_prom_init(void)
>        if (!board_get_mac_address(bcm63xx_sprom.il0mac)) {
>                memcpy(bcm63xx_sprom.et0mac, bcm63xx_sprom.il0mac, ETH_ALEN);
>                memcpy(bcm63xx_sprom.et1mac, bcm63xx_sprom.il0mac, ETH_ALEN);
> -               if (ssb_arch_set_fallback_sprom(&bcm63xx_sprom) < 0)
> -                       printk(KERN_ERR "failed to register fallback SPROM\n");
> +               if (ssb_arch_register_fallback_sprom(
> +                               &bcm63xx_get_fallback_sprom) < 0)
> +                       printk(KERN_ERR PFX "failed to register fallback SPROM\n");
>        }
>  #endif
>  }
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 6f34963..7ad4858 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -662,7 +662,6 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
>  static int ssb_pci_sprom_get(struct ssb_bus *bus,
>                             struct ssb_sprom *sprom)
>  {
> -       const struct ssb_sprom *fallback;
>        int err;
>        u16 *buf;
>
> @@ -707,10 +706,17 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>                if (err) {
>                        /* All CRC attempts failed.
>                         * Maybe there is no SPROM on the device?
> -                        * If we have a fallback, use that. */
> -                       fallback = ssb_get_fallback_sprom();
> -                       if (fallback) {
> -                               memcpy(sprom, fallback, sizeof(*sprom));
> +                        * Now we ask the arch code if there is some sprom
> +                        * available for this device in some other storage */
> +                       err = ssb_fill_sprom_with_fallback(bus, sprom);
> +                       if (err) {
> +                               ssb_printk(KERN_WARNING PFX "WARNING: Using"
> +                                          " fallback SPROM failed (err %d)\n",
> +                                          err);

I was recently told we should not duplicate message levels info with
own prefixes ("WARNING: ").

-- 
Rafał
