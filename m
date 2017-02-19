Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34281 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdBSD2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 22:28:36 -0500
Received: by mail-ot0-f194.google.com with SMTP id 45so5030520otd.1
        for <linux-wireless@vger.kernel.org>; Sat, 18 Feb 2017 19:27:02 -0800 (PST)
Subject: Re: [PATCH] Fix rtl8187 multicast reception
To: Nils Holland <nholland@tisys.org>, linux-wireless@vger.kernel.org
References: <20170219013520.GA3190@tisys.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <2eb1dd33-4d71-86b7-c579-412419e2a2e5@lwfinger.net> (sfid-20170219_043418_824701_39BBE473)
Date: Sat, 18 Feb 2017 21:26:59 -0600
MIME-Version: 1.0
In-Reply-To: <20170219013520.GA3190@tisys.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2017 07:35 PM, Nils Holland wrote:
> The rtl8187 doesn't seem to receive multicast data, which, among other
> thinks, make it fail to receive RAs in IPv6 networks.
>
> The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
> have any effect at all. Fix this issue by setting
> RTL818X_RX_CONF_MONITOR instead, which puts the card into monitor mode,
> and fixes the problem.
>
> Signed-off-by: Nils Holland <nholland@tisys.org>
> ---
> The problem and solution have been tested on an rtl8187b (0bda:8197), but
> the fix changes behavior on other cards supported by the driver as well
> (like non-b 8187's). Due to lack of hardware, I unfortunately cannot say
> if the issue exists on these cards in the first place, or if the fix has
> any unwanted consequences there.
>
> If people consider it a bad idea to just always put the card into monitor
> mode (for example, for performance reasons), I could imagine rewriting this
> patch so that a module parameter controls this behavior instead.

I would hate to make such a change in the behavior of the driver, and have it be 
applied without the user having any say. The fact that setting 
RTL818X_RX_CONF_MULTICAST does not have the desired effect may be due to a 
firmware error; however, there is no chance of making a change there as these 
devices have embedded/fixed fw.

I would prefer a module parameter that would allow this change to be implemented 
only if the user takes special action. I suspect that you will have no 
difficulty preparing such a change. If that is not true, I would be happy to help.

Larry

>
>  drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> index 231f84db9ab0..56a8686cd367 100644
> --- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
> @@ -946,8 +946,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>  		      (7 << 13 /* RX FIFO threshold NONE */) |
>  		      (7 << 10 /* MAX RX DMA */) |
>  		      RTL818X_RX_CONF_RX_AUTORESETPHY |
> -		      RTL818X_RX_CONF_ONLYERLPKT |
> -		      RTL818X_RX_CONF_MULTICAST;
> +		      RTL818X_RX_CONF_ONLYERLPKT;
>  		priv->rx_conf = reg;
>  		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
>
> @@ -1319,12 +1318,11 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
>  		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
>  	if (changed_flags & FIF_CONTROL)
>  		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
> -	if (changed_flags & FIF_OTHER_BSS)
> -		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
> -	if (*total_flags & FIF_ALLMULTI || multicast > 0)
> -		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
> +	if (*total_flags & FIF_OTHER_BSS ||
> +	    *total_flags & FIF_ALLMULTI || multicast > 0)
> +		priv->rx_conf |= RTL818X_RX_CONF_MONITOR;
>  	else
> -		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
> +		priv->rx_conf &= ~RTL818X_RX_CONF_MONITOR;
>
>  	*total_flags = 0;
>
> @@ -1332,10 +1330,10 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
>  		*total_flags |= FIF_FCSFAIL;
>  	if (priv->rx_conf & RTL818X_RX_CONF_CTRL)
>  		*total_flags |= FIF_CONTROL;
> -	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
> +	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR) {
>  		*total_flags |= FIF_OTHER_BSS;
> -	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
>  		*total_flags |= FIF_ALLMULTI;
> +	}
>
>  	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
>  }
>


-- 
If I was stranded on an island and the only way to get off
the island was to make a pretty UI, I’d die there.

Linus Torvalds
