Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38714 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751133AbdINOOc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 10:14:32 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Joe Perches <joe@perches.com>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH 2/2] mwifiex: print URB submit failure error
 after threshold attemtps
Date: Thu, 14 Sep 2017 14:14:24 +0000
Message-ID: <6dfc9cfaff734c12bc53ffcb063c4491@SC-EXCH02.marvell.com> (sfid-20170914_161435_428321_8D6FA2BA)
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
         <1504122674-3379-3-git-send-email-gbhat@marvell.com>
 <1504238727.2361.1.camel@perches.com>
In-Reply-To: <1504238727.2361.1.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

> On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:
> > Current driver prints dev_alloc_skb failures everytime while
> > submitting RX URBs. This failure might be frequent in some low
> > resource platforms. So, wait for a threshold failure count before
> > start priting the error. This change is a follow up for the 'commit
> > 7b368e3d15c3
> > ("mwifiex: resubmit failed to submit RX URBs in main thread")'
> 
> []
> 
> > diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c
> > b/drivers/net/wireless/marvell/mwifiex/usb.c
> []
> > @@ -300,9 +300,16 @@ static int mwifiex_usb_submit_rx_urb(struct
> urb_context *ctx, int size)
> >  	if (card->rx_cmd_ep != ctx->ep) {
> >  		ctx->skb = dev_alloc_skb(size);
> >  		if (!ctx->skb) {
> > -			mwifiex_dbg(adapter, ERROR,
> > -				    "%s: dev_alloc_skb failed\n", __func__);
> > +			if (++card->rx_urb_failure_count >
> > +			    MWIFIEX_RX_URB_FAILURE_THRESHOLD) {
> > +				mwifiex_dbg(adapter, ERROR,
> > +					    "%s: dev_alloc_skb failed, failure
> count = %u\n",
> > +					    __func__,
> > +					    card->rx_urb_failure_count);
> > +			}
> >  			return -ENOMEM;
> 
> Why not use a ratelimit?
Since this is for receive, the packets are from AP side and we cannot lower the rate from AP. On some low performance systems this change will be helpful.

Regards,
Ganapathi
