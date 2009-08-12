Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53683 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZHLSIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:08:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Implement RC calibration for rev.0/1 LP-PHYs
Date: Wed, 12 Aug 2009 20:08:29 +0200
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A830249.1010005@gmail.com>
In-Reply-To: <4A830249.1010005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908122008.29582.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 August 2009 19:56:25 Gábor Stefanik wrote:
> +		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF, 1<<8);

> +	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0x80FF, incr2 << 3);

Can you try to stick to one style? a << b is our coding style.

> +static void lpphy_run_ddfs(struct b43_wldev *dev, int i_on, int q_on,
> +                          int incr1, int incr2, int scale_idx)
> +{
> +       lpphy_stop_ddfs(dev);
> +       b43_phy_mask(dev, B43_LPPHY_AFE_DDFS_POINTER_INIT, 0xFF80);
> +       b43_phy_mask(dev, B43_LPPHY_AFE_DDFS_POINTER_INIT, 0x80FF);
> +       b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0xFF80, incr1);
> +       b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0x80FF, incr2 << 3);

3bit shift smells fishy. Did you want 8?

> +u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)

static?

> +static void lpphy_set_tx_power_control(struct b43_wldev *dev,
> +				       enum b43_lpphy_txpctl_mode mode);

Can you reorder the code to avoid the forward declaration?

> +	for (i = 128; i <= 159; i++) {
> +		b43_radio_write(dev, B2062_N_RXBB_CALIB2, i);
> +  		inner_sum = 0;
> +		for (j = 5; j <= 25; j++) {
> +			lpphy_run_ddfs(dev, 1, 1, j, j, 0);

(Just by guess) Did you really want j,j instead of i,j or something like that?

> +			if (!(lpphy_rx_iq_est(dev, 1000, 32, &iq_est)))
> +				goto finish;
> +			mean_sq_pwr = iq_est.i_pwr + iq_est.q_pwr;
> +			if (j == 5)
> +				tmp = mean_sq_pwr;
> +			ideal_pwr = ((ideal_pwr_table[j-5] >> 3) + 1) >> 1;
> +			normal_pwr = lpphy_qdiv_roundup(mean_sq_pwr, tmp, 12);
> +			mean_sq_pwr = ideal_pwr - normal_pwr;
> +			mean_sq_pwr *= mean_sq_pwr;
> +			inner_sum += mean_sq_pwr;
> +			if ((i = 128) || (inner_sum < mean_sq_pwr_min)) {
> +				lpphy->rc_cap = i;
> +				mean_sq_pwr_min = inner_sum;
> +			}
> +		}
> +	}
> +	lpphy_stop_ddfs(dev);
> +

> +	if (old_txg_ovr)
> +		/*
> +		 * SPEC FIXME: The specs say "get_tx_gains" here, which is
> +		 * illogical. According to lwfinger, vendor driver v4.150.10.5
> +		 * has a Set here, while v4.174.64.19 has a Get - regression in
> +		 * the vendor driver? This should be tested this once the code
> +		 * is testable.
> +		 */
> +		lpphy_set_tx_gains(dev, tx_gains);

Use curly brackets for multiline indents.

> +	lpphy_set_tx_power_control(dev, old_txpctl);
> +	if (lpphy->rc_cap)
> +		lpphy_set_rc_cap(dev);
>  }
>  
>  static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)



-- 
Greetings, Michael.
