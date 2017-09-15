Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750879AbdIOJqj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 05:46:39 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Joe Perches <joe@perches.com>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 2/2] mwifiex: print URB submit failure error
 after threshold attemtps
Date: Fri, 15 Sep 2017 09:46:33 +0000
Message-ID: <f54060710b85470a92a15c9cbab4b777@SC-EXCH02.marvell.com> (sfid-20170915_114643_926011_9549131A)
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
 <1504122674-3379-3-git-send-email-gbhat@marvell.com>
 <1504238727.2361.1.camel@perches.com>
 <6dfc9cfaff734c12bc53ffcb063c4491@SC-EXCH02.marvell.com>
 <20170914215955.GA42289@google.com>
In-Reply-To: <20170914215955.GA42289@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,
> 
> Hi Ganapathi,
> 
> On Thu, Sep 14, 2017 at 02:14:24PM +0000, Ganapathi Bhat wrote:
> > > On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:
> > > > Current driver prints dev_alloc_skb failures everytime while
> > > > submitting RX URBs. This failure might be frequent in some low
> > > > resource platforms. So, wait for a threshold failure count before
> > > > start priting the error. This change is a follow up for the
> > > > 'commit
> > > > 7b368e3d15c3
> > > > ("mwifiex: resubmit failed to submit RX URBs in main thread")'
> > >
> > > []
> > >
> > > > diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c
> > > > b/drivers/net/wireless/marvell/mwifiex/usb.c
> > > []
> > > > @@ -300,9 +300,16 @@ static int mwifiex_usb_submit_rx_urb(struct
> > > urb_context *ctx, int size)
> > > >  	if (card->rx_cmd_ep != ctx->ep) {
> > > >  		ctx->skb = dev_alloc_skb(size);
> > > >  		if (!ctx->skb) {
> > > > -			mwifiex_dbg(adapter, ERROR,
> > > > -				    "%s: dev_alloc_skb failed\n",
> __func__);
> > > > +			if (++card->rx_urb_failure_count >
> > > > +			    MWIFIEX_RX_URB_FAILURE_THRESHOLD) {
> > > > +				mwifiex_dbg(adapter, ERROR,
> > > > +					    "%s: dev_alloc_skb failed,
> failure
> > > count = %u\n",
> > > > +					    __func__,
> > > > +					    card->rx_urb_failure_count);
> > > > +			}
> > > >  			return -ENOMEM;
> > >
> > > Why not use a ratelimit?
> > Since this is for receive, the packets are from AP side and we cannot
> > lower the rate from AP. On some low performance systems this change
> > will be helpful.
> 
> I think Joe was referring to things like printk_ratelimited() or
> dev_err_ratelimited(). Those automatically ratelimit prints for you,
> using a static counter. You'd just need to make a small warpper for
> mwifiex_dbg() using __ratelimit().

Got it. Yet it looks he meant the same. Thank you.

> 
> Those sort of rate limits are significantly different than yours
> though.
> You were looking to avoid printing errors when there are only a few
> failures in a row, whereas the existing rate-limiting infrastructure
> looks to avoid printing errors if too many happen in a row. Those are
> different goals.
> 
> Brian

Ok.

Hi Joe,

Let us know your comments on the above.

Thanks,
Ganapathi
