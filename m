Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57872
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbXJGOy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2007 10:54:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH] mac80211: Defer setting of RX_FLAG_DECRYPTED.
Date: Sun, 7 Oct 2007 16:53:53 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <1191767731.8135.5.camel@localhost>
In-Reply-To: <1191767731.8135.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710071653.53335.mb@bu3sch.de> (sfid-20071007_155434_925897_2E555CC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 07 October 2007 16:35:31 Mattias Nissler wrote:
> The decryption handlers will skip the frame if the RX_FLAG_DECRYPTED
> flag is set, so the early flag setting introduced by Johannes breaks
> decryption. To work around this, call the handlers first and then set
> the flag.
> 
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> ---
>  net/mac80211/rx.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index de3f7ae..34699a1 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -424,6 +424,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
>  	int keyidx;
>  	int hdrlen;
> +	ieee80211_txrx_result result = TXRX_DROP;
>  	struct ieee80211_key *stakey = NULL;
>  
>  	/*
> @@ -522,21 +523,22 @@ ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
>  	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
>  		rx->sta->wep_weak_iv_count++;
>  
> -	/* either the frame will be decrypted or dropped */
> -	rx->u.rx.status->flag |= RX_FLAG_DECRYPTED;
> -
>  	switch (rx->key->conf.alg) {
>  	case ALG_WEP:
> -		return ieee80211_crypto_wep_decrypt(rx);
> +		result = ieee80211_crypto_wep_decrypt(rx);
> +		break;
>  	case ALG_TKIP:
> -		return ieee80211_crypto_tkip_decrypt(rx);
> +		result = ieee80211_crypto_tkip_decrypt(rx);
> +		break;
>  	case ALG_CCMP:
> -		return ieee80211_crypto_ccmp_decrypt(rx);
> +		result = ieee80211_crypto_ccmp_decrypt(rx);
> +		break;
>  	}
>  
> -	/* not reached */
> -	WARN_ON(1);
> -	return TXRX_DROP;
> +	/* either the frame will be decrypted or dropped */

I think this comment doesn't apply then anymore, eh?

> +	rx->u.rx.status->flag |= RX_FLAG_DECRYPTED;
> +
> +	return result;
>  }
>  
>  static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)



-- 
Greetings Michael.
