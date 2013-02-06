Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3BFRdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:33:15 -0500
Message-ID: <1360172015.7910.51.camel@jlt4.sipsolutions.net> (sfid-20130206_183318_982520_6F84379F)
Subject: Re: [PATCHv8 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 06 Feb 2013 18:33:35 +0100
In-Reply-To: <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359982200-2321-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:

>   *
>   * @channel: the channel to tune to
>   * @channel_type: the channel (HT) type
> + * @radar_enabled: whether radar detection is enabled on this channel

There's only one channel for ieee80211_conf ;-)

>  /**
> + * ieee80211_radar_detected - inform a configured connection that
> + * radar was detected on the current channel
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + * @gfp: context flags.
> + */
> +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp);

Given the way this works in cfg80211 and my comment there, it seems
pointless to report per vif, but rather should be per HW?

> +	res = ieee80211_vif_use_channel(sdata, chandef,
> +					IEEE80211_CHANCTX_SHARED);
> +	if (res)
> +		return -EBUSY;

return res? This really can't fail here (except for memory allocation
etc.) so -EBUSY is a bit odd.

> @@ -753,6 +753,9 @@ struct ieee80211_sub_if_data {
>  	int user_power_level; /* in dBm */
>  	int ap_power_level; /* in dBm */
>  
> +	bool radar_required;
> +	struct delayed_work dfs_cac_timer_work;

Does the work struct make sense here? It seems like an inherently global
operation, so should that be in ieee80211_local? We should check anyway
if radar detection is requested when it's already running, I guess.

> +++ b/net/mac80211/iface.c
> @@ -817,6 +817,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  
>  	cancel_work_sync(&sdata->recalc_smps);
>  
> +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);

OTOH, I guess if the interface is going away then you'd want to stop
radar detection if it was done for that interface, so in that sense it
makes sense per interface.

> @@ -1583,6 +1592,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  	spin_lock_init(&sdata->cleanup_stations_lock);
>  	INIT_LIST_HEAD(&sdata->cleanup_stations);
>  	INIT_WORK(&sdata->cleanup_stations_wk, ieee80211_cleanup_sdata_stas_wk);
> +	INIT_DELAYED_WORK(&sdata->dfs_cac_timer_work,
> +			  ieee80211_dfs_cac_timer_work);
> +

unneeded blank line

> +void ieee80211_dfs_cac_timer_work(struct work_struct *work)
> +{
> +	struct delayed_work *delayed_work =
> +		container_of(work, struct delayed_work, work);
> +	struct ieee80211_sub_if_data *sdata =
> +		container_of(delayed_work, struct ieee80211_sub_if_data,
> +			     dfs_cac_timer_work);
> +
> +	rtnl_lock();
> +	ieee80211_vif_release_channel(sdata);
> +	cfg80211_radar_event(sdata->dev, &sdata->vif.bss_conf.chandef,
> +			     NL80211_RADAR_CAC_FINISHED, GFP_KERNEL);
> +	rtnl_unlock();
> +}

Did you test your code with lockdep enabled? I'm almost certain using
rtnl_lock() isn't allowed on mac80211's workqueue.

> +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)

That "gfp" argument is misleading, ...

> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +
> +	trace_api_radar_detected(sdata);
> +
> +	/* may happen to devices which have currently no BSS configured */
> +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> +		return;
> +
> +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);

... since you do something that requires being able to sleep, hence the
only useful argument you could pass as gfp is GFP_KERNEL. However, not
being able to calls this from softirq or so is probably not desirable
for many drivers?

johannes

