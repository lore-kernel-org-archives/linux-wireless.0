Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:49662 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYLLUtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 15:49:13 -0500
Date: Fri, 12 Dec 2008 15:33:41 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: Fuijtsu Lifebook RFKILL support
In-reply-to: <20081212195331.GA12679@khazad-dum.debian.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tony Vroon <tony@linx.net>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain> (sfid-20081212_214919_992216_FF869E34)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1228957506.4045.11.camel@localhost>
 <20081211165247.GA4844@khazad-dum.debian.net>
 <1229016827.6446.6.camel@localhost>
 <20081211194734.GA18132@khazad-dum.debian.net>
 <1229046602.4030.13.camel@localhost>
 <20081212195331.GA12679@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding linux-wireless@vger.kernel.org
i expect somebody there may know a thing or two about the
proper way to do rfkill...

-- 
Len Brown, Intel Open Source Technology Center

On Fri, 12 Dec 2008, Henrique de Moraes Holschuh wrote:

> On Fri, 12 Dec 2008, Tony Vroon wrote:
> > On Thu, 2008-12-11 at 17:47 -0200, Henrique de Moraes Holschuh
> > wrote:
> > > I don't think so if you mean Gnome knowing what to do with EV_SW
> > > SW_RFKILL_ALL.  That is not a report that radios got rfkilled, but
> > > rather a COMMAND to rfkill all radios.
> > 
> > Right, so are we talking across purposes here?
> 
> Probably.  You still need to generate that SW_RFKILL_ALL input event
> anyway, btw, so that the rest of rfkill can know when the user wants
> all radios killed.
> 
> > I want to report radio status to userland so NetworkManager can stop
> > helplessly flailing around asking me for a WPA2 password in a loop
> > if I kill the radios.
> 
> That is a bug somewhere, and at first glance it looks to be either in
> the wireless network driver, wpa_supplicant, or network manager.  It
> needs to be fixed, not worked around.
> 
> What is the WLAN driver involved? Is it rfkill-aware?
> 
> > What I have is an event-driven report that includes radio killswitch
> > status, HARD_BLOCKED or UNBLOCKED in rfkill terminology. There is no
> > SOFT_BLOCKED as I have no ability to turn individual radios on/off
> > in software.
> 
> Whatever WLAN driver you use (which is not your Fujitsu Lifebook
> platform driver) should just get complete rfkill support, and Network
> Manager and wpa_supplicant have to do nonbraindamaged things when the
> radio is rfkilled.  So let's ignore it.
> 
> Just to make a point clear, you CAN ask HAL people to provide an OSD
> notification keyed on uevents sent by rfkill-input.  It is completely
> correct to say "Radio kill switch active" and "Radio kill switch
> inactive" from some uevents rfkill-input generates (or will generate,
> I will check if I sent the patch already).  It would still not mean
> all devices have been rfkilled, but at least it shows the truth from
> the point of view of the rfkill core and that has a higher chance of
> being true than keying OSD on input events that nobody might be
> listening to.
> 
> I hope the above takes care of the "I want user feedback when the
> rfkill switch changes state" side.  That leaves your question about
> attaching rfkill classes to phantom BT and WWAN devices inside your
> platform driver.
> 
> BT and WWAN rfkilling are basically implemented in two possible ways,
> AFAIK:
> 
> WARNING: THE STUFF BELOW IS FOR PLATFORM DRIVERS, NOT NETWORK DEVICE
> DRIVERS.  NETWORK DEVICE DRIVERS DO IT SLIGHTLY DIFFERENT.
> 
> 1. rfkill actualy is/looks like a hotplug/hotunplug operation
> 
>   1a. You can do it at will (or you can do it at will except when the
> hardware switch is enforcing that they remain rfkilled):
> 
>       Attach rfkill classes to platform devices if you know this is
>       the best way to software-command this functionality.
> 
>       Most notebooks go here for Bluetooth and WWAN.  It is a pity
>       Fujitsu Lifebooks don't.
> 
>   1b. You cannot do it at will
> 
>       Attaching it to the rfkill core simply is not supported, and
>       even if you force the issue with a weird toggle_radio(), you'd
>       end up with a device that causes annoying behaviour every time
>       you want to change its rfkill state.  So, I cannot recommend
>       it.
> 
>       The user knows if the radios are around or not from whatever
>       hotplug subsystem they are tied to (PCI, USB), and that's what
>       should be issuing events the user can see (only they will be of
>       the "hardware connected/disconnected" sort, and not of the
>       "radio killed" sort.
> 
> 2. rfkill doesn't mess with the device existence, it just disables
> energy output:
> 
>   2a. You can do it at will (or you can do it at will except when the
> hardware switch is enforcing that they remain rfkilled):
> 
>       You attach it to the rfkill core using a rfkill class, unless
>       there is a better place to do it.  Usually, there isn't.
> 
>       This is rare, as BT and WWAN are usually of type 1a, and WLAN
>       is usually of type 2b.
> 
>   2b. You cannot do it at will
> 
>       The rfkill class is to be attached to the device driver for that
>       device, i.e. something in the bluetooth subsystem, USB subsystem
>       or a wireless network driver.
> 
> > Should I be creating individual Bluetooth/WLAN/WWAN rfkills that flip
> > between HARD_BLOCKED & UNBLOCKED with force status and return failure
> > for a radio state change attempt?
> 
> Like I said, that's probably quite not nice for the user, and might
> cause very annoying behaviour on userspace applications.  The rfkill
> core won't care for it either, but it won't break.
> 
> However do NOT do it for WLAN.  Almost every WLAN device knows quite
> well if it is being rfkilled or not by a hardware rfkill line, and it
> is their business to report it.  And the wireless network drivers are
> being ported to connect to the rfkill core.
> 
> > But perhaps code talks, let me just attach what I have right now. Both
> 
> Not really in this case, no.  It is not a case of coding it right,
> after all...  I will look over the input device stuff in a separate
> reply.
> 
> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
