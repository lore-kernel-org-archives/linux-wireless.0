Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:35433 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbZGHRCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 13:02:53 -0400
Received: by yxe26 with SMTP id 26so8137767yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2009 10:02:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247049613.4755.65.camel@johannes.local>
References: <1247032403-8312-1-git-send-email-javier@cozybit.com>
	 <1247049613.4755.65.camel@johannes.local>
Date: Wed, 8 Jul 2009 10:02:50 -0700
Message-ID: <445f43ac0907081002i50c23aeelc2e52d6082f7c9af@mail.gmail.com>
Subject: Re: [PATCH] Assign next hop address to pending mesh frames once the
	path is resolved.
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Wed, Jul 8, 2009 at 3:40 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-07-07 at 22:53 -0700, Javier Cardona wrote:
>> Regression.  Frames transmitted when a mesh path was wating to be resolved were
>> being transmitted with an invalid Receiver Address.
>
>> -     rcu_assign_pointer(mpath->next_hop, sta);
>> +     struct sk_buff *skb, *skb_first = NULL;
>> +     struct ieee80211_hdr *hdr;
>> +
>> +     rcu_read_lock();
>> +     mpath->next_hop = sta;
>> +
>> +     while ((skb = skb_dequeue(&mpath->frame_queue)) != skb_first) {
>> +             if (!skb_first)
>> +                     skb_first = skb;
>> +             hdr = (struct ieee80211_hdr *) skb->data;
>> +             memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
>> +             skb_queue_tail(&mpath->frame_queue, skb);
>> +     }
>> +     if (skb_first)
>> +             skb_queue_tail(&mpath->frame_queue, skb_first);
>> +
>> +     rcu_read_unlock();
>
> Since skb queues have a locks, why use rcu too?

The some mpath members are rcu protected.  I thought I had to extend
the rcu section to cover both mpath->next_hop and mpath->frame_queue.
But now I see that the latter does not need protection, so I'll revert
that to just rcu_assign_pointer(mpath->next_hop, sta);

> Also I think you should probably use a different pattern -- this looks
> prone to breakage, maybe something like
>
>        sk_buff_head tmpq;
>        unsigned long flags;
>
>        __skb_queue_head_init(&tmpq);
>
>        spin_lock_irqsave(&frame_queue->lock);
>
>        while (skb = __skb_dequeue(&frame_queue)) {
>                hdr = (struct ieee80211_hdr *) skb->data;
>                memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
>                __skb_queue_tail(&tmpq, skb);
>        }
>
>        skb_queue_splice(&tmpq, frame_queue);
>        spin_unlock_irqrestore(&frame_queue->lock);

Oh, nice, cleaner and less locking. v2 will follow shortly.

Thanks!

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
