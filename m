Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46034 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab2BGMuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 07:50:44 -0500
Received: by vcge1 with SMTP id e1so4592019vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 04:50:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328568313-26267-3-git-send-email-gwingerde@gmail.com>
References: <1328568313-26267-1-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-2-git-send-email-gwingerde@gmail.com>
	<1328568313-26267-3-git-send-email-gwingerde@gmail.com>
Date: Tue, 7 Feb 2012 13:50:43 +0100
Message-ID: <CAOZOX0U4ZtLitQQyxo-hKfUmzcwaSc+tJYZH28Fuy=PaDcpi=A@mail.gmail.com> (sfid-20120207_135054_523624_6972F7F5)
Subject: Re: [PATCH 2/8] rt2x00: Use struct rt2x00_dev driver data in rt2800{pci,usb}.
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
> Start using the struct rt2x00_dev driver data in rt2800 for the calibration
> data.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index fac9ece..7c05dee 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -2438,4 +2438,12 @@ struct mac_iveiv_entry {
>  */
>  #define EIRP_MAX_TX_POWER_LIMIT        0x50
>
> +/*
> + * RT2800 driver data structure
> + */
> +struct rt2800_drv_data {
> +       u8 calibration_bw20;
> +       u8 calibration_bw40;
> +};
> +
>  #endif /* RT2800_H */
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index bc093b9..fad0e77 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1645,6 +1645,7 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>                                         struct rf_channel *rf,
>                                         struct channel_info *info)
>  {
> +       struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>        u8 rfcsr, calib_tx, calib_rx;
>
>        rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
> @@ -1714,8 +1715,13 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>                calib_tx = conf_is_ht40(conf) ? 0x68 : 0x4f;
>                calib_rx = conf_is_ht40(conf) ? 0x6f : 0x4f;
>        } else {
> -               calib_tx = rt2x00dev->calibration[conf_is_ht40(conf)];
> -               calib_rx = rt2x00dev->calibration[conf_is_ht40(conf)];
> +               if (conf_is_ht40(conf)) {
> +                       calib_tx = drv_data->calibration_bw40;
> +                       calib_rx = drv_data->calibration_bw40;
> +               } else {
> +                       calib_tx = drv_data->calibration_bw20;
> +                       calib_rx = drv_data->calibration_bw20;
> +               }
>        }
>
>        rt2800_rfcsr_read(rt2x00dev, 24, &rfcsr);
> @@ -1743,6 +1749,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>                                         struct rf_channel *rf,
>                                         struct channel_info *info)
>  {
> +       struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>        u8 rfcsr;
>        u32 reg;
>
> @@ -1836,10 +1843,13 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
>        rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
>        rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
>
> -       rt2800_rfcsr_write(rt2x00dev, 24,
> -                             rt2x00dev->calibration[conf_is_ht40(conf)]);
> -       rt2800_rfcsr_write(rt2x00dev, 31,
> -                             rt2x00dev->calibration[conf_is_ht40(conf)]);
> +       if (conf_is_ht40(conf)) {
> +               rt2800_rfcsr_write(rt2x00dev, 24, drv_data->calibration_bw40);
> +               rt2800_rfcsr_write(rt2x00dev, 31, drv_data->calibration_bw40);
> +       } else {
> +               rt2800_rfcsr_write(rt2x00dev, 24, drv_data->calibration_bw20);
> +               rt2800_rfcsr_write(rt2x00dev, 31, drv_data->calibration_bw20);
> +       }
>
>        if (rf->channel <= 14) {
>                rt2800_rfcsr_write(rt2x00dev, 7, 0xd8);
> @@ -3310,6 +3320,7 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
>
>  static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  {
> +       struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>        u8 rfcsr;
>        u8 bbp;
>        u32 reg;
> @@ -3598,17 +3609,17 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>         * Set RX Filter calibration for 20MHz and 40MHz
>         */
>        if (rt2x00_rt(rt2x00dev, RT3070)) {
> -               rt2x00dev->calibration[0] =
> +               drv_data->calibration_bw20 =
>                        rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
> -               rt2x00dev->calibration[1] =
> +               drv_data->calibration_bw40 =
>                        rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
>        } else if (rt2x00_rt(rt2x00dev, RT3071) ||
>                   rt2x00_rt(rt2x00dev, RT3090) ||
>                   rt2x00_rt(rt2x00dev, RT3390) ||
>                   rt2x00_rt(rt2x00dev, RT3572)) {
> -               rt2x00dev->calibration[0] =
> +               drv_data->calibration_bw20 =
>                        rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
> -               rt2x00dev->calibration[1] =
> +               drv_data->calibration_bw40 =
>                        rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
>        }
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 4e98502..6ad6929 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1093,6 +1093,7 @@ static const struct data_queue_desc rt2800pci_queue_bcn = {
>
>  static const struct rt2x00_ops rt2800pci_ops = {
>        .name                   = KBUILD_MODNAME,
> +       .drv_data_size          = sizeof(struct rt2800_drv_data),
>        .max_sta_intf           = 1,
>        .max_ap_intf            = 8,
>        .eeprom_size            = EEPROM_SIZE,
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index f0074bc..d009b6b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -827,6 +827,7 @@ static const struct data_queue_desc rt2800usb_queue_bcn = {
>
>  static const struct rt2x00_ops rt2800usb_ops = {
>        .name                   = KBUILD_MODNAME,
> +       .drv_data_size          = sizeof(struct rt2800_drv_data),
>        .max_sta_intf           = 1,
>        .max_ap_intf            = 8,
>        .eeprom_size            = EEPROM_SIZE,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index b4260bfb6..5bd2f22 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -897,13 +897,6 @@ struct rt2x00_dev {
>        u8 freq_offset;
>
>        /*
> -        * Calibration information (for rt2800usb & rt2800pci).
> -        * [0] -> BW20
> -        * [1] -> BW40
> -        */
> -       u8 calibration[2];
> -
> -       /*
>         * Association id.
>         */
>        u16 aid;
> --
> 1.7.9
>
