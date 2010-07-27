Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab0G0GiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 02:38:23 -0400
Subject: Re: [PATCH] mac80211: Fix key freeing to handle unlinked keys
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100726225203.GA31787@jm.kir.nu>
References: <1275380359.3621.17.camel@jlt3.sipsolutions.net>
	 <20100724053301.GA6773@jm.kir.nu>
	 <1279962385.8223.2.camel@jlt3.sipsolutions.net>
	 <20100726013953.GA29386@jm.kir.nu>
	 <1280130178.3693.1.camel@jlt3.sipsolutions.net>
	 <20100726142058.GA7324@jm.kir.nu>
	 <1280154447.3693.9.camel@jlt3.sipsolutions.net>
	 <20100726225203.GA31787@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 08:38:18 +0200
Message-ID: <1280212698.19098.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 15:52 -0700, Jouni Malinen wrote:
> Key locking simplification removed key->sdata != NULL verification from
> ieee80211_key_free(). While that is fine for most use cases, there is one
> path where this function can be called with an unlinked key (i.e.,
> key->sdata == NULL && key->local == NULL). This results in a NULL pointer
> dereference with the current implementation. This is known to happen at
> least with FT protocol when wpa_supplicant tries to configure the key
> before association.
> 
> Avoid the issue by passing in the local pointer to
> ieee80211_key_free(). In addition, do not clear the key from hw_accel
> or debugfs if it has not yet been added. At least the hw_accel one could
> trigger another NULL pointer dereference.
> 
> Signed-off-by: Jouni Malinen <j@w1.fi>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/cfg.c      |    6 +++---
>  net/mac80211/key.c      |   13 ++++++-------
>  net/mac80211/key.h      |    3 ++-
>  net/mac80211/sta_info.c |    2 +-
>  4 files changed, 12 insertions(+), 12 deletions(-)
> 
> (Note: The reference to key locking simplification is to the commit
> ad0e2b5a00dbec303e4682b403bb6703d11dcdb2 which is not yet in linux-2.6.)


Yes, this is because it's in wireless-next-2.6, the commit ID should
still be stable.

johannes

> --- wireless-testing.orig/net/mac80211/cfg.c	2010-07-26 14:44:01.000000000 -0700
> +++ wireless-testing/net/mac80211/cfg.c	2010-07-26 14:44:43.000000000 -0700
> @@ -158,7 +158,7 @@ static int ieee80211_add_key(struct wiph
>  	if (mac_addr) {
>  		sta = sta_info_get_bss(sdata, mac_addr);
>  		if (!sta) {
> -			ieee80211_key_free(key);
> +			ieee80211_key_free(sdata->local, key);
>  			err = -ENOENT;
>  			goto out_unlock;
>  		}
> @@ -192,7 +192,7 @@ static int ieee80211_del_key(struct wiph
>  			goto out_unlock;
>  
>  		if (sta->key) {
> -			ieee80211_key_free(sta->key);
> +			ieee80211_key_free(sdata->local, sta->key);
>  			WARN_ON(sta->key);
>  			ret = 0;
>  		}
> @@ -205,7 +205,7 @@ static int ieee80211_del_key(struct wiph
>  		goto out_unlock;
>  	}
>  
> -	ieee80211_key_free(sdata->keys[key_idx]);
> +	ieee80211_key_free(sdata->local, sdata->keys[key_idx]);
>  	WARN_ON(sdata->keys[key_idx]);
>  
>  	ret = 0;
> --- wireless-testing.orig/net/mac80211/key.c	2010-07-26 14:43:07.000000000 -0700
> +++ wireless-testing/net/mac80211/key.c	2010-07-26 14:44:43.000000000 -0700
> @@ -323,13 +323,15 @@ static void __ieee80211_key_destroy(stru
>  	if (!key)
>  		return;
>  
> -	ieee80211_key_disable_hw_accel(key);
> +	if (key->local)
> +		ieee80211_key_disable_hw_accel(key);
>  
>  	if (key->conf.alg == ALG_CCMP)
>  		ieee80211_aes_key_free(key->u.ccmp.tfm);
>  	if (key->conf.alg == ALG_AES_CMAC)
>  		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
> -	ieee80211_debugfs_key_remove(key);
> +	if (key->local)
> +		ieee80211_debugfs_key_remove(key);
>  
>  	kfree(key);
>  }
> @@ -410,15 +412,12 @@ static void __ieee80211_key_free(struct 
>  	__ieee80211_key_destroy(key);
>  }
>  
> -void ieee80211_key_free(struct ieee80211_key *key)
> +void ieee80211_key_free(struct ieee80211_local *local,
> +			struct ieee80211_key *key)
>  {
> -	struct ieee80211_local *local;
> -
>  	if (!key)
>  		return;
>  
> -	local = key->sdata->local;
> -
>  	mutex_lock(&local->key_mtx);
>  	__ieee80211_key_free(key);
>  	mutex_unlock(&local->key_mtx);
> --- wireless-testing.orig/net/mac80211/key.h	2010-07-26 14:43:07.000000000 -0700
> +++ wireless-testing/net/mac80211/key.h	2010-07-26 14:44:43.000000000 -0700
> @@ -135,7 +135,8 @@ struct ieee80211_key *ieee80211_key_allo
>  void ieee80211_key_link(struct ieee80211_key *key,
>  			struct ieee80211_sub_if_data *sdata,
>  			struct sta_info *sta);
> -void ieee80211_key_free(struct ieee80211_key *key);
> +void ieee80211_key_free(struct ieee80211_local *local,
> +			struct ieee80211_key *key);
>  void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx);
>  void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
>  				    int idx);
> --- wireless-testing.orig/net/mac80211/sta_info.c	2010-07-26 14:43:07.000000000 -0700
> +++ wireless-testing/net/mac80211/sta_info.c	2010-07-26 14:44:43.000000000 -0700
> @@ -647,7 +647,7 @@ static int __must_check __sta_info_destr
>  		return ret;
>  
>  	if (sta->key) {
> -		ieee80211_key_free(sta->key);
> +		ieee80211_key_free(local, sta->key);
>  		WARN_ON(sta->key);
>  	}
>  


