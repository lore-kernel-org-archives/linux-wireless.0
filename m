Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49818 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZC3VCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 17:02:43 -0400
Date: Mon, 30 Mar 2009 18:02:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330210233.GE23749@khazad-dum.debian.net> (sfid-20090330_230248_815023_A9866849)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local> <20090330132911.GC11934@khazad-dum.debian.net> <1238422114.5970.6.camel@johannes.local> <20090330173421.GB23749@khazad-dum.debian.net> <1238434878.5970.17.camel@johannes.local> <20090330204800.GC23749@khazad-dum.debian.net> <1238446338.5970.41.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238446338.5970.41.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes!

On Mon, 30 Mar 2009, Johannes Berg wrote:

> On Mon, 2009-03-30 at 17:48 -0300, Henrique de Moraes Holschuh wrote:
> 
> > Yes, thinkpad-acpi wants it.  It uses that to make sure the bluethooth
> > and wwan rfkill _global_ state is kept across machine shutdown and
> > reboots (I can't do that for UWB because Lenovo didn't add persistence
> > for UWB for some reason).
> 
> Yeah, I've added it back already :)
> 
> > 1.  thinkpad-acpi loads
> >     1a. reads radio states from firmware, and stores to rfkill core
> >         default state for the specific radio type
> >     1b. registers the rfkill switch.  The core will cause the just
> >         registered rfkill switch state to be changed to match the
> >         current global state for that switch type... which probably
> >         is what thinkpad-acpi tried to set in 1a.
> 
> Yeah -- I need to add back 1b; I removed it for now because it goes like
> this:
> 
> 	driver - rfkill_register
> 	  rfkill - rfkill_register
> 	    rfkill - set radio
> 	      driver - set radio      <--- deadlock if this needs lock
> 
> This I need to schedule that away.
> 
> > > state should be set for the devices it applies to, but it seems that if
> > > the master rfkill switch is set to "transmitter off" then one needs to
> > > set the default state (for all USB transmitters etc) to off, correct?
> > 
> > Well, the default is applied to a _type_, so it is valid for all
> > switches of that type.
> 
> Right.
> 
> > It is probably a good idea to have the rfkill core sanitize the
> > attempt to set the default state, and force it to "block" if EPO is
> > active (I don't recall if I checked for this failure mode in the old
> > code).
> 
> No, but it rejects any calls to set the default state when any rfkill
> struct has been registered already. So this isn't a concern.

Suppose something entirely different (an input device) issued SW_RFKILL_ALL,
and EPO is in effect.  It happened right at boot because the user turned the
laptop on with the rfkill switch active, and that driver loaded first.

Now another driver is loading, and is registering the first rfkill struct of
type foo (say, for an USB 'foo' dongle that has no idea whatsoever of any
platform rfkill switches), and that USB 'foo' dongle is a really well-made
device that even has NVRAM with lots of state pertaining to 'foo', including
a bit used to keep persistent on/off state.

It will try to set the default state for type 'foo' (which might well be
unblock) while EPO is active.  This attempt to set the default for 'foo' to
ubblock can succeed or not (whatever is easier on the rfkill core code), but
either way it must _not_ cause any switches to be unblocked, and that
includes any subsequent rfkill_register (because EPO _is_ active)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
