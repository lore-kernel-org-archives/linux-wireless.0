Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3FRPAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:00:42 -0400
Message-ID: <1371567628.8318.43.camel@jlt4.sipsolutions.net> (sfid-20130618_170051_745296_FE347AA5)
Subject: Re: [PATCHv2 4/5] mac80211: add channel switch command and beacon
 callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 17:00:28 +0200
In-Reply-To: <1371212124-26264-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-14 at 14:15 +0200, Simon Wunderlich wrote:

> + * @channel_switch_beacon: Starts a channel switch for the to a new channel.

for the ?

> + *	Beacons are modified to include CSA or ECSA IEs before calling this
> + *	function. The corresponding count fields in these IEs must be
> + *	decremented, and when they reach zero the driver must call
> + *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
> + *	get the csa counter decremented by mac80211, but must check if it is
> + *	zero using ieee80211_csa_is_complete() and then call
> + *	ieee80211_csa_finish().

... when the beacon was transmitted, or something like that, right?

> @@ -2818,6 +2830,8 @@ struct ieee80211_ops {
>  				 struct ieee80211_vif *vif,
>  				 struct inet6_dev *idev);
>  #endif
> +	void (*channel_switch_beacon)(struct ieee80211_hw *hw,
> +				      struct ieee80211_vif *vif);

What about channel contexts? Actually I don't really understand this?
Shouldn't it say which channel to switch to?

>  /**
> + * ieee80211_csa_finish - notify mac80211 about channel switch
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + *
> + * After a channel switch announcement was scheduled and the counter in this
> + * announcement hit zero, this function must be called by the driver to
> + * notify mac80211 that the channel can be changed.
> + */
> +void ieee80211_csa_finish(struct ieee80211_vif *vif);

If there are multiple interfaces, should it be called multiple times?
etc. Maybe it should be on a channel context instead?

> +/**
> + * ieee80211_csa_is_complete - find out if counters reached zero
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + *
> + * This function checks the registered beacon if the counters reached zero.
> + */
> +int ieee80211_csa_is_complete(struct ieee80211_vif *vif);

Huh? Return value? Maybe it should be bool?

> +	netif_carrier_off(sdata->dev);
> +	err = ieee80211_vif_use_channel(sdata, &local->csa_chandef,
> +					IEEE80211_CHANCTX_SHARED);
> +	netif_carrier_on(sdata->dev);

That seems like a really bad idea, deleting a channel context might tear
down all kinds of device state and might require deleting the interface
first ... I think the chan context API needs to be extended to switch
instead.

> +	if (WARN_ON(err < 0))
> +		return;

This can fail _easily_ too, e.g. if some other vif stays on the channel
and you're now using too many channel contexts.

> +	/* don't handle if chanctx is used */
> +	if (local->use_chanctx)
> +		return -EBUSY;

Still don't really like the way you've implemented it :-)

> +	rcu_read_lock();
> +	mutex_lock(&local->chanctx_mtx);

Yeah right.

> +static inline void
> +drv_channel_switch_beacon(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	if (local->ops->channel_switch_beacon) {

blank line between these two please

> +		trace_drv_channel_switch_beacon(sdata);
> +		local->ops->channel_switch_beacon(&local->hw, &sdata->vif);
> +	}
> +}
> +
> +

steal one from here ;-)

>  void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
> +/* channel switch handling */

I'd prefer a blank line before the comment

> +TRACE_EVENT(drv_channel_switch_beacon,
> +	TP_PROTO(struct ieee80211_sub_if_data *sdata),

Use local_sdata_evt I think.

> +void ieee80211_csa_finish(struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = NULL;
> +	sdata = vif_to_sdata(vif);

ahem.

> +	vif->csa_active = 0;

is that a counter, or should it be a bool?

> +static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
> +				 struct beacon_data *beacon)
> +{
> +	struct probe_resp *resp;
> +	int counter_beacon = sdata->csa_counter_offset_beacon;
> +	int counter_presp = sdata->csa_counter_offset_presp;
> +
> +	if (WARN_ON(counter_beacon > beacon->tail_len))
> +		return;
> +
> +	if (WARN_ON(((u8 *)beacon->tail)[counter_beacon] == 0))
> +		return;

How can these happen?

> +	((u8 *)beacon->tail)[counter_beacon]--;
> +
> +	if (counter_presp && sdata->vif.type == NL80211_IFTYPE_AP) {
> +		resp = rcu_dereference(sdata->u.ap.probe_resp);

Who guarantees RCU protection?

> +		if (WARN_ON(!resp))
> +			return;

That can legimitately happen, no? At least userspace is allowed to not
set probe_resp now, if you want to change that ...

> +		if (WARN_ON(counter_presp > resp->len))
> +			return;

?
I guess counter_presp should be called "counter_offset_presp" or so

> +		((u8 *)resp->data)[counter_presp]--;

resp->data is already a u8 *, no?


> +int ieee80211_csa_is_complete(struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct beacon_data *beacon = NULL;
> +	int counter_beacon = sdata->csa_counter_offset_beacon;
> +
> +	if (!sdata || !ieee80211_sdata_running(sdata))
> +		return 0;

yeah right ... container_of returned NULL?

> +	if (vif->type == NL80211_IFTYPE_AP) {
> +		struct ieee80211_if_ap *ap = &sdata->u.ap;
> +		beacon = rcu_dereference(ap->beacon);
> +

swap those last two lines :)

johannes

