Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45744 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3EGMuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:50:54 -0400
Message-ID: <1367930971.32148.85.camel@cumari.coelho.fi> (sfid-20130507_145058_020244_08591F4A)
Subject: Re: [PATCH 1/3] wlcore: allow TX BA on all TIDs
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 May 2013 15:49:31 +0300
In-Reply-To: <1367930469-29826-1-git-send-email-eliad@wizery.com>
References: <1367930469-29826-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Tue, 2013-05-07 at 15:41 +0300, Eliad Peller wrote:
> Previous fw limitation prevented us from from doing
> TX BA on TIDs 6/7. However, this restriction no
> longer exists, so enable TX BA on all TIDs.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/conf.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
> index 2b96ff8..80c1ac1 100644
> --- a/drivers/net/wireless/ti/wlcore/conf.h
> +++ b/drivers/net/wireless/ti/wlcore/conf.h
> @@ -590,8 +590,8 @@ struct conf_tx_ac_category {
>  
>  #define CONF_TX_MAX_TID_COUNT 8
>  
> -/* Allow TX BA on all TIDs but 6,7. These are currently reserved in the FW */
> -#define CONF_TX_BA_ENABLED_TID_BITMAP 0x3F
> +/* Allow TX BA on all TIDs */
> +#define CONF_TX_BA_ENABLED_TID_BITMAP 0xFF
>  
>  enum {
>  	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/

What happened with this?

https://patchwork.kernel.org/patch/1802841/

--
Luca.

