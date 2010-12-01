Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60694 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0LAQpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 11:45:34 -0500
Message-ID: <4CF67BAB.60504@openwrt.org>
Date: Wed, 01 Dec 2010 17:45:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/26] ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7
 from an array for AR9485
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com> <1291188775-13707-12-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-12-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-12-01 8:32 AM, Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |   25 ++++++++++++++++++++++++-
>  1 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 4e35bda..4739af1 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -25,6 +25,24 @@ static const int cycpwrThr1_table[] =
>  /* level:  0   1   2   3   4   5   6   7   8  */
>  	{ -6, -4, -2,  0,  2,  4,  6,  8 };     /* lvl 0-7, default 3 */
>  
> +/* Chansel table used by ar9485 */
> +static const u32 ar9003_chansel_xtal_40M[] = {
> +	0xa0ccbe,
> +	0xa12213,
> +	0xa17769,
> +	0xa1ccbe,
> +	0xa22213,
> +	0xa27769,
> +	0xa2ccbe,
> +	0xa32213,
> +	0xa37769,
> +	0xa3ccbe,
> +	0xa42213,
> +	0xa47769,
> +	0xa4ccbe,
> +	0xa5998b,
> +};
> +
>  /*
>   * register values to turn OFDM weak signal detection OFF
>   */
> @@ -75,7 +93,12 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
>  	freq = centers.synth_center;
>  
>  	if (freq < 4800) {     /* 2 GHz, fractional mode */
> -		channelSel = CHANSEL_2G(freq);
> +		if (AR_SREV_9485(ah)) {
> +			int ichan = ieee80211_frequency_to_channel(freq);
> +
> +			channelSel = ar9003_chansel_xtal_40M[ichan - 1];
> +		} else
> +			channelSel = CHANSEL_2G(freq);
I looked at the values of this table, this is exactly the same as what
CHANSEL_2G() returns except that the table has an offset of -14.
Please use CHANSEL_2G(freq) - 14 for AR9485 and drop the table to avoid
adding more unnecessary hardcoded values.

- Felix
