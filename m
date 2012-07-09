Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2GIJWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:22:11 -0400
Message-ID: <1341825724.4455.16.camel@jlt3.sipsolutions.net> (sfid-20120709_112215_578936_AEBF3808)
Subject: Re: [PATCH] nl/cfg/mac80211: use BIT(x) instead of (1 << x)
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 11:22:04 +0200
In-Reply-To: <1341763805-7386-1-git-send-email-ordex@autistici.org>
References: <1341763805-7386-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1432,7 +1432,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  		struct ieee80211_supported_band *sband;
>  		sband = local->hw.wiphy->bands[i];
>  		sdata->rc_rateidx_mask[i] =
> -			sband ? (1 << sband->n_bitrates) - 1 : 0;
> +			sband ? BIT(sband->n_bitrates) - 1 : 0;

I don't like the BIT()-1 pattern, "(1 << x) - 1" seems like a more
regular pattern. Arguably, there should be a define for it, but I can't
seem to come up with a good name.

>  	/* This should be adjusted for each device */
> -	int device_constant = 1 << ARITH_SHIFT;
> +	int device_constant = BIT(ARITH_SHIFT);
>  	int test_frame_len = TEST_FRAME_LEN << ARITH_SHIFT;
> -	int s_unit = 1 << ARITH_SHIFT;
> +	int s_unit = BIT(ARITH_SHIFT);

similarly, I don't think this makes sense. Yes, it's the same code, but
this whole shift arithmetic is easier to understand when you don't use
BIT() I think, in particular since you can't replace things like
TEST_FRAME_LEN << ARITH_SHIFT and the code is less regular now.

> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -84,7 +84,7 @@ static struct mesh_table *mesh_table_alloc(int size_order)
>  		return NULL;
>  
>  	newtbl->hash_buckets = kzalloc(sizeof(struct hlist_head) *
> -			(1 << size_order), GFP_ATOMIC);
> +			BIT(size_order), GFP_ATOMIC);

again here, the 1<<size_order isn't meant as BIT(), it's meant as a
size, so 1<< makes more sense.

> +++ b/net/mac80211/mlme.c
> @@ -168,7 +168,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
>  
>  static int ecw2cw(int ecw)
>  {
> -	return (1 << ecw) - 1;
> +	return BIT(ecw) - 1;

This is also not bit operations but calculations.

> @@ -463,7 +463,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
>  	mask = sdata->rc_rateidx_mask[info->band];
>  	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
>  	       sizeof(mcs_mask));
> -	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
> +	if (mask != BIT(txrc->sband->n_bitrates) - 1) {

again that mask thing ... I prefer the 1<< in this case, unless you want
to come up with a #define and submit it for linux/bitmap.h :)


>  /* Exponential averaging smoothness (used for I part of PID controller) */
>  #define RC_PID_SMOOTHING_SHIFT		3
> -#define RC_PID_SMOOTHING		(1 << RC_PID_SMOOTHING_SHIFT)
> +#define RC_PID_SMOOTHING		BIT(RC_PID_SMOOTHING_SHIFT)

Calculations again ...


>  		rthdr->it_present |=
> -			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
> +			cpu_to_le32(BIT(IEEE80211_RADIOTAP_TSFT));

This makes sense, of course, it's actually doing bitwise operations.

johannes

