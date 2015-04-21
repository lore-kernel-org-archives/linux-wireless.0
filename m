Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42703 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbbDUHHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 03:07:02 -0400
Message-ID: <1429600019.2045.2.camel@sipsolutions.net> (sfid-20150421_090707_353837_82ABE68B)
Subject: Re: [PATCH 01/11] mac80211: add TX fastpath
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 21 Apr 2015 09:06:59 +0200
In-Reply-To: <CAB3XZEeTCSK2qpyBqBXJLyJm_SES4RncUr0AoZLtqqvCz9BprQ@mail.gmail.com> (sfid-20150421_085437_370250_F0858165)
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeraicUA4Vo4tT93yFn7uN4-FapHOu_5wVutBvtJZP+jQ@mail.gmail.com>
	 <1429519633.2439.11.camel@sipsolutions.net>
	 <CAB3XZEeTCSK2qpyBqBXJLyJm_SES4RncUr0AoZLtqqvCz9BprQ@mail.gmail.com>
	 (sfid-20150421_085437_370250_F0858165)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-21 at 09:54 +0300, Eliad Peller wrote:

> > Hey, somebody is reviewing my patches :-)
> >
> i didn't delve into them too much, but generally they look good :)

:)

> > To fix that, I think I can hold the lock longer, so that the lifetime of
> > the key and the fast_tx pointer are more closely correlated. If I
> > acquire the spinlock before checking for the key, then the CPU that
> > invalidates the key pointer cannot race in this way with another caller,
> > since the key pointer would (for this purpose) be protected by the lock.
> > Then either the CPU that deleted the key will have to wait (while the
> > key is still pretty much valid) and then will overwrite the fast_tx w/o
> > the key, or the other CPU will have to wait and will find the key
> > pointer changed/NULL already.
> >
> > Right? what do you think?
> 
> sounds correct.
> i guess taking rcu_lock is a valid option as well (for about the same
> reasons). so either one of them should be good.

I don't think that would be correct - that just prevents the key from
being freed while we hold it, whereas here we actually need to prevent
the key from being accessed.

Anyway - I've done a bit more testing on this and will likely merge it
(the fixed version of course) in the next couple of days.

johannes

