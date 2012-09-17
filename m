Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2IQP1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:27:41 -0400
Received: by dady13 with SMTP id y13so959484dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:27:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347827393-26948-3-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-2-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-3-git-send-email-gwingerde@gmail.com>
Date: Mon, 17 Sep 2012 17:27:41 +0200
Message-ID: <CAOZOX0WovkjPgnoKccN4UEpJAuDdmDjpkOsrEwquKAwA+mGHTg@mail.gmail.com> (sfid-20120917_172751_288076_B48796DF)
Subject: Re: [PATCH 2/5] rt2x00: rt2800 - Fix default vgc values for RT3572
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
> Align with the values used by the RT3572 Ralink vendor driver v2.5.0.0.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index cec4a99..17b8a28 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2904,16 +2904,21 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>                     rt2x00_rt(rt2x00dev, RT3090) ||
>                     rt2x00_rt(rt2x00dev, RT3290) ||
>                     rt2x00_rt(rt2x00dev, RT3390) ||
> +                   rt2x00_rt(rt2x00dev, RT3572) ||
>                     rt2x00_rt(rt2x00dev, RT5390) ||
>                     rt2x00_rt(rt2x00dev, RT5392))
>                         vgc = 0x1c + (2 * rt2x00dev->lna_gain);
>                 else
>                         vgc = 0x2e + rt2x00dev->lna_gain;
>         } else { /* 5GHZ band */
> -               if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
> -                       vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
> -               else
> -                       vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
> +               if (rt2x00_rt(rt2x00dev, RT3572))
> +                       vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
> +               else {
> +                       if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
> +                               vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
> +                       else
> +                               vgc = 0x3a + (rt2x00dev->lna_gain * 5) / 3;
> +               }
>         }
>
>         return vgc;
> --
> 1.7.11.1
>
