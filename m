Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0LOJMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 04:12:30 -0500
Subject: Re: [PATCH] mac80211: Add timeout to BA session start API
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith.Manoharan@atheros.com
In-Reply-To: <19720.9510.589223.207856@gargle.gargle.HOWL>
References: <19720.9510.589223.207856@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 10:12:27 +0100
Message-ID: <1292404347.3678.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 07:47 +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Allow drivers or rate control algorithms to specify BlockAck session
> timeout when initiating an ADDBA transaction. This is useful in cases
> where maintaining persistent BA sessions does not incur any overhead.
> 
> The current timeout value of 5000 TUs is retained for all non ath9k/ath9k_htc
> drivers.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -374,7 +374,7 @@ minstrel_aggr_check(struct minstrel_priv *mp, struct ieee80211_sta *pubsta, stru
>  	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
>  		return;
>  
> -	ieee80211_start_tx_ba_session(pubsta, tid);
> +	ieee80211_start_tx_ba_session(pubsta, tid, 5000);
>  }
>  
>  static void

Maybe you need to make minstrel configurable here. Or maybe instead of
passing the value to the function directly, it should be a config option
in the hw struct? I'll let you sort that out with other people (Ivo?
Helmut? anyone else working on HT drivers?) -- I don't care since we
can't use minstrel for iwlwifi anyway.

johannes

