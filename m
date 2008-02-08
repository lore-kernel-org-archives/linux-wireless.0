Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:48861 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbYBHJKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 04:10:18 -0500
Received: by py-out-1112.google.com with SMTP id u52so5379679pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 01:10:17 -0800 (PST)
Message-ID: <43e72e890802080110t47d8c9ci2a6fd7ea78215336@mail.gmail.com> (sfid-20080208_091039_502616_B7051AE2)
Date: Fri, 8 Feb 2008 04:10:17 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "bruno randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>
In-Reply-To: <20080207035202.GW1261@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <200801241226.28394.bruno@thinktube.com>
	 <1201193704.3454.137.camel@johannes.berg>
	 <200801251701.59629.bruno@thinktube.com>
	 <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
	 <20080206043451.GT1261@jm.kir.nu>
	 <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com>
	 <20080207035202.GW1261@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 6, 2008 10:52 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Feb 06, 2008 at 01:33:31PM -0500, Luis R. Rodriguez wrote:
>
> > Yes I see your point, this is definitely an issue, unless of course
> > the driver/stack is configured to default to use a specific channel by
> > default. But regardless its a problem.
>
> It doesn't really help even if the driver/stack would be configured to
> default to a specific channel. This has to work with other
> implementations, too.

Right, my point was just that if a stack was configured to try to use
a channel by default when creating an IBSS and you'd end up with the
same BSSID you'd eventually get a merge. But I see your point about
interoperability and I think its key.

> Hardcoding BSSID based on SSID may be fine for
> most cases when a new IBSS is created, but still, the implementation
> will need to allow this to be changed when merging with other parts of
> the IBSS since those other parts may not implement this type of hack.

I'm not quite sure I understand the problem here. The *key* feature of
using some sort of a hash is just to guarantee the "random" BSSID you
create matches that of the other stations using the same BSSID (and
channel if channel is part of the hash as well as you suggest). What
changes here is just the method for generation of the BSSID should no
beacon be received yet for the SSID chosen.

> I'm somewhat concerned about the possibility of getting the same BSSID
> on different channels, though. Using the same BSSID for different groups
> is not really a very good solution.. Including the channel number in the
> hash data would resolve this concern.

Sure.

> > Well the idea is that if it misses the timer from the leader it'll try
> > to create the IBSS but will end up using the same BSSID as the leader
> > would have, eventually causing a merge amongst the nodes. So you would
> > not merge unless its with the same BSSID.
>
> I'm not completely what the "misses the timer from the leader" is
> referring to or even what this "leader" would be in context of IBSS.
> Anyway, the implementation has to merge regardless of what BSSID is used
> (i.e., SSID match is enough).

Oh well I mean the TSF becaon leader when in IBSS in the BSS during
beacon generation. When in IBSS you have a node who has the greatest
time for the TSF, this is what I call the leader. If a STA misses the
"leader beacon" it'll generate its own beacon and may create a
separate BSS. If however, you change the algorithm for picking the
"random BSSID" and instead use some sort of hash based on desired SSID
(and channel) you'd end up generating beacons for the same BSSID,
eventually forcing a merge even if you missed the first few beacons
from the TSF leader for the BSS.

> > I haven't run the test myself but I am informed this hack helps to try
> > to solve the issue with 400 nodes on IBSS mode.
>
> Sure, if you can control all the STAs in the IBSS. That just is not the
> case in general and Linux wireless stack must not be designed with the
> view point of all STAs following the exact same rules (unless those
> rules are based on a required standard behavior)..

Agreed that we shouldn't assume everyone will have the same hacks, and
that we should focus on interoperability but I am wondering how this
could break things. All that would be changed here is the algorithm
for BSSID generation, instead of using a random BSSID you'd use one as
a hash of say SSID and channel. Can you think of issues with
interoperability with STAs who choose a random BSSID generator instead
of a hash other than those using a hash being able to guarantee
sticking to the same BSSID ?

> Taken into account that we should really implement proper IBSS merge to
> allow interoperation with non-mac80211 implementations, I don't know how
> much of a benefit this BSSID=hash(SSID,chan) mechanism would really
> provide.

It simply would solve the IBSS split issue, which can be caused by
several reasons, until that is solved within the standard or someone
thinks of a better solution.

> If it can be shown that the IBSS merges in a large network are
> not stable,

Oh we have proof for this :) and we also have proof of how using a
hash helps correct it, of course, as  hack. I'll try to see if we can
come up with something a bit more formal I guess.

> this could of course be helpful and I don't think I would
> object it as long as the BSSID is going to end up being same only on the
> same channel and the mac80211 implementation allows the BSSID to be
> changed if a Beacon frame is received with a larger timestamp value than
> the local TSF timer.

Respecting the higher TSF is not affected, all that would be changed
would be the algorithm used for generating the BSSID. Once we have
IBSS merge on mac80211 I'll then test a patch for this on the 40x40
grid with ath5k and let you know how it goes. I'll try to use two
BSSes, each on a separate channel. Not sure yet what topology to use.

  Luis
