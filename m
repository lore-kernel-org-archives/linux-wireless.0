Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36748 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932480AbcKVNM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 08:12:29 -0500
Received: by mail-qk0-f175.google.com with SMTP id n21so22663073qka.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 05:12:28 -0800 (PST)
Subject: Re: [PATCH] nl80211: change validation of scheduled scan interval
 values
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479810126-28492-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9fa76f2c-44b2-9782-8636-09afd1d59927@broadcom.com> (sfid-20161122_141232_064753_D73C55AC)
Date: Tue, 22 Nov 2016 14:12:25 +0100
MIME-Version: 1.0
In-Reply-To: <1479810126-28492-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-11-2016 11:22, Arend van Spriel wrote:
> When user-space does not provide scheduled scan plans, ie. uses the
> old scheduled scan API containing NL80211_ATTR_SCHED_SCAN_INTERVAL.
> The interval value passed by user-space is validated against
> struct wiphy::max_sched_scan_plan_interval and if it is exceeding
> it the interval is set to struct wiphy::max_sched_scan_plan_interval.
> However, when the driver does not set this limit the interval the
> interval in the request will always be zero. Hence add a check to
> see whether the driver set struct wiphy::max_sched_scan_plan_interval.
> 
> For the new API, ie. for scheduled scan plans, the interval validation
> has been simalarly adjusted to assure the limit is non-zero.

Actually turns out that max_sched_scan_plan_interval is always set in
wiphy_new_nm() which is used by all drivers so please drop this patch.

Regards,
Arend

> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  net/wireless/nl80211.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 24ab199..e621554 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -6777,7 +6777,8 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
>  		if (!request->scan_plans[0].interval)
>  			return -EINVAL;
>  
> -		if (request->scan_plans[0].interval >
> +		if (wiphy->max_sched_scan_plan_interval &&
> +		    request->scan_plans[0].interval >
>  		    wiphy->max_sched_scan_plan_interval)
>  			request->scan_plans[0].interval =
>  				wiphy->max_sched_scan_plan_interval;
> @@ -6801,7 +6802,10 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
>  
>  		request->scan_plans[i].interval =
>  			nla_get_u32(plan[NL80211_SCHED_SCAN_PLAN_INTERVAL]);
> -		if (!request->scan_plans[i].interval ||
> +		if (!request->scan_plans[i].interval)
> +			return -EINVAL;
> +
> +		if (wiphy->max_sched_scan_plan_interval &&
>  		    request->scan_plans[i].interval >
>  		    wiphy->max_sched_scan_plan_interval)
>  			return -EINVAL;
> 
