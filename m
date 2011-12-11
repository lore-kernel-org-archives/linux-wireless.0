Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42602 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab1LKDG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 22:06:56 -0500
Received: by ggdk6 with SMTP id k6so89313ggd.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 19:06:56 -0800 (PST)
Message-ID: <4EE41E4D.3050702@lwfinger.net> (sfid-20111211_040700_533049_C3B44F85)
Date: Sat, 10 Dec 2011 21:06:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 7/7] b43: N-PHY: implement spurious tone avoidance
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com> <1323568535-2816-8-git-send-email-zajec5@gmail.com>
In-Reply-To: <1323568535-2816-8-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 07:55 PM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/phy_n.c |   90 +++++++++++++++++++++++++++++++++++++-
>   1 files changed, 88 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 114c413..6e776d0 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -4023,6 +4023,58 @@ int b43_phy_initn(struct b43_wldev *dev)
>   	return 0;
>   }
>
> +static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
> +{
> +	struct bcma_drv_cc *cc =&dev->dev->bdev->bus->drv_cc;
> +	u32 pmu_ctl;
> +	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
> +		if (avoid) {
> +			bcma_chipco_pll_write(cc, 0x0, 0x11500010);
> +			bcma_chipco_pll_write(cc, 0x1, 0x000C0C06);
> +			bcma_chipco_pll_write(cc, 0x2, 0x0F600a08);
> +			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
> +			bcma_chipco_pll_write(cc, 0x4, 0x2001E920);
> +			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
> +		} else {
> +			bcma_chipco_pll_write(cc, 0x0, 0x11100010);
> +			bcma_chipco_pll_write(cc, 0x1, 0x000c0c06);
> +			bcma_chipco_pll_write(cc, 0x2, 0x03000a08);
> +			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
> +			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
> +			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
> +		}
> +		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
> +	} else if (dev->dev->chip_id == 0x4716) {
> +		if (avoid) {
> +			bcma_chipco_pll_write(cc, 0x0, 0x11500060);
> +			bcma_chipco_pll_write(cc, 0x1, 0x080C0C06);
> +			bcma_chipco_pll_write(cc, 0x2, 0x0F600000);
> +			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
> +			bcma_chipco_pll_write(cc, 0x4, 0x2001E924);
> +			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
> +		} else {
> +			bcma_chipco_pll_write(cc, 0x0, 0x11100060);
> +			bcma_chipco_pll_write(cc, 0x1, 0x080c0c06);
> +			bcma_chipco_pll_write(cc, 0x2, 0x03000000);
> +			bcma_chipco_pll_write(cc, 0x3, 0x00000000);
> +			bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
> +			bcma_chipco_pll_write(cc, 0x5, 0x88888815);
> +		}
> +		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD | BCMA_CC_PMU_CTL_NOILPONW;
> +	} else if (dev->dev->chip_id == 0x4322 || dev->dev->chip_id == 0x4340 ||
> +		   dev->dev->chip_id == 0x4341) {
> +		bcma_chipco_pll_write(cc, 0x0, 0x11100070);
> +		bcma_chipco_pll_write(cc, 0x1, 0x1014140a);
> +		bcma_chipco_pll_write(cc, 0x5, 0x88888854);
> +		if (avoid)
> +			bcma_chipco_pll_write(cc, 0x2, 0x05201828);
> +		else
> +			bcma_chipco_pll_write(cc, 0x2, 0x05001828);
> +		pmu_ctl = BCMA_CC_PMU_CTL_PLL_UPD;
> +	}
> +	bcma_cc_set32(cc, BCMA_CC_PMU_CTL, pmu_ctl);

My gcc is brain dead here and outputs

   CC [M]  drivers/net/wireless/b43/phy_n.o
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_channel_setup.isra.14’:
drivers/net/wireless/b43/phy_n.c:4075:2: warning: ‘pmu_ctl’ may be used 
uninitialized in this function [-Wuninitialized]
drivers/net/wireless/b43/phy_n.c:4029:6: note: ‘pmu_ctl’ was declared here

The variable is clearly set in all paths, but I still get the warning.

Larry
