Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50243 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbYL1N1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:27:08 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: Hostapd doesn't like crda
Date: Sun, 28 Dec 2008 14:26:16 +0100
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200812272208.20153.mb@bu3sch.de> <20081227220814.GA15229@jm.kir.nu>
In-Reply-To: <20081227220814.GA15229@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812281426.16683.mb@bu3sch.de> (sfid-20081228_142714_380120_CB8EC673)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 December 2008 23:08:14 Jouni Malinen wrote:
> On Sat, Dec 27, 2008 at 10:08:20PM +0100, Michael Buesch wrote:
> > Please take a look at the following log:
> > http://bu3sch.de/misc/crda.JPG
> > 
> > Note the ordering of the events.
> > Hostapd starts up and tells the kernel what country we're in.
> > Then the kernel calls CRDA, _but_ hostapd goes on with its business
> > before CRDA has finished its work.
> 
> Yes, because the netlink message was completed and hostapd assumes
> everything is ready at that point. Ignoring the complexity in the kernel
> (+ CRDA as a helper), this looks like reasonable expectation to make for
> NL80211_CMD_REQ_SET_REG operation. There is no other mechanism that
> would notify hostapd (or any other program setting country for that
> matter) when the operation was actually fully completed and polling for
> channel changes up to a timeout is not very appealing either.
> 
> Unfortunately, I don't see an easy fix for this. cfg80211 would somehow
> need to block sending of the NL80211_CMD_REQ_SET_REG response until CRDA
> has completed doing whatever it is going to do (is that even something
> that cfg80211 knows when the final step was completed?).. I haven't
> taken a look at all the details, but I've asked for this kind of wait in
> the past and at least it did not seem to be trivial to add since this
> has not been fixed yet ;-).

Ok, thanks for the explanation. For now I added a workaround to the initscript
that starts hostapd which sets the regulatory and waits a seconds before starting
hostapd.

	iw reg set DE
	sleep 1
	# start hostapd...

-- 
Greetings, Michael.
