Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab2FUSOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:14:36 -0400
Message-ID: <1340302471.4489.43.camel@jlt3.sipsolutions.net> (sfid-20120621_201439_839883_E765BE18)
Subject: Re: [RFC v3] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 21 Jun 2012 20:14:31 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CE8@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CE8@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 16:51 +0000, Mahesh Palivela wrote:

> +/* 802.11ac VHT Capabilities */
> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454               0x00000002

I have a feeling there should be a value for 3895, since this isn't
really a bitfield only (it doesn't make sense to set both of these, in
fact 3 is reserved)

> +#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ              0x00000004
> +#define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ     0x00000008

same here, you might otherwise be tempted to set both?


> +       u8 vht_supported_mcs_set[VHT_MCS_SUPPORTED_SET_SIZE];

might make sense to break that down further into RX/TX etc?

johannes

