Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:56457 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752105AbeAWNYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 08:24:18 -0500
Message-ID: <1516713855.8658.18.camel@intel.com> (sfid-20180123_142500_466655_5A38B3DA)
Subject: Re: iwlegacy: Please change led_mode default to _LED_RF_STATE
From: Luciano Coelho <luciano.coelho@intel.com>
To: cyp@abwesend.de, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 23 Jan 2018 15:24:15 +0200
In-Reply-To: <CALY9mdzC06HRmPGF1q5G9Gz7Qc5miww8xuK-1rsGE37yMaQj1Q@mail.gmail.com>
References: <CALY9mdzC06HRmPGF1q5G9Gz7Qc5miww8xuK-1rsGE37yMaQj1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-23 at 12:55 +0100, cyp@abwesend.de wrote:
> Good morning, :-)
> 
> In iwlegacy/common.c, when module_param(led_mode) is not set by the
> user (i.e. it is 0=IL_LED_DEFAULT), then il_leds_init() uses the
> device's cfg->led_mode as the default. That inheritance is ok for
> devices that have cfg->led_mode = IL_LED_RF_STATE. But there are also
> .cfgs in which cfg->led_mode = IL_LED_BLINK. Then the inheritance is
> not so good. :-)
> 
> A blinking wlan led is a human factor problem when the wlan led lies
> within a user's field of vision, for instance on the keyboard or  on
> the display bevel. In those cases, the blinking is literally in-your-
> face, and therefore a distraction. Or annoyance. Or even drives
> people insane if they happen to have an HP device with a bright blue
> led on the wlan "media" key. :-)
> 
> In dozens (hundreds?) of posts dating back to at least 2008 and found
> all over the 'net, users have been seeking workarounds for a blinking
> wlan led. (search for: linux blinking wifi|wlan led)
> * One of those workarounds is of course to define led_mode=1 via
> /etc/modprobe.d/<whatever>.  But many of those posts are for older
> versions of the driver, and the solutions no longer work because the
> name of the driver has changed since then. (https://askubuntu.com/que
> stions/12069/how-to-stop-constantly-blinking-wifi-led has a list)
> * Another suggested workaround is to echo phyXradio >
> /sys/class/led/<whatever>/trigger and then stick that in a script in
> /etc/NetworkManager/dispatcher.d. Well, the led interface names have
> changed too (e.g. 'iwl-phyX:{assoc|radio|RX|TX}' is now 'phyX-led',
> so many of those suggestions no longer work either. Of course, it
> also breaks if phyX becomes phyY when the driver is reloaded.
> * Another workaround is to paste a piece of opaque tape over the led.
> I was recently a visitor at a high school where the "administrator"
> had done that for the laptops there. But kids will be kids, and most
> of the machines had "lost" the tape.  :-)
> 
> My point is, these "workarounds" are not solutions. They would also
> be unnecessary if the driver used a sane default to begin with, just
> as the newer iwlwifi devices have. You know the code and the design
> choices better than anyone else, but perhaps cfg->led_mode is just
> code cruft that is long obsolete. But perhaps the following change to
> iwlegacy/common.c would also be ok?:
> - /* default: IL_LED_BLINK(0) using blinking idx table */
> + /* module_param(led_mode) is evaluated in il_leds_init() below */
>   static int led_mode;
>   module_param(led_mode, int, S_IRUGO);
>   MODULE_PARM_DESC(led_mode,
> -                 "0=system default, " "1=On(RF On)/Off(RF Off),
> 2=blinking");
> +               "0=system default, 1=show RF on/off state, 2=blink on
> TX/RX");
> + /* previously (< Jan 2018) "system default" meant "inherit from
> device .cfg."
> + * Now, "system default" means "driver default" which is '1' for
> user sanity 
> + * and for consistency with newer intel wifi devices.
> + */
> 
>   void
>   il_leds_init(struct il_priv *il)
>   {
>         int mode = led_mode;
>         int ret;
> 
> -      if (mode == IL_LED_DEFAULT) 
> -             mode = il->cfg->led_mode;
> +      if (mode != IL_LED_BLINK) /* if user does not explicitly ask
> for blink ... */
> +             mode = IL_LED_RF_STATE; /* use stable (i.e. RF on/off)
> state */
> 
> 
> A non-blinking default would be great.

Emmanuel and I are not the maintainers of iwlegacy, so I'm adding the
linux-wireless mailing list and Stanislaw, who is the actual
maintainer.

--
Cheers,
Luca.
