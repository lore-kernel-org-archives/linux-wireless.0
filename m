Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rain.florz.de ([62.216.164.86]:40486 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753261AbZLRS7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 13:59:32 -0500
Date: Fri, 18 Dec 2009 19:59:16 +0100
From: Florian Zumbiehl <florz@florz.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: andreamrl@tiscali.it, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
Message-ID: <20091218185916.GE2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org> <4B2BC7E3.2050907@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B2BC7E3.2050907@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I don't have a clue (yet) where exactly all that power goes to, and how
> > much of it is actually being used by the stick itself (it's getting pretty
> > warm, too - maybe you have a clue what to expect there?). But apparently,
> > quite a bit of that increased power consumption is due to the CPU entering
> > ACPI sleep states for a much smaller proportion of time, and not entering
> > the highest sleep state at all anymore (which otherwise makes up around
> > 98 % of the time) due to some polling/high-frequency interrupt of the
> > driver. After all, even the most inefficient voltage regulator can't
> > make 15 W from USB's max. 2.5 W (I hope ...).
> 
> My RTL8187B does get quite warm. The 'lsusb -v' output says that the
> device can draw up to 500 mA or the maximum 2.5 W, but it does seem
> warmer than that.

That's my impression, too ... but it doesn't feel like 15 Watts,
either :-)

> > Now, the obvious question is: Is there anything one could do about that?
> 
> AFAIK, the rtl8187 driver is not running any polling loops. It will
> interrupt the machine whenever it receives something or whenever data
> needs to be transmitted. You could cut the frequency by changing the
> beacon interval to 2 s. It is probably now set at 0.1 s.

Beacons are sent by the AP only, aren't they? I guess I could try
playing with the AP's config. On the other hand, the point of a wifi
interface for my laptop is not primarily to connect to my own
network ...

> > And if not, or possibly even if: Any recommendation for a power-efficient
> > USB 802.11 adapter - in particular something that does not cause
> > CPU wakeups all the time when there is no actual network traffic?
> 
> Not all network traffic is data.

Well, yeah, I meant "payload I care about", of course :-)

For comparison, if I plug in and configure my prism2 card to connect
to the same AP, power consumption goes up by ~ 2 Watts while idling.
Given that it seems to be possible to build a wifi interface (plus driver)
that does manage to stay connected on a budget of ~ 2 Watts, I would hope
that there is such a thing for USB, too. b-only would be fine, too - it's
USB 1.1 only, anyhow.

Florian
