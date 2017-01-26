Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48012 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753169AbdAZJlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 04:41:24 -0500
Message-ID: <1485423682.11038.8.camel@sipsolutions.net> (sfid-20170126_104137_674921_7347536E)
Subject: Re: [RFC 3/3] cfg80211: Share Channel DFS state across wiphys of
 same DFS domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Jan 2017 10:41:22 +0100
In-Reply-To: <1485343870-23601-4-git-send-email-vthiagar@qti.qualcomm.com>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1485343870-23601-4-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-25 at 17:01 +0530, Vasanthakumar Thiagarajan wrote:
> Sharing DFS channel state across multiple wiphys (radios) could
> be useful with multiple radios on the system. When one radio
> completes CAC and marks the channel available another radio
> can use this information and start beaconing without really doing
> CAC.
> 
> Whenever there is a state change in DFS channel associated to
> a particular wiphy the the same state change is propagated to
> other wiphys having the same DFS reg domain configuration.
> Also when a new wiphy is created the DFS channel state of
> other existing wiphys of same DFS domain is copied.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  net/wireless/chan.c |  24 +++++++++--
>  net/wireless/core.c |  37 +++++++++++++++++
>  net/wireless/core.h |   6 +++
>  net/wireless/mlme.c |  11 +++++-
>  net/wireless/reg.c  | 112
> ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/reg.h  |  22 +++++++++++
>  6 files changed, 207 insertions(+), 5 deletions(-)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 090309a..40f1097 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -532,21 +532,37 @@ bool cfg80211_beaconing_iface_active(struct
> wireless_dev *wdev)
>  	return active;
>  }
>  
> +static bool cfg80211_5ghz_is_wiphy_oper_chan(struct wiphy *wiphy,
> +					     struct
> ieee80211_channel *chan)

again, nothing really 5 GHz specific here, afaict?

> +	struct wireless_dev *wdev;
> +
> +	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
> +		if (!cfg80211_beaconing_iface_active(wdev))
> +			continue;
> +
> +		if (cfg80211_5ghz_sub_chan(&wdev->chandef, chan))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
>  				       struct ieee80211_channel
> *chan)
>  {
> -	struct wireless_dev *wdev;
> +	struct cfg80211_registered_device *rdev;
>  
>  	ASSERT_RTNL();
>  
>  	if (!(chan->flags & IEEE80211_CHAN_RADAR))
>  		return false;
>  
> -	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
> -		if (!cfg80211_beaconing_iface_active(wdev))
> +	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +		if (!reg_dfs_domain_same(wiphy, &rdev->wiphy))
>  			continue;
>  
> -		if (cfg80211_5ghz_sub_chan(&wdev->chandef, chan))
> +		if (cfg80211_5ghz_is_wiphy_oper_chan(&rdev->wiphy,
> chan))
>  			return true;
>  	}
>  
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 903fc419..c3fe44b 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -357,6 +357,38 @@ static void cfg80211_sched_scan_stop_wk(struct
> work_struct *work)
>  	rtnl_unlock();
>  }
>  
> +static void cfg80211_propagate_radar_detect_wk(struct work_struct
> *work)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = container_of(work, struct cfg80211_registered_device,
> +			    porpagate_radar_detect_wk);
> +
> +	rtnl_lock();
> +
> +	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev-
> >radar_chandef,
> +				       NL80211_DFS_UNAVAILABLE,
> +				       NL80211_RADAR_DETECTED);
> +
> +	rtnl_unlock();
> +}
> +
> +static void cfg80211_propagate_cac_done_wk(struct work_struct *work)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = container_of(work, struct cfg80211_registered_device,
> +			    propagate_cac_done_wk);
> +
> +	rtnl_lock();
> +
> +	regulatory_propagate_dfs_state(&rdev->wiphy, &rdev-
> >cac_done_chandef,
> +				       NL80211_DFS_AVAILABLE,
> +				       NL80211_RADAR_CAC_FINISHED);
> +
> +	rtnl_unlock();
> +}
> +
>  /* exported functions */
>  
>  struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int
> sizeof_priv,
> @@ -456,6 +488,9 @@ struct wiphy *wiphy_new_nm(const struct
> cfg80211_ops *ops, int sizeof_priv,
>  	spin_lock_init(&rdev->destroy_list_lock);
>  	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
>  	INIT_WORK(&rdev->sched_scan_stop_wk,
> cfg80211_sched_scan_stop_wk);
> +	INIT_WORK(&rdev->porpagate_radar_detect_wk,
> +		  cfg80211_propagate_radar_detect_wk);
> +	INIT_WORK(&rdev->propagate_cac_done_wk,
> cfg80211_propagate_cac_done_wk);
>  
>  #ifdef CONFIG_CFG80211_DEFAULT_PS
>  	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
> @@ -914,6 +949,8 @@ void wiphy_unregister(struct wiphy *wiphy)
>  	flush_work(&rdev->destroy_work);
>  	flush_work(&rdev->sched_scan_stop_wk);
>  	flush_work(&rdev->mlme_unreg_wk);
> +	flush_work(&rdev->porpagate_radar_detect_wk);

typo: propagate.

> +	flush_work(&rdev->propagate_cac_done_wk);

You got it right here :)
 
>  #ifdef CONFIG_PM
>  	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 327fe95..607c8be 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -97,6 +97,12 @@ struct cfg80211_registered_device {
>  
>  	struct work_struct sched_scan_stop_wk;
>  
> +	struct cfg80211_chan_def radar_chandef;
> +	struct work_struct porpagate_radar_detect_wk;

Since it compiled, the typo exists everywhere this is referenced.

> +++ b/net/wireless/mlme.c
> @@ -18,7 +18,6 @@
>  #include "nl80211.h"
>  #include "rdev-ops.h"
>  
> -
>  void cfg80211_rx_assoc_resp(struct net_device *dev, struct
> cfg80211_bss *bss,

please don't make unrelated "cleanups".

> +bool reg_dfs_domain_same(struct wiphy *wiphy1, struct wiphy *wiphy2)
> +{
> +	const struct ieee80211_regdomain *wiphy1_regd = NULL;
> +	const struct ieee80211_regdomain *wiphy2_regd = NULL;
> +	const struct ieee80211_regdomain *cfg80211_regd = NULL;
> +	bool dfs_domain_same = false;

You can remove that initializer,

> +	rcu_read_lock();
> +
> +	cfg80211_regd = rcu_dereference(cfg80211_regdomain);
> +	wiphy1_regd = rcu_dereference(wiphy1->regd);
> +	if (!wiphy1_regd)
> +		wiphy1_regd = cfg80211_regd;
> +
> +	wiphy2_regd = rcu_dereference(wiphy2->regd);
> +	if (!wiphy2_regd)
> +		wiphy2_regd = cfg80211_regd;
> +
> +	if (wiphy1_regd->dfs_region == wiphy2_regd->dfs_region)
> +		dfs_domain_same = true;

and just assign
	dfs_domain_same = wiphy1... == wiphy2...;

> +static void wiphy_share_dfs_chan_state(struct wiphy *dst_wiphy,
> +				       struct wiphy *src_wiphy)
> +{
> +	struct ieee80211_supported_band *src_sband, *dst_sband;
> +	int i, j;
> +
> +	dst_sband = dst_wiphy->bands[NL80211_BAND_5GHZ];
> +	src_sband = src_wiphy->bands[NL80211_BAND_5GHZ];
> +	if (!dst_sband || !src_sband)
> +		return;

Why make this 5 GHz specific? Perhaps some kind of radar stuff will
exist in future bands too. It shouldn't really cost much to iterate all
the bands, I think?

johannes
