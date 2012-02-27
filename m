Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2B0Li5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 06:38:57 -0500
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Paul Stewart <pstew@chromium.org>, linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>
In-Reply-To: <20120227113212.GA4576@w1.fi>
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	 <1330254954.4401.9.camel@jlt3.sipsolutions.net>
	 <1330255537.4401.10.camel@jlt3.sipsolutions.net>
	 <1330338898.3483.10.camel@jlt3.sipsolutions.net>
	 <20120227113212.GA4576@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 12:38:50 +0100
Message-ID: <1330342730.3483.34.camel@jlt3.sipsolutions.net> (sfid-20120227_123900_716063_0D66AEC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 13:32 +0200, Jouni Malinen wrote:
> On Mon, Feb 27, 2012 at 11:34:58AM +0100, Johannes Berg wrote:
> > Come to think of it, we could also simply configure the channel to be
> > the right HT channel during auth, and then still associate as a non-HT
> > station later. I realise this isn't the best configuration, but given
> > that this is a corner case (TKIP used on an HT AP!) I think we can live
> > with that.
> 
> In general, it should be fine to enable HT/HT40 configuration for
> receive and just make sure we never transmit using parameters not
> allowed by regulatory or something like HT+TKIP rules. 

Right, this would be setting the configuration for receive -- in a way.
Remember that we're not telling the AP that we're an HT station (we
don't send HT IEs) so traffic to us still wouldn't be transmitted as HT.
Which is really what we want, since we don't want to suddenly find that
we're being sent TKIP HT frames.

> However, there
> could be some hardware/firmware designs that would refuse HT+TKIP at
> lower layer, so skipping the channel (re-)configuration could
> potentially cause some problems. I'm not aware of any specific example
> of this, though, so I can only speculate that such a thing could exist.

That's a good point, but I don't really think is likely to exist. I can
see this in a full-MAC scenario, but there you get all the relevant
parameters in the nl80211 connect() call so can do the right choices
earlier than mac80211 can with auth/assoc calls.

Of course, if this we actually happen to come across a device that needs
this it could set a flag somehwere and mac80211 could re-configure the
channel to non-HT on the assoc request, but right now I'd rather not
worry about that since we're moving towards multi-channel and have no
indication of such devices existing. Agree?

johannes

