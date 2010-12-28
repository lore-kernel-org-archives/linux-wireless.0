Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:54436 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0L1M6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 07:58:01 -0500
Subject: Re: [PATCH v2 17/18] wl1271: Read MAC address from NVS file on HW
 startup
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-18-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-18-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 14:57:58 +0200
Message-ID: <1293541078.24274.33.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Try to read the MAC address from the on-disk NVS file.
> A non-zero MAC address is required to add an AP interface.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index eb2c3c5..a9f95c6 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -3025,6 +3025,18 @@ int wl1271_register_hw(struct wl1271 *wl)
>  	if (wl->mac80211_registered)
>  		return 0;
>  
> +	ret = wl1271_fetch_nvs(wl);
> +	if (ret == 0) {
> +		u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
> +
> +		wl->mac_addr[0] = nvs_ptr[11];
> +		wl->mac_addr[1] = nvs_ptr[10];
> +		wl->mac_addr[2] = nvs_ptr[6];
> +		wl->mac_addr[3] = nvs_ptr[5];
> +		wl->mac_addr[4] = nvs_ptr[4];
> +		wl->mac_addr[5] = nvs_ptr[3];
> +	}
> +
>  	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
>  
>  	ret = ieee80211_register_hw(wl->hw);

I think we need to check whether the MAC address is valid in the NVS.
Also this goes a little bit against the way we are doing things in Nokia
devices.  In our devices we don't have different files during
production, the only part that is different from one individual device
to another is in a protected area.  The NVS file in the file system is
always the same.  The one that changes is in the protected area and is
passed to the driver by a special application.

Also, how would this work if the hw is registered before udev is
running?

We need to revise the entire NVS thing.  But at least for now, while we
don't come up with a good and final solution, we should not be inventing
new ways of setting the MAC.


-- 
Cheers,
Luca.

