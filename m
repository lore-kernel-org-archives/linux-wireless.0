Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3AaOn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:43:58 -0500
Message-ID: <1359643448.8415.62.camel@jlt4.sipsolutions.net> (sfid-20130131_154401_499674_84F87162)
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 31 Jan 2013 15:44:08 +0100
In-Reply-To: <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:

> +void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
> +				    struct ieee80211_chanctx *chanctx)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	bool radar_enabled = false;
> +
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		if (sdata->radar_required)
> +			radar_enabled = true;

I guess you could break here. Technically though I'm not sure this is
right, since it should only iterate interfaces on this chanctx. OTOH,
multiple channel contexts aren't (currently?) allowed anyway.

> +	chanctx->conf.radar_enabled = radar_enabled;
> +	local->radar_detect_enabled = chanctx->conf.radar_enabled;

What's the reason for "local->radar_detect_enabled"?

Btw, do we also make the driver responsible for turning off any
powersave when radar detection is enabled? I guess so?

> @@ -817,6 +817,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  
>  	cancel_work_sync(&sdata->recalc_smps);
>  
> +	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
> +
> +	/* only inform about abort cac if it was started before. */
> +	if (sdata->wdev.cac_started) {

I'm not entirely sure we should use the wdev data here, OTOH it seems
safe, so why not.

> +void ieee80211_dfs_cac_timer_work(struct work_struct *work)
> +{
> +	struct delayed_work *delayed_work =
> +		container_of(work, struct delayed_work, work);
> +	struct ieee80211_sub_if_data *sdata =
> +		container_of(delayed_work, struct ieee80211_sub_if_data,
> +			     dfs_cac_timer_work);
> +
> +	rtnl_lock();

what part requires rtnl?

> +void ieee80211_radar_detected(struct ieee80211_vif *vif, gfp_t gfp)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +
> +	trace_api_radar_detected(sdata);
> +
> +	/* may happen to devices which have been added but are not up */
> +	if (!cfg80211_chandef_valid(&sdata->vif.bss_conf.chandef))
> +		return;

Huh, what does device and up have to do with that?

>  static bool ieee80211_can_scan(struct ieee80211_local *local,
>  			       struct ieee80211_sub_if_data *sdata)
>  {
> +	if (local->radar_detect_enabled)
> +		return false;

Oh, ok. I guess that explains the reason for radar_detect_enabled :)

johannes

