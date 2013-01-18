Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3ARVSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 16:18:24 -0500
Message-ID: <1358543924.7922.22.camel@jlt4.sipsolutions.net> (sfid-20130118_221827_115017_6EF76D17)
Subject: Re: [PATCHv3] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 18 Jan 2013 22:18:44 +0100
In-Reply-To: <1358509570-31602-1-git-send-email-marco@cozybit.com> (sfid-20130118_124620_310760_705AD973)
References: <1358509570-31602-1-git-send-email-marco@cozybit.com>
	 (sfid-20130118_124620_310760_705AD973)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was going to apply this, but then I still had a few questions.

> +++ b/net/mac80211/mesh_ps.c
> @@ -0,0 +1,605 @@
> +/*
> + * Copyright 2012, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
> + * Copyright 2012, cozybit Inc.

First of all, do you want 2013 now maybe? Or 2012-2013 or something?

> +static void mpsp_qos_null_append(struct sta_info *sta,
> +				 struct sk_buff_head *frames)
> +{
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct sk_buff *new_skb, *skb = skb_peek_tail(frames);
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_tx_info *info;
> +
> +	if (ieee80211_is_data_qos(hdr->frame_control))
> +		return;
> +
> +	new_skb = mps_qos_null_get(sta);
> +	if (!new_skb)
> +		return;
> +
> +	mps_dbg(sdata, "appending QoS Null in MPSP towards %pM\n",
> +		sta->sta.addr);
> +
> +	/* should be transmitted last -> lowest priority */
> +	new_skb->priority = 1;
> +	skb_set_queue_mapping(new_skb, IEEE80211_AC_BK);

That comment might do with exanding a bit? Without more explanation,
transmission order doesn't really require BK -- except that this is done
after potentially releasing multiple frames on different ACs, so it has
to be BK to not pass any released BK frames. It's reasonable if you look
at the (only) caller though, so I'm not worried about it.

> +	/* prepare collected frames for transmission */
> +	skb_queue_walk(&frames, skb) {
> +		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +		struct ieee80211_hdr *hdr = (void *) skb->data;
> +
> +		/*
> +		 * Tell TX path to send this frame even though the
> +		 * STA may still remain is PS mode after this frame
> +		 * exchange.
> +		 */
> +		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
> +
> +		if (more_data || !skb_queue_is_last(&frames, skb))
> +			hdr->frame_control |=
> +				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
> +		else
> +			hdr->frame_control &=
> +				cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
> +
> +		if (skb_queue_is_last(&frames, skb) &&
> +		    ieee80211_is_data_qos(hdr->frame_control)) {
> +			u8 *qoshdr = ieee80211_get_qos_ctl(hdr);
> +
> +			/* MPSP trigger frame ends service period */
> +			*qoshdr |= IEEE80211_QOS_CTL_EOSP;
> +			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
> +		}
> +	}

Ultimately, this is where you should also call
drv_allow_buffered_frames() and/or driver_release_buffered_frames(). In
fact, the *driver* might be buffering frames, so that would be necessary
for proper A-MPDU operation etc. I can merge it anyway, but be aware
that it is not implementing the full API correctly, so once more drivers
get fixed to rely on that API (really is a fix, especially with A-MPDU)
you won't have much fun. But you said it doesn't really work with 11n
anyway, so ... :)

> @@ -997,6 +1006,8 @@ static void clear_sta_ps_flags(void *_sta)
>  	if (sdata->vif.type == NL80211_IFTYPE_AP ||
>  	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>  		ps = &sdata->bss->ps;
> +	else if (ieee80211_vif_is_mesh(&sdata->vif))
> +		ps = &sdata->u.mesh.ps;

Will this even compile with mesh turned off? It seems you should have a
helper for "&sdata->u.mesh.ps" or something, so you can have just a
single ifdef (you have a few places like this), maybe something like
this:


void *__force_mesh_link_error(void);

static inline struct ... ieee80211_get_mesh_ps(sdata)
{
#ifdef MESH
	return ...;
#else
	return __force_mesh_link_error();
#endif
}


> @@ -329,6 +329,8 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
>  
>  		if (sdata->vif.type == NL80211_IFTYPE_AP)
>  			ps = &sdata->u.ap.ps;
> +		else if (ieee80211_vif_is_mesh(&sdata->vif))
> +			ps = &sdata->u.mesh.ps;

For example here. I'd hate to see ifdefs in all those places.

>  				    2 + 3 + /* DS params */
> +				    256 + /* TIM IE */

If wonder if that should be 2 + 255? But I haven't looked up the TIM IE
format again now ...

johannes

