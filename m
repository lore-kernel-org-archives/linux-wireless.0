Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2FUOp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:45:56 -0400
Message-ID: <1340289952.4489.29.camel@jlt3.sipsolutions.net> (sfid-20120621_164559_698715_E5F52B3F)
Subject: Re: [RFC v2] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 21 Jun 2012 16:45:52 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3B74@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3B74@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 05:13 +0000, Mahesh Palivela wrote:

> +/**
> + * struct ieee80211_vht_mcs_info - VHT MCS information
> + * @rx_mask: RX mask
> + * @rx_highest: highest supported RX rate. If set represents
> + *	the highest supported RX data rate in units of 1 Mbps.
> + *	If this field is 0 this value should not be used to
> + *	consider the highest RX data rate supported.
> + * @tx_params: TX parameters

those don't seem to match below -- rx_mcs_map, tx_mcs_map and tx_highest
should be there?

> +struct ieee80211_vht_mcs_info {
> +	__le16 rx_mcs_map;
> +	__le16 rx_highest;
> +	__le16 tx_mcs_map;
> +	__le16 tx_highest;
> +} __packed;


> +	if (supp_vht)
> +		local->scan_ies_len += 2 + sizeof(struct ieee80211_vht_capabilities);

that line looks a bit long, but yeah, this is what I was thinking of
before :-)

johannes

