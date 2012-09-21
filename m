Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752413Ab2IUMhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 08:37:43 -0400
Message-ID: <1348231086.4160.5.camel@jlt4.sipsolutions.net> (sfid-20120921_143746_949248_9BBA83C3)
Subject: Re: [PATCH] mac80211: Peer STA VHT cap
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 21 Sep 2012 14:38:06 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF4FFB@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF4FFB@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-21 at 08:45 +0000, Mahesh Palivela wrote:

> +/**
> + * struct ieee80211_vht_operation - VHT operation IE

kernel-doc should have member descriptions

> +void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
> +					 struct ieee80211_supported_band *sband,
> +					 struct ieee80211_vht_cap *vht_cap_ie,
> +					 struct ieee80211_sta_vht_cap *vht_cap)
> +{
> +	BUG_ON(!vht_cap);

Please don't use BUG_ON(), maybe "if (WARN_ON_ONCE(...)) return;"?

> +	/*
> +	 * The bits listed in this expression should be
> +	 * the same for the peer and us, if the station
> +	 * advertises more then we can't use those thus
> +	 * we mask them out.
> +	 */
> +	vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info) & 
> +		       sband->vht_cap.cap;

There are no bits listed in this expression? :)

Also, I'm sure that not all bits are symmetric, e.g. beamformer and
beamformee are asymmetric.

johannes

