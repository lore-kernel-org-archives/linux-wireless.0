Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbcBPWFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 17:05:32 -0500
Message-ID: <1455660329.2723.16.camel@sipsolutions.net> (sfid-20160216_230536_088193_26481340)
Subject: Re: ath9k(?): AP stops sending traffic to iPhone 4S until another
 802.11n-capable STA joins
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, nbd@nbd.name
Date: Tue, 16 Feb 2016 23:05:29 +0100
In-Reply-To: <1455658091-28262-1-git-send-email-apenwarr@gmail.com> (sfid-20160216_222824_263622_E1EF34E2)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 (sfid-20160216_222824_263622_E1EF34E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-16 at 16:28 -0500, Avery Pennarun wrote:
> 
> Changing default_agg_timeout to zero (as it is on most non-ath9k
> drivers) makes the problem pretty much go away.  However, I think
> it's because I'm just dodging the code path that triggers a race
> condition.

That does seem likely. Perhaps you could reproduce it while running
mac80211 tracing? There should be a fair amount of information about
aggregation and queue stops in there, though as you note queue stops
aren't really happening, only aggregation related things. Perhaps the
tracepoints for that aren't quite sufficient.

> Notes:
> 
> - I'm using exactly the same ath9k driver (currently 20150525, but
> we've   tried newer ones with no difference) on two totally different
> platforms: a dual-core mindspeed c2k host CPU (ARMv7) with separate
> ath9k, and a single-core QCA9531 (MIPS) with on-chip ath9k.
> 
> - I've been unable to trigger the problem on the QCA9531, but I have
> on MIPS.

That's ... not what I would have expected, especially since the MIPS is
single core. That makes the races stranger than expected.

> The aggregation code is... a little hairy.  Does anyone have any
> guesses where I might look for the race condition?  Or better still,
> a patch I can try?

I'm not aware of any race conditions in the code right now :)

johannes
