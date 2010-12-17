Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout027.mac.com ([17.148.16.102]:58336 "EHLO
	asmtpout027.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0LQJeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 04:34:00 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] (unknown [87.201.169.175])
 by asmtp027.mac.com (Oracle Communications Messaging Exchange Server 7u4-18.01
 64bit (built Jul 15 2010)) with ESMTPSA id <0LDK0053FFWBKA90@asmtp027.mac.com>
 for linux-wireless@vger.kernel.org; Fri, 17 Dec 2010 01:33:51 -0800 (PST)
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
Date: Fri, 17 Dec 2010 13:33:36 +0400
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
Message-id: <5BEEB020-F254-4885-91B1-61FD38F7E19A@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>
 <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
 <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
To: panduranga <x0125717@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 17, 2010, at 9:11 AM, panduranga wrote:

> add the following patch (http://www.spinics.net/lists/linux-wireless/msg59391.html) by Arik Nemtsov.
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 708b699..e5fbbb6 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2987,6 +2987,18 @@ int wl1271_register_hw(struct wl1271 *wl)
> 	if (wl->mac80211_registered)
> 		return 0;
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
> 	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
> 
> 	ret = ieee80211_register_hw(wl->hw);

Where should the firmware file be located? What name should I give the firmware file : firmware.bin ? 

I get the following error after adding the following patch:

[   62.835174] wl1271: ERROR could not get nvs file: -2
[   62.887786] wl1271: loaded
[   62.890655] wl1271: initialized


Elvis Dowson
