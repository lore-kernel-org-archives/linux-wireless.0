Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IXI6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 04:58:40 -0400
Message-ID: <1348477154.10257.2.camel@jlt4.sipsolutions.net> (sfid-20120924_105845_325748_0A394419)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Mon, 24 Sep 2012 10:59:14 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-24 at 03:57 +0000, Mahesh Palivela wrote:
> From: Mahesh Palivela <maheshp@posedge.com>
> 
> To save peer STA VHT capabilities in mac80211.
> 
> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> ---
> Taken care of Johannes comments in patch v1


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
> +

Well I think it'd be better to actually restrict/copy/update the feature
bits correctly, this would simplify drivers.

johannes

