Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2FTOW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:22:58 -0400
Message-ID: <1340202172.4655.70.camel@jlt3.sipsolutions.net> (sfid-20120620_162301_588027_293CA5E8)
Subject: Re: [RFC] {cfg,nl,mac}80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jun 2012 16:22:52 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3A1E@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3A1E@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +struct ieee80211_vht_capabilities {
> +	__le32 vht_capabilities_info;
> +	u8 vht_supported_mcs_set[8];

should have some define for that 8

> +} __attribute__((packed));

__packed

> +struct ieee80211_vht_operation {
> +	u8 vht_operation_information_chwidth;
> +	u8 vht_operation_information_chan_center_freq1;
> +	u8 vht_operation_information_chan_center_freq2;

That doesn't seem right? how can a center freq fit into a u8?

> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +					u32 cap);

Please fix indentation.
 
> +	if (sband->vht_cap.vht_supported)
> +		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
> +						sband->vht_cap.cap);

ditto

There's some calculation about scan IE length somewhere -- I think that
needs to be adjusted? Or are you not using the info yet?

johannes

