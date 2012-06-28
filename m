Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2F1LHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:07:32 -0400
Message-ID: <1340881646.4491.41.camel@jlt3.sipsolutions.net> (sfid-20120628_130736_212484_A5231B00)
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 13:07:26 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok I applied some of the changes (see mac80211-next tree), but not the
mac80211 pieces. Please fix:


> +	if (supp_vht)
> +		local->scan_ies_len += 2 + sizeof(struct ieee80211_vht_capabilities);

too long line

>  
> +	if (sband->vht_cap.vht_supported)
> +		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
> +						sband->vht_cap.cap);

indentation

>  	return pos - buffer;
>  }
>  
> @@ -1696,6 +1700,27 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>  	return pos;
>  }
>  
> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +			      u32 cap)

indentation here & in ieee80211_i.h

> +	__le32 tmp;
> +
> +	*pos++ = WLAN_EID_VHT_CAPABILITY;
> +	*pos++ = sizeof(struct ieee80211_vht_capabilities);
> +	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
> +
> +	/* capability flags */
> +	tmp = cpu_to_le16(cap);
> +	memcpy(pos, &tmp, sizeof(u32));
> +	pos += sizeof(u32);
> +
> +	/* VHT MCS set */
> +	memcpy(pos, &vht_cap->vht_mcs, sizeof(vht_cap->vht_mcs));
> +	pos += sizeof(vht_cap->vht_mcs);
> +

endian issues

johannes

