Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:45557 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYBFSde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 13:33:34 -0500
Received: by py-out-1112.google.com with SMTP id u52so4506707pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 10:33:32 -0800 (PST)
Message-ID: <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com> (sfid-20080206_183338_659607_B61A9FC1)
Date: Wed, 6 Feb 2008 13:33:31 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "bruno randolf" <bruno@thinktube.com>,
	"Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>
In-Reply-To: <20080206043451.GT1261@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <200801241226.28394.bruno@thinktube.com>
	 <1201193704.3454.137.camel@johannes.berg>
	 <200801251701.59629.bruno@thinktube.com>
	 <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
	 <20080206043451.GT1261@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 5, 2008 11:34 PM, Jouni Malinen <j@w1.fi> wrote:
> On Sat, Feb 02, 2008 at 06:22:12PM -0500, Luis R. Rodriguez wrote:
>
> > problems. A solution to this we implemented at Orbit with MadWifi was
> > that instead of generating "random" BSSIDs you'd create one based on
> > the hash of the SSID [1]. This ensures that nodes with identical SSIDs
> > end up with identical BSSIDs, regardless of any strange problems.
>
> How does that work with multiple channels?

Good point. It never really accounted for it. This patch to MadWifi
was just a hack to prevent IBSS split on a large grid, and should be
treated as such. I would have to check with MadWifi but my guess here
would be that we didn't see issue with channels as the channel
selected would be a default and all the cards were using the same
driver and hardware.

> The patch did not seem to do
> more than just use a very weak "hash" of the SSID to generate the BSSID.

Indeed the hash is extremely weak. If we were to use something similar
we'd have to consider a stronger hash, say maybe SHA1.

> In other words, I would assume it leaves IBSS STAs on whatever channel
> they end up selecting, i.e., in separate groups, unless all STAs are
> forced to use the same channel by not allowing them to initialize the
> IBSS on other channels.

Yes I see your point, this is definitely an issue, unless of course
the driver/stack is configured to default to use a specific channel by
default. But regardless its a problem.

> This would also likely require hardcoding the
> STAs not to allow merging to other BSSIDs should there be any such
> (i.e., any STA that does not implement this hack).

Well the idea is that if it misses the timer from the leader it'll try
to create the IBSS but will end up using the same BSSID as the leader
would have, eventually causing a merge amongst the nodes. So you would
not merge unless its with the same BSSID.

> > Technically from what I have gathered this doesn't break the specs but
> > would prevent this split-IBSS problem. I actually like to see this
> > technique added into mac80211 too.
> >
> > [1] http://www.orbit-lab.org/wiki/HowTo/bssidFix
>
> I don't see how this alone would either prevent the split-IBSS problem

I haven't run the test myself but I am informed this hack helps to try
to solve the issue with 400 nodes on IBSS mode.

> or be compliant with the IEEE 802.11 standard. The change in this patch
> makes it likely to get same BSSID for different IBSS since the first six
> octets of the SSID is used as the BSSID. That would not be very
> desirable..

Agreed, the hash used is very weak, again its a hack but perhaps it
can help find a better solution. AFAICT this is still an open problem.

> Furthermore, it is unlikely to work well with STA
> implementations that do not implement the identical mechanism for
> generating the BSSID.

Agreed, it definitely won't improve the situation in those cases, but
with those that do it would at least help.

> The BSSID generation as a hash from SSID does not sound like something
> that would match the requirements of IEEE 802.11 11.1.6 ("a number
> selected in a manner that minimizes the probability of STAs generating
> the same number") since it is actually maximizing that probablity for
> the case of same SSID ;-).

Heh, good catch :)

> As far as joining of separate STA groups in an IBSS (same SSID) is
> concerned, 11.1.4 seems to indicate that the STA in IBSS shall adopt
> _all_ parameters (i.e., also BSSID and channel) contained in the Beacon
> frame when the Timestamp field of the received Beacon is later than the
> STA's own TSF timer. This seems to be a requirement for supporting
> merging of separate IBSS groups..

ACK

> Actually hearing a Beacon from another
> channel may be an issue, though,

Broken? :)

> but at least as far as separate groups
> using different BSSIDs, but same SSID, on the same channel is concerned,
> the merging behavior seems to be defined in the standard.

ACK. Again, this seems like an open problem.

We *could* take the channel into considering for the hash along with
SSID... Anyway, good points!

  Luis
