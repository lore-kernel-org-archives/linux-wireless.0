Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42372 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbcAFKoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 05:44:11 -0500
Message-ID: <1452077048.2541.5.camel@sipsolutions.net> (sfid-20160106_114417_294668_D1802852)
Subject: Re: [PATCH v2 1/2] mac80211: check requested flags in
 ieee80211_tx_prepare_skb()
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: j@w1.fi
Date: Wed, 06 Jan 2016 11:44:08 +0100
In-Reply-To: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_113556_363725_B1436A7B)
References: <1451990134-15183-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20160105_113556_363725_B1436A7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 11:35 +0100, Janusz Dziedzic wrote:
> In case driver already set info->flags (eg.
> IEEE80211_TX_CTL_NO_CCK_RATE
> in ath9k driver), before this patch we skip this requested flags.

I don't see how we "skip" them?

> +	unsigned int flags = info->flags;
>  
>  	if (ieee80211_tx_prepare(sdata, &tx, NULL, skb) == TX_DROP)
>  		return false;
> 
>  	info->band = band;
>  	info->control.vif = vif;
>  	info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
> +	info->flags |= flags;

tx_prepare() doesn't [seem to] do anything to the flags but twiddle a
few, so ?

johannes
