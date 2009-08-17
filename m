Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:60276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZHPOiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 10:38:09 -0400
Received: by wf-out-1314.google.com with SMTP id 26so668279wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 07:38:10 -0700 (PDT)
Message-ID: <4A88C27E.3030000@lwfinger.net>
Date: Sun, 16 Aug 2009 21:37:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: LP-PHY: Update code for spec fixes, and fix a few
 typos
References: <4A88090D.3070107@gmail.com>
In-Reply-To: <4A88090D.3070107@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> A few typos have been discovered both in the specs in and our code.
> This patch fixes them.
> 
> Also use lpphy_op_switch_channel consistently, and make all callers
> print its return value for easier debugging.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> I think using a forward declaration is justified in this case;
> as avoiding the forward decl would require moving around huge
> blocks of code, completely breaking any logical ordering.
> 
> drivers/net/wireless/b43/phy_lp.c |   51
> ++++++++++++++++++++++++------------
> 1 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index e4a040b..a51da6e 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -552,7 +552,7 @@ static void lpphy_2062_init(struct b43_wldev *dev)
>     B43_WARN_ON(!(bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU));
>     B43_WARN_ON(crystalfreq == 0);
> 
> -    if (crystalfreq >= 30000000) {
> +    if (crystalfreq <= 30000000) {
>         lpphy->pdiv = 1;
>         b43_radio_mask(dev, B2062_S_RFPLL_CTL1, 0xFFFB);
>     } else {
> @@ -560,14 +560,16 @@ static void lpphy_2062_init(struct b43_wldev *dev)
>         b43_radio_set(dev, B2062_S_RFPLL_CTL1, 0x4);
>     }
> 
> -    tmp = (800000000 * lpphy->pdiv + crystalfreq) /
> -          (32000000 * lpphy->pdiv);
> -    tmp = (tmp - 1) & 0xFF;
> +    tmp = (((800000000 * lpphy->pdiv + crystalfreq) /
> +          (2 * crystalfreq)) - 8) & 0xFF;
> +    b43_radio_write(dev, B2062_S_RFPLL_CTL7, tmp);
> +
> +    tmp = (((100 * crystalfreq + 16000000 * lpphy->pdiv) /
> +          (32000000 * lpphy->pdiv)) - 1) & 0xFF;
>     b43_radio_write(dev, B2062_S_RFPLL_CTL18, tmp);
> 
> -    tmp = (2 * crystalfreq + 1000000 * lpphy->pdiv) /
> -          (2000000 * lpphy->pdiv);
> -    tmp = ((tmp & 0xFF) - 1) & 0xFFFF;
> +    tmp = (((2 * crystalfreq + 1000000 * lpphy->pdiv) /
> +          (2000000 * lpphy->pdiv)) - 1) & 0xFF;
>     b43_radio_write(dev, B2062_S_RFPLL_CTL19, tmp);
> 
>     ref = (1000 * lpphy->pdiv + 2 * crystalfreq) / (2000 * lpphy->pdiv);
> @@ -671,7 +673,7 @@ static void lpphy_radio_init(struct b43_wldev *dev)
>     b43_phy_mask(dev, B43_LPPHY_FOURWIRE_CTL, 0xFFFD);
>     udelay(1);
> 
> -    if (dev->phy.rev < 2) {
> +    if (dev->phy.radio_ver == 0x2062) {
>         lpphy_2062_init(dev);
>     } else {
>         lpphy_2063_init(dev);
> @@ -688,11 +690,18 @@ struct lpphy_iq_est { u32 iq_prod, i_pwr, q_pwr; };
> 
> static void lpphy_set_rc_cap(struct b43_wldev *dev)
> {
> -    u8 rc_cap = dev->phy.lp->rc_cap;
> +    struct b43_phy_lp *lpphy = dev->phy.lp;
> 
> -    b43_radio_write(dev, B2062_N_RXBB_CALIB2, max_t(u8, rc_cap-4, 0x80));
> -    b43_radio_write(dev, B2062_N_TX_CTL_A, ((rc_cap & 0x1F) >> 1) | 0x80);
> -    b43_radio_write(dev, B2062_S_RXG_CNT16, ((rc_cap & 0x1F) >> 2) |
> 0x80);
> +    u8 rc_cap = (lpphy->rc_cap & 0x1F) >> 1;
> +   
> +    if (dev->phy.rev == 1) //FIXME check channel 14!
> +        rc_cap = max_t(u8, rc_cap + 5, 15);
> +
> +    b43_radio_write(dev, B2062_N_RXBB_CALIB2,
> +            max_t(u8, lpphy->rc_cap - 4, 0x80));
> +    b43_radio_write(dev, B2062_N_TX_CTL_A, rc_cap | 0x80);
> +    b43_radio_write(dev, B2062_S_RXG_CNT16,
> +            ((lpphy->rc_cap & 0x1F) >> 2) | 0x80);
> }
> 
> static u8 lpphy_get_bb_mult(struct b43_wldev *dev)
> @@ -1101,6 +1110,9 @@ static void lpphy_set_tx_power_control(struct
> b43_wldev *dev,
>     lpphy_write_tx_pctl_mode_to_hardware(dev);
> }
> 
> +static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
> +                       unsigned int new_channel);
> +
> static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
> {
>     struct b43_phy_lp *lpphy = dev->phy.lp;
> @@ -1118,11 +1130,16 @@ static void lpphy_rev0_1_rc_calib(struct
> b43_wldev *dev)
>         old_rf2_ovr, old_rf2_ovrval, old_phy_ctl;
>     enum b43_lpphy_txpctl_mode old_txpctl;
>     u32 normal_pwr, ideal_pwr, mean_sq_pwr, tmp = 0, mean_sq_pwr_min = 0;
> -    int loopback, i, j, inner_sum;
> +    int loopback, i, j, inner_sum, err;
> 
>     memset(&iq_est, 0, sizeof(iq_est));
> 
> -    b43_switch_channel(dev, 7);
> +    err = b43_lpphy_op_switch_channel(dev, 7);
> +    if (err) {
> +        b43dbg(dev->wl,
> +               "RC calib: Failed to switch to channel 7, error = %d",
> +               err);
> +    }
>     old_txg_ovr = (b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR) >> 6) & 1;
>     old_bbmult = lpphy_get_bb_mult(dev);
>     if (old_txg_ovr)
> @@ -1881,14 +1898,14 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
> {
>     struct b43_phy_lp *lpphy = dev->phy.lp;
>     struct ssb_bus *bus = dev->dev->bus;
> -    static const struct b206x_channel *chandata = NULL;
> +    const struct b206x_channel *chandata = NULL;
>     u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
>     u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9;
>     int i, err = 0;
> 
> -    for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
> +    for (i = 0; i < ARRAY_SIZE(b2062_chantbl); i++) {
>         if (b2063_chantbl[i].channel == channel) {
              -----
This should also be b2062. As long as the two tables have the same
channel ordering, this way would work.

> -            chandata = &b2063_chantbl[i];
> +            chandata = &b2062_chantbl[i];
>             break;
>         }
>     }

Larry
