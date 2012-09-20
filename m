Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58257 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2ITMsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:48:17 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so135056pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 05:48:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348145269.4161.28.camel@jlt4.sipsolutions.net>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	<1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	<1347631355.5263.19.camel@sauron.fi.intel.com>
	<1347640763.5263.24.camel@sauron.fi.intel.com>
	<1347892887.7112.9.camel@sauron.fi.intel.com>
	<1348142775.2388.10.camel@sauron.fi.intel.com>
	<1348144524.4161.26.camel@jlt4.sipsolutions.net>
	<CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	<CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	<1348145269.4161.28.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Sep 2012 14:48:16 +0200
Message-ID: <CANn89iLksBMJ=Ep+VcPSAOPzqst70hk8hR5=mGte2vSx=49zUA@mail.gmail.com> (sfid-20120920_144823_083141_9C26E9DD)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <edumazet@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Or its a buggy protocol ?

IP/UDP/TCP definitely works, but maybe another protocol assumes its
header is in skb->head


On Thu, Sep 20, 2012 at 2:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-09-20 at 14:45 +0200, Eric Dumazet wrote:
>> I guess you only need to make sure 14 bytes of ethernet header are
>> available before eth_type_trans(skb, dev);
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index 61c621e..ffe5f84 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1795,9 +1795,13 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>>
>>                 if (skb) {
>>                         /* deliver to local stack */
>> -                       skb->protocol = eth_type_trans(skb, dev);
>> -                       memset(skb->cb, 0, sizeof(skb->cb));
>> -                       netif_receive_skb(skb);
>> +                       if (pskb_may_pull(skb, sizeof(struct ethhdr))) {
>> +                               skb->protocol = eth_type_trans(skb, dev);
>> +                               memset(skb->cb, 0, sizeof(skb->cb));
>> +                               netif_receive_skb(skb);
>> +                       } else {
>> +                               kfree_skb(skb);
>> +                       }
>>                 }
>>         }
>
> Yeah I was looking at the same code just now. However, we had actually
> inserted the skb_linearize() *after* eth_type_trans(), so I'm confused.
> Maybe it still works, more or less by accident?
>
> johannes
>
