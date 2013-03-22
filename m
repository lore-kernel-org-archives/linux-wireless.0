Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423107Ab3CVVOQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 17:14:16 -0400
Message-ID: <1363986849.8238.71.camel@jlt4.sipsolutions.net> (sfid-20130322_221432_076799_380F8F83)
Subject: Re: [PATCH 1/2] mac80211: some fixes for ieee80211_do_stop while
 suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 22:14:09 +0100
In-Reply-To: <20130318093046.GA1458@redhat.com>
References: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
	 <1363362270.8656.25.camel@jlt4.sipsolutions.net>
	 <20130318093046.GA1458@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 10:30 +0100, Stanislaw Gruszka wrote:

> I thought about 2 solutions:
> 
> 1) Do not drv_remove_interface() and drv_stop() on suspend. Need to
> check and possibly rewrite drivers to work with that, so this is not
> preferred solution for me.

Yeah, that's probably not feasible. Actually this is what happens with
WoWLAN today, but still. OTOH, it'd only have to be done for drivers
that even can hotplug :)

> 2) Add "if (local->started && !local->suspended) check in some drv_
> callbacks, IOW silently ignore callbacks when suspended. This looks
> as even worse hack than this patch.

Agree, that's not really a great idea either.

I was more thinking along the lines of seeing whether during suspend
it'd be possible to put the interface into a state where it's safe to
not do any more cleanups at all, and then just not really execute the
do_stop() at all if it's still in that suspended state. But that looks
equally difficult to do.

johannes

