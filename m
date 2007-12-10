Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38300 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750971AbXLJG2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 01:28:05 -0500
Subject: Re: [RFC/T][PATCH v2 2/3] rc80211-pid: introduce PID sharpening
	factor
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071210032811.5cea4909@morte>
References: <20071209211547.2d7fca32@morte> <20071209212133.43030d03@morte>
	 <1197239361.7543.17.camel@localhost> <20071210003120.0078db1d@morte>
	 <1197244416.7543.27.camel@localhost>  <20071210032811.5cea4909@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 07:28:01 +0100
Message-Id: <1197268081.7490.10.camel@localhost> (sfid-20071210_062822_223084_1FC0B7D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 03:28 +0100, Stefano Brivio wrote:
> This patch introduces a PID sharpening factor for faster response after
> association and low activity events.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> Cc: Mattias Nissler <mattias.nissler@gmx.de>
> 
> ---
> 
> Ok, this isn't a no-op anymore. :)
> 
> ---
> 
> Index: wireless-2.6/net/mac80211/rc80211_pid.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/rc80211_pid.c
> +++ wireless-2.6/net/mac80211/rc80211_pid.c
> @@ -23,13 +23,16 @@
>   *
>   * The controller basically computes the following:
>   *
> - * adj = CP * err + CI * err_avg + CD * (err - last_err)
> + * adj = CP * err + CI * err_avg + CD * (err - last_err) * (1 + sharpening)
>   *
>   * where
>   * 	adj	adjustment value that is used to switch TX rate (see below)
>   * 	err	current error: target vs. current failed frames percentage
>   * 	last_err	last error
>   * 	err_avg	average (i.e. poor man's integral) of recent errors
> + *	sharpening	non-zero when fast response is needed (i.e. right after
> + *			association or no frames sent for a long time), heading
> + * 			to zero over time
>   * 	CP	Proportional coefficient
>   * 	CI	Integral coefficient
>   * 	CD	Derivative coefficient
> @@ -65,6 +68,11 @@
>  #define RC_PID_SMOOTHING_SHIFT 3
>  #define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
>  
> +/* Sharpening factor (used for D part of PID controller) */
> +#define RATE_CONTROL_SHARPENING_SHIFT 2
> +#define RATE_CONTROL_SHARPENING (1 << RATE_CONTROL_SHARPENING_SHIFT)
> +#define RATE_CONTROL_SHARPENING_DURATION 1
> +
>  /* Fixed point arithmetic shifting amount. */
>  #define RC_PID_ARITH_SHIFT 8
>  
> @@ -131,8 +139,11 @@ struct rc_pid_sta_info {
>  	 */
>  	s32 err_avg_sc;
>  
> -	/* Last framed failes percentage sample */
> +	/* Last framed failes percentage sample. */
>  	u32 last_pf;
> +
> +	/* Sharpening needed. */
> +	u8 sharp_cnt;
>  };
>  
>  /* Algorithm parameters. We keep them on a per-algorithm approach, so they can
> @@ -282,19 +293,19 @@ static void rate_control_pid_sample(stru
>  
>  	mode = local->oper_hw_mode;
>  	spinfo = sta->rate_ctrl_priv;
> +
> +	/* In case nothing happened during the previous control interval, turn
> +	 * on the sharpening factor. */
> +	if (jiffies - spinfo->last_sample > RC_PID_INTERVAL)
> +		spinfo->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
> +
>  	spinfo->last_sample = jiffies;
>  
> -	/* If no frames were transmitted, we assume the old sample is
> -	 * still a good measurement and copy it. */
> -	if (spinfo->tx_num_xmit == 0)
> -		pf = spinfo->last_pf;

Please don't remove this check. We can never know when anybody starts
calling rate_control_pid_sample() without packets transmitted. Then it's
good to have it, else we divide by zero in the next line.

> -	else {
> -		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
> -		pf <<= RC_PID_ARITH_SHIFT;
> +	pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
> +	pf <<= RC_PID_ARITH_SHIFT;
>  
> -		spinfo->tx_num_xmit = 0;
> -		spinfo->tx_num_failed = 0;
> -	}
> +	spinfo->tx_num_xmit = 0;
> +	spinfo->tx_num_failed = 0;
>  
>  	/* If we just switched rate, update the rate behaviour info. */
>  	if (pinfo->oldrate != sta->txrate) {
> @@ -321,8 +332,11 @@ static void rate_control_pid_sample(stru
>  	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
>  	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
>  
> -	err_der = pf - spinfo->last_pf;
> +	err_der = pf - spinfo->last_pf
> +		  * (1 + RATE_CONTROL_SHARPENING * spinfo->sharp_cnt);
>  	spinfo->last_pf = pf;
> +	if (spinfo->sharp_cnt)
> +			spinfo->sharp_cnt--;
>  
>  	/* Compute the controller output. */
>  	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
> 
> 

