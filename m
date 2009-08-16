Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50081 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZHPRu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 13:50:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Remove BROKEN from B43_PHY_LP
Date: Sun, 16 Aug 2009 19:50:23 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A88370B.5090506@gmail.com>
In-Reply-To: <4A88370B.5090506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908161950.24270.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 18:42:51 Gábor Stefanik wrote:
> Larry has reported success getting scan data with an LP-PHY device,
> so it's probably time to release LP-PHY support for testing.
> 
> Also add a temporary BROKEN Kconfig symbol to disable 5GHz support,
> as 5GHz currently causes the driver to panic (NULL pointer deref).
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
>  drivers/net/wireless/b43/Kconfig  |   25 +++++++++++++++++++------
>  drivers/net/wireless/b43/main.c   |    2 ++
>  drivers/net/wireless/b43/phy_lp.c |    2 ++
>  3 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
> index 67f564e..13414c9 100644
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> @@ -80,16 +80,29 @@ config B43_NPHY
>  	  SAY N.
>  
>  config B43_PHY_LP
> -	bool "IEEE 802.11g LP-PHY support (BROKEN)"
> -	depends on B43 && EXPERIMENTAL && BROKEN
> +	bool "Support for low-power (LP-PHY) devices (VERY EXPERIMENTAL)"

Very is a vague term. Just remove it.

> +	depends on B43 && EXPERIMENTAL
>  	---help---
>  	  Support for the LP-PHY.
> -	  The LP-PHY is an IEEE 802.11g based PHY built into some notebooks
> -	  and embedded devices.
> +	  The LP-PHY is a low-power PHY built into some notebooks
> +	  and embedded devices. It supports 802.11a/g
> +	  (802.11a support is optional, and currently disabled).
>  
> -	  THIS IS BROKEN AND DOES NOT WORK YET.
> +	  Known LP-PHY devices include the BCM4310, BCM4312 (PCI ID 0x4315),
> +	  BCM4325 (currently unsupported), BCM4326 & BCM4328 wireless cards
> +	  and the BCM5354 SoC.

It's pointless to list them here, as the list will always be obsolete and never be correct.

>  
> -	  SAY N.
> +	  This is heavily experimental, and probably will not work for you.
> +	  Say N unless you want to help debug the driver.
> +
> +config B43_PHY_LP_5GHZ
> +	bool "Enable 802.11a support for LP-PHYs (BROKEN)"
> +	depends on B43_PHY_LP && BROKEN
> +	---help---
> +	  Enable the 5GHz band of LP-PHY devices. Currently, all it
> +	  does is cause the driver to panic on startup.
> +
> +	  Only select this if you are a developer working on this feature.

I don't think we should introduce another config option. Just hardcode
disable the 802.11a for LP-PHYs. There's no point in enabling an option
that crashes the kernel. And if you fix the crash, there's no point in
leaving it disabled.

>  # This config option automatically enables b43 LEDS support,
>  # if it's possible.
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> index 99b41ce..0096d25 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -4514,7 +4514,9 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
>  			have_5ghz_phy = 1;
>  			break;
>  		case B43_PHYTYPE_LP: //FIXME not always!
> +#ifdef CONFIG_B43_PHY_LP_5GHZ
>  			have_5ghz_phy = 1;
> +#endif
>  		case B43_PHYTYPE_G:
>  		case B43_PHYTYPE_N:
>  			have_2ghz_phy = 1;
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 3889519..c902dd1 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -43,7 +43,9 @@ static inline u16 channel2freq_lp(u8 channel)
>  
>  static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
>  {
> +#ifdef CONFIG_B43_PHY_LP_5GHZ
>  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
> +#endif
>  		return 1;
>  	return 36;
>  }

This is a completely pointless ifdef.



-- 
Greetings, Michael.
