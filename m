Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34869 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0BOA3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 19:29:09 -0500
Received: by fxm27 with SMTP id 27so106322fxm.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 16:29:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr>
References: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 15 Feb 2010 01:28:47 +0100
Message-ID: <69e28c911002141628w76dc0419r43c7d753c16962da@mail.gmail.com>
Subject: Re: [PATCH 1/2] zd1211rw: Experimental change to add proper monitor
	support
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: dsd@gentoo.org, kune@deine-taler.de,
	linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 15, 2010 at 12:34 AM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> Without this patch, monitor mode does not returns all frames. With this patch,
> the performance are quite poor if we create a monitor interface. Note :
> creating a monitor interface with the "cook" flag has no impact on performance.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  drivers/net/wireless/zd1211rw/zd_mac.c |   20 +++++++++++++++++++-
>  1 files changed, 19 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 2d555cc..9cb6cbc 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -904,8 +904,26 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
>  {
>        struct zd_mac *mac = zd_hw_mac(hw);
>        struct ieee80211_conf *conf = &hw->conf;
> +       int ret;
>
> -       return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
> +       if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
> +               /*
> +                * Warning : enabling this register kills RX & TX
> +                * performance
> +                */
> +               u32 cr_sniffer = !!(conf->flags & IEEE80211_CONF_MONITOR);
> +               ret = zd_iowrite32(&mac->chip, CR_SNIFFER_ON, cr_sniffer);
> +               if (!ret)
> +                       return ret;

Your logic is the wrong way around. You should return if nonzero, not if zero.

> +       }
> +
> +       if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> +               ret = zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
> +               if (!ret)
> +                       return ret;
> +       }
> +
> +       return 0;
>  }
>
>  static void zd_process_intr(struct work_struct *work)
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
