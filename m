Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58697 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbAFKv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:51:57 -0500
Message-ID: <1420541514.1966.16.camel@sipsolutions.net> (sfid-20150106_115222_774497_547DE2F0)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 06 Jan 2015 11:51:54 +0100
In-Reply-To: <1419847199-25493-1-git-send-email-arik@wizery.com> (sfid-20141229_110002_459476_3F75B800)
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
	 (sfid-20141229_110002_459476_3F75B800)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-29 at 11:59 +0200, Arik Nemtsov wrote:
> If a P2P GO is active, the cfg80211_reg_can_beacon function will take
> the wdev lock, in its call to cfg80211_go_permissive_chan. But the wdev lock
> is already taken by the parent channel-checking function, causing a
> deadlock.
> Split the checking code into two parts. The first part will check if the
> wdev is active and saves the channel under the wdev lock. The second part
> will check actual channel validity according to type.

I'm not convinced this is the right thing to do. When checking for the
current wdev that it can use a channel, then it seems that it's own
current BSS connection (if any) shouldn't actually be taken into account
- ergo the lock shouldn't have to be taken, that interface should be
excluded from the "can beacon due to concurrent check" anyway.

Also, the only reason this can happen anyway is when you call "can
beacon" for a station interface - which seems nonsensical. Given that
this is now really becoming far more complex than originally designed
("can beacon") with TDLS ("can IR") perhaps this should be
 * renamed to reg_can_ir()
 * passed an "exclude wdev"
 * (and use mutex_lock_nested with a big comment to explain to lockdep
what's
   going on)

or so.

johannes

