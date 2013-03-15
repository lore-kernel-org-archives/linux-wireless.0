Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3CPM5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:00 -0400
Message-ID: <1363361717.8656.18.camel@jlt4.sipsolutions.net> (sfid-20130316_135703_463587_8DBA7D11)
Subject: Re: [RFC 3/3] mac80211: P2P add NOA settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz.Dziedzic@tieto.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
References: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:35:17 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-14 at 09:33 +0200, Janusz.Dziedzic@tieto.com wrote:
> Add P2P NOA settings for STA mode.

First two patches are fine, here I have some concerns.

> +/* struct p2p_noa_desc - holds Notice of Absence parameters
> + *

This isn't valid kernel-doc.

> +struct p2p_noa_desc {

However, in any case, I'd rather you remove this struct.

> +	struct p2p_noa_desc p2p_noa_desc[IEEE80211_P2P_NOA_DESC_MAX];

and use ieee80211_p2p_noa_desc here

> +static u8 ieee80211_setup_noa_attr(struct ieee80211_bss_conf *bss_conf,
> +				   struct ieee80211_p2p_noa_attr *noa)

indentation is wrong, but you'll get rid of the function anyway :-)

> +		bss_conf->p2p_noa_desc[i].duration =
> +				le32_to_cpu(noa->desc[i].duration);

I don't see any need to do endian conversion here in mac80211 -- the
driver can do it. Most drivers won't need it anyway, so this is just
extra code/time spent.

> -			struct ieee80211_p2p_noa_attr noa;
> +			struct ieee80211_p2p_noa_attr noa = {0};

Please just use = {}. Although ... see below

> @@ -2953,18 +2976,17 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  	}
>  
>  	if (sdata->vif.p2p) {
> -		struct ieee80211_p2p_noa_attr noa;
> +		struct ieee80211_p2p_noa_attr noa = {0};
>  		int ret;
>  
>  		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
>  					    len - baselen,
>  					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
>  					    (u8 *) &noa, sizeof(noa));
> -		if (ret >= 2 && sdata->u.mgd.p2p_noa_index != noa.index) {
> -			bss_conf->p2p_oppps = noa.oppps_ctwindow & 0x80;
> -			bss_conf->p2p_ctwindow = noa.oppps_ctwindow & 0x7f;
> +		if (sdata->u.mgd.p2p_noa_index != noa.index) {
> +			sdata->u.mgd.p2p_noa_index =
> +					ieee80211_setup_noa_attr(bss_conf, &noa);
>  			changed |= BSS_CHANGED_P2P_PS;
> -			sdata->u.mgd.p2p_noa_index = noa.index;

Now that we pretty much have *all* fields of the NoA attribute in
bss_conf (except the index), why not just put the full struct there, and
have cfg80211 read into that buffer directly? That way, we save all the
copying. Yes, it would mean changing all the drivers (just one I guess)
using it, but maybe that'd be better?

Or do we expect broken GOs that change the contents w/o updating the
index, and then things break or something?

johanes

