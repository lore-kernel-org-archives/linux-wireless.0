Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2GYJgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 05:36:40 -0400
Message-ID: <1343208990.4463.25.camel@jlt3.sipsolutions.net> (sfid-20120725_113644_599580_8AC4476F)
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Date: Wed, 25 Jul 2012 11:36:30 +0200
In-Reply-To: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120724_221843_511093_701FFAF2)
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120724_221843_511093_701FFAF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 22:18 +0200, Thomas Huehn wrote:
> The pointer control.sta is removed from ieee80211_tx_info to free up
> sufficient memory in SKB_CB on the tx-path to enable new annotations
> per data packet e.g.support of upcoming Transmit Power Control (TPC).
> Now the control.sta pointer is put on the stack where passed as
> function parameter to the .tx equivalent (ieee80211_ops) of each
> affected wireless driver.
> Therefore a new structure ieee80211_tx_control is added to mac80211.h
> which holds the sta structure instead. The tx-path of all affected
> drivers is restructured to respect the chaneges.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> restructure this patch to respect logical API evolutions. thx to Johannes Berg
> add missing drivers that are effected as well. thx to Xose Vazquez Perez
> add missing drivers that are effected as well. thx to Johannes Berg
> simplified control pointer passing in tx.c - thx to Johannes Berg

Finally applied, but I dropped these spurious changes:

> @@ -1301,8 +1302,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
>  		break;
>  	}
>  
> -	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
> -				    txpending);
> +	result = ieee80211_tx_frags(local, vif, pubsta, skbs, txpending);
>  
>  	ieee80211_tpt_led_trig_tx(local, fc, led_len);
>  	ieee80211_led_tx(local, 1);
> @@ -1409,8 +1409,8 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
>  			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
>  
>  	if (!invoke_tx_handlers(&tx))
> -		result = __ieee80211_tx(local, &tx.skbs, led_len,
> -					tx.sta, txpending);
> +		result = __ieee80211_tx(local, &tx.skbs, led_len, tx.sta,
> +					txpending);
>   out:
>  	rcu_read_unlock();
>  	return result;

johannes

