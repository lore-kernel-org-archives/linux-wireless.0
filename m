Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab0G1TMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 15:12:37 -0400
Subject: Re: [BUG] after starting wimaxd at boot iwlagn module will crash
 for intel 6250 card
From: Dan Williams <dcbw@redhat.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: alexxy@gentoo.org, linux-wireless@vger.kernel.org,
	wimax@linuxwimax.org
In-Reply-To: <1280341422.26204.307.camel@localhost.localdomain>
References: <201007280028.48674.alexxy@gentoo.org>
	 <1280270313.26204.288.camel@localhost.localdomain>
	 <201007282154.06383.alexxy@gentoo.org>
	 <1280340597.26204.300.camel@localhost.localdomain>
	 <1280341422.26204.307.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 14:14:05 -0700
Message-ID: <1280351645.2700.8.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 11:23 -0700, Inaky Perez-Gonzalez wrote:
> On Wed, 2010-07-28 at 11:09 -0700, Inaky Perez-Gonzalez wrote: 
> > Hi Alexey
> > 
> > On Wed, 2010-07-28 at 21:53 +0400, Alexey Shvetsov wrote: 
> > > Updated relevant part of logs for this bug
> > > 
> 
> On the other side, I just went through the huge log file you sent me --
> thx for that.
> 
> I don't see any i2400m errors in there -- the driver seems to at least
> be able to initialize right. WiFi's iwlagn gets toasted, but i2400m is
> not really complaining about anything -- except when NetworkManager
> seemingly tries to turn on/off the radio and a message about it being
> done while the device is not in the right state is popping up:

Stock NM actually doesn't poke rfkill for any device type yet.  It
listens for killswitch changes, but it doesn't modify the switch state
at all.  It will set the wifi device !IFF_UP though.  At some point
we'll hook up rfkill to the "Wireless Enabled" checkbox, but rfkill is
such a tangled mess that it takes a bit of work to get the user
interaction right.

(there are platform and hardware switches, and sometimes the platform
switches control the hard/soft block on the hardware switches.
sometimes they don't.  and you can't really tell.  so you have to loop
through all switches, try turning them all off, and if any one fails to
turn off then you go through again until all of them turn off or until
it fails.  but you can't tell it might fail before you try...)

> ... 
> kernel: iwlagn 0000:02:00.0: RF_KILL bit toggled to enable radio.
> NetworkManager: <info>  WiFi now disabled by radio killswitch
> kernel: i2400m_usb 2-1.3:1.0: 'RF Control' (0x4602) command failed: -84 - invalid state (3)
> NetworkManager: <info>  (wlan0): bringing up device.
> kernel: iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting
> ...
> 
> I say seemingly because I don't remember NetworkManager actually doing
> that on WiMAX devices, but I could be wrong, as they expose an RFKILL
> interface.

NM doesn't do anything yet with wimax devices, though it'll look for
wimax killswitches.  But nothing is done with them yet upstream.

So I guess my question here is whether Alexey is using a stock NM or a
distro-patched one.  Ubuntu used to patch NM to actually poke the rfkill
bits, not sure if they still do that or not.  Fedora does not, and I
don't think Novell/SUSE does either.

Dan

> So I am the more puzzled here, I guess I need to re-establish a baseline
> to curb confusion, please help me here:
> 
> -- let's be in peace with the fact that wifi is not working at this
> point --
> 
> (1) Does WiMAX work ok when iwlagn is unloaded? can you get to turn on
> the radio and scan?
> 
> (2) Apparently the driver is up and running when iwlagn is loaded
> (according to your logs). Can you get the daemon to start? turn the
> radio on? scan?
> 
> (3) when and how do you actually get that -22 error from the i2400m
> probe?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


