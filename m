Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33532 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2LJSAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 13:00:03 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1667228qcr.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 10:00:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355153582.3738.53.camel@cumari.coelho.fi>
References: <1354229283-7934-1-git-send-email-arik@wizery.com> <1355153582.3738.53.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 10 Dec 2012 19:59:46 +0200
Message-ID: <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com> (sfid-20121210_190008_655746_5DC5CDF5)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 5:33 PM, Luciano Coelho <coelho@ti.com> wrote:
>> +     __set_bit(vif->hw_queue[0] / NUM_TX_QUEUES, iter_data->hw_queue_map);
>> +}
>
> Can't you just use an int to pass the q_base that you use below? Am I
> missing something or are you just using the bitmap to pass the vif
> number?

That's not the case. I'm using all the bits marked. There's a special
case where the vif already exists in mac80211, we don't allocate a new
HW-queue-base and just use the existing one in vif->hw_queue_base.

>
>
>> +static int wlcore_allocate_hw_queue_base(struct wl1271 *wl,
>> +                                      struct wl12xx_vif *wlvif)
>> +{
>> +     struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
>> +     struct wlcore_hw_queue_iter_data iter_data = {};
>> +     int i, q_base;
>> +
>> +     iter_data.vif = vif;
>> +
>> +     /* mark all bits taken by active interfaces */
>> +     ieee80211_iterate_active_interfaces_atomic(wl->hw,
>> +                                     IEEE80211_IFACE_ITER_RESUME_ALL,
>> +                                     wlcore_hw_queue_iter, &iter_data);
>
> The comment here is misleading.  You don't really mark all bits, you
> mark bits one by one.  This iteration will only set a single bit.

The iteration will set several bits, one for each active interface.
Note that cur_running = true in the iterator is a special case in
suspend/resume, usually in suspend/resume. We don't have cur_running =
true when a new interface is added.

>
>
>> /+    /* the current vif is already running in mac80211 (resume/recovery) */
>> +     if (iter_data.cur_running) {
>> +             wlvif->hw_queue_base = vif->hw_queue[0];
>> +             wl1271_debug(DEBUG_MAC80211,
>> +                          "using pre-allocated hw queue base %d",
>> +                          wlvif->hw_queue_base);
>> +
>> +             /* interface type might have changed type */
>> +             goto adjust_cab_queue;
>> +     }
>
> This can probably be avoided with the new IEEE80211_IFACE_ITER_NORMAL,
> can't it?

we can't use normal since we need to assign the exact same HW queue
base to existing interfaces (in case of resume from suspend).
Otherwise we'll have a problem, as mac80211 doesn't flush internal
packets during suspend. So if we assign a new HW queues
to an existing vif we risk stopping/starting the wrong vifs using the
ieee80211_queue_xxx APIs.

>
>
>> +     q_base = find_first_zero_bit(iter_data.hw_queue_map,
>> +                                  WLCORE_NUM_MAC_ADDRESSES);
>> +     if (q_base >= WLCORE_NUM_MAC_ADDRESSES)
>> +             return -EBUSY;
>> +
>> +     wlvif->hw_queue_base = q_base * NUM_TX_QUEUES;
>> +     wl1271_debug(DEBUG_MAC80211, "allocating hw queue base: %d",
>> +                  wlvif->hw_queue_base);
>> +
>> +     for (i = 0; i < NUM_TX_QUEUES; i++) {
>> +             wl->queue_stop_reasons[wlvif->hw_queue_base + i] = 0;
>> +             /* register hw queues in mac80211 */
>> +             vif->hw_queue[i] = wlvif->hw_queue_base + i;
>> +     }
>> +
>> +adjust_cab_queue:
>> +     /* the last places are reserved for cab queues per interface */
>> +     if (wlvif->bss_type == BSS_TYPE_AP_BSS)
>> +             vif->cab_queue = NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES +
>> +                              wlvif->hw_queue_base / NUM_TX_QUEUES;
>> +     else
>> +             vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
>
> Why not keep the reservation per-vif in the same order (ie. the cab
> queue comes together with the other queues for that vif)? It doesn't
> matter that you don't use the cab_queue for the non AP vifs, since
> you're allocating them anyway.
>
> Keeping them together would make this code clearer.  Just make a macro
> NUM_TX_QUEUES_PER_VIF that includes the space for cab_queue.

I did it on purpose - that way the functions wlcore_wake_queues and
friends can loop on the "real" vifs and stop/start them.

>
>
>> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
>> index d799fc9..dbc1721 100644
>> --- a/drivers/net/wireless/ti/wlcore/tx.c
>> +++ b/drivers/net/wireless/ti/wlcore/tx.c
>
> [...]
>
>> @@ -1189,44 +1192,45 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
>>  }
>>  EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
>>
>> -void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
>> -                           enum wlcore_queue_stop_reason reason)
>> +void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>> +                           u8 queue, enum wlcore_queue_stop_reason reason)
>>  {
>> -     bool stopped = !!wl->queue_stop_reasons[queue];
>> +     int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
>
> It would look nicer if we moved the "wlvif->hw_queue_base + " to the
> wl1271_tx_get_mac80211_queue() function.  After all, the function call
> without adding the hw_queue_base doesn't mean anything anymore.

well a rename is necessary as well then, since this is not a simple
translation between mac8021 and wlcore jargon for queues..

>
> I'll change this when applying.
>
>
>> -void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
>> +void wlcore_wake_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
>>                      enum wlcore_queue_stop_reason reason)
>>  {
>>       unsigned long flags;
>> +     int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
>>
>>       spin_lock_irqsave(&wl->wl_lock, flags);
>> -
>
> Stray line removal, I'll insert it back.

thanks.

>
> [...]
>
>> @@ -1235,49 +1239,62 @@ out:
>>  void wlcore_stop_queues(struct wl1271 *wl,
>>                       enum wlcore_queue_stop_reason reason)
>>  {
>> -     int i;
>> +     int i, q_base;
>> +     unsigned long flags;
>>
>> -     for (i = 0; i < NUM_TX_QUEUES; i++)
>> -             wlcore_stop_queue(wl, i, reason);
>> -}
>> -EXPORT_SYMBOL_GPL(wlcore_stop_queues);
>> +     spin_lock_irqsave(&wl->wl_lock, flags);
>>
>> -void wlcore_wake_queues(struct wl1271 *wl,
>> -                     enum wlcore_queue_stop_reason reason)
>> -{
>> -     int i;
>> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
>> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
>> +                     int h = q_base * NUM_TX_QUEUES + i;
>> +                     WARN_ON(test_and_set_bit(reason,
>> +                                              &wl->queue_stop_reasons[h]));
>> +             }
>
> This looks a bit hacky.  You'll "stop queues" even for vifs that were
> not added, won't you? Also, you can do with a single for-loop here ;)

there's no harm in setting the bit for queues that were not added, as
we zero out all stop reasons when a vif is added. we need to zero-out
the reasons anyway in case someone removes a stopped vif..

>
> I'm also not sure about the WARN_ON.  If one of the queues is already
> stopped, should we really warn? I see that, currently, the reasons to
> stop all queues are not used to stop a single queue, but still. :)

