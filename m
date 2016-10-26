Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51616 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932550AbcJZMLb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 08:11:31 -0400
Message-ID: <1477483882.4059.34.camel@sipsolutions.net> (sfid-20161026_141151_790102_432FBAB1)
Subject: Re: [PATCH] cfg80211: add key management offload feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
        Jouni Malinen <j@w1.fi>
Cc: yangzy@marvell.com, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
Date: Wed, 26 Oct 2016 14:11:22 +0200
In-Reply-To: <1474973796-1873-1-git-send-email-akarwar@marvell.com> (sfid-20160927_125737_815734_5AE7ADB1)
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
         (sfid-20160927_125737_815734_5AE7ADB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Getting back to this ... as I was preparing my patch.

> @@ -3687,6 +3692,9 @@ enum nl80211_key_attributes {
>  	NL80211_KEY_DEFAULT_MGMT,
>  	NL80211_KEY_TYPE,
>  	NL80211_KEY_DEFAULT_TYPES,
> +	NL80211_KEY_REPLAY_CTR,
> +	NL80211_KEY_KCK,
> +	NL80211_KEY_KEK,

You made those key attributes, but ...
 
>  	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len,
> resp_ie)))
>  		goto nla_put_failure;
>  
> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
> +				    NL80211_EXT_FEATURE_KEY_MGMT_OFF
> LOAD) &&
> +	    (nla_put_u8(msg, NL80211_ATTR_AUTHORIZED, authorized) ||
> +	    (key_replay_ctr && nla_put(msg, NL80211_KEY_REPLAY_CTR,
> +	     NL80211_REPLAY_CTR_LEN, key_replay_ctr)) ||
> +	    (key_kck &&
> +	     nla_put(msg, NL80211_KEY_KCK, NL80211_KCK_LEN,
> key_kck)) ||
> +	    (key_kek &&
> +	     nla_put(msg, NL80211_KEY_KEK, NL80211_KEK_LEN,
> key_kek))))
> +		goto nla_put_failure;

Used them at a top level here! That can't possibly have worked.

Anyway, I checked and we can transport these without adding new
attributes, but adding the NL80211_ATTR_REKEY_DATA attribute with its
nested KEK, KCK and REPLAY_CTR.

That leaves the authorized attribute, I guess nesting a whole bunch of
station info etc. doesn't make a lot of sense.

I also fail to see how the data is actually configured down, since you
just pass it through. I'll send our patch for configuring the PMK/PSK
via the PMKSA cache separately in a few minutes.

johannes
