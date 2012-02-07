Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39487 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab2BGMvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:51:40 -0500
Received: by vcge1 with SMTP id e1so4592507vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:51:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-5-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-4-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-5-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:51:39 +0100
Message-ID: <CAOZOX0UfTBDOokm364SKVPSxS-+OXqVuFpSdQQsa2grc1xBgUg@mail.gmail.com> (sfid-20120207_135143_422705_7E6FE828)
Subject: Re: [PATCH 4/8] rt2x00: Use saved BBP 25 and 26 values when
 configuring channel on RT3572.
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
> This brings the rt2800 channel switching code for RT3572 closer to the
> v2.5.0.0 Ralink RT3572 driver.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 7c05dee..8aabd0d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -2444,6 +2444,8 @@ struct mac_iveiv_entry {
>  struct rt2800_drv_data {
>        u8 calibration_bw20;
>        u8 calibration_bw40;
> +       u8 bbp25;
> +       u8 bbp26;
>  };
>
>  #endif /* RT2800_H */
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index fad0e77..cb841f4 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1754,8 +1754,8 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>        u32 reg;
>
>        if (rf->channel <= 14) {
> -               rt2800_bbp_write(rt2x00dev, 25, 0x15);
> -               rt2800_bbp_write(rt2x00dev, 26, 0x85);
> +               rt2800_bbp_write(rt2x00dev, 25, drv_data->bbp25);
> +               rt2800_bbp_write(rt2x00dev, 26, drv_data->bbp26);
>        } else {
>                rt2800_bbp_write(rt2x00dev, 25, 0x09);
>                rt2800_bbp_write(rt2x00dev, 26, 0xff);
> @@ -3623,6 +3623,12 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>                        rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
>        }
>
> +       /*
> +        * Save BBP 25 & 26 values for later use in channel switching
> +        */
> +       rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
> +       rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
> +
>        if (!rt2x00_rt(rt2x00dev, RT5390)) {
>                /*
>                 * Set back to initial state
> --
> 1.7.9
>
