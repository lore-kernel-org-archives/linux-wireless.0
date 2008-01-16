Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2664 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYAPUYW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 15:24:22 -0500
Date: Wed, 16 Jan 2008 15:01:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: led support in mac80211 and drivers
Message-ID: <20080116200126.GA3164@tuxdriver.com> (sfid-20080116_202428_768975_7B04F6BA)
References: <478DF297.9020904@dbservice.com> <1ba2fa240801160832g611d5763gcb3d681353019d4f@mail.gmail.com> <478E465A.2030003@dbservice.com> <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I appreciate that this topic started with discussion of the (long
overdue) support for LEDs in the iwlwifi drivers.  However at
this point I think it has strayed sufficiently into the mac80211
realm that it should be moved to the home of mac80211 development,
linux-wireless@vger.kernel.org

Thanks,

John

On Wed, Jan 16, 2008 at 08:38:48PM +0200, Tomas Winkler wrote:
> > > Currently we recognize 4 or 5 pasterns that are implemented and
> > > switching between them according laptop vendor.
> >
> > We = who?
> 
> Intel
> 
> Greping through the kernel source revealed only a single user
> > of ieee80211_get_*_led_name(), the broadcom B43 wireless driver.
> 
> Correct
> 
> That
> > driver switches between different modes based on bus->boardinfo.vendor.
> > But where are the other modules needing this flexibility? Are they being
> > developed in private by the companies that make the access points?
> >
> 
> Different Laptop vendor and AP vendors. This information might be
> written in many places, PCI subvendor, in EEROM etc sometimes it has
> to be supplied from outside.
> 
> 
> > > So what is needed for led implementation are 3 decision chain
> > >  - Activity Trigger (RX, TX, Association, Radio State/RF Kill)
> > >  - Behavior Decision -  What is done on each trigger
> > >     - Behavior is easy to model - ON, OFF, BLINK(pattern)
> > >  - Mapping to what led is this behavior mapped
> > >     - One behavior might be mapped to single led. Then we need to know
> > > what trigger take precedences.
> >
> > Actually, the second and third point can be merged.
> >
> 
> Agree Implementation wise might be simpler.
> 
> > > Actually the major problem I have currently with mac80211 trigger
> > > implementation RX/TX trigger since Intel's led doesn't have to be
> > > triggered ON/OFF on each packet, led is capable of blinking itself.,
> > > therefore I would like to see your patch very much. We probably would
> > > have to work on flexibility of blinking patterns
> >
> > I thought about having an 'ieee80211_activity_listener' that could
> > subscribe to activity events of a ieee80211_hw device. One single
> > callback that would be called when there's activity or if the state of
> > the device has changed. Maybe something like this:
> >
> > int (*callback)(... *hw, u8 state, u8 type);
> >
> > where 'state' would be a bitmap of scanning/associated/etc and type the
> > 'type' of activity (transmitting/receiving a frame). The callback then
> > would decide which leds to activate and how (blinking or not etc). Does
> > that sound better? At least it would be better than having to register
> > three leds in each low-level driver ;)
> 
> I'm not sure it's such big deal to subscribe to led more problem is
> that I cannot subscribe same led to different triggers
> so need another level
> mac80211     | driver
> Led Trigger ->| Logical Led -> (LED LOGIC/MAPPING) ->  HW LED
>                     |
> 
> The problem here is that logic is already defined in Led pattern is
> already defined int Led Trigger
> 
> Problem with your approach I cannot reach LEDs that are not connected
> to NIC's PCIe pins.
> 
> Other options that uses your idea is
> mac80211        |  driver
> mac callback ->| (LED LOGIC) - Led Trigger - > Led
> 
> 
> > Btw, is there a function that lists all 'struct ieee80211_hw *'? How
> > does the led driver (external driver, where the leds are on a different
> > bus and the driver implemented in a different kernel module) get the led
> > triggers?
> 
> by name - "wlan0:rx"  for example
> 
> > Oh, and I read (in the intel driver source) that there is no callback
> > from the low-level driver into the mac subsystem that would inform it
> > that rfkill is active... that limitation would be bad in case of the
> > external led drivers.
> >
> That's a gap.
> 
> > tom
> >
> >
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel

-- 
John W. Linville
linville@tuxdriver.com
