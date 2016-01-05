Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38404 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbcAEQbx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:31:53 -0500
Message-ID: <1452011509.12357.51.camel@sipsolutions.net> (sfid-20160105_173156_400973_675EAADC)
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 17:31:49 +0100
In-Reply-To: <568B91D6.6080404@broadcom.com>
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
		 <1450959550-19655-2-git-send-email-arend@broadcom.com>
	 <1451985926.12357.16.camel@sipsolutions.net>
	 <568B91D6.6080404@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 10:50 +0100, Arend van Spriel wrote:

> > > +struct cfg80211_bss_selection {
> > > +> 	> bool present;
> > > +> 	> enum nl80211_band pref_band;
> > > +> 	> u8 rssi_adjust;
> > > +> 	> bool ignore_rssi;
> > > +};
> > 
> > Hm. Isn't it possible to specify *some* parameters of these? Or at
> > least, in the future (if we extend this), it would be?
> > 
> > Seems that 'present' might want to be a bitmap or so? Or perhaps be
> > done by using invalid values by default (e.g. NUM_BANDS for no band
> > preference, etc.)?
> 
> Ok. I was not sure how to go about this. Our firmware uses an ordered
> list of selection "keys" with the first being the primary selection
> key and so on. So there are three "key" types: band, rssi, and
> rssi_adjust. 
> The latter is not really a selection key, but will do rssi adjustment
> for BSSes in the specified band.

Ok.

> One of the questions I have is whether the order of a nested list 
> attribute is retained.

It is if you parse it right, but it's not typically something that we
rely on and take advantage of, so I wouldn't want to do it that way.
Also, I'm not really sure it'd really be what we wanted to do anyway?

It seems though that we might need to allow for other drivers having
other selection criteria, and having a validity flag for each? That
could go some of the way.

To really fully replicate your firmware's capabilities seems difficult,
though I also don't really see much point, or are you saying you could
put "rssi" first? But the way you described it in nl80211, with "band"
being a "tie breaker", it sounds like really "rssi" comes first,
usually, followed by rssi_adjust and band?

The other way - band first - could also be done with a huge rssi_adjust
though (as I said before), so I don't really see much value in having
all this complexity to start with?

> Ok. Will elaborate. In follow-up email I raise question whether this 
> could/should be a signed value. Any opinion on this?

I didn't see that, but yeah - good question. Would it be supported by
firmware?

But logically - does it even make sense? If you already prefer that
band, why give it a boost still? Just disable RSSI? Hmm.


johannes
