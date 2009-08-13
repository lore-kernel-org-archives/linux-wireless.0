Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46792 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbZHMNQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 09:16:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Initialize TX power control
Date: Thu, 13 Aug 2009 15:15:59 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A832940.6000807@gmail.com>
In-Reply-To: <4A832940.6000807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908131515.59966.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 August 2009 22:42:40 Gábor Stefanik wrote:
> The HW TX power control init still needs work.
> The SW init is complete according to the specs.

HW PCTL needs a serious amount of work in the common code, too.
For now I would focus to SW PCTL and fix HW PCTL later.

> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> This depends on both the rev0/1 RC calibration patch and the
> V4 dummy transmission patch I submitted earlier.
> 
> Larry, please check the SPEC TODO/SPEC FIXME comments.
> 
>  drivers/net/wireless/b43/phy_lp.c |  104 ++++++++++++++++++++++++++++++++++---
>  drivers/net/wireless/b43/phy_lp.h |    5 ++
>  2 files changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index e05981b..6ebaeb2 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1258,18 +1258,108 @@ static void lpphy_calibration(struct b43_wldev *dev)
>  	b43_mac_enable(dev);
>  }
>  
> +static void lpphy_set_tssi_mux(struct b43_wldev *dev, enum tssi_mux_mode mode)
> +{
> +	if (mode != TSSI_MUX_EXT) {
> +		b43_radio_set(dev, B2063_PA_SP1, 0x2);
> +		b43_phy_set(dev, B43_PHY_OFDM(0xF3), 0x1000);
> +		b43_radio_write(dev, B2063_PA_CTL10, 0x51);
> +		if (mode == TSSI_MUX_POSTPA) {
> +			b43_radio_mask(dev, B2063_PA_SP1, 0xFFFE);
> +			b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0xFFC7);
> +		} else {
> +			b43_radio_maskset(dev, B2063_PA_SP1, 0xFFFE, 0x1);
> +			b43_phy_maskset(dev, B43_LPPHY_AFE_CTL_OVRVAL,
> +					0xFFC7, 0x20);
> +		}
> +	} else {
> +		//SPEC TODO
> +	}
> +}
> +
> +static void lpphy_tx_pctl_init_hw(struct b43_wldev *dev)
> +{
> +	u16 tmp;
> +	int i;
> +
> +	//SPEC TODO Call LP PHY Clear TX Power offsets
> +	for (i = 0; i < 64; i++) {
> +		if (dev->phy.rev >= 2)
> +			b43_lptab_write(dev, B43_LPTAB32(7, i+1), i);
                                                            ^^^
Please keep in mind to use spaces all the time. It is our coding style and I think
we should stick with it.

> +	tmp = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_STAT);
> +	if (tmp & 0x8000)
> +		b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_IDLETSSI,
> +				0xFFC0, (tmp & 0xFF) - 32);

Curly brackets for multiline indents, please.


-- 
Greetings, Michael.
