Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:49231 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966777AbZLHWtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:49:25 -0500
Message-ID: <4B1ED7FA.3070803@gmail.com>
Date: Tue, 08 Dec 2009 23:49:30 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andi Kleen <andi@firstfloor.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in 	2.6.32
References: <20091204233202.GA13658@basil.fritz.box>	 <4B1BB44E.90706@gmail.com>	 <200912080006.28892.s.L-H@gmx.de>	 <20091208095755.GT18989@one.firstfloor.org>	 <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>	 <4B1EC842.7040407@gmail.com> <1260308669.32227.2.camel@johannes.local>	 <4B1ECB84.6010009@gmail.com> <1260309607.32227.4.camel@johannes.local>
In-Reply-To: <1260309607.32227.4.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/09 23:00, Johannes Berg wrote:
> On Tue, 2009-12-08 at 22:56 +0100, Gertjan van Wingerde wrote:
> 
>> Well, this is a test patch, to validate my theory that this is where the problem is.
>> If that is confirmed, then I can start working out a proper solution.
> 
> Well but this patch won't help you test that theory, because it'll just
> disable PS completely if there were packets pending when mac80211 asked
> you to enable PS, afaict.

I don't think so, but that can be because of a big misunderstanding on my side on PS.
We just do not go to sleep when being asked to by mac80211, and thus are saving less
power. But awake would still work.

When quickly testing the patch I did see multiple requests for enabling PS come in
which were denied because of this patch. So I don't think that anything is disabled
with respect to PS.

> 
>> How does mac80211 look at these things anyway. How does it expect the driver to handle
>> the cases where mac80211 asks the driver to go to sleep because of power saving, and
>> the driver can't because its queues haven't drained yet?
> 
> mac80211 does expect you to be able to transmit while asleep. Same
> happens when PS-polling, where it actually expects you to wait for the
> response frame too. I think. I haven't looked at this in a while.

OK. If that is the case then it may very well be that the PS implementation of rt2x00
is completely broken, as I cannot find any code to wake up if any TX frames come in.

Maybe the safest thing to do would be to disable powersaving from the driver until
we have figured out what the proper implementation of it is for rt2x00.

---
Gertjan.

