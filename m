Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:46344 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbYBAWZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:25:50 -0500
Received: by an-out-0708.google.com with SMTP id d31so315402and.103
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 14:25:49 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Fri, 1 Feb 2008 23:25:25 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg> <1201902217.4188.82.camel@johannes.berg>
In-Reply-To: <1201902217.4188.82.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802012325.26163.IvDoorn@gmail.com> (sfid-20080201_222552_728381_079DC989)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 February 2008, Johannes Berg wrote:
> Any thoughts on this patch? The only thing it should really actually
> change is removing the IBSS beacon queue configuration, but as I've
> explained previously that really has to be done by the driver because we
> don't know whether the driver even uses queues for beaconing... Also we
> never reset that info.
> 
> Also, I'm wondering, iwl4965 has 16 queues, can it use 4 for regular WMM
> and the other 12 for aggregation? And how does it configure the access
> parameters for aggregation? I don't see conf_tx() calls anywhere for
> that.

Like I mentioned earlier, ring/queue handling has received an overhaul,
so not much of the rt2x00 part of this patch will apply after the update.
However the change should be easier afterwards. ;)

> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-02-01 22:05:11.038210937 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-02-01 22:09:22.358177843 +0100
> @@ -100,6 +100,12 @@
>  #define MGMT_FRAME_SIZE	256
>  
>  /*
> + * Internal queue numbers for beacon and buffered broadcast/multicast traffic.
> + */
> +#define RT2X00_QUEUE_BEACON	100
> +#define RT2X00_QUEUE_BCMC	101

Personally I think these queue identifiers should be completely seperated from the ieee80211_queue
enumeration, and not be used inside a variable mixed.
But that will be implementation details for later, and something I should probably take care of. ;)


> +/*
>   * Number of entries in a packet ring.
>   * PCI devices only need 1 Beacon entry,
>   * but USB devices require a second because they
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-02-01 22:02:56.938182780 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-02-01 22:06:28.338180393 +0100
> @@ -49,9 +49,9 @@ struct data_ring *rt2x00lib_get_ring(str
>  	if (!rt2x00dev->bcn || !beacon)
>  		return NULL;
>  
> -	if (queue == IEEE80211_TX_QUEUE_BEACON)
> +	if (queue == RT2X00_QUEUE_BEACON)
>  		return &rt2x00dev->bcn[0];
> -	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
> +	else if (queue == RT2X00_QUEUE_BCMC)
>  		return &rt2x00dev->bcn[1];
>  
>  	return NULL;
> @@ -502,7 +502,7 @@ static void rt2x00lib_beacondone_schedul
>  	struct rt2x00_dev *rt2x00dev =
>  	    container_of(work, struct rt2x00_dev, beacon_work);
>  	struct data_ring *ring =
> -	    rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
> +	    rt2x00lib_get_ring(rt2x00dev, RT2X00_QUEUE_BEACON);
>  	struct data_entry *entry = rt2x00_get_data_entry(ring);
>  	struct sk_buff *skb;
>  
> @@ -665,8 +665,8 @@ void rt2x00lib_write_tx_desc(struct rt2x
>  	 */
>  	if (control->queue < rt2x00dev->hw->queues)
>  		desc.queue = control->queue;
> -	else if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
> -		 control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
> +	else if (control->queue == RT2X00_QUEUE_BEACON ||
> +		 control->queue == RT2X00_QUEUE_BCMC)
>  		desc.queue = QUEUE_MGMT;
>  	else
>  		desc.queue = QUEUE_OTHER;
> @@ -717,7 +717,7 @@ void rt2x00lib_write_tx_desc(struct rt2x
>  	 * Beacons and probe responses require the tsf timestamp
>  	 * to be inserted into the frame.
>  	 */
> -	if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
> +	if (control->queue == RT2X00_QUEUE_BEACON ||
>  	    is_probe_resp(frame_control))
>  		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc.flags);
>  
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00pci.c	2008-02-01 22:07:08.708181857 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00pci.c	2008-02-01 22:07:41.538180176 +0100
> @@ -43,11 +43,10 @@ int rt2x00pci_beacon_update(struct ieee8
>  	struct data_entry *entry;
>  
>  	/*
> -	 * Just in case mac80211 doesn't set this correctly,
> -	 * but we need this queue set for the descriptor
> -	 * initialization.
> +	 * mac80211 doesn't set the queue but we use an internal
> +	 * number here that we later translate to the right thing.
>  	 */
> -	control->queue = IEEE80211_TX_QUEUE_BEACON;
> +	control->queue = RT2X00_QUEUE_BEACON;
>  	ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
>  	entry = rt2x00_get_data_entry(ring);
>  
> --- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2008-02-01 22:09:43.378180447 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2008-02-01 22:12:26.208178873 +0100
> @@ -1049,8 +1049,9 @@ static int rt61pci_init_rings(struct rt2
>  	rt2x00pci_register_write(rt2x00dev, TX_RING_CSR0, reg);
>  
>  	rt2x00pci_register_read(rt2x00dev, TX_RING_CSR1, &reg);
> +	/* XXX: what is this fifth queue? */
>  	rt2x00_set_field32(&reg, TX_RING_CSR1_MGMT_RING_SIZE,
> -			   rt2x00dev->tx[IEEE80211_TX_QUEUE_DATA4].stats.limit);
> +			   rt2x00dev->tx[4].stats.limit);

MGMT frames only, but since mac80211 doesn't handle seperate queues for management frames,
I never added a filter for routing management frames over the queue. Doing something like
that is a bad idea anyway, so this queue is just dummy unless there are uses for a 
fifth TX queue.

Other then that, the patch is fine with me, but not this patch probably needs to be respinned after
my rt2x00 queue and virtual interfaces overhaul.

Ivo
