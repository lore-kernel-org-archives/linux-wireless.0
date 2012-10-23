Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2JWTxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 15:53:36 -0400
Message-ID: <1351022046.10322.15.camel@jlt4.sipsolutions.net> (sfid-20121023_215341_469965_1C5CECB7)
Subject: Re: [PATCH] mac80211: don't allocate mesh peer under RCU
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Date: Tue, 23 Oct 2012 21:54:06 +0200
In-Reply-To: <1351018508-6390-1-git-send-email-thomas@cozybit.com> (sfid-20121023_205521_279759_4D8ECEBB)
References: <1351018508-6390-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121023_205521_279759_4D8ECEBB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-23 at 11:55 -0700, Thomas Pedersen wrote:
> mesh_plink_alloc() was being called with the RCU read lock held, which
> triggered warnings because various things inside this function must
> sleep. It doesn't make much sense to hold an RCU lock on a pointer we
> don't yet have anyway, so do rcu_read_unlock() if allocating and relock
> on insertion.

I'm not going to apply this, the locking in mesh_plink.c is *already* a
mess with the spinlock being unlocked in so many places. Adding a random
rcu being possibly dropped in the middle won't help it at all. That may
be safe today, but it's in no way obvious. Dropping a lock in the middle
of a function when it was acquired by the caller is always a *really*
bad idea.

To fix the issue right now, you can simply change GFP_KERNEL to
GFP_ATOMIC in mesh_plink_alloc(). If that's not good enough in the long
term, I'd really like to see code cleanups to make all the locking
easier to follow.

johannes

