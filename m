Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li674-96.members.linode.com ([212.71.239.96]:44316 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbaAGQih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:38:37 -0500
Date: Tue, 7 Jan 2014 18:38:34 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
Message-ID: <20140107163834.GA9771@w1.fi> (sfid-20140107_173840_577509_28203B85)
References: <20140106081151.GA1613@w1.fi>
 <1389110063.4645.21.camel@jlt4.sipsolutions.net>
 <20140107161241.GA9092@w1.fi>
 <1389112179.4645.37.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389112179.4645.37.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 07, 2014 at 05:29:39PM +0100, Johannes Berg wrote:
> Is such a limit advertised anywhere?

Yes, below..

> I can't think of a reason why a
> static limit would be superior to a dynamic one? Maybe if we'd want to
> restrict it to 8 to have enough station entries for the other use cases,
> but then we could do that in the code as well?

It is not really that much of a static vs. dynamic, but more so about
being able to advertise this before a station tries to start association
(which, for some P2P devices, may mean having to drop another
connection).

> Anyway, I'm not really objecting much to this, I'm just not convinced
> it's sufficient, and if we need a more dynamic mechanism anyway I'm not
> sure it really buys us much.

Like I said, I think both will be needed.

> > P2P has a P2P Group Limit field which the GO uses to
> > advertise in Beacon/Probe Response frames to indicate that no more P2P
> > Clients can join the group. wpa_supplicant supports this functionality,
> > but currently, requires user (or well, whoever is building the system)
> > to configure the maximum limit. This is an extra complexity that could
> > be easily avoided for cases where the driver were able to advertise the
> > maximum number of associated stations.
> 
> Right, indeed. That does indicate a need for such a limit. I wonder if a
> more dynamic approach (such as an event saying 'I just ran out of
> space') would be preferable? But it'd obviously be far more complex, so
> may not be worth it.

That would allow the specific (and only clearly known today, I guess)
use case of P2P GO to be addressed. Or well, this would actually require
even more complexity, since there would also need to be another event to
indicate that more space become available (another operation stopped)..
While I'm not against adding this type of functionality, I'm not sure it
really would be worth the effort and it would be yet another alternative
since there is already support for maximum station count in
hostapd/wpa_supplicant even if that currently happens to depend on
manual configuration. The case of add-sta failing will obviously need to
be supported cleanly, so we (or well, I at least ;-) are pretty much
stuck with having at least those two.. Adding a third one sounds a bit
much.

-- 
Jouni Malinen                                            PGP id EFC895FA
