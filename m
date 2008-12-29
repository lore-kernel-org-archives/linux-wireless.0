Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48863 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYL2DpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 22:45:23 -0500
Message-Id: <1230522322.28489.1292098677@webmail.messagingengine.com> (sfid-20081229_044529_946345_0B3286A6)
From: "Dan E" <trg_info@mailhaven.com>
To: "Jouni Malinen" <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <200812272208.20153.mb@bu3sch.de> <20081227220814.GA15229@jm.kir.nu>
Subject: Re: Hostapd doesn't like crda
In-Reply-To: <20081227220814.GA15229@jm.kir.nu>
Date: Sun, 28 Dec 2008 22:45:22 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 28 Dec 2008 00:08:14 +0200, "Jouni Malinen" <j@w1.fi> said:
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
> Unfortunately, I don't see an easy fix for this.

This sounds like it's broken by design.  Hostapd should not send
NL80211_CMD_REQ_SET_REG if it is unable to evaluate the result.  If it's
necessary to do "iw reg set foobar" in a script prior to invoking
hostapd, then why does hostapd even bother?

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

