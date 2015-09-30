Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57953 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbI3RYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 13:24:43 -0400
Date: Wed, 30 Sep 2015 19:24:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bastian Bittorf <bittorf@bluebottle.com>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150930172440.GA11160@amd> (sfid-20150930_192446_906761_34A699E4)
References: <20150926102403.GA21555@amd>
 <1443426103.2401.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443426103.2401.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon 2015-09-28 09:41:43, Johannes Berg wrote:
> On Sat, 2015-09-26 at 12:24 +0200, Pavel Machek wrote:
> > 
> > That would be equivalent to ping -Q, right? It does not seem to have
> > any effect :-(. I'd expect at least local machine to use shorter waits
> > for medium, and thus drop packets instead of waiting.
> 
> Correct. But it won't *drop* packets, it just increases the chances of
> getting medium access.

Increases chances of medium access, but limits number of retries, so
it should drop sooner, no?

> > > # you have to add some magic for matching your data
> > > e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7
> > 
> > Again, this is ping -Q equivalent, right? I was doing
> 
> Yes.
> 
> > ping -c 300 -i .2 -Q $[56*4] -s 500 amd
> > 300 packets transmitted, 300 received, 0% packet loss, time 60989ms
> > rtt min/avg/max/mdev = 2.155/8.599/44.475/5.677 ms
> > 300 packets transmitted, 300 received, +1 duplicates, 0% packet loss, time 61030ms
> > rtt min/avg/max/mdev = 2.158/23.809/300.956/49.969 ms, pipe 2
> > 
> > I would expect packet loss, but got long delays instead.
> 
> See above :)
> 
> > > also you should consider force the ACK-timing to 450m / Class1
> > > and forbid retransmission in minstrel
> > 
> > Yes, disabling retransmission would be useful. How would I do that?
> > 
> It won't work on Intel devices though since they don't use
> minstrel(_ht)

I'm using ath5k for testing... that should use minstrel AFAICT.

02:02.0 Ethernet controller: Qualcomm Atheros AR5211 Wireless Network
Adapter [AR5001X 802.11ab] (rev 01)

I'm now trying:

# Background load
sudo ping -f amd -s 8000
# Test
ping -c 30 -i .2 -Q $[0*4] -s 500 amd
ping -c 30 -i .2 -Q $[40*4] -s 500 amd
ping -c 30 -i .2 -Q $[56*4] -s 500 amd

This should send the second  ping to the priority queue based on -Q,
but I don't see an effect against one access point.... and it seems to
work somehow against second one. Good!

avg/maximum latency goes from 8/24 (-Q $[40*4]) to 80/258 (same
settings, every second frame is slow?!) to 8/26 to 7/32 to 6/18. But
this jumps to 92/123, 95/139, 91/128 and 135/678 with (-Q 0). -Q
$[56*4] produces 6/10, 8/23, 6/14, 5/9, 5/14. Good.

Thanks!

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
