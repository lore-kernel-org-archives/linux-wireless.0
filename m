Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57168 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752107AbdHIR1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 13:27:00 -0400
Date: Wed, 9 Aug 2017 10:26:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v6] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170809172651.GA3934@atomide.com> (sfid-20170809_192713_818256_E7F0A195)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170809 00:55]:
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -6040,6 +6040,21 @@ static int wl1271_register_hw(struct wl1271 *wl)
>  		nic_addr = wl->fuse_nic_addr + 1;
>  	}
>  
> +	if (oui_addr == 0xdeadbe && nic_addr == 0xef0000) {
> +		wl1271_warning("Detected unconfigured mac address in nvs.\n"
> +				"derive from fuse instead.\n"
> +				"in case of using a wl12xx device, your "
> +				"device performance may not be optimized.\n"
> +				"Please use the calibrator tool to configure "
> +				"your device.\n"
> +				"When using a wl18xx device this default nvs "
> +				"file can be removed from the file system\n");
> +
> +		oui_addr = wl->fuse_oui_addr;
> +		/* fuse has the BD_ADDR, the WLAN addresses are the next two */
> +		nic_addr = wl->fuse_nic_addr + 1;
> +	}
> +
>  	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr);

I just gave this a quick try on omap3-evm with wl1271, now I get
mac address of 00:00:00:00:00:01 :) So looks like at least wl1271 needs
to use the random mac address here.

Note that we should now have struct wilink_family_data available
so maybe that can be used to check if the hardware mac address
exists?

Regards,

Tony
