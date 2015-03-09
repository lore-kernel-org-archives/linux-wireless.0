Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36052 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbbCIXBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 19:01:39 -0400
Date: Mon, 9 Mar 2015 15:49:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Message-ID: <20150309224929.GL5264@atomide.com> (sfid-20150310_000143_165727_07CC9F44)
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
 <1425915402-10012-3-git-send-email-eliad@wizery.com>
 <9217056.Z3urqp19oZ@wuerfel>
 <CAB3XZEc_sjpA8kgfYCsO8FjGEc6O0xhE9aKO3VtgVbd+Meaakg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEc_sjpA8kgfYCsO8FjGEc6O0xhE9aKO3VtgVbd+Meaakg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eliad Peller <eliad@wizery.com> [150309 14:03]:
> On Mon, Mar 9, 2015 at 9:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 09 March 2015 17:36:42 Eliad Peller wrote:
> >> --- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> >> +++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> >> @@ -64,4 +64,13 @@
> >>         vmmc-supply = <&lbep5clwmc_wlen>;
> >>         bus-width = <4>;
> >>         non-removable;
> >> +
> >> +       #address-cells = <1>;
> >> +       #size-cells = <0>;
> >> +       wlcore: wlcore@2 {
> >> +               compatible = "ti,wl1835";
> >> +               reg = <2>;
> >> +               interrupt-parent = <&gpio5>;
> >> +               interrupts = <8 IRQ_TYPE_NONE>;
> >> +       };
> >>
> >
> > Why IRQ_TYPE_NONE?
> >
> i simply mirrored the current board file (which only sets the irq number).
> 
> > I was expecting you to remove all calls to legacy_init_wl12xx from this file,
> > including the ones for wl12xx aside from the wl18xx ones you removed, but
> > if that's enough to clean out the platform_data handling from the wlcore
> > driver, it's good enough as a start.
> not sure i'm following - can you elaborate?
> 
> i'll summarize the way i see it. please correct me if i'm wrong.
> 
> both wl18xx and wl12xx use the platform data to get the irq number.
> wl12xx (only) also needs some additional clock definitions to be
> passed. there's currently some issue with specifying some the of clock
> sources, so i preferred starting only with (the simpler) wl18xx
> bindings.
> 
> for platforms with wl18xx, we can remove the pdata-quirk, as all the
> data (i.e. irq) can be passed by the new DT bindings.
> however, for platforms with wl12xx, we still need to pass the clock
> definitions (along with the irq), so we have to keep
> legacy_init_wl12xx for the time being (and that's also why we have to
> currently keep the platform_data handling in the wlcore driver)
> 
> do you have something else in mind?

I think what Arnd is saying is we've now removed all the wl12xx using
legacy platforms, so all of them can boot with just data from dts.

Regards,

Tony
