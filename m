Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966638Ab0GSUNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 16:13:09 -0400
Received: by fxm14 with SMTP id 14so2399738fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 13:13:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C449C67.6010004@davizone.at>
References: <4C449C67.6010004@davizone.at>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 19 Jul 2010 22:12:48 +0200
Message-ID: <AANLkTimj6DhVK7WePrpoJap6M_OtteoHtS8UMYcVloIV@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 19, 2010 at 8:41 PM, David Gnedt <david.gnedt@davizone.at> wrote:
> The cfg80211_set_freq function now also saves the channel for monitor
> interfaces.
> This fixes a issue were the WEXT ioctl GIWFREQ doesn't report the correct
> channel when the channel was switched in monitor mode.
>
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> ---
>  net/wireless/chan.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index d0c92dd..fd05938 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -51,9 +51,6 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>        struct ieee80211_channel *chan;
>        int result;
>
> -       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
> -               wdev = NULL;
> -
>        if (wdev) {
>                ASSERT_WDEV_LOCK(wdev);
>
> @@ -69,7 +66,9 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>                return -EINVAL;
>
>        result = rdev->ops->set_channel(&rdev->wiphy,
> -                                       wdev ? wdev->netdev : NULL,
> +                                       wdev && wdev->iftype !=
> +                                               NL80211_IFTYPE_MONITOR ?
> +                                                       wdev->netdev : NULL,

Just out of curiosity: why is it important to pass NULL as netdev for
monitor interfaces?

>                                        chan, channel_type);
>        if (result)
>                return result;
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
