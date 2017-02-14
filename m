Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43404 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752370AbdBNNGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:06:21 -0500
Message-ID: <1487077574.4705.13.camel@sipsolutions.net> (sfid-20170214_140755_352422_5DEE350B)
Subject: Re: [RFC 3/4] ieee80211: add new VHT capability fields/parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com
Date: Tue, 14 Feb 2017 14:06:14 +0100
In-Reply-To: <20170214112827.28216-3-johannes@sipsolutions.net> (sfid-20170214_123003_071861_B32E46B9)
References: <20170214112827.28216-1-johannes@sipsolutions.net>
         <20170214112827.28216-3-johannes@sipsolutions.net>
         (sfid-20170214_123003_071861_B32E46B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static inline int ieee80211_get_vht_max_nss(struct ieee80211_vht_cap
> *cap,
> +					    enum
> ieee80211_vht_chanwidth bw)
> +{
> +	unsigned long w;
> +	int max_vht_nss;
> +	int ext_nss_bw;
> +	int supp_width;
> +
> +	if (cap->supp_mcs.rx_mcs_map == 0xffff)
> +		return 0;

Apart from the various endian issues, this function is completely wrong
because the max_vht_nss is per MCS (at least 0-7, 8 and 9 separately),
which this can't take into account.

Also, the only code that would use this right now, in mac80211,
probably won't use the same types as the parameters were to this
function.

I want to preserve the strange table somewhere in a single place, but
not sure yet how to do that best.

johannes
