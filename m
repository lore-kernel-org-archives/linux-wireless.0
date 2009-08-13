Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:59008 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZHMC2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 22:28:18 -0400
Received: by rv-out-0506.google.com with SMTP id f6so142045rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 19:28:19 -0700 (PDT)
Message-ID: <4A837A3F.6050703@lwfinger.net>
Date: Wed, 12 Aug 2009 21:28:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: Implement RC calibration for rev.0/1 LP-PHYs
References: <4A830CF1.3020907@gmail.com>
In-Reply-To: <4A830CF1.3020907@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Also implement get/set BB mult, get/set TX gain, set RX gain,
> disable/restore CRS, run/stop DDFS, RX IQ est and QDIV roundup
> in the process.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> Changes from v1->v2:
> -Coding style fixes as suggested by Michael.
> -Added missing static to lpphy_qdiv_roundup.
> -Moved set_tx_power_control & related functions before rev0/1 RC
> calibration,
> and removed forward declaration
> -Reordered variable declarations at the start of rev0_1_rc_calib.
> -The ideal power table is now static const.
> 
> Interdiff v1->v2 available @ http://b43.pastebin.com/f5fe6ba3c for
> easier review.
> 
> drivers/net/wireless/b43/phy_lp.c |  508
> +++++++++++++++++++++++++++++++++----
> 1 files changed, 461 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c
> b/drivers/net/wireless/b43/phy_lp.c
> index 689c932..e05981b 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -605,6 +605,8 @@ static void lpphy_radio_init(struct b43_wldev *dev)
>     }
> }
> 
> +struct lpphy_iq_est { u32 iq_prod, i_pwr, q_pwr; };
> +
> static void lpphy_set_rc_cap(struct b43_wldev *dev)
> {
>     u8 rc_cap = dev->phy.lp->rc_cap;
> @@ -614,79 +616,327 @@ static void lpphy_set_rc_cap(struct b43_wldev *dev)
>     b43_radio_write(dev, B2062_S_RXG_CNT16, ((rc_cap & 0x1F) >> 2) | 0x80);
> }
> 
> -static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
> +static u8 lpphy_get_bb_mult(struct b43_wldev *dev)
> {
> -    //TODO and SPEC FIXME
> +    return (b43_lptab_read(dev, B43_LPTAB16(0, 87)) & 0xFF00) >> 8;
> }
> 
> -static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
> +static void lpphy_set_bb_mult(struct b43_wldev *dev, u8 bb_mult)
> {
> -    struct ssb_bus *bus = dev->dev->bus;
> -    u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
> -    u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
> -    int i;
> +    b43_lptab_write(dev, B43_LPTAB16(0, 87), (u16)bb_mult << 8);
> +}
> 
> -    b43_radio_write(dev, B2063_RX_BB_SP8, 0x0);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
> -    b43_radio_mask(dev, B2063_PLL_SP1, 0xF7);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x15);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x70);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x52);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7D);
> +static void lpphy_disable_crs(struct b43_wldev *dev)
> +{
> +    b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x80);
> +    b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFC, 0x1);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x3);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFB);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x4);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFF7);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x8);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x10);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x10);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFDF);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x20);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFBF);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x40);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x7);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x38);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFF3F);
> +    b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x100);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFDFF);
> +    b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL0, 0);
> +    b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL1, 1);
> +    b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL2, 0x20);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFBFF);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xF7FF);
> +    b43_phy_write(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL, 0);
> +    b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, 0x45AF);
> +    b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, 0x3FF);
> +}
> 
> -    for (i = 0; i < 10000; i++) {
> -        if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
> -            break;
> -        msleep(1);
> +static void lpphy_restore_crs(struct b43_wldev *dev)
> +{
> +    if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
> +        b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x60);
> +    else
> +        b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x20);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFF80);
> +    b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFC00);
> +}
> +
> +struct lpphy_tx_gains { u16 gm, pga, pad, dac; };
> +
> +static struct lpphy_tx_gains lpphy_get_tx_gains(struct b43_wldev *dev)
> +{
> +    struct lpphy_tx_gains gains;
> +    u16 tmp;
> +
> +    gains.dac = (b43_phy_read(dev, B43_LPPHY_AFE_DAC_CTL) & 0x380) >> 7;
> +    if (dev->phy.rev < 2) {
> +        tmp = b43_phy_read(dev,
> +                   B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL) & 0x7FF;
> +        gains.gm = tmp & 0x0007;
> +        gains.pga = (tmp & 0x0078) >> 3;
> +        gains.pad = (tmp & 0x780) >> 7;
> +    } else {
> +        tmp = b43_phy_read(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL);
> +        gains.pad = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0xFF;
> +        gains.gm = tmp & 0xFF;
> +        gains.pga = (tmp >> 8) & 0xFF;
>     }
> 
> -    if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
> -        b43_radio_write(dev, B2063_RX_BB_SP8, tmp);
> +    return gains;
> +}
> 
> -    tmp = b43_radio_read(dev, B2063_TX_BB_SP3) & 0xFF;
> +static void lpphy_set_dac_gain(struct b43_wldev *dev, u16 dac)
> +{
> +    u16 ctl = b43_phy_read(dev, B43_LPPHY_AFE_DAC_CTL) & 0xC7F;
> +    ctl |= dac << 7;
> +    b43_phy_maskset(dev, B43_LPPHY_AFE_DAC_CTL, 0xF000, ctl);
> +}
> 
> -    b43_radio_write(dev, B2063_TX_BB_SP3, 0x0);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x55);
> -    b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x76);
> +static void lpphy_set_tx_gains(struct b43_wldev *dev,
> +                   struct lpphy_tx_gains gains)
> +{
> +    u16 rf_gain, pa_gain;
> 
> -    if (crystal_freq == 24000000) {
> -        b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0xFC);
> -        b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x0);
> +    if (dev->phy.rev < 2) {
> +        rf_gain = (gains.pad << 7) | (gains.pga << 3) | gains.gm;
> +        b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
> +                0xF800, rf_gain);
>     } else {
> -        b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x13);
> -        b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
> +        pa_gain = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0x7F00;
> +        b43_phy_write(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
> +                  (gains.pga << 8) | gains.gm);
> +        b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
> +                0x8000, gains.pad | pa_gain);
> +        b43_phy_write(dev, B43_PHY_OFDM(0xFC),
> +                  (gains.pga << 8) | gains.gm);
> +        b43_phy_maskset(dev, B43_PHY_OFDM(0xFD),
> +                0x8000, gains.pad | pa_gain);
> +    }
> +    lpphy_set_dac_gain(dev, gains.dac);
> +    if (dev->phy.rev < 2) {
> +        b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF, 1 << 8);
> +    } else {
> +        b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFF7F, 1 << 7);
> +        b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xBFFF, 1 << 14);
>     }
> +    b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFBF, 1 << 4);
> +}
> 
> -    b43_radio_write(dev, B2063_PA_SP7, 0x7D);
> +static void lpphy_rev0_1_set_rx_gain(struct b43_wldev *dev, u32 gain)
> +{
> +    u16 trsw = gain & 0x1;
> +    u16 lna = (gain & 0xFFFC) | ((gain & 0xC) >> 2);
> +    u16 ext_lna = (gain & 2) >> 1;
> +
> +    b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFE, trsw);
> +    b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
> +            0xFBFF, ext_lna << 10);
> +    b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
> +            0xF7FF, ext_lna << 11);
> +    b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, lna);
> +}
> 
> -    for (i = 0; i < 10000; i++) {
> -        if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
> +static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
> +{
> +    u16 low_gain = gain & 0xFFFF;
> +    u16 high_gain = (gain >> 16) & 0xF;
> +    u16 ext_lna = (gain >> 21) & 0x1;
> +    u16 trsw = ~(gain >> 21) & 0x1;
                            ==
Should be 20, not 21.

> +    u16 tmp;
> +    //SPEC FIXME is trsw really just ~(bool)ext_lna for rev2+?

No.

Larry

