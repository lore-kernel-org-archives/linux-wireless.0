Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49411 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0GUQF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 12:05:26 -0400
Message-ID: <4C471AC2.5040003@bu3sch.de>
Date: Wed, 21 Jul 2010 18:05:22 +0200
From: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@wfinger.net>,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] b43: silense most sparse warnings
References: <1279727142-25234-1-git-send-email-linville@tuxdriver.com> (sfid-20100721_180034_804844_FFFFFFFF8CC2B4DB)
In-Reply-To: <1279727142-25234-1-git-send-email-linville@tuxdriver.com> (sfid-20100721_180034_804844_FFFFFFFF8CC2B4DB)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2010 05:45 PM, John W. Linville wrote:
> diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
> index 29bf34c..0dc33b6 100644
> --- a/drivers/net/wireless/b43/phy_g.c
> +++ b/drivers/net/wireless/b43/phy_g.c
> @@ -972,7 +972,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
>   		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
>
>   		if (phy->rev>= 3) {
> -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> +			b43_phy_mask(dev, 0x048A, 0x7FFF);

This cast was introduced to silense a GCC warning. Do we end up in an
infinite loop now? ;)

>   			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
>   			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
>   			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index c6afe9d..fd50eb1 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1145,7 +1145,7 @@ static void lpphy_write_tx_pctl_mode_to_hardware(struct b43_wldev *dev)
>   		B43_WARN_ON(1);
>   	}
>   	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
> -			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE, ctl);
> +			~B43_LPPHY_TX_PWR_CTL_CMD_MODE&  0xFFFF, ctl);
>   }

>
>   static void lpphy_set_tx_power_control(struct b43_wldev *dev,
> @@ -1522,11 +1522,11 @@ static void lpphy_tx_pctl_init_hw(struct b43_wldev *dev)
>   	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xFF);
>   	b43_phy_write(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xA);
>   	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
> -			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
> +			~B43_LPPHY_TX_PWR_CTL_CMD_MODE&  0xFFFF,
>   			B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
>   	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0xF8FF);
>   	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
> -			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
> +			~B43_LPPHY_TX_PWR_CTL_CMD_MODE&  0xFFFF,
>   			B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW);

> diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
> index 97c7916..9a335da 100644
> --- a/drivers/net/wireless/b43/wa.c
> +++ b/drivers/net/wireless/b43/wa.c
> @@ -382,7 +382,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
>   		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
>   	}
>
> -	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, (u16)~0xFF00, 0x5700);
> +	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, 0x00FF, 0x5700);
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
>   	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
> @@ -400,9 +400,9 @@ static void b43_wa_altagc(struct b43_wldev *dev)
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
> -	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), (u16)~0xFF00, 0x1A00);
> +	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), 0x00FF, 0x1A00);
>   	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
> -	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), (u16)~0xFF00, 0x2C00);
> +	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), 0x00FF, 0x2C00);
>   	if (phy->rev == 1) {
>   		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
>   		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
> @@ -412,7 +412,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
>   		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
>   		if (phy->rev>= 6) {
>   			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
> -			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, (u16)~0xF000, 0x3000);
> +			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, 0x0FFF, 0x3000);
>   		}
>   	}
>   	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);

Same for all of these.

-- 
Greetings Michael.
