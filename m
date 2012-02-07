Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39487 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab2BGMvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:51:55 -0500
Received: by mail-vx0-f174.google.com with SMTP id e1so4592507vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:51:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-6-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-4-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-5-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-6-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:51:55 +0100
Message-ID: <CAOZOX0XrqZuA9xaz6x8wEyc8gryD7+a7Q6mNGvPvn21E4ZH+Tw@mail.gmail.com> (sfid-20120207_135209_998459_54895A0F)
Subject: Re: [PATCH 5/8] rt2x00: Fix RFCSR 12 & 13 programming on RT3572
 channel switching.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 11:45 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Align with v2.5.0.0 Ralink RT3572 driver for 2.4GHz band channel switch.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index cb841f4..66af6f4 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1783,8 +1783,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>        if (rf->channel <= 14) {
>                rt2x00_set_field8(&rfcsr, RFCSR12_DR0, 3);
>                rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
> -                               (info->default_power1 & 0x3) |
> -                               ((info->default_power1 & 0xC) << 1));
> +                                 info->default_power1);
>        } else {
>                rt2x00_set_field8(&rfcsr, RFCSR12_DR0, 7);
>                rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
> @@ -1797,8 +1796,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>        if (rf->channel <= 14) {
>                rt2x00_set_field8(&rfcsr, RFCSR13_DR0, 3);
>                rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
> -                               (info->default_power2 & 0x3) |
> -                               ((info->default_power2 & 0xC) << 1));
> +                                 info->default_power2);
>        } else {
>                rt2x00_set_field8(&rfcsr, RFCSR13_DR0, 7);
>                rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
> --
> 1.7.9
>
