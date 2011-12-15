Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46359 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab1LOL3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 06:29:08 -0500
Received: by faar15 with SMTP id r15so2052986faa.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 03:29:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ee9d496.ZmxUcTz7IvcMM2Tq%francesco.gringoli@ing.unibs.it>
References: <4ee9d496.ZmxUcTz7IvcMM2Tq%francesco.gringoli@ing.unibs.it>
Date: Thu, 15 Dec 2011 12:23:28 +0100
Message-ID: <CACna6ryYG3o_h9xfy6TFM0Ra7nFbCfMpKoXtQ0MsDY67-_-1bg@mail.gmail.com> (sfid-20111215_122912_494726_D0F030A2)
Subject: Re: [PATCH] b43: avoid packet losses in the dma worker code.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: francesco.gringoli@ing.unibs.it
Cc: m@bues.ch, linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	michele.orru@hotmail.it, b43-dev@lists.infradead.org,
	riccardo.paolillo@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/15  <francesco.gringoli@ing.unibs.it>:
> This patch addresses a bug in the dma worker code that keeps draining
> packets even when the hardware queues are full. In such cases packets
> can not be passed down to the device and are erroneusly dropped by the
> code.
>
> This problem was already discussed here
>
> http://www.mail-archive.com/b43-dev@lists.infradead.org/msg01413.html
>
> and acknowledged by Michael.
>
> The patch also introduces separate workers for each hardware queues
> and dedicated buffers where storing packets from mac80211 before sending
> them down to the hardware.

I think it sounds like the real solution, thanks for the patch.

I'll test it later, for now I've few minor comments, code style related mostyle.


