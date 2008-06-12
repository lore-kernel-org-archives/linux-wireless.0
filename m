Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48824 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbYFLQbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 12:31:39 -0400
Message-Id: <1213288298.11423.1258137419@webmail.messagingengine.com> (sfid-20080612_183143_219166_211AEBEF)
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Dan Williams" <dcbw@redhat.com>
Cc: "Matthew Garrett" <mjg@redhat.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
 <20080605003808.GA16599@khazad-dum.debian.net>
 <1212667955.25730.29.camel@localhost.localdomain>
 <20080605130323.GB3413@khazad-dum.debian.net>
 <1212677207.28545.56.camel@localhost.localdomain>
 <1212696826.13915.1256967905@webmail.messagingengine.com>
 <1212722763.1026.17.camel@localhost.localdomain>
 <1212758662.26514.5.camel@localhost.localdomain>
 <20080606141419.GA3444@khazad-dum.debian.net>
 <20080608201603.GA25453@srcf.ucam.org>
 <20080610041136.GA20310@khazad-dum.debian.net>
 <1213285384.6589.28.camel@localhost.localdomain>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
In-Reply-To: <1213285384.6589.28.camel@localhost.localdomain>
Date: Thu, 12 Jun 2008 13:31:38 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jun 2008 11:43:04 -0400, "Dan Williams" <dcbw@redhat.com> said:
> As you've explained it, I believe this will work IFF we take your
> suggestion and add a 3rd state RADIO_SW_BLOCKED to go along with
> RADIO_HW_BLOCKED and RADIO_UNBLOCKED.

Now you get it why I wanted the third state instead of a separate attribute,
I hope.  It integrates much better on how *current* rfkill is supposed to
be used.

Good, I now just have to get to that email explaining switches, which I sort
of managed to already do partially, if you understood the above :-)

> In this system, if NM wants to softblock a wifi device for example, it
> would likely just turn off the transmitter with 'SIOCSIWTXPOW', thus the

Or you could also use sysfs to set the state to 0 (BLOCK).  It is supposed
to perform the same operation as 'SIOCSIWTXPOW' to a power of 0, as far as
rfkill is concerned.  Or you could, if you wanted to turn off *ALL*
transmitters of the same type, issue an input layer event for rfkill-input
to process.  Whichever suits your application best.

> wifi device itself would report it's rfkill state as RADIO_SW_BLOCKED.
> NM would then be aware that it could be re-enabled at any time through
> software.

Yes.

> If the user then hits the hardkill switch, the wifi device would report
> RADIO_HW_BLOCKED, and NM would be aware that the user must unkill the
> transmitter with a physical switch.

Yes.

> It gets a bit interesting when unrelated killswitches like hp-wmi and
> thinkpad-acpi are used, because if those just softkill the radio, you
> could end up in the situation where the radio itself is RADIO_UNBLOCKED
> but the struct rfkill created by hp-wmi is RADIO_SW_BLOCKED if BIOS
> doesn't track the actual state of the radio too.  How do we fix that?

It is already fixed :-)  The radio itself will be RADIO_HW_BLOCKED (to
use your terms).  Think about it: the thinkpad-acpi and hp-wmi
softswitches are not magic, they somehow rfkill the real radio devices.

That "somehow" is done through an input pin in the radio device that
will change state when the thinkpad-acpi/hp-wmi softswitch changes state,
so the radio device driver (which has NOTHING to do with thinkpad-acpi
OR hp-wmi, and doesn't even know they exist!) will report that the radio
is now in state RADIO_HW_BLOCKED.

So, a softswitch in one platform driver like thinkpad-acpi or hp-wmi CAN
cause a separate device under control by another module (the radio itself)
to see a hardswitch rfkill happening.  This is fine, it is as things are
supposed to work.

That's why I call the current rfkill design one that hides the switch
topology from its users.  Which is a Good Thing, as it means it gets
that much easier to write platform drivers and network drivers that
use rfkill.

The uglyness of the way some devices implement rfkill happens when the
hardware/firmware itself kludges things by unplugging devices from the
BUS when you rfkill that device.  This has nothing to do with the rfkill
code in the kernel, it is just how some of these things work and we cannot
change that.  Bluetooth and WWAN usually get this kind of treatment.
There is no sane workaround that could be done for that, we will have to
deal with hotplug and hotunplugging being a common operation for such
devices.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

