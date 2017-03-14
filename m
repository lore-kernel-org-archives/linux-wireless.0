Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39636 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbdCNOCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:02:00 -0400
Message-ID: <1489500117.10872.7.camel@sipsolutions.net> (sfid-20170314_150318_693953_2BEB284C)
Subject: Re: [RFC v2] cfg80211: Add support for FILS shared key
 authentication offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Date: Tue, 14 Mar 2017 15:01:57 +0100
In-Reply-To: <1489054141-7848-1-git-send-email-jouni@qca.qualcomm.com>
References: <1489054141-7848-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	/* 802.11ai */
> +	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 108,
> +	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 109,

Not sure I see much value in that comment there, but whatever :)

>   * caching.
>   *
>   * @bssid: The AP's BSSID.
> - * @pmkid: The PMK material itself.
> + * @pmkid: The identifer to refer a PMKSA.

typo - identifier

> + * @pmk: The PMK for the PMKSA identified by @pmkid. This is used
> for key
> + *	derivation by a FILS STA. Otherwise, %NULL.
> + * @pmk_len: Length of the @pmk. The length of @pmk can differ
> depending on
> + *	the hash algorithm used to generate this.
> + * @ssid: SSID to specify the ESS within which a PMKSA is valid.
> + * @ssid_len: Length of the @ssid in octets.
> + * @cache_id: Unsigned 16 bit identifier advertized by an AP
> identifying the
> + *	scope of PMKSA. This is valid only if @ssid_len is non-
> zero.
>   */
>  struct cfg80211_pmksa {
>  	const u8 *bssid;
>  	const u8 *pmkid;
> +	const u8 *pmk;
> +	size_t pmk_len;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	u16 cache_id;
>  };

So I'm really still a bit confused by this.

For 802.1X, we decided that using the PMKSA cache to convey the PMK
from the host to the device (after doing the handshake) was a bad idea.

Can you explain why this is different for FILS?

Or wait - I'll attempt myself. In this case, it really *is* a cache,
since the firmware will be able to use any of them?

>  /**
> + * struct cfg80211_connect_resp_params - Connection response params

I like this, but I think it'd be good to split it out into a separate
patch.

> +struct cfg80211_connect_resp_params {
> +	int status;
> +	u8 bssid[ETH_ALEN];

Is there a reason for this to be the value rather than a pointer? I'm
not really sure it actually matters, but the fields below are pointers
too (and kinda have to be) so why the difference?

(Ok, so on 64-bit systems this is smaller, but it's actually easier to
assign a pointer than to memcpy())

>  /**
> + * DOC: FILS shared key authentication offload

Thanks :)

johannes
