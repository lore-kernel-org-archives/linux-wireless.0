Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbdCKKnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Mar 2017 05:43:03 -0500
Date: Sat, 11 Mar 2017 11:37:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] mac80211: rt2x00: add support for MT7620
Message-ID: <20170311103750.GA17556@redhat.com> (sfid-20170311_114619_707083_80F6B148)
References: <20170310123224.GA4573@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170310123224.GA4573@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Please remove mac80211 from the topic, this is not mac80211 patch.

> @@ -523,6 +590,16 @@ void rt2800_get_txwi_rxwi_size(struct rt2x00_dev *rt2x00dev,
>  		*rxwi_size = RXWI_DESC_SIZE_5WORDS;
>  		break;
>  
> +	case RT5390:
> +		if (rt2x00_rf(rt2x00dev, RF7620)) {
> +			*txwi_size = TXWI_DESC_SIZE_5WORDS;
> +			*rxwi_size = RXWI_DESC_SIZE_6WORDS;
> +		} else {
> +			*txwi_size = TXWI_DESC_SIZE_4WORDS;
> +			*rxwi_size = RXWI_DESC_SIZE_4WORDS;
> +		}
> +		break;

TXWI, RXWI sizes are not RF chipset properties. Similar like vendor
driver please introduce RT6352 (set chip.rt = RT6352 on init)
and use it when need to identify RT chip instead of mixing RT
checks and RF checks. There are few places below where this
need to be changed, I pointed some but not all.

BTW, I wondered where all this low level settings came from until
I realized that vendor driver use RT6352 name, that was confusing.
 
> +	if (!test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags)) {
> +		if (conf_is_ht40(conf)) {
> +			txrx_agc_fc = rt2x00_get_field8(
> +						drv_data->calibration_bw40,
> +						RFCSR24_TX_AGC_FC);
> +		} else {
> +			txrx_agc_fc = rt2x00_get_field8(
> +						drv_data->calibration_bw20,
> +						RFCSR24_TX_AGC_FC);
> +		}
> +		rt2800_rfcsr_read_bank(rt2x00dev, 5, 6, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 5, 6, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 5, 7, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 5, 7, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 7, 6, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 7, 6, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 7, 7, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 7, 7, rfcsr);
> +
> +		rt2800_rfcsr_read_bank(rt2x00dev, 5, 58, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 5, 58, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 5, 59, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 5, 59, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 7, 58, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 7, 58, rfcsr);
> +		rt2800_rfcsr_read_bank(rt2x00dev, 7, 59, &rfcsr);
> +		rfcsr &= (~0x3F);
> +		rfcsr |= txrx_agc_fc;
> +		rt2800_rfcsr_write_bank(rt2x00dev, 7, 59, rfcsr);

Vendor driver make this quite different. It use different procedure
on initialization than we do rt2800_init_rx_filter and use different
values for TX and RX. See BW_Filter_Calibration() and
RT6352_ChipSwitchChannel().

For now we can apply this, but need to be fixed in the future.

> -	tx_pin = 0;
> +	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);

I think this will not cause problems on other chipsets, but I would
be careful here. Having tx_pin = 0 is a problem for MT7620 ?

> -	if (rt2x00_rt(rt2x00dev, RT5592)) {
> +	if (rt2x00_rt(rt2x00dev, RT5592) ||
> +	    (rt2x00_rt(rt2x00dev, RT5390) && rt2x00_rf(rt2x00dev, RF7620))) {

	if (rt2x00_rt(rt2x00dev, RT5592) ||
	    rt2x00_rt(rt2x00dev, RT6352)) {

> +	else if (rt2x00_rf(rt2x00dev, RF7620))
> +		rt2800_config_txpower_mt7620(rt2x00dev, chan, power_level);

	else if (rt2x00_rt(rt2x00dev, RT6352))
		rt2800_config_txpower_rt6352(rt2x00dev, chan, power_level);


>  	case RT5390:
>  	case RT5392:
> -		rt2800_init_bbp_53xx(rt2x00dev);
> +		if (rt2x00_rf(rt2x00dev, RF7620))

	case RT6352:

> +static const struct rf_channel rf_vals_7620[] = {
> +	/* Channel, Rdiv, N, K | (D >> 8), Ksd */
> +	{1, 3, 0x50, 0 | (0 >> 8), 0x19999},
> +	{2, 3, 0x50, 0 | (0 >> 8), 0x24444},
> +	{3, 3, 0x50, 0 | (0 >> 8), 0x2EEEE},
> +	{4, 3, 0x50, 0 | (0 >> 8), 0x39999},
> +	{5, 3, 0x51, 0 | (0 >> 8), 0x04444},
> +	{6, 3, 0x51, 0 | (0 >> 8), 0x0EEEE},
> +	{7, 3, 0x51, 0 | (0 >> 8), 0x19999},
> +	{8, 3, 0x51, 0 | (0 >> 8), 0x24444},
> +	{9, 3, 0x51, 0 | (0 >> 8), 0x2EEEE},
> +	{10, 3, 0x51, 0 | (0 >> 8), 0x39999},
> +	{11, 3, 0x52, 0 | (0 >> 8), 0x04444},
> +	{12, 3, 0x52, 0 | (0 >> 8), 0x0EEEE},
> +	{13, 3, 0x52, 0 | (0 >> 8), 0x19999},
> +	{14, 3, 0x52, 0 | (0 >> 8), 0x33333},
> +};

It should D << 8, but it does not matter since values are 0.
You can just remove those from rf_vals and use 0 for K & D
on rt2800_config_channel_rf7620().

Stanislaw
