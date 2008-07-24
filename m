Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:20964 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbYGXOzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:55:48 -0400
Received: by py-out-1112.google.com with SMTP id p76so2123166pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 07:55:47 -0700 (PDT)
Message-ID: <1ba2fa240807240755o25889a9fy50d20e298beb14b0@mail.gmail.com> (sfid-20080724_165618_294799_4B8AF8DA)
Date: Thu, 24 Jul 2008 17:55:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Another fragmentation multiqueue kludge
Cc: "David Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1216910776.13587.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 <1216908973.13587.65.camel@johannes.berg>
	 <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com>
	 <1216910776.13587.74.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 5:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-24 at 17:37 +0300, Tomas Winkler wrote:
>
>> >> -       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> >> +       struct ieee80211_tx_info *info;
>> >>         int ret, i;
>> >>
>> >> -       if (netif_subqueue_stopped(local->mdev, skb))
>> >> -               return IEEE80211_TX_AGAIN;
>> >>
>> >>         if (skb) {
>> >> +               if (netif_subqueue_stopped(local->mdev, skb))
>> >> +                       return IEEE80211_TX_AGAIN;
>> >> +               info = IEEE80211_SKB_CB(skb);
>> >> +
>> >
>> > This isn't right. It means that if you have a stopped queue and pending
>> > fragments, you still transmit them, which is not something the driver
>> > should have to expect.
>>
>> This logic was wrong you cannot access skb and then ask if'ts not
>> NULL. (it actually creates nice panic in fragmentation)
>
> Oh, indeed, and since the same check is actually in the if
> (tx->extra_frag) part, this is fine.
>
>> >>         if (test_bit(queue, local->queues_pending)) {
>> >> +               /* don't call scheduler just open the queue */
>> >> +               if (ieee80211_is_multiqueue(local)) {
>> >> +                       netif_start_subqueue(local->mdev, queue);
>> >> +               } else {
>> >> +                       WARN_ON(queue != 0);
>> >> +                       netif_start_queue(local->mdev);
>> >> +               }
>> >>                 tasklet_schedule(&local->tx_pending_tasklet);
>> >>         } else {
>> >>                 if (ieee80211_is_multiqueue(local)) {
>> >
>> > That's not right either, if you have pending fragments/packets then you
>> > cannot start the queue.
>>
>> Exactly this what I wrote are my concern on the other hand
>> that's the kludge because the __ieee80211_tx checks whether the queue
>> is started so there is no way
>> the pending packet is transmitted if you don't start the queue. I have
>> new version of the patch that starts
>> the queue only in the tasklet. Tasklet is locks tx so the next packet
>> will come only after the pending packet is transmitted.
>
> What happens if you just invert the
>                if (__netif_subqueue_stopped(local->mdev, i))
>                        continue;

> check in ieee80211_tx_pending to read
>                if (!__netif_subqueue_stopped(local->mdev, i))
>                        continue;
>
> as I suggested yesterday?

This is wrong since you it will actually starts queues that driver
didn't ask to start in the next line.



>> I actually can do. I can leave extra 16 TFDs (4 bits for frag num)  in
>> the queue that wouldn't be a problem, I'm just not sure that iwlwifi
>> is the only driers that does it.  I didn't encountered such scenario
>> but this code looks like also non fragments can be put to pending. Am
>> I wrong?
>
> non-fragments can only be put in there if your driver is buggy, because
> if you don't have fragmentation turned on then you should know when your
> queue is filling up and be able to stop it before you get another frame.
>

As I see it any failure in the driver's tx path will cause moving to
pending queue, except packets on AMPDU
queues that will be dropped.

         ret = __ieee80211_tx(local, skb, &tx);
	if (ret) {
		struct ieee80211_tx_stored_packet *store;

		/*
		 * Since there are no fragmented frames on A-MPDU
		 * queues, there's no reason for a driver to reject
		 * a frame there, warn and drop it.
		 */
		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
			goto drop;

		store = &local->pending_packet[queue];

> The problem with fragmentation is that mac80211 creates multiple frames
> from a single one, while if you don't have fragmentation that doesn't
> happen since once you stop the queue there are no pending packets.

That's correct for stopping because of queue overhead, not for errors.

> If we require drivers to always keep space for 8 or 9 fragments then we
> can remove all this requeuing stuff, the only trouble with that may be
> in adm8211 since that has to send frames one by one, but we can fix it
> in that driver, it only has a single queue so it's much easier.

So till someone fix adm driver consider this patch It worked quite
well. I will also send patch that fixes the behavior in the iwlwifi
driver.

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3ac23b8..98e0283 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -580,6 +580,7 @@ struct ieee80211_local {
        struct timer_list sta_cleanup;

        unsigned long queues_pending[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
+       unsigned long queues_pending_run[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
        struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
        struct tasklet_struct tx_pending_tasklet;

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2b912cf..4d9f9cb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1061,13 +1061,15 @@ static int ieee80211_tx_prepare(struct
ieee80211_tx_data *tx,
 static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
                          struct ieee80211_tx_data *tx)
 {
-       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+       struct ieee80211_tx_info *info;
        int ret, i;

-       if (netif_subqueue_stopped(local->mdev, skb))
-               return IEEE80211_TX_AGAIN;

        if (skb) {
+               if (netif_subqueue_stopped(local->mdev, skb))
+                       return IEEE80211_TX_AGAIN;
+               info =  IEEE80211_SKB_CB(skb);
+
                ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
                                     "TX to low-level driver", skb);
                ret = local->ops->tx(local_to_hw(local), skb);
@@ -1721,14 +1725,19 @@ void ieee80211_tx_pending(unsigned long data)
        netif_tx_lock_bh(dev);
        for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
                /* Check that this queue is ok */
-               if (__netif_subqueue_stopped(local->mdev, i))
+               if (__netif_subqueue_stopped(local->mdev, i) &&
+                   !test_bit(i, local->queues_pending_run))
                        continue;

                if (!test_bit(i, local->queues_pending)) {
+                       clear_bit(i, local->queues_pending_run);
                        ieee80211_wake_queue(&local->hw, i);
                        continue;
                }

+               clear_bit(i, local->queues_pending_run);
+               netif_start_subqueue(local->mdev, i);
+
                store = &local->pending_packet[i];

               tx.extra_frag = store->extra_frag;
                tx.num_extra_frag = store->num_extra_frag;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89ce4e0..02af3e8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -361,6 +361,7 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw,
int queue)
        struct ieee80211_local *local = hw_to_local(hw);

        if (test_bit(queue, local->queues_pending)) {
+               set_bit(queue, local->queues_pending_run);
                tasklet_schedule(&local->tx_pending_tasklet);
        } else {
                if (ieee80211_is_multiqueue(local)) {
-- 
1.5.4.1

Tomas.
