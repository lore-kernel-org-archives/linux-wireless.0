Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:15218 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZILSH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 14:07:29 -0400
Message-ID: <4AABE34D.30401@hartkopp.net>
Date: Sat, 12 Sep 2009 20:07:09 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211: NOHZ: local_softirq_pending 08
References: <200909111648.50902.mb@bu3sch.de> <200909111813.35810.mb@bu3sch.de> <4AABCF28.6090505@hartkopp.net> <200909121851.46002.mb@bu3sch.de>
In-Reply-To: <200909121851.46002.mb@bu3sch.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 12 September 2009 18:41:12 Oliver Hartkopp wrote:
>> Michael Buesch wrote:
>>
>>>> As there are several users in the kernel do exact this test and call the
>>>> appropriate netif_rx() function, i would suggest to create a static inline
>>>> function:
>>>>
>>>> static inline int netif_rx_ti(struct sk_buff *skb)
>>>> {
>>>> 	if (in_interrupt())
>>>> 		return netif_rx(skb);
>>>> 	return netif_rx_ni(skb);
>>>> }
>>>>
>>>> ('ti' for test in_interrupt())
>>>>
>>>> in include/linux/netdevice.h
>>>>
>>>> What do you think about that?
>>> Yeah, I'm fine with that.
>>>
>> Hi Michael,
>>
>> i cooked a patch that introduces netif_rx_ti() and fixes up the problems in
>> mac80211 and the CAN subsystem.
>>
>> Currently i'm pondering whether netif_rx_ti() is needed in all cases or if
>> there are code sections that'll never be executed from irq-context.
>>
>> In theses cases netif_rx_ni() should be prefered to netif_rx_ti() to prevent
>> the obsolete check ...
>>
>> Is there any of your changes that should better use netif_rx_ni() ?
>>
>> Regards,
>> Oliver
>>
> 
> Well, I'd say this check does not cost much at all.
> If I were the net maintainer, I'd get rid of netif_rx_ni() _and_ netif_rx_ti() and
> do the check internally in netif_rx().
> But as I don't have to decide that, I just want the mac80211 issue fixed.
> 

Like this?

int netif_rx(struct sk_buff *skb)
{
	int err;

	if (likely(in_interrupt()))
		err = __netif_rx(skb);
	else {
		preempt_disable();
		err = __netif_rx(skb);
		if (local_softirq_pending())
			do_softirq();
		preempt_enable();
	}

	return err;
}

I don't know how expensive in_interrupt() is ... checking the code does not
give any answers to *me* ;-)

But i found

356 netif_rx()

but only

18 netif_rx_ni()

in the kernel tree.

And three of them check for in_interrupt() before using netif_rx() or
netif_rx_ni() ...


Finally i would tend to introduce netif_rx_ti() in include/linux/netdevice.h
as described above, for the rare code that can be used inside and outside the
irq context.

I assume the affected code in the CAN stuff has to use netif_rx_ni() - but i
will doublecheck that (and prepare a separate CAN patch).

For the mac80211 i would suggest to check whether you really need
netif_rx()/netif_rx_ni()/netif_rx_ti() in all the regarded cases.

I assume always using netif_rx_ti() (as you proposed in the original patch) is
not the most efficient approach.

Best regards,
Oliver

