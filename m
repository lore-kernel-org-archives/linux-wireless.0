Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:14569 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZHMPGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 11:06:31 -0400
Received: by wa-out-1112.google.com with SMTP id j5so198119wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 08:06:33 -0700 (PDT)
Message-ID: <4A842BF5.8090704@lwfinger.net>
Date: Thu, 13 Aug 2009 10:06:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: LP-PHY: Initialize TX power control
References: <4A842934.2060206@gmail.com>
In-Reply-To: <4A842934.2060206@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> The HW TX power control init still needs work.
> The SW init is complete according to the specs.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> v2: Address Michael's comments, and update for the dummy transmission
> changes.
> 
> This depends on both the rev0/1 RC calibration patch and the
> updated V4 dummy transmission patch I submitted earlier.
> 
> Larry, please review the SPEC TODO/SPEC FIXME comments!
> 
> drivers/net/wireless/b43/phy_lp.c |  105
> ++++++++++++++++++++++++++++++++++---
> drivers/net/wireless/b43/phy_lp.h |    5 ++
> 2 files changed, 103 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 2441a8d..b4e51f0 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -1257,18 +1257,109 @@ static void lpphy_calibration(struct b43_wldev
> *dev)
>     b43_mac_enable(dev);
> }
> 
> +static void lpphy_set_tssi_mux(struct b43_wldev *dev, enum
> tssi_mux_mode mode)
> +{
> +    if (mode != TSSI_MUX_EXT) {
> +        b43_radio_set(dev, B2063_PA_SP1, 0x2);
> +        b43_phy_set(dev, B43_PHY_OFDM(0xF3), 0x1000);
> +        b43_radio_write(dev, B2063_PA_CTL10, 0x51);
> +        if (mode == TSSI_MUX_POSTPA) {
> +            b43_radio_mask(dev, B2063_PA_SP1, 0xFFFE);
> +            b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0xFFC7);
> +        } else {
> +            b43_radio_maskset(dev, B2063_PA_SP1, 0xFFFE, 0x1);
> +            b43_phy_maskset(dev, B43_LPPHY_AFE_CTL_OVRVAL,
> +                    0xFFC7, 0x20);
> +        }
> +    } else {
> +        //SPEC TODO

Put a WARN_ON(1) here. This branch would be an error. No, I don't
understand it either!

Larry



