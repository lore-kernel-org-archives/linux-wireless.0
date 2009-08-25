Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43309 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbZHYUs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 16:48:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix a few typos in the RC calibration code
Date: Tue, 25 Aug 2009 22:48:56 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1251209868-7681-1-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1251209868-7681-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908252248.58079.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 25 August 2009 16:17:48 Gábor Stefanik wrote:
> The RC calibration code has some typos - fix them.
> Also, make the default channel 7, as channel 1 is still
> broken (only channels 7 and 8, and occasionally 9 work).
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

ack

> ---
>  drivers/net/wireless/b43/phy_lp.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 2d3a5d8..7e70c07 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -44,7 +44,7 @@ static inline u16 channel2freq_lp(u8 channel)
>  static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
>  {
>  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
> -		return 1;
> +		return 7; //FIXME temporary - channel 1 is broken
>  	return 36;
>  }
>  
> @@ -705,7 +705,7 @@ static void lpphy_set_rc_cap(struct b43_wldev *dev)
>  	u8 rc_cap = (lpphy->rc_cap & 0x1F) >> 1;
>  
>  	if (dev->phy.rev == 1) //FIXME check channel 14!
> -		rc_cap = max_t(u8, rc_cap + 5, 15);
> +		rc_cap = min_t(u8, rc_cap + 5, 15);
>  
>  	b43_radio_write(dev, B2062_N_RXBB_CALIB2,
>  			max_t(u8, lpphy->rc_cap - 4, 0x80));
> @@ -1008,6 +1008,7 @@ static int lpphy_loopback(struct b43_wldev *dev)
>  
>  	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFC, 0x3);
>  	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x3);
> +	b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 1);
>  	b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0xFFFE);
>  	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x800);
>  	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x800);
> @@ -1213,7 +1214,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
>  			mean_sq_pwr = ideal_pwr - normal_pwr;
>  			mean_sq_pwr *= mean_sq_pwr;
>  			inner_sum += mean_sq_pwr;
> -			if ((i = 128) || (inner_sum < mean_sq_pwr_min)) {
> +			if ((i == 128) || (inner_sum < mean_sq_pwr_min)) {
>  				lpphy->rc_cap = i;
>  				mean_sq_pwr_min = inner_sum;
>  			}



-- 
Greetings, Michael.
