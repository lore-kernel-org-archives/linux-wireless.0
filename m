Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36390 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbeAOMBM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:01:12 -0500
Message-ID: <1516017667.410.12.camel@sipsolutions.net> (sfid-20180115_130149_501208_4FA13D95)
Subject: Re: WARNING in rfkill_alloc
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+1ddfb3357e1d7bb5b5d3@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Date: Mon, 15 Jan 2018 13:01:07 +0100
In-Reply-To: <CACT4Y+aO8kwS+ketv3rr0x3EecZ6j+7ep8Ag6PuTirO00SqRtw@mail.gmail.com> (sfid-20180115_101229_108798_C47519CB)
References: <089e08282cc03493040562b0079c@google.com>
         <1516006661.410.6.camel@sipsolutions.net>
         <CACT4Y+aO8kwS+ketv3rr0x3EecZ6j+7ep8Ag6PuTirO00SqRtw@mail.gmail.com>
         (sfid-20180115_101229_108798_C47519CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 10:12 +0100, Dmitry Vyukov wrote:

> However, there can be some surprising things, for example, executing
> one ioctl/setsockopt with data meant for another one, or these
> 0xffffffffffffffff are actually mean 0 (for involved reasons), 

I think those fff was actually what was throwing me off.

> or we
> can simply have bugs in these descriptions so they don't match C
> structures and then all data is messed/shifted.

No, I think this part was OK.

> If this representation does not make sense to you right away, your
> best bet is looking at/running the C reproducer where you can see true
> data layout:
> 
> 
[...]
Yeah, good point, I should've just done that.

> > Ah, then again, now I see the fault injection - I guess dev_set_name()
> > just failed and we didn't check the return value, will fix that.
> 
> Yes, it's highly likely the root cause. The raw.log file shows there
> there was an immediately preceding fault in kmalloc in the same
> process, in a close stack.

Yep, I submitted the fix now (with the correct reported-by).

Also for the other one, the wiphy_register() warning.

johannes
