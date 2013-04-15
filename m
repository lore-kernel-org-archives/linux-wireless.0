Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3DONkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 09:40:35 -0400
Message-ID: <1366033231.8361.24.camel@jlt4.sipsolutions.net> (sfid-20130415_154039_568100_5E1B884B)
Subject: Re: [PATCH 2/5] mac80211: fix CTS protection handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Apr 2013 15:40:31 +0200
In-Reply-To: <1365890626-86895-2-git-send-email-nbd@openwrt.org>
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org>
	 <1365890626-86895-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-04-14 at 00:03 +0200, Felix Fietkau wrote:

> @@ -655,7 +655,9 @@ struct ieee80211_tx_info {
>  					struct ieee80211_tx_rate rates[
>  						IEEE80211_TX_MAX_RATES];
>  					s8 rts_cts_rate_idx;
> -					/* 3 bytes free */
> +					u8 use_rts:1;
> +					u8 use_cts_prot:1;

hmm, why here?

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -656,6 +656,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>  		txrc.rts = rts = true;
>  	}
>  
> +	info->control.use_rts = rts;

evidently, txrc already has an "rts" field?

johannes

