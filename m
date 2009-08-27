Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:62533 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZH0Sjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:39:44 -0400
Received: by ey-out-2122.google.com with SMTP id 25so303841eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 11:39:45 -0700 (PDT)
Message-ID: <4A96D2EC.6060906@lwfinger.net>
Date: Thu, 27 Aug 2009 13:39:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Implement antenna diversity support for LP-PHY
References: <4A96CE28.3040800@gmail.com>
In-Reply-To: <4A96CE28.3040800@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> This intentionally deviates slightly from the spec (writing
> the antenna ID in one pass instead of two) - please test if
> this works. (I don't have the tools to test if it actually
> selects the right antenna.)
> 
> The A/G-PHY changes are fallout fixes from the enum change,
> which in turn allows the LP-PHY code to be much simpler.
> The antenna_to_phyctl change is a fix for a potential
> existing bug that this patch may otherwise trigger.
> 
> drivers/net/wireless/b43/main.c       |    3 ++-
> drivers/net/wireless/b43/phy_a.c      |    2 +-
> drivers/net/wireless/b43/phy_common.h |   10 +++++-----
> drivers/net/wireless/b43/phy_g.c      |    2 +-
> drivers/net/wireless/b43/phy_lp.c     |   11 ++++++++++-
> 5 files changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index 289e06c..3b038c9 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -1456,7 +1456,8 @@ static u16 b43_antenna_to_phyctl(int antenna)
>         return B43_TXH_PHY_ANT2;
>     case B43_ANTENNA3:
>         return B43_TXH_PHY_ANT3;
> -    case B43_ANTENNA_AUTO:
> +    case B43_ANTENNA_AUTO0:
> +    case B43_ANTENNA_AUTO1:
>         return B43_TXH_PHY_ANT01AUTO;
>     }
>     B43_WARN_ON(1);
> diff --git a/drivers/net/wireless/b43/phy_a.c
> b/drivers/net/wireless/b43/phy_a.c
> index 816e028..809ec97 100644
> --- a/drivers/net/wireless/b43/phy_a.c
> +++ b/drivers/net/wireless/b43/phy_a.c
> @@ -531,7 +531,7 @@ static void b43_aphy_op_set_rx_antenna(struct
> b43_wldev *dev, int antenna)
> 
>     tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
>     tmp &= ~B43_PHY_BBANDCFG_RXANT;
> -    tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
> +    tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
>         << B43_PHY_BBANDCFG_RXANT_SHIFT;
>     b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
> 
> diff --git a/drivers/net/wireless/b43/phy_common.h
> b/drivers/net/wireless/b43/phy_common.h
> index b47a0f5..a6a90df 100644
> --- a/drivers/net/wireless/b43/phy_common.h
> +++ b/drivers/net/wireless/b43/phy_common.h
> @@ -49,11 +49,11 @@ enum b43_interference_mitigation {
> 
> /* Antenna identifiers */
> enum {
> -    B43_ANTENNA0,        /* Antenna 0 */
> -    B43_ANTENNA1,        /* Antenna 0 */
> -    B43_ANTENNA_AUTO1,    /* Automatic, starting with antenna 1 */
> -    B43_ANTENNA_AUTO0,    /* Automatic, starting with antenna 0 */
> -    B43_ANTENNA2,
> +    B43_ANTENNA0 = 0,    /* Antenna 0 */
> +    B43_ANTENNA1 = 1,    /* Antenna 1 */
> +    B43_ANTENNA_AUTO0 = 2,    /* Automatic, starting with antenna 0 */
> +    B43_ANTENNA_AUTO1 = 3,    /* Automatic, starting with antenna 1 */
> +    B43_ANTENNA2 = 4,
>     B43_ANTENNA3 = 8,
> 
>     B43_ANTENNA_AUTO = B43_ANTENNA_AUTO0,
> diff --git a/drivers/net/wireless/b43/phy_g.c
> b/drivers/net/wireless/b43/phy_g.c
> index c6c9d2f..c6d639d 100644
> --- a/drivers/net/wireless/b43/phy_g.c
> +++ b/drivers/net/wireless/b43/phy_g.c
> @@ -2651,7 +2651,7 @@ static void b43_gphy_op_set_rx_antenna(struct
> b43_wldev *dev, int antenna)
> 
>     tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
>     tmp &= ~B43_PHY_BBANDCFG_RXANT;
> -    tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
> +    tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
>             << B43_PHY_BBANDCFG_RXANT_SHIFT;
>     b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 837d952..457357a 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -2204,7 +2204,16 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
> 
> static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
> {
> -    //TODO
> +    int autodiv = ;
> +
> +    if (dev->phy.rev >= 2)
> +        return; // rev2+ doesn't support antenna diversity
> +
> +    if (B43_WARN_ON(antenna > B43_ANTENNA_AUTO1))
> +        return;
> +
> +    /* NOTE: The spec breaks this up into 2 writes - please test */
> +    b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFC, antenna);
> }
> 
> static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)

Sorry, but the spec for this routine was updated 1.5 hours ago.

As to the two-stage write, the spec does match the original code. Who
knows what happens in the device. As it adds little to the routine, I
would suggest implementing it the way the original code does.

Larry
