Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:34955 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXFPViL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 17:38:11 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1174167wxc
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2007 14:38:11 -0700 (PDT)
Message-ID: <1ba2fa240706161438lfd629e4j7317bb62340c82a3@mail.gmail.com>
Date: Sun, 17 Jun 2007 00:38:07 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC PATCH] bcm43xx QoS support
Cc: bcm43xx-dev@lists.berlios.de, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Joseph Jezak" <josejx@gentoo.org>
In-Reply-To: <200706161328.53726.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706161328.53726.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi supports QoS. It has queues 4 hw for WMM access categories 2
hw queus for HCCA.
There is also a discussion about supporting hardware queues in qdisc  in netdev.

On 6/16/07, Michael Buesch <mb@bu3sch.de> wrote:
> This incomplete patch tries to implement QoS support in
> the bcm43xx driver.
> It's incomplete, because we don't upload the QoS parameters
> to the hardware, yet.
> http://bcm-v4.sipsolutions.net/802.11/QoS
> We might need some stack support to implement this (I'm not
> entirely sure, as I didn't read the whole ieee 802.11e, yet).
> Does some stack support for QoS exist? We need to upload
> some TX-opportunity, Interframe-space and some other values
> to the firmware. Not sure where to get them from, yet (didn't
> completely read 802.11e, yet :) ).
>
> The bcm43xx device has 6 DMA rings, but I think only 4
> are usable for 802.11e QoS. The other two seem to be useful
> for APs, though.
>
> This patch also implements per-DMAring-locking. So this
> (theoretically) enables the stack to simultaneously transmit
> on two (or more) rings. Though, I'm not sure the stack exploits this
> behaviour, yet.
>
>
> Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.c
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.c        2007-06-02 23:14:46.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.c     2007-06-16 00:38:59.000000000 +0200
> @@ -290,6 +290,50 @@ void return_slot(struct bcm43xx_dmaring
>         ring->used_slots--;
>  }
>
> +/* Mac80211-queue to bcm43xx-ring mapping */
> +static struct bcm43xx_dmaring * priority_to_txring(struct bcm43xx_wldev *dev,
> +                                                  int queue_priority)
> +{
> +       struct bcm43xx_dmaring *ring;
> +
> +       /* 0 = highest priority */
> +       switch (queue_priority) {
> +       default:
> +               assert(0);
> +               /* fallthrough */
> +       case 0:
> +               ring = dev->dma.tx_ring3;
> +               break;
> +       case 1:
> +               ring = dev->dma.tx_ring2;
> +               break;
> +       case 2:
> +               ring = dev->dma.tx_ring1;
> +               break;
> +       case 3:
> +               ring = dev->dma.tx_ring0;
> +               break;
> +       case 4:
> +               ring = dev->dma.tx_ring4;
> +               break;
> +       case 5:
> +               ring = dev->dma.tx_ring5;
> +               break;
> +       }
> +
> +       return ring;
> +}
> +
> +/* Bcm43xx-ring to mac80211-queue mapping */
> +static inline int txring_to_priority(struct bcm43xx_dmaring *ring)
> +{
> +       static const u8 idx_to_prio[] =
> +               { 3, 2, 1, 0, 4, 5, };
> +
> +       return idx_to_prio[ring->index];
> +}
> +
> +
>  u16 bcm43xx_dmacontroller_base(int dma64bit, int controller_idx)
>  {
>         static const u16 map64[] = {
> @@ -816,6 +860,7 @@ struct bcm43xx_dmaring * bcm43xx_setup_d
>                 } else
>                         assert(0);
>         }
> +       spin_lock_init(&ring->lock);
>  #ifdef CONFIG_BCM43XX_MAC80211_DEBUG
>         ring->last_injected_overflow = jiffies;
>  #endif
> @@ -1171,37 +1216,39 @@ int bcm43xx_dma_tx(struct bcm43xx_wldev
>                    struct sk_buff *skb,
>                    struct ieee80211_tx_control *ctl)
>  {
> -       struct bcm43xx_dmaring *ring = dev->dma.tx_ring1;
> +       struct bcm43xx_dmaring *ring;
>         int err = 0;
> +       unsigned long flags;
>
> +       ring = priority_to_txring(dev, ctl->queue);
> +       spin_lock_irqsave(&ring->lock, flags);
>         assert(ring->tx);
>         if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
> -               /* This should never trigger, as we call
> -                * ieee80211_stop_queue() when it's full.
> -                */
>                 printkl(KERN_ERR PFX "DMA queue overflow\n");
> -               return NETDEV_TX_BUSY;
> +               err = -ENOSPC;
> +               goto out_unlock;
>         }
>         /* Check if the queue was stopped in mac80211,
> -        * but we got called nevertheless. */
> +        * but we got called nevertheless.
> +        * That would be a mac80211 bug. */
>         assert(!ring->stopped);
>
>         err = dma_tx_fragment(ring, skb, ctl);
>         if (unlikely(err)) {
>                 printkl(KERN_ERR PFX "DMA tx mapping failure\n");
> -               return NETDEV_TX_BUSY;
> +               goto out_unlock;
>         }
> -
>         ring->nr_tx_packets++;
>         if ((free_slots(ring) < SLOTS_PER_PACKET) ||
>             should_inject_overflow(ring)) {
>                 /* This TX ring is full. */
> -               /* FIXME: we currently only have one queue, so hardcode queue 0 here. */
> -               ieee80211_stop_queue(dev->wl->hw, 0);
> +               ieee80211_stop_queue(dev->wl->hw, txring_to_priority(ring));
>                 ring->stopped = 1;
>         }
> +out_unlock:
> +       spin_unlock_irqrestore(&ring->lock, flags);
>
> -       return 0;
> +       return err;
>  }
>
>  void bcm43xx_dma_handle_txstatus(struct bcm43xx_wldev *dev,
> @@ -1216,6 +1263,9 @@ void bcm43xx_dma_handle_txstatus(struct
>         ring = parse_cookie(dev, status->cookie, &slot);
>         if (unlikely(!ring))
>                 return;
> +       assert(irqs_disabled());
> +       spin_lock(&ring->lock);
> +
>         assert(ring->tx);
>         ops = ring->ops;
>         while (1) {
> @@ -1257,24 +1307,32 @@ void bcm43xx_dma_handle_txstatus(struct
>         dev->stats.last_tx = jiffies;
>         if (ring->stopped) {
>                 assert(free_slots(ring) >= SLOTS_PER_PACKET);
> -               /* FIXME: we currently only have one queue, co hardcode queue 0 here. */
> -               ieee80211_wake_queue(dev->wl->hw, 0);
> +               ieee80211_wake_queue(dev->wl->hw, txring_to_priority(ring));
>                 ring->stopped = 0;
>         }
> +
> +       spin_unlock(&ring->lock);
>  }
>
>  void bcm43xx_dma_get_tx_stats(struct bcm43xx_wldev *dev,
>                               struct ieee80211_tx_queue_stats *stats)
>  {
> -       struct bcm43xx_dma *dma = &dev->dma;
> +       const int nr_queues = dev->wl->hw->queues;
>         struct bcm43xx_dmaring *ring;
>         struct ieee80211_tx_queue_stats_data *data;
> +       unsigned long flags;
> +       int i;
>
> -       ring = dma->tx_ring1;
> -       data = &(stats->data[0]);
> -       data->len = ring->used_slots / SLOTS_PER_PACKET;
> -       data->limit = ring->nr_slots / SLOTS_PER_PACKET;
> -       data->count = ring->nr_tx_packets;
> +       for (i = 0; i < nr_queues; i++) {
> +               data = &(stats->data[i]);
> +               ring = priority_to_txring(dev, i);
> +
> +               spin_lock_irqsave(&ring->lock, flags);
> +               data->len = ring->used_slots / SLOTS_PER_PACKET;
> +               data->limit = ring->nr_slots / SLOTS_PER_PACKET;
> +               data->count = ring->nr_tx_packets;
> +               spin_unlock_irqrestore(&ring->lock, flags);
> +       }
>  }
>
>  static void dma_rx(struct bcm43xx_dmaring *ring,
> @@ -1397,16 +1455,24 @@ void bcm43xx_dma_rx(struct bcm43xx_dmari
>         ring->current_slot = slot;
>  }
>
> -static inline void bcm43xx_dma_tx_suspend_ring(struct bcm43xx_dmaring *ring)
> +static void bcm43xx_dma_tx_suspend_ring(struct bcm43xx_dmaring *ring)
>  {
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ring->lock, flags);
>         assert(ring->tx);
>         ring->ops->tx_suspend(ring);
> +       spin_unlock_irqrestore(&ring->lock, flags);
>  }
>
> -static inline void bcm43xx_dma_tx_resume_ring(struct bcm43xx_dmaring *ring)
> +static void bcm43xx_dma_tx_resume_ring(struct bcm43xx_dmaring *ring)
>  {
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&ring->lock, flags);
>         assert(ring->tx);
>         ring->ops->tx_resume(ring);
> +       spin_unlock_irqrestore(&ring->lock, flags);
>  }
>
>  void bcm43xx_dma_tx_suspend(struct bcm43xx_wldev *dev)
> Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.h
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.h        2007-06-02 22:54:41.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_dma.h     2007-06-16 00:43:40.000000000 +0200
> @@ -252,6 +252,8 @@ struct bcm43xx_dmaring {
>         u8 dma64;
>         /* Boolean. Is this ring stopped at ieee80211 level? */
>         u8 stopped;
> +       /* Lock, only used for TX. */
> +       spinlock_t lock;
>         struct bcm43xx_wldev *dev;
>  #ifdef CONFIG_BCM43XX_MAC80211_DEBUG
>         /* Maximum number of used slots. */
> Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c       2007-06-14 16:05:09.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c    2007-06-16 00:50:26.000000000 +0200
> @@ -2448,16 +2448,17 @@ static int bcm43xx_tx(struct ieee80211_h
>         int err = -ENODEV;
>         unsigned long flags;
>
> +       /* DMA-TX is done without a global lock. */
>         if (unlikely(!dev))
>                 goto out;
> -       spin_lock_irqsave(&wl->irq_lock, flags);
> -       if (likely(bcm43xx_status(dev) == BCM43xx_STAT_INITIALIZED)) {
> -               if (bcm43xx_using_pio(dev))
> -                       err = bcm43xx_pio_tx(dev, skb, ctl);
> -               else
> -                       err = bcm43xx_dma_tx(dev, skb, ctl);
> -       }
> -       spin_unlock_irqrestore(&wl->irq_lock, flags);
> +       assert(bcm43xx_status(dev) == BCM43xx_STAT_INITIALIZED);
> +       assert(dev->started);
> +       if (bcm43xx_using_pio(dev)) {
> +               spin_lock_irqsave(&wl->irq_lock, flags);
> +               err = bcm43xx_pio_tx(dev, skb, ctl);
> +               spin_unlock_irqrestore(&wl->irq_lock, flags);
> +       } else
> +               err = bcm43xx_dma_tx(dev, skb, ctl);
>  out:
>         if (unlikely(err))
>                 return NETDEV_TX_BUSY;
> @@ -3313,10 +3314,13 @@ static int bcm43xx_wireless_core_init(st
>         bcm43xx_write_mac_bssid_templates(dev);
>
>         do {
> -               if (bcm43xx_using_pio(dev))
> +               if (bcm43xx_using_pio(dev)) {
>                         err = bcm43xx_pio_init(dev);
> -               else
> +               } else {
>                         err = bcm43xx_dma_init(dev);
> +                       if (!err)
> +                               bcm43xx_qos_init(dev);
> +               }
>         } while (err == -EAGAIN);
>         if (err)
>                 goto err_chip_exit;
> @@ -3798,7 +3802,7 @@ static int bcm43xx_wireless_init(struct
>         hw->max_signal = 100;
>         hw->max_rssi = -110;
>         hw->max_noise = -110;
> -       hw->queues = 1;
> +       hw->queues = 4;
>         SET_IEEE80211_DEV(hw, dev->dev);
>         if (is_valid_ether_addr(sprom->r1.et1mac))
>                 SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
> Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c       2007-06-10 14:37:06.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c    2007-06-16 13:14:30.000000000 +0200
> @@ -619,3 +619,28 @@ void bcm43xx_tx_resume(struct bcm43xx_wl
>         else
>                 bcm43xx_dma_tx_resume(dev);
>  }
> +
> +static void upload_qos_parms(struct bcm43xx_wldev *dev,
> +                            const u16 *parms,
> +                            u16 offset)
> +{
> +       int i;
> +
> +       for (i = 0; i < BCM43xx_NR_QOSPARMS; i++) {
> +               bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
> +                                   offset + i, parms[i]);
> +       }
> +}
> +
> +/* Initialize the QoS parameters */
> +void bcm43xx_qos_init(struct bcm43xx_wldev *dev)
> +{
> +       //TODO
> +       bcm43xx_hf_write(dev, bcm43xx_hf_read(dev) | BCM43xx_HF_EDCF);
> +       //FIXME kill magic
> +       bcm43xx_write16(dev, 0x688,
> +                       bcm43xx_read16(dev, 0x688) | 0x4);
> +
> +
> +       /*TODO: We might need some stack support here to get the values. */
> +}
> Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> ===================================================================
> --- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h       2007-06-01 01:14:02.000000000 +0200
> +++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h    2007-06-16 01:09:03.000000000 +0200
> @@ -215,6 +215,21 @@ void bcm43xx_handle_hwtxstatus(struct bc
>  void bcm43xx_tx_suspend(struct bcm43xx_wldev *dev);
>  void bcm43xx_tx_resume(struct bcm43xx_wldev *dev);
>
> +
> +#define BCM43xx_NR_QOSPARMS            21
> +enum {
> +       BCM43xx_QOSPARM_TXOP = 0,
> +       BCM43xx_QOSPARM_CWMIN,
> +       BCM43xx_QOSPARM_CWMAX,
> +       BCM43xx_QOSPARM_CWCUR,
> +       BCM43xx_QOSPARM_AIFS,
> +       BCM43xx_QOSPARM_BSLOTS,
> +       BCM43xx_QOSPARM_REGGAP,
> +       BCM43xx_QOSPARM_STATUS,
> +};
> +void bcm43xx_qos_init(struct bcm43xx_wldev *dev);
> +
> +
>  /* Helper functions for converting the key-table index from "firmware-format"
>   * to "raw-format" and back. The firmware API changed for this at some revision.
>   * We need to account for that here. */
>
> --
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
