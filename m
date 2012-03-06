Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46048 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031133Ab2CFW4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:56:16 -0500
Message-ID: <4F5695CC.3010206@hauke-m.de> (sfid-20120306_235620_191655_8A5C5378)
Date: Tue, 06 Mar 2012 23:55:08 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, larry.finger@lwfinger.net,
	florian@openwrt.org, m@bues.ch
Subject: Re: [RFT][PATCH] b43: fix logic in GPIO configuration
References: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 11:11 PM, Rafał Miłecki wrote:
> By using reverted mask we were taking over pins we were not supporsed to
> touch. After fixing this workaround for BCM5354 should not be needed
> anymore.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 1d633f3..8a89885 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -2706,8 +2706,6 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  		mask |= 0x0060;
>  		set |= 0x0060;
>  	}
> -	if (dev->dev->chip_id == 0x5354)
> -		set &= 0xff02;
>  	if (0 /* FIXME: conditional unknown */ ) {
>  		b43_write16(dev, B43_MMIO_GPIO_MASK,
>  			    b43_read16(dev, B43_MMIO_GPIO_MASK)
> @@ -2730,7 +2728,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  	case B43_BUS_BCMA:
>  		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
>  				(bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
> -					BCMA_CC_GPIOCTL) & mask) | set);
> +					BCMA_CC_GPIOCTL) & ~mask) | set);
>  		break;
>  #endif
>  #ifdef CONFIG_B43_SSB
> @@ -2739,7 +2737,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  		if (gpiodev)
>  			ssb_write32(gpiodev, B43_GPIO_CONTROL,
>  				    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
> -				    & mask) | set);
> +				    & ~mask) | set);
>  		break;
>  #endif
>  	}

Hi,

This patch did not helped fixing my problem. The ucode still takes over
the GPIOs of the buttons with firmware version 666.2. I am getting the
following messages:

[   83.620000] b43-phy0: Loading firmware version 666.2 (2011-02-23
01:15:07)
[   83.624000] Init value of B43_GPIO_CONTROL: 0x0
[   83.632000] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[   83.640000] hotplug_button: action: pressed, name: reset, seen: 17179652
[   83.644000] hotplug_button: action: pressed, name: ses, seen: 17179652
[   89.404000] b43-phy0 debug: Chip initialized

