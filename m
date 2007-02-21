Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37819
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161315AbXBUQNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 11:13:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 17:12:53 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.46661.IvDoorn@gmail.com>
In-Reply-To: <200702211702.46661.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211712.54089.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 February 2007 17:02, Ivo van Doorn wrote:
> Currently d80211 only uses a single variable for antenna selection,
> some devices (rt2x00) can configure the TX and RX antenna
> seperately from eachother.
> Assuming that antenna_sel is only for tx, and rx is "the other antenna"
> is flawed and does hinder possible switching of RX antenna based
> on RSSI results. And configuring the wrong antenna also impacts
> transfer rates and link quality.
> 
> This patch will remove the usage of the IOCTL call:
> PRISM2_PARAM_ANTENNA_SEL but will restore the usage of
> (the already excisting) IOCTL calls PRISM2_PARAM_ANTSEL_TX and
> PRISM2_PARAM_ANTSEL_RX.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> diff --git a/include/net/d80211.h b/include/net/d80211.h
> index 551fe46..68c8c8a 100644
> --- a/include/net/d80211.h
> +++ b/include/net/d80211.h
> @@ -196,7 +196,8 @@ struct ieee80211_tx_control {
>  						* above */
>  	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
>  	u8 power_level;		/* per-packet transmit power level, in dBm */
> -	u8 antenna_sel; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
> +	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
> +	u8 antenna_sel_rx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */

This doesn't make sense to me.
Why should we want to set the RX antenna on TXing a packet?

>  	s8 key_idx;		/* -1 = do not encrypt, >= 0 keyidx from
>  				 * hw->set_key() */
>  	u8 icv_len;		/* length of the ICV/MIC field in octets */
> @@ -285,10 +286,9 @@ struct ieee80211_conf {
>          u8 antenna_max;			/* maximum antenna gain */
>  	short tx_power_reduction; /* in 0.1 dBm */
>  
> -	int antenna_sel;		/* default antenna conf:
> -					 *	0 = default/diversity,
> -			  		 *	1 = Ant0,
> -					 *	2 = Ant1 */
> +	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
> +	u8 antenna_sel_tx;
> +	u8 antenna_sel_rx;

This makes sense, yes. I ack this.

-- 
Greetings Michael.
