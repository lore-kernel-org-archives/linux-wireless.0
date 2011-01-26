Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1AZJEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:04:23 -0500
Subject: Re: [PATCH 1/2] wl12xx: Enable the IEEE80211_HW_SPECTRUM_MGMT hw
 flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296032537.18570.384.camel@wimaxnb.nmp.nokia.com>
References: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030565-23778-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1296030672.3635.13.camel@jlt3.sipsolutions.net>
	 <1296032537.18570.384.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 10:04:19 +0100
Message-ID: <1296032659.3635.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 11:02 +0200, Juuso Oikarinen wrote:

> Well I guess I'm stating the obvious here. The effects of the flag are:
> 
> - It causes mac80211 to add the spectrum mgmt capability bit, list of
> supported channels and TX power capability info into the assoc-req
> - It causes mac80211 to process channel switch actions
> - It causes mac80211 to process and react to TPC power constraint
> elements sent out in beacons
> - It causes mac80211 to respond to TPC report requests by the AP, albeit
> currently only by refusing them.

Right. But all of this is generic, no? Except maybe TPC?

> In addition to this, I plan to implement the TPC basic reporting,
> including mac80211 stuff if required (I still need to learn some more on
> the subject, specifically regarding the wl12xx chipset) and also I plan
> to implement quieting, though it's likely that wont need mac80211
> intervention with wl12xx at least.
> 
> AFAIK all these items are mandatory on the 5GHz band, at least in
> Europe.
> 
> So I don't see how this flag could be removed. Unless you wan't to make
> the above default behavior - but then adding for instance the spectrum
> mgmt bit into the capabilities assumes all chipset will be able handle
> all of the features?

Yeah, I was thinking those should be default, and the actual TPC
reporting would of course depend on hardware features? But then again
maybe TPC itself isn't necessarily implemented by drivers since not all
drivers implement setting the power correctly.

johannes

