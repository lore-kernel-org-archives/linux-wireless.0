Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2JJI7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 04:59:01 -0400
Message-ID: <1349859575.4683.40.camel@jlt4.sipsolutions.net> (sfid-20121010_105906_448995_6333CDDE)
Subject: Re: [PATCH v4 2/2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Oct 2012 10:59:35 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB278@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB278@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
> +					 struct ieee80211_supported_band *sband,
> +					 struct ieee80211_vht_cap *vht_cap_ie,
> +					 struct ieee80211_sta_vht_cap *vht_cap)
> +{
> +	if (WARN_ON_ONCE(!vht_cap))
> +		return;
> +
> +	memset(vht_cap, 0, sizeof(*vht_cap));
> +
> +	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
> +		return;
> +
> +	vht_cap->vht_supported = true;
> +
> +	vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info);

This doesn't compile??

johannes

