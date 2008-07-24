Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:48742 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYGXOhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:37:01 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1222650ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 07:37:00 -0700 (PDT)
Message-ID: <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com> (sfid-20080724_163714_033917_8974F697)
Date: Thu, 24 Jul 2008 17:37:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Another fragmentation multiqueue kludge
Cc: "David Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1216908973.13587.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 <1216908973.13587.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 5:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-24 at 16:01 +0300, Tomas Winkler wrote:
>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 2b912cf..db6540e 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -1061,13 +1061,15 @@ static int ieee80211_tx_prepare(struct
>> ieee80211_tx_data *tx,
>>  static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
>>                           struct ieee80211_tx_data *tx)
>>  {
>> -       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> +       struct ieee80211_tx_info *info;
>>         int ret, i;
>>
>> -       if (netif_subqueue_stopped(local->mdev, skb))
>> -               return IEEE80211_TX_AGAIN;
>>
>>         if (skb) {
>> +               if (netif_subqueue_stopped(local->mdev, skb))
>> +                       return IEEE80211_TX_AGAIN;
>> +               info = IEEE80211_SKB_CB(skb);
>> +
>
> This isn't right. It means that if you have a stopped queue and pending
> fragments, you still transmit them, which is not something the driver
> should have to expect.

This logic was wrong you cannot access skb and then ask if'ts not
NULL. (it actually creates nice panic in fragmentation)

>
>>         if (test_bit(queue, local->queues_pending)) {
>> +               /* don't call scheduler just open the queue */
>> +               if (ieee80211_is_multiqueue(local)) {
>> +                       netif_start_subqueue(local->mdev, queue);
>> +               } else {
>> +                       WARN_ON(queue != 0);
>> +                       netif_start_queue(local->mdev);
>> +               }
>>                 tasklet_schedule(&local->tx_pending_tasklet);
>>         } else {
>>                 if (ieee80211_is_multiqueue(local)) {
>
> That's not right either, if you have pending fragments/packets then you
> cannot start the queue.

Exactly this what I wrote are my concern on the other hand
that's the kludge because the __ieee80211_tx checks whether the queue
is started so there is no way
the pending packet is transmitted if you don't start the queue. I have
new version of the patch that starts
the queue only in the tasklet. Tasklet is locks tx so the next packet
will come only after the pending packet is transmitted.

>
> I think what you're trying to do here is implement, in mac80211, to not
> stop queues in the middle of a fragmented MSDU, but you really should do
> that in the driver and we just remove all this code.

I actually can do. I can leave extra 16 TFDs (4 bits for frag num)  in
the queue that wouldn't be a problem, I'm just not sure that iwlwifi
is the only driers that does it.  I didn't encountered such scenario
but this code looks like also non fragments can be put to pending. Am
I wrong?

Thanks
Tomas
