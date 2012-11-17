Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab2KQJZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:25:38 -0500
Message-ID: <1353144370.9543.29.camel@jlt4.sipsolutions.net> (sfid-20121117_102542_639597_3FA7B9B3)
Subject: Re: [RFC 09/14] mac80211: add power save support structure to mesh
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 10:26:10 +0100
In-Reply-To: <1353134886-13256-10-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-10-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:

>  #ifdef CONFIG_MAC80211_MESH
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index bc3e3e1..8396602 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -769,6 +769,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  		/* free all potentially still buffered bcast frames */
>  		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
>  		skb_queue_purge(&sdata->u.ap.ps.bc_buf);
> +	} else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
> +		local->total_ps_buffered -= skb_queue_len(&sdata->u.mesh.ps.bc_buf);
> +		skb_queue_purge(&sdata->u.mesh.ps.bc_buf);
>  	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>  		ieee80211_mgd_stop(sdata);
>  	}

This will not apply, and is in the wrong place anyway.

> +	/* reset in case we have been in a mesh with PS peers before */

should amend the comment to say "and leak all the frames that might be
on the queue now.

> +	} else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
> +		ps = &sta->sdata->u.mesh.ps;
> +		/* TIM map only for AID <= IEEE80211_MAX_AID */

AID? Seems more like PLID to me:

> +		id = le16_to_cpu(sta->plid) % IEEE80211_MAX_AID;

> -	/* This is only necessary for stations on BSS interfaces */
> -	if (!sta->sdata->bss)
> +	/* This is only necessary for stations on BSS/MBSS interfaces */
> +	if (!sta->sdata->bss &&
> +	    !ieee80211_vif_is_mesh(&sta->sdata->vif))
>  		return false;

Instead of cluttering all the code paths like this, what if we changed

struct ieee80211_if_ap *sdata->bss

to

struct ps_data *sdata->ps


If we know the interface type is AP/AP_VLAN, we can still get the AP
sdata from that pointer:
	container_of(sdata->ps, struct ieee80211_sub_if_sdata, u.ap.ps);

This is only in a few places, and might keep all the RX/TX code simpler?
 
> +++ b/net/mac80211/tx.c
> @@ -329,6 +329,8 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
>  
>  		if (sdata->vif.type == NL80211_IFTYPE_AP)
>  			ps = &sdata->u.ap.ps;
> +		else if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
> +			ps = &sdata->u.mesh.ps;

This could just be "ps = sdata->ps" etc.

johannes

