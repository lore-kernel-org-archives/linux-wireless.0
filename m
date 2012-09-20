Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2ITNEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 09:04:51 -0400
Received: by pbbrr4 with SMTP id rr4so166093pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 06:04:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348145936.2388.18.camel@sauron.fi.intel.com>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	<1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	<1347631355.5263.19.camel@sauron.fi.intel.com>
	<1347640763.5263.24.camel@sauron.fi.intel.com>
	<1347892887.7112.9.camel@sauron.fi.intel.com>
	<1348142775.2388.10.camel@sauron.fi.intel.com>
	<1348144524.4161.26.camel@jlt4.sipsolutions.net>
	<CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	<CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	<1348145936.2388.18.camel@sauron.fi.intel.com>
Date: Thu, 20 Sep 2012 15:04:50 +0200
Message-ID: <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com> (sfid-20120920_150456_332372_3ED7EF4A)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <edumazet@google.com>
To: artem.bityutskiy@linux.intel.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to pull 40 bytes : Thats OK for tcp performance, because 40 bytes
is the minimum size of IP+TCP headers

pskb_may_pull(skb, 40);

(instead of your  skb_linearize(skb);)


On Thu, Sep 20, 2012 at 2:58 PM, Artem Bityutskiy
<artem.bityutskiy@linux.intel.com> wrote:
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
> Does not help, this one does:
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 61c621e..6888586 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1797,6 +1797,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>                         /* deliver to local stack */
>                         skb->protocol = eth_type_trans(skb, dev);
>                         memset(skb->cb, 0, sizeof(skb->cb));
> +                       skb_linearize(skb);
>                         netif_receive_skb(skb);
>                 }
>
> --
> Best Regards,
> Artem Bityutskiy
