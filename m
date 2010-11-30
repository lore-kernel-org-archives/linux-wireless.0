Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39776 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0K3PtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:49:01 -0500
Message-ID: <4CF51CE8.9090809@ti.com>
Date: Tue, 30 Nov 2010 17:48:56 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
References: <1290079951-16793-1-git-send-email-arik@wizery.com> <1290079951-16793-18-git-send-email-arik@wizery.com>
In-Reply-To: <1290079951-16793-18-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 01:32 PM, Arik Nemtsov wrote:
> Try to read the MAC address from the on-disk NVS file.
> A non-zero MAC address is required to add an AP interface.
>
> Signed-off-by: Arik Nemtsov<arik@wizery.com>
> ---
>   drivers/net/wireless/wl12xx/main.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 708b699..e5fbbb6 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2987,6 +2987,18 @@ int wl1271_register_hw(struct wl1271 *wl)
>   	if (wl->mac80211_registered)
>   		return 0;
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
>   	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
>
>   	ret = ieee80211_register_hw(wl->hw);
The code flow of the add if (wl1271_op_add_interface) overwrites it from vif.
There are 3 places for MAC: wl, vif and NVS :)
Should be considered also PLT flow which is not goes
through wl1271_op_add_interface, but from wl1271_tm_cmd().
