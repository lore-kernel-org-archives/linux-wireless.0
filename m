Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:64519 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3DOQAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 12:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <1365996575-18989-1-git-send-email-minimumlaw@rambler.ru>
References: <1365996575-18989-1-git-send-email-minimumlaw@rambler.ru>
Date: Mon, 15 Apr 2013 18:00:41 +0200
Message-ID: <CAL1gcdP1uDUnfLAEb+=BOdVKtvVWg==dg7+eNkSVO_s0-DejTw@mail.gmail.com> (sfid-20130415_180046_545798_02C08496)
Subject: Re: [PATCH v2] rt2x00: Fix transmit power troubles on some Ralink
 RT30xx cards
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: =?KOI8-R?B?4czFy9PFyiDtycjByszP1w==?= <minimumlaw@rambler.ru>,
	John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 15, 2013 at 5:29 AM,  <minimumlaw@rambler.ru> wrote:
> From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
>
> Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> value in them EEPROM/EFUSE. In this case, we must use default value,
> but always used EEPROM/EFUSE value. As result we have tranmitt power
> range from -10dBm to +6dBm instead 0dBm to +16dBm.
>
> Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> more for other RT30xx chips.
>
> Tested on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> embedded Wi-Fi module.
>
> Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
> Cc: stable@vger.kernel.org

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a658b4b..92849e5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4436,6 +4436,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>
>         if (!rt2x00_rt(rt2x00dev, RT5390) &&
>             !rt2x00_rt(rt2x00dev, RT5392)) {
> +               u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
> +
>                 rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
>                 rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
>                 if (rt2x00_rt(rt2x00dev, RT3070) ||
> @@ -4446,8 +4448,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                                       &rt2x00dev->cap_flags))
>                                 rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
>                 }
> -               rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> -                                 drv_data->txmixer_gain_24g);
> +               if (drv_data->txmixer_gain_24g >= min_gain) {
> +                       rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> +                                         drv_data->txmixer_gain_24g);
> +               }
>                 rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
>         }
>
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
---
Gertjan
