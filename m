Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab2BGMwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:52:33 -0500
Received: by vbjk17 with SMTP id k17so4572742vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:52:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-8-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-4-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-5-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-6-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-7-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-8-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:52:32 +0100
Message-ID: <CAOZOX0Uxfwk5S4oOb8ahFhNg=EtQbUYp8O7Bbi0vFhjHW0-nww@mail.gmail.com> (sfid-20120207_135239_667740_BAC35528)
Subject: Re: [PATCH 7/8] rt2x00: Fix RT3572 channel switch RFCSR 7 programming.
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
> Align with the v2.5.0.0 Ralink RT3572 driver.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 8aabd0d..c6648b0 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1819,10 +1819,12 @@ struct mac_iveiv_entry {
>  * RFCSR 7:
>  */
>  #define RFCSR7_RF_TUNING               FIELD8(0x01)
> -#define RFCSR7_R02                             FIELD8(0x07)
> -#define RFCSR7_R3                              FIELD8(0x08)
> -#define RFCSR7_R45                             FIELD8(0x30)
> -#define RFCSR7_R67                             FIELD8(0xc0)
> +#define RFCSR7_BIT1                    FIELD8(0x02)
> +#define RFCSR7_BIT2                    FIELD8(0x04)
> +#define RFCSR7_BIT3                    FIELD8(0x08)
> +#define RFCSR7_BIT4                    FIELD8(0x10)
> +#define RFCSR7_BIT5                    FIELD8(0x20)
> +#define RFCSR7_BITS67                  FIELD8(0xc0)
>
>  /*
>  * RFCSR 11:
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 2afb798..28dc6ba 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1865,7 +1865,12 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>                rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
>                rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
>        } else {
> -               rt2800_rfcsr_write(rt2x00dev, 7, 0x14);
> +               rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
> +               rt2x00_set_field8(&rfcsr, RFCSR7_BIT2, 1);
> +               rt2x00_set_field8(&rfcsr, RFCSR7_BIT3, 0);
> +               rt2x00_set_field8(&rfcsr, RFCSR7_BIT4, 1);
> +               rt2x00_set_field8(&rfcsr, RFCSR7_BITS67, 0);
> +               rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
>                rt2800_rfcsr_write(rt2x00dev, 9, 0xc0);
>                rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
>                rt2800_rfcsr_write(rt2x00dev, 11, 0x00);
> --
> 1.7.9
>
