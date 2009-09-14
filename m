Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:19929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbZINTZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 15:25:38 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1060817fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:25:41 -0700 (PDT)
Subject: Re: [PATCH] b43: LP-PHY: Fix analog core switching
From: Thomas Ilnseher <illth@gmx.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <4AAE950C.2050704@gmail.com>
References: <4AAE950C.2050704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Sep 2009 21:24:40 +0200
Message-Id: <1252956280.4696.19.camel@luzifer.localnet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mo, 2009-09-14 at 21:10 +0200, Gábor Stefanik wrote:
> The generic analog switch routine is not correct for LP-PHY according
> to the latest specs. Implement the proper analog core switch routine.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 80da9c7..b0e127a 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -2160,6 +2160,16 @@ static int lpphy_b2063_tune(struct b43_w
>  	return 0;
>  }
>  
> +static void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
> +{
The spec says:
Else if this in an LP PHY 
     a. If argument "on" is zero 
             1. OR PHY Register 0x43C with 7 
                
             2. OR PHY Register 0x43B with 7 
                
> +	if (on) {
This stuff is executed when on is true (ie. anything else than zero)
> +		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x7);
> +		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x7);
> +	} else {
> +		b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xFFF8);
> +	}
> +}
> +
>  static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>  				       unsigned int new_channel)
>  {
> @@ -2239,7 +2249,7 @@ const struct b43_phy_operations b43_phyo
>  	.radio_read		= b43_lpphy_op_radio_read,
>  	.radio_write		= b43_lpphy_op_radio_write,
>  	.software_rfkill	= b43_lpphy_op_software_rfkill,
> -	.switch_analog		= b43_phyop_switch_analog_generic,
> +	.switch_analog		= b43_lpphy_op_switch_analog,
>  	.switch_channel		= b43_lpphy_op_switch_channel,
>  	.get_default_chan	= b43_lpphy_op_get_default_chan,
>  	.set_rx_antenna		= b43_lpphy_op_set_rx_antenna,
> 
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev

