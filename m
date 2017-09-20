Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:56550 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdITGCt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 02:02:49 -0400
Received: by mail-pg0-f46.google.com with SMTP id 7so1140531pgd.13
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 23:02:49 -0700 (PDT)
Date: Tue, 19 Sep 2017 23:02:45 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>, Joe Perches <joe@perches.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mwifiex: print URB submit failure error after
 threshold attemtps
Message-ID: <20170920060244.GA13616@google.com> (sfid-20170920_080253_128790_E9CFC92B)
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
 <1504122674-3379-3-git-send-email-gbhat@marvell.com>
 <1504238727.2361.1.camel@perches.com>
 <6dfc9cfaff734c12bc53ffcb063c4491@SC-EXCH02.marvell.com>
 <20170914215955.GA42289@google.com>
 <87bmm6yot6.fsf_-_@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87bmm6yot6.fsf_-_@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Sep 20, 2017 at 07:30:29AM +0300, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> 
> > Hi Ganapathi,
> >
> > On Thu, Sep 14, 2017 at 02:14:24PM +0000, Ganapathi Bhat wrote:
> >> > On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:

> >> > Why not use a ratelimit?
> >> Since this is for receive, the packets are from AP side and we cannot
> >> lower the rate from AP. On some low performance systems this change
> >> will be helpful.
> >
> > I think Joe was referring to things like printk_ratelimited() or
> > dev_err_ratelimited(). Those automatically ratelimit prints for you,
> > using a static counter. You'd just need to make a small warpper for
> > mwifiex_dbg() using __ratelimit().
> >
> > Those sort of rate limits are significantly different than yours though.
> > You were looking to avoid printing errors when there are only a few
> > failures in a row, whereas the existing rate-limiting infrastructure
> > looks to avoid printing errors if too many happen in a row. Those are
> > different goals.
> 
> Are you saying that this patch is good to take? Or should Ganapathi
> submit v2?

If you're asking me...

All I was saying was that I don't think Joe's suggestion will help
Ganapathi. I'd expect Ganapathi could confirm/deny that part. (Or Joe
could correct me if my interpretation is wrong.)

I'm also not familiar with how we expect dev_alloc_skb() failures to be
handled. If that's a common expected failure mode in low-memory
situations (seems reasonable?) and the driver handles these failure just
fine (completely unreviewed by me, so far; I suspect it doesn't do this
completely correctly), then sure, being less noisy about it as done in
this patch should be fine.

IOW, I don't have concrete feedback for Ganapathi to address, but I'm
not exactly "ack"ing it myself.

Brian
