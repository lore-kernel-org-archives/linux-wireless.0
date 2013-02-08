Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946100Ab3BHJUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:20:39 -0500
Message-ID: <1360315234.29851.15.camel@jlt4.sipsolutions.net> (sfid-20130208_102045_573707_4AA04B78)
Subject: Re: [RFCv2 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 08 Feb 2013 10:20:34 +0100
In-Reply-To: <1360151325-6368-3-git-send-email-marco@cozybit.com> (sfid-20130206_124915_323291_448699F4)
References: <1360151325-6368-1-git-send-email-marco@cozybit.com>
	 <1360151325-6368-3-git-send-email-marco@cozybit.com>
	 (sfid-20130206_124915_323291_448699F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 12:48 +0100, Marco Porsch wrote:

> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
> a timer which triggers a doze call on expiry.

That seems questionable -- drivers are not required to request each
beacon. I know you only want to make it work on ath9k, but I don't think
"stretching" the API, without even documenting it, is a good idea.

> +static inline void mps_queue_work(struct ieee80211_sub_if_data *sdata,
> +				  enum mesh_deferred_task_flags flag)
> +{
> +	set_bit(flag, &sdata->u.mesh.wrkq_flags);
> +	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
> +}

Doing any sort of wakeup from here is also undesirable -- the workqueue
might actually sometimes be blocked for quite a while, I believe.

> +/**
> + * ieee80211_mps_hw_conf - check conditions for mesh PS and configure driver
> + *
> + * @sdata: local mesh subif
> + */
> +void ieee80211_mps_hw_conf(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	bool enable;
> +
> +	enable = mps_hw_conf_check(local);
> +
> +	if (local->mps_enabled == enable)
> +		return;
> +
> +	if (enable) {
> +		mps_hw_conf_sta_prepare(local);
> +		local->hw.conf.flags |= IEEE80211_CONF_PS;
> +	} else {
> +		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
> +	}
> +
> +	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);

For some reason I thought this was supposed to be covered by the new
mesh PS callbacks, why do you still need hw conf?

Or wait -- this is only for general enable/disable, depending on the
other interfaces? I guess that's ok.

> +	/* simple Deep Sleep implementation: only wake up for DTIM beacons */
> +	if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
> +		skip = tim->dtim_count ? tim->dtim_count : tim->dtim_period;
> +	/*
> +	 * determine time to peer TBTT (TSF % beacon_interval = 0).
> +	 * This approach is robust to delayed beacons.
> +	 */
> +	tsf_peer = tsf_local + sta->t_offset;
> +	nexttbtt_interval = sta->beacon_interval * skip -
> +			do_div(tsf_peer, sta->beacon_interval * skip);
> +
> +	mps_dbg(sta->sdata, "updating %pM next TBTT in %dus (%lldus awake)\n",
> +		sta->sta.addr, nexttbtt_interval,
> +		(long long) tsf_local - sta->nexttbtt_tsf);
> +
> +	sta->nexttbtt_tsf = tsf_local + nexttbtt_interval;
> +	sta->nexttbtt_jiffies = jiffies + usecs_to_jiffies(nexttbtt_interval);
> +
> +	mod_timer(&sta->nexttbtt_timer, sta->nexttbtt_jiffies +
> +			usecs_to_jiffies(BEACON_TIMEOUT));

Is that some sort of recovery? jiffies can be up to 20ms (I think, in
that order of magnitude anyway) inaccurate.

johannes

