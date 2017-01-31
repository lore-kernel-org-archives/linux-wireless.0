Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAaHal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:30:41 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Iain Hunter <drhunter95@gmail.com>
Cc: linux-wireless@vger.kernel.org, Iain Hunter <i-hunter1@ti.com>
Subject: Re: [PATCH] wlcore: disable multicast filter in AP mode
References: <20170130144936.6699-1-i-hunter1@ti.com>
Date: Tue, 31 Jan 2017 09:22:58 +0200
In-Reply-To: <20170130144936.6699-1-i-hunter1@ti.com> (Iain Hunter's message
        of "Mon, 30 Jan 2017 14:49:36 +0000")
Message-ID: <87r33jg0bx.fsf@purkki.adurom.net> (sfid-20170131_083044_586529_F0959400)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Iain Hunter <drhunter95@gmail.com> writes:

> Enable AP support allmulticast for MDNS. It can be enabled by bringing up 
>
> the interface with ip command with the argument allmulticast on
>
> Signed-off-by: Iain Hunter <i-hunter1@ti.com>

The commit log looks now ok, except there's an unnecessare empty line.
But I can fix that.

> @@ -3281,6 +3281,20 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
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
> + 			if (*total & FIF_ALLMULTI)
> +				ret = wl1271_acx_group_address_tbl(wl, wlvif,
> +								   false,
> +								   NULL, 0);
> +              
> +                }
> +
>  	}

Sorry, I missed this earlier but here you don't check ret value at all.
I think you should bail out from the look if an error happens, like
other commands in the same loop does.

-- 
Kalle Valo
