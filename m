Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:51710 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYAQQkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 11:40:35 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1171475wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 08:40:34 -0800 (PST)
Message-ID: <1ba2fa240801170840i10c6bc9fp24eebbe1110df93@mail.gmail.com> (sfid-20080117_165334_779439_CF003333)
Date: Thu, 17 Jan 2008 18:40:34 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: led support in mac80211 and drivers
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Tomas Carnecky" <tom@dbservice.com>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1200584782.8007.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <478DF297.9020904@dbservice.com>
	 <1ba2fa240801160832g611d5763gcb3d681353019d4f@mail.gmail.com>
	 <478E465A.2030003@dbservice.com>
	 <1ba2fa240801161038t235f9ae4m3b1f7e1963b592ef@mail.gmail.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 <1200584782.8007.59.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 17, 2008 5:46 PM, Johannes Berg <johannes@sipsolutions.net> wrote:

> I'm wondering if this shouldn't simply be a driver decision and mac80211
> exports an RXon LED that is always "on" for as long as receive is
> running (whatever that means, please specify!)

What we do is translate throughputs  - to  8 patterns if I remember correctly.
Only when the throughput  cross threshold level NIC is disturbed with
changing blinking pattern.

> Or you need to define blink patterns with the core LED framework.

Not for traffic but for example some laptops vendors wants slow blink
in unassociated state some wants led to be off.

The problem is that led behavior in clean design would be defined by
trigger. So I would prefer to put flexibility of LED behavior in that
level.

> > > > >  - Mapping to what led is this behavior mapped
>
> That's trivially specified in sysfs. b43 (since it was mentioned
> already) has some special logic to set up defaults coming from EEPROM.
>
> > > > >     - One behavior might be mapped to single led. Then we need to know
> > > > > what trigger take precedences.
>
> That (multiple behaviours on a single LED) is impossible in the current
> LED framework.

Most of todays laptop has only one led for Wifi that's a problem.

> > > > I thought about having an 'ieee80211_activity_listener' that could
> > > > subscribe to activity events of a ieee80211_hw device. One single
> > > > callback that would be called when there's activity or if the state of
> > > > the device has changed. Maybe something like this:
> > > >
> > > > int (*callback)(... *hw, u8 state, u8 type);
> > > >
> > > > where 'state' would be a bitmap of scanning/associated/etc and type the
> > > > 'type' of activity (transmitting/receiving a frame). The callback then
> > > > would decide which leds to activate and how (blinking or not etc). Does
> > > > that sound better? At least it would be better than having to register
> > > > three leds in each low-level driver ;)
>
> No, that sounds like a bad idea. We actually want the flexibility here,
> I could for example use the front LED on my powerbook as a wireless
> association LED if I wanted. We want to use the LED framework and if
> that means three LEDs in your driver then so be it.

I agree it  has a lot of benefits to use LED framework, but it can be
pushed to driver or some module. Unfortunately I'm not sure myself

Tomas

> johannes
>
