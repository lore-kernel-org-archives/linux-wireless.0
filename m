Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55653 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZIKQNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 12:13:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
Date: Fri, 11 Sep 2009 18:13:33 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <200909111648.50902.mb@bu3sch.de> <200909111707.23971.mb@bu3sch.de> <4AAA75CB.6040803@hartkopp.net>
In-Reply-To: <4AAA75CB.6040803@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909111813.35810.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 September 2009 18:07:39 Oliver Hartkopp wrote:
> Michael Buesch wrote:
> > On Friday 11 September 2009 16:57:54 Kalle Valo wrote:
> >> Michael Buesch <mb@bu3sch.de> writes:
> >>
> >>> Hi,
> >> Hallo,
> >>
> >>> mac80211 (or some other part of the networking stack) triggers this
> >>> warning in the NOHZ code: NOHZ: local_softirq_pending 08
> >>>
> >>> 08 seems to be NET_RX_SOFTIRQ.
> >>>
> >>> It happens, because my test driver b43 handles all RX and TX-status
> >>> callbacks in process context. I guess some part of the networking
> >>> stack expects RX to be in tasklet and/or softirq context.
> >>>
> >>> We also have a report of this warning in wl1251, so it's probably not
> >>> a b43 problem.
> >> Yes, I see this with wl1251. It uses workqueues everywhere.
> >>
> > 
> > This patch seems to fix it.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Index: wireless-testing/net/mac80211/cfg.c
> > ===================================================================
> > --- wireless-testing.orig/net/mac80211/cfg.c	2009-08-09 18:47:11.000000000 +0200
> > +++ wireless-testing/net/mac80211/cfg.c	2009-09-11 16:59:12.000000000 +0200
> > @@ -606,7 +606,7 @@ static void ieee80211_send_layer2_update
> >  	skb->dev = sta->sdata->dev;
> >  	skb->protocol = eth_type_trans(skb, sta->sdata->dev);
> >  	memset(skb->cb, 0, sizeof(skb->cb));
> > -	netif_rx(skb);
> > +	ieee80211_netif_rx(skb);
> >  }
> >  
> >  static void sta_apply_parameters(struct ieee80211_local *local,
> > Index: wireless-testing/net/mac80211/ieee80211_i.h
> > ===================================================================
> > --- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-23 00:06:41.000000000 +0200
> > +++ wireless-testing/net/mac80211/ieee80211_i.h	2009-09-11 17:02:05.000000000 +0200
> > @@ -1053,6 +1053,14 @@ void ieee80211_tx_pending(unsigned long 
> >  int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
> >  
> > +/* rx handling */
> > +static inline int ieee80211_netif_rx(struct sk_buff *skb)
> > +{
> > +	if (in_interrupt())
> > +		return netif_rx(skb);
> > +	return netif_rx_ni(skb);
> > +}
> > +
> 
> Hello Michael,
> 
> i know this NOHZ warning from the CAN stack also - but now, i know what caused
> this warning. I fixed it in my local tree and it works. Thanks!
> 
> As there are several users in the kernel do exact this test and call the
> appropriate netif_rx() function, i would suggest to create a static inline
> function:
> 
> static inline int netif_rx_ti(struct sk_buff *skb)
> {
> 	if (in_interrupt())
> 		return netif_rx(skb);
> 	return netif_rx_ni(skb);
> }
> 
> ('ti' for test in_interrupt())
> 
> in include/linux/netdevice.h
> 
> What do you think about that?

Yeah, I'm fine with that.

-- 
Greetings, Michael.
