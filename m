Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1LGNqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:46:50 -0500
Subject: Re: [PATCH V2 1/2] cfg80211: Define a wrapper function for
 reporting roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 14:46:44 +0100
Message-ID: <1323265604.3404.37.camel@jlt3.sipsolutions.net> (sfid-20111207_144653_599548_579B42BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 19:12 +0530, Vasanthakumar Thiagarajan wrote:

>  /**
> + * cfg80211_roamed_bss - notify cfg80211 of roaming
> + *
> + * @dev: network device
> + * @bss: entry of bss to which STA got roamed (may be %NULL)

I think you should check that it isn't, that's an implementation thing
of __cfg80211_roamed() I think? Semantically, I don't think this should
happen here?

It would also be good to note that the reference to the bss is given to
the function and it will be released by it.

> +void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
> +			 struct ieee80211_channel *channel,
> +			 const u8 *bssid, const u8 *req_ie, size_t req_ie_len,
> +			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
> +{
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
>  	struct cfg80211_event *ev;


Hmm, now that I think about it more, I think the calling convention is
really strange. Why pass the channel and bssid when the BSS struct is
already known?

Why not make cfg80211_roamed() do the BSS lookup (which would also
reduce the race for drivers that don't use _bss()) based on the info,
and then call a cfg80211_roamed_bss() that doesn't get channel/bssid.

johannes

