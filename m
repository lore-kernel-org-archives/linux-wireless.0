Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44996 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3EaSAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 14:00:37 -0400
Message-ID: <51A8E53E.8030101@candelatech.com> (sfid-20130531_200041_962432_F23717E6)
Date: Fri, 31 May 2013 11:00:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
References: <51A79E4A.7000609@candelatech.com>  <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com>  <51A857BF.7070008@openwrt.org> <51A8DC1C.1040908@candelatech.com>  (sfid-20130531_192143_291284_FB196B0A) <1370021846.14117.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370021846.14117.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2013 10:37 AM, Johannes Berg wrote:
> On Fri, 2013-05-31 at 10:21 -0700, Ben Greear wrote:
>
>> Before I go work on this, does anyone have any preference over
>> whether pktgen packets should obey the QoS or the xmit-queue?
>
> That's the core of the problem is that select_queue has the side effect
> of setting skb->priority in mac80211, no? Maybe that side effect needs
> to be removed?

I think it might be more that the wifi stacks have some specific
assumptions about how skb->priority maps to queues and QoS.  If
they get out of sync, then the TID mappings and so forth get
confused.

I actually don't know exactly why pktgen shows this problem,
but it must be because it does direct calls to the hard_start_xmit
method of the netdev when (most?) other paths do dev_queue_xmit
or similar.

> Actually that makes it seem like something else should be doing packet
> classification, not mac80211 in select_queue()?
>
> Where is skb->priority actually really used in mac80211? I don't see
> much?

There's a bit more in net/wireless/util.c, at least (cfg80211_classify8021d, for instance).

The mac80211/wme.c uses it.  Some of this is called from the drivers
(line 1916 or so of ath9k/xmit.c).

It's all a bit convoluted in my opinion, but there may well
be good reasons for it.

I think the network stack in general is not going to want
to bother with mapping QoS to xmit queues, so probably that
has to remain in the wifi stacks somewhere...

Thanks,
Ben


>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

