Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47722 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0IWKaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 06:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
Date: Thu, 23 Sep 2010 13:30:21 +0300
Message-ID: <AANLkTinLjQbvbTj3LTnw+54S-ojWzojqgyd=-3F783We@mail.gmail.com>
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board file
From: Grazvydas Ignotas <notasas@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-omap@vger.kernel.org, tony@atomide.com,
	linux-wireless@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 11:20 AM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> Add board configuration for the wl1271 daughter board.  This patch is based
> on Ohad Ben-Cohen's patches for Zoom boards.

Hm can that daughter board be detected? With your patch all beagle
users will get GPIO139 toggled, and if someone has that wired to
chainsaw switch somebody might get hurt.

> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
> There was a useless variable defined in omap3_beagle_init() that was causing a
> warning.  I have removed it in v2.
>
>  arch/arm/mach-omap2/board-omap3beagle.c |   69 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/wl12xx/wl1271.h    |    2 +-
>  2 files changed, 70 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index 87969c7..755df29 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c

<snip>

> +static struct regulator_consumer_supply beagle_vmmc2_supply = {
> +       .supply         = "vmmc",
> +       .dev_name       = "mmci-omap-hs.1",
> +};
> +
> +

single newline is enough.

>  static struct regulator_consumer_supply beagle_vsim_supply = {
>        .supply                 = "vmmc_aux",
>  };
>
> +

here too.

> +static struct regulator_init_data beagle_vmmc2 = {
> +       .constraints = {
> +               .valid_ops_mask = REGULATOR_CHANGE_STATUS,
> +       },
> +       .num_consumer_supplies = 1,
> +       .consumer_supplies = &beagle_vmmc2_supply,
> +};
> +
> +static struct fixed_voltage_config beagle_vwlan = {
> +       .supply_name = "vwl1271",
> +       .microvolts = 1800000,  /* 1.8V */
> +       .gpio = OMAP_BEAGLE_WLAN_EN_GPIO,
> +       .startup_delay = 70000, /* 70ms */
> +       .enable_high = 1,
> +       .enabled_at_boot = 0,
> +       .init_data = &beagle_vmmc2,
> +};

We tabify all structures in board files, take a look at other structures.

<snip>

> diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> index 4134f44..8bb028e 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -60,7 +60,7 @@ enum {
>        DEBUG_ALL       = ~0,
>  };
>
> -#define DEBUG_LEVEL (DEBUG_NONE)
> +#define DEBUG_LEVEL (DEBUG_MAC80211 | DEBUG_CMD | DEBUG_ACX | DEBUG_BOOT)

I guess you didn't want that?
