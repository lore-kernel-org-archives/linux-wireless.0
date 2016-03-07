Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36314 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbcCGQyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 11:54:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAHqTa-2-uZ0PUdwp33E588EU2a7T6KnTYs8RWfNDEzgOLseG9g@mail.gmail.com>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<E1abfnE-0000VS-00@www.xplot.org>
	<CA+BoTQk6J7kgdie9aX24MB+8PxN3oFUh0eVdmVrdyptW5RxQXg@mail.gmail.com>
	<CAPp0ZBYP9UzUTtPz=vivUQkE2FiGSsJjDaecQtPuK8y_d3ccqA@mail.gmail.com>
	<56DD99AA.8050403@openwrt.org>
	<CAHqTa-2-uZ0PUdwp33E588EU2a7T6KnTYs8RWfNDEzgOLseG9g@mail.gmail.com>
Date: Mon, 7 Mar 2016 08:54:48 -0800
Message-ID: <CAA93jw4JG_uEZaxk1JDKndq9K0+QPwKaAmK6=gZ8e-7qNmc=Cw@mail.gmail.com> (sfid-20160307_175457_905990_69DAD6AB)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Dave Taht <dave.taht@gmail.com>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	Tim Shepard <shep@alum.mit.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Network Development <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Andrew Mcgregor <andrewmcgr@google.com>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If I can just get a coherent patch set that I can build, I will gladly
join you on the testing ath9k in particular... can probably do ath10k,
too - and do a bit of code review... this week. it's very exciting
watching all this activity...

but I confess that I've totally lost track of what set of trees and
patchwork I should try to pull from. wireless-drivers-next? ath10k?
wireless-next? net-next? toke and I have a ton of x86 platforms
available to test on....

Avery - which patches did you use??? on top of what?

In terms of "smoothing" codel...

I emphatically do not think codel in it's current form is "ready" for
wireless, at the very least the target should not be much lower than
20ms in your 2 station tests.  There is another bit in codel where the
algo "turns off" with only a single MTU's worth of packets
outstanding, which could get bumped to the ideal size of the
aggregate. "ideal" kind of being a variable based on a ton of other
factors...

the underlying code needs to be striving successfully for per-station
airtime fairness for this to work at all, and the driver/card
interface nearly as tight as BQL is for the fq portion to behave
sanely. I'd configure codel at a higher target and try to observe what
is going on at the fq level til that got saner.

There are so many other variables and things left unaccounted for, as yet.
