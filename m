Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3BDRgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:36:51 -0500
Message-ID: <1359999430.17993.19.camel@jlt4.sipsolutions.net> (sfid-20130204_183656_629511_E4708864)
Subject: Re: [PATCH 1/3] mac80211: cache mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Feb 2013 18:37:10 +0100
In-Reply-To: <1359853341-29237-2-git-send-email-thomas@cozybit.com> (sfid-20130203_020330_936748_686C8758)
References: <1359853341-29237-1-git-send-email-thomas@cozybit.com>
	 <1359853341-29237-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130203_020330_936748_686C8758)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


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
> +	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +	band = chanctx_conf->def.chan->band;
> +	rcu_read_unlock();
> +
> +	RCU_INIT_POINTER(ifmsh->beacon, NULL);
> +	synchronize_rcu();

That doesn't seem right? Why force to NULL and synchronize, instead of
just building an update and overwriting the old beacon with the new,
using kfree_rcu() to get rid of the old afterwards? synchronize_rcu() is
quite expensive (might take hundreds of milliseconds.)

Also, doesn't this just leak the old one?

> +	/* need an skb for IE builders to operate on */
> +	skb = dev_alloc_skb(max(head_len, tail_len));

Heh. Might consider changing the IE builder functions?

> +static int
> +ieee80211_mesh_rebuild_beacon(struct ieee80211_if_mesh *ifmsh)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	sdata = container_of(ifmsh, struct ieee80211_sub_if_data, u.mesh);
> +
> +	rcu_read_lock();
> +	kfree(rcu_dereference(ifmsh->beacon));
> +	rcu_read_unlock();
> +
> +	if (WARN_ON(ieee80211_mesh_build_beacon(ifmsh))) {

The warning is probably not a good idea since it's really for allocation
failures only which already print long messages.

> +		mpl_dbg(sdata, "couldn't rebuild mesh beacon, stopping!\n");
> +		ieee80211_stop_mesh(sdata);

I'm not sure that's such a good idea? Nothing in userspace would expect
to randomly stop the mesh.

> +		return -1;

Why not have a proper error code and propagate it properly? :)

johannes

