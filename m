Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25042 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2LBWSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 17:18:31 -0500
Date: Mon, 3 Dec 2012 01:17:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] carl9170: remove unneeded NULL check
Message-ID: <20121202221751.GD6517@mwanda> (sfid-20121202_231902_320219_7CF95C26)
References: <20121202104238.GB16078@elgon.mountain>
 <201212021449.21267.chunkeey@googlemail.com>
 <20121202165153.GC6517@mwanda>
 <201212022124.53838.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201212022124.53838.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 02, 2012 at 09:24:53PM +0100, Christian Lamparter wrote:
> On Sunday, December 02, 2012 05:51:53 PM Dan Carpenter wrote:
> > On Sun, Dec 02, 2012 at 02:49:20PM +0100, Christian Lamparter wrote:
> > > On Sunday 02 December 2012 11:42:38 Dan Carpenter wrote:
> > > > The "sta" variable is not checked for NULL consistently and it makes the
> > > > static checkers complain.  I asked Christian Lamparter about this and
> > > > it turns out the check is not needed.  "In fact, in order to set up a
> > > > ampdu session, the stack would call the driver's op_ampdu_action
> > > > callback which always needs a station."
> > > 
> > > that would be from the thread:
> > > <http://www.spinics.net/lists/linux-wireless/msg94526.html>
> > >  
> > > > I have removed the check.
> > > I think this will bug for multicast and injected frames.
> > >  
> > > It is not possible for the sta(tion) pointer to be NULL if
> > > the frame has the IEEE80211_TX_CTL_AMPDU flag set. So the
> > > sta == NULL check can be avoided when calling 
> > > carl9170_tx_ampdu_queue. This is because mac80211 tracks
> > > all aggregation sessions within the station struct.
> > > Of course, this is something that the checker tool can't
> > > possibly deduce, but it has a point and we can add a check
> > > like this [see attached draft patch]:
> > > 
> > > What do you think [or more to the point: what does the
> > > checker say?]
> > > 
> > 
> > So we wouldn't apply my patch, we would apply that one instead?
> We could, but that's up for debate (no, I don't think we are done
> just yet).
> 
> > I think that's great.  My static checker doesn't understand bit
> > flags yet so it would complain but it would be obvious to a human
> > reader.
> then we might as well add a comment to carl9170_tx_ampdu_queue
> and explain the situation [in a way that's obvious to a
> human reader]. This way we can save the "if"... which is a small
> win since carl9170_op_tx is sort of a hot-path.
>  

Putting a comment there is fine.  Without the comment it's easy for
a human reader to get confused why the check is there.  So long as
humans can read the code, that's all that matters.

> > Could you just resend that patch with a signed-off-by?
> Once we know what to do... yes :)
> I have attached another patch. With this patch the checker
> should be able to read the code without throwing any
> warnings.

Heh.  You have a lot of faith in checker's ability to read code.  In
theory you are right, but it turns out that Smatch is ignoring the
stuff inside the WARN_ON_ONCE().  It's not supposed to do that in
this case; it should only do that if the WARN_ON_ONCE() is in a
statement by itself.  I'll take a look at this, but not tonight.

Anyway, do whatever you think is best.  I just misunderstood what
you said earlier about it not being possible to be NULL.  I
understand it better now I think.  Thanks.

regards,
dan carpenter

