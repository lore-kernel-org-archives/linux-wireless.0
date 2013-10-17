Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3JQOdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:33:21 -0400
Message-ID: <1382020397.14410.9.camel@jlt4.sipsolutions.net> (sfid-20131017_163328_835511_47D2022F)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 16:33:17 +0200
In-Reply-To: <1381830012.3711.50.camel@djensen-laptop>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
	 <1381506302.3711.10.camel@djensen-laptop>
	 <1381752176.13092.10.camel@jlt4.sipsolutions.net>
	 <1381752976.3711.14.camel@djensen-laptop>
	 <1381759370.13092.11.camel@jlt4.sipsolutions.net>
	 <1381762681.3711.36.camel@djensen-laptop>
	 <1381763193.13092.19.camel@jlt4.sipsolutions.net>
	 <1381830012.3711.50.camel@djensen-laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-15 at 11:40 +0200, Dennis H Jensen wrote:

> > Yes, but then before 5910 would have been channel 182. Now you're making
> > it channel 197. That doesn't really make sense at all.
> 
> OK, fair enough, but the fact is that there is a hole in the frequencies
> that were added in 802.11p.

802.11p ... yeah, that's an issue.

> > > In case that doesn't do it. What is needed to get channel 182 to be 5910
> > > MHz as Annex E defines for the US and Europe? Channel to frequency
> > > mapping based on operating class?
> > 
> > Annex E is the 802.11 spec, to get something into that ...
> 
> You misunderstood me; the European operating class 14, for example,
> states that channel 182 is to be 5910.

That's a 10MHz channel only.

In any case, I don't see a good way out. Pretending that the channel
number is something else like you did in this patch is clearly wrong and
will obviously lead to interoperability issues.

I think we need to actually start taking the operating class (or maybe
just the starting frequency) into account in the kernel. How we do that
I don't really know.

johannes

