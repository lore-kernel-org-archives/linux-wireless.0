Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:56506 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752413Ab2BKPGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 10:06:20 -0500
Message-ID: <20120211150614.30728.qmail@stuge.se> (sfid-20120211_160624_189096_ACB2B546)
Date: Sat, 11 Feb 2012 16:06:14 +0100
From: Peter Stuge <peter@stuge.se>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: stop on rates with idx -1 in
	ath9k rate control's .tx_status
References: <20120211150152.4823.8570.stgit@ae>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120211150152.4823.8570.stgit@ae>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Rate control algorithms are supposed to stop processing when they
> encounter a rate with the index -1.  Checking for rate->count not being
> zero is not enough.

Maybe it's a good idea to use an unsigned variable and check for the
actual error condition when it can happen, instead of checking for an
"overflow" after the fact?


> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1346,7 +1346,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
>  	fc = hdr->frame_control;
>  	for (i = 0; i < sc->hw->max_rates; i++) {
>  		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
> -		if (!rate->count)
> +		if (rate->idx < 0 || !rate->count)
>  			break;

At the very least this could test for <= 0.


//Peter
