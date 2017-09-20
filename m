Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40304 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdITMJk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:09:40 -0400
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
        <87bmm6yot6.fsf_-_@purkki.adurom.net>
        <20170920060244.GA13616@google.com>
Date: Wed, 20 Sep 2017 15:09:35 +0300
In-Reply-To: <20170920060244.GA13616@google.com> (Brian Norris's message of
        "Tue, 19 Sep 2017 23:02:45 -0700")
Message-ID: <8760cda7wg.fsf@kamboji.qca.qualcomm.com> (sfid-20170920_140944_656267_4B6677C5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Sep 20, 2017 at 07:30:29AM +0300, Kalle Valo wrote:
>> Brian Norris <briannorris@chromium.org> writes:
>> 
>> > Hi Ganapathi,
>> >
>> > On Thu, Sep 14, 2017 at 02:14:24PM +0000, Ganapathi Bhat wrote:
>> >> > On Thu, 2017-08-31 at 01:21 +0530, Ganapathi Bhat wrote:
>
>> >> > Why not use a ratelimit?
>> >> Since this is for receive, the packets are from AP side and we cannot
>> >> lower the rate from AP. On some low performance systems this change
>> >> will be helpful.
>> >
>> > I think Joe was referring to things like printk_ratelimited() or
>> > dev_err_ratelimited(). Those automatically ratelimit prints for you,
>> > using a static counter. You'd just need to make a small warpper for
>> > mwifiex_dbg() using __ratelimit().
>> >
>> > Those sort of rate limits are significantly different than yours though.
>> > You were looking to avoid printing errors when there are only a few
>> > failures in a row, whereas the existing rate-limiting infrastructure
>> > looks to avoid printing errors if too many happen in a row. Those are
>> > different goals.
>> 
>> Are you saying that this patch is good to take? Or should Ganapathi
>> submit v2?
>
> If you're asking me...

Yeah, I was asking you because to me this patch looks like an ugly
workaround to a bug. And now that looked patch 1 more closely it feels
the same.

> All I was saying was that I don't think Joe's suggestion will help
> Ganapathi. I'd expect Ganapathi could confirm/deny that part. (Or Joe
> could correct me if my interpretation is wrong.)

Ok.

> I'm also not familiar with how we expect dev_alloc_skb() failures to be
> handled. If that's a common expected failure mode in low-memory
> situations (seems reasonable?) and the driver handles these failure just
> fine (completely unreviewed by me, so far; I suspect it doesn't do this
> completely correctly), then sure, being less noisy about it as done in
> this patch should be fine.

But this is a debug message so it should not bother normal users, right?
I think that having a threshold like this is just hiding problems and
not solving them. The real issue here is that dev_alloc_skb() is failing
and that's what should be solved, not to paper it over by limiting debug
messages. It just means that the real issue will be even more difficult
to detect in the future.

> IOW, I don't have concrete feedback for Ganapathi to address, but I'm
> not exactly "ack"ing it myself.

I'm not very confident about this patch either, it's not just making any
sense.

-- 
Kalle Valo
