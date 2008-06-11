Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:22500 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYFKRKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 13:10:54 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2579730waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 10:10:53 -0700 (PDT)
Message-ID: <1ba2fa240806111010r54772177r9b274590f8fa89d8@mail.gmail.com> (sfid-20080611_191057_375259_11808A85)
Date: Wed, 11 Jun 2008 20:10:53 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "Matthew Garrett" <mjg@redhat.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <20080610041136.GA20310@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <1212667955.25730.29.camel@localhost.localdomain>
	 <20080605130323.GB3413@khazad-dum.debian.net>
	 <1212677207.28545.56.camel@localhost.localdomain>
	 <1212696826.13915.1256967905@webmail.messagingengine.com>
	 <1212722763.1026.17.camel@localhost.localdomain>
	 <1212758662.26514.5.camel@localhost.localdomain>
	 <20080606141419.GA3444@khazad-dum.debian.net>
	 <20080608201603.GA25453@srcf.ucam.org>
	 <20080610041136.GA20310@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 7:11 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sun, 08 Jun 2008, Matthew Garrett wrote:
>> On Fri, Jun 06, 2008 at 11:14:19AM -0300, Henrique de Moraes Holschuh wrote:
>> > 1. Every transmitter shall have ONE, and just ONE (not zero, not two,
>> > not more) rfkill class attached.  For those transmitters lacking support
>> > in hardware to make it block, the drivers shall quiesce them and avoid
>> > doing anything to cause transmissions, or even use bus tricks to power
>> > the device down (i.e. the driver will emulate a switch capable of doing
>> > the blocking).
>>
>> How do we enforce this? iwl4965 provides an rfkill device, but hp-wmi
>> will also provide one for the wifi. If I swap out the wireless card for
>> something else, I may lose the card-specific rfkill device.
>
> Let's define some very STRICT terminology to avoid confusion.
>
> rfkill class:  the sysfs rfkill class, related to struct rfkill.
>
> rfkill class attached [to a Linux struct device]: a device whose
>  struct device was given to rfkill_allocate() as the parent.
>
> transmitter:  part of a wireless device.  So far, every wireless device
> I have seen has only one transmitter from the kernel PoV.  A device
> with two transmitters would be able to transmit two different information
> streams at the same time, with different parameters (such as frequency,
> power).
>
> transmitter != switch, so hp-wmi, thinkpad-acpi, and anything else that is
> not an actual wireless hardware device IS NOT INCLUDED in that "one and just
> one" constraint.  In fact, thinkpad-acpi has two rfkill classes attached to
> its main platform device, one for the bluetooth softswitch, and another for
> the wwan softswitch.
>
> So, "Every transmitter shall have ONE and just ONE rfkill class attached."
> just means that you call rfkill_allocate with that device as the parent just
> ONCE per transmitter (and everything I have seen so far has just one
> transmitter).


Not that I cannot read the code, but what this rkill class actually
should do according your vision?
Does it implement radio-state state machine....notification hub for
rfkill switches ...



>
> Which also means that, for wireless drivers (which have transmitters), you
> need to synthesize the "device rfkill state" to give to that rfkill class.
> THE TRANSMITTER MIGHT BE UNDER THE EFFECT OF MORE THAN ONE RFKILL LINE.
>
> And if the device [transmitter] has NO rfkill capabilities by itself, we
> emulate the minimum of one in software [per transmitter].   If the device
> has one input pin for rfkill, that one is also taken into account when
> generating the state for the ONLY ONE rfkill class attached to that device
> [per transmitter], etc.
>
> Now, firmware switches are different, and something for another email that
> I haven't typed in yet (busy in real life right now).
>
> An example:
>
> ipw4965 probably has two rfkill controls in itself (an input pin for a
> hardkill line, and an R/W IO register to help its driver (ilw4965) implement
> a rfkill softswitch).  Those TWO rfkill inputs are to be combined into just
> ONE rfkill class which will be attached to the Linux device provided by
> ilw4965.  This is the end of the story from the PoC of the ilw4965 module.
>

iwl4965 has actually one more rf kill switch. It switches itself off
if it goes over critical temperature.
For NIC it looks like temporal rfkill.

Tomas


> hp-wmi probably has one softswitch it controls, that ends up connected to
> that input pin in the ipw4965 card so you end up being able to use a hp-wmi
> softswitch to hardkill the ipw4965 card.  This IS expected, and it will not
> matter or break anything.  In the current rfkill incarnation, rfkill doesn't
> understand or know or want to know about rfkill switch topology as it
> stands.
>
> Did I manage to get the idea across, this time?  Remember, I am not
> describing the rfkill class interactions for switches in that email, JUST
> for wireless drivers, which hp-wmi, thinkpad-acpi, etc are not...
>
> What happens on the hp-wmi side when the ipw4965 card is removed, is to be
> explained in the other email about switches, but it is not much.  Basically,
> hp-wmi has to be written in such a way that it won't matter for the user,
> and THERE is the real reason why one must never confuse the softswitch
> control with input devices.  Remember that as long as rfkill-input is
> loaded, if anything sends a "change all WLAN rfkill switches" input event,
> all WLAN rfkill switches WILL be changed, regardless of whether they are
> wired among themselves, or completely independent.
>
> --
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh
>
