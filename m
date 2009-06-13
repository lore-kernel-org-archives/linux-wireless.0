Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:43026 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZFMUYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 16:24:07 -0400
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
From: Marcel Holtmann <marcel@holtmann.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Pierre Ossman <pierre@ossman.eu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, san@google.com
In-Reply-To: <873aa3opsr.fsf@litku.valot.fi>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	 <1244685780-28930-8-git-send-email-me@bobcopeland.com>
	 <20090613132144.6c7783bc@mjolnir.ossman.eu> <87bposnmxi.fsf@litku.valot.fi>
	 <1244922097.1852.4.camel@violet>  <873aa3opsr.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:24:07 +0200
Message-Id: <1244924647.1852.10.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> >> wl1251 has these lines to the host:
> >> 
> >> o four lines for SDIO or SPI, configured to SDIO by default
> >> o power line
> >> o interrupt line
> >> 
> >> When the power line is pulled up, the chip will power on itself.
> >> Whenever the power line goes down, the chip will power off. For example,
> >> the power line can be controlled with a GPIO pin from the host. But how
> >> the power line is really controlled, is board specific and should be
> >> handled in the board file. And here comes the set_power() function to
> >> the picture. The wl1251 driver will call set_power() function every time
> >> user space calls wlan interface up or down.
> >> 
> >> Pierre, how do you propose we should do this? I understood based on
> >> discussions from linux-omap that this is a common way.
> >
> > actually this looks like a RFKILL hard switch to me.
> 
> I have my doubts. For example, when you turn off and on the power from
> the wl1251 chip you have to reupload the firmware and boot it again,
> which is slow. I have been thinking more like turning off the radios
> when rfkill is enabled, which is significantly faster. But I haven't
> looked at rfkill yet, and I'm not planning to do it until the dust has
> settled within the next few months :)
> 
> > Why don't we just integrate it with RFKILL and this way have a common
> > interface to handle all of these.
> 
> But rfkill won't solve the problem under discussion. rfkill is the
> interface between wl12xx driver and higher levels, but the problem here
> is the lower level interface, that is how does wl12xx driver shall
> control the actual hw line. We need to have a generic way to control the
> hw line so that driver works in TI's OMAP architecture, whatever Google
> is using and all the other possible (embedded) combination where Linux
> can run.
> 
> Because I know that my english sucks, I'll draw an architecture diagram
> to show what I'm trying to say here:
> 
> ---------- ------------
> | rfkill | | mac80211 |
> ---------- ------------
> 
> -----------------------
> |       wl12xx        |
> -----------------------
> 
> -----------------------
> |    hw power line    |
> -----------------------
> 
> So rfkill is on the opposite side of wl12xx compared to the actual hw
> power line.

we do have the RFKILL (aka soft killswitch) that is now integrated with
mac80211 and we do have separate RFKILL hardware killswitches.

For example the Bluetooth pieces inside a laptop now have a Bluetooth
hardware killswitch (behind a platform device) and the soft killswitch
from the Bluetooth subsystem. They are two independent pieces.

RFKILL is a confusing beast ;)

Regards

Marcel


