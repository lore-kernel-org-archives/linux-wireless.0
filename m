Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:40444 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1AZJCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:02:45 -0500
Subject: Re: [PATCH 1/2] wl12xx: Enable the IEEE80211_HW_SPECTRUM_MGMT hw
 flag
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296030672.3635.13.camel@jlt3.sipsolutions.net>
References: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030565-23778-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030672.3635.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 11:02:17 +0200
Message-ID: <1296032537.18570.384.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 09:31 +0100, ext Johannes Berg wrote:
> On Wed, 2011-01-26 at 10:29 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > +		IEEE80211_HW_SPECTRUM_MGMT;
> 
> I once had a patch to remove this flag completely since it has very
> little effect at all on mac80211. Can I convince you to review the flag
> use in mac80211 and tell me why you think it is, or not, present?
> 
> johannes

Well I guess I'm stating the obvious here. The effects of the flag are:

- It causes mac80211 to add the spectrum mgmt capability bit, list of
supported channels and TX power capability info into the assoc-req
- It causes mac80211 to process channel switch actions
- It causes mac80211 to process and react to TPC power constraint
elements sent out in beacons
- It causes mac80211 to respond to TPC report requests by the AP, albeit
currently only by refusing them.

In addition to this, I plan to implement the TPC basic reporting,
including mac80211 stuff if required (I still need to learn some more on
the subject, specifically regarding the wl12xx chipset) and also I plan
to implement quieting, though it's likely that wont need mac80211
intervention with wl12xx at least.

AFAIK all these items are mandatory on the 5GHz band, at least in
Europe.

So I don't see how this flag could be removed. Unless you wan't to make
the above default behavior - but then adding for instance the spectrum
mgmt bit into the capabilities assumes all chipset will be able handle
all of the features?

-Juuso

-Juuso

