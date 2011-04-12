Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1DLLmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:42:24 -0400
Subject: Re: [PATCH] CHROMIUM: config: bluetooth: rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: aidapalapati@nvidia.com
Cc: olofj@chromium.org, linville@tuxdriver.com, uraval@nvidia.com,
	linux-wireless@vger.kernel.org, aritger@nvidia.com,
	krakesh@nvidia.com
In-Reply-To: <1302607528-8773-1-git-send-email-aidapalapati@nvidia.com>
References: <1302607528-8773-1-git-send-email-aidapalapati@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 13:42:20 +0200
Message-ID: <1302608540.3639.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-12 at 16:55 +0530, aidapalapati@nvidia.com wrote:
> From: Anantha Idapalapati <aidapalapati@nvidia.com>
> 
> Initial version of new "rfkill" driver to control BT radio.
> A new kernel config variable CONFIG_BT_RFKILL is defined and
> need to be used to include this driver in the kernel.
> 
> Three Platform resources are expected by the driver.
>  - Shutdown GPIO
>  - Reset GPIO and
>  - Reference Clock.
> Any/All of the resources can be defined by a platform.

So it really is a GPIO_RFKILL driver. What's bluetooth specific in it?

> BUG=none
> TEST= tested on board using BCM4329 (ventana)
> 
> Change-Id: I38e6ad3a772180b7cab5cf2d59b459b21051817e

> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -219,4 +219,12 @@ config BT_ATH3K
>  	  Say Y here to compile support for "Atheros firmware download driver"
>  	  into the kernel or say M to compile it as module (ath3k).
>  
> +config BT_RFKILL
> +	bool "Bluetooth RFKILL driver"
> +	depends on BT && RFKILL
> +	help
> +	  If you say yes here you get support of a generic bluetooth RFKILL
> +	  driver for BT chipset. Platform needs to define the resources
> +	  required.

GPIO should show up in the name and description. BT should not. The
driver should be moved to net/rfkill/ and be generic for GPIO.

> +static int bt_rfkill_probe(struct platform_device *pdev)
> +{
> +	struct rfkill *bt_rfkill_dev;
> +	struct resource *res;
> +	int ret;
> +	bool enable = false;  /* off */
> +	bool default_sw_block_state;
> +
> +	bt_rfkill = kzalloc(sizeof(*bt_rfkill), GFP_KERNEL);
> +	if (!bt_rfkill)
> +		return -ENOMEM;
> +
> +	bt_rfkill->bt_clk = clk_get(&pdev->dev, "bt_clk");

I don't think all of this is really the best way to do things. This
hardcodes "bt_clk" for example. But that's useless for a generic driver.

Please look at
http://article.gmane.org/gmane.linux.kernel/1124137

That driver requires that some specific code registers a platform device
with the right data, but you could do that for this as well and get rid
of all the hardcoded strings and the hard-coded assumption that it's for
bluetooth. I think that approach is MUCH better, since then if somebody
has a Wifi or GPS device with GPIO control they can reuse this code.

johannes

