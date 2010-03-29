Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:50120 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab0C2TrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:47:07 -0400
Message-ID: <4BB103B9.8040100@gmail.com>
Date: Mon, 29 Mar 2010 21:47:05 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2500usb: fix powersaving random failures
References: <201003290956.54234.linux@rainbow-software.org>
In-Reply-To: <201003290956.54234.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/10 09:56, Ondrej Zary wrote:
> This patch seems to fix random powersaving failure where the device state is
> stuck at 1 (STATE_SLEEP) and does not change to 3 (STATE_AWAKE), resulting in
> to associate and these error messages:
> phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
> No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Thanks. This looks good, but I'll rehash it against the latest state of affairs of rt2x00,
so that the disabling of powersaving is undone at the same time.

John, I'll send you the rehashed patch tomorrow.

---
Gertjan.

> 
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-29 09:38:02.000000000 +0200
> @@ -648,6 +648,10 @@
>  
>  		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 1);
>  		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
> +	} else {
> +		rt2500usb_register_read(rt2x00dev, MAC_CSR18, &reg);
> +		rt2x00_set_field16(&reg, MAC_CSR18_AUTO_WAKE, 0);
> +		rt2500usb_register_write(rt2x00dev, MAC_CSR18, reg);
>  	}
>  
>  	rt2x00dev->ops->lib->set_device_state(rt2x00dev, state);
> 

