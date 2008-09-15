Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:14157 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbYIORLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 13:11:38 -0400
Received: by ey-out-2122.google.com with SMTP id 6so981827eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 10:11:36 -0700 (PDT)
To: Mikko =?utf-8?q?Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
Date: Mon, 15 Sep 2008 19:11:32 +0200
Cc: rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1221494693.14102.22.camel@virkkmi-linux>
In-Reply-To: <1221494693.14102.22.camel@virkkmi-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200809151911.32834.IvDoorn@gmail.com> (sfid-20080915_191143_815533_5EE1937F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 September 2008, Mikko Virkkil=C3=A4 wrote:
> Modeled after the waiting-for-ack queue in the zd1211rw
> driver, this patch adds a similar queue to the rt2x00. If
> the tx state of a packet is unknown and a tx ack or
> tx fail is needed, then the packet is pushed to a
> waiting-for-ack queue. Each time an ack is received the
> queue is checked and a possible match is reported to
> mac80211 as a tx ack.
>=20
> If the queue gets filled up the oldest waiting packet
> will be discarded and a tx fail will be reported.

I believe it was mentioned it earlier as well, but this code belongs
to mac80211 rather than being copied in all individual drivers.

I think the best solution would be:
 - Drivers set *unknown TX status* flag for mac80211
 - Mac80211 sets the FIF_CONTROL flag for the RX filter (or adds a new
   more specific flag FIF_ACK for hardware that allows this specific fi=
ltering (rt2800))
 - Driver will set a *unknown TX status* flag per send out frame
 - Mac80211 keeps track of ACK responses, and decides what to do when
   no ACK has been received for the frame.

Note that rt61 might be tricky since that does support TX status report=
ing,
but it fails in only 1% of the cases to do this, which means enabling t=
his for rt61
would be far too much overhead.

> This doesn't use timers so a message might in theory be
> stuck in the queue indefinitely.

Well you wouldn't need timers actually, if you have a list of packets
waiting to be acked you can expect the frames to be acked in the order
of which they were send (when using the same queue).

> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wi=
reless/rt2x00/rt2x00dev.c
> index 2f3bfc6..57020de 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -495,6 +495,30 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2=
x00dev)
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
> =20
> +static struct sk_buff *rt2x00lib_get_match_from_ack_queue(
> +	struct sk_buff_head *q, struct ieee80211_hdr *rx_hdr)
> +{
> +	struct sk_buff *skb;
> +	for (skb =3D q->next; skb !=3D (struct sk_buff *)q; skb =3D skb->ne=
xt) {
> +		struct ieee80211_hdr *tx_hdr;
> +		tx_hdr =3D (struct ieee80211_hdr *)skb->data;
> +		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1))) {

Why is this likely() do we really expect the first ack in the list to b=
e the rigth one?
And is this enough to match a frame to an ack?

> @@ -560,7 +584,22 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	 * status report back.
>  	 */
>  	if (tx_info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> -		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
> +		if (test_bit(TXDONE_UNKNOWN, &txdesc->flags)) {
> +			struct sk_buff *failed_skb;
> +			failed_skb =3D rt2x00lib_push_to_ack_queue(
> +				&rt2x00dev->ack_wait_queue, entry->skb);
> +			if (failed_skb) {
> +				struct ieee80211_tx_info *info;
> +				info =3D IEEE80211_SKB_CB(failed_skb);
> +				info->status.excessive_retries =3D 1;
> +				rt2x00dev->link.qual.tx_failed++;
> +				rt2x00dev->low_level_stats.dot11RTSFailureCount++;
> +				DEBUG(rt2x00dev, "ACK queue: fail oldest\n");
> +				ieee80211_tx_status_irqsafe(rt2x00dev->hw,
> +					failed_skb);
> +			}
> +		} else
> +			ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
>  	else
>  		dev_kfree_skb_irq(entry->skb);
> =20
> @@ -694,7 +733,26 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00d=
ev,
>  	 * mac80211 will clean up the skb structure.
>  	 */
>  	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_RXDONE, entry->skb);
> -	ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);
> +
> +	if (ieee80211_is_ack(hdr->frame_control)) {
> +		struct sk_buff *match =3D NULL;
> +		match =3D rt2x00lib_get_match_from_ack_queue(
> +			&rt2x00dev->ack_wait_queue,	hdr);
> +		if (match) {
> +			struct ieee80211_tx_info *tx_info;
> +			tx_info =3D IEEE80211_SKB_CB(match);
> +			tx_info->flags |=3D IEEE80211_TX_STAT_ACK;
> +			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;

Incorrect, you need to check if this was an RTS frame if you want to in=
crement this counter.

> +			rt2x00dev->link.qual.tx_success++;
> +			DEBUG(rt2x00dev, "ACK hit in queue\n")
> +			ieee80211_tx_status_irqsafe(rt2x00dev->hw, match);
> +		} else {
> +			DEBUG(rt2x00dev, "Got ACK but not in queue\n")
> +		}
> +		/* Unmap done at start of func, so just free */
> +		dev_kfree_skb_irq(entry->skb);
> +    } else
> +		ieee80211_rx_irqsafe(rt2x00dev->hw, entry->skb, rx_status);

