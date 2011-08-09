Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34520 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HIPwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com>
References: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com>
Date: Tue, 9 Aug 2011 11:52:00 -0400
Message-ID: <CACqU3MWU-Mas_c814EcMjSgAh5dbOmDDrLzbtCFaf3wpMEHexA@mail.gmail.com> (sfid-20110809_175206_035317_6579B2B9)
Subject: Re: Cannot easily set CONFIG_WIRELESS_EXT in kernel 3.0 build
From: Arnaud Lacombe <lacombar@gmail.com>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Aug 9, 2011 at 11:04 AM, Pavel Ivanov <paivanof@gmail.com> wrote:
> Hi,
>
> I've tried to build and install kernel 3.0. The standard Ubuntu
> configuration worked very well. But after I ran 'make localmodconfig',
> rebuilt and rebooted my wireless didn't work. After some investigation
> I've found that option CONFIG_WIRELESS_EXT is no longer set in .config
> file.
what is the ubuntu kernel version ?

> But no matter how I tried to include it in .config file it was
> automatically deleted by 'make oldconfig' and again kernel compiled
> without it.
well, .config is not meant to be edited manually. It is written at the
top of the file:

# Automatically generated file; DO NOT EDIT.

> Then I've found that if I include in the build some
> (completely unnecessary to me) wireless module which has 'select
> WIRELESS_EXT' in its Kconfig then it stays in .config file and
> resulting kernel works very well with my WiFi network.
>
expected behavior.

> In fact even if
> I add 'select WIRELESS_EXT' to Kconfig of the driver for my wireless
> card (ath9k) everything works as well.
>
did you look at ubuntu kernel sources to see if the Kconfig entry
ath9k driver had been changed to 'select WIRELESS_EXT' ? What may be
more likely is that ubuntu is building a bundle of driver, and one of
them include WIRELESS_EXT.

> I'd think that such behavior is a bug, although I don't know on which
> side. Either on the side of wireless drivers which all have to have
> 'select WIRELESS_EXT' in their Kconfig files
>From what you describe, I'd say yes.

> or on the side of kbuild
> system which doesn't allow me to set CONFIG_WIRELESS_EXT unless some
> driver requires it. Interestingly enough requiring WIRELESS_EXT works
> only with drivers, because I've tried to add CONFIG_LIBIPW (it
> requires WIRELESS_EXT too) but it was automatically deleted from
> .config file along with CONFIG_WIRELESS_EXT. So I couldn't include
> only this library.
>
as Michal pointed out, that's the intended behavior.

Could you generate a patch for the change you made to make your
adapter works and send them to the wireless folks ? They are likely to
be more aware of the various requirement and inter-dependency of the
subsystem.

Thanks,
 - Arnaud

> Could you tell me if this is indeed a bug or am I missing something here?
> I'm not subscribed to the lists so please add me in CC.
>
>
> Pavel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
