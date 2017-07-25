Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:55748 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbdGYKWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 06:22:14 -0400
Date: Tue, 25 Jul 2017 03:22:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Subject: Re: [v3] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170725102211.GT10026@atomide.com> (sfid-20170725_122232_986584_3D0A1B4D)
References: <8665E2433BC68541A24DFFCA87B70F5B36409500@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36409500@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170720 05:17]:
> The following commits:
> c815fde wlcore: spi: Populate config firmware data
> d776fc8 wlcore: sdio: Populate config firmware data
> 
> Populated the nvs entry for wilink6 and wilink7 only while it is 
> still needed for wilink8 as well. 
> This broke user space backward compatibility when upgrading from older 
> kernels, as the alternate mac address would not be read from the nvs that is 
> already present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin) 
> causing mac address change of the wlan interface.
> 
> This patch fix this and update the structure field with the same default nvs file 
> name that has been used before.
> 
> In addition, some distros hold a default wl1271-nvs.bin in the file
> system with a bogus mac address (deadbeef...) that for a wl18xx device
> also overrides the mac address that is stored inside the device.
> Warn users about this bogus mac address.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> ---
> v2->v3: add a check for default deadbeef... mac address and warn about it
> 
>  drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
>  drivers/net/wireless/ti/wlcore/sdio.c |  1 +
>  drivers/net/wireless/ti/wlcore/spi.c  |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 60aaa85..37c35aa 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5961,6 +5961,16 @@ static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
>  	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr > 0xffffff)
>  		wl1271_warning("NIC part of the MAC address wraps around!");
>  
> +	if (oui == 0xdeadbe && nic == 0xef0000)
> +		wl1271_warning("Detected unconfigured mac address in nvs.\n"
> +				"in case of using a wl12xx device, your "
> +				"device performance may not be optimized.\n"
> +				"Please use the calibrator tool to configure "
> +				"your device.\n"
> +				"When using a wl18xx device the nvs file can "
> +				"be removed as a default mac address is "
> +				"stored internally.\n");
> +
>  	for (i = 0; i < wl->num_mac_addr; i++) {
>  		wl->addresses[i].addr[0] = (u8)(oui >> 16);
>  		wl->addresses[i].addr[1] = (u8)(oui >> 8);

Hmm so why would we ever even use this bogus nvs file? In addition to warning,
I think we should just ignore the bogus nvs file completely.

Regards,

Tony
