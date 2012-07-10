Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43116 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2GJGew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 02:34:52 -0400
Received: by yenl2 with SMTP id l2so10914813yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 23:34:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341837708-22689-2-git-send-email-sgruszka@redhat.com>
References: <1341837708-22689-1-git-send-email-sgruszka@redhat.com>
	<1341837708-22689-2-git-send-email-sgruszka@redhat.com>
Date: Tue, 10 Jul 2012 08:34:51 +0200
Message-ID: <CAGXE3d8NG-5dzJ7GONTV=pbY1gTw0JWGazQXUWkqRf5Te+n7Ew@mail.gmail.com> (sfid-20120710_083456_105873_90681EC8)
Subject: Re: [PATCH 2/2] rt2800lib: merge same defines
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody Hung <Woody.Hung@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/9 Stanislaw Gruszka <sgruszka@redhat.com>:
> Merge 3290 and 5390 POWER_BOUND and FREQ_OFFSET_BOUND defines.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Yep, makes sense.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   29 ++++++++++++-----------------
>  1 files changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 068276e..e76f03c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1940,10 +1940,8 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>         rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
>  }
>
> -#define RT3290_POWER_BOUND     0x27
> -#define RT3290_FREQ_OFFSET_BOUND       0x5f
> -#define RT5390_POWER_BOUND     0x27
> -#define RT5390_FREQ_OFFSET_BOUND       0x5f
> +#define POWER_BOUND            0x27
> +#define FREQ_OFFSET_BOUND      0x5f
>
>  static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
>                                          struct ieee80211_conf *conf,
> @@ -1959,16 +1957,15 @@ static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
>         rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
>
>         rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
> -       if (info->default_power1 > RT3290_POWER_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT3290_POWER_BOUND);
> +       if (info->default_power1 > POWER_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
>         else
>                 rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
>         rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
>
>         rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> -       if (rt2x00dev->freq_offset > RT3290_FREQ_OFFSET_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
> -                                 RT3290_FREQ_OFFSET_BOUND);
> +       if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
>         else
>                 rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
>         rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> @@ -2002,17 +1999,16 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
>         rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
>
>         rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
> -       if (info->default_power1 > RT5390_POWER_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR49_TX, RT5390_POWER_BOUND);
> +       if (info->default_power1 > POWER_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
>         else
>                 rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
>         rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
>
>         if (rt2x00_rt(rt2x00dev, RT5392)) {
>                 rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
> -               if (info->default_power1 > RT5390_POWER_BOUND)
> -                       rt2x00_set_field8(&rfcsr, RFCSR50_TX,
> -                                         RT5390_POWER_BOUND);
> +               if (info->default_power1 > POWER_BOUND)
> +                       rt2x00_set_field8(&rfcsr, RFCSR50_TX, POWER_BOUND);
>                 else
>                         rt2x00_set_field8(&rfcsr, RFCSR50_TX,
>                                           info->default_power2);
> @@ -2031,9 +2027,8 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
>         rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>
>         rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> -       if (rt2x00dev->freq_offset > RT5390_FREQ_OFFSET_BOUND)
> -               rt2x00_set_field8(&rfcsr, RFCSR17_CODE,
> -                                 RT5390_FREQ_OFFSET_BOUND);
> +       if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
> +               rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
>         else
>                 rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
>         rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
