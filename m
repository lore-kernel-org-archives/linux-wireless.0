Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49370 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbZINTkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 15:40:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix analog core switching
Date: Mon, 14 Sep 2009 21:40:16 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4AAE950C.2050704@gmail.com>
In-Reply-To: <4AAE950C.2050704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909142140.18118.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 September 2009 21:10:04 Gábor Stefanik wrote:
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
> +	if (on) {
> +		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0x7);
> +		b43_phy_set(dev, B43_LPPHY_AFE_CTL_OVR, 0x7);
> +	} else {
> +		b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xFFF8);
> +	}
> +}

You have the if branches swapped. (Don't add a ! in front of the on. Swap the branches).

-- 
Greetings, Michael.
