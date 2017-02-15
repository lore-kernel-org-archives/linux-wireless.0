Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56416 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbdBOIOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 03:14:42 -0500
Message-ID: <1487146475.4026.11.camel@sipsolutions.net> (sfid-20170215_091500_912254_0FBD505A)
Subject: Re: [PATCH 2/2] mac80211: fix mesh fail_avg check
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Wed, 15 Feb 2017 09:14:35 +0100
In-Reply-To: <1487104037-24941-2-git-send-email-rmanohar@qca.qualcomm.com>
References: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com>
         <1487104037-24941-2-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 12:27 -0800, Rajkumar Manoharan wrote:
> Mesh failure average never be more than 100. Only in case of
> fixed path, average will be more than threshold limit (95%).
> With recent EWMA changes it may go upto 99 as it is scaled to
> 100. It make sense to return maximum metric when average is
> greater than threshold limit.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/mesh_hwmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index d07ee3ca07ee..02c30a21eb66 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -339,7 +339,7 @@ static u32 airtime_link_metric_get(struct
> ieee80211_local *local,
>  	if (rate) {
>  		err = 0;
>  	} else {
> -		if (fail_avg >= 100)
> +		if (fail_avg >= 95)
>  			return MAX_METRIC;

Why is this >= and the other place is >?

Also, I think it'd be good to introduce a #define for this value now,
perhaps something like "LINK_FAIL_THRESH".

johannes
