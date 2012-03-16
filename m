Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635Ab2CPIyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 04:54:07 -0400
Subject: Re: [PATCH 3/4] mac80211:  Framework to get wifi-driver stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331853606-28434-3-git-send-email-greearb@candelatech.com> (sfid-20120316_002024_641881_9A17A76F)
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com>
	 <1331853606-28434-3-git-send-email-greearb@candelatech.com>
	 (sfid-20120316_002024_641881_9A17A76F)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 09:54:05 +0100
Message-ID: <1331888045.3435.1.camel@jlt3.sipsolutions.net> (sfid-20120316_095414_564623_52A53C4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 16:20 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This adds hooks to call into the driver to get additional
> stats for the ethtool API.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 d49928b... e89a742... M	include/net/mac80211.h
> :100644 100644 0aef0d2... 872e06e... M	net/mac80211/cfg.c
>  include/net/mac80211.h |    9 +++++++++
>  net/mac80211/cfg.c     |   23 +++++++++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d49928b..e89a742 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2236,6 +2236,15 @@ struct ieee80211_ops {
>  					u16 tids, int num_frames,
>  					enum ieee80211_frame_release_type reason,
>  					bool more_data);
> +
> +	int	(*get_et_sset_count)(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif, int sset);
> +	void	(*get_et_stats)(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif,
> +				struct ethtool_stats *stats, u64 *data);
> +	void	(*get_et_strings)(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif *vif,
> +				  u32 sset, u8 *data);
>  };
>  
>  /**
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 0aef0d2..872e06e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -125,8 +125,17 @@ static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
>  				       struct net_device *dev,
>  				       int sset)
>  {
> -	if (sset == ETH_SS_STATS)
> -		return STA_STATS_LEN;
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_local *local;
> +	if (sset == ETH_SS_STATS) {
> +		int rv = STA_STATS_LEN;
> +		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +		local = sdata->local;
> +		if (local->ops->get_et_sset_count)
> +			rv += local->ops->get_et_sset_count(&local->hw,
> +							    &sdata->vif, sset);

should there be tracing for this?

johannes

