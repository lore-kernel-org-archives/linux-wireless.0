Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:43481 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYBFEfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 23:35:07 -0500
Date: Tue, 5 Feb 2008 20:34:51 -0800
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Message-ID: <20080206043451.GT1261@jm.kir.nu> (sfid-20080206_043514_587462_0ADEF9BD)
References: <20080118125252.6455.41047.stgit@one> <200801241226.28394.bruno@thinktube.com> <1201193704.3454.137.camel@johannes.berg> <200801251701.59629.bruno@thinktube.com> <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 02, 2008 at 06:22:12PM -0500, Luis R. Rodriguez wrote:

> problems. A solution to this we implemented at Orbit with MadWifi was
> that instead of generating "random" BSSIDs you'd create one based on
> the hash of the SSID [1]. This ensures that nodes with identical SSIDs
> end up with identical BSSIDs, regardless of any strange problems.

How does that work with multiple channels? The patch did not seem to do
more than just use a very weak "hash" of the SSID to generate the BSSID.
In other words, I would assume it leaves IBSS STAs on whatever channel
they end up selecting, i.e., in separate groups, unless all STAs are
forced to use the same channel by not allowing them to initialize the
IBSS on other channels. This would also likely require hardcoding the
STAs not to allow merging to other BSSIDs should there be any such
(i.e., any STA that does not implement this hack).

> Technically from what I have gathered this doesn't break the specs but
> would prevent this split-IBSS problem. I actually like to see this
> technique added into mac80211 too.
> 
> [1] http://www.orbit-lab.org/wiki/HowTo/bssidFix

I don't see how this alone would either prevent the split-IBSS problem
or be compliant with the IEEE 802.11 standard. The change in this patch
makes it likely to get same BSSID for different IBSS since the first six
octets of the SSID is used as the BSSID. That would not be very
desirable.. Furthermore, it is unlikely to work well with STA
implementations that do not implement the identical mechanism for
generating the BSSID.

The BSSID generation as a hash from SSID does not sound like something
that would match the requirements of IEEE 802.11 11.1.6 ("a number
selected in a manner that minimizes the probability of STAs generating
the same number") since it is actually maximizing that probablity for
the case of same SSID ;-).

As far as joining of separate STA groups in an IBSS (same SSID) is
concerned, 11.1.4 seems to indicate that the STA in IBSS shall adopt
_all_ parameters (i.e., also BSSID and channel) contained in the Beacon
frame when the Timestamp field of the received Beacon is later than the
STA's own TSF timer. This seems to be a requirement for supporting
merging of separate IBSS groups.. Actually hearing a Beacon from another
channel may be an issue, though, but at least as far as separate groups
using different BSSIDs, but same SSID, on the same channel is concerned,
the merging behavior seems to be defined in the standard.

-- 
Jouni Malinen                                            PGP id EFC895FA
