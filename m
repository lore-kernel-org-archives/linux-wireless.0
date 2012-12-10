Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LJVvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:51:00 -0500
Message-ID: <1355176215.3738.102.camel@cumari.coelho.fi> (sfid-20121210_225104_649951_40FCC993)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 10 Dec 2012 23:50:15 +0200
In-Reply-To: <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com>
References: <1354229283-7934-1-git-send-email-arik@wizery.com>
	 <1355153582.3738.53.camel@cumari.coelho.fi>
	 <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 19:59 +0200, Arik Nemtsov wrote:
> On Mon, Dec 10, 2012 at 5:33 PM, Luciano Coelho <coelho@ti.com> wrote:
> > +static void wlcore_hw_queue_iter(void *data, u8 *mac,
> > +                              struct ieee80211_vif *vif)
> > +{
> > +     struct wlcore_hw_queue_iter_data *iter_data = data;
> > +
> > +     if (WARN_ON(vif->hw_queue[0] == IEEE80211_INVAL_HW_QUEUE))
> > +             return;
> > +
> > +     if (iter_data->cur_running || vif == iter_data->vif) {
> > +             iter_data->cur_running = true;
> > +             return;
> > +     }
> > +
> > +     __set_bit(vif->hw_queue[0] / NUM_TX_QUEUES, iter_data->hw_queue_map);
> > +}
> >
> > Can't you just use an int to pass the q_base that you use below? Am I
> > missing something or are you just using the bitmap to pass the vif
> > number?
> 
> That's not the case. I'm using all the bits marked. There's a special
> case where the vif already exists in mac80211, we don't allocate a new
> HW-queue-base and just use the existing one in vif->hw_queue_base.

Okay, I see.


> >> +static int wlcore_allocate_hw_queue_base(struct wl1271 *wl,
> >> +                                      struct wl12xx_vif *wlvif)
> >> +{
> >> +     struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
> >> +     struct wlcore_hw_queue_iter_data iter_data = {};
> >> +     int i, q_base;
> >> +
> >> +     iter_data.vif = vif;
> >> +
> >> +     /* mark all bits taken by active interfaces */
> >> +     ieee80211_iterate_active_interfaces_atomic(wl->hw,
> >> +                                     IEEE80211_IFACE_ITER_RESUME_ALL,
> >> +                                     wlcore_hw_queue_iter, &iter_data);
> >
> > The comment here is misleading.  You don't really mark all bits, you
> > mark bits one by one.  This iteration will only set a single bit.
> 
> The iteration will set several bits, one for each active interface.
> Note that cur_running = true in the iterator is a special case in
> suspend/resume, usually in suspend/resume. We don't have cur_running =
> true when a new interface is added.

Now I get it.  This function is called with supposedly a new vif (which
it is in most cases).  Only in this special case the list of "active"
interfaces in mac80211 will contain the one that is being added...


> >> /+    /* the current vif is already running in mac80211 (resume/recovery) */
> >> +     if (iter_data.cur_running) {
> >> +             wlvif->hw_queue_base = vif->hw_queue[0];
> >> +             wl1271_debug(DEBUG_MAC80211,
> >> +                          "using pre-allocated hw queue base %d",
> >> +                          wlvif->hw_queue_base);
> >> +
> >> +             /* interface type might have changed type */
> >> +             goto adjust_cab_queue;
> >> +     }
> >
> > This can probably be avoided with the new IEEE80211_IFACE_ITER_NORMAL,
> > can't it?
> 
> we can't use normal since we need to assign the exact same HW queue
> base to existing interfaces (in case of resume from suspend).
> Otherwise we'll have a problem, as mac80211 doesn't flush internal
> packets during suspend. So if we assign a new HW queues
> to an existing vif we risk stopping/starting the wrong vifs using the
> ieee80211_queue_xxx APIs.

Isn't the only difference of using _NORMAL that mac80211 won't call the
iterator function when the driver already knows about the interface?

Or is this happening too late here, because when mac80211 calls the
add_interface op it already considers that the driver knows about it?


> >> +     q_base = find_first_zero_bit(iter_data.hw_queue_map,
> >> +                                  WLCORE_NUM_MAC_ADDRESSES);

Okay, this is what confused me.  For some reason I interpreted this call
as find_first_bit() instead.


> >> +     if (q_base >= WLCORE_NUM_MAC_ADDRESSES)
> >> +             return -EBUSY;
> >> +
> >> +     wlvif->hw_queue_base = q_base * NUM_TX_QUEUES;
> >> +     wl1271_debug(DEBUG_MAC80211, "allocating hw queue base: %d",
> >> +                  wlvif->hw_queue_base);
> >> +
> >> +     for (i = 0; i < NUM_TX_QUEUES; i++) {
> >> +             wl->queue_stop_reasons[wlvif->hw_queue_base + i] = 0;
> >> +             /* register hw queues in mac80211 */
> >> +             vif->hw_queue[i] = wlvif->hw_queue_base + i;
> >> +     }
> >> +
> >> +adjust_cab_queue:
> >> +     /* the last places are reserved for cab queues per interface */
> >> +     if (wlvif->bss_type == BSS_TYPE_AP_BSS)
> >> +             vif->cab_queue = NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES +
> >> +                              wlvif->hw_queue_base / NUM_TX_QUEUES;
> >> +     else
> >> +             vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;
> >
> > Why not keep the reservation per-vif in the same order (ie. the cab
> > queue comes together with the other queues for that vif)? It doesn't
> > matter that you don't use the cab_queue for the non AP vifs, since
> > you're allocating them anyway.
> >
> > Keeping them together would make this code clearer.  Just make a macro
> > NUM_TX_QUEUES_PER_VIF that includes the space for cab_queue.
> 
> I did it on purpose - that way the functions wlcore_wake_queues and
> friends can loop on the "real" vifs and stop/start them.

I don't see the difference.  They can still do it all the same.


> >> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
> >> index d799fc9..dbc1721 100644
> >> --- a/drivers/net/wireless/ti/wlcore/tx.c
> >> +++ b/drivers/net/wireless/ti/wlcore/tx.c
> >
> > [...]
> >
> >> @@ -1189,44 +1192,45 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
> >>  }
> >>  EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
> >>
> >> -void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
> >> -                           enum wlcore_queue_stop_reason reason)
> >> +void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
> >> +                           u8 queue, enum wlcore_queue_stop_reason reason)
> >>  {
> >> -     bool stopped = !!wl->queue_stop_reasons[queue];
> >> +     int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
> >
> > It would look nicer if we moved the "wlvif->hw_queue_base + " to the
> > wl1271_tx_get_mac80211_queue() function.  After all, the function call
> > without adding the hw_queue_base doesn't mean anything anymore.
> 
> well a rename is necessary as well then, since this is not a simple
> translation between mac8021 and wlcore jargon for queues..

I don't think we need to rename.  I think wl1271_tx_get_mac80211_queue()
suits very well to include the hw_queue_base.  It would be a more
complete translation, actually.


> >> @@ -1235,49 +1239,62 @@ out:
> >>  void wlcore_stop_queues(struct wl1271 *wl,
> >>                       enum wlcore_queue_stop_reason reason)
> >>  {
> >> -     int i;
> >> +     int i, q_base;
> >> +     unsigned long flags;
> >>
> >> -     for (i = 0; i < NUM_TX_QUEUES; i++)
> >> -             wlcore_stop_queue(wl, i, reason);
> >> -}
> >> -EXPORT_SYMBOL_GPL(wlcore_stop_queues);
> >> +     spin_lock_irqsave(&wl->wl_lock, flags);
> >>
> >> -void wlcore_wake_queues(struct wl1271 *wl,
> >> -                     enum wlcore_queue_stop_reason reason)
> >> -{
> >> -     int i;
> >> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
> >> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
> >> +                     int h = q_base * NUM_TX_QUEUES + i;
> >> +                     WARN_ON(test_and_set_bit(reason,
> >> +                                              &wl->queue_stop_reasons[h]));
> >> +             }
> >
> > This looks a bit hacky.  You'll "stop queues" even for vifs that were
> > not added, won't you? Also, you can do with a single for-loop here ;)
> 
> there's no harm in setting the bit for queues that were not added, as
> we zero out all stop reasons when a vif is added. we need to zero-out
> the reasons anyway in case someone removes a stopped vif..

Yeah, I know there's no harm, but it still looks a bit ugly.  It's
probably not efficient to iterate over the existing vifs to set the stop
reasons, but that would look nicer.

In any case, if you want a quick and dirty way of doing it without
caring about the actual vifs, it could be like this:

	for (i = 0; i < WLCORE_NUM_MAC_ADDRESSES * NUM_TX_QUEUES; i++)
		WARN_ON(test_and_set_bit(reason,
					 &wl->queue_stop_reasons[i]));

Your double-loop would make more sense if the cabs were included in the
same block per vif, as I suggested, though.


> > I'm also not sure about the WARN_ON.  If one of the queues is already
> > stopped, should we really warn? I see that, currently, the reasons to
> > stop all queues are not used to stop a single queue, but still. :)
> 
> you're not supposed to use the global API if you've already used a
> per-vif stop/start API. Generally there are reasons we stop a vif for,
> and other reasons we stop all vifs for. There should not be an overlap
> between reasons as that doesn't make sense.

