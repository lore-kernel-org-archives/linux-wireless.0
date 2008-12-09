Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:42658 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYLIMgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 07:36:32 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] mac80211: clean up set_key callback
Date: Tue, 9 Dec 2008 13:36:31 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
References: <1228757035.22164.94.camel@johannes.berg>
In-Reply-To: <1228757035.22164.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812091336.31889.chunkeey@web.de> (sfid-20081209_133637_917541_F2B51632)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008 18:23:55 Johannes Berg wrote:
> The set_key callback now seems rather odd, passing a MAC address
> instead of a station struct, and a local address instead of a
> vif struct. Change that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
Acked-by: Christian Lamparter <chunkeey@web.de>

> --- everything.orig/drivers/net/wireless/p54/p54common.c	2008-12-08 17:47:11.000000000 +0100
> +++ everything/drivers/net/wireless/p54/p54common.c	2008-12-08 17:53:09.000000000 +0100
> @@ -1938,7 +1938,7 @@ static void p54_bss_info_changed(struct 
>  }
>  
>  static int p54_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
> -		       const u8 *local_address, const u8 *address,
> +		       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
>  		       struct ieee80211_key_conf *key)
>  {
>  	struct p54_common *priv = dev->priv;
> @@ -2002,8 +2002,8 @@ static int p54_set_key(struct ieee80211_
>  	rxkey->entry = key->keyidx;
>  	rxkey->key_id = key->keyidx;
>  	rxkey->key_type = algo;
> -	if (address)
> -		memcpy(rxkey->mac, address, ETH_ALEN);
> +	if (sta)
> +		memcpy(rxkey->mac, sta->addr, ETH_ALEN);
>  	else
>  		memset(rxkey->mac, ~0, ETH_ALEN);
>  	if (key->alg != ALG_TKIP) {
