Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0KOVli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 16:41:38 -0500
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211: match only assigned bss in =?UTF-8?Q?sta=5Finfo=5Fg?=
 =?UTF-8?Q?et=5Fbss?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Nov 2010 22:41:35 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <20101115203048.GA6757@jm.kir.nu>
References: <1284492854.3703.0.camel@jlt3.sipsolutions.net> <20101115203048.GA6757@jm.kir.nu>
Message-ID: <a2e657f4e238d6ec8128bf4f1ec08514@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Nov 2010 22:30:48 +0200, Jouni Malinen <j@w1.fi> wrote:
> This (commit a2c1e3dad516618cb0fbfb1a62c36d0b0744573a) seems to cause
> some changes that may not have been intended.. I'm not sure whether to
> call them all regressions, but it does break my 802.11w test setup.. ;-)
> 
> With this change in place, robust management frames injected on a cooked
> monitor interface do not get protected by mac80211 in station mode
> (i.e., PMF in use on wlan0 and PTK in place; use mon0 to inject a
> frame) while they used to get protected before this change. Reverting
> this on top of wireless-testing.git now gets the old behavior back, too.
> I have not verified whether this applies to other uses of cooked monitor
> (e.g., Data frames or AP mode where Shared Key auth actually expects
> injected frame to get protected in normal, non-testing-only use case).
> 
> Is this a bug? Or do I need to figure out another way of getting the
> frames injected on a monitor interface encrypted by mac80211?

It's a bug. I suspect we set up the sta pointer first, and then the
sdata pointer (when injecting) where if we do it the other way around
it should work fine.

johannes
