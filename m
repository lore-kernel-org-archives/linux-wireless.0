Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38242 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab0KKLGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 06:06:01 -0500
Received: by qwi4 with SMTP id 4so1560022qwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 03:06:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com>
References: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
	<AANLkTinT72TE_z2JW1x+pMHNys6jVEeGfkQZFAW_f+48@mail.gmail.com>
	<AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com>
Date: Thu, 11 Nov 2010 13:06:00 +0200
Message-ID: <AANLkTin6oaCQ02Je5X2CMR83mLzTBKfjCF+rVuOxk_X+@mail.gmail.com>
Subject: Re: wl1271 sdio timeouts on omap3
From: Grazvydas Ignotas <notasas@gmail.com>
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 5:01 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> On Wed, Nov 10, 2010 at 6:35 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> Snippets below are not complete. E.g., where do you actually indicate
>> the gpio number ?
>> It's better to send your complete patch so we can have a look.
>
> Sorry, I've attached a full diff of the board changes below.

Your vsim configuration looks wrong.

<snip>

>
> @@ -213,6 +224,16 @@ static struct regulator_consumer_supply
> nowplus_vpll2_supply = {
>        .dev                    = &nowplus_dss_device.dev,
>  };
>
> +static struct regulator_consumer_supply nowplus_vsim_supply = {
> +       .supply                 = "vmmc",
> +};

You need to set .dev or .dev_name here, best just do
+       .dev_name               = "mmci-omap-hs.2",

> +
> +
> +static struct regulator_consumer_supply nowplus_wl1271_supply = {
> +       .supply                 = "vmmc_aux",
> +       .dev_name               = "mmci-omap-hs.2",
> +};
> +
>  /* VMMC1 for MMC1 card */
>  static struct regulator_init_data nowplus_vmmc1 = {
>        .constraints = {
> @@ -311,6 +332,53 @@ static struct regulator_init_data nowplus_vpll2 = {
>        .consumer_supplies      = &nowplus_vpll2_supply,
>  };
>
> +/* VSIM for WiFi SDIO */
> +static struct regulator_init_data nowplus_vsim = {

doesn't seem to be referenced anywhere? You need to add it to
twl4030_platform_data I think.
