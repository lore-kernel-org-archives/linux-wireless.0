Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:39881 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0AZWx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 17:53:59 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so967935fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 14:53:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264540940-30813-1-git-send-email-linville@tuxdriver.com>
References: <1264540940-30813-1-git-send-email-linville@tuxdriver.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 26 Jan 2010 23:53:38 +0100
Message-ID: <69e28c911001261453r12a687eay3eac8669d3f0bfad@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: implement get_tsf op for mac80211
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 10:22 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/rtl818x/rtl8180_dev.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> index 5a2b719..8dbb504 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -761,6 +761,20 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
>        rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
>  }
>
> +static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
> +{
> +       struct rtl8180_priv *priv = dev->priv;
> +       u32 tsftl;
> +       u64 tsft;
> +
> +       tsftl = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
> +       tsft = rtl818x_ioread32(priv, &priv->map->TSFT[1]);
> +       tsft <<= 32;
> +       tsft |= tsftl;
> +
> +       return tsft;
> +}

Why not:

struct rtl8180_priv *priv = dev->priv;
u64 tsft;

tsft = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
tfst |= rtl818x_ioread32(priv, &priv->map->TSFT[1]) << 32;

return tsft;

> +
>  static const struct ieee80211_ops rtl8180_ops = {
>        .tx                     = rtl8180_tx,
>        .start                  = rtl8180_start,
> @@ -771,6 +785,7 @@ static const struct ieee80211_ops rtl8180_ops = {
>        .bss_info_changed       = rtl8180_bss_info_changed,
>        .prepare_multicast      = rtl8180_prepare_multicast,
>        .configure_filter       = rtl8180_configure_filter,
> +       .get_tsf                = rtl8180_get_tsf,
>  };
>
>  static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
> --
> 1.6.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
