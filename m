Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:41652
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab2FTOmQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:42:16 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] {cfg,nl,mac}80211: 802.11ac changes
Date: Wed, 20 Jun 2012 14:42:16 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3A6D@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120620_164219_978358_46037DB7)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3A1E@mbx022-e1-nj-10.exch022.domain.local>,<1340202172.4655.70.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340202172.4655.70.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Wednesday, June 20, 2012 7:52 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [RFC] {cfg,nl,mac}80211: 802.11ac changes

> +struct ieee80211_vht_capabilities {
> +     __le32 vht_capabilities_info;
> +     u8 vht_supported_mcs_set[8];

should have some define for that 8

[MP] Ok. 

> +} __attribute__((packed));

__packed

[MP] ok.

> +struct ieee80211_vht_operation {
> +     u8 vht_operation_information_chwidth;
> +     u8 vht_operation_information_chan_center_freq1;
> +     u8 vht_operation_information_chan_center_freq2;

That doesn't seem right? how can a center freq fit into a u8?

[MP] Its not center freq. Its center freq segment 1 and segment 2. I will change the names.

> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +                                     u32 cap);

Please fix indentation.

[MP] ok.
> +     if (sband->vht_cap.vht_supported)
> +             pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
> +                                             sband->vht_cap.cap);

ditto

There's some calculation about scan IE length somewhere -- I think that
needs to be adjusted? Or are you not using the info yet?

[MP] I will check that. I am using it. I tested my change and probe req comes out with VHT cap IE.

johannes