you're not supposed to use the global API if you've already used a
per-vif stop/start API. Generally there are reasons we stop a vif for,
and other reasons we stop all vifs for. There should not be an overlap
between reasons as that doesn't make sense.
I guess we could convert it to WARN_ON_ONCE though.

>
> [...]
>
>> -void wlcore_reset_stopped_queues(struct wl1271 *wl)
>> +void wlcore_wake_queues(struct wl1271 *wl,
>> +                     enum wlcore_queue_stop_reason reason)
>>  {
>> -     int i;
>> +     int i, q_base;
>>       unsigned long flags;
>>
>>       spin_lock_irqsave(&wl->wl_lock, flags);
>>
>> -     for (i = 0; i < NUM_TX_QUEUES; i++) {
>> -             if (!wl->queue_stop_reasons[i])
>> -                     continue;
>> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
>> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
>> +                     int h = q_base * NUM_TX_QUEUES + i;
>> +                     WARN_ON(!test_and_clear_bit(reason,
>> +                                             &wl->queue_stop_reasons[h]));
>> +             }
>
> Same thing here.  Actually, wouldn't it make more sense to have a
> separate bitmask for the "full-stops"? In that way, at least it would be
> very clear that the full-stop reasons (eg. flush, restart...) cannot be
> used with single queues.

I think the WARN_ON separates this quite well already, I would prefer
to avoid the extra complexity. Again this can be converted to
WARN_ON_ONCE, since WARN_ON is frowned upon (and rightly so).

Arik
