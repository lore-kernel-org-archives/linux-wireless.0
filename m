Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:64912 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZHMPpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 11:45:31 -0400
Received: by pzk34 with SMTP id 34so616823pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 08:45:30 -0700 (PDT)
Message-ID: <4A84350C.2090903@lwfinger.net>
Date: Thu, 13 Aug 2009 10:45:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: LP-PHY: Implement channel switching for rev2+/B2063
 radio
References: <4A842AFD.1020903@gmail.com>
In-Reply-To: <4A842AFD.1020903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Rev.2+/B2063 will now hopefully show some signs of life, though
> it won't work at full performance, as calibration is still missing.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> If you have an LP-PHY device with the B2063 radio, please test!
> 
> Larry&Michael,
> There is some pretty arcane stuff in op_switch_channel, please
> review it closely!
> 
> drivers/net/wireless/b43/phy_lp.c |  395
> ++++++++++++++++++++++++++++++++++++-
> 1 files changed, 390 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index b4e51f0..716bb87 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -142,10 +142,9 @@ static void lpphy_read_band_sprom(struct b43_wldev
> *dev)
>     }
> }
> 
> -static void lpphy_adjust_gain_table(struct b43_wldev *dev)
> +static void lpphy_adjust_gain_table(struct b43_wldev *dev, u32 freq)
> {
>     struct b43_phy_lp *lpphy = dev->phy.lp;
> -    u32 freq = dev->wl->hw->conf.channel->center_freq;
>     u16 temp[3];
>     u16 isolation;
> 
> @@ -170,6 +169,8 @@ static void lpphy_adjust_gain_table(struct b43_wldev
> *dev)
> 
> static void lpphy_table_init(struct b43_wldev *dev)
> {
> +    u32 freq = dev->wl->hw->conf.channel->center_freq;
> +
>     if (dev->phy.rev < 2)
>         lpphy_rev0_1_table_init(dev);
>     else
> @@ -178,7 +179,7 @@ static void lpphy_table_init(struct b43_wldev *dev)
>     lpphy_init_tx_gain_table(dev);
> 
>     if (dev->phy.rev < 2)
> -        lpphy_adjust_gain_table(dev);
> +        lpphy_adjust_gain_table(dev, freq);
> }
> 
> static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
> @@ -1369,7 +1370,7 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
>     lpphy_baseband_init(dev);
>     lpphy_radio_init(dev);
>     lpphy_calibrate_rc(dev);
> -    //TODO set channel
> +    b43_switch_channel(dev, dev->wl->hw->conf.channel->hw_value);
>     lpphy_tx_pctl_init(dev);
>     lpphy_calibration(dev);
>     //TODO ACI init
> @@ -1419,10 +1420,394 @@ static void b43_lpphy_op_software_rfkill(struct
> b43_wldev *dev,
>     //TODO
> }
> 
> +static void lpphy_b2062_tune(struct b43_wldev *dev,
> +                 unsigned int channel)
> +{
> +    //TODO
> +}
> +
> +struct b2063_channel {
> +    u8 channel;
> +    u16 freq;
> +    u8 data[12];
> +};
> +
> +static const struct b2063_channel b2063_chantbl[] = {
> +    { .channel = 1, .freq = 2412, .data[0] = 0x6F, .data[1] = 0x3C,
> +      .data[2] = 0x3C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 2, .freq = 2417, .data[0] = 0x6F, .data[1] = 0x3C,
> +      .data[2] = 0x3C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 3, .freq = 2422, .data[0] = 0x6F, .data[1] = 0x3C,
> +      .data[2] = 0x3C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 4, .freq = 2427, .data[0] = 0x6F, .data[1] = 0x2C,
> +      .data[2] = 0x2C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 5, .freq = 2432, .data[0] = 0x6F, .data[1] = 0x2C,
> +      .data[2] = 0x2C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 6, .freq = 2437, .data[0] = 0x6F, .data[1] = 0x2C,
> +      .data[2] = 0x2C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 7, .freq = 2442, .data[0] = 0x6F, .data[1] = 0x2C,
> +      .data[2] = 0x2C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 8, .freq = 2447, .data[0] = 0x6F, .data[1] = 0x2C,
> +      .data[2] = 0x2C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 9, .freq = 2452, .data[0] = 0x6F, .data[1] = 0x1C,
> +      .data[2] = 0x1C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 10, .freq = 2457, .data[0] = 0x6F, .data[1] = 0x1C,
> +      .data[2] = 0x1C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 11, .freq = 2462, .data[0] = 0x6E, .data[1] = 0x1C,
> +      .data[2] = 0x1C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 12, .freq = 2467, .data[0] = 0x6E, .data[1] = 0x1C,
> +      .data[2] = 0x1C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 13, .freq = 2472, .data[0] = 0x6E, .data[1] = 0x1C,
> +      .data[2] = 0x1C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 14, .freq = 2484, .data[0] = 0x6E, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x04, .data[4] = 0x05, .data[5] = 0x05,
> +      .data[6] = 0x05, .data[7] = 0x05, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x80, .data[11] = 0x70, },
> +    { .channel = 34, .freq = 5170, .data[0] = 0x6A, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x02, .data[5] = 0x05,
> +      .data[6] = 0x0D, .data[7] = 0x0D, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 38, .freq = 5190, .data[0] = 0x6A, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x01, .data[5] = 0x04,
> +      .data[6] = 0x0C, .data[7] = 0x0C, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 42, .freq = 5210, .data[0] = 0x69, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x01, .data[5] = 0x04,
> +      .data[6] = 0x0B, .data[7] = 0x0C, .data[8] = 0x77, .data[9] = 0x70,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 46, .freq = 5230, .data[0] = 0x69, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x03,
> +      .data[6] = 0x0A, .data[7] = 0x0B, .data[8] = 0x77, .data[9] = 0x60,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 36, .freq = 5180, .data[0] = 0x6A, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x01, .data[5] = 0x05,
> +      .data[6] = 0x0D, .data[7] = 0x0C, .data[8] = 0x77, .data[9] = 0x80,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 40, .freq = 5200, .data[0] = 0x69, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x01, .data[5] = 0x04,
> +      .data[6] = 0x0C, .data[7] = 0x0C, .data[8] = 0x77, .data[9] = 0x70,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 44, .freq = 5220, .data[0] = 0x69, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x04,
> +      .data[6] = 0x0B, .data[7] = 0x0B, .data[8] = 0x77, .data[9] = 0x60,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 48, .freq = 5240, .data[0] = 0x69, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x03,
> +      .data[6] = 0x0A, .data[7] = 0x0A, .data[8] = 0x77, .data[9] = 0x60,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 52, .freq = 5260, .data[0] = 0x68, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x02,
> +      .data[6] = 0x09, .data[7] = 0x09, .data[8] = 0x77, .data[9] = 0x60,
> +      .data[10] = 0x20, .data[11] = 0x00, },
> +    { .channel = 56, .freq = 5280, .data[0] = 0x68, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x01,
> +      .data[6] = 0x08, .data[7] = 0x08, .data[8] = 0x77, .data[9] = 0x50,
> +      .data[10] = 0x10, .data[11] = 0x00, },
> +    { .channel = 60, .freq = 5300, .data[0] = 0x68, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x01,
> +      .data[6] = 0x08, .data[7] = 0x08, .data[8] = 0x77, .data[9] = 0x50,
> +      .data[10] = 0x10, .data[11] = 0x00, },
> +    { .channel = 64, .freq = 5320, .data[0] = 0x67, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x08, .data[7] = 0x08, .data[8] = 0x77, .data[9] = 0x50,
> +      .data[10] = 0x10, .data[11] = 0x00, },
> +    { .channel = 100, .freq = 5500, .data[0] = 0x64, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x02, .data[7] = 0x01, .data[8] = 0x77, .data[9] = 0x20,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 104, .freq = 5520, .data[0] = 0x64, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x01, .data[7] = 0x01, .data[8] = 0x77, .data[9] = 0x20,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 108, .freq = 5540, .data[0] = 0x63, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x01, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x10,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 112, .freq = 5560, .data[0] = 0x63, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x10,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 116, .freq = 5580, .data[0] = 0x62, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x10,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 120, .freq = 5600, .data[0] = 0x62, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 124, .freq = 5620, .data[0] = 0x62, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 128, .freq = 5640, .data[0] = 0x61, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 132, .freq = 5660, .data[0] = 0x61, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 136, .freq = 5680, .data[0] = 0x61, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 140, .freq = 5700, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 149, .freq = 5745, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 153, .freq = 5765, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 157, .freq = 5785, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 161, .freq = 5805, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 165, .freq = 5825, .data[0] = 0x60, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x00, .data[5] = 0x00,
> +      .data[6] = 0x00, .data[7] = 0x00, .data[8] = 0x77, .data[9] = 0x00,
> +      .data[10] = 0x00, .data[11] = 0x00, },
> +    { .channel = 184, .freq = 4920, .data[0] = 0x6E, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x09, .data[5] = 0x0E,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xC0,
> +      .data[10] = 0x50, .data[11] = 0x00, },
> +    { .channel = 188, .freq = 4940, .data[0] = 0x6E, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x09, .data[5] = 0x0D,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xB0,
> +      .data[10] = 0x50, .data[11] = 0x00, },
> +    { .channel = 192, .freq = 4960, .data[0] = 0x6E, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x08, .data[5] = 0x0C,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xB0,
> +      .data[10] = 0x50, .data[11] = 0x00, },
> +    { .channel = 196, .freq = 4980, .data[0] = 0x6D, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x08, .data[5] = 0x0C,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xA0,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +    { .channel = 200, .freq = 5000, .data[0] = 0x6D, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x08, .data[5] = 0x0B,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xA0,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +    { .channel = 204, .freq = 5020, .data[0] = 0x6D, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x08, .data[5] = 0x0A,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0xA0,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +    { .channel = 208, .freq = 5040, .data[0] = 0x6C, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x07, .data[5] = 0x09,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0x90,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +    { .channel = 212, .freq = 5060, .data[0] = 0x6C, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x06, .data[5] = 0x08,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0x90,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +    { .channel = 216, .freq = 5080, .data[0] = 0x6C, .data[1] = 0x0C,
> +      .data[2] = 0x0C, .data[3] = 0x00, .data[4] = 0x05, .data[5] = 0x08,
> +      .data[6] = 0x0F, .data[7] = 0x0F, .data[8] = 0x77, .data[9] = 0x90,
> +      .data[10] = 0x40, .data[11] = 0x00, },
> +};
> +
> +static void lpphy_b2063_vco_calib(struct b43_wldev *dev)
> +{
> +    u16 tmp;
> +
> +    b43_phy_mask(dev, B2063_PLL_SP1, ~0x40);
> +    tmp = b43_phy_read(dev, B2063_PLL_JTAG_CALNRST) & 0xF8;
> +    b43_phy_write(dev, B2063_PLL_JTAG_CALNRST, tmp);
> +    udelay(1);
> +    b43_phy_write(dev, B2063_PLL_JTAG_CALNRST, tmp | 0x4);
> +    udelay(1);
> +    b43_phy_write(dev, B2063_PLL_JTAG_CALNRST, tmp | 0x6);
> +    udelay(1);
> +    b43_phy_write(dev, B2063_PLL_JTAG_CALNRST, tmp | 0x7);
> +    udelay(300);
> +    b43_phy_set(dev, B2063_PLL_SP1, 0x40);
> +}
> +
> +static void lpphy_b2063_tune(struct b43_wldev *dev,
> +                 unsigned int channel)
> +{
> +    struct ssb_bus *bus = dev->dev->bus;
> +
> +    struct b2063_channel chandata;
> +    u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
> +    u32 freqref, vco_freq, val1, val2, val3, timeout, timeoutref, count;
> +    u16 old_comm15, scale;
> +    u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6;
> +    int i, div = (crystal_freq <= 26000000 ? 1 : 2);
> +
> +    memset(&chandata, 0, sizeof(chandata));
> +
> +    for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
> +        if (b2063_chantbl[i].channel == channel) {
> +            chandata = b2063_chantbl[i];
> +            break;
> +        }
> +    }
> +
> +    B43_WARN_ON(!chandata.channel);
> +
> +    b43_radio_write(dev, B2063_LOGEN_VCOBUF1, chandata.data[0]);
> +    b43_radio_write(dev, B2063_LOGEN_MIXER2, chandata.data[1]);
> +    b43_radio_write(dev, B2063_LOGEN_BUF2, chandata.data[2]);
> +    b43_radio_write(dev, B2063_LOGEN_RCCR1, chandata.data[3]);
> +    b43_radio_write(dev, B2063_A_RX_1ST3, chandata.data[4]);
> +    b43_radio_write(dev, B2063_A_RX_2ND1, chandata.data[5]);
> +    b43_radio_write(dev, B2063_A_RX_2ND4, chandata.data[6]);
> +    b43_radio_write(dev, B2063_A_RX_2ND7, chandata.data[7]);
> +    b43_radio_write(dev, B2063_A_RX_PS6, chandata.data[8]);
> +    b43_radio_write(dev, B2063_TX_RF_CTL2, chandata.data[9]);
> +    b43_radio_write(dev, B2063_TX_RF_CTL5, chandata.data[10]);
> +    b43_radio_write(dev, B2063_PA_CTL11, chandata.data[11]);
> +
> +    old_comm15 = b43_radio_read(dev, B2063_COMM15);
> +    b43_radio_set(dev, B2063_COMM15, 0x1E);
> +
> +    if (chandata.freq > 4000) /* spec says 2484, but 4000 is safer */
> +        vco_freq = chandata.freq << 1;
> +    else
> +        vco_freq = chandata.freq << 2;
> +
> +    freqref = crystal_freq * 3;
> +    val1 = lpphy_qdiv_roundup(crystal_freq, 1000000, 16);
> +    val2 = lpphy_qdiv_roundup(crystal_freq, 1000000 * div, 16);
> +    val3 = lpphy_qdiv_roundup(vco_freq, 3, 16);
> +    timeout = ((((8 * crystal_freq) / (div * 5000000)) + 1) >> 1) - 1;
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_VCO_CALIB3, 0x2);
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_VCO_CALIB6,
> +              0xFFF8, timeout >> 2);
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_VCO_CALIB7,
> +              0xFF9F,timeout << 5);
> +
> +    timeoutref = ((((8 * crystal_freq) / (div * (timeout + 1))) +
> +                        999999) / 1000000) + 1;
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_VCO_CALIB5, timeoutref);
> +
> +    count = lpphy_qdiv_roundup(val3, val2 + 16, 16);
> +    count *= (timeout + 1) * (timeoutref + 1);
> +    count--;
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_VCO_CALIB7,
> +                        0xF0, count >> 8);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_VCO_CALIB8, count & 0xFF);
> +
> +    tmp1 = ((val3 * 62500) / freqref) << 4;
> +    tmp2 = ((val3 * 62500) % freqref) << 4;
> +    while (tmp2 >= freqref) {
> +        tmp1++;
> +        tmp2 -= freqref;
> +    }
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_SG1, 0xFFE0, tmp1 >> 4);
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_SG2, 0xFE0F, tmp1 << 4);
> +    b43_radio_maskset(dev, B2063_PLL_JTAG_PLL_SG2, 0xFFF0, tmp1 >> 16);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_SG3, (tmp2 >> 8) & 0xFF);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_SG4, tmp2 & 0xFF);
> +
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_LF1, 0xB9);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_LF2, 0x88);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_LF3, 0x28);
> +    b43_radio_write(dev, B2063_PLL_JTAG_PLL_LF4, 0x63);
> +
> +    tmp3 = ((41 * (val3 - 3000)) /1200) + 27;
> +    tmp4 = lpphy_qdiv_roundup(132000 * tmp1, 8451, 16);
> +
> +    if ((tmp4 + tmp3 - 1) / tmp3 > 60) {
> +        scale = 1;
> +        tmp5 = ((tmp4 + tmp3) / (tmp3 << 1)) - 8;
> +    } else {
> +        scale = 0;
> +        tmp5 = ((tmp4 + (tmp3 >> 1)) / tmp3) - 8;
> +    }
> +    b43_phy_maskset(dev, B2063_PLL_JTAG_PLL_CP2, 0xFFC0, tmp5);
> +    b43_phy_maskset(dev, B2063_PLL_JTAG_PLL_CP2, 0xFFBF, scale << 6);
> +
> +    tmp6 = lpphy_qdiv_roundup(100 * val1, val3, 16);
> +    tmp6 *= (tmp5 * 8) * (scale + 1);
> +    if (tmp6 > 150)
> +        tmp6 = 0;
> +
> +    b43_phy_maskset(dev, B2063_PLL_JTAG_PLL_CP3, 0xFFE0, tmp6);
> +    b43_phy_maskset(dev, B2063_PLL_JTAG_PLL_CP3, 0xFFDF, scale << 5);
> +
> +    b43_phy_maskset(dev, B2063_PLL_JTAG_PLL_XTAL_12, 0xFFFB, 0x4);
> +    if (crystal_freq > 26000000)
> +        b43_phy_set(dev, B2063_PLL_JTAG_PLL_XTAL_12, 0x2);
> +    else
> +        b43_phy_mask(dev, B2063_PLL_JTAG_PLL_XTAL_12, 0xFD);
> +
> +    if (val1 == 45)
> +        b43_phy_set(dev, B2063_PLL_JTAG_PLL_VCO1, 0x2);
> +    else
> +        b43_phy_mask(dev, B2063_PLL_JTAG_PLL_VCO1, 0xFD);
> +
> +    b43_phy_set(dev, B2063_PLL_SP2, 0x3);
> +    udelay(1);
> +    b43_phy_mask(dev, B2063_PLL_SP2, 0xFFFC);
> +    lpphy_b2063_vco_calib(dev);
> +    b43_radio_write(dev, B2063_COMM15, old_comm15);
> +}
> +
> static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>                        unsigned int new_channel)
> {
> -    //TODO
> +    struct b2063_channel chandata;
> +    int i;
> +
> +    memset(&chandata, 0, sizeof(chandata));
> +
> +    //FIXME this abuses the 2063 channel table for chan2freq purposes!
> +    for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
> +        if (b2063_chantbl[i].channel == new_channel) {
> +            chandata = b2063_chantbl[i];
> +            break;
> +        }
> +    }
> +
> +    B43_WARN_ON(!chandata.channel);
> +
> +    /* FIXME this should be the last thing done, even after generic
> +     * parts - does it matter?
> +     * SPEC FIXME should this write channel, freq, chanspec or cookie?
> +     */
> +    b43_write16(dev, B43_MMIO_CHANNEL, new_channel);

Whenever this hardware register is written, it is always with a channel.

> +    if (dev->phy.radio_ver == 0x2063) {
> +        lpphy_b2063_tune(dev, new_channel);
> +    } else {
> +        lpphy_b2062_tune(dev, new_channel);
> +        //TODO Japan filter
> +    }
> +    lpphy_adjust_gain_table(dev, chandata.freq);
>     return 0;
> }
> 

What SPEC page did you use for this? I only see the tuning calls in
http://bcm-v4.sipsolutions.net/802.11/PHY/LP/SetChanSpecLPPHY, but it
doesn't look like this.

Larry
