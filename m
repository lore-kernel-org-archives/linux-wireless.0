Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51879 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366AbbGQJKB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:10:01 -0400
Message-ID: <1437124199.1933.6.camel@sipsolutions.net> (sfid-20150717_111008_750218_CA1695C5)
Subject: Re: [PATCH] mac80211: don't clear all tx flags when requeing
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 11:09:59 +0200
In-Reply-To: <1437124038.1933.4.camel@sipsolutions.net> (sfid-20150717_110753_137870_576AC4E6)
References: <1435823996-32510-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150702_100018_000929_8F93B7A2) <1437123955.1933.3.camel@sipsolutions.net>
	 (sfid-20150717_110614_486475_B0C53BCA) <1437124038.1933.4.camel@sipsolutions.net>
	 (sfid-20150717_110753_137870_576AC4E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-17 at 11:07 +0200, Johannes Berg wrote:
> 
> > > Once (a) is not stripped (b) becomes important
> > > because it's the main condition to clear the
> > > Service Period bit of the station when Tx status
> > > for the released frame is reported back.
> > > 
> > > This problem was observed with ath9k acting as P2P
> > > GO in some testing scenarios but isn't limited to
> > > it. AP operation with mac80211 based Tx A-MPDU
> > > control combined with clients using PS-Poll frames
> > > is subject to this race.
> > 
> > I'm not sure I quite understand - how is the aggregation teardown
> > causing frame filtering?
> > 
> 
> Never mind, I was looking at the wrong code. I'll apply this.
> 

However, I'd like to ask you to look at this again - I can see how it
fixes the problem now, but it seems like a fairly unreliable fix since
the frame is sent through TX processing again, and you're relying on
that preserving a flag that's otherwise marked temporary...

So I think it may be better to adjust the station flags in this case to
let a new (the same) frame be the ps-poll response again.

johannes
