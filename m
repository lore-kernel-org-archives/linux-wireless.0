Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45547 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbYIRNQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 09:16:49 -0400
Date: Thu, 18 Sep 2008 10:16:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit
	bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Message-ID: <20080918131643.GC1583@khazad-dum.debian.net> (sfid-20080918_151652_672199_8B2A1F45)
References: <48CFC03A.8020708@lwfinger.net> <200809171619.33377.mb@bu3sch.de> <20080917151822.GB5186@khazad-dum.debian.net> <200809171759.32645.mb@bu3sch.de> <1ba2fa240809171351h293012daj4e1735f52e08b48b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240809171351h293012daj4e1735f52e08b48b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Sep 2008, Tomas Winkler wrote:
> In practice the rfkill in WiFi comes to 2 common cases
> HW|SW
> 
> Most of the world SW and HW are independent states and radio is
> enabled only in 0|0
>         0|1
>       /       \
> 0|0 -          - 1|1
>       \       /
>         1|0

Indeed.  And it is like that, because that's how WiFi hardware with hardware
rfkill input lines work in the bare metal.

> Dell Only - Unblocking HW rfkill enabled radio.
>             0|1
>         /          \
> 0|0 -- <-HW- - 1|1
>         \         /
> 	    1|0

This is likely Dell's crap of a firmware getting in the way.

Still, does the Dell firmware interferes just when the HW rfkill input line
changes state (i.e. on edges), or all the time?

> This is why all vendors (including iwlwifi) that targets notebook and
> friends markets need to implement independent SW HW rfkill switches
> and we need 2 bits (4 states- 3 states are not  enought I've wrote
> that couple of times....

You need two bits inside the drivers, yes.

However, the core interface (rfkill) does not.  It has a different point of
view, one that is driven by the needs of the interface and userspace
applications, and not by hardware implementation.

The rfkill core has three states:

	0 - Radio blocked, but could be unblocked by software request
	1 - Radio unblocked, can always be blocked by software request
	2 - Radio blocked and locked, software request cannot unblock it

These states are defined by the valid [for rfkill] combinations of two
SEMANTHIC parameters: "the current state can be changed by the
rfkill->toggle_radio() callback" and "transmitter is currently emmiting
energy".

There is no fourth state, because a radio locked into unblocked mode is
completely unacceptable for rfkill: it is against all safety regulations for
the kind of wireless transmitter rfkill is concerned with.

The reason why the underlying wireless driver can or cannot change the
transmitter state through rfkill->toggle_radio() is NOT important to the
rfkill core.  And if it were, IMHO we would be better off by exporting that
as a separate attribute, and not messing with the rfkill states.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
