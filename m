Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:54379 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYEAKIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 06:08:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix some TX/RX locking issues
Date: Thu, 1 May 2008 12:08:10 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200804251929.09301.mb@bu3sch.de>
In-Reply-To: <200804251929.09301.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805011208.10533.mb@bu3sch.de> (sfid-20080501_120829_839749_9B4FB92B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, did you drop this patch? I can't see it in git and your latest push,
while a patch submitted later is in there.

On Friday 25 April 2008, Michael Buesch wrote:
> This fixes some TX/RX related locking issues.
> With this patch applied, some of the PHY transmission errors are fixed.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, this is for 2.6.26.
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-24 19:42:55.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-25 19:28:42.000000000 +0200
> @@ -688,12 +688,16 @@ struct b43_wl {
>  	struct b43_wldev *current_dev;
>  	/* Pointer to the ieee80211 hardware data structure */
>  	struct ieee80211_hw *hw;
>  
>  	struct mutex mutex;
>  	spinlock_t irq_lock;
> +	/* R/W lock for data transmission.
> +	 * Transmissions on 2+ queues can run concurrently, but somebody else
> +	 * might sync with TX by write_lock_irqsave()'ing. */
> +	rwlock_t tx_lock;
>  	/* Lock for LEDs access. */
>  	spinlock_t leds_lock;
>  	/* Lock for SHM access. */
>  	spinlock_t shm_lock;
>  
>  	/* We can only have one operating interface (802.11 core)
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-24 19:42:55.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-25 18:47:08.000000000 +0200
> @@ -726,12 +726,13 @@ static void b43_synchronize_irq(struct b
>  
>  /* DummyTransmission function, as documented on
>   * http://bcm-specs.sipsolutions.net/DummyTransmission
>   */
>  void b43_dummy_transmission(struct b43_wldev *dev)
>  {
> +	struct b43_wl *wl = dev->wl;
>  	struct b43_phy *phy = &dev->phy;
>  	unsigned int i, max_loop;
>  	u16 value;
>  	u32 buffer[5] = {
>  		0x00000000,
>  		0x00D40000,
> @@ -752,12 +753,15 @@ void b43_dummy_transmission(struct b43_w
>  		break;
>  	default:
>  		B43_WARN_ON(1);
>  		return;
>  	}
>  
> +	spin_lock_irq(&wl->irq_lock);
> +	write_lock(&wl->tx_lock);
> +
>  	for (i = 0; i < 5; i++)
>  		b43_ram_write(dev, i * 4, buffer[i]);
>  
>  	/* Commit writes */
>  	b43_read32(dev, B43_MMIO_MACCTL);
>  
> @@ -792,12 +796,15 @@ void b43_dummy_transmission(struct b43_w
>  		if (!(value & 0x0100))
>  			break;
>  		udelay(10);
>  	}
>  	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
>  		b43_radio_write16(dev, 0x0051, 0x0037);
> +
> +	write_unlock(&wl->tx_lock);
> +	spin_unlock_irq(&wl->irq_lock);
>  }
>  
>  static void key_write(struct b43_wldev *dev,
>  		      u8 index, u8 algorithm, const u8 * key)
>  {
>  	unsigned int i;
> @@ -2821,30 +2828,37 @@ static int b43_rng_init(struct b43_wl *w
>  static int b43_op_tx(struct ieee80211_hw *hw,
>  		     struct sk_buff *skb,
>  		     struct ieee80211_tx_control *ctl)
>  {
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
>  	struct b43_wldev *dev = wl->current_dev;
> -	int err = -ENODEV;
> +	unsigned long flags;
> +	int err;
>  
>  	if (unlikely(skb->len < 2 + 2 + 6)) {
>  		/* Too short, this can't be a valid frame. */
> -		return -EINVAL;
> +		dev_kfree_skb_any(skb);
> +		return NETDEV_TX_OK;
>  	}
>  	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
> -
>  	if (unlikely(!dev))
> -		goto out;
> -	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
> -		goto out;
> -	/* TX is done without a global lock. */
> -	if (b43_using_pio_transfers(dev))
> -		err = b43_pio_tx(dev, skb, ctl);
> -	else
> -		err = b43_dma_tx(dev, skb, ctl);
> -out:
> +		return NETDEV_TX_BUSY;
> +
> +	/* Transmissions on seperate queues can run concurrently. */
> +	read_lock_irqsave(&wl->tx_lock, flags);
> +
> +	err = -ENODEV;
> +	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
> +		if (b43_using_pio_transfers(dev))
> +			err = b43_pio_tx(dev, skb, ctl);
> +		else
> +			err = b43_dma_tx(dev, skb, ctl);
> +	}
> +
> +	read_unlock_irqrestore(&wl->tx_lock, flags);
> +
>  	if (unlikely(err))
>  		return NETDEV_TX_BUSY;
>  	return NETDEV_TX_OK;
>  }
>  
>  /* Locking: wl->irq_lock */
> @@ -3457,23 +3471,23 @@ static void b43_wireless_core_stop(struc
>  	spin_lock_irqsave(&wl->irq_lock, flags);
>  	dev->irq_savedstate = b43_interrupt_disable(dev, B43_IRQ_ALL);
>  	b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* flush */
>  	spin_unlock_irqrestore(&wl->irq_lock, flags);
>  	b43_synchronize_irq(dev);
>  
> +	write_lock_irqsave(&wl->tx_lock, flags);
>  	b43_set_status(dev, B43_STAT_INITIALIZED);
> +	write_unlock_irqrestore(&wl->tx_lock, flags);
>  
>  	b43_pio_stop(dev);
>  	mutex_unlock(&wl->mutex);
>  	/* Must unlock as it would otherwise deadlock. No races here.
>  	 * Cancel the possibly running self-rearming periodic work. */
>  	cancel_delayed_work_sync(&dev->periodic_work);
>  	mutex_lock(&wl->mutex);
>  
> -	ieee80211_stop_queues(wl->hw);	//FIXME this could cause a deadlock, as mac80211 seems buggy.
> -
>  	b43_mac_suspend(dev);
>  	free_irq(dev->dev->irq, dev);
>  	b43dbg(wl, "Wireless interface stopped\n");
>  }
>  
>  /* Locking: wl->mutex */
> @@ -4471,12 +4485,13 @@ static int b43_wireless_init(struct ssb_
>  
>  	/* Get and initialize struct b43_wl */
>  	wl = hw_to_b43_wl(hw);
>  	memset(wl, 0, sizeof(*wl));
>  	wl->hw = hw;
>  	spin_lock_init(&wl->irq_lock);
> +	rwlock_init(&wl->tx_lock);
>  	spin_lock_init(&wl->leds_lock);
>  	spin_lock_init(&wl->shm_lock);
>  	mutex_init(&wl->mutex);
>  	INIT_LIST_HEAD(&wl->devlist);
>  	INIT_WORK(&wl->qos_update_work, b43_qos_update_work);
>  	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
> 


