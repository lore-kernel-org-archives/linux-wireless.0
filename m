Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1LLJwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:52:04 -0500
Subject: Re: [RFC] mac80211: Prevent possible BUG on suspend.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYjxRK30hTvKEaK=ppofN=KecJkbabTggWzXZQ5b-EN-NA@mail.gmail.com> (sfid-20111212_102315_339801_E78EE17A)
References: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com>
	 <1323680547.3442.6.camel@jlt3.sipsolutions.net>
	 <CAMG6FYjxRK30hTvKEaK=ppofN=KecJkbabTggWzXZQ5b-EN-NA@mail.gmail.com>
	 (sfid-20111212_102315_339801_E78EE17A)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:52:01 +0100
Message-ID: <1323683521.3442.33.camel@jlt3.sipsolutions.net> (sfid-20111212_105210_298735_CF687EC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 10:22 +0100, Dmitry Tarnyagin wrote:
> On Mon, Dec 12, 2011 at 10:02 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2011-12-12 at 00:38 +0100, Dmitry Tarnyagin wrote:
> >> Some WLAN hardware has
> >> longer timeouts for non-interruptible configuration-related
> >> operations, leading to the watchdog timeout while
> >> ieee80211_scan_cancel is waiting on a mutex.
> >
> > Yuck, fix the device?
> >
> It's hardly possible. Some configuration changes really takes long time,
> especially in presence of an active bluetooth session.
> ... or abort suspend on the driver's level. It's perfectly ok for me. But then
> driver needs to be at least notified that WLAN is suspending. What do you
> think about early-suspend driver callback which to be called before any
> possibly locking operations in mac80211 code?

That's seems reasonable.

> >> The patch checks if interface mutex is already held and rejects
> >> suspend if there is a possibility of locking.
> >
> > That's really not a good plan. This will refuse suspend *all the time*.
> >
> All the time? I don't think so.. On normal Linux systems WLAN operations
> should not interfere with suspend at all. On aggressive systems like Android
> it's actually a good idea to reject suspend when the interface mutex is held,
> otherwise system will be likely resumed almost immediately by WoW.

Well whenever it would have to wait for the mutex, even if it just has
to wait 1ms for it... That will *certainly* trigger *randomly* on normal
laptops systems and cause a TON of bug reports from users saying "my
system randomly refuses to suspend".

johannes

