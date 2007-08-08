Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:45776 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXHHHEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:04:10 -0400
Received: by wx-out-0506.google.com with SMTP id h31so66722wxd
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2007 00:04:09 -0700 (PDT)
Message-ID: <1ba2fa240708080004n19d5de4dv75bf5f22220c1f27@mail.gmail.com>
Date: Wed, 8 Aug 2007 10:04:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Add SIOCGIWTXPOWER routine
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46b8b531.h17+wXhw0v8LOFD/%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <46b8b531.h17+wXhw0v8LOFD/%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The wireless extensions ioctl's implemented in mac80211 do not include
> SIOCGIWTXPOWER. This patch adds the necessary code.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
> +++ wireless-dev/net/mac80211/ieee80211_ioctl.c
> @@ -1925,6 +1925,20 @@ static int ieee80211_ioctl_giwrate(struc
>         return 0;
>  }
>
> +static int ieee80211_ioctl_giwtxpower(struct net_device *dev,
> +                                  struct iw_request_info *info,
> +                                  union iwreq_data *data, char *extra)
> +{
> +       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +       data->txpower.fixed = 1;
> +       data->txpower.disabled = 0;

 data->txpower.disabled = !(local->conf.radio_enabled)

> +       data->txpower.value = local->hw.conf.power_level;
> +       data->txpower.flags = IW_TXPOW_DBM;
> +
> +       return 0;
> +}
> +
>  static int ieee80211_ioctl_siwrts(struct net_device *dev,
>                                   struct iw_request_info *info,
>                                   struct iw_param *rts, char *extra)
> @@ -2881,7 +2895,7 @@ static const iw_handler ieee80211_handle
>         (iw_handler) ieee80211_ioctl_siwfrag,           /* SIOCSIWFRAG */
>         (iw_handler) ieee80211_ioctl_giwfrag,           /* SIOCGIWFRAG */
>         (iw_handler) NULL,                              /* SIOCSIWTXPOW */
> -       (iw_handler) NULL,                              /* SIOCGIWTXPOW */
> +       (iw_handler) ieee80211_ioctl_giwtxpower,        /* SIOCGIWTXPOW */
>         (iw_handler) ieee80211_ioctl_siwretry,          /* SIOCSIWRETRY */
>         (iw_handler) ieee80211_ioctl_giwretry,          /* SIOCGIWRETRY */
>         (iw_handler) ieee80211_ioctl_siwencode,         /* SIOCSIWENCODE */
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
