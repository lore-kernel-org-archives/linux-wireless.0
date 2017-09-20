Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdITEad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 00:30:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>, Joe Perches <joe@perches.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mwifiex: print URB submit failure error after threshold attemtps
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
        <1504122674-3379-3-git-send-email-gbhat@marvell.com>
        <1504238727.2361.1.camel@perches.com>
        <6dfc9cfaff734c12bc53ffcb063c4491@SC-EXCH02.marvell.com>
        <20170914215955.GA42289@google.com>
Date: Wed, 20 Sep 2017 07:30:29 +0300
In-Reply-To: <20170914215955.GA42289@google.com> (Brian Norris's message of
        "Thu, 14 Sep 2017 14:59:57 -0700")
Message-ID: <87bmm6yot6.fsf_-_@purkki.adurom.net> (sfid-20170920_063037_924174_48C7B0FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Hi Ganapathi,
>
> On Thu, Sep 14, 2017 at 02:14:24PM +0000, Ganapathi Bhat wrote:
>> > On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:
>> > > @@ -300,9 +300,16 @@ static int mwifiex_usb_submit_rx_urb(struct
>> > urb_context *ctx, int size)
>> > >  	if (card->rx_cmd_ep != ctx->ep) {
>> > >  		ctx->skb = dev_alloc_skb(size);
>> > >  		if (!ctx->skb) {
>> > > -			mwifiex_dbg(adapter, ERROR,
>> > > -				    "%s: dev_alloc_skb failed\n", __func__);
>> > > +			if (++card->rx_urb_failure_count >
>> > > +			    MWIFIEX_RX_URB_FAILURE_THRESHOLD) {
>> > > +				mwifiex_dbg(adapter, ERROR,
>> > > +					    "%s: dev_alloc_skb failed, failure
>> > count = %u\n",
>> > > +					    __func__,
>> > > +					    card->rx_urb_failure_count);
>> > > +			}
>> > >  			return -ENOMEM;
>> > 
>> > Why not use a ratelimit?
>> Since this is for receive, the packets are from AP side and we cannot
>> lower the rate from AP. On some low performance systems this change
>> will be helpful.
>
> I think Joe was referring to things like printk_ratelimited() or
> dev_err_ratelimited(). Those automatically ratelimit prints for you,
> using a static counter. You'd just need to make a small warpper for
> mwifiex_dbg() using __ratelimit().
>
> Those sort of rate limits are significantly different than yours though.
> You were looking to avoid printing errors when there are only a few
> failures in a row, whereas the existing rate-limiting infrastructure
> looks to avoid printing errors if too many happen in a row. Those are
> different goals.

Are you saying that this patch is good to take? Or should Ganapathi
submit v2?

-- 
Kalle Valo
