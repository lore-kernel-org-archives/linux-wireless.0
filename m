Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:14737
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299Ab2F1Mje convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 08:39:34 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211/mac80211: 802.11ac changes
Date: Thu, 28 Jun 2012 12:39:33 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D612F@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120628_143938_618016_9A9198B3)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>,<1340881646.4491.41.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340881646.4491.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Thursday, June 28, 2012 4:37 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes

Ok I applied some of the changes (see mac80211-next tree), but not the
mac80211 pieces. Please fix:


> +     if (supp_vht)
> +             local->scan_ies_len += 2 + sizeof(struct ieee80211_vht_capabilities);

too long line

[MP] But within column 80. shall I break from sizeof?

>
> +     if (sband->vht_cap.vht_supported)
> +             pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
> +                                             sband->vht_cap.cap);

indentation

[MP] sorry. I didn't get. Is it sband-> line to be moved left? But previous build_ht_cap() has similar indentation

>       return pos - buffer;
>  }
>
> @@ -1696,6 +1700,27 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>       return pos;
>  }
>
> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +                           u32 cap)

indentation here & in ieee80211_i.h

[MP] ditto. please explain

> +     __le32 tmp;
> +
> +     *pos++ = WLAN_EID_VHT_CAPABILITY;
> +     *pos++ = sizeof(struct ieee80211_vht_capabilities);
> +     memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
> +
> +     /* capability flags */
> +     tmp = cpu_to_le16(cap);
> +     memcpy(pos, &tmp, sizeof(u32));
> +     pos += sizeof(u32);
> +
> +     /* VHT MCS set */
> +     memcpy(pos, &vht_cap->vht_mcs, sizeof(vht_cap->vht_mcs));
> +     pos += sizeof(vht_cap->vht_mcs);
> +

endian issues

[MP] I see mistake tmp = cpu_to_le16(cap) to be changed to tmp = cpu_to_le32(cap). MCS set is fine right?

johannes

