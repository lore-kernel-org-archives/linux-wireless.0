Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64236 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbbCKNOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 09:14:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eliad Peller <eliad@wizery.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
	Tony Lindgren <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Date: Wed, 11 Mar 2015 14:13:59 +0100
Message-ID: <2233058.m8xh0sUU5j@wuerfel> (sfid-20150311_141439_229949_726D3FDB)
In-Reply-To: <CAB3XZEfnZbZqH95suJ9n39aZRr8kxPdj2HZuWKMvQtYmXe3QEQ@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <CABxcv=nE_Qd7do+dRyp=fw3wYmWFb+0eEjXYOtdjqE55Cp0zmQ@mail.gmail.com> <CAB3XZEfnZbZqH95suJ9n39aZRr8kxPdj2HZuWKMvQtYmXe3QEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 March 2015 14:12:54 Eliad Peller wrote:
> On Wed, Mar 11, 2015 at 1:34 PM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
> > I think that patch [0] should not be needed since for external clocks,
> > the IP providing the clocks should have its own clock driver and for
> > internal clocks, a property should be used instead as you said.
> >
> >> If there is no external clock provider for this chip and the clocks
> >> are provided by the device itself, then all we need is a clock-frequency
> >> property in the device node.
> >>
> >
> > Agreed, IIUC Luciano wanted to expose the internal clocks by
> > registering in the common clock framework but if those clocks are not
> > really accessible from outside the wlan chip, then I also think that a
> > device node property should be used instead.
> >
> how should i describe multiple clock-frequency properties (there are 2
> relevant clocks) in this case?
> 
> does something like the following makes sense?
> 
> wlcore: wlcore@2 {
>     ...
>     refclock: refclock {
>         compatible = "fixed-clock";
>         #clock-cells = <0>;
>         clock-frequency = <38400000>;
>     };
> }

I would put that clock node on the top level of the DT, as you are
describing an external clock input here, but other than that, it looks
good.

I would do the binding in a way that mandates either a "clocks"
reference to an external clock provider in case of a XTAL or
a "clock-frequency" property. In the first case, you can use
the "clock-names" property to identify the "ref" and "txco"
clock inputs, in the second case we could either decide
to have a single property with two cells, or have named
properties like

	wlcore@2 {
		interrupts = < ... >;
		tcxo-clock-frequency = <38400000>;
		ref-clock-frequency = <19200000>;
	}

I don't know which combinations are possible here. I did notice
that most of the references in the board hacks use '0' as the
tcxo clock value, which happens to be the same as
WL12XX_TCXOCLOCK_19_2, but could also meant that no tcxo clock
is used.

	Arnd 
