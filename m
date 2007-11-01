Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:19406 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXKAV5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 17:57:24 -0400
Received: by nf-out-0910.google.com with SMTP id g13so663543nfb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 14:57:22 -0700 (PDT)
Message-ID: <472A4BBD.4050207@gmail.com> (sfid-20071101_215726_638994_B87C56EA)
Date: Thu, 01 Nov 2007 22:57:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/7] ath5k: Move OFDM timings into a helper routine
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo> <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo> <20071101215318.GC4182@pogo>
In-Reply-To: <20071101215318.GC4182@pogo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2007 10:53 PM, Luis R. Rodriguez wrote:
> ** Resending after checkpatch.pl.. 
> 
> This move the OFDM timings on ath5k_hw_reset() onto a helper,
> ath5k_hw_write_ofdm_timings() to make code cleaner.
> 
> Changes to ath5k.h, hw.c
> Changes-licensed-under: ISC
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/hw.c |   83 ++++++++++++++++++++++++++-------------
>  1 files changed, 55 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index 3f78d20..1b9c4f0 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -458,6 +458,56 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
>   */
>  
>  /**
> + * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
> + *
> + * @ah: the &struct ath5k_hw
> + * @channel: the currently set channel upon reset
> + *
> + * Write the OFDM timings for the AR5212 upon reset. This is a helper for
> + * ath5k_hw_reset(). This seems to tune the PLL a specified frequency
> + * depending on the bandwidth of the channel.
> + *
> + */
> +static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
> +	struct ieee80211_channel *channel)
> +{
> +	/* Get exponent and mantissa and set it */
> +	u32 coef_scaled, coef_exp, coef_man,
> +		ds_coef_exp, ds_coef_man, clock;
> +
> +	if (!(ah->ah_version == AR5K_AR5212) ||
> +		!(channel->val & CHANNEL_OFDM))
> +		BUG();

Note, that BUG can return (on configurations where !CONFIG_BUG). It is my fault
writing you it won't, sorry! Could you post a patch which will add return from
here and also from places where the BUG() is used in other places?

> +
> +	/* Seems there are two PLLs, one for baseband sampling and one
> +	 * for tuning. Tuning basebands are 40 MHz or 80MHz when in
> +	 * turbo. */
> +	clock = channel->val & CHANNEL_TURBO ? 80 : 40;
> +	coef_scaled = ((5 * (clock << 24)) / 2) /
> +	channel->freq;

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
