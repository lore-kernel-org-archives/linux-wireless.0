Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:10843
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526Ab2FUQzz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 12:55:55 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2] cfg80211/mac80211: 802.11ac changes
Date: Thu, 21 Jun 2012 16:55:54 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CF9@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120621_185559_118962_6E541DE4)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3B74@mbx022-e1-nj-10.exch022.domain.local>,<1340289952.4489.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340289952.4489.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Thursday, June 21, 2012 8:15 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] cfg80211/mac80211: 802.11ac changes

On Thu, 2012-06-21 at 05:13 +0000, Mahesh Palivela wrote:

> +/**
> + * struct ieee80211_vht_mcs_info - VHT MCS information
> + * @rx_mask: RX mask
> + * @rx_highest: highest supported RX rate. If set represents
> + *   the highest supported RX data rate in units of 1 Mbps.
> + *   If this field is 0 this value should not be used to
> + *   consider the highest RX data rate supported.
> + * @tx_params: TX parameters

those don't seem to match below -- rx_mcs_map, tx_mcs_map and tx_highest
should be there?

[MP] Yes. I missed it. Just sent another patch with correct comments.

> +struct ieee80211_vht_mcs_info {
> +     __le16 rx_mcs_map;
> +     __le16 rx_highest;
> +     __le16 tx_mcs_map;
> +     __le16 tx_highest;
> +} __packed;


> +     if (supp_vht)
> +             local->scan_ies_len += 2 + sizeof(struct ieee80211_vht_capabilities);

that line looks a bit long, but yeah, this is what I was thinking of
before :-)

[MP] Yes. I didn't know that.

johannes

