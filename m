Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from darkstar.wilibox.com ([195.14.175.138]:59843 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbZKDNAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 08:00:17 -0500
Message-ID: <4AF17884.5000200@gmail.com>
Date: Wed, 04 Nov 2009 14:50:12 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] usb: Check results of dma_map_single
References: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net>
In-Reply-To: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2009 07:48 AM, Larry Finger wrote:
> At http://marc.info/?l=linux-wireless&m=125695331205062&w=2, a problem
> with DMA buffer processing was corrected for the libertas driver. Because
> routine usb_fill_bulk_urb() does not check that DMA is possible when
> dma_map_single() is called, this condition was not detected until the buffer
> was unmapped. By this time memory corruption had occurred.
>
> The situation is fixed by testing the returned DMA address. If not a legal
> address, a WARN_ON(1) is executed to provide traceback and the error is
> returned.
>
> Signed-off-by: Larry Finger<Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@public.gmane.org>
> ---
>
> Index: linux-2.6/drivers/usb/core/hcd.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/core/hcd.c
> +++ linux-2.6/drivers/usb/core/hcd.c
> @@ -1281,6 +1281,13 @@ static int map_urb_for_dma(struct usb_hc
>   					urb->setup_packet,
>   					sizeof(struct usb_ctrlrequest),
>   					DMA_TO_DEVICE);
> +			ret = dma_mapping_error(hcd->self.controller,
> +						urb->setup_dma);
> +			/* warn if DMA mapping failed */
> +			if (ret) {
> +				WARN_ON(1);
> +				return ret;
> +			}

First of all you forgot to add { } around everything under if statement.

I don't think WARN_ON is needed...
dma_mapping_error under most architectures return 0 or 1 so it would be
better to make some real error value. EAGAIN seems to be proper error,
since documentation says that driver should try again later.

I would write this error handler like this:

if (dma_mapping_error(hcd->self.controller, urb->setup_dma))
	ret = -EAGAIN;

>   		else if (hcd->driver->flags&  HCD_LOCAL_MEM)
>   			ret = hcd_alloc_coherent(
>   					urb->dev->bus, mem_flags,
> @@ -1299,6 +1306,13 @@ static int map_urb_for_dma(struct usb_hc
>   					urb->transfer_buffer,
>   					urb->transfer_buffer_length,
>   					dir);
> +			ret = dma_mapping_error(hcd->self.controller,
> +						urb->transfer_dma);
> +			/* warn if DMA mapping failed */
> +			if (ret) {
> +				WARN_ON(1);
> +				return ret;
> +			}

ditto

>   		else if (hcd->driver->flags&  HCD_LOCAL_MEM) {
>   			ret = hcd_alloc_coherent(
>   					urb->dev->bus, mem_flags,
