Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36708 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbbI1Hls (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 03:41:48 -0400
Message-ID: <1443426103.2401.1.camel@sipsolutions.net> (sfid-20150928_094154_249228_F21D1AFC)
Subject: Re: Low latency communication over wifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>,
	Bastian Bittorf <bittorf@bluebottle.com>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Mon, 28 Sep 2015 09:41:43 +0200
In-Reply-To: <20150926102403.GA21555@amd>
References: <20150926102403.GA21555@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-09-26 at 12:24 +0200, Pavel Machek wrote:
> 
> That would be equivalent to ping -Q, right? It does not seem to have
> any effect :-(. I'd expect at least local machine to use shorter waits
> for medium, and thus drop packets instead of waiting.

Correct. But it won't *drop* packets, it just increases the chances of
getting medium access.

> > # you have to add some magic for matching your data
> > e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7
> 
> Again, this is ping -Q equivalent, right? I was doing

Yes.

> ping -c 300 -i .2 -Q $[56*4] -s 500 amd
> 300 packets transmitted, 300 received, 0% packet loss, time 60989ms
> rtt min/avg/max/mdev = 2.155/8.599/44.475/5.677 ms
> 300 packets transmitted, 300 received, +1 duplicates, 0% packet loss, time 61030ms
> rtt min/avg/max/mdev = 2.158/23.809/300.956/49.969 ms, pipe 2
> 
> I would expect packet loss, but got long delays instead.

See above :)

> > also you should consider force the ACK-timing to 450m / Class1
> > and forbid retransmission in minstrel
> 
> Yes, disabling retransmission would be useful. How would I do that?
> 
It won't work on Intel devices though since they don't use
minstrel(_ht)

johannes
