Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:43305 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaAIM0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:26:48 -0500
Message-ID: <52CE934D.1020400@neratec.com> (sfid-20140109_132652_796614_DFD3B96E)
Date: Thu, 09 Jan 2014 13:17:17 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org> <1384665016-12022-5-git-send-email-sujith@msujith.org>
In-Reply-To: <1384665016-12022-5-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2013 06:10 AM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> Since calibration data reuse is not enabled in
> SoC chips, simplify the IQ calibration code.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/ar9003_calib.c | 20 ++++++++------------
>   1 file changed, 8 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 58eacf1..a18c3dd 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -1255,22 +1255,19 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
>   
>   	/*
>   	 * For AR9485 or later chips, TxIQ cal runs as part of
> -	 * AGC calibration
> +	 * AGC calibration. Specifically, AR9550 in SoC chips.
>   	 */
>   	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
> -		if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags))
> -			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
> -				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
> -		else
> -			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
> -				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
> -		txiqcal_done = run_agc_cal = true;
> -	} else if (caldata && !test_bit(TXIQCAL_DONE, &caldata->cal_flags)) {
> +		txiqcal_done = true;
>   		run_agc_cal = true;
> +	} else {
>   		sep_iq_cal = true;
> +		run_agc_cal = true;
> 	}
This code will always set run_agc to true. Does it mean you always have 
to run agc
cal no matter what since default is anyway true or it's just a typo?

if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
		txiqcal_done = true;
  		run_agc_cal = true;
} else {
  		sep_iq_cal = true;
		run_agc_cal = true;
}

The reason I am asking is that I have ran into problem with rssi reporting when calibration is ongoing.
It looks like beacon received just after IQ mismatch calibration is reported ~10-15 dB higher
than it should. I have verified power with wireshark and they are ok at antenna port.
Next beacons are reported fine. I have tried to enable disable different antennas but it doesn't seem
to affect the results.

It doesn't happen all the time but since iq calibration is on every time we are scanning it puts
wrong rssi value in scan result entry. I don't have a proof yet but it might affect probe responses
as well.

Br,
Wojtek

>   
> -skip_tx_iqcal:
> +	/*
> +	 * In the SoC family, this will run for AR9300, AR9331 and AR9340.
> +	 */
>   	if (sep_iq_cal) {
>   		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
>   		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
> @@ -1278,6 +1275,7 @@ skip_tx_iqcal:
>   		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
>   	}
>   
> +skip_tx_iqcal:
>   	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
>   		/* Calibrate the AGC */
>   		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
> @@ -1299,8 +1297,6 @@ skip_tx_iqcal:
>   
>   	if (txiqcal_done)
>   		ar9003_hw_tx_iq_cal_post_proc(ah, is_reusable);
> -	else if (caldata && test_bit(TXIQCAL_DONE, &caldata->cal_flags))
> -		ar9003_hw_tx_iq_cal_reload(ah);
>   
>   	/* Revert chainmask to runtime parameters */
>   	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);

