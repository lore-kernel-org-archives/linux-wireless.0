Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab3BTOvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:51:06 -0500
Message-ID: <1361371850.8629.24.camel@jlt4.sipsolutions.net> (sfid-20130220_155110_881378_44924EAF)
Subject: Re: [PATCHv2 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org
Date: Wed, 20 Feb 2013 15:50:50 +0100
In-Reply-To: <1361203709-16669-1-git-send-email-marco@cozybit.com> (sfid-20130218_170844_711843_DDA91A7F)
References: <1361203709-16669-1-git-send-email-marco@cozybit.com>
	 (sfid-20130218_170844_711843_DDA91A7F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 17:08 +0100, Marco Porsch wrote:

> +	/*
> +	 * If available, calculate the time the beacon timestamp field was
> +	 * received from the rx_status->mactime field. Otherwise get the
> +	 * current TSF as approximation before entering rcu-read section.
> +	 */
> +	if (ieee80211_have_rx_timestamp(rx_status))
> +		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> +						       24 + 12 +
> +						       elems->total_len +
> +						       FCS_LEN,
> +						       24);

That doesn't seem right -- it's calculating the timestamp at the end of
the frame, but you said you wanted the timestamp at the "timestamp
field" time, which is just 24 bytes into the frame.

> +static void mesh_sync_offset_rx_bcn(struct sta_info *sta,
> +				    struct ieee80211_mgmt *mgmt,
> +				    struct ieee802_11_elems *elems,
> +				    u64 t_r)
>  {
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
>  	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> -	struct ieee80211_local *local = sdata->local;
> -	struct sta_info *sta;
> -	u64 t_t, t_r;
> +	u64 t_t;
>  
>  	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
>  
>  	/* standard mentions only beacons */
> -	if (stype != IEEE80211_STYPE_BEACON)
> +	if (!ieee80211_is_beacon(mgmt->frame_control))
>  		return;

This is a bit odd -- why should a function that's called _rx_bcn() have
to check it? Seems the check should be outside the API boundary.
 

> -	if (ieee80211_have_rx_timestamp(rx_status))
> -		/* time when timestamp field was received */
> -		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> -						       24 + 12 +
> -						       elems->total_len +
> -						       FCS_LEN,
> -						       24);

I see this was already wrong ...

johannes

