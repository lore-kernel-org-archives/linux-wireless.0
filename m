Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3BKVR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:17:56 -0500
Message-ID: <1360617458.8738.41.camel@jlt4.sipsolutions.net> (sfid-20130211_221801_949251_6CCE9F8A)
Subject: Re: [PATCH 2/3] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 11 Feb 2013 22:17:38 +0100
In-Reply-To: <1360616843-24618-2-git-send-email-thomas@cozybit.com> (sfid-20130211_220848_749593_827CA205)
References: <1360616843-24618-1-git-send-email-thomas@cozybit.com>
	 <1360616843-24618-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130211_220848_749593_827CA205)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 13:07 -0800, Thomas Pedersen wrote:

> +static int
> +ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
> +{
> +	struct beacon_data *bcn;
> +	int head_len, tail_len;
> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +	struct ieee80211_chanctx_conf *chanctx_conf;
> +	enum ieee80211_band band;
> +	u8 *pos;
> +	struct ieee80211_sub_if_data *sdata;
> +	int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
> +		      sizeof(mgmt->u.beacon);
> +
> +	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> +	rcu_read_lock();

This is weird since you already did it outside the function?

> +	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +	band = chanctx_conf->def.chan->band;

could be NULL? I guess not at this point though.

> +static int
> +ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	struct beacon_data *old_bcn;
> +	int ret;
> +	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> +
> +	rcu_read_lock();
> +	old_bcn = rcu_dereference(ifmsh->beacon);
> +	ret = ieee80211_mesh_build_beacon(ifmsh);

This looks totally wrong. You must protect the assignment to
ifmsg->beacon by some lock, so then you don't need the rcu_read_lock()
here since you're under that lock, so this should be
rcu_dereference_protected(..., lockdep_is_held(whatever_lock));

> +	if (sdata->vif.bss_conf.enable_beacon &&
> +	    (changed & (BSS_CHANGED_BEACON |
> +			BSS_CHANGED_HT |
> +			BSS_CHANGED_BASIC_RATES |
> +			BSS_CHANGED_BEACON_INT)))
> +		if (ieee80211_mesh_rebuild_beacon(&sdata->u.mesh))
> +			return;

Does that return make any sense?

>  	changed |= ieee80211_mps_local_status_update(sdata);
>  
> +	if (WARN_ON(ieee80211_mesh_build_beacon(ifmsh))) {

no warning for memory allocation failures please

> @@ -694,6 +833,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	sdata->vif.bss_conf.enable_beacon = false;
>  	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
>  	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
> +	kfree_rcu(ifmsh->beacon, rcu_head);

I think you should set it to NULL first, just so it's clearer.
 
> @@ -883,6 +1023,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
>  	skb_queue_head_init(&ifmsh->ps.bc_buf);
>  	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
>  	spin_lock_init(&ifmsh->sync_offset_lock);
> +	RCU_INIT_POINTER(ifmsh->beacon, NULL);

Isn't everything initialized to 0/null?

johannes

