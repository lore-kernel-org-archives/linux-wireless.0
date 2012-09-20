Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51012 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2ITMkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:40:25 -0400
Received: by pbbrr4 with SMTP id rr4so121231pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 05:40:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348144524.4161.26.camel@jlt4.sipsolutions.net>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	<1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	<1347631355.5263.19.camel@sauron.fi.intel.com>
	<1347640763.5263.24.camel@sauron.fi.intel.com>
	<1347892887.7112.9.camel@sauron.fi.intel.com>
	<1348142775.2388.10.camel@sauron.fi.intel.com>
	<1348144524.4161.26.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Sep 2012 14:40:24 +0200
Message-ID: <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com> (sfid-20120920_144028_758401_14E0E501)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Eric Dumazet <edumazet@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, but which netif_receive_skb(), as I count 5 occurrences in
net/mac80211/rx.c ?

Instead of skb_linearize() calls

you could try several values of XXX in

pskb_may_pull(skb, XXX)

So that you make sure XXX bytes are available in skb->head, and not
the whole frame.

One you know the limit for XXX, it might give a clue where a
pskb_may_pull(skb, XXX) is missing.

On Thu, Sep 20, 2012 at 2:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> >             56138f5 iwlwifi: dont pull too much payload in skb head
>> >             3edaf3e mac80211: manage AP netdev carrier state
>>
>> The second patch (AP carrier state) actually exposed a connman issue
>> which I fixed and submitted a connman patch:
>> http://lists.connman.net/pipermail/connman/2012-September/011232.html
>>
>> However, Eric's patch still causes tethering problems to me.
>
>
> Let me recap a bit. Artem is using connman, which sets up the wifi
> interface as part of a bridge. It runs wpa_supplicant to create an AP
> (only AP and mesh mode interfaces can be bridged anyway).
>
>
> Eric, you said:
>
>> I would say some part of the stack assumes a header (I dont know wich
>> one ?) is pulled in skb->head/data, and thats a bug.
>>
>> Always use pskb_may_pull(skb, XXX) to make sure you can access XXX
>> bytes in skb->data
>
> I thought we'd figure out which part of the stack assumes a header, so I
> asked Artem to test a one-line patch which adds "skb_linearize()" before
> "netif_receive_skb()" in mac80211. This makes it work, but I'm not sure
> where after that the bad assumption might be.
>
> johannes
>
