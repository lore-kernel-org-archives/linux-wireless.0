Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34584 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdBWK0I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 05:26:08 -0500
Received: by mail-qt0-f180.google.com with SMTP id n21so24760497qta.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 02:26:08 -0800 (PST)
Subject: Re: [RFC v2 1/2] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221144335.GA17601@w1.fi> <1487688369.15350.3.camel@sipsolutions.net>
 <1487688447.15350.4.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <70536003-75fb-102d-00e0-6ccd0fe559cc@broadcom.com> (sfid-20170223_112612_126835_BECA6A12)
Date: Thu, 23 Feb 2017 10:56:17 +0100
MIME-Version: 1.0
In-Reply-To: <1487688447.15350.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 15:47, Johannes Berg wrote:
> 
>> The .len verifies that it's at least that long. We're thus ignoring
>> additional bytes in the PSK case if they're present, which I suppose
>> we should fix by checking the exact length in the code separately.
>>

libnl seems to have the notion of min_len and max_len in its policy
definition, but the kernel does not so .len is actually min_len indeed.

> IOW, I'll add this:
> 
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -8044,6 +8044,8 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
>  		if (!wiphy_ext_feature_isset(&rdev->wiphy,
>  					     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK))
>  			return -EINVAL;
> +		if (nla_len(info->attrs[NL80211_ATTR_PMK]) != WLAN_PMK_LEN)
> +			return -EINVAL;

Makes sense.

Regards,
Arend

>  		settings->psk = nla_data(info->attrs[NL80211_ATTR_PMK]);
>  	}
>  
> 
> johannes
> 
