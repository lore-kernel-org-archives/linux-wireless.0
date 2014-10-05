Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaJESbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2014 14:31:15 -0400
Date: Sun, 5 Oct 2014 20:28:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mark Asselstine <asselsm@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then
 driver requested
Message-ID: <20141005182835.GA8897@redhat.com> (sfid-20141005_203127_831251_1A847C13)
References: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
 <20141001091240.GA2011@redhat.com>
 <CAPuovEJtuJdRakwRhdUjRwrmkfry62wJqd8p2uJQ7L0rB7DoCA@mail.gmail.com>
 <CAPuovEJssghQv=03sn07AuYVvwULq0kSTn9kch53r+VKccy8xA@mail.gmail.com>
 <20141005131312.GA1827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141005131312.GA1827@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2014 at 03:13:12PM +0200, Stanislaw Gruszka wrote:
> On Sat, Oct 04, 2014 at 07:38:25PM -0400, Mark Asselstine wrote:
> > >> The only possibility to skb_under_panic I can see, is that we retransmit
> > >> frame and try to align it many times, but alignment should not be needed
> > >> once we aligned frame. Hence I'm not sure how those skb_under_panics can
> > >> happen.
> > 
> > I am still digging through trying to find a cause for this, without a
> > reproducer I am starting to lose hope on finding the cause.
> > 
> > I dug up this old thread
> > http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-November/002457.html
> >
> > I am thinking that the cause is an interaction with 80211mac and the
> > rt2x00queue not doing enough to ensure we are sending the skb back in
> > the same state as we get it. Looking at rt2x00lib_txdone() we don't
> > return headroom that may have been taken for frame alignment and we
> > don't account for the extra 4-bytes taken for header_align when the
> > payload_align is larger then the header_align while setting up the
> > l2pad.
> 
> I think we reserve sufficient space, 4 bytes for payload align plus
> 4 bytes for header align.
> 
> > Do you know why rt2x00 doesn't return frame align space back to
> > the headroom?
> 
> For performance reasons I guess.
> 
> If we return (payload) aligned skb to mac80211 and mac80211 will
> retransmit that skb we will not align it again, since it's already
> aligned. But perhaps we really need to return original tx skb to
> mac80211, but if so, I would like to know detailed reason why.

There is some old patch from Helmut, which remove payload alignment and
movement:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-September/004179.html  
It seems to be provided by default on OpenWRT and AFICT nobody reported
skb underflow panic there. Hence possibly it fix the problem, but still
I would like to know why. However if we apply it, I would relax extra
TX headroom requirement to 4 bytes, as that maximum what we need with
the patch.

Stanislaw

