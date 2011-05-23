Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45875 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab1EWTwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 15:52:10 -0400
Received: by vws1 with SMTP id 1so4389522vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 12:52:09 -0700 (PDT)
Message-ID: <4DDABAE6.10601@lwfinger.net> (sfid-20110523_215215_808287_59F179ED)
Date: Mon, 23 May 2011 14:52:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/8] rtlwifi: Assign rx buffer ownership to hardware last
References: <4DDA6724.1070809@ring3k.org>
In-Reply-To: <4DDA6724.1070809@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 08:54 AM, Mike McCormack wrote:
> Ownership of an rx buffer should only be given to the hardware
> after all other changes are written, otherwise there's
> a potential race.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index fd74396..4fe405a 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -782,8 +782,6 @@ done:
>   		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
>   					    HW_DESC_RXBUFF_ADDR,
>   					    (u8 *)&bufferaddress);
> -		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
> -					    (u8 *)&tmp_one);
>   		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
>   					    HW_DESC_RXPKT_LEN,
>   					    (u8 *)&rtlpci->rxbuffersize);
> @@ -793,6 +791,9 @@ done:
>   						    HW_DESC_RXERO,
>   						    (u8 *)&tmp_one);
>
> +		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
> +					    (u8 *)&tmp_one);
> +
>   		index = (index + 1) % rtlpci->rxringcount;
>   	}
>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry

