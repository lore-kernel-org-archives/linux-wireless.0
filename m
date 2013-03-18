Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3CRUWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 16:22:03 -0400
Message-ID: <1363638107.8260.24.camel@jlt4.sipsolutions.net> (sfid-20130318_212209_151640_2D364E9A)
Subject: Re: [RFC 3/3] mac80211: P2P add NOA settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Janusz.Dziedzic@tieto.com, linux-wireless@vger.kernel.org
Date: Mon, 18 Mar 2013 21:21:47 +0100
In-Reply-To: <CAFED-jmGRNFDHBvZQV=t7ETQa=yk4bZMjt1N8KckKweDLZE3uA@mail.gmail.com> (sfid-20130317_092700_698543_F05D2142)
References: <3078A9B976EF864C8DDD0C499FFD07912FA1693F2A@EXMB01.eu.tieto.com>
	 <1363361717.8656.18.camel@jlt4.sipsolutions.net>
	 <CAFED-jmGRNFDHBvZQV=t7ETQa=yk4bZMjt1N8KckKweDLZE3uA@mail.gmail.com>
	 (sfid-20130317_092700_698543_F05D2142)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -	u8 p2p_ctwindow;
> -	bool p2p_oppps;
> +	struct ieee80211_p2p_noa_attr p2p_noa_attr;

Shouldn't you also remove sdata.u.mgd.p2p_noa_index? Actually, maybe
not, since that needs to be -1 in some cases, so n/m.

> -	if (params->p2p_opp_ps >= 0) {
> -		sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
> +	if (params->p2p_opp_ps > 0) {
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |= BIT(8);
> +		changed |= BSS_CHANGED_P2P_PS;
> +	} else if (params->p2p_opp_ps == 0) {
> +		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow &= ~BIT(8);
>  		changed |= BSS_CHANGED_P2P_PS;

BIT(8) can't be right -- you mean 7?

Maybe also time to introduce a constant for this so drivers can use it
as well?

>  	if (sdata->vif.p2p) {
> -		struct ieee80211_p2p_noa_attr noa;
>  		int ret;
> -
> +		struct ieee80211_p2p_noa_attr noa = {};
> +		/* We have to handle here such cases:
> +		   - p2p_attr disapear

got catch, I guess I never noticed that -- also typo ("disappears" or
"disappeared")

wrong comment style though

> +		/* We can memcmp() here in case will find broken GO */
> +		if (sdata->u.mgd.p2p_noa_index != noa.index) {
>  			sdata->u.mgd.p2p_noa_index = noa.index;
> +			memcpy(&bss_conf->p2p_noa_attr, &noa, sizeof(noa));
> +			changed |= BSS_CHANGED_P2P_PS;
>  			/*
>  			 * make sure we update all information, the CRC
>  			 * mechanism doesn't look at P2P attributes.
>  			 */
>  			ifmgd->beacon_crc_valid = false;
>  		}
> +
> +		/* Or different handling:
> +
> +		// Version 2:

Are you asking me to pick version? I guess the first one above doesn't
handle the disappearance case very well?

> +		int ret;
> +		struct ieee80211_p2p_noa_attr noa = {};
> +		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
> +					    len - baselen,
> +					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
> +					    (u8 *) &noa, 2);

why 2 now?

> +		if (ret <= 0) {
> +			if (sdata->u.mgd.p2p_noa_index) {
> +				// NOA attr disapear
> +				sdata->u.mgd.p2p_noa_index = 0;
> +				memset(&bss_conf->p2p_noa_attr, 0,
> +				       sizeof(bss_conf->p2p_noa_attr));
> +				changed |= BSS_CHANGED_P2P_PS;
> +				ifmgd->beacon_crc_valid = false;
> +			}
> +		} else if (sdata->u.mgd.p2p_noa_index != noa.index) {
> +			// NOA changed, noa desc(s) could disapear
> +			memset(&bss_conf->p2p_noa_attr, 0,
> +			       sizeof(bss_conf->p2p_noa_attr);
> +			ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
> +						    len - baselen,
> +						    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
> +						    (u8 *) &bss_conf->p2p_noa_attr,
> +						    sizeof(bss_conf->p2p_noa_attr));

I don't see why you'd want to retrieve it twice? It will only copy as
much as is present and return the data length.

> +		// Version 3:
> +		int ret;
> +		memset(&bss_conf->p2p_noa_attr, 0, sizeof(bss_conf->p2p_noa_attr));
> +		ret = cfg80211_get_p2p_attr(mgmt->u.beacon.variable,
> +					    len - baselen,
> +					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
> +					    (u8 *) &bss_conf->p2p_noa_attr,
> +					    sizeof(bss_conf->p2p_noa_attr));
> +		if (sdata->u.mgd.p2p_noa_index != noa.index) {
> +			sdata->u.mgd.p2p_noa_index = noa.index;
> +			changed |= BSS_CHANGED_P2P_PS;
> +			ifmgd->beacon_crc_valid = false;
> +		}

Here you didn't check "ret", so the "disappeared entirely" case isn't
handled?

Seems like it should be like this:

ret = get_p2p_attr(...)
if (sdata->u.mgd.p2p_noa_index != noa.index || !ret) {
  if (ret)
    p2p_noa_index = noa.index
  else
    p2p_noa_index = -1;
  changed |= ...
  crc_valid = false;
}

to handle all the cases, including dis- and reappearance?

johannes

