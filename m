Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22619 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2LBQwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 11:52:18 -0500
Date: Sun, 2 Dec 2012 19:51:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] carl9170: remove unneeded NULL check
Message-ID: <20121202165153.GC6517@mwanda> (sfid-20121202_175223_987725_A82E0FAA)
References: <20121202104238.GB16078@elgon.mountain>
 <201212021449.21267.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201212021449.21267.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 02, 2012 at 02:49:20PM +0100, Christian Lamparter wrote:
> On Sunday 02 December 2012 11:42:38 Dan Carpenter wrote:
> > The "sta" variable is not checked for NULL consistently and it makes the
> > static checkers complain.  I asked Christian Lamparter about this and
> > it turns out the check is not needed.  "In fact, in order to set up a
> > ampdu session, the stack would call the driver's op_ampdu_action
> > callback which always needs a station."
> 
> that would be from the thread:
> <http://www.spinics.net/lists/linux-wireless/msg94526.html>
>  
> > I have removed the check.
> I think this will bug for multicast and injected frames.
>  
> It is not possible for the sta(tion) pointer to be NULL if
> the frame has the IEEE80211_TX_CTL_AMPDU flag set. So the
> sta == NULL check can be avoided when calling 
> carl9170_tx_ampdu_queue. This is because mac80211 tracks
> all aggregation sessions within the station struct.
> Of course, this is something that the checker tool can't
> possibly deduce, but it has a point and we can add a check
> like this [see attached draft patch]:
> 
> What do you think [or more to the point: what does the
> checker say?]
> 

So we wouldn't apply my patch, we would apply that one instead?

I think that's great.  My static checker doesn't understand bit
flags yet so it would complain but it would be obvious to a human
reader.

Could you just resend that patch with a signed-off-by?

regards,
dan carpenter

