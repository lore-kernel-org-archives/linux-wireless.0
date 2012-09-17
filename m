Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53387 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab2IQP2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:28:42 -0400
Received: by pbbrr13 with SMTP id rr13so9174147pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2012 08:28:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347827393-26948-6-git-send-email-gwingerde@gmail.com>
References: <1347827393-26948-1-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-2-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-3-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-4-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-5-git-send-email-gwingerde@gmail.com>
	<1347827393-26948-6-git-send-email-gwingerde@gmail.com>
Date: Mon, 17 Sep 2012 17:28:41 +0200
Message-ID: <CAOZOX0V4Ynq6GuADxiOE6Hn7w48DHhaW3ctcJKLjbVs0qqu1Jg@mail.gmail.com> (sfid-20120917_172845_198266_C82AC96E)
Subject: Re: [PATCH 5/5] rt2x00: Clean up RFCSR1 programming in rt2800_config_channel_rf3xxx.
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
> Setting of the individual fields of the RF register can be simplified.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index d745c32..540c94f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1763,36 +1763,15 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>
>         rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
>         rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
> +                         rt2x00dev->default_ant.rx_chain_num <= 1);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD,
> +                         rt2x00dev->default_ant.rx_chain_num <= 2);
>         rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
> -       if (rt2x00_rt(rt2x00dev, RT3390)) {
> -               rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
> -                                 rt2x00dev->default_ant.rx_chain_num == 1);
> -               rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
> -                                 rt2x00dev->default_ant.tx_chain_num == 1);
> -       } else {
> -               rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
> -               rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
> -               rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
> -               rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
> -
> -               switch (rt2x00dev->default_ant.tx_chain_num) {
> -               case 1:
> -                       rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
> -                       /* fall through */
> -               case 2:
> -                       rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
> -                       break;
> -               }
> -
> -               switch (rt2x00dev->default_ant.rx_chain_num) {
> -               case 1:
> -                       rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
> -                       /* fall through */
> -               case 2:
> -                       rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
> -                       break;
> -               }
> -       }
> +       rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
> +                         rt2x00dev->default_ant.tx_chain_num <= 1);
> +       rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD,
> +                         rt2x00dev->default_ant.tx_chain_num <= 2);
>         rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>
>         rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> --
> 1.7.11.1
>
