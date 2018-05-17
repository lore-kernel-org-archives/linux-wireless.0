Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQSnN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 14:43:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 17 May 2018 11:43:12 -0700
From: Jeff Johnson <jjohnson@codeaurora.org>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] nl80211: fix nlmsg allocation in cfg80211_ft_event
In-Reply-To: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org>
References: <000901d3ede2$78a3aa20$69eafe60$@codeaurora.org>
Message-ID: <a19275473776283a94997b8f5436f3b9@codeaurora.org> (sfid-20180517_204322_111043_9C68DA25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-17 06:25, Dedy Lansky wrote:
> From: Dedy Lansky <dlansky@codeaurora.org>
> 
> Allocation size of nlmsg in cfg80211_ft_event is based on ric_ies_len
> and doesn't take into account ies_len. This leads to
> NL80211_CMD_FT_EVENT message construction failure in case ft_event
> contains large enough ies buffer.
> Add ies_len to the nlmsg allocation size.
> 
> Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index afbe510..64afd04 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -15755,7 +15755,8 @@ void cfg80211_ft_event(struct net_device 
> *netdev,
>  	if (!ft_event->target_ap)
>  		return;
> 
> -	msg = nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
> +	msg = nlmsg_new(100 + ft_event->ies_len + ft_event->ric_ies_len,
> +			GFP_KERNEL);
>  	if (!msg)
>  		return;

should these really be nla_total_size(ft_event->ies_len) + 
nla_total_size(ft_event->ric_ies_len) to properly account for the NLA 
header + padding? or do we consider that to be noise captured by the 
"100"?
