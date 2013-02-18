Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f169.google.com ([209.85.213.169]:56086 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3BRRYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 12:24:13 -0500
Received: by mail-ye0-f169.google.com with SMTP id l13so1057511yen.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 09:24:12 -0800 (PST)
Message-ID: <512263B9.3000402@lwfinger.net> (sfid-20130218_182419_821783_45207BE9)
Date: Mon, 18 Feb 2013 11:24:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, j@w1.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] cfg80211: fix station change if TDLS isn't supported
References: <51207925.5040702@lwfinger.net> <1361196149-10731-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1361196149-10731-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 08:02 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Larry noticed (and bisected) that commit df881293c6ba9a12868491a717b25
> "cfg80211: Pass TDLS peer's QoS/HT/VHT information during set_station"
> broke secure connections. This is is the case only for drivers that
> don't support TDLS, where any kind of change, even just the change of
> authorized flag that is required for normal operation, was rejected
> now. To fix this, remove the checks. I have some patches that will add
> proper verification for all the different cases later.
>
> Cc: Jouni Malinen <j@w1.fi>
> Bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Johannes,

Thanks. This patch does fix the problem. The only thing I saw was an unused 
variable:

net/wireless/nl80211.c: In function ‘nl80211_set_station_tdls’:
net/wireless/nl80211.c:3421:37: warning: unused variable ‘rdev’ [-Wunused-variable]

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> ---
>   net/wireless/nl80211.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 580ffea..d86af75 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3423,14 +3423,6 @@ static int nl80211_set_station_tdls(struct genl_info *info,
>   	struct nlattr *nla;
>   	int err;
>
> -	/* Can only set if TDLS ... */
> -	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS))
> -		return -EOPNOTSUPP;
> -
> -	/* ... with external setup is supported */
> -	if (!(rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
> -		return -EOPNOTSUPP;
> -
>   	/* Dummy STA entry gets updated once the peer capabilities are known */
>   	if (info->attrs[NL80211_ATTR_HT_CAPABILITY])
>   		params->ht_capa =
>

