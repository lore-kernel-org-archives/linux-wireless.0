Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:39939 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1AZJRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:17:40 -0500
Subject: Re: [PATCH 1/2] wl12xx: Enable the IEEE80211_HW_SPECTRUM_MGMT hw
 flag
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296032659.3635.29.camel@jlt3.sipsolutions.net>
References: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030565-23778-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030672.3635.13.camel@jlt3.sipsolutions.net>
	 <1296032537.18570.384.camel@wimaxnb.nmp.nokia.com>
	 <1296032659.3635.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 11:17:16 +0200
Message-ID: <1296033436.18570.391.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 10:04 +0100, ext Johannes Berg wrote:
> On Wed, 2011-01-26 at 11:02 +0200, Juuso Oikarinen wrote:
> 
> > Well I guess I'm stating the obvious here. The effects of the flag are:
> > 
> > - It causes mac80211 to add the spectrum mgmt capability bit, list of
> > supported channels and TX power capability info into the assoc-req
> > - It causes mac80211 to process channel switch actions
> > - It causes mac80211 to process and react to TPC power constraint
> > elements sent out in beacons
> > - It causes mac80211 to respond to TPC report requests by the AP, albeit
> > currently only by refusing them.
> 
> Right. But all of this is generic, no? Except maybe TPC?
> 
> > In addition to this, I plan to implement the TPC basic reporting,
> > including mac80211 stuff if required (I still need to learn some more on
> > the subject, specifically regarding the wl12xx chipset) and also I plan
> > to implement quieting, though it's likely that wont need mac80211
> > intervention with wl12xx at least.
> > 
> > AFAIK all these items are mandatory on the 5GHz band, at least in
> > Europe.
> > 
> > So I don't see how this flag could be removed. Unless you wan't to make
> > the above default behavior - but then adding for instance the spectrum
> > mgmt bit into the capabilities assumes all chipset will be able handle
> > all of the features?
> 
> Yeah, I was thinking those should be default, and the actual TPC
> reporting would of course depend on hardware features? But then again
> maybe TPC itself isn't necessarily implemented by drivers since not all
> drivers implement setting the power correctly.

This *is* mandatory stuff, so in that perspective I guess it would make
sense to remove the flag and make all of this default behavior. Indeed
the mac80211 could be made to refuse the TCP basic reports unless the
driver provides a call-back for that or sth like that.

Also, I guess it would be a valid assumption all drivers supporting the
5GHz band would also support setting the TX power - otherwise they will
possibly violate regulations anyway - whether they say they state or not
they have the specturm mgmt capability makes little difference.

As I mentioned, I plan to implement basic reporting once I find out how
to do that - so I will be reviewing this functionality some more later.
Maybe, if you like, I can consider removing the flag at that point?

-Juuso


> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


