Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:52634 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032373AbeBOAp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 19:45:58 -0500
Date: Wed, 14 Feb 2018 16:45:49 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: cantabile <cantabile.desu@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180214164549.72ee26c3@cakuba.netronome.com> (sfid-20180215_014627_343232_CF214C94)
In-Reply-To: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 14 Feb 2018 13:34:38 +0200, cantabile wrote:
> The firmware running on the device sometimes survives a reboot 
> (firmware_running returns 1). When this happens the driver never calls 
> request_firmware, which means the kernel's firmware handling code 
> doesn't know this firmware should be cached before hibernating. Upon 
> resuming from several hours of hibernation, the firmware is no longer 
> running on the device, so the driver calls request_firmware. Since the 
> firmware was never cached, it needs to be loaded from disk, and this is 
> when the system freezes, somewhere in the xfs driver. Fix this by always 
> requesting the firmware, whether it's already running on the device or not.
> 
> Signed-off-by: John Smith <cantabile.desu@gmail.com>

Thanks for tracking this down, but this seems like the wrong
direction.

What's your hard drive?  Is it some complex configuration which
prevents the block device from coming online after resume?  

If it's really because of some peculiarities of XFS the fix should 
go there, no driver will be able to load FW on resume...

> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -420,13 +420,15 @@
>   	mt7601u_wr(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
>   					 MT_USB_DMA_CFG_TX_BULK_EN));
> 
> -	if (firmware_running(dev))
> -		return 0;
> -
>   	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
>   	if (ret)
>   		return ret;
> 
> +	if (firmware_running(dev)) {
> +		release_firmware(fw);
> +		return 0;
> +	}
> +
>   	if (!fw || !fw->data || fw->size < sizeof(*hdr))
>   		goto err_inv_fw;
> 
