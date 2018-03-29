Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbeC2FbO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 01:31:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 29 Mar 2018 11:01:13 +0530
From: vthiagar@codeaurora.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/4] mac80211: Apply per-peer NoAck tid bitmap configuration
In-Reply-To: <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
Message-ID: <ec216d1f82f8bbe958ec6312c563bbd5@codeaurora.org> (sfid-20180329_073117_858662_A27AF10D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 14:12, Vasanthakumar Thiagarajan wrote:
> Use per-peer noack tid bitmap, if it is configured,
> when setting up the qos header. If no per-peer configuration
> is set, use the existing nedev wide noack policy configuration.
> Also modifies callback set_noack_tid_bitmap() with the provision
> to send per-peer NoAck policy configuration to the drivers supporting
> the NoAck offload functionality (IEEE80211_HW_SUPPORTS_NOACK_POLICY).
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
> ---
>  include/net/mac80211.h    |  7 +++++--
>  net/mac80211/cfg.c        | 42 
> +++++++++++++++++++++++++++++++++++++-----
>  net/mac80211/driver-ops.h |  5 +++--
>  net/mac80211/iface.c      |  2 +-
>  net/mac80211/sta_info.h   |  3 +++
>  net/mac80211/trace.h      |  9 ++++++---
>  net/mac80211/tx.c         |  2 +-
>  net/mac80211/wme.c        | 34 +++++++++++++++++++++++++++++++++-
>  8 files changed, 89 insertions(+), 15 deletions(-)
> 

<snip>

> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index a0a2d3c..8a2154a 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -1252,6 +1252,7 @@ static inline void drv_del_nan_func(struct
> ieee80211_local *local,
> 
>  static inline int drv_set_noack_tid_bitmap(struct ieee80211_local 
> *local,
>  					   struct ieee80211_sub_if_data *sdata,
> +					   struct sta_info *sta,
>  					   u16 noack_map)
>  {
>  	int ret;
> @@ -1263,9 +1264,9 @@ static inline int
> drv_set_noack_tid_bitmap(struct ieee80211_local *local,
>  	if (!local->ops->set_noack_tid_bitmap)
>  		return -EOPNOTSUPP;
> 
> -	trace_drv_set_noack_tid_bitmap(local, sdata, noack_map);
> +	trace_drv_set_noack_tid_bitmap(local, sdata, &sta->sta, noack_map);
>  	ret = local->ops->set_noack_tid_bitmap(&local->hw, &sdata->vif,
> -					       noack_map);
> +					       &sta->sta, noack_map);

Oops, we'll endup in NULL pointer dereference in accessing sta object 
when ndev level
configuration is sent. Ill address this in the next version.

Vasanth
