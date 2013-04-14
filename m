Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:33405 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab3DNNwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 09:52:19 -0400
Date: Sun, 14 Apr 2013 15:53:16 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: minimumlaw@rambler.ru
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] Fix transmit power troubles on some Ralink RT30xx cards
Message-ID: <20130414135316.GA14248@localhost.localdomain> (sfid-20130414_155223_957025_DBCF2C52)
References: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 14, 2013 at 02:54:43PM +0400, minimumlaw@rambler.ru wrote:
> From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
> 
> Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> value in them EEPROM/EFUSE. In this case, we must use default value,
> but always used EEPROM/EFUSE value. As result we have tranmitt power
> range from -10dBm to +6dBm instead 0dBm to +16dBm.

Thanks for great work on debugging this!
> Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> more for other RT30xx chips.
>
> Testen on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> embedded Wi-Fi module.

Signed-off-by: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
Cc: stable@vger.kernel.org

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

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
>  	if (!rt2x00_rt(rt2x00dev, RT5390) &&
>  	    !rt2x00_rt(rt2x00dev, RT5392)) {
> +		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
> +
>  		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
>  		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
>  		if (rt2x00_rt(rt2x00dev, RT3070) ||
> @@ -4446,8 +4448,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  				      &rt2x00dev->cap_flags))
>  				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
>  		}
> -		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> -				  drv_data->txmixer_gain_24g);
> +		if (drv_data->txmixer_gain_24g >= min_gain) {
> +			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
> +					  drv_data->txmixer_gain_24g);
> +		}
>  		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
>  	}
>  
> -- 
> 1.8.1.5
> 
> 
