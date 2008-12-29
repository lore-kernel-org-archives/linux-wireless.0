Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40533 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYL2K2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 05:28:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Dan E" <trg_info@mailhaven.com>
Subject: Re: Hostapd doesn't like crda
Date: Mon, 29 Dec 2008 11:28:00 +0100
Cc: "Jouni Malinen" <j@w1.fi>, linux-wireless@vger.kernel.org
References: <200812272208.20153.mb@bu3sch.de> <20081227220814.GA15229@jm.kir.nu> <1230522322.28489.1292098677@webmail.messagingengine.com>
In-Reply-To: <1230522322.28489.1292098677@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812291128.00512.mb@bu3sch.de> (sfid-20081229_112849_919554_5F5DCA95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 December 2008 04:45:22 Dan E wrote:
> 
> On Sun, 28 Dec 2008 00:08:14 +0200, "Jouni Malinen" <j@w1.fi> said:
> > On Sat, Dec 27, 2008 at 10:08:20PM +0100, Michael Buesch wrote:
> > > Please take a look at the following log:
> > > http://bu3sch.de/misc/crda.JPG
> > > 
> > > Note the ordering of the events.
> > > Hostapd starts up and tells the kernel what country we're in.
> > > Then the kernel calls CRDA, _but_ hostapd goes on with its business
> > > before CRDA has finished its work.
> > 
> > Yes, because the netlink message was completed and hostapd assumes
> > everything is ready at that point. Ignoring the complexity in the kernel
> > (+ CRDA as a helper), this looks like reasonable expectation to make for
> > NL80211_CMD_REQ_SET_REG operation. There is no other mechanism that
> > would notify hostapd (or any other program setting country for that
> > matter) when the operation was actually fully completed and polling for
> > channel changes up to a timeout is not very appealing either.
> > 
> > Unfortunately, I don't see an easy fix for this.
> 
> This sounds like it's broken by design.  Hostapd should not send
> NL80211_CMD_REQ_SET_REG if it is unable to evaluate the result.  If it's
> necessary to do "iw reg set foobar" in a script prior to invoking
> hostapd, then why does hostapd even bother?
> 

hostapd isn't broken. The CMD_REQ_SET_REG should block until regulatory
settings are done. It currently doesn't, because that's hard to implement (probably
by design).

-- 
Greetings, Michael.
