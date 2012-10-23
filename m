Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64023 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab2JWUWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 16:22:52 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so2254375wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2012 13:22:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351022046.10322.15.camel@jlt4.sipsolutions.net>
References: <1351018508-6390-1-git-send-email-thomas@cozybit.com> <1351022046.10322.15.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 23 Oct 2012 13:22:27 -0700
Message-ID: <CAG6hwVO2Kig_wX=cWGATD0njspcUn66z1vPt1vjXWK9021JmaA@mail.gmail.com> (sfid-20121023_222257_198040_C339ACA7)
Subject: Re: [PATCH] mac80211: don't allocate mesh peer under RCU
To: Johannes Berg <johannes@sipsolutions.net>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 23, 2012 at 12:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-10-23 at 11:55 -0700, Thomas Pedersen wrote:
>> mesh_plink_alloc() was being called with the RCU read lock held, which
>> triggered warnings because various things inside this function must
>> sleep. It doesn't make much sense to hold an RCU lock on a pointer we
>> don't yet have anyway, so do rcu_read_unlock() if allocating and relock
>> on insertion.
>
> I'm not going to apply this, the locking in mesh_plink.c is *already* a
> mess with the spinlock being unlocked in so many places. Adding a random
> rcu being possibly dropped in the middle won't help it at all. That may
> be safe today, but it's in no way obvious. Dropping a lock in the middle
> of a function when it was acquired by the caller is always a *really*
> bad idea.
>
> To fix the issue right now, you can simply change GFP_KERNEL to
> GFP_ATOMIC in mesh_plink_alloc(). If that's not good enough in the long
> term, I'd really like to see code cleanups to make all the locking
> easier to follow.

That won't really do it though, since sta_info_pre_move_state() needs
to sleep as well

I'll take another look, thanks for reviewing.

Thomas
