Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41732 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaJFOwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:52:16 -0400
Message-ID: <1412607134.3098.25.camel@jlt4.sipsolutions.net> (sfid-20141006_165219_517209_80C50D65)
Subject: Re: [PATCH v6 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 16:52:14 +0200
In-Reply-To: <20140916234647.GA2238@sesse.net>
References: <20140903133328.GC18933@sesse.net>
	 <E1XPB2h-0008WO-MS@pannekake.samfundet.no>
	 <1410166400.7983.9.camel@jlt4.sipsolutions.net>
	 <20140916234647.GA2238@sesse.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-17 at 01:47 +0200, Steinar H. Gunderson wrote:
> On Mon, Sep 08, 2014 at 10:53:20AM +0200, Johannes Berg wrote:
> >> Linux already supports 802.11h, where the access point can tell the
> >> client to reduce its transmission power. However, 802.11h is only
> >> defined for 5 GHz, where the need for this is much smaller than on
> >> 2.4 GHz.
> >> 
> >> Cisco has their own solution, called DTPC (Dynamic Transmit Power
> >> Control). Cisco APs on a controller sometimes but not always send
> >> 802.11h; they always send DTPC, even on 2.4 GHz. This patch adds support
> >> for parsing and honoring the DTPC IE in addition to the 802.11h
> >> element (they do not always contain the same limits, so both must
> >> be honored); the format is not documented, but very simple.
> >> 
> >> Tested (on top of wireless.git and on 3.16.1) against a Cisco Aironet
> >> 1142 joined to a Cisco 2504 WLC, by setting various transmit power
> >> levels for the given access points and observing the results.
> >> The Wireshark 802.11 dissector agrees with the interpretation of the
> >> element, except for negative numbers, which seem to never happen
> >> anyway.
> > Applied both.
> 
> I found what I believe is an edge case: What happens if the element suddenly
> goes away from one beacon to another? Shouldn't there be a reset of the power
> level and then a new call to __ieee80211_recalc_txpower()?
> 
> (If so, I believe this bug was already present in the code before my first
> patch, as I understand the existing logic.)

I'm not sure it's worth worrying about, but if you want to write a patch
I'd take it :)

johannes

