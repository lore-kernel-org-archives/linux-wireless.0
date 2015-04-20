Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37167 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbbDTIrb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 04:47:31 -0400
Message-ID: <1429519633.2439.11.camel@sipsolutions.net> (sfid-20150420_104734_884371_83764795)
Subject: Re: [PATCH 01/11] mac80211: add TX fastpath
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 20 Apr 2015 10:47:13 +0200
In-Reply-To: <CAB3XZEeraicUA4Vo4tT93yFn7uN4-FapHOu_5wVutBvtJZP+jQ@mail.gmail.com> (sfid-20150420_102521_690840_0A3A15BD)
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeraicUA4Vo4tT93yFn7uN4-FapHOu_5wVutBvtJZP+jQ@mail.gmail.com>
	 (sfid-20150420_102521_690840_0A3A15BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey, somebody is reviewing my patches :-)

> > +       build.key = rcu_access_pointer(sta->ptk[sta->ptk_idx]);
> > +       if (!build.key)
> > +               build.key = rcu_access_pointer(sdata->default_unicast_key);
> don't you need rcu_dereference here? (and you don't seem to be inside
> rcu section here)

It's a bit complicated.

I used to think I don't need it, but perhaps I do to avoid accessing bad
memory in this function.

The thing is that this function is going to be called immediately
whenever those pointers change, so that the RCU handling of the fast_tx
struct itself should prevent the TX path from accessing a bad key
pointer.

However, it seems possible that we go into this function on another CPU
for unrelated reasons, and if that CPU then stalls after getting the key
pointer but before assigning the fast_tx pointer, then it might
overwrite the assignment or clearing from the CPU processing the key
change.

So indeed it looks like this isn't safe as is right now.

To fix that, I think I can hold the lock longer, so that the lifetime of
the key and the fast_tx pointer are more closely correlated. If I
acquire the spinlock before checking for the key, then the CPU that
invalidates the key pointer cannot race in this way with another caller,
since the key pointer would (for this purpose) be protected by the lock.
Then either the CPU that deleted the key will have to wait (while the
key is still pretty much valid) and then will overwrite the fast_tx w/o
the key, or the other CPU will have to wait and will find the key
pointer changed/NULL already.

Right? what do you think?

johannes

