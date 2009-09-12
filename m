Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43542 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbZILQvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 12:51:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
Date: Sat, 12 Sep 2009 18:51:44 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200909111648.50902.mb@bu3sch.de> <200909111813.35810.mb@bu3sch.de> <4AABCF28.6090505@hartkopp.net>
In-Reply-To: <4AABCF28.6090505@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909121851.46002.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 September 2009 18:41:12 Oliver Hartkopp wrote:
> Michael Buesch wrote:
> 
> >> As there are several users in the kernel do exact this test and call the
> >> appropriate netif_rx() function, i would suggest to create a static inline
> >> function:
> >>
> >> static inline int netif_rx_ti(struct sk_buff *skb)
> >> {
> >> 	if (in_interrupt())
> >> 		return netif_rx(skb);
> >> 	return netif_rx_ni(skb);
> >> }
> >>
> >> ('ti' for test in_interrupt())
> >>
> >> in include/linux/netdevice.h
> >>
> >> What do you think about that?
> > 
> > Yeah, I'm fine with that.
> > 
> 
> Hi Michael,
> 
> i cooked a patch that introduces netif_rx_ti() and fixes up the problems in
> mac80211 and the CAN subsystem.
> 
> Currently i'm pondering whether netif_rx_ti() is needed in all cases or if
> there are code sections that'll never be executed from irq-context.
> 
> In theses cases netif_rx_ni() should be prefered to netif_rx_ti() to prevent
> the obsolete check ...
> 
> Is there any of your changes that should better use netif_rx_ni() ?
> 
> Regards,
> Oliver
> 

Well, I'd say this check does not cost much at all.
If I were the net maintainer, I'd get rid of netif_rx_ni() _and_ netif_rx_ti() and
do the check internally in netif_rx().
But as I don't have to decide that, I just want the mac80211 issue fixed.

-- 
Greetings, Michael.
