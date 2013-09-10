Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42566 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3IJTQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 15:16:30 -0400
Message-ID: <1378840613.4223.34.camel@porter.coelho.fi> (sfid-20130910_211633_362597_0A92C075)
Subject: Re: [PATCH 02/12] wlcore: add new plt power-mode: CHIP_AWAKE
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Sep 2013 22:16:53 +0300
In-Reply-To: <CAB3XZEd=n5=pG9=Rvj6P6RHygqYyoqh3rGa3ntQf9f=obK03Sg@mail.gmail.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-2-git-send-email-eliad@wizery.com>
	 <1378794813.4799.35.camel@porter.coelho.fi>
	 <CA+XVXfdiudFgdXVAugkHVBLPVgLyrsokosCyhpNd5c5G7DOcOg@mail.gmail.com>
	 <1378796198.4799.49.camel@porter.coelho.fi>
	 <CAB3XZEd=n5=pG9=Rvj6P6RHygqYyoqh3rGa3ntQf9f=obK03Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-10 at 15:46 +0200, Eliad Peller wrote:
> On Tue, Sep 10, 2013 at 9:56 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2013-09-10 at 08:47 +0200, Arik Nemtsov wrote:
> >> On Tue, Sep 10, 2013 at 9:33 AM, Luca Coelho <luca@coelho.fi> wrote:
> >> > On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
> >> >> From: Yair Shapira <yair.shapira@ti.com>
> >> >>
> >> >> Under this mode the chip is powered on including sdio
> >> >> but no FW is downloaded and run, interrupts are not enabled, etc...
> >> >>
> >> >> This mode is intended to allow RTTT to bridge sdio as a transport
> >> >> to the chip.
> >> >>
> >> >> Driver only provides sdio access using the dev_mem debugfs file.
> >> >>
> >> >> Some fixes done to the code that ensures that PLT mode and normal
> >> >> driver power mode (ifconfig/add_interface) are mutually excluded.
> >> >>
> >> >> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> >> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> >> ---
> >> >
> >> > I had some comments to this patch internally while I was still at TI.
> >> > Namely, I asked why do we need a new way of doing this if this is
> >> > already possible via debugsfs (using the gpio_power file)?
> >>
> >> Are you commenting on the correct patch? Seems this is just a patch to
> >> prevent "ifconfig up" during PLT mode..
> >
> > Yes, I'm commenting on the right patch.  It allows the chip power
> > (namely the WLAN_EN GPIO pin) to be set directly, without loading the
> > firmware and doing other initialization stuff.  This can already be
> > controlled via the gpio_power debugfs file.  I've used that a bunch of
> > times, including with the RTTT tool.
> >
> > Okay, this patch has a few more protections (eg. not allowing an
> > interface to be added while the chip is powered in this way), but this
> > could also be added on top of the existing implementation.
> >
> i guess this just a bit "cleaner" (similar to the way PLT is used).
> the gpio_power debugfs only toggles the gpio power, without changing
> the driver mode, so adding similar protections will be more
> complicated.

Maybe, but the truth is that you don't need to add these protections,
unless you really want to shoot your own foot and start mangling with
the interfaces.  These tools are usually used in very controlled
environments (like RF R&D and production testing).

Still, this is okay, but it's just bad to see things being done in two
different ways.  I guess whoever requested this "new feature" didn't
know about the gpio toggling debugfs file.

--
Luca.

