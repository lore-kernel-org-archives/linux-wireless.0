Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:36791 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932119Ab0ARWDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 17:03:53 -0500
Message-ID: <4B54DAC5.2030004@free.fr>
Date: Mon, 18 Jan 2010 23:03:49 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Andriy Tkachuk <andriy.v.tkachuk@globallogic.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Account HT Control field also in Data frame hdrlen according
 to 802.11n-2009
References: <4B546A68.5050503@globallogic.com>
In-Reply-To: <4B546A68.5050503@globallogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andriy Tkachuk a écrit :
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 8427019..1998495 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -138,6 +138,8 @@
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK   0x03
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT  5
>
> +#define IEEE80211_HT_CTL_LEN           4
> +
>  struct ieee80211_hdr {
>         __le16 frame_control;
>         __le16 duration_id;
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 23557c1..be2ab8c 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -227,8 +227,11 @@ unsigned int ieee80211_hdrlen(__le16 fc)
>         if (ieee80211_is_data(fc)) {
>                 if (ieee80211_has_a4(fc))
>                         hdrlen = 30;
> -               if (ieee80211_is_data_qos(fc))
> +               if (ieee80211_is_data_qos(fc)) {
>                         hdrlen += IEEE80211_QOS_CTL_LEN;
> +                       if (ieee80211_has_order(fc))
> +                               hdrlen += IEEE80211_HT_CTL_LEN;
> +               }
>                 goto out;
>         }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Nice! Acked-by : Benoit Papillault <benoit.papillault@free.fr>

Regards,
Benoit


