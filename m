Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2JISih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:38:37 -0400
Message-ID: <1349807952.4683.12.camel@jlt4.sipsolutions.net> (sfid-20121009_203842_844738_2CC2BF06)
Subject: Re: [RFC] mac80211: make powersave independent of interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Oct 2012 20:39:12 +0200
In-Reply-To: <1349719669-11503-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1349719669-11503-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-08 at 11:07 -0700, Marco Porsch wrote:
> This patch prepares mac80211 for a later implementation of mesh or ad-hoc
> powersave.

I think you should mention "powersave clients" in the subject, rather
than just "powersave", since that could also mean "as a client"

> The structures related to powersave (buffer, TIM map, counters) are moved
> from the AP-specific interface structure to a generic structure that can
> be embedded into any interface type.
> The functions related to powersave are prepared to allow easy extension
> with different interface types. For example with:
> 
> + } else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
> +			ps = &sdata->u.mesh.ps;
> 
> 
> Some references to the AP's beacon structure are removed where they were
> obviously not used. Other occurrences are in ieee80211_get_buffered_bc
> where I am not sure if they make any sense or not. Should they be removed
> too?

That might be stale since the dtim counter moved out of the beacon
structure again? Somebody pointed this out to me before, maybe even you?

> Does it make any sense to test for NL80211_IFTYPE_AP and
> NL80211_IFTYPE_AP_VLAN everytime?

Not sure how you mean that?



>  	if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
> -		BUG_ON(!sdata->bss);
> +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
> +		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
> +			BUG_ON(!sdata->bss);

might be a good time to remove the BUG_ON usage now, or as a follow-up
patch

>  	/*
>  	 * broadcast/multicast frame
>  	 *
> -	 * If any of the associated stations is in power save mode,
> +	 * If any of the neighbor stations is in power save mode,

I'd prefer to be more generic here or list the options, "neighbor" is a
mesh-only term.

> @@ -2651,29 +2659,37 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
>  	struct sk_buff *skb = NULL;
>  	struct ieee80211_tx_data tx;
>  	struct ieee80211_sub_if_data *sdata;
> -	struct ieee80211_if_ap *bss = NULL;
> -	struct beacon_data *beacon;
> +	struct ps_data *ps;
>  	struct ieee80211_tx_info *info;
>  
>  	sdata = vif_to_sdata(vif);
> -	bss = &sdata->u.ap;
>  
>  	rcu_read_lock();
> -	beacon = rcu_dereference(bss->beacon);
>  
> -	if (sdata->vif.type != NL80211_IFTYPE_AP || !beacon || !beacon->head)
> +	if (sdata->vif.type == NL80211_IFTYPE_AP) {
> +		struct beacon_data *beacon =
> +				rcu_dereference(sdata->u.ap.beacon);
> +
> +		/* XXX is there any use for beacon here? */
> +
> +		if (!beacon || !beacon->head)
> +			goto out;

Checking to return NULL, apparently, if no beacons are active? If you
can say that's always true (list empty) then it could be removed, I
suspect it is going to be removed properly so this might not be relevant
(any more).

Looks good.

johannes

