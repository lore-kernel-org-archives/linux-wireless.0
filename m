Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1AIJeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 04:34:04 -0500
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D2797D2.6000002@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
	 <1294397880.3467.1.camel@jlt3.sipsolutions.net>
	 <4D275CCC.90905@candelatech.com>  <20110107200913.GF21588@tux>
	 <1294432018.2709.2.camel@edumazet-laptop>
	 <4D2791BD.7050502@candelatech.com>
	 <1294439171.2709.6.camel@edumazet-laptop>
	 <4D2797D2.6000002@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Jan 2011 10:34:00 +0100
Message-ID: <1294565640.3469.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-07 at 14:46 -0800, Ben Greear wrote:
> On 01/07/2011 02:26 PM, Eric Dumazet wrote:
> > Le vendredi 07 janvier 2011 à 14:20 -0800, Ben Greear a écrit :
> >> On 0
> >>> Using skb_copy() is wrong then, since it makes a copy (order-1
> >>> allocations)
> >>>
> >>> It should use :
> >>>    skb_alloc( actual_size_of_frame  not the 3840 thing ...)
> >>>    copy(data)
> >>
> >> We need the extra stuff copied too I think (like skb->cb).
> >>
> >> If you could provide a bit more complete example code, I'll be happy
> >> to test it...
> >
> > take a random drivers/net using copybreak ... say ... tg3.c
> >
> > lines 4785
> >
> > len = length_of_the_current_frame
> > copy_skb = netdev_alloc_skb(...,  len);
> > // allocates exact required size not a byte more....
> > ...
> > skb_copy_from_linear_data(skb, copy_skb->data, len);
> > ...
> > skb_put(skb, len);
> > ...
> 
> That seems fine for drivers, but I'm guessing something different
> would be needed in the mac80211/rx.c code:
> 
> I figure doing the fix here might be a nice quick fix,
> and would help with all funky drivers.  Later, can fix the
> ath9k to do the skb copying as soon as DMA is done?

This code in mac80211 that you point out will nearly never do a copy
unless you have a lot of multicast traffic. I really don't think it
makes sense to think about changing that now.

johannes

