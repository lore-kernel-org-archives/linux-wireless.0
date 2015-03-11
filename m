Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61651 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbbCKNRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 09:17:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Tony Lindgren <tony@atomide.com>, Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Date: Wed, 11 Mar 2015 14:17:42 +0100
Message-ID: <2353601.si5uCETVn2@wuerfel> (sfid-20150311_141756_520593_EC1E0CC9)
In-Reply-To: <CABxcv=mPVxW=BqL2PUL=AtS74kcqMG1yxC1WqMpxGiNOqGAnyQ@mail.gmail.com>
References: <1425915402-10012-1-git-send-email-eliad@wizery.com> <6286151.8rcX893TN6@wuerfel> <CABxcv=mPVxW=BqL2PUL=AtS74kcqMG1yxC1WqMpxGiNOqGAnyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 March 2015 14:07:11 Javier Martinez Canillas wrote:
> 
> Right now it seems that all boards in mainline with a WiLink6 part are
> using internal clocks. So as a first step I think that adding an
> optional refclock-frequency and tcxoclock-frequency properties should
> be enough.
> 
> It would be good if the driver supports getting the refclock and
> tcxoclock from an external provider in case a board gets these from
> external clocks but that can be done as a followup if there are boards
> in the future using that design.
> 
> But please bear in mind that I'm not familiar with the clock handling
> in WiLink6 since the WiLink8 part used in the IGEP boards does not
> need these clocks and I only looked at Luciano's previous patches and
> the WiLink today driver today. So it would be good if Eliad can double
> check my assumptions to see if those are correct.

Sounds good. I'd also be fine with not implementing the case for
external clocks in the code until we need (and can test) it, but
I think it should be specified in the binding from the start.

	Arnd
