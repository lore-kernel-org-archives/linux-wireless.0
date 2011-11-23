Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1KWKsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 05:48:55 -0500
Date: Wed, 23 Nov 2011 11:51:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111123105106.GA7943@redhat.com> (sfid-20111123_114859_348653_0186BBFE)
References: <20111116100915.GA2191@redhat.com>
 <20111122214940.GH8452@tuxdriver.com>
 <20111123080506.GB9833@redhat.com>
 <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-HE8MWV5Xv9e407iDn83UFvjua52mYGEJuJnQuQvnyog@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 09:51:38AM +0100, Helmut Schaa wrote:
> Are we 100% sure that the rt2800pci device is generating the interrupts?
No, good point. There is also usb_hcd_irq() registered on that line.

I wonder if there is method to control irq routing. I don't know 
about any that could allow to control assignment of individual irq's.
There are nomsi, acpi=noirq and noacpi kernel parameters which influence
irq routing, so perhaps with a bit of luck they could cause exclusively
Ralink device will be assigned to irq line>

Amir, could you configure system to assure Ralink device have
assigned exclusive (non shared) irq line. Interrupts assignment
can be seen in /proc/interrupts. If above kernel parameters do not
achieve that, you can try disabling USB in BIOS and (if possible)
changing pci slot of Ralink device.
 
> Just a shot in the dark but instead of masking out interrupts we don't handle
> just enable all device interrupts. Mind to try the below patch?
Amir, the best way is to test it on top of compat wireless, if you will
be unable to do this, I'll prepare fedora koji build with patch.

Thanks
Stanislaw 

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c
> b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 4dc2d0f..c0badec 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -437,24 +437,24 @@ static void rt2800pci_toggle_irq(struct
> rt2x00_dev *rt2x00dev,
> 
>  	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
>  	rt2x00pci_register_read(rt2x00dev, INT_MASK_CSR, &reg);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, 0);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDELAYINT, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDELAYINT, mask);
>  	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, mask);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, 0);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_AC0_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_AC1_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_AC2_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_AC3_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_HCCA_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_MGMT_DMA_DONE, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_MCU_COMMAND, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_RXTX_COHERENT, mask);
>  	rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, mask);
>  	rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, mask);
>  	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, mask);
>  	rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, mask);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, 0);
> -	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, 0);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_GPTIMER, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_RX_COHERENT, mask);
> +	rt2x00_set_field32(&reg, INT_MASK_CSR_TX_COHERENT, mask);
>  	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
>  	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
