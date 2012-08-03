Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2HCGn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 02:43:59 -0400
Message-ID: <1343976236.4482.4.camel@jlt3.sipsolutions.net> (sfid-20120803_084405_774112_05EE7547)
Subject: Re: [PATCH 1/4] mac80211: leave mesh when stopping the netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 03 Aug 2012 08:43:56 +0200
In-Reply-To: <1343951274-24956-1-git-send-email-thomas@cozybit.com> (sfid-20120803_014803_594417_BCEC95E9)
References: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120803_014803_594417_BCEC95E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 16:47 -0700, Thomas Pedersen wrote:
> Previously, we would merely stop the beacon and fail to free any mesh
> specific data structures on netdev down or unregister. Split mesh
> beacon, data, timer, and work cancel steps into ieee80211_mesh_stop() to
> avoid decrementing the filter counters twice, and call this in the
> ndo_stop handler.

Now you're going overboard a bit :-)

This isn't needed, as cfg80211 will explicitly leave the mesh while the
netdev is going down (NETDEV_GOING_DOWN notification handler) without
mac80211 even knowing yet that it's be going down.

> +++ b/net/mac80211/iface.c
> @@ -689,6 +689,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		local->fif_probe_req--;
>  	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
>  		local->fif_probe_req--;
> +	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
> +		local->fif_other_bss--;

I think this may be wrong since it's only incremented when we join the
mesh, so it will cause the number to become negative if we never join
the mesh, or if we correctly leave it before going down (as we actually
do)

> @@ -733,6 +735,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
>  	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>  		ieee80211_mgd_stop(sdata);
> +	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
> +		ieee80211_mesh_stop(sdata);
>  	}

This isn't needed, since we already called stop_mesh from cfg.c via
cfg80211.

> @@ -771,14 +775,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		skb_queue_purge(&sdata->skb_queue);
>  
>  		/*
> -		 * Disable beaconing here for mesh only, AP and IBSS
> -		 * are already taken care of.
> -		 */
> -		if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
> -			ieee80211_bss_info_change_notify(sdata,
> -				BSS_CHANGED_BEACON_ENABLED);

This makes sense, it's already done anyway.


> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -611,14 +611,17 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>  						BSS_CHANGED_BEACON_INT);
>  }
>  
> -void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> +void ieee80211_mesh_stop(struct ieee80211_sub_if_data *sdata)
>  {
> -	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>  
> +	/* stop the beacon */
>  	ifmsh->mesh_id_len = 0;
>  	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
> -	sta_info_flush(local, NULL);
> +
> +	/* flush STAs and mpaths on this iface */
> +	sta_info_flush(sdata->local, sdata);
> +	mesh_path_flush_by_iface(sdata);
>  
>  	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
>  	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);

This also makes sense, of course.

> @@ -630,6 +633,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	 * it no longer is.
>  	 */
>  	cancel_work_sync(&sdata->work);
> +}
> +
> +void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +
> +	ieee80211_mesh_stop(sdata);
>  
>  	local->fif_other_bss--;
>  	atomic_dec(&local->iff_allmultis);

Ok so you're trying to split it up, but I don't think that makes sense
since we'll always call stop_mesh() before the interface goes down.

johannes

