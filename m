Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdBBGXu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 01:23:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Iain Hunter <drhunter95@gmail.com>
Cc: linux-wireless@vger.kernel.org, Iain Hunter <i-hunter1@ti.com>
Subject: Re: [PATCH v3] wlcore: disable multicast filter in AP mode
References: <20170131104840.10366-1-i-hunter1@ti.com>
        <20170131124431.11675-1-i-hunter1@ti.com>
Date: Thu, 02 Feb 2017 08:23:46 +0200
In-Reply-To: <20170131124431.11675-1-i-hunter1@ti.com> (Iain Hunter's message
        of "Tue, 31 Jan 2017 12:44:31 +0000")
Message-ID: <87mve5f6vh.fsf@purkki.adurom.net> (sfid-20170202_072518_839052_B7E661DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Iain Hunter <drhunter95@gmail.com> writes:

> Enable AP support for allmulticast for MDNS. It can be enabled by bringing
> up the interface with ip command with argument allmulticast on
>
> Signed-off-by:Iain Hunter <i-hunter1@ti.com>

There should be a space after ':' and before your name.

> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -3281,6 +3281,21 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
>  			if (ret < 0)
>  				goto out_sleep;
>  		}
> +
> +        /*
> +         * If interface in AP mode and created with allmulticast then disable
> +         * the firmware filters so that all multicast packets are passed
> +         * This is mandatory for MDNS based discovery protocols 
> +         */
> + 		if (wlvif->bss_type == BSS_TYPE_AP_BSS) {

The comment looks wrongly indented.

> + 			if (*total & FIF_ALLMULTI) {
> +				ret = wl1271_acx_group_address_tbl(wl, wlvif,
> +							false,
> +							NULL, 0);
> +				if (ret < 0)
> +					goto out_sleep;
> +				}

Also the closing bracket here is not indented correctly.

-- 
Kalle Valo
