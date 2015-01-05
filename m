Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53234 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbbAEJ15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:27:57 -0500
Message-ID: <1420450070.1898.5.camel@sipsolutions.net> (sfid-20150105_102800_203161_502F2DCE)
Subject: Re: [PATCH 3.17 1/3] mac80211: add feature flag to enable resizing
 of outgoing frames for encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net, chrischavez@gmx.us, pizza@shaftnet.org,
	Ido Yariv <idox.yariv@intel.com>
Date: Mon, 05 Jan 2015 10:27:50 +0100
In-Reply-To: <2051417.66dkbc7KnO@debian64> (sfid-20141231_111942_701497_8196DC0E)
References: <2051417.66dkbc7KnO@debian64>
	 (sfid-20141231_111942_701497_8196DC0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3.17 is long gone :-)

> @@ -1673,7 +1680,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
>  	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
>  	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
> -	/* free slot */
> +	IEEE80211_HW_TAILROOM_CRYPTO			= 1<<16,

Why wouldn't this be a key flag?

I think I'll go and revert Ido's commit and mark that for Cc stable -
and then we/he can reintroduce the patch while also updating the two
drivers (p54 and cw2100) to include a new "need tailroom anyway" flag.

johannes

