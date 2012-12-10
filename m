Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2LJPdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:33:46 -0500
Message-ID: <1355153582.3738.53.camel@cumari.coelho.fi> (sfid-20121210_163350_422583_FEFB47D6)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 10 Dec 2012 17:33:02 +0200
In-Reply-To: <1354229283-7934-1-git-send-email-arik@wizery.com>
References: <1354229283-7934-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 00:48 +0200, Arik Nemtsov wrote:
> Start using the new hw_queue mechanism in mac80211 and give each AC in
> each vif its own hw_queue number. This allows us to stop an AC in a vif
> independently from other vifs.
> 
> Change the Tx watermark handling functions to count packets per AC in
> vif. From now on fast links should not be able to hurt the throughput
> of slow links on the same AC but on different vifs.
> 
> Change internal queue mgmt functions to operate per vif, to support the
> new Tx watermark granularity. Make the global versions of the queue
> stop/start functions to use the global mac80211 API for queue mgmt. This
> helps in situations where the driver currently doesn't know all the vifs
> that reside in mac80211. Recovery is a good example for such a case.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> v2: move to new vif iterator API

Thanks for respinning! :)


> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 15631fa..c9fb441 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c

[...]

> @@ -2313,6 +2313,81 @@ static void wl12xx_force_active_psm(struct wl1271 *wl)
>  	}
>  }
>  
> +struct wlcore_hw_queue_iter_data {
> +	unsigned long hw_queue_map[BITS_TO_LONGS(WLCORE_NUM_MAC_ADDRESSES)];
> +	/* current vif */
> +	struct ieee80211_vif *vif;
> +	/* is the current vif among those iterated */
> +	bool cur_running;
> +};
> +
> +static void wlcore_hw_queue_iter(void *data, u8 *mac,
> +				 struct ieee80211_vif *vif)
> +{
> +	struct wlcore_hw_queue_iter_data *iter_data = data;
> +
> +	if (WARN_ON(vif->hw_queue[0] == IEEE80211_INVAL_HW_QUEUE))
> +		return;
> +
> +	if (iter_data->cur_running || vif == iter_data->vif) {
> +		iter_data->cur_running = true;
> +		return;
> +	}
> +
> +	__set_bit(vif->hw_queue[0] / NUM_TX_QUEUES, iter_data->hw_queue_map);
> +}

Can't you just use an int to pass the q_base that you use below? Am I
missing something or are you just using the bitmap to pass the vif
number?


> +static int wlcore_allocate_hw_queue_base(struct wl1271 *wl,
> +					 struct wl12xx_vif *wlvif)
> +{
> +	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
> +	struct wlcore_hw_queue_iter_data iter_data = {};
> +	int i, q_base;
> +
> +	iter_data.vif = vif;
> +
> +	/* mark all bits taken by active interfaces */
> +	ieee80211_iterate_active_interfaces_atomic(wl->hw,
> +					IEEE80211_IFACE_ITER_RESUME_ALL,
> +					wlcore_hw_queue_iter, &iter_data);

The comment here is misleading.  You don't really mark all bits, you
mark bits one by one.  This iteration will only set a single bit.


> /+	/* the current vif is already running in mac80211 (resume/recovery) */
> +	if (iter_data.cur_running) {
> +		wlvif->hw_queue_base = vif->hw_queue[0];
> +		wl1271_debug(DEBUG_MAC80211,
> +			     "using pre-allocated hw queue base %d",
> +			     wlvif->hw_queue_base);
> +
> +		/* interface type might have changed type */
> +		goto adjust_cab_queue;
> +	}

This can probably be avoided with the new IEEE80211_IFACE_ITER_NORMAL,
can't it?


> +	q_base = find_first_zero_bit(iter_data.hw_queue_map,
> +				     WLCORE_NUM_MAC_ADDRESSES);
> +	if (q_base >= WLCORE_NUM_MAC_ADDRESSES)
> +		return -EBUSY;
> +
> +	wlvif->hw_queue_base = q_base * NUM_TX_QUEUES;
> +	wl1271_debug(DEBUG_MAC80211, "allocating hw queue base: %d",
> +		     wlvif->hw_queue_base);
> +
> +	for (i = 0; i < NUM_TX_QUEUES; i++) {
> +		wl->queue_stop_reasons[wlvif->hw_queue_base + i] = 0;
> +		/* register hw queues in mac80211 */
> +		vif->hw_queue[i] = wlvif->hw_queue_base + i;
> +	}
> +
> +adjust_cab_queue:
> +	/* the last places are reserved for cab queues per interface */
> +	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
> +		vif->cab_queue = NUM_TX_QUEUES * WLCORE_NUM_MAC_ADDRESSES +
> +				 wlvif->hw_queue_base / NUM_TX_QUEUES;
> +	else
> +		vif->cab_queue = IEEE80211_INVAL_HW_QUEUE;

Why not keep the reservation per-vif in the same order (ie. the cab
queue comes together with the other queues for that vif)? It doesn't
matter that you don't use the cab_queue for the non AP vifs, since
you're allocating them anyway.

Keeping them together would make this code clearer.  Just make a macro
NUM_TX_QUEUES_PER_VIF that includes the space for cab_queue.


> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
> index d799fc9..dbc1721 100644
> --- a/drivers/net/wireless/ti/wlcore/tx.c
> +++ b/drivers/net/wireless/ti/wlcore/tx.c

[...]

> @@ -1189,44 +1192,45 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
>  }
>  EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
>  
> -void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
> -			      enum wlcore_queue_stop_reason reason)
> +void wlcore_stop_queue_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
> +			      u8 queue, enum wlcore_queue_stop_reason reason)
>  {
> -	bool stopped = !!wl->queue_stop_reasons[queue];
> +	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);

