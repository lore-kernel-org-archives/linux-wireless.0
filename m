Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:37968 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab0J2NPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 09:15:54 -0400
Date: Fri, 29 Oct 2010 11:15:52 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20101029111552.1e96be6b@gotham.conectiva>
In-Reply-To: <1288303260-6149-1-git-send-email-cascardo@holoscopio.com>
References: <20101028191305.2960c83b@gotham.conectiva>
	<1288303260-6149-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 28 Oct 2010 20:01:00 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> Clearing the per packet TX AGC for the RTL8187B device appears to
> increase its overall TX power. This allows the device to associate and a
> connection to be established using APs a little further away.
> 
> This is in accordance to what is done for RTL8187L devices and also what
> Realtek drivers do.
> 
> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Cc: Hin-Tak Leung <hintak.leung@gmail.com>
> Cc: seno <senada@t-online.de>

Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 38fa824..6e26149 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -775,10 +775,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
>  	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
>  	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
>  	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
> -	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
> -	reg |= RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT |
> -	       RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
> -	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
>  
>  	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
>  
> @@ -929,6 +925,12 @@ static int rtl8187_start(struct ieee80211_hw *dev)
>  		priv->rx_conf = reg;
>  		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
>  
> +		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
> +		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
> +		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
> +		reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
> +		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
> +
>  		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
>  				  RTL818X_TX_CONF_HW_SEQNUM |
>  				  RTL818X_TX_CONF_DISREQQSIZE |
> -- 
> 1.7.1
> 


-- 
[]'s
Herton
