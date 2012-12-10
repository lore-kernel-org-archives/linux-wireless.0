Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37734 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2LJWSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:18:46 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so2170105qaq.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:18:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355176215.3738.102.camel@cumari.coelho.fi>
References: <1354229283-7934-1-git-send-email-arik@wizery.com>
 <1355153582.3738.53.camel@cumari.coelho.fi> <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com>
 <1355176215.3738.102.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 11 Dec 2012 00:18:30 +0200
Message-ID: <CA+XVXffZgF+rJfgrGbq0+D2Y1gx2VmZ1HziD18r9NNwqQ2BVjA@mail.gmail.com> (sfid-20121210_231849_732374_330D6FD8)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 11:50 PM, Luciano Coelho <coelho@ti.com> wrote:
>> we can't use normal since we need to assign the exact same HW queue
>> base to existing interfaces (in case of resume from suspend).
>> Otherwise we'll have a problem, as mac80211 doesn't flush internal
>> packets during suspend. So if we assign a new HW queues
>> to an existing vif we risk stopping/starting the wrong vifs using the
>> ieee80211_queue_xxx APIs.
>
> Isn't the only difference of using _NORMAL that mac80211 won't call the
> iterator function when the driver already knows about the interface?

The other way around - the iterator won't be called for interfaces not
yet added to the driver that already exist in mac80211.

Using the iterator as is, we gain information on which interfaces
mac80211 knows, regardless of the lower driver. So if the current
interface already exists, it means this is recovery/resume.

Actually Johannes came up with this little bit of black magic.

>
>> >> +     if (q_base >= WLCORE_NUM_MAC_ADDRESSES)
>> >> +             return -EBUSY;
>> >> +
>> >> +     wlvif->hw_queue_base = q_base * NUM_TX_QUEUES;
>> >> +     wl1271_debug(DEBUG_MAC80211, "allocating hw queue base: %d",
>> >> +                  wlvif->hw_queue_base);
>> >> +
>> >> +     for (i = 0; i < NUM_TX_QUEUES; i++) {
>> >> +             wl->queue_stop_reasons[wlvif->hw_queue_base + i] = 0;
>> >> +             /* register hw queues in mac80211 */
>> >> +             vif->hw_queue[i] = wlvif->hw_queue_base + i;
>> >> +     }
>> >> +
>> >> +adjust_cab_queue:
>> >> +     /* the last places are reserved for cab queues per interface */
>> >> +     if (wlvif->bss_type == BSS_TYPE_AP_BSS)
>> >> +             vif->cab_queue = NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES +
>> >> +                              wlvif->hw_queue_base / NUM_TX_QUEUES;
>> >> +     else
>> >> +             vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
>> >
>> > Why not keep the reservation per-vif in the same order (ie. the cab
>> > queue comes together with the other queues for that vif)? It doesn't
>> > matter that you don't use the cab_queue for the non AP vifs, since
>> > you're allocating them anyway.
>> >
>> > Keeping them together would make this code clearer.  Just make a macro
>> > NUM_TX_QUEUES_PER_VIF that includes the space for cab_queue.
>>
>> I did it on purpose - that way the functions wlcore_wake_queues and
>> friends can loop on the "real" vifs and stop/start them.
>
> I don't see the difference.  They can still do it all the same.

It's a matter of convenience. It was easier for me to picture the real
HW queues as contiguous and throw the fake ones off to the side.
The off-channel HW queue is also fake (but global) and gets treated the same..

