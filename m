Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33201 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaJXOdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 10:33:09 -0400
Message-ID: <1414161186.2326.1.camel@jlt4.sipsolutions.net> (sfid-20141024_163314_103373_7FC9580A)
Subject: Re: [PATCH] mac80211: add support for driver tx power reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Oct 2014 16:33:06 +0200
In-Reply-To: <1413993458-62517-1-git-send-email-nbd@openwrt.org>
References: <1413993458-62517-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 17:57 +0200, Felix Fietkau wrote:
> The configured tx power is often limited by hardware capabilities,
> channel settings, antenna configuration, etc.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h | 5 +++++
>  net/mac80211/cfg.c     | 3 +++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0ad1f47..41b0e60 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2838,6 +2838,9 @@ enum ieee80211_roc_type {
>   * @get_expected_throughput: extract the expected throughput towards the
>   *	specified station. The returned value is expressed in Kbps. It returns 0
>   *	if the RC algorithm does not have proper data to provide.
> + *
> + * @get_txpower: get current maximum tx power (in dBm) based on configuration
> + *	and hardware limits.
>   */
>  struct ieee80211_ops {
>  	void (*tx)(struct ieee80211_hw *hw,
> @@ -3039,6 +3042,8 @@ struct ieee80211_ops {
>  	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>  	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>  	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
> +	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +			   int *dbm);
>  };
>  
>  /**
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index fb6a150..7cb31a8 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2081,6 +2081,9 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
>  
> +	if (local->ops->get_txpower)
> +		return local->ops->get_txpower(&local->hw, &sdata->vif, dbm);

Might be good to have tracing?

And when this is supported, maybe there should be a cop-out for the
driver to say "please use your value"? OTOH it can access the data that
mac80211 currently reports so that's probably not needed?

johannes

