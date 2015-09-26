Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58223 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbIZKYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 06:24:07 -0400
Date: Sat, 26 Sep 2015 12:24:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	Bastian Bittorf <bittorf@bluebottle.com>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150926102403.GA21555@amd> (sfid-20150926_122433_646369_56870BC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150923114236.GJ6319@medion.lan>
 <1443007312.1889.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> > (I could use Intel 3945ABG-based card instead, but I figured out 
> > ath5k might be easier to hack?)
> > 
> > Is there way to manipulate type of service from userland to get
> > similar behaviour without patching kernel?
> 
> If your AP has WMM/QoS then you can use setsockopt(SO_PRIORITY) to
> change the TID and thus the AC and get your packets classified as voice
> (VO) on wifi, which makes them much more likely to get access to the
> medium.

That would be equivalent to ping -Q, right? It does not seem to have
any effect :-(. I'd expect at least local machine to use shorter waits
for medium, and thus drop packets instead of waiting.

On Wed 2015-09-23 13:42:36, Bastian Bittorf wrote:
> * Pavel Machek <pavel@ucw.cz> [23.09.2015 13:38]:
> > Is there way to manipulate type of service from userland to get
> > similar behaviour without patching kernel?
> 
> yes, iptables DSCP / DiffServ / Differentiated Services Field
> 
> # you have to add some magic for matching your data
> e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7

Again, this is ping -Q equivalent, right? I was doing

ping -c 300 -i .2 -Q $[56*4] -s 500 amd
300 packets transmitted, 300 received, 0% packet loss, time 60989ms
rtt min/avg/max/mdev = 2.155/8.599/44.475/5.677 ms
300 packets transmitted, 300 received, +1 duplicates, 0% packet loss, time 61030ms
rtt min/avg/max/mdev = 2.158/23.809/300.956/49.969 ms, pipe 2

I would expect packet loss, but got long delays instead.

> also you should consider force the ACK-timing to 450m / Class1
> and forbid retransmission in minstrel

Yes, disabling retransmission would be useful. How would I do that?

Thanks and best regards,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
