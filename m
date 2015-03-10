Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52546 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbCJPzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:55:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Date: Tue, 10 Mar 2015 16:54:40 +0100
Message-ID: <2231165.khxX6WSbaL@wuerfel> (sfid-20150310_165520_738131_080BB0B9)
In-Reply-To: <CAB3XZEc_sjpA8kgfYCsO8FjGEc6O0xhE9aKO3VtgVbd+Meaakg@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <9217056.Z3urqp19oZ@wuerfel> <CAB3XZEc_sjpA8kgfYCsO8FjGEc6O0xhE9aKO3VtgVbd+Meaakg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 March 2015 23:03:30 Eliad Peller wrote:
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

The irq type is set in this chunk of code from wlcore_nvs_cb:

        if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ) {
                irqflags = IRQF_TRIGGER_RISING;
                hardirq_fn = wlcore_hardirq;
        } else {
                irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
        }

This means you would replace the platform_quirks with setting the
correct irq type.

	Arnd
