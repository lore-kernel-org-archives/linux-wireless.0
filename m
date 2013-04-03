Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473Ab3DCNm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:42:28 -0400
Message-ID: <1364996543.8351.42.camel@jlt4.sipsolutions.net> (sfid-20130403_154244_571506_1D50908D)
Subject: Re: RFC:  Hashing by VIF addr for rx of data packets.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 03 Apr 2013 15:42:23 +0200
In-Reply-To: <515C308F.7030506@candelatech.com>
References: <515B6D98.4060303@candelatech.com>
	  (sfid-20130403_014533_732333_9EEA2246) <1364993169.8351.34.camel@jlt4.sipsolutions.net>
	 <515C308F.7030506@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-03 at 06:37 -0700, Ben Greear wrote:
> > Hmmm. I'm not really convinced this will make sense upstream. I'm kinda
> > fine with the single-station cache, but maintaining a whole other hash
> > table seems too much overhead for every use case but yours.
> 
> Yeah, aside from multiple stations, I'm not sure it helps anything.  It would
> require a different scheme to help with multiple VAP I think, and I'm not
> sure there are any other multi-vif use cases out there...

Yes, likely.

> >> +		if (!is_multicast_ether_addr(hdr->addr1)) {
> >> +			sta = sta_info_get_by_vif(local, hdr->addr1);
> >
> > AFAICT, this is also wrong for TDLS and other cases where we might
> > receive a frame that's not from the AP, even if it's only by accident or
> > from an attacker.
> 
> I think patch is probably wrong for any VIF that can be associated with more than
> one station (such as APs).  I'm going to re-work the vhash to only include
> Station VIFS and see how that works for my test case.

Well it's wrong even as is, even with just a single station on that VIF,
because as far as I can tell it assumes that *any* frame, no matter who
it came from, was from that station.

johannes

