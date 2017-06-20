Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33394 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdFTT71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:59:27 -0400
Message-ID: <1497988764.11421.1.camel@sipsolutions.net> (sfid-20170620_215930_391122_EF41CBCD)
Subject: Re: [PATCH 5/8] qtnfmac: enable reporting the current operating
 channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 20 Jun 2017 21:59:24 +0200
In-Reply-To: <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215610_767547_199205B9)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
         <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com>
         (sfid-20170620_215610_767547_199205B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-20 at 22:55 +0300, Sergey Matyukevich wrote:

> +	if (sme->channel) {
> +		/* FIXME: need to set proper nl80211_channel_type
> value */
> +		cfg80211_chandef_create(&chandef, sme->channel,
> +					NL80211_CHAN_HT20);
> +		/* fall-back to minimal safe chandef description */
> +		if (!cfg80211_chandef_valid(&chandef))
> +			cfg80211_chandef_create(&chandef, sme-
> >channel,
> +						NL80211_CHAN_HT20);
> 
This seems odd since you just do the same thing over again? Not that I
could see how it would be invalid anyway.

johannes
