Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49248 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758329AbYF0WMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 18:12:34 -0400
Date: Fri, 27 Jun 2008 19:12:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] rfkill: rename the rfkill_state states and add
	block-locked state
Message-ID: <20080627221228.GB8266@khazad-dum.debian.net> (sfid-20080628_001239_563648_E5032E5B)
References: <1214254004-32652-1-git-send-email-hmh@hmh.eng.br> <1214254004-32652-2-git-send-email-hmh@hmh.eng.br> <1214591028.24579.18.camel@localhost.localdomain> <20080627213524.GA8266@khazad-dum.debian.net> <1214602787.9373.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214602787.9373.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Jun 2008, Dan Williams wrote:
> On Fri, 2008-06-27 at 18:35 -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 27 Jun 2008, Dan Williams wrote:
> > > So with this patch, in the case where ex. hp-wmi advertises a killswitch
> > > and the wlan driver itself doesn't have one, when NM wants to softkill
> > > the radio, should NM do a SIOCSIWTXPOW or softblock the hp-wmi
> > > killswitch?  Or would the wlan driver implement an rfkill handler and
> > 
> > I thought a lot about it, and I personally feel it is better to keep
> > SIOCSIWTXPOW separate from rfkill.  This is a driver layer thing, and rfkill
> > doesn't care either way, but IMHO it is less confusing for the user if
> > iwconfig txpower doesn't change the rfkill status of a device.
> > 
> > This means NM would be trying to set the class/rfkill*/state to
> > RFKILL_STATE_SOFT_BLOCKED for the devices it wants to block.
> > 
> > And the way to be able to do it without going insane really is to start
> > adding rfkill subsystem support to all wireless network drivers, so your
> > WLAN devices will all have a rfkill class related to them.
> 
> Right, but that's the part we don't yet have, correct?  Can I just start

Correct, not all wireless device drivers support the rfkill class, and those
which do need to be revised to make sure they're doing it right.

> adding rfkill capability with the patchset you just posted to drivers
> like airo and atmel even though they don't have killswitches themselves?

Yes, *provided* that you do so by *adding* a rfkill controller (software
based) to them.  And that, of course, requires you to be able to get the
devices to stop emitting energy in software somehow.

By *definition*, you did not rfkill something if it still keeps emmiting
radio waves, or light, or whatever (even if data transfer itself is not
happening).  For some devices this is easy.  For others, you might find out
you need to put them in D3, or power down their USB port... and for others
it will be just plain impossible.

I don't know the airo and atmel devices you mention, so I have no idea how
easy (or difficult) it is to make them stop emitting energy.


Here is a weird example (with a happy ending) to make it clear:

[PS: I don't know if bluetooth keeps emitting energy when there is no data
to transmit. I will assume it does, since the laptop vendor added expensive
circuitry to make damn sure it could be powered off].

The thinkpad builtin bluetooth device is *impossible* to rfkill as far as
the bluetooth driver is concerned.  So, whatever bluetooth driver takes care
of the builtin thinkpad USB dongle here can't do anything.  It CANNOT
support rfkill.

  * Therefore, the bluetooth driver does not connect that device with a
    rfkill class, because it is impossible for that dongle hardware.  Even
    if the driver were to ignore data received by the device and halt data
    transmissions to it, it would still be emmiting radio signals so it
    would be a LIE to say it was rfkilled.

=> if the user depended only on the bluetooth device driver, he would NOT
have rfkill capabilities for bluetooth at all on the thinkpad.  In fact, he
will not get a "RF kill this radio" control in NM on this device.

Lenovo, however, added a hard rfkill hardware to make up for the lack of
native rfkill support on the bluetooth dongle: it has firmware and hardware
that powers off the dongle(!).  thinkpad-acpi knows about this hard rfkill
controller, and exports it through the rfkill class.

=> the user gets a rfkill class that says it is of type bluetooth, but it is
not connected to a bluetooth device (it is connected to the platform, i.e.
the computer itself).  Now, it is not the bluetooth device, but NM lets him
set it to RFKILL_STATE_SOFT_BLOCKED.  And when he tries it... the other
bluetooth device that had no "RF kill this radio" control goes away! (it has
been hot-unplugged, as power was cut off and that makes it disappear from
the USB bus).  How quaint!

It is not perfect beauty, but it works.  Maybe NM can use some assumptions
to make it better (example: if there is a single bluetooth platform rfkill
controller, and a single bluetooth device with no rfkill controller, assume
the platform device one will control the device), but it might be a wrong
assumption in some platform out there.

Maybe we can even teach HAL about these assumptions for some machines, if it
is deemed important enough (rfkill certainly works without it and won't want
to know about it, but GUIs might present a better interface for the user
with that information).

And I sure hope it is just bluetooth and WWAN that will be annoying like
this.

> That's the conceptual problem here; cards like airo and atmel don't have
> killswitches, and since /sys/class/rfkill/rfkillX are _switches_ right
> now, it gets confusing when a device that isn't a killswitch would start
> providing rfkillX.

Let's avoid the term "switches", please.  Look at the new documentation, and
use rfkill controller, hard rfkill line, soft rfkill line and input device,
please :-)

I hope I got what you meant with "switches" correctly, I know nothing of the
atmel and airo.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
