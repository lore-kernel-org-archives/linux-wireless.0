Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63140 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab1BYSWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 13:22:04 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so2185147bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 10:22:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110223222842.GA20039@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	<1298064074-8108-1-git-send-email-linville@tuxdriver.com>
	<AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
	<20110221184716.GD9650@tuxdriver.com>
	<AANLkTi=LnpFLzKbtaPxSjg9TRU_pY2oRi6tsFg5GkaGK@mail.gmail.com>
	<20110223222842.GA20039@tuxdriver.com>
Date: Fri, 25 Feb 2011 10:21:50 -0800
Message-ID: <AANLkTimahYNo0ZHr9PU217CWJQP6ssuhaxguYVz7dX_-@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 23, 2011 at 2:28 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Feb 21, 2011 at 03:26:32PM -0800, Nathaniel Smith wrote:
>> But for this calculation to make sense, we need T to be the time it
>> takes the card to transmit 1 fragment. In your patch, you're not
>> measuring that. You're measuring the total time between when a packet
>> is enqueued and when it is transmitted; if there were K packets in the
>> queue ahead of it, then this is the time to send *all* of them --
>> you're measuring (K+1)*T. That's why in my patch, I recorded the
>> current size of the queue when each packet is enqueued, so I could
>> compute T = total_time / (K+1).
>
> Thanks for the math!  I think I see what you are saying now.  Since the
> measured time is being used to determine the queue size, we need to
> factor-in the length of the queue that resulted in that measurment.
>
> Unfortunately, I'm not sure how to apply this with the technique I
> am using for the timing measurements. :-(  I'll have to think about
> this some more...

I guess an ugly but effective approach would be to steal some bits
from the timestamp... something like (untested, and probably needs
some sign-extension bugs fixed):

#define LATENCY_BITS 8
#define ENQUEUED_BITS 24
BUILD_BUG_ON(LATENCY_BITS + ENQUEUED_BITS != 32);

static ktime_t _ktime_get_and_stash(int enqueued) {
        timespec now = ktime_to_timespec(ktime_get());
        now.sec &= (1 << LATENCY_BITS) - 1;
        BUG_ON(enqueued > (1 << ENQUEUED_BITS));
        now.sec |= enqueued << LATENCY_BITS;
        return timespec_to_ktime(now);
}

static u64 _ktime_diff_to_now_and_unstash(ktime_t then, int * enqueued) {

        timespec ts_then = ktime_to_timespec(then);
        timespec ts_now = ktime_to_timespec(ktime_get());
        *enqueued = ts_then.tv_sec >> LATENCY_BITS;
        ts_then.tv_sec &= (1 << LATENCY_BITS) - 1;
        ts_now.tv_sec &= (1 << LATENCY_BITS) - 1;
        if (ts_now.tv_sec < ts_then.tv_sec)
                ts_now.tv_sec += (1 << LATENCY_BITS);
         timespec_sub(ts_now, ts_then);
}
