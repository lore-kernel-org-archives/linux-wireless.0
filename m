Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47966 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbdAZJeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 04:34:07 -0500
Message-ID: <1485423244.11038.4.camel@sipsolutions.net> (sfid-20170126_103412_359228_62B31662)
Subject: Re: [RFC 1/3] cfg80211: Make pre-CAC results valid only for ETSI
 domain
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Jan 2017 10:34:04 +0100
In-Reply-To: <1485343870-23601-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1485343870-23601-2-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +		/* Should we apply the grace period during beaconing
> interface
> +		 * shutdown also?
> +		 */
> +		cfg80211_sched_dfs_chan_update(rdev);

It might make some sense, say if hostapd crashes and you restart it
automatically or something?

>  	return err;
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 5497d022..090309a 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -456,6 +456,102 @@ bool cfg80211_chandef_dfs_usable(struct wiphy
> *wiphy,
>  	return (r1 + r2 > 0);
>  }
>  
> +static bool cfg80211_5ghz_sub_chan(struct cfg80211_chan_def
> *chandef,
> +				   struct ieee80211_channel *chan)

This could use some explanation, and I don't see anything that's really
5 GHz specific in here, so why that in the function name?

> +	u32 start_freq_seg0 = 0, end_freq_seg0 = 0;
> +	u32 start_freq_seg1 = 0, end_freq_seg1 = 0;
> +
> +	if (chandef->chan->center_freq == chan->center_freq)
> +		return true;
> +
> +	switch (chandef->width) {
> +	case NL80211_CHAN_WIDTH_40:
> +		start_freq_seg0 = chandef->center_freq1 - 20;
> +		end_freq_seg0 = chandef->center_freq1 + 20;
> +		break;
> +	case NL80211_CHAN_WIDTH_80P80:
> +		start_freq_seg1 = chandef->center_freq2 - 40;
> +		end_freq_seg1 = chandef->center_freq2 + 40;
> +		/* fall through */
> +	case NL80211_CHAN_WIDTH_80:
> +		start_freq_seg0 = chandef->center_freq1 - 40;
> +		end_freq_seg0 = chandef->center_freq1 + 40;
> +		break;
> +	case NL80211_CHAN_WIDTH_160:
> +		start_freq_seg0 = chandef->center_freq1 - 80;
> +		end_freq_seg0 = chandef->center_freq1 + 80;
> +		break;
> +	case NL80211_CHAN_WIDTH_20_NOHT:
> +	case NL80211_CHAN_WIDTH_20:
> +	case NL80211_CHAN_WIDTH_5:
> +	case NL80211_CHAN_WIDTH_10:
> +		break;
> +	}
> +
> +	if (chan->center_freq > start_freq_seg0 &&
> +	    chan->center_freq < end_freq_seg0)
> +		return true;
> +
> +	return chan->center_freq > start_freq_seg1 &&
> +		chan->center_freq < end_freq_seg1;
> +}

It's also written pretty oddly... The 5/10/20 cases could return
immediately, the start/end could be replaced by width, and the
initializations wouldn't be needed at all ... I think we can do better
here.

> +bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
> +				       struct ieee80211_channel
> *chan)

Again, nothing 5 GHz specific.

> +	struct wireless_dev *wdev;
> +
> +	ASSERT_RTNL();
> +
> +	if (!(chan->flags & IEEE80211_CHAN_RADAR))
> +		return false;
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
>  
>  static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
>  					     u32 center_freq,
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 58ca206..327fe95 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -459,6 +459,13 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
>  cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
>  			      const struct cfg80211_chan_def
> *chandef);
>  
> +void cfg80211_sched_dfs_chan_update(struct
> cfg80211_registered_device *rdev);
> +
> +bool cfg80211_5ghz_any_wiphy_oper_chan(struct wiphy *wiphy,
> +				       struct ieee80211_channel
> *chan);
> +
> +bool cfg80211_beaconing_iface_active(struct wireless_dev *wdev);
> +
>  static inline unsigned int elapsed_jiffies_msecs(unsigned long
> start)
>  {
>  	unsigned long end = jiffies;
> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 364f900..10bf040 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -190,6 +190,7 @@ static void __cfg80211_clear_ibss(struct
> net_device *dev, bool nowext)
>  	if (!nowext)
>  		wdev->wext.ibss.ssid_len = 0;
>  #endif
> +	cfg80211_sched_dfs_chan_update(rdev);
>  }
>  
>  void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index 2d8518a..ec0b1c2 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -262,6 +262,7 @@ int __cfg80211_leave_mesh(struct
> cfg80211_registered_device *rdev,
>  		wdev->beacon_interval = 0;
>  		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
>  		rdev_set_qos_map(rdev, dev, NULL);
> +		cfg80211_sched_dfs_chan_update(rdev);
>  	}
>  
>  	return err;
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 22b3d99..3c7e155 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -745,6 +745,12 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev,
> int freq, int sig_mbm,
>  }
>  EXPORT_SYMBOL(cfg80211_rx_mgmt);
>  
> +void cfg80211_sched_dfs_chan_update(struct
> cfg80211_registered_device *rdev)
> +{
> +	cancel_delayed_work(&rdev->dfs_update_channels_wk);
> +	queue_delayed_work(cfg80211_wq, &rdev-
> >dfs_update_channels_wk, 0);
> +}

This uses 0.

> @@ -820,9 +844,7 @@ void cfg80211_radar_event(struct wiphy *wiphy,
>  	 */
>  	cfg80211_set_dfs_state(wiphy, chandef,
> NL80211_DFS_UNAVAILABLE);
>  
> -	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_NOP_TIME_MS);
> -	queue_delayed_work(cfg80211_wq, &rdev-
> >dfs_update_channels_wk,
> -			   timeout);
> +	cfg80211_sched_dfs_chan_update(rdev);

But this didn't - why does that change?

> +unsigned long regulatory_get_pre_cac_timeout(struct wiphy *wiphy)
> +{
> +	if (!regulatory_pre_cac_allowed(wiphy))
> +		return REG_PRE_CAC_EXPIRY_GRACE_MS;
> +
> +	/*
> +	 * Return the maximum pre-CAC timeout when pre-CAC is
> allowed
> +	 * in the current dfs domain (ETSI).
> +	 */
> +	return -1;
> +}

Don't ever return -1, that's -EPERM and not really what you want
anyway.

In fact, this doesn't even make sense, since the only caller already
checks regulatory_pre_cac_allowed() before calling this.

johannes
