Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:45687 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab3LESuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:50:02 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Luciano Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH v8 5/5] mac80211: only set CSA beacon when at least one beacon must be transmitted
Date: Thu, 5 Dec 2013 19:49:58 +0100
Cc: linux-wireless@vger.kernel.org, yeohchunyeow@gmail.com,
	yeohchunyeow@cozybit.com, andrei.otcheretianski@intel.com
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com> <1386257143-29840-6-git-send-email-luciano.coelho@intel.com>
In-Reply-To: <1386257143-29840-6-git-send-email-luciano.coelho@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312051949.58777.sw@simonwunderlich.de> (sfid-20131205_195007_995817_6B87881E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Luca,

let me add first that there is another locking regression introduced by my 
latest fixes for the IBSS mode. I'll send a fix in a minute, please include it 
when you test/rebase.

Appearently there are a few locking problems in your patch too (do you have a 
chance to test it, somehow?), see comments inline:

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2982,21 +2982,19 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data
> *beacon) return new_beacon;
>  }
> 
> -void ieee80211_csa_finalize_work(struct work_struct *work)
> +void ieee80211_csa_finish(struct ieee80211_vif *vif)
>  {
> -	struct ieee80211_sub_if_data *sdata =
> -		container_of(work, struct ieee80211_sub_if_data,
> -			     csa_finalize_work);
> -	struct ieee80211_local *local = sdata->local;
> -	int err, changed = 0;
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> 
> -	sdata_lock(sdata);
> -	/* AP might have been stopped while waiting for the lock. */
> -	if (!sdata->vif.csa_active)
> -		goto unlock;
> +	ieee80211_queue_work(&sdata->local->hw,
> +			     &sdata->csa_finalize_work);
> +}
> +EXPORT_SYMBOL(ieee80211_csa_finish);
> 
> -	if (!ieee80211_sdata_running(sdata))
> -		goto unlock;
> +static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	int err, changed = 0;
> 
>  	sdata->radar_required = sdata->csa_radar_required;
>  	err = ieee80211_vif_change_channel(sdata, &changed);

This hunk is a little hard to understand, but at least in the resulting file I 
have here, csa_finalize() does sdata_unlock but never locks it. Lockdep 
complains about locking imbalance, and actually that's true ...

> @@ -3048,6 +3046,29 @@ unlock:
>  	sdata_unlock(sdata);
>  }
> 
> +void ieee80211_csa_finalize_work(struct work_struct *work)
> +{
> +	struct ieee80211_sub_if_data *sdata =
> +		container_of(work, struct ieee80211_sub_if_data,
> +			     csa_finalize_work);
> +
> +	sdata_lock(sdata);
> +	/* AP might have been stopped while waiting for the lock. */
> +	if (!sdata->vif.csa_active)
> +		goto unlock;
> +
> +	if (!ieee80211_sdata_running(sdata))
> +		goto unlock;
> +
> +	if (!ieee80211_sdata_running(sdata))
> +		return;

Why are you checking the same thing twice? The second time without unlocking, 
that's unsafe too ...

> +
> +	ieee80211_csa_finalize(sdata);
> +
> +unlock:
> +	sdata_unlock(sdata);
> +}
> +
>  int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>  			     struct cfg80211_csa_settings *params)
>  {

Cheers,
    Simon
