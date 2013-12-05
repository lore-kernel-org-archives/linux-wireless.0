Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:43368 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3LEPUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:20:54 -0500
Message-ID: <1386256850.3878.19.camel@porter.coelho.fi> (sfid-20131205_162057_177143_115F568A)
Subject: Re: [PATCH v7 5/5] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, yeohchunyeow@gmail.com,
	yeohchunyeow@cozybit.com
Date: Thu, 05 Dec 2013 17:20:50 +0200
In-Reply-To: <1386256044-8651-6-git-send-email-luciano.coelho@intel.com>
References: <1386256044-8651-1-git-send-email-luciano.coelho@intel.com>
	 <1386256044-8651-6-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:07 +0200, Luciano Coelho wrote:
> @@ -2982,21 +2982,19 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
>  	return new_beacon;
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
> @@ -3048,6 +3046,29 @@ unlock:
>  	sdata_unlock(sdata);
>  }

Hrmmmhh... This unlock should not be here anymore.  I missed it when
rebasing.

v8 coming soon!

--
Luca.

