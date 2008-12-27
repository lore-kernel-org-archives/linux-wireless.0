Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58439 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbYL0WId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 17:08:33 -0500
Date: Sun, 28 Dec 2008 00:08:14 +0200
From: Jouni Malinen <j@w1.fi>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Hostapd doesn't like crda
Message-ID: <20081227220814.GA15229@jm.kir.nu> (sfid-20081227_230903_310661_CBAA11C0)
References: <200812272208.20153.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812272208.20153.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 27, 2008 at 10:08:20PM +0100, Michael Buesch wrote:
> Please take a look at the following log:
> http://bu3sch.de/misc/crda.JPG
> 
> Note the ordering of the events.
> Hostapd starts up and tells the kernel what country we're in.
> Then the kernel calls CRDA, _but_ hostapd goes on with its business
> before CRDA has finished its work.

Yes, because the netlink message was completed and hostapd assumes
everything is ready at that point. Ignoring the complexity in the kernel
(+ CRDA as a helper), this looks like reasonable expectation to make for
NL80211_CMD_REQ_SET_REG operation. There is no other mechanism that
would notify hostapd (or any other program setting country for that
matter) when the operation was actually fully completed and polling for
channel changes up to a timeout is not very appealing either.

Unfortunately, I don't see an easy fix for this. cfg80211 would somehow
need to block sending of the NL80211_CMD_REQ_SET_REG response until CRDA
has completed doing whatever it is going to do (is that even something
that cfg80211 knows when the final step was completed?).. I haven't
taken a look at all the details, but I've asked for this kind of wait in
the past and at least it did not seem to be trivial to add since this
has not been fixed yet ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
