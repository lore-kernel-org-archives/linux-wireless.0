Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39729 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbcHBHp1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 03:45:27 -0400
Message-ID: <1470123822.2665.9.camel@sipsolutions.net> (sfid-20160802_094531_131695_6A44DF51)
Subject: Re: [PATCH] nl80211: Expand max value of NL80211_MESHCONF_HT_OPMODE
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Tue, 02 Aug 2016 09:43:42 +0200
In-Reply-To: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com> (sfid-20160719_132611_386606_D9F41C4A)
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160719_132611_386606_D9F41C4A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-07-19 at 20:25 +0900, Masashi Honma wrote:
> Previously, the max value of NL80211_MESHCONF_HT_OPMODE was 16.
> But it causes EINVAL when IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED
> and IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT bit is enabled.
> So this patch expands the max value.
> 
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
> ---
>  net/wireless/nl80211.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 46417f9..8a00e50 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5471,7 +5471,10 @@ do {						
> 			    \
>  	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, -255, 0,
>  				  mask,
> NL80211_MESHCONF_RSSI_THRESHOLD,
>  				  nl80211_check_s32);
> -	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0,
> +				  IEEE80211_HT_OP_MODE_PROTECTION |
> +				  IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
> +				  IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT,
>  				  mask, NL80211_MESHCONF_HT_OPMODE,
>  				  nl80211_check_u16);
> 
Hmm. So first of all, it looks like the old value was wrong because 16
would have been an allowed value, which doesn't make sense - 15 was
likely the maximum that should've been allowed?

You're now changing it to 23, which makes some sense, but is kinda
strange. It allows setting the unused bit 0x8 by itself or in
combination with any protection and/or the NON_GF bit, but not in
combination with the NON_HT bit.

It seems that perhaps this should rather check the value against a
bitmap of allowed bits, which would be exactly the ones you add in this
patch?

johannes
