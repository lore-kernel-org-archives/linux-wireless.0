Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33727 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbDUGyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 02:54:36 -0400
Received: by iecrt8 with SMTP id rt8so7224300iec.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2015 23:54:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429519633.2439.11.camel@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEeraicUA4Vo4tT93yFn7uN4-FapHOu_5wVutBvtJZP+jQ@mail.gmail.com>
	<1429519633.2439.11.camel@sipsolutions.net>
Date: Tue, 21 Apr 2015 09:54:35 +0300
Message-ID: <CAB3XZEeTCSK2qpyBqBXJLyJm_SES4RncUr0AoZLtqqvCz9BprQ@mail.gmail.com> (sfid-20150421_085439_734145_E6E6B0AA)
Subject: Re: [PATCH 01/11] mac80211: add TX fastpath
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2015 at 11:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hey, somebody is reviewing my patches :-)
>
i didn't delve into them too much, but generally they look good :)

>> > +       build.key = rcu_access_pointer(sta->ptk[sta->ptk_idx]);
>> > +       if (!build.key)
>> > +               build.key = rcu_access_pointer(sdata->default_unicast_key);
>> don't you need rcu_dereference here? (and you don't seem to be inside
>> rcu section here)
>
> It's a bit complicated.
>
> I used to think I don't need it, but perhaps I do to avoid accessing bad
> memory in this function.
>
> The thing is that this function is going to be called immediately
> whenever those pointers change, so that the RCU handling of the fast_tx
> struct itself should prevent the TX path from accessing a bad key
> pointer.
>
> However, it seems possible that we go into this function on another CPU
> for unrelated reasons, and if that CPU then stalls after getting the key
> pointer but before assigning the fast_tx pointer, then it might
> overwrite the assignment or clearing from the CPU processing the key
> change.
>
> So indeed it looks like this isn't safe as is right now.
>
> To fix that, I think I can hold the lock longer, so that the lifetime of
> the key and the fast_tx pointer are more closely correlated. If I
> acquire the spinlock before checking for the key, then the CPU that
> invalidates the key pointer cannot race in this way with another caller,
> since the key pointer would (for this purpose) be protected by the lock.
> Then either the CPU that deleted the key will have to wait (while the
> key is still pretty much valid) and then will overwrite the fast_tx w/o
> the key, or the other CPU will have to wait and will find the key
> pointer changed/NULL already.
>
> Right? what do you think?

sounds correct.
i guess taking rcu_lock is a valid option as well (for about the same
reasons). so either one of them should be good.

Eliad.
