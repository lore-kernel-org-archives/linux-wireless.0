Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35003 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbcCHIHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 03:07:35 -0500
Message-ID: <1457424451.2283.2.camel@sipsolutions.net> (sfid-20160308_090745_649335_5A9FD37E)
Subject: Re: [RFC v1] mac80211: Add support for per station rx stats
 histogram
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
	mohammed@codeaurora.org, Anilkumar Kolli <akolli@qti.qualcomm.com>
Date: Tue, 08 Mar 2016 09:07:31 +0100
In-Reply-To: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-03-07 at 21:53 +0530, Mohammed Shafi Shajakhan wrote:
> 
> +#define IEEE80211_HT_MCS_NUM		32
> +#define IEEE80211_VHT_MCS_NUM		10
> +#define IEEE80211_BW_NUM		4
> +#define IEEE80211_NSS_NUM		4
> +#define IEEE80211_GI_NUM		2
> +#define IEEE80211_RATE_TABLE_NUM	320
> +#define IEEE80211_LEGACY_RATE_NUM	12

> +#ifdef CONFIG_MAC80211_DEBUG_PER_STA_RX_STATS
> +	u64 rx_legacy_pkt[IEEE80211_LEGACY_RATE_NUM];
> +	u64 rx_ht_pkt[IEEE80211_HT_MCS_NUM];
> +	u64 rx_vht_pkt[IEEE80211_VHT_MCS_NUM];
> +	u64 rx_bw_pkt[IEEE80211_BW_NUM];
> +	u64 rx_nss_pkt[IEEE80211_NSS_NUM];
> +	u64 rx_gi_pkt[IEEE80211_GI_NUM];
> +	u64 rx_rate_pkt[IEEE80211_RATE_TABLE_NUM];
> +	u64 rx_legacy_byte[IEEE80211_LEGACY_RATE_NUM];
> +	u64 rx_ht_byte[IEEE80211_HT_MCS_NUM];
> +	u64 rx_vht_byte[IEEE80211_VHT_MCS_NUM];
> +	u64 rx_bw_byte[IEEE80211_BW_NUM];
> +	u64 rx_nss_byte[IEEE80211_NSS_NUM];
> +	u64 rx_gi_byte[IEEE80211_GI_NUM];
> +	u64 rx_rate_byte[IEEE80211_RATE_TABLE_NUM];
> +#endif

Do you know how much data this is?!

Felix is going to kill both of us if I apply it.

Please look at reviving my rate-statistics patch and do the remaining
work in userspace:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/133172

johannes
