Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2IQP2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:28:00 -0400
Received: by pbbrr13 with SMTP id rr13so9173009pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:28:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347827393-26948-4-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-2-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-3-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-4-git-send-email-gwingerde@gmail.com>
Date: Mon, 17 Sep 2012 17:28:00 +0200
Message-ID: <CAOZOX0Ui_WM4o=7WmFrSSq5uXJfyVo8bD46ZQj0br1Yzjb6s7g@mail.gmail.com> (sfid-20120917_172812_110637_C4FF46C4)
Subject: Re: [PATCH 3/5] rt2x00: rt2800lib - code cleanup.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/16 Gertjan van Wingerde <gwingerde@gmail.com>:
> Move RT3290 BBP initialization sequence (part) to the right place in the code.
>
> This is just a code style change, no functional changes.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 17b8a28..37f64ba 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -3535,6 +3535,11 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>         } else if (rt2800_is_305x_soc(rt2x00dev)) {
>                 rt2800_bbp_write(rt2x00dev, 78, 0x0e);
>                 rt2800_bbp_write(rt2x00dev, 80, 0x08);
> +       } else if (rt2x00_rt(rt2x00dev, RT3290)) {
> +               rt2800_bbp_write(rt2x00dev, 74, 0x0b);
> +               rt2800_bbp_write(rt2x00dev, 79, 0x18);
> +               rt2800_bbp_write(rt2x00dev, 80, 0x09);
> +               rt2800_bbp_write(rt2x00dev, 81, 0x33);
>         } else if (rt2x00_rt(rt2x00dev, RT3352)) {
>                 rt2800_bbp_write(rt2x00dev, 78, 0x0e);
>                 rt2800_bbp_write(rt2x00dev, 80, 0x08);
> @@ -3543,13 +3548,6 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>                 rt2800_bbp_write(rt2x00dev, 81, 0x37);
>         }
>
> -       if (rt2x00_rt(rt2x00dev, RT3290)) {
> -               rt2800_bbp_write(rt2x00dev, 74, 0x0b);
> -               rt2800_bbp_write(rt2x00dev, 79, 0x18);
> -               rt2800_bbp_write(rt2x00dev, 80, 0x09);
> -               rt2800_bbp_write(rt2x00dev, 81, 0x33);
> -       }
> -
>         rt2800_bbp_write(rt2x00dev, 82, 0x62);
>         if (rt2x00_rt(rt2x00dev, RT3290) ||
>             rt2x00_rt(rt2x00dev, RT5390) ||
> --
> 1.7.11.1
>
