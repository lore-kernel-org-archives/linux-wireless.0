Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0FDINs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 04:13:48 -0400
Subject: Re: rt73usb & Mesh network
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinChab0MINV64h1UFb7YUxVRNvDztRbcKxZuDJO@mail.gmail.com>
References: <AANLkTinChab0MINV64h1UFb7YUxVRNvDztRbcKxZuDJO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 10:13:46 +0200
Message-ID: <1275639226.9953.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-03 at 12:49 +0200, Ivo Van Doorn wrote:

> The stacktrace indicates the problem is a scheduling while atomic bug,
> however this seems to be triggerd by mac80211 making the bss_info_changed()
> callback function in atomic context. But the current documentation of mac80211
> implies that this callback function is allowed to sleep.
> 
> Could you check the stacktrace to see if this is indeed a mac80211 bug rather
> then rt73usb?

It clearly is, at least a documentation issue in that it must not sleep
in mesh mode ... fixing it would seem to require major locking changes
in the mesh implementation, and unfortunately we don't have anybody who
has enough time to care about it.

FWIW, if anybody is interested to fix this, it seems like it should be
safe to use sta_mtx instead of rcu_read_lock() for station protection
and change a lot of mesh stuff to not use the per-sta spinlock. Must be
very careful with this though since some stuff is in the RX path.

Short of doing that, I can only suggest disabling mesh for drivers that
require being able to sleep.

johannes