It would look nicer if we moved the "wlvif->hw_queue_base + " to the
wl1271_tx_get_mac80211_queue() function.  After all, the function call
without adding the hw_queue_base doesn't mean anything anymore.

I'll change this when applying.


> -void wlcore_wake_queue(struct wl1271 *wl, u8 queue,
> +void wlcore_wake_queue(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 queue,
>  		       enum wlcore_queue_stop_reason reason)
>  {
>  	unsigned long flags;
> +	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
>  
>  	spin_lock_irqsave(&wl->wl_lock, flags);
> -

Stray line removal, I'll insert it back.

[...]

> @@ -1235,49 +1239,62 @@ out:
>  void wlcore_stop_queues(struct wl1271 *wl,
>  			enum wlcore_queue_stop_reason reason)
>  {
> -	int i;
> +	int i, q_base;
> +	unsigned long flags;
>  
> -	for (i = 0; i < NUM_TX_QUEUES; i++)
> -		wlcore_stop_queue(wl, i, reason);
> -}
> -EXPORT_SYMBOL_GPL(wlcore_stop_queues);
> +	spin_lock_irqsave(&wl->wl_lock, flags);
>  
> -void wlcore_wake_queues(struct wl1271 *wl,
> -			enum wlcore_queue_stop_reason reason)
> -{
> -	int i;
> +	for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
> +		for (i = 0; i < NUM_TX_QUEUES; i++) {
> +			int h = q_base * NUM_TX_QUEUES + i;
> +			WARN_ON(test_and_set_bit(reason,
> +						 &wl->queue_stop_reasons[h]));
> +		}

This looks a bit hacky.  You'll "stop queues" even for vifs that were
not added, won't you? Also, you can do with a single for-loop here ;)

I'm also not sure about the WARN_ON.  If one of the queues is already
stopped, should we really warn? I see that, currently, the reasons to
stop all queues are not used to stop a single queue, but still. :)

[...]

> -void wlcore_reset_stopped_queues(struct wl1271 *wl)
> +void wlcore_wake_queues(struct wl1271 *wl,
> +			enum wlcore_queue_stop_reason reason)
>  {
> -	int i;
> +	int i, q_base;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&wl->wl_lock, flags);
>  
> -	for (i = 0; i < NUM_TX_QUEUES; i++) {
> -		if (!wl->queue_stop_reasons[i])
> -			continue;
> +	for (q_base = 0; q_base < WLCORE_NUM_MAC_ADDRESSES; q_base++)
> +		for (i = 0; i < NUM_TX_QUEUES; i++) {
> +			int h = q_base * NUM_TX_QUEUES + i;
> +			WARN_ON(!test_and_clear_bit(reason,
> +						&wl->queue_stop_reasons[h]));
> +		}

Same thing here.  Actually, wouldn't it make more sense to have a
separate bitmask for the "full-stops"? In that way, at least it would be
very clear that the full-stop reasons (eg. flush, restart...) cannot be
used with single queues.

--
Luca.

