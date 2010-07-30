Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp136.mail.ukl.yahoo.com ([77.238.184.67]:41763 "HELO
	smtp136.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751765Ab0G3DWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 23:22:09 -0400
Message-ID: <4C52455E.6010405@users.sourceforge.net>
Date: Fri, 30 Jul 2010 04:22:06 +0100
From: Hin-Tak Leung <htl10@users.sourceforge.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: consolidate MSR writes in rtl8187_bss_info_changed
References: <1280455044-26073-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280455044-26073-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Thanks for looking this over. I wondered how the code came to be like this, so I 
went to look it up - the reason was that we used to have more lines between the 
{}'s and they were gradually removed. The full list of defines for the 
RTL818X_MSR_* are :

#define RTL818X_MSR_NO_LINK		(0 << 2)
#define RTL818X_MSR_ADHOC		(1 << 2)
#define RTL818X_MSR_INFRA		(2 << 2)
#define RTL818X_MSR_MASTER		(3 << 2)
#define RTL818X_MSR_ENEDCA		(4 << 2)

but we only use 3 at the moment (not _AHOC nor _MASTER).

Hin-Tak

> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 5738a55..0801c1d 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1176,13 +1176,12 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
>  		else
>  			reg = 0;
>  
> -		if (is_valid_ether_addr(info->bssid)) {
> +		if (is_valid_ether_addr(info->bssid))
>  			reg |= RTL818X_MSR_INFRA;
> -			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
> -		} else {
> +		else
>  			reg |= RTL818X_MSR_NO_LINK;
> -			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
> -		}
> +
> +		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
>  
>  		mutex_unlock(&priv->conf_mutex);
>  	}
