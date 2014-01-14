Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaANQcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:32:32 -0500
Message-ID: <1389717148.32635.18.camel@jlt4.sipsolutions.net> (sfid-20140114_173236_123050_BF398E45)
Subject: Re: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:32:28 +0100
In-Reply-To: <20140107163834.GA9771@w1.fi>
References: <20140106081151.GA1613@w1.fi>
	 <1389110063.4645.21.camel@jlt4.sipsolutions.net>
	 <20140107161241.GA9092@w1.fi>
	 <1389112179.4645.37.camel@jlt4.sipsolutions.net>
	 <20140107163834.GA9771@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 18:38 +0200, Jouni Malinen wrote:

> > > P2P has a P2P Group Limit field which the GO uses to
> > > advertise in Beacon/Probe Response frames to indicate that no more P2P
> > > Clients can join the group. wpa_supplicant supports this functionality,
> > > but currently, requires user (or well, whoever is building the system)
> > > to configure the maximum limit. This is an extra complexity that could
> > > be easily avoided for cases where the driver were able to advertise the
> > > maximum number of associated stations.
> > 
> > Right, indeed. That does indicate a need for such a limit. I wonder if a
> > more dynamic approach (such as an event saying 'I just ran out of
> > space') would be preferable? But it'd obviously be far more complex, so
> > may not be worth it.
> 
> That would allow the specific (and only clearly known today, I guess)
> use case of P2P GO to be addressed. Or well, this would actually require
> even more complexity, since there would also need to be another event to
> indicate that more space become available (another operation stopped)..

Yeah, too much complexity.

> While I'm not against adding this type of functionality, I'm not sure it
> really would be worth the effort and it would be yet another alternative
> since there is already support for maximum station count in
> hostapd/wpa_supplicant even if that currently happens to depend on
> manual configuration. The case of add-sta failing will obviously need to
> be supported cleanly, so we (or well, I at least ;-) are pretty much
> stuck with having at least those two.. Adding a third one sounds a bit
> much.

I agree. I think this patch is fine, but I'd like to see this documented
with the slightly relaxed semantics, i.e. documenting that it is fine in
practice to set this a bit too high where it can't be known or station
entries are shared. Given that is actually OK, of course, which I think
we said it would be.

johannes

