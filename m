Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:55734 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966530AbZLHV4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:56:15 -0500
Message-ID: <4B1ECB84.6010009@gmail.com>
Date: Tue, 08 Dec 2009 22:56:20 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andi Kleen <andi@firstfloor.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in 	2.6.32
References: <20091204233202.GA13658@basil.fritz.box>	 <4B1BB44E.90706@gmail.com>	 <200912080006.28892.s.L-H@gmx.de>	 <20091208095755.GT18989@one.firstfloor.org>	 <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>	 <4B1EC842.7040407@gmail.com> <1260308669.32227.2.camel@johannes.local>
In-Reply-To: <1260308669.32227.2.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/09 22:44, Johannes Berg wrote:
> On Tue, 2009-12-08 at 22:42 +0100, Gertjan van Wingerde wrote:
> 
>> OK. Please try again with the attached patch. Basically it disables going
>> to sleep when there are still unacknowledged frames in the TX queues.
>> This mirrors the behavior of the Ralink provided drivers.
> 
> Kinda looks like you forgot to actually make it go to sleep once the
> queues are drained though?
> 

Well, this is a test patch, to validate my theory that this is where the problem is.
If that is confirmed, then I can start working out a proper solution.

How does mac80211 look at these things anyway. How does it expect the driver to handle
the cases where mac80211 asks the driver to go to sleep because of power saving, and
the driver can't because its queues haven't drained yet?

---
Gertjan.