This breaks when mac80211 requested FIF_CONTROL, you are now always
filtering out ACK frames no matter what mac80211 requested.

>  	/*
>  	 * Replace the skb with the freshly allocated one.
> @@ -974,6 +1032,11 @@ static int rt2x00lib_initialize(struct rt2x00_d=
ev *rt2x00dev)
>  		return status;
> =20
>  	/*
> +	 * Initialize queue for messages waiting for acks
> +	 */
> +	skb_queue_head_init(&rt2x00dev->ack_wait_queue);
> +
> +	/*
>  	 * Initialize the device.
>  	 */
>  	status =3D rt2x00dev->ops->lib->initialize(rt2x00dev);
> @@ -1107,6 +1170,14 @@ exit:
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_probe_dev);
> =20
> +static void rt2x00lib_free_ack_wait_queue(struct rt2x00_dev *rt2x00d=
ev)
> +{
> +	struct sk_buff_head *ack_wait_queue =3D &rt2x00dev->ack_wait_queue;
> +	struct sk_buff *skb;
> +	while ((skb =3D skb_dequeue(ack_wait_queue)))
> +		dev_kfree_skb_any(skb);
> +}
> +
>  void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  {
>  	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
> @@ -1142,6 +1213,11 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *r=
t2x00dev)
>  	 * Free queue structures.
>  	 */
>  	rt2x00queue_free(rt2x00dev);
> +
> +	/*
> +	 * Free ack wait queue
> +	 */
> +	rt2x00lib_free_ack_wait_queue(rt2x00dev);

	skb_queue_purge(&rt2x00dev->ack_wait_queue) ?

>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_remove_dev);
> =20
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wire=
less/rt2x00/rt73usb.c
> index 27dde3e..e082d30 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -593,8 +593,7 @@ static void rt73usb_config_filter(struct rt2x00_d=
ev *rt2x00dev,
>  			   !(filter_flags & FIF_FCSFAIL));
>  	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_PHYSICAL,
>  			   !(filter_flags & FIF_PLCPFAIL));
> -	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL,
> -			   !(filter_flags & FIF_CONTROL));
> +	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_CONTROL, 0);
>  	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_NOT_TO_ME,
>  			   !(filter_flags & FIF_PROMISC_IN_BSS));
>  	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_TO_DS,
> @@ -604,8 +603,7 @@ static void rt73usb_config_filter(struct rt2x00_d=
ev *rt2x00dev,
>  	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_MULTICAST,
>  			   !(filter_flags & FIF_ALLMULTI));
>  	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_BROADCAST, 0);
> -	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS,
> -			   !(filter_flags & FIF_CONTROL));
> +	rt2x00_set_field32(&reg, TXRX_CSR0_DROP_ACK_CTS, 0);
>  	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
>  }
> =20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