Yes, this makes my statement below more significant. :)


> I guess we could convert it to WARN_ON_ONCE though.

Yes, didn't I mention I would convert all WARN_ONs to WARN_ON_ONCEs? Oh,
well, I meant it anyway. ;)


> >
> > [...]
> >
> >> -void wlcore_reset_stopped_queues(struct wl1271 *wl)
> >> +void wlcore_wake_queues(struct wl1271 *wl,
> >> +                     enum wlcore_queue_stop_reason reason)
> >>  {
> >> -     int i;
> >> +     int i, q_base;
> >>       unsigned long flags;
> >>
> >>       spin_lock_irqsave(&wl->wl_lock, flags);
> >>
> >> -     for (i = 0; i < NUM_TX_QUEUES; i++) {
> >> -             if (!wl->queue_stop_reasons[i])
> >> -                     continue;
> >> +     for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
> >> +             for (i = 0; i < NUM_TX_QUEUES; i++) {
> >> +                     int h = q_base * NUM_TX_QUEUES + i;
> >> +                     WARN_ON(!test_and_clear_bit(reason,
> >> +                                             &wl->queue_stop_reasons[h]));
> >> +             }
> >
> > Same thing here.  Actually, wouldn't it make more sense to have a
> > separate bitmask for the "full-stops"? In that way, at least it would be
> > very clear that the full-stop reasons (eg. flush, restart...) cannot be
> > used with single queues.
> 
> I think the WARN_ON separates this quite well already, I would prefer
> to avoid the extra complexity. Again this can be converted to
> WARN_ON_ONCE, since WARN_ON is frowned upon (and rightly so).

A WARN_ON separates it only at runtime.  We could miss it if the exact
combination of factors don't happen during testing.  If we would
separate them, we could also have a global all_queues_stop_reason
instead of going through all the queues and marking them. ;)

--
Luca.