>
>
>> >> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
>> >> index d799fc9..dbc1721 100644
>> >> --- a/drivers/net/wireless/ti/wlcore/tx.c
>> >> +++ b/drivers/net/wireless/ti/wlcore/tx.c
>> >
>> > [...]
>> >
>> >> @@ -1189,44 +1192,45 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
>> >>
>> >> -void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
>> >> -                           enum wlcore_queue_stop_reason reason)
>> >> +void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>> >> +                           u8 queue, enum wlcore_queue_stop_reason reason)
>> >>  {
>> >> -     bool stopped = !!wl->queue_stop_reasons[queue];
>> >> +     int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
>> >
>> > It would look nicer if we moved the "wlvif->hw_queue_base + " to the
>> > wl1271_tx_get_mac80211_queue() function.  After all, the function call
>> > without adding the hw_queue_base doesn't mean anything anymore.
>>
>> well a rename is necessary as well then, since this is not a simple
>> translation between mac8021 and wlcore jargon for queues..
>
> I don't think we need to rename.  I think wl1271_tx_get_mac80211_queue()
> suits very well to include the hw_queue_base.  It would be a more
> complete translation, actually.

I won't press the issue :)

>
>
>> >> @@ -1235,49 +1239,62 @@ out:
>> >>  void wlcore_stop_queues(struct wl1271 *wl,
>> >>                       enum wlcore_queue_stop_reason reason)
>> >>  {
>> >> -     int i;
>> >> +     int i, q_base;
>> >> +     unsigned long flags;
>> >>
>> >> -     for (i = 0; i < NUM_TX_QUEUES; i++)
>> >> -             wlcore_stop_queue(wl, i, reason);
>> >> -}
>> >> -EXPORT_SYMBOL_GPL(wlcore_stop_queues);
>> >> +     spin_lock_irqsave(&wl->wl_lock, flags);
>> >>
>> >> -void wlcore_wake_queues(struct wl1271 *wl,
>> >> -                     enum wlcore_queue_stop_reason reason)
>> >> -{
>> >> -     int i;
>> >> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
>> >> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
>> >> +                     int h = q_base * NUM_TX_QUEUES + i;
>> >> +                     WARN_ON(test_and_set_bit(reason,
>> >> +                                              &wl->queue_stop_reasons[h]));
>> >> +             }
>> >
>> > This looks a bit hacky.  You'll "stop queues" even for vifs that were
>> > not added, won't you? Also, you can do with a single for-loop here ;)
>>
>> there's no harm in setting the bit for queues that were not added, as
>> we zero out all stop reasons when a vif is added. we need to zero-out
>> the reasons anyway in case someone removes a stopped vif..
>
> Yeah, I know there's no harm, but it still looks a bit ugly.  It's
> probably not efficient to iterate over the existing vifs to set the stop
> reasons, but that would look nicer.

Note that "existing" is tricky here as sometimes vifs are removed from
the driver (suspend/recovery) but still exist in mac80211.
So for instance we want to stop all vifs during recovery, and mark all
with stop reasons. That's also the reason I used the mac80211 global
API for stopping/waking the queues.

>
> In any case, if you want a quick and dirty way of doing it without
> caring about the actual vifs, it could be like this:
>
>         for (i = 0; i < WLCORE_NUM_MAC_ADDRESSES * NUM_TX_QUEUES; i++)
>                 WARN_ON(test_and_set_bit(reason,
>                                          &wl->queue_stop_reasons[i]));
>
> Your double-loop would make more sense if the cabs were included in the
> same block per vif, as I suggested, though.

The compiler optimizes away the difference between my code and yours,
and I thought my version was a bit clearer, but yours is ok as well.

>
>
>> > I'm also not sure about the WARN_ON.  If one of the queues is already
>> > stopped, should we really warn? I see that, currently, the reasons to
>> > stop all queues are not used to stop a single queue, but still. :)
>>
>> you're not supposed to use the global API if you've already used a
>> per-vif stop/start API. Generally there are reasons we stop a vif for,
>> and other reasons we stop all vifs for. There should not be an overlap
>> between reasons as that doesn't make sense.
>
> Yes, this makes my statement below more significant. :)
>
>
>> I guess we could convert it to WARN_ON_ONCE though.
>
> Yes, didn't I mention I would convert all WARN_ONs to WARN_ON_ONCEs? Oh,
> well, I meant it anyway. ;)

:)

>
>
>> >
>> > [...]
>> >
>> >> -void wlcore_reset_stopped_queues(struct wl1271 *wl)
>> >> +void wlcore_wake_queues(struct wl1271 *wl,
>> >> +                     enum wlcore_queue_stop_reason reason)
>> >>  {
>> >> -     int i;
>> >> +     int i, q_base;
>> >>       unsigned long flags;
>> >>
>> >>       spin_lock_irqsave(&wl->wl_lock, flags);
>> >>
>> >> -     for (i = 0; i < NUM_TX_QUEUES; i++) {
>> >> -             if (!wl->queue_stop_reasons[i])
>> >> -                     continue;
>> >> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
>> >> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
>> >> +                     int h = q_base * NUM_TX_QUEUES + i;
>> >> +                     WARN_ON(!test_and_clear_bit(reason,
>> >> +                                             &wl->queue_stop_reasons[h]));
>> >> +             }
>> >
>> > Same thing here.  Actually, wouldn't it make more sense to have a
>> > separate bitmask for the "full-stops"? In that way, at least it would be
>> > very clear that the full-stop reasons (eg. flush, restart...) cannot be
>> > used with single queues.
>>
>> I think the WARN_ON separates this quite well already, I would prefer
>> to avoid the extra complexity. Again this can be converted to
>> WARN_ON_ONCE, since WARN_ON is frowned upon (and rightly so).
>
> A WARN_ON separates it only at runtime.  We could miss it if the exact
> combination of factors don't happen during testing.  If we would
> separate them, we could also have a global all_queues_stop_reason
> instead of going through all the queues and marking them. ;)

I guess it's a good point. But I think this should be in a separate
patch. This is not directly related to this one and would complicate
it as is.
