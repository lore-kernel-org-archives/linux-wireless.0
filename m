Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:58179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYLHWyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 17:54:03 -0500
Received: by ug-out-1314.google.com with SMTP id 39so854093ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 14:54:01 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT] mac80211: clean up set_key callback
Date: Mon, 8 Dec 2008 23:53:57 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, Tomas Winkler <tomasw@gmail.com>,
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
  charset="iso-8859-15"
Message-Id: <200812082353.58453.IvDoorn@gmail.com> (sfid-20081208_235409_218029_35606B0D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008, Johannes Berg wrote:
> The set_key callback now seems rather odd, passing a MAC address
> instead of a station struct, and a local address instead of a
> vif struct. Change that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK for the rt2x00 changes,
I'm especially happy with the ieee80211_find_sta() removal from rt2x00. :)

I'll see if I can test this in a few days,
One small change request though.

> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-12-08 17:48:03.000000000 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-12-08 17:57:43.000000000 +0100
> @@ -483,15 +483,17 @@ EXPORT_SYMBOL_GPL(rt2x00mac_configure_fi
>  
>  #ifdef CONFIG_RT2X00_LIB_CRYPTO
>  int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> -		      const u8 *local_address, const u8 *address,
> +		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
>  		      struct ieee80211_key_conf *key)
>  {
>  	struct rt2x00_dev *rt2x00dev = hw->priv;
> -	struct ieee80211_sta *sta;
> +	struct rt2x00_intf *intf = vif_to_intf(vif);
>  	int (*set_key) (struct rt2x00_dev *rt2x00dev,
>  			struct rt2x00lib_crypto *crypto,
>  			struct ieee80211_key_conf *key);
>  	struct rt2x00lib_crypto crypto;
> +	static const u8 bcast_addr[ETH_ALEN] =
> +		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
>  
>  	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
>  		return 0;
> @@ -509,15 +511,14 @@ int rt2x00mac_set_key(struct ieee80211_h
>  	if (rt2x00dev->intf_sta_count)
>  		crypto.bssidx = 0;
>  	else
> -		crypto.bssidx =
> -		    local_address[5] & (rt2x00dev->ops->max_ap_intf - 1);
> +		crypto.bssidx = intf->mac[5] & (rt2x00dev->ops->max_ap_intf - 1);
>  
>  	crypto.cipher = rt2x00crypto_key_to_cipher(key);
>  	if (crypto.cipher == CIPHER_NONE)
>  		return -EOPNOTSUPP;
>  
>  	crypto.cmd = cmd;
> -	crypto.address = address;
> +	crypto.address = sta ? sta->addr : bcast_addr;
>  
>  	if (crypto.cipher == CIPHER_TKIP) {
>  		if (key->keylen > NL80211_TKIP_DATA_OFFSET_ENCR_KEY)
> @@ -542,11 +543,8 @@ int rt2x00mac_set_key(struct ieee80211_h
>  	 * Some drivers need this information when updating the
>  	 * hardware key (either adding or removing).
>  	 */
> -	rcu_read_lock();
> -	sta = ieee80211_find_sta(hw, address);
>  	if (sta)
>  		crypto.aid = sta->aid;
> -	rcu_read_unlock();

Please move this bit up a bit to merge it with the address if-statement:

	if (sta) {
		crypto.address = sta->addr;
		crypto.aid = sta->aid
	} else
		crypto.address = bcast_addr;

that would group the sta dependencies together so we only need to check
if sta is valid once.

Thanks!

Ivo
