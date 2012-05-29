Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2E2Gox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 02:44:53 -0400
Message-ID: <1338273896.4342.4.camel@jlt3.sipsolutions.net> (sfid-20120529_084456_829739_E026F50C)
Subject: Re: [PATCH v2] mac80211: add op to configure default key id
From: Johannes Berg <johannes@sipsolutions.net>
To: Yoni Divinsky <yoni.divinsky@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2012 08:44:56 +0200
In-Reply-To: <1337872512-28678-1-git-send-email-yoni.divinsky@ti.com>
References: <1337872512-28678-1-git-send-email-yoni.divinsky@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-24 at 18:15 +0300, Yoni Divinsky wrote:

> @@ -2370,6 +2373,8 @@ struct ieee80211_ops {
>  	void	(*get_et_strings)(struct ieee80211_hw *hw,
>  				  struct ieee80211_vif *vif,
>  				  u32 sset, u8 *data);
> +	int (*set_default_key_idx)(struct ieee80211_hw *hw,
> +				    struct ieee80211_vif *vif, int idx);

You allow this to fail

> @@ -309,9 +309,8 @@ static int ieee80211_config_default_key(struct wiphy *wiphy,
>  {
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  
> -	ieee80211_set_default_key(sdata, key_idx, uni, multi);
> +	return ieee80211_set_default_key(sdata, key_idx, uni, multi);

and propagate failures to userspace

> +int ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
>  			       bool uni, bool multi)
>  {
> +	int ret = 0;
>  	mutex_lock(&sdata->local->key_mtx);
>  	__ieee80211_set_default_key(sdata, idx, uni, multi);
> +	if (uni)
> +		ret = drv_set_default_unicast_key(sdata->local, sdata, idx);
>  	mutex_unlock(&sdata->local->key_mtx);
> +	return ret;

Yet, if it fails, you have still updated the key in mac80211 itself!!

I suspect it should simply not be allowed to fail. The key is already
guaranteed to be there, and if the device previously rejected uploading
the key then it shouldn't be allowed to care at this point.

johannes

