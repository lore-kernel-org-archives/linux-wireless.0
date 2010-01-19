Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:40523 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0ASRtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:49:52 -0500
Received: by pxi12 with SMTP id 12so4758506pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 09:49:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B546A68.5050503@globallogic.com>
References: <4B546A68.5050503@globallogic.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 09:49:31 -0800
Message-ID: <43e72e891001190949u717da5f6maae6a2ca81f3101f@mail.gmail.com>
Subject: Re: Account HT Control field also in Data frame hdrlen according to
	802.11n-2009
To: Andriy Tkachuk <andriy.v.tkachuk@globallogic.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2010 at 6:04 AM, Andriy Tkachuk
<andriy.v.tkachuk@globallogic.com> wrote:
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h

The commit log entry is empty. Can you describe what this fixes
verbally and if its a critical fix or not, if it is, its important to
know whether or not to propagate this to stable, so please explain its
impact and what the behavior was before this.

Also please prefix your e-mails with [PATCH].

  Luis
> index 8427019..1998495 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -138,6 +138,8 @@
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK   0x03
>  #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT  5
>
> +#define IEEE80211_HT_CTL_LEN           4
> +
>  struct ieee80211_hdr {
>        __le16 frame_control;
>        __le16 duration_id;
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 23557c1..be2ab8c 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -227,8 +227,11 @@ unsigned int ieee80211_hdrlen(__le16 fc)
>        if (ieee80211_is_data(fc)) {
>                if (ieee80211_has_a4(fc))
>                        hdrlen = 30;
> -               if (ieee80211_is_data_qos(fc))
> +               if (ieee80211_is_data_qos(fc)) {
>                        hdrlen += IEEE80211_QOS_CTL_LEN;
> +                       if (ieee80211_has_order(fc))
> +                               hdrlen += IEEE80211_HT_CTL_LEN;
> +               }
>                goto out;
>        }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
