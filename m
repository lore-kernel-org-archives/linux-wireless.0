Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40228 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2LEGzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 01:55:22 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4082199lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 22:55:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-k+RY5m804tBg4uzbWsUhS16coW9cQ62R7mPCjKjGffg@mail.gmail.com>
References: <CAPgLHd-k+RY5m804tBg4uzbWsUhS16coW9cQ62R7mPCjKjGffg@mail.gmail.com>
Date: Tue, 4 Dec 2012 22:55:20 -0800
Message-ID: <CA++WF2Okd8vD7r5ydMsPprWOwmvjKh+W-=cT7_dYiAf1r5k3iQ@mail.gmail.com> (sfid-20121205_075525_888559_A72C307B)
Subject: Re: [PATCH -next] ipw2200: return error code on error in ipw_wx_get_auth()
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Wei,

On 3 December 2012 22:03, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> We have assinged error code to 'ret' when get auth from some
> option is not supported but never used it, but we'd better return
> the error code.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/net/wireless/ipw2x00/ipw2200.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 482f505..1ad72d5 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -6812,7 +6812,6 @@ static int ipw_wx_get_auth(struct net_device *dev,
>         struct libipw_device *ieee = priv->ieee;
>         struct lib80211_crypt_data *crypt;
>         struct iw_param *param = &wrqu->param;
> -       int ret = 0;
>
>         switch (param->flags & IW_AUTH_INDEX) {
>         case IW_AUTH_WPA_VERSION:
> @@ -6822,7 +6821,7 @@ static int ipw_wx_get_auth(struct net_device *dev,
>                 /*
>                  * wpa_supplicant will control these internally
>                  */
> -               ret = -EOPNOTSUPP;
> +               return -EOPNOTSUPP;
>                 break;

Could you remove this break as well?

Thanks,
Stanislav.

>
>         case IW_AUTH_TKIP_COUNTERMEASURES:
>
>
