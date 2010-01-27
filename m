Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61993 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0A0ARl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 19:17:41 -0500
Received: by fxm20 with SMTP id 20so1029907fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 16:17:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net>
References: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net>
Date: Wed, 27 Jan 2010 00:17:39 +0000
Message-ID: <3ace41891001261617w54e8c08dm5d317f7c2b17cba4@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Add callback for get_tsf
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 11:45 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Presumably this new api is needed and used by some userland tools (iw
or other QoS-related tool?).

> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1265,6 +1265,14 @@ static int rtl8187_conf_tx(struct ieee80
>        return 0;
>  }
>
> +static u64 rtl8187_get_tsf(struct ieee80211_hw *dev)
> +{
> +       struct rtl8187_priv *priv = dev->priv;
> +
> +       return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
> +              (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
> +}
> +
>  static const struct ieee80211_ops rtl8187_ops = {
>        .tx                     = rtl8187_tx,
>        .start                  = rtl8187_start,
> @@ -1276,7 +1284,8 @@ static const struct ieee80211_ops rtl818
>        .prepare_multicast      = rtl8187_prepare_multicast,
>        .configure_filter       = rtl8187_configure_filter,
>        .conf_tx                = rtl8187_conf_tx,
> -       .rfkill_poll            = rtl8187_rfkill_poll
> +       .rfkill_poll            = rtl8187_rfkill_poll,
> +       .get_tsf                = rtl8187_get_tsf
>  };
>
>  static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
