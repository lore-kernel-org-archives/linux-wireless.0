Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1DUMeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 08:34:01 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110421121513.GC27527@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
	 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
	 <20110415105140.GD11576@hertz.marvell.com>
	 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
	 <20110421121513.GC27527@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:33:56 +0200
Message-ID: <1303389236.3597.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 17:45 +0530, Yogesh Ashok Powar wrote:

> @@ -101,6 +101,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  
>  	if (!ret) {
>  		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
> +		if (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)
> +			key->local->crypto_tx_tailroom_needed_cnt++;
> +
>  		return 0;
>  	}
>  
> @@ -117,6 +120,11 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>  	case WLAN_CIPHER_SUITE_CCMP:
>  	case WLAN_CIPHER_SUITE_AES_CMAC:
>  		/* all of these we can do in software */
> +
> +		/* SW encryption need tailroom reservation */
> +		BUG_ON(!key->local);

BUG_ON? Seriously? It was already dereferenced about 10 times here... In
any case, this isn't right.

> @@ -156,6 +164,11 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
>  			  key->conf.keyidx, sta ? sta->addr : bcast_addr, ret);
>  
>  	key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
> +
> +	if ((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)
> +				&& key->local->crypto_tx_tailroom_needed_cnt)
> +		key->local->crypto_tx_tailroom_needed_cnt--;

And that if (cnt) can't be right either.


> +	if (key_sw_programmed && local->crypto_tx_tailroom_needed_cnt)
> +		local->crypto_tx_tailroom_needed_cnt--;

So you're putting if (needed_cnt) everywhere because you have
refcounting bugs? Better fix those bugs ....


> +	local->crypto_tx_tailroom_needed_cnt = 0;

Not necessary, it's already 0.


I don't think you understood what I said how it should work. You must
increase the counter when the key is created, and then you can reduce it
again when the key is uploaded and no mmic is needed.

johannes

