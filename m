Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753468AbXLIW3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 17:29:25 -0500
Subject: Re: [RFC/T][PATCH 2/3] rc80211-pid: introduce PID sharpening factor
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071209212133.43030d03@morte>
References: <20071209211547.2d7fca32@morte>  <20071209212133.43030d03@morte>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 23:29:21 +0100
Message-Id: <1197239361.7543.17.camel@localhost> (sfid-20071209_222950_791474_5B899962)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-09 at 21:21 +0100, Stefano Brivio wrote:
> This patch introduces a PID sharpening factor for faster response on
> association and interpolation.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> Index: wireless-2.6/net/mac80211/rc80211_pid.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/rc80211_pid.c
> +++ wireless-2.6/net/mac80211/rc80211_pid.c
> @@ -23,13 +23,15 @@
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
> + *			association or interpolation), heading to zero over time
>   * 	CP	Proportional coefficient
>   * 	CI	Integral coefficient
>   * 	CD	Derivative coefficient
> @@ -65,6 +67,11 @@
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
> @@ -127,8 +134,11 @@ struct rc_pid_sta_info {
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
> @@ -271,10 +281,12 @@ static void rate_control_pid_sample(stru
>  	spinfo->last_sample = jiffies;
>  
>  	/* If no frames were transmitted, we assume the old sample is
> -	 * still a good measurement and copy it. */
> -	if (spinfo->tx_num_xmit == 0)
> +	 * still a good measurement and copy it, and turn the sharpening factor
> +	 * on. */
> +	if (spinfo->tx_num_xmit == 0) {
>  		pf = spinfo->last_pf;
> -	else {
> +		spinfo->sharp_cnt = RATE_CONTROL_SHARPENING_DURATION;
> +	} else {

Note that current rate_control_pid_sample() is only called from
rate_control_pid_tx_status(), which does an tx_num_xmit++ in advance. So
the tx_num_xmit branch should actually never be executed (I kept it only
to guard against any division by zero errors). I guess this makes the
whole patch basically a noop.

>  		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
>  		pf <<= RC_PID_ARITH_SHIFT;
>  
> @@ -314,8 +326,11 @@ static void rate_control_pid_sample(stru
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

