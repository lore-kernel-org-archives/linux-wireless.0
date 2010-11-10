Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65252 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab0KJFfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 00:35:36 -0500
Received: by iwn10 with SMTP id 10so338539iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 21:35:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
References: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 10 Nov 2010 07:35:15 +0200
Message-ID: <AANLkTinT72TE_z2JW1x+pMHNys6jVEeGfkQZFAW_f+48@mail.gmail.com>
Subject: Re: wl1271 sdio timeouts on omap3
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joerie,

On Tue, Nov 9, 2010 at 12:14 AM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> lockup in mmc_wait_for_req (called from wl1271_sdio_power_on). In 10%
> of my attempts the driver gets as far as uploading the firmware after
> which I'm getting similar SDIO timeouts.
>
> I'm mostly unsure about my regulator config (relevant snippets below),

Snippets below are not complete. E.g., where do you actually indicate
the gpio number ?

It's better to send your complete patch so we can have a look.

> having no wl1271 documentation to work with. The wl1271 is on mmc3,
> powered by twl4030 vsim. I assume the fixed regulator in [1] is just
> to be able to control the PMENA GPIO?

Yes.

> Pin muxing aside, all changes are equal to those displayed in [1]. Is
> there anything I might be doing wrong wrt. the power-up sequence?

Indeterministic SDIO behavior is unlikely to be related to the
device's gpio-based power, since it's either on or off.

The issues you are experiencing sound more like hw issues (e.g. faulty
board level shifter) or misconfiguration of the SDIO pins (e.g. lines
not pulled up).

I suggest you to try working with 1 bit SDIO and/or low clock speeds
and see if stability is improved.

If not, the best thing to do is sniffing the hardware lines - power,
clock, mmc 1-4,.. You will then know exactly what's wrong.

Regards,
Ohad.

>
> [1]: https://patchwork.kernel.org/patch/201572/
>
> Joerie
>
> ----------
>
> static struct regulator_consumer_supply nowplus_vsim_supply = {
>        .supply                 = "vmmc",
> };
>
>
> static struct regulator_consumer_supply nowplus_wl1271_supply = {
>        .supply                 = "vmmc_aux",
>        .dev_name               = "mmci-omap-hs.2",
> };
>
>
> /* VSIM for WiFi SDIO */
> static struct regulator_init_data nowplus_vsim = {
>        .constraints = {
>                .name                   = "VSIM",
>                .min_uV                 = 1800000,
>                .max_uV                 = 1800000,
>                .apply_uV               = true,
>                .valid_modes_mask       = REGULATOR_MODE_NORMAL
>                                        | REGULATOR_MODE_STANDBY,
>                .valid_ops_mask         = REGULATOR_CHANGE_MODE
>                                        | REGULATOR_CHANGE_STATUS,
>        },
>        .num_consumer_supplies  = 1,
>        .consumer_supplies      = &nowplus_vsim_supply,
> };
>
> static struct regulator_init_data nowplus_wlgpio = {
>        .constraints = {
>                .valid_ops_mask = REGULATOR_CHANGE_STATUS,
>        },
>        .num_consumer_supplies  = 1,
>        .consumer_supplies      = &nowplus_wl1271_supply,
> };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
