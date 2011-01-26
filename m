Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:43663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1AZOBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 09:01:02 -0500
Subject: Re: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta
 connection
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1295156534-4178-3-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:01:10 +0200
Message-ID: <1296050470.2039.47.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
> If a sta starts transmitting immediately after authentication, sometimes
> the FW deauthenticates it. Fix this by marking the sta "in-connection"
> in FW before sending the autentication response.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Looks good.  So you don't need to remove the STA from the inconnection
list later? Does the firmware remove it automatically?


> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index fdec4a3..d3ba27c 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -70,6 +70,22 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
>  	}
>  }
>  
> +static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
> +					      struct sk_buff *skb)

This indentation seems wrong.


> +	/*
> +	 * add the station to the known list before broadcasting the
> +	 * authentication response. this way it won't get de-authed by FW
> +	 * when transmitting too soon.
> +	 */

Broadcasting the auth response? Isn't it unicast?


> @@ -238,6 +254,9 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
>  	if (ret < 0)
>  		return ret;
>  
> +	if (wl->bss_type == BSS_TYPE_AP_BSS)
> +		wl1271_tx_ap_update_inconnection_sta(wl, skb);
> +
>  	wl1271_tx_fill_hdr(wl, skb, extra, info);

Isn't there any other place where you can put this? Doesn't it add too
much overhead if you do it for every TX frame?


-- 
Cheers,
Luca.

