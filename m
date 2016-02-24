Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39550 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbcBXNbn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:31:43 -0500
Message-ID: <1456320693.2050.30.camel@sipsolutions.net> (sfid-20160224_144434_677389_DACF9968)
Subject: Re: custom ioctl-based interface to control LED in networking (was
 Re: [PATCHv2 09/10] rfkill: Userspace control for airplane mode)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, j.anaszewski@samsung.com,
	linux-leds@vger.kernel.org,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Wed, 24 Feb 2016 14:31:33 +0100
In-Reply-To: <20160224121420.GA5627@amd>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
	 <1456159001-20307-10-git-send-email-jprvita@endlessm.com>
	 <20160223204525.GC16961@amd> <1456260914.9910.34.camel@sipsolutions.net>
	 <20160223214501.GA22501@amd> <1456304509.2050.15.camel@sipsolutions.net>
	 <20160224104611.GB31302@amd> <1456311697.2050.23.camel@sipsolutions.net>
	 <20160224121420.GA5627@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 13:14 +0100, Pavel Machek wrote:
> 
> Why would it need to? It could look at default triggers for the led
> if it really wanted to.

And then it needs to change them; if anything goes wrong error recovery
is practically impossible since the trigger information is lost
forever.

> > I'm sure you'd also not like to see 2**7 triggers implemented in
> > rfkill
> > to cover all the possibilities.
> 
> Are all the possibilities useful? I assumed about 2 are. If you need
> 2**7 of them, LED triggers can have parameters.

It's not my position to decide which combinations some system
integrator or userspace developer might find useful.

Even when we add parameters to a trigger (I don't see a generic way to
do that, but please do enlighten me), you're now ignoring the issue of
the userspace controlled GSM modem...

> > Really what you have here is a concept of "airplane mode", and that
> > concept is specific to the rfkill subsystem. This happens to affect
> > mostly an LED trigger, today, but as a concept it's something that
> > *should* be managed within the rfkill subsystem.
> 
> How is that concept used outside the LEDs? What semantics does
> "airplane mode" have? You tried to explain "airplane mode" is not
> well defined up in this thread...

I'd say it's well-defined for any given set of system software, so if
e.g. NetworkManager decides to define it one way, and connman another
way, there's a definition but the kernel need not interfere with it.

> > > Besides, the series really should have been Cc-ed to LED
> > > people, too.
> > 
> > That's simply unreasonable, you're essentially saying that any user
> > of any kernel infrastructure should be Cc'ed to the implementer of
> > that infrastructure... 9/10 patches in this series aren't even LED
> > specific,
> 
> I'm not saying that. I'm saying that LED maintainers should be Cced,
> to keep the interfaces consistent.

I pretty much have to read it that way, since the LED API is in no way
impacted by these changes. Here's a new trigger, with some magic inner
working. No impact on the LED API.

johannes
