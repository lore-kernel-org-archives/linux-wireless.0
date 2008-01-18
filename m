Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.227]:55165 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYARD4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 22:56:08 -0500
Received: by hu-out-0506.google.com with SMTP id 19so245844hue.21
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 19:56:04 -0800 (PST)
Message-ID: <9f50a7a00801171956l3bdc2ccas3dc37534744e669@mail.gmail.com> (sfid-20080118_035614_371287_E6DAD465)
Date: Thu, 17 Jan 2008 21:56:04 -0600
From: "Jerone Young" <jerone@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [ipw3945-devel] led support in mac80211 and drivers
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240801171635t50f3f267o6f7ba5e4dc31cf48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <478DF297.9020904@dbservice.com>
	 <20080116200126.GA3164@tuxdriver.com>
	 <1200584782.8007.59.camel@johannes.berg>
	 <200801172313.00246.mb@bu3sch.de>
	 <1ba2fa240801171635t50f3f267o6f7ba5e4dc31cf48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes I see this more as a stop gap solution. The fact is that there is
a lot of contengency on how the light blinks (and it's
understandable). But the feature is so far over due that at this point
it's best to have something so the user can know that wireless is on
or off.

On Jan 17, 2008 6:35 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Jan 18, 2008 12:12 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Thursday 17 January 2008 16:46:22 Johannes Berg wrote:
> > > > > > > Actually the major problem I have currently with mac80211 trigger
> > > > > > > implementation RX/TX trigger since Intel's led doesn't have to be
> > > > > > > triggered ON/OFF on each packet, led is capable of blinking itself.,
> > >
> > > I'm wondering if this shouldn't simply be a driver decision and mac80211
> > > exports an RXon LED that is always "on" for as long as receive is
> > > running (whatever that means, please specify!)
> >
> > I read this thread multiple times, but I don't get where the problem is.
> > Why don't you simply implement this in the driver:
> > When LED didn't change software state for X jiffies, switch the auto-blinking
> > LED in the hardware off. Switch it on if it's off in hardware and there's
> > a software state transition.
> > Where's the problem? This is trivial to implement.
>
> Sure it's simple, even there are few implementations already in the
> mailing list.. just still missing the flexibility I seek.
> Tomas
>
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
