Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44927 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3EaSvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 14:51:52 -0400
Message-ID: <51A8F141.5050804@candelatech.com> (sfid-20130531_205156_577264_2AB9AD65)
Date: Fri, 31 May 2013 11:51:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
References: <51A79E4A.7000609@candelatech.com>   <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com>   <51A857BF.7070008@openwrt.org> <51A8DC1C.1040908@candelatech.com>   (sfid-20130531_192143_291284_FB196B0A) <1370021846.14117.13.camel@jlt4.sipsolutions.net>  <51A8E53E.8030101@candelatech.com> <1370025698.14117.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1370025698.14117.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2013 11:41 AM, Johannes Berg wrote:
> On Fri, 2013-05-31 at 11:00 -0700, Ben Greear wrote:
>
>> I think it might be more that the wifi stacks have some specific
>> assumptions about how skb->priority maps to queues and QoS.  If
>> they get out of sync, then the TID mappings and so forth get
>> confused.
>
> What I'm saying though is that I don't see where skb->priority is even
> _used_ in the wifi stack. I can see it getting set, but not used.

ieee80211_downgrade_queue
wme_downgrade_ac // sort of
ieee80211_select_queue_80211 // sort of...seems twiddling skb->priority is more of a by-product here.

cfg80211_classify8021d

>>> Actually that makes it seem like something else should be doing packet
>>> classification, not mac80211 in select_queue()?
>>>
>>> Where is skb->priority actually really used in mac80211? I don't see
>>> much?
>>
>> There's a bit more in net/wireless/util.c, at least (cfg80211_classify8021d, for instance).
>
> But that's pretty much all assignments.

cfg80211_classify8021d uses it to determine the queue in if skb->priority is
set to a special range (hard coded un-documented hack from hell, it appears).

I didn't go looking to find out where those magic values might be set.


>> The mac80211/wme.c uses it.  Some of this is called from the drivers
>> (line 1916 or so of ath9k/xmit.c).
>
> What's called there? I don't see any reason for that to use
> skb->priority?

Ok, I was confused about that..but that *is* the code that pukes if you
have have mis-matched queues like you get with pktgen in upstream kernels...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

