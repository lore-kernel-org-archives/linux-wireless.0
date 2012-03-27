Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:3710 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446Ab2C0SNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 14:13:46 -0400
Message-ID: <4F720358.1010606@gmail.com> (sfid-20120327_201348_746115_38AA5ECE)
Date: Tue, 27 Mar 2012 20:13:44 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/4] rt2x00: initialize queues before giving up due to
 DMA error
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl> <1332859867-27921-4-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332859867-27921-4-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/12 16:51, Jakub Kicinski wrote:
> Don't immediately abort .start if DMA is busy before we
> initialize the queues. Some drivers do not deinitialize
> queues properly and we would fail to take over after them.
> 
> This behaviour is consistent with legacy driver.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> common/rtmp_init.c:2007
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2800pci.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index c872ba6..de975ef 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -290,7 +290,7 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
>  		msleep(10);
>  	}
>  
> -	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
> +	ERROR(rt2x00dev, "WPDMA TX/RX busy [0x%08x].\n", reg);
>  	return -EACCES;
>  }
>  EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 5a2f68f..f39587b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -501,8 +501,10 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
>  
> -	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
> -		     rt2800pci_init_queues(rt2x00dev)))
> +	/* Wait for DMA, ignore error until we initialize queues. */
> +	rt2800_wait_wpdma_ready(rt2x00dev);
> +
> +	if (unlikely(rt2800pci_init_queues(rt2x00dev)))
>  		return -EIO;
>  
>  	retval = rt2800_enable_radio(rt2x00dev);


-- 
---
Gertjan
