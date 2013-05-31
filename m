Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3EaSlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 14:41:45 -0400
Message-ID: <1370025698.14117.15.camel@jlt4.sipsolutions.net> (sfid-20130531_204153_665019_C0E78175)
Subject: Re: Another try at getting pktgen to work with wifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 31 May 2013 20:41:38 +0200
In-Reply-To: <51A8E53E.8030101@candelatech.com>
References: <51A79E4A.7000609@candelatech.com>
	  <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com>
	  <51A857BF.7070008@openwrt.org> <51A8DC1C.1040908@candelatech.com>
	  (sfid-20130531_192143_291284_FB196B0A) <1370021846.14117.13.camel@jlt4.sipsolutions.net>
	 <51A8E53E.8030101@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-31 at 11:00 -0700, Ben Greear wrote:

> I think it might be more that the wifi stacks have some specific
> assumptions about how skb->priority maps to queues and QoS.  If
> they get out of sync, then the TID mappings and so forth get
> confused.

What I'm saying though is that I don't see where skb->priority is even
_used_ in the wifi stack. I can see it getting set, but not used.

> I actually don't know exactly why pktgen shows this problem,
> but it must be because it does direct calls to the hard_start_xmit
> method of the netdev when (most?) other paths do dev_queue_xmit
> or similar.

Other paths go through select_queue(), obviously.

> > Actually that makes it seem like something else should be doing packet
> > classification, not mac80211 in select_queue()?
> >
> > Where is skb->priority actually really used in mac80211? I don't see
> > much?
> 
> There's a bit more in net/wireless/util.c, at least (cfg80211_classify8021d, for instance).

But that's pretty much all assignments.

> The mac80211/wme.c uses it.  Some of this is called from the drivers
> (line 1916 or so of ath9k/xmit.c).

What's called there? I don't see any reason for that to use
skb->priority?

> It's all a bit convoluted in my opinion, but there may well
> be good reasons for it.

More likely legacy.

johannes

