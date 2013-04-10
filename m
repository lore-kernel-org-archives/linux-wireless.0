Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58856 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3DJHMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 03:12:09 -0400
Message-ID: <516510D6.5090700@openwrt.org> (sfid-20130410_091213_847974_07BFC4CF)
Date: Wed, 10 Apr 2013 09:12:22 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: stf_xl@wp.pl
CC: "" <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 02/11] rt2800: move rf init calibration code
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-3-git-send-email-stf_xl@wp.pl>
In-Reply-To: <1365519930-3230-3-git-send-email-stf_xl@wp.pl>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

> From: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Add separate functions for rf init calibration code and use it in
> proper init rf routines.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   53 ++++++++++++++++++-------------
>  1 files changed, 31 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index d092b47..334973a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -4425,6 +4425,18 @@ static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
>  	rt2800_rfcsr_write(rt2x00dev, 30, reg);
>  }
>  
> +static void rt2800_rf_init_calibration_53xx(struct rt2x00_dev *rt2x00dev)
> +{
> +	u8 rfcsr;
> +
> +	rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
> +	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
> +	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> +	msleep(1);
> +	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
> +	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> +}
> +
>  static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>  {
>  	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
> @@ -4463,6 +4475,19 @@ static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>  
>  static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>  {
> +	u8 rfcsr;
> +
> +	/*
> +	 * Init RF calibration.
> +	 * XXX: vendor driver do this only for 3070 ?
> +	 */
> +	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> +	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +	msleep(1);
> +	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> +	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> +
>  	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
>  	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
>  	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> @@ -4486,6 +4511,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>  
>  static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>  {
> +	rt2800_rf_init_calibration_53xx(rt2x00dev);
> +
>  	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
>  	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>  	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
> @@ -4674,6 +4701,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>  
>  static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>  {
> +	rt2800_rf_init_calibration_53xx(rt2x00dev);
> +
>  	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
>  	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>  	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> @@ -4760,6 +4789,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>  
>  static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>  {
> +	rt2800_rf_init_calibration_53xx(rt2x00dev);
> +
>  	rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
>  	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>  	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
> @@ -4882,28 +4913,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>  	    !rt2800_is_305x_soc(rt2x00dev))
>  		return 0;
>  
> -	/*
> -	 * Init RF calibration.
> -	 */
> -
> -	if (rt2x00_rt(rt2x00dev, RT3290) ||
> -	    rt2x00_rt(rt2x00dev, RT5390) ||
> -	    rt2x00_rt(rt2x00dev, RT5392)) {
> -		rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
> -		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
> -		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> -		msleep(1);
> -		rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
> -		rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
> -	} else {
> -		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
> -		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> -		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -		msleep(1);
> -		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> -		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> -	}

The code in the else branch is required by the 305x_soc devices. However the
change moves it into the 'rt2800_init_rfcsr_30xx' function and that is only
called for RT3070, RT3071, RT3090.

Either add the code into the 'rt2800_init_rfcsr_305x_soc function' as well or
create a helper function and call that from 'rt2800_init_rfcsr_30xx' and from
'rt2800_init_rfcsr_305x_soc'.

> -
>  	if (rt2800_is_305x_soc(rt2x00dev)) {
>  		rt2800_init_rfcsr_305x_soc(rt2x00dev);
>  		return 0;
> 

-Gabor
