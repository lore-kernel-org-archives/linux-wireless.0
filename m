Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48898 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZHMRk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:40:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC/RFT] b43: LP-PHY: Implement channel switching for rev2+/B2063 radio
Date: Thu, 13 Aug 2009 19:40:52 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A842AFD.1020903@gmail.com>
In-Reply-To: <4A842AFD.1020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908131940.52830.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 August 2009 17:02:21 Gábor Stefanik wrote:
> Rev.2+/B2063 will now hopefully show some signs of life, though
> it won't work at full performance, as calibration is still missing.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

>  static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
> @@ -1369,7 +1370,7 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
>  	lpphy_baseband_init(dev);
>  	lpphy_radio_init(dev);
>  	lpphy_calibrate_rc(dev);
> -	//TODO set channel
> +	b43_switch_channel(dev, dev->wl->hw->conf.channel->hw_value);

Does dev->wl->hw->conf.channel->hw_value already have a sane value here?
Also please call b43_lpphy_op_switch_channel() instead of b43_switch_channel().

> +static void lpphy_b2063_tune(struct b43_wldev *dev,
> +			     unsigned int channel)
> +{
> +	struct ssb_bus *bus = dev->dev->bus;
> +
> +	struct b2063_channel chandata;
> +	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
> +	u32 freqref, vco_freq, val1, val2, val3, timeout, timeoutref, count;
> +	u16 old_comm15, scale;
> +	u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6;
> +	int i, div = (crystal_freq <= 26000000 ? 1 : 2);
> +
> +	memset(&chandata, 0, sizeof(chandata));
> +
> +	for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
> +		if (b2063_chantbl[i].channel == channel) {
> +			chandata = b2063_chantbl[i];

Can you use a const pointer instead of copying the whole data structure?

> +			break;
> +		}
> +	}
> +
> +	B43_WARN_ON(!chandata.channel);

> +
>  static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>  				       unsigned int new_channel)
>  {
> -	//TODO
> +	struct b2063_channel chandata;
> +	int i;
> +
> +	memset(&chandata, 0, sizeof(chandata));
> +
> +	//FIXME this abuses the 2063 channel table for chan2freq purposes!
> +	for (i = 0; i < ARRAY_SIZE(b2063_chantbl); i++) {
> +		if (b2063_chantbl[i].channel == new_channel) {
> +			chandata = b2063_chantbl[i];
> +			break;
> +		}
> +	}
> +
> +	B43_WARN_ON(!chandata.channel);
> +
> +	/* FIXME this should be the last thing done, even after generic
> +	 * parts - does it matter?

It is correct as is.

> +	 * SPEC FIXME should this write channel, freq, chanspec or cookie?
> +	 */

Can you explain this FIXME? What's "chanspec", what's "cookie"?

> +	b43_write16(dev, B43_MMIO_CHANNEL, new_channel);
> +	if (dev->phy.radio_ver == 0x2063) {
> +		lpphy_b2063_tune(dev, new_channel);
> +	} else {
> +		lpphy_b2062_tune(dev, new_channel);
> +		//TODO Japan filter
> +	}
> +	lpphy_adjust_gain_table(dev, chandata.freq);
>  	return 0;
>  }
>  



-- 
Greetings, Michael.
