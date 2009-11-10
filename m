Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZKJHCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 02:02:47 -0500
Subject: Re: [PATCH] libertas if_usb: tiny usb-rx overhaul
From: Dan Williams <dcbw@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200911042313.00089.chunkeey@googlemail.com>
References: <1256924714.4030.44.camel@macbook.infradead.org>
	 <1257364903.14545.51.camel@localhost.localdomain>
	 <20091104211600.GE10786@tuxdriver.com>
	 <200911042313.00089.chunkeey@googlemail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 23:02:36 -0800
Message-Id: <1257836556.19597.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-04 at 23:12 +0100, Christian Lamparter wrote:
> This patch reorganizes libertas' if_usb rx routines.
> 
>  - URB_ZERO_PACKET flag has no use for urbs for 
>    incoming endpoints.
>     
>  - skb_tail_pointer(skb) should be used to get
>    the right rx_buf pointer.
> 
>  - most + IPFIELD_ALIGN_OFFSET can be prevented by
>    moving skb_reserve up right after allocation.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

With 5.110.22p23 firmware if anyone cares...  Thanks!

Acked-by: Dan Williams <dcbw@redhat.com>
Tested-by: Dan Williams <dcbw@redhat.com>

> ---
> any Tested-by: ?
> ---
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index a8262de..f220db9 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -506,17 +506,16 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
>  		goto rx_ret;
>  	}
>  
> +	skb_reserve(skb, IPFIELD_ALIGN_OFFSET);
>  	cardp->rx_skb = skb;
>  
>  	/* Fill the receive configuration URB and initialise the Rx call back */
>  	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
>  			  usb_rcvbulkpipe(cardp->udev, cardp->ep_in),
> -			  skb->data + IPFIELD_ALIGN_OFFSET,
> +			  skb_tail_pointer(skb),
>  			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
>  			  cardp);
>  
> -	cardp->rx_urb->transfer_flags |= URB_ZERO_PACKET;
> -
>  	lbs_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
>  	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
>  		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
> @@ -557,7 +556,7 @@ static void if_usb_receive_fwload(struct urb *urb)
>  	}
>  
>  	if (cardp->fwdnldover) {
> -		__le32 *tmp = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
> +		__le32 *tmp = (__le32 *)skb->data;
>  
>  		if (tmp[0] == cpu_to_le32(CMD_TYPE_INDICATION) &&
>  		    tmp[1] == cpu_to_le32(MACREG_INT_CODE_FIRMWARE_READY)) {
> @@ -572,8 +571,7 @@ static void if_usb_receive_fwload(struct urb *urb)
>  		return;
>  	}
>  	if (cardp->bootcmdresp <= 0) {
> -		memcpy (&bootcmdresp, skb->data + IPFIELD_ALIGN_OFFSET,
> -			sizeof(bootcmdresp));
> +		memcpy(&bootcmdresp, skb->data, sizeof(bootcmdresp));
>  
>  		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
>  			kfree_skb(skb);
> @@ -619,8 +617,7 @@ static void if_usb_receive_fwload(struct urb *urb)
>  		return;
>  	}
>  
> -	memcpy(syncfwheader, skb->data + IPFIELD_ALIGN_OFFSET,
> -	       sizeof(struct fwsyncheader));
> +	memcpy(syncfwheader, skb->data, sizeof(struct fwsyncheader));
>  
>  	if (!syncfwheader->cmd) {
>  		lbs_deb_usb2(&cardp->udev->dev, "FW received Blk with correct CRC\n");
> @@ -665,7 +662,6 @@ static inline void process_cmdtypedata(int recvlength, struct sk_buff *skb,
>  		return;
>  	}
>  
> -	skb_reserve(skb, IPFIELD_ALIGN_OFFSET);
>  	skb_put(skb, recvlength);
>  	skb_pull(skb, MESSAGE_HEADER_LEN);
>  
> @@ -719,7 +715,7 @@ static void if_usb_receive(struct urb *urb)
>  	int recvlength = urb->actual_length;
>  	uint8_t *recvbuff = NULL;
>  	uint32_t recvtype = 0;
> -	__le32 *pkt = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
> +	__le32 *pkt = (__le32 *)skb->data;
>  	uint32_t event;
>  
>  	lbs_deb_enter(LBS_DEB_USB);
> @@ -732,7 +728,7 @@ static void if_usb_receive(struct urb *urb)
>  			goto setup_for_next;
>  		}
>  
> -		recvbuff = skb->data + IPFIELD_ALIGN_OFFSET;
> +		recvbuff = skb->data;
>  		recvtype = le32_to_cpu(pkt[0]);
>  		lbs_deb_usbd(&cardp->udev->dev,
>  			    "Recv length = 0x%x, Recv type = 0x%X\n",
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev

