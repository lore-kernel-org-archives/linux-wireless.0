Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbZERPff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:35:35 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <1242478137.10005.63.camel@johannes.local>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <200905151011.50915.hs4233@mail.mn-solutions.de>
	 <1242429353.10933.32.camel@localhost.localdomain>
	 <1242478137.10005.63.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 18 May 2009 11:35:24 -0400
Message-Id: <1242660924.6530.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-16 at 14:48 +0200, Johannes Berg wrote:
> On Fri, 2009-05-15 at 19:15 -0400, Dan Williams wrote:
> 
> > Well, what does "background scan" mean?  mac80211 will obviously accept
> > beacons from APs on the same channel and happily add them to the scan
> > list.
> 
> Only if powersave/beacon filtering isn't enabled. Actually, mac80211
> does beacon filtering itself now, so I don't think this happens any more
> (I did that on purpose so people don't really rely on the former
> behaviour)
> 
> > But a background scan would imply that the card itself is taking
> > over the decision about when to jump around and scan, basically the same
> > thing NM is doing, right?  When would the card/stack decided to
> > background scan, and what channels would it background scan on?  If it
> > doesn't do more or less all passive channels, then it wouldn't be that
> > useful for figuring out the site survey data.
> 
> I would think that mac80211, while asked to scan when associated, could
> simply do something like calculating how long it can go off-channel
> under the current QoS requirements, and then go off-channel for that,
> wait for the next on-channel beacon and some traffic, scan the next
> channel(s) again etc.

Yeah, that sounds like it would work.

Dan

