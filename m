Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37292 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbcDFFft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 01:35:49 -0400
Received: by mail-wm0-f53.google.com with SMTP id n3so47282112wmn.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 22:35:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459864656.18188.60.camel@sipsolutions.net>
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	<1459864656.18188.60.camel@sipsolutions.net>
Date: Wed, 6 Apr 2016 07:35:47 +0200
Message-ID: <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com> (sfid-20160406_073553_664985_3D5F3522)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 April 2016 at 15:57, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-03-31 at 12:28 +0200, Michal Kazior wrote:
>
>> +++ b/net/mac80211/codel.h
>> +++ b/net/mac80211/codel_i.h
>
> Do we really need all this code in .h files? It seems very odd to me to
> have all the algorithm implementation there rather than a C file, you
> should (can?) only include codel.h into a single C file anyway.

I just wanted to follow the suggested/implied usage of codel code and
keep modifications to a minimum. I could very well just assimilate it
if you wish.


>>  struct txq_info {
>> -     struct sk_buff_head queue;
>> +     struct txq_flow flow;
>> +     struct list_head new_flows;
>> +     struct list_head old_flows;
>
> This is confusing, can you please document that? Why are there two
> lists of flows, *and* an embedded flow? Is the embedded flow on any of
> the lists?

The new/old flows is follows the same principle as net/sched/sch_fq_codel.c

The embedded flow is for possible collisions, explained below.

Nevertheless I'll add more comments on what-is-what-and-why.


>> +     u32 backlog_bytes;
>> +     u32 backlog_packets;
>> +     u32 drop_codel;
>
> Would it make some sense to at least conceptually layer this a bit?
> I.e. rather than calling this "drop_codel" call it "drop_congestion" or
> something like that?

Sure, I'll change it.


>> +/**
>> + * struct txq_flow - per traffic flow queue
>> + *
>> + * This structure is used to distinguish and queue different traffic flows
>> + * separately for fair queueing/AQM purposes.
>> + *
>> + * @txqi: txq_info structure it is associated at given time
>
> Do we actually have to keep that? It's on a list per txqi, no?

It's used to track ownership.

Packets can be destined to different stations/txqs. At enqueue time I
do a partial hash of a packet to get an "index" which I then use to
address a txq_flow from per-radio list (out of 4096 of them). You can
end up with a situtation like this:
 - packet A hashing to X destined to txq P which is VI
 - packet B hashing to X destined to txq Q which is BK

You can't use the same txq_flow for both A and B because you want to
maintain packets per txqs more than you want to maintain them per flow
(you don't want to queue BK traffic onto VI or vice versa as an
artifact, do you? ;). When a txq_flow doesn't have a txqi it is bound.
Later, if a collision happens (i.e. resulting txq_flow has non-NULL
txqi) the "embedded" per-txq flow is used:

  struct txq_info {
 -     struct sk_buff_head queue;
 +     struct txq_flow flow; // <--- this

When txq_flow becomes empty its txqi is reset.

The embedded flow is otherwise treated like any other flow, i.e. it
can be linked to old_flows and new_flows.


>> + * @flowchain: can be linked to other flows for RR purposes
>
> RR?

Round-robin. Assuming it's correct to call fq_codel an RR scheme?



>> +void ieee80211_teardown_flows(struct ieee80211_local *local)
>> +{
>> +     struct ieee80211_fq *fq = &local->fq;
>> +     struct ieee80211_sub_if_data *sdata;
>> +     struct sta_info *sta;
>> +     int i;
>> +
>> +     if (!local->ops->wake_tx_queue)
>> +             return;
>> +
>> +     list_for_each_entry_rcu(sta, &local->sta_list, list)
>> +             for (i = 0; i < IEEE80211_NUM_TIDS; i++)
>> +                     ieee80211_purge_txq(local,
>> +                                         to_txq_info(sta->sta.txq[i]));
>> +
>> +     list_for_each_entry_rcu(sdata, &local->interfaces, list)
>> +             ieee80211_purge_txq(local, to_txq_info(sdata->vif.txq));
>
> Using RCU iteration here seems rather strange, since it's a teardown
> flow? That doesn't seem necessary, since it's control path and must be
> holding appropriate locks anyway to make sure nothing is added to the
> lists.

You're probably right. I'll look into changing it.


>
>> +     skb = codel_dequeue(flow,
>> +                         &flow->backlog,
>> +                         0,
>> +                         &flow->cvars,
>> +                         &fq->cparams,
>> +                         codel_get_time(),
>> +                         false);
>
> What happened here? :)

I'm not a huge fan of wrapping functions with a lot of (ugly-looking)
arguments. I can make it a different ugly if you want :)


>> +     if (!skb) {
>> +             if ((head == &txqi->new_flows) &&
>> +                 !list_empty(&txqi->old_flows)) {
>> +                     list_move_tail(&flow->flowchain, &txqi->old_flows);
>> +             } else {
>> +                     list_del_init(&flow->flowchain);
>> +                     flow->txqi = NULL;
>> +             }
>> +             goto begin;
>> +     }
>
> Ouch. Any way you can make that easier to follow?

This follows net/sched/sch_fq_codel.h. I can put up a comment to
explain what it's supposed to do?


Michał
