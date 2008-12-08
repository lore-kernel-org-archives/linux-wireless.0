Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52455 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYLHULu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 15:11:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] mac80211: clean up set_key callback
Date: Mon, 8 Dec 2008 21:11:22 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
References: <1228757035.22164.94.camel@johannes.berg>
In-Reply-To: <1228757035.22164.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200812082111.22996.mb@bu3sch.de> (sfid-20081208_211154_094553_ADE98E26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008 18:23:55 Johannes Berg wrote:
> --- everything.orig/drivers/net/wireless/b43/main.c	2008-12-08 17:42:05.000000000 +0100
> +++ everything/drivers/net/wireless/b43/main.c	2008-12-08 17:49:40.000000000 +0100
> @@ -3508,8 +3508,8 @@ static void b43_op_bss_info_changed(stru
>  }
>  
>  static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> -			   const u8 *local_addr, const u8 *addr,
> -			   struct ieee80211_key_conf *key)
> +			  struct ieee80211_vif *vif, struct ieee80211_sta *sta,
> +			  struct ieee80211_key_conf *key)
>  {
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
>  	struct b43_wldev *dev;
> @@ -3567,17 +3567,13 @@ static int b43_op_set_key(struct ieee802
>  			goto out_unlock;
>  		}
>  
> -		if (is_broadcast_ether_addr(addr)) {
> +		if (!sta) {
>  			/* addr is FF:FF:FF:FF:FF:FF for default keys */

Please also remove this comment.

>  			err = b43_key_write(dev, index, algorithm,
>  					    key->key, key->keylen, NULL, key);
>  		} else {
> -			/*
> -			 * either pairwise key or address is 00:00:00:00:00:00
> -			 * for transmit-only keys
> -			 */
> -			err = b43_key_write(dev, -1, algorithm,
> -					    key->key, key->keylen, addr, key);
> +			err = b43_key_write(dev, -1, algorithm, key->key,
> +					    key->keylen, sta->addr, key);
>  		}
>  		if (err)
>  			goto out_unlock;
> @@ -3604,10 +3600,12 @@ out_unlock:
>  	spin_unlock_irqrestore(&wl->irq_lock, flags);
>  	mutex_unlock(&wl->mutex);
>  	if (!err) {
> +		static const u8 bcast_addr[ETH_ALEN] =
> +			{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
>  		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
>  		       "mac: %s\n",
>  		       cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
> -		       print_mac(mac, addr));
> +		       print_mac(mac, sta ? sta->addr : bcast_addr));

Will throw "unused variable bcast_addr" for !DEBUG.
Use something like
		sta ? print_mac(mac, sta->addr) : "group/tx-only");

-- 
Greetings Michael.
