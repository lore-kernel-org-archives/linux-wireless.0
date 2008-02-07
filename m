Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:59610 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbYBGDwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 22:52:17 -0500
Date: Wed, 6 Feb 2008 19:52:02 -0800
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Ivo van Doorn <ivdoorn@gmail.com>,
	Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	Ivan Seskar <Seskar@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Message-ID: <20080207035202.GW1261@jm.kir.nu> (sfid-20080207_035222_171190_EFA43B38)
References: <20080118125252.6455.41047.stgit@one> <200801241226.28394.bruno@thinktube.com> <1201193704.3454.137.camel@johannes.berg> <200801251701.59629.bruno@thinktube.com> <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com> <20080206043451.GT1261@jm.kir.nu> <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:33:31PM -0500, Luis R. Rodriguez wrote:

> Yes I see your point, this is definitely an issue, unless of course
> the driver/stack is configured to default to use a specific channel by
> default. But regardless its a problem.

It doesn't really help even if the driver/stack would be configured to
default to a specific channel. This has to work with other
implementations, too. Hardcoding BSSID based on SSID may be fine for
most cases when a new IBSS is created, but still, the implementation
will need to allow this to be changed when merging with other parts of
the IBSS since those other parts may not implement this type of hack.

I'm somewhat concerned about the possibility of getting the same BSSID
on different channels, though. Using the same BSSID for different groups
is not really a very good solution.. Including the channel number in the
hash data would resolve this concern.

> Well the idea is that if it misses the timer from the leader it'll try
> to create the IBSS but will end up using the same BSSID as the leader
> would have, eventually causing a merge amongst the nodes. So you would
> not merge unless its with the same BSSID.

I'm not completely what the "misses the timer from the leader" is
referring to or even what this "leader" would be in context of IBSS.
Anyway, the implementation has to merge regardless of what BSSID is used
(i.e., SSID match is enough).

> I haven't run the test myself but I am informed this hack helps to try
> to solve the issue with 400 nodes on IBSS mode.

Sure, if you can control all the STAs in the IBSS. That just is not the
case in general and Linux wireless stack must not be designed with the
view point of all STAs following the exact same rules (unless those
rules are based on a required standard behavior)..

Taken into account that we should really implement proper IBSS merge to
allow interoperation with non-mac80211 implementations, I don't know how
much of a benefit this BSSID=hash(SSID,chan) mechanism would really
provide. If it can be shown that the IBSS merges in a large network are
not stable, this could of course be helpful and I don't think I would
object it as long as the BSSID is going to end up being same only on the
same channel and the mac80211 implementation allows the BSSID to be
changed if a Beacon frame is received with a larger timestamp value than
the local TSF timer.

-- 
Jouni Malinen                                            PGP id EFC895FA
