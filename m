Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40227 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZKDTaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:30:14 -0500
Date: Wed, 4 Nov 2009 14:16:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, stern@rowland.harvard.edu, davem@davemloft.net
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
Message-ID: <20091104191642.GB10786@tuxdriver.com>
References: <1256924714.4030.44.camel@macbook.infradead.org> <200910301944.14740.chunkeey@googlemail.com> <1256928681.4030.112.camel@macbook.infradead.org> <200910302026.47131.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200910302026.47131.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is anyone evaluating these suggestions?  Should I be expecting properly
formatted patch emails?

John

On Fri, Oct 30, 2009 at 08:26:46PM +0100, Christian Lamparter wrote:
> On Friday 30 October 2009 19:51:21 David Woodhouse wrote:
> > On Fri, 2009-10-30 at 19:44 +0100, Christian Lamparter wrote:
> > > 
> > > that's just a fill-in macro.
> > > AFAICT usb_submit_urb does the tricky dma mapping.
> > 
> > Ah, that makes sense. In that case, all we need to do is make
> > map_urb_for_dma() do the right thing.
> 
> well, but while we're on the subject of libertas.
> 
> I took a quick look around and wrote down some hopefully _helpful_ comments.
> That said, I don't have any libertas hw, so I have no idea if the attached
> code will actually do what its supposed to do... I'll leave it up to the
> professionals to test & write a real fix(es) with a proper commit message. 
> 
> Notes:
> - most + IPFIELD_ALIGN_OFFSET can be replaced by a
>   single skb_reserve, right after allocation.
> 
> - skb_tail_pointer(skb) should be used to get
>   the right rx_buf pointer.
> 
> - setting URB_ZERO_PACKET is pointless for urbs
>   which are submitted to an IN endpoint.
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
> -			  (void *) (skb->tail + (size_t) IPFIELD_ALIGN_OFFSET),
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
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
