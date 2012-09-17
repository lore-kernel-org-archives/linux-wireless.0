Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2IQP1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:27:13 -0400
Received: by pbbrr13 with SMTP id rr13so9171950pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:27:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347827393-26948-2-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-2-git-send-email-gwingerde@gmail.com>
Date: Mon, 17 Sep 2012 17:27:13 +0200
Message-ID: <CAOZOX0X6KyX7aHscbRr6RP4v3Q=CRinKX8hUubyuBK5YhV=LGQ@mail.gmail.com> (sfid-20120917_172717_488893_62BAB93B)
Subject: Re: [PATCH 1/5] rt2x00: Code clean up in rt2800lib.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 16, 2012 at 10:29 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Make the code in rt2800_get_default_vgc more understandable and
> readable, especially for the 5GHz band values.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 9e09367..cec4a99 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2896,6 +2896,8 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
>
>  static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>  {
> +       u8 vgc;
> +
>         if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
>                 if (rt2x00_rt(rt2x00dev, RT3070) ||
>                     rt2x00_rt(rt2x00dev, RT3071) ||
> @@ -2904,15 +2906,17 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>                     rt2x00_rt(rt2x00dev, RT3390) ||
>                     rt2x00_rt(rt2x00dev, RT5390) ||
>                     rt2x00_rt(rt2x00dev, RT5392))
> -                       return 0x1c + (2 * rt2x00dev->lna_gain);
> +                       vgc = 0x1c + (2 * rt2x00dev->lna_gain);
> +               else
> +                       vgc = 0x2e + rt2x00dev->lna_gain;
> +       } else { /* 5GHZ band */
> +               if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
> +                       vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
>                 else
> -                       return 0x2e + rt2x00dev->lna_gain;
> +                       vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
>         }
>
> -       if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
> -               return 0x32 + (rt2x00dev->lna_gain * 5) / 3;
> -       else
> -               return 0x3a + (rt2x00dev->lna_gain * 5) / 3;
> +       return vgc;
>  }
>
>  static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
> --
> 1.7.11.1
>
