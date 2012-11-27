Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:4331 "EHLO
	HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842Ab2K0MMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 07:12:31 -0500
Message-ID: <50B4AE29.3040600@posedge.com> (sfid-20121127_131234_827655_5A13CB34)
Date: Tue, 27 Nov 2012 17:42:25 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/3] mac80211: support VHT association
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net> <1353939915-25121-3-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1353939915-25121-3-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 07:55 PM, Johannes Berg wrote:
> +static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
> +				     struct cfg80211_bss *cbss)
> +{
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	const u8 *ht_cap_ie, *vht_cap_ie;
> +	const struct ieee80211_ht_cap *ht_cap;
> +	const struct ieee80211_vht_cap *vht_cap;
> +	u8 chains = 1;
> +
> +	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT)
> +		return chains;
> +
> +	ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
> +				     cbss->information_elements,
> +				     cbss->len_information_elements);
> +	if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap)) {
> +		ht_cap = (void *)(ht_cap_ie + 2);
> +		chains = ieee80211_mcs_to_chains(&ht_cap->mcs);
> +		/*
> +		 * TODO: use "Tx Maximum Number Spatial Streams Supported" and
> +		 *	 "Tx Unequal Modulation Supported" fields.
> +		 */
> +		
> +	}
> +
> +	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
> +		return chains;
> +
> +
> +	vht_cap_ie = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY,
> +				      cbss->information_elements,
> +				      cbss->len_information_elements);
> +	if (vht_cap_ie && vht_cap_ie[1] >= sizeof(*vht_cap)) {
> +		u8 nss;
> +		u16 tx_mcs_map;
> +
> +		vht_cap = (void *)(vht_cap_ie + 2);
> +		tx_mcs_map = le16_to_cpu(vht_cap->supp_mcs.tx_mcs_map);

Guess we should take rx_mcs_map as we are determining vht_rx_chains?

Thanks,
Mahesh
