Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaCELLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:11:18 -0500
Message-ID: <1394017873.5275.22.camel@jlt4.sipsolutions.net> (sfid-20140305_121123_154788_8CDC000F)
Subject: Re: [PATCH 3.14.0-rc5 v3 5/10] rsi: MAC80211 callbacks to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 12:11:13 +0100
In-Reply-To: <53143B27.60205@redpinesignals.com> (sfid-20140303_092123_178066_6C4D5A72)
References: <53143B27.60205@redpinesignals.com>
	 (sfid-20140303_092123_178066_6C4D5A72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:49 +0530, Fariya Fatima wrote:

> +void rsi_mac80211_detach(struct rsi_hw *adapter)
> +{
> +	struct ieee80211_hw *hw = adapter->hw;
> +
> +	if (hw) {
> +		ieee80211_stop_queues(hw);
> +		ieee80211_unregister_hw(hw);
> +		ieee80211_free_hw(hw);
> +	}
> +
> +#ifdef CONFIG_RSI_DEBUGFS
> +	rsi_remove_dbgfs(adapter);
> +#endif

Typically, you'd call this unconditionally and have the header file for
it provide a static inline that does nothing with the ifdef, to reduce
ifdefs in the code.

> +	return;
> +}

more naked returns

> +static void rsi_mac80211_conf_filter(struct ieee80211_hw *hw,
> +				     u32 changed_flags,
> +				     u32 *total_flags,
> +				     u64 multicast)
> +{
> +	*total_flags &= FIF_FCSFAIL;
> +	changed_flags &= FIF_FCSFAIL;

That doesn't seem to be right?


> +	if ((key->cipher == WLAN_CIPHER_SUITE_WEP104) ||
> +	    (key->cipher == WLAN_CIPHER_SUITE_WEP40)) {
> +		status = rsi_hal_load_key(adapter->priv,
> +					  key->key,
> +					  key->keylen,
> +					  RSI_PAIRWISE_KEY,
> +					  key->keyidx,
> +					  key->cipher);
> +	}


> +	return rsi_hal_load_key(adapter->priv,
> +				key->key,
> +				key->keylen,
> +				key_type,
> +				key->keyidx,
> +				key->cipher);

You really need to load WEP keys twice? And you want to ignore the
status?

> +static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
> +				enum set_key_cmd cmd,
> +				struct ieee80211_vif *vif,
> +				struct ieee80211_sta *sta,
> +				struct ieee80211_key_conf *key)
> +{
> +	struct rsi_hw *adapter = hw->priv;
> +	struct rsi_common *common = adapter->priv;
> +	struct security_info *secinfo = &common->secinfo;
> +	int status = 0;

Like many other places, you shouldn't initialize variables if it's not
needed - that way the compiler will warn you if you don't actually init
them in some path. Particularly if you init them to "success" rather
than an error.

> +/**
> + * This function selects the AMPDU action for the corresponding
> + * mlme_action flag and informs the f/w regarding this.
> + *
> + * @param  hw Pointer to the ieee80211_hw structure.

None of this is valid kernel-doc by the way, so you should probably go
through all of those things and fix them. See the kernel-doc nano howto
and other files in Documentation/

Btw, git am also complains about whitespace damage in some patches.

johannes

