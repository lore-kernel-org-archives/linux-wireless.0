Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2CSIjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 04:39:31 -0400
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <4F65C374.2060505@openwrt.org>
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-2-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-3-git-send-email-nbd@openwrt.org>
	 <1332065875.3609.3.camel@jlt3.sipsolutions.net>
	 <4F65C374.2060505@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 09:39:28 +0100
Message-ID: <1332146368.3359.12.camel@jlt3.sipsolutions.net> (sfid-20120319_093935_080638_D479A1CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-03-18 at 12:13 +0100, Felix Fietkau wrote:
> On 2012-03-18 11:17 AM, Johannes Berg wrote:
> > On Sun, 2012-03-18 at 00:00 +0100, Felix Fietkau wrote:
> >> Calling mod_timer from the rx/tx hotpath is somewhat expensive, and the
> >> timeout doesn't need to be so precise.
> >> 
> >> Switch to a different strategy: Schedule the timer initially, store jiffies
> >> of all last rx/tx activity which would previously modify the timer, and
> >> let the timer re-arm itself after checking the last rx/tx timestamp.
> > 
> > I don't like this. It's not the optimisation you think it is on other
> > ("embedded") systems where firing a timer is more expensive.
> > 
> > You're trading power consumption against CPU utilisation by causing the
> > timer to wake up.
> I considered that was well, but didn't think one wakeup every 5 seconds
> or so would be significant. Would you take the patch if I change the
> timer to be deferrable, so that it doesn't cause wakeups by itself?

I'm not really convinced, for making them deferrable we should analyse
the consequences of that more carefully, for example it seems possible
that the system wakes up to send a packet, and then the first thing that
happens is a few aggregation handshakes ... that wastes a lot of time
and power.

Also, at least for TX aggregation, you don't even give them a timeout in
ath9k so that wouldn't really be an issue?

johannes

