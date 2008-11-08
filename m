Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:52365 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYKHOci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 09:32:38 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1417796ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2008 06:32:35 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: Cleanup TX/RX entry handling
Date: Sat, 8 Nov 2008 15:32:32 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200811081525.33831.IvDoorn@gmail.com>
In-Reply-To: <200811081525.33831.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811081532.32851.IvDoorn@gmail.com> (sfid-20081108_153243_568239_FD2CB91B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, typo in the linux-wireless recipient. :(

On Saturday 08 November 2008, Ivo van Doorn wrote:
> Merge the callback functions init_txentry() and
> init_rxentry(). This makes life in rt2x00lib a
> lot simpler and we can cleanup several functions.
> 
> rt2x00pci contained "fake" FIELD definitions for
> descriptor words. This is not flexible since it
> assumes the driver will always have the same field
> to indicate if a driver is available or not.
> This should be dependent on the driver, and we
> should add a callback function for this.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c   |   51 +++++++++++++++++-----------
>  drivers/net/wireless/rt2x00/rt2500pci.c   |   45 ++++++++++++++++---------
>  drivers/net/wireless/rt2x00/rt2500usb.c   |    3 +-
>  drivers/net/wireless/rt2x00/rt2x00.h      |    6 +--
>  drivers/net/wireless/rt2x00/rt2x00dev.c   |    7 ++--
>  drivers/net/wireless/rt2x00/rt2x00lib.h   |   12 ++++++-
>  drivers/net/wireless/rt2x00/rt2x00pci.c   |   13 ++-----
>  drivers/net/wireless/rt2x00/rt2x00pci.h   |   11 ------
>  drivers/net/wireless/rt2x00/rt2x00queue.c |   28 ++--------------
>  drivers/net/wireless/rt2x00/rt2x00usb.c   |   31 ++++++++---------
>  drivers/net/wireless/rt2x00/rt2x00usb.h   |    5 +--
>  drivers/net/wireless/rt2x00/rt61pci.c     |   47 ++++++++++++++++----------
>  drivers/net/wireless/rt2x00/rt73usb.c     |    3 +-
>  13 files changed, 127 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 2350f43..257cd71 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -626,36 +626,47 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
>  /*
>   * Initialization functions.
>   */
> -static void rt2400pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
> -				   struct queue_entry *entry)
> +static bool rt2400pci_get_entry_state(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> -	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 2, &word);
> -	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH, entry->skb->len);
> -	rt2x00_desc_write(entry_priv->desc, 2, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
> -	rt2x00_desc_read(entry_priv->desc, 1, &word);
> -	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
> -	rt2x00_desc_write(entry_priv->desc, 1, word);
> +		return rt2x00_get_field32(word, RXD_W0_OWNER_NIC);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +		return (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
> +		        rt2x00_get_field32(word, TXD_W0_VALID));
> +	}
>  }
>  
> -static void rt2400pci_init_txentry(struct rt2x00_dev *rt2x00dev,
> -				   struct queue_entry *entry)
> +static void rt2400pci_clear_entry(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> +	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> -	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 2, &word);
> +		rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH, entry->skb->len);
> +		rt2x00_desc_write(entry_priv->desc, 2, word);
> +
> +		rt2x00_desc_read(entry_priv->desc, 1, &word);
> +		rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
> +		rt2x00_desc_write(entry_priv->desc, 1, word);
> +
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> +		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	}
>  }
>  
>  static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
> @@ -1572,8 +1583,8 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
>  	.probe_hw		= rt2400pci_probe_hw,
>  	.initialize		= rt2x00pci_initialize,
>  	.uninitialize		= rt2x00pci_uninitialize,
> -	.init_rxentry		= rt2400pci_init_rxentry,
> -	.init_txentry		= rt2400pci_init_txentry,
> +	.get_entry_state	= rt2400pci_get_entry_state,
> +	.clear_entry		= rt2400pci_clear_entry,
>  	.set_device_state	= rt2400pci_set_device_state,
>  	.rfkill_poll		= rt2400pci_rfkill_poll,
>  	.link_stats		= rt2400pci_link_stats,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 9e9a6b8..a3fbfdf 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -722,32 +722,43 @@ dynamic_cca_tune:
>  /*
>   * Initialization functions.
>   */
> -static void rt2500pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
> -				   struct queue_entry *entry)
> +static bool rt2500pci_get_entry_state(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> -	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 1, &word);
> -	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
> -	rt2x00_desc_write(entry_priv->desc, 1, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +
> +		return rt2x00_get_field32(word, RXD_W0_OWNER_NIC);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +		return (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
> +		        rt2x00_get_field32(word, TXD_W0_VALID));
> +	}
>  }
>  
> -static void rt2500pci_init_txentry(struct rt2x00_dev *rt2x00dev,
> -				   struct queue_entry *entry)
> +static void rt2500pci_clear_entry(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> +	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> -	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 1, &word);
> +		rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
> +		rt2x00_desc_write(entry_priv->desc, 1, word);
> +
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> +		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	}
>  }
>  
>  static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
> @@ -1874,8 +1885,8 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
>  	.probe_hw		= rt2500pci_probe_hw,
>  	.initialize		= rt2x00pci_initialize,
>  	.uninitialize		= rt2x00pci_uninitialize,
> -	.init_rxentry		= rt2500pci_init_rxentry,
> -	.init_txentry		= rt2500pci_init_txentry,
> +	.get_entry_state	= rt2500pci_get_entry_state,
> +	.clear_entry		= rt2500pci_clear_entry,
>  	.set_device_state	= rt2500pci_set_device_state,
>  	.rfkill_poll		= rt2500pci_rfkill_poll,
>  	.link_stats		= rt2500pci_link_stats,
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 36d0fab..3e4051c 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1779,8 +1779,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
>  	.probe_hw		= rt2500usb_probe_hw,
>  	.initialize		= rt2x00usb_initialize,
>  	.uninitialize		= rt2x00usb_uninitialize,
> -	.init_rxentry		= rt2x00usb_init_rxentry,
> -	.init_txentry		= rt2x00usb_init_txentry,
> +	.clear_entry		= rt2x00usb_clear_entry,
>  	.set_device_state	= rt2500usb_set_device_state,
>  	.link_stats		= rt2500usb_link_stats,
>  	.reset_tuner		= rt2500usb_reset_tuner,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 8fa971c..4506f6c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -523,10 +523,8 @@ struct rt2x00lib_ops {
>  	/*
>  	 * queue initialization handlers
>  	 */
> -	void (*init_rxentry) (struct rt2x00_dev *rt2x00dev,
> -			      struct queue_entry *entry);
> -	void (*init_txentry) (struct rt2x00_dev *rt2x00dev,
> -			      struct queue_entry *entry);
> +	bool (*get_entry_state) (struct queue_entry *entry);
> +	void (*clear_entry) (struct queue_entry *entry);
>  
>  	/*
>  	 * Radio control handlers.
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index e8ca1cb..bb510a2 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -101,8 +101,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize all data queues.
>  	 */
> -	rt2x00queue_init_rx(rt2x00dev);
> -	rt2x00queue_init_tx(rt2x00dev);
> +	rt2x00queue_init_queues(rt2x00dev);
>  
>  	/*
>  	 * Enable radio.
> @@ -576,7 +575,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	entry->skb = NULL;
>  	entry->flags = 0;
>  
> -	rt2x00dev->ops->lib->init_txentry(rt2x00dev, entry);
> +	rt2x00dev->ops->lib->clear_entry(entry);
>  
>  	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
>  	rt2x00queue_index_inc(entry->queue, Q_INDEX_DONE);
> @@ -708,7 +707,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
>  	entry->skb = skb;
>  	entry->flags = 0;
>  
> -	rt2x00dev->ops->lib->init_rxentry(rt2x00dev, entry);
> +	rt2x00dev->ops->lib->clear_entry(entry);
>  
>  	rt2x00queue_index_inc(entry->queue, Q_INDEX);
>  }
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 0c3a355..9399733 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -150,8 +150,16 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
>   */
>  void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index);
>  
> -void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev);
> -void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev);
> +/**
> + * rt2x00queue_init_queues - Initialize all data queues
> + * @rt2x00dev: Pointer to &struct rt2x00_dev.
> + *
> + * This function will loop through all available queues to clear all
> + * index numbers and set the queue entry to the correct initialization
> + * state.
> + */
> +void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev);
> +
>  int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev);
>  void rt2x00queue_uninitialize(struct rt2x00_dev *rt2x00dev);
>  int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index adf2876..b246d85 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -36,20 +36,17 @@
>   */
>  int rt2x00pci_write_tx_data(struct queue_entry *entry)
>  {
> +	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
>  	struct skb_frame_desc *skbdesc;
> -	u32 word;
> -
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
>  	/*
>  	 * This should not happen, we already checked the entry
>  	 * was ours. When the hardware disagrees there has been
>  	 * a queue corruption!
>  	 */
> -	if (unlikely(rt2x00_get_field32(word, TXD_ENTRY_OWNER_NIC) ||
> -		     rt2x00_get_field32(word, TXD_ENTRY_VALID))) {
> -		ERROR(entry->queue->rt2x00dev,
> +	if (unlikely(rt2x00dev->ops->lib->get_entry_state(entry))) {
> +		ERROR(rt2x00dev,
>  		      "Corrupt queue %d, accessing entry which is not ours.\n"
>  		      "Please file bug report to %s.\n",
>  		      entry->queue->qid, DRV_PROJECT);
> @@ -76,14 +73,12 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
>  	struct queue_entry *entry;
>  	struct queue_entry_priv_pci *entry_priv;
>  	struct skb_frame_desc *skbdesc;
> -	u32 word;
>  
>  	while (1) {
>  		entry = rt2x00queue_get_entry(queue, Q_INDEX);
>  		entry_priv = entry->priv_data;
> -		rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
> -		if (rt2x00_get_field32(word, RXD_ENTRY_OWNER_NIC))
> +		if (rt2x00dev->ops->lib->get_entry_state(entry))
>  			break;
>  
>  		/*
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
> index a83f45f..96a2082 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
> @@ -44,17 +44,6 @@
>  #define REGISTER_BUSY_DELAY	100
>  
>  /*
> - * Descriptor availability flags.
> - * All PCI device descriptors have these 2 flags
> - * with the exact same definition.
> - * By storing them here we can use them inside rt2x00pci
> - * for some simple entry availability checking.
> - */
> -#define TXD_ENTRY_OWNER_NIC	FIELD32(0x00000001)
> -#define TXD_ENTRY_VALID		FIELD32(0x00000002)
> -#define RXD_ENTRY_OWNER_NIC	FIELD32(0x00000001)
> -
> -/*
>   * Register access.
>   */
>  static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index e9f4261..7fc9c6e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -589,40 +589,18 @@ static void rt2x00queue_reset(struct data_queue *queue)
>  	spin_unlock_irqrestore(&queue->lock, irqflags);
>  }
>  
> -void rt2x00queue_init_rx(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct data_queue *queue = rt2x00dev->rx;
> -	unsigned int i;
> -
> -	rt2x00queue_reset(queue);
> -
> -	if (!rt2x00dev->ops->lib->init_rxentry)
> -		return;
> -
> -	for (i = 0; i < queue->limit; i++) {
> -		queue->entries[i].flags = 0;
> -
> -		rt2x00dev->ops->lib->init_rxentry(rt2x00dev,
> -						  &queue->entries[i]);
> -	}
> -}
> -
> -void rt2x00queue_init_tx(struct rt2x00_dev *rt2x00dev)
> +void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct data_queue *queue;
>  	unsigned int i;
>  
> -	txall_queue_for_each(rt2x00dev, queue) {
> +	queue_for_each(rt2x00dev, queue) {
>  		rt2x00queue_reset(queue);
>  
> -		if (!rt2x00dev->ops->lib->init_txentry)
> -			continue;
> -
>  		for (i = 0; i < queue->limit; i++) {
>  			queue->entries[i].flags = 0;
>  
> -			rt2x00dev->ops->lib->init_txentry(rt2x00dev,
> -							  &queue->entries[i]);
> +			rt2x00dev->ops->lib->clear_entry(&queue->entries[i]);
>  		}
>  	}
>  }
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index b73a7e0..4eb550f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -351,28 +351,25 @@ EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
>  /*
>   * Device initialization handlers.
>   */
> -void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
> -			    struct queue_entry *entry)
> +void rt2x00usb_clear_entry(struct queue_entry *entry)
>  {
> -	struct usb_device *usb_dev = to_usb_device_intf(rt2x00dev->dev);
> +	struct usb_device *usb_dev =
> +	    to_usb_device_intf(entry->queue->rt2x00dev->dev);
>  	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
>  
> -	usb_fill_bulk_urb(entry_priv->urb, usb_dev,
> -			  usb_rcvbulkpipe(usb_dev, 1),
> -			  entry->skb->data, entry->skb->len,
> -			  rt2x00usb_interrupt_rxdone, entry);
> +	if (entry->queue->qid == QID_RX) {
> +		usb_fill_bulk_urb(entry_priv->urb, usb_dev,
> +				usb_rcvbulkpipe(usb_dev, 1),
> +				entry->skb->data, entry->skb->len,
> +				rt2x00usb_interrupt_rxdone, entry);
>  
> -	set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
> -	usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
> -}
> -EXPORT_SYMBOL_GPL(rt2x00usb_init_rxentry);
> -
> -void rt2x00usb_init_txentry(struct rt2x00_dev *rt2x00dev,
> -			    struct queue_entry *entry)
> -{
> -	entry->flags = 0;
> +		set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
> +		usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
> +	} else {
> +		entry->flags = 0;
> +	}
>  }
> -EXPORT_SYMBOL_GPL(rt2x00usb_init_txentry);
> +EXPORT_SYMBOL_GPL(rt2x00usb_clear_entry);
>  
>  static int rt2x00usb_alloc_urb(struct rt2x00_dev *rt2x00dev,
>  			       struct data_queue *queue)
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
> index 3b4a674..4104f0e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -286,10 +286,7 @@ void rt2x00usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
>  /*
>   * Device initialization handlers.
>   */
> -void rt2x00usb_init_rxentry(struct rt2x00_dev *rt2x00dev,
> -			    struct queue_entry *entry);
> -void rt2x00usb_init_txentry(struct rt2x00_dev *rt2x00dev,
> -			    struct queue_entry *entry);
> +void rt2x00usb_clear_entry(struct queue_entry *entry);
>  int rt2x00usb_initialize(struct rt2x00_dev *rt2x00dev);
>  void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev);
>  
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index a8c3057..cea66bb 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1261,33 +1261,44 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
>  /*
>   * Initialization functions.
>   */
> -static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
> -				 struct queue_entry *entry)
> +static bool rt61pci_get_entry_state(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> -	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 5, &word);
> -	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
> -			   skbdesc->skb_dma);
> -	rt2x00_desc_write(entry_priv->desc, 5, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +		return rt2x00_get_field32(word, RXD_W0_OWNER_NIC);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +
> +		return (rt2x00_get_field32(word, TXD_W0_OWNER_NIC) ||
> +		        rt2x00_get_field32(word, TXD_W0_VALID));
> +	}
>  }
>  
> -static void rt61pci_init_txentry(struct rt2x00_dev *rt2x00dev,
> -				 struct queue_entry *entry)
> +static void rt61pci_clear_entry(struct queue_entry *entry)
>  {
>  	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
> +	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>  	u32 word;
>  
> -	rt2x00_desc_read(entry_priv->desc, 0, &word);
> -	rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> -	rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> -	rt2x00_desc_write(entry_priv->desc, 0, word);
> +	if (entry->queue->qid == QID_RX) {
> +		rt2x00_desc_read(entry_priv->desc, 5, &word);
> +		rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
> +				   skbdesc->skb_dma);
> +		rt2x00_desc_write(entry_priv->desc, 5, word);
> +
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, RXD_W0_OWNER_NIC, 1);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	} else {
> +		rt2x00_desc_read(entry_priv->desc, 0, &word);
> +		rt2x00_set_field32(&word, TXD_W0_VALID, 0);
> +		rt2x00_set_field32(&word, TXD_W0_OWNER_NIC, 0);
> +		rt2x00_desc_write(entry_priv->desc, 0, word);
> +	}
>  }
>  
>  static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
> @@ -2724,8 +2735,8 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
>  	.load_firmware		= rt61pci_load_firmware,
>  	.initialize		= rt2x00pci_initialize,
>  	.uninitialize		= rt2x00pci_uninitialize,
> -	.init_rxentry		= rt61pci_init_rxentry,
> -	.init_txentry		= rt61pci_init_txentry,
> +	.get_entry_state	= rt61pci_get_entry_state,
> +	.clear_entry		= rt61pci_clear_entry,
>  	.set_device_state	= rt61pci_set_device_state,
>  	.rfkill_poll		= rt61pci_rfkill_poll,
>  	.link_stats		= rt61pci_link_stats,
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index a5a9341..eddc489 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2315,8 +2315,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
>  	.load_firmware		= rt73usb_load_firmware,
>  	.initialize		= rt2x00usb_initialize,
>  	.uninitialize		= rt2x00usb_uninitialize,
> -	.init_rxentry		= rt2x00usb_init_rxentry,
> -	.init_txentry		= rt2x00usb_init_txentry,
> +	.clear_entry		= rt2x00usb_clear_entry,
>  	.set_device_state	= rt73usb_set_device_state,
>  	.link_stats		= rt73usb_link_stats,
>  	.reset_tuner		= rt73usb_reset_tuner,