> Index: wireless-testing-new/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/b43/b43.h    2011-12-12 16:15:45.134475457 +0100
> +++ wireless-testing-new/drivers/net/wireless/b43/b43.h 2011-12-13 12:45:10.764607082 +0100
> @@ -845,6 +845,14 @@
>  #endif
>  };
>
> +/* Multi-Queue work struct */
> +struct b43_mt_work {
> +       /* Work associated to the queue */
> +       struct work_struct mt_work;
> +       /* Queue index */
> +       int work_queue_id;
> +};
> +
>  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
>  struct b43_wl {
>        /* Pointer to the active wireless device on this chip */
> @@ -911,10 +919,14 @@
>         * power doesn't match what we want. */
>        struct work_struct txpower_adjust_work;
>
> -       /* Packet transmit work */
> -       struct work_struct tx_work;
> +       /* Packet transmit work. */
> +       struct b43_mt_work tx_work[4];

That 4 repeats a lot of time, define it please.


>        /* Queue of packets to be transmitted. */
> -       struct sk_buff_head tx_queue;
> +       struct sk_buff_head tx_queue[4];
> +
> +       /* Flag that implement the queues stopping*/

Trivial, I don't insist on changing, but maybe space before the star?


>        /* The device LEDs. */
>        struct b43_leds leds;
> Index: wireless-testing-new/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/b43/main.c   2011-12-12 16:15:45.134475457 +0100
> +++ wireless-testing-new/drivers/net/wireless/b43/main.c        2011-12-13 13:05:25.834514041 +0100
> @@ -3375,9 +3375,11 @@
>
>  static void b43_tx_work(struct work_struct *work)
>  {
> -       struct b43_wl *wl = container_of(work, struct b43_wl, tx_work);
> +       struct b43_mt_work *queue_work = container_of(work, struct b43_mt_work, mt_work);
> +       struct b43_wl *wl = container_of(queue_work, struct b43_wl, tx_work[queue_work->work_queue_id]);
>        struct b43_wldev *dev;
>        struct sk_buff *skb;
> +       int queue_num = queue_work->work_queue_id;
>        int err = 0;
>
>        mutex_lock(&wl->mutex);
> @@ -3387,15 +3389,27 @@
>                return;
>        }
>
> -       while (skb_queue_len(&wl->tx_queue)) {
> -               skb = skb_dequeue(&wl->tx_queue);
> +       while (skb_queue_len(&wl->tx_queue[queue_num])) {
> +               skb = skb_dequeue(&wl->tx_queue[queue_num]);
>
>                if (b43_using_pio_transfers(dev))
>                        err = b43_pio_tx(dev, skb);
>                else
>                        err = b43_dma_tx(dev, skb);
> +
> +               if (err == -ENOSPC) {
> +                       wl->tx_queue_stopped[queue_num] = 1;
> +                       ieee80211_stop_queue(wl->hw, skb_get_queue_mapping(skb));
> +                       skb_queue_head(&wl->tx_queue[queue_num], skb);
> +                       break;
> +               }
>                if (unlikely(err))
>                        dev_kfree_skb(skb); /* Drop it */
> +               err = 0;
> +       }
> +
> +       if (!err) {
> +               wl->tx_queue_stopped[queue_num] = 0;
>        }
>
>  #if B43_DEBUG
> @@ -3416,8 +3430,12 @@
>        }
>        B43_WARN_ON(skb_shinfo(skb)->nr_frags);
>
> -       skb_queue_tail(&wl->tx_queue, skb);
> -       ieee80211_queue_work(wl->hw, &wl->tx_work);
> +       skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
> +       if ( !wl->tx_queue_stopped[skb->queue_mapping] ) {
> +               ieee80211_queue_work(wl->hw, &wl->tx_work[skb->queue_mapping].mt_work);
> +       } else {
> +               ieee80211_stop_queue(wl->hw, skb->queue_mapping);
> +       }

Please, use checkpatch.sh from scripts directory. You don't follow
kernel coding style here.
Space after "(" and braces.


> @@ -4147,6 +4165,7 @@
>        struct b43_wl *wl;
>        struct b43_wldev *orig_dev;
>        u32 mask;
> +       int queue_num;
>
>        if (!dev)
>                return NULL;
> @@ -4158,7 +4177,10 @@
>        /* Cancel work. Unlock to avoid deadlocks. */
>        mutex_unlock(&wl->mutex);
>        cancel_delayed_work_sync(&dev->periodic_work);
> -       cancel_work_sync(&wl->tx_work);
> +
> +       for (queue_num = 0; queue_num < 4; queue_num++)
> +               cancel_work_sync(&wl->tx_work[queue_num].mt_work);
> +
>        mutex_lock(&wl->mutex);
>        dev = wl->current_dev;
>        if (!dev || b43_status(dev) < B43_STAT_STARTED) {
> @@ -4199,9 +4221,11 @@
>        mask = b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);
>        B43_WARN_ON(mask != 0xFFFFFFFF && mask);
>
> -       /* Drain the TX queue */
> -       while (skb_queue_len(&wl->tx_queue))
> -               dev_kfree_skb(skb_dequeue(&wl->tx_queue));
> +       /* Drain each TX queue */
> +       for (queue_num = 0; queue_num < 4; queue_num++) {
> +               while (skb_queue_len(&wl->tx_queue[queue_num]))
> +                       dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
> +       }
>
>        b43_mac_suspend(dev);
>        b43_leds_exit(dev);
> @@ -5245,6 +5269,7 @@
>        struct ieee80211_hw *hw;
>        struct b43_wl *wl;
>        char chip_name[6];
> +       int queue_num;
>
>        hw = ieee80211_alloc_hw(sizeof(*wl), &b43_hw_ops);
>        if (!hw) {
> @@ -5280,8 +5305,14 @@
>        INIT_LIST_HEAD(&wl->devlist);
>        INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
>        INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
> -       INIT_WORK(&wl->tx_work, b43_tx_work);
> -       skb_queue_head_init(&wl->tx_queue);
> +
> +       /* Initialize the work for each queues  */
> +       for (queue_num = 0; queue_num < 4; queue_num++) {
> +               INIT_WORK(&wl->tx_work[queue_num].mt_work, b43_tx_work);
> +               wl->tx_work[queue_num].work_queue_id = queue_num;
> +               skb_queue_head_init(&wl->tx_queue[queue_num]);
> +               wl->tx_queue_stopped[queue_num] = 0;
> +       }
>
>        snprintf(chip_name, ARRAY_SIZE(chip_name),
>                 (dev->chip_id > 0x9999) ? "%d" : "%04X", dev->chip_id);
> Index: wireless-testing-new/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/b43/dma.c    2011-12-12 16:15:45.134475457 +0100
> +++ wireless-testing-new/drivers/net/wireless/b43/dma.c 2011-12-13 12:55:58.834540692 +0100
> @@ -1465,7 +1465,9 @@
>        if ((free_slots(ring) < TX_SLOTS_PER_FRAME) ||
>            should_inject_overflow(ring)) {
>                /* This TX ring is full. */
> -               ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
> +               unsigned int skb_mapping = skb_get_queue_mapping(skb);
> +               ieee80211_stop_queue(dev->wl->hw, skb_mapping);
> +               dev->wl->tx_queue_stopped[skb_mapping] = 1;
>                ring->stopped = 1;
>                if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
>                        b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
> @@ -1584,12 +1585,21 @@
>        }
>        if (ring->stopped) {
>                B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
> -               ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
>                ring->stopped = 0;
> +       }
> +
> +       if ( dev->wl->tx_queue_stopped[ring->queue_prio] ) {

Space again.

-- 
Rafał
