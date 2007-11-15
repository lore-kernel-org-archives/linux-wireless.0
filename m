Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:23365 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495AbXKOJpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 04:45:19 -0500
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] b43: multiple MAC addresses support
References: <1194572631.4793.64.camel@johannes.berg>
	<1194605550.4793.93.camel@johannes.berg>
	<20071111025808.GK4031@jm.kir.nu> <87pryfd8cc.fsf@nokia.com>
	<1194953217.9116.38.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Thu, 15 Nov 2007 11:35:29 +0200
In-Reply-To: <1194953217.9116.38.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 13 Nov 2007 12\:26\:57 +0100")
Message-ID: <877ikjsvfi.fsf@nokia.com> (sfid-20071115_094523_580662_AEE9CE83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2007-11-12 at 13:14 +0200, Kalle Valo wrote:
>
>> Exactly, it is important for small mobile devices that beacons are
>> sent at the correct time. For example, I have seen broken APs which
>> Target Beacon Transmission Time fluctuates and Nokia N800 has high
>> power consumption because of that.
>
> The N800 and similar devices only wake up at DTIM beacons, right?

At least N800 and N810 do, we don't want to miss any of broadcast and
multicast traffic. But I don't know how other mobile devices wakeup
for beacons.

> So another idea would be to burst beacons but make sure the DTIM
> beacon time doesn't fluctuate away from the DTIM TBTT. This would be
> possible by changing the order of the beacons and adjusting the DTIM
> count so that the beacon with DTIM count zero is always the first.

At least from my point of view that could possible. Of course it feels
like a bit of a hack, but I guess there's no clean way to implement
this.

-- 
Kalle Valo
