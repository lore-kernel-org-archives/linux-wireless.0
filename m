Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982Ab1GOJyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:54:32 -0400
Subject: Re: [PATCH 1/5] mac80211: give if_mesh a beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-2-git-send-email-thomas@cozybit.com> (sfid-20110714_014631_631390_BB120B5C)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014631_631390_BB120B5C)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:54:29 +0200
Message-ID: <1310723669.4164.18.camel@jlt3.sipsolutions.net> (sfid-20110715_115436_363664_CF81CE0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:

> +	if (ieee80211_vif_is_mesh(&sdata->vif))
> +		rcu_assign_pointer(sdata->u.mesh.beacon, new);

I don't think this compiles if MESH isn't configured into mac80211. Not
sure adding lots of ifdefs is good, but it's probably the only choice
right now.

> @@ -461,6 +462,9 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>  	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_mgmt *bcn_head;
> +	struct beacon_parameters bcn_params;
> +	u8 *pos;
>  
>  	local->fif_other_bss++;
>  	/* mesh ifaces must set allmulti to forward mcast traffic */
> @@ -473,7 +477,44 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>  	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
>  	ieee80211_mesh_root_setup(ifmsh);
>  	ieee80211_queue_work(&local->hw, &sdata->work);
> +
> +	/* Build fixed part of mesh beacon. */
> +	memset(&bcn_params, 0, sizeof(struct beacon_parameters));
> +
> +	/* header + fixed fields + null ssid */
> +	bcn_params.head_len = 24 + sizeof(bcn_head->u.beacon) + 2;
> +	pos = kmalloc(bcn_params.head_len, GFP_KERNEL | __GFP_ZERO);

Err, kzalloc, don't use __GFP_ZERO.

> +	if (mac80211_config_ops.add_beacon(sdata->wdev.wiphy, sdata->dev,
> +				&bcn_params))
> +		printk(KERN_ERR "Unable to configure mesh beacon\n");

That's horrible. Don't do that. Just do whatever is necessary inline. If
you restructure, you only need like 10% of the code from
ieee80211_config_beacon() anyway.

> @@ -498,6 +540,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	 * it no longer is.
>  	 */
>  	cancel_work_sync(&sdata->work);
> +	if (sdata->u.mesh.beacon)
> +		mac80211_config_ops.del_beacon(sdata->wdev.wiphy, sdata->dev);

Ditto.

>  	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
> -		struct ieee80211_mgmt *mgmt;
> -		u8 *pos;
> -
> +		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>  #ifdef CONFIG_MAC80211_MESH
>  		if (!sdata->u.mesh.mesh_id_len)
>  			goto out;
>  #endif
> +		beacon = rcu_dereference(ifmsh->beacon);

not going to compile w/o CONFIG_MAC80211_MESH

> +		if (beacon) {
> +			/* headroom, head length, tail length, mesh_ies and
> +			 * maximum TIM length */
> +			skb = dev_alloc_skb(local->tx_headroom +
> +					    beacon->head_len +
> +					    beacon->tail_len + 400);

what's + 400? You can't really think the TIM IE is that long?

> -		/* headroom, head length, tail length and maximum TIM length */
> -		skb = dev_alloc_skb(local->tx_headroom + 400 +
> -				sdata->u.mesh.ie_len);

I guess it was even there before though ... huh?

Couldn't more code here be shared between mesh and AP? I don't see any
difference here between mesh and AP.

Also ... since you'll need PS support eventually anyway, maybe you
should refactor "struct ieee80211_if_ap" into something AP-specific
(currently only VLANs) and the rest, and then use "the rest" in mesh as
well to make all this code more unified.

johannes

