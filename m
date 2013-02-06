Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3BFRXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:23:50 -0500
Message-ID: <1360171448.7910.43.camel@jlt4.sipsolutions.net> (sfid-20130206_182353_793802_7D24A4A9)
Subject: Re: [PATCHv8 1/3] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 06 Feb 2013 18:24:08 +0100
In-Reply-To: <1359982200-2321-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359982200-2321-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 13:49 +0100, Simon Wunderlich wrote:

>  /**
> + * cfg80211_chandef_dfs_required - checks if radar detection
> + *	is required on any of the channels

pretty sure this isn't valid kernel-doc, I think it has to fit into one
line

> @@ -3663,6 +3694,21 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
>  			      gfp_t gfp);
>  
>  /**
> + * cfg80211_radar_event - radar detection event
> + * @dev: network device
> + * @chandef: chandef for the current channel
> + * @event: type of event
> + * @gfp: context flags
> + *
> + * This function is called when a radar is detected or a CAC event occured

occurred :)


> @@ -2014,6 +2029,7 @@ enum nl80211_band_attr {
>   *	(100 * dBm).
>   * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
>   *	currently defined
> + * @NL80211_FREQUENCY_ATTR_DFS_STATE: current state for DFS

missed docs for _DFS_TIME, maybe should put it before _MAX :)
also, what values does this take?

> +/**
> + * enum nl80211_dfs_state - DFS states for channels
> + *
> + * Channel states used by the DFS code.
> + *
> + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
> + *	check (CAC) must be performed before using it for AP or IBSS.
> + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
> + *	is therefore marked as not available.
> + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
> + */
> +
> +enum nl80211_dfs_state {
> +	NL80211_DFS_USABLE	= 0,

I don't really see a reason for explicit values?

> +static inline int cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)

no need for inline

> +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> +				  const struct cfg80211_chan_def *chandef)
> +{
> +	int width;
> +	int r;
> +
> +	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> +		return -EINVAL;
> +
> +	width = cfg80211_chandef_get_width(chandef);
> +	if (width < 0)
> +		return -EINVAL;
> +
> +	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
> +					    width);
> +	if (r)
> +		return r;
> +
> +	if (!chandef->center_freq2)
> +		return 0;
> +
> +	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
> +					       width);
> +}

If you don't export it why is it in the public header file -- either you
need to export it as well or it doesn't need to be in cfg80211.h :)

> @@ -454,6 +462,16 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
>  					    chan, chanmode, 0);
>  }
>  
> +static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> +{
> +	unsigned long end = jiffies;
> +
> +	if (end >= start)
> +		return jiffies_to_msecs(end - start);
> +
> +	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> +}

That seems a bit magic, like it should be hidden away in jiffies.h. Is
there really no function already to do something like this?

> +static void cfg80211_notify_nop_ended(struct cfg80211_registered_device *rdev,
> +					struct ieee80211_channel *c)

indentation :)

> +{
> +	struct wireless_dev *wdev;
> +	struct cfg80211_chan_def chandef;
> +
> +	cfg80211_chandef_create(&chandef, c, NL80211_CHAN_NO_HT);
> +
> +	mutex_lock(&rdev->devlist_mtx);
> +	list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +		if (!wdev->netdev)
> +			continue;
> +
> +		if (!netif_running(wdev->netdev))
> +			continue;
> +
> +		nl80211_radar_notify(rdev, &chandef,
> +				     NL80211_RADAR_NOP_FINISHED,
> +				     wdev->netdev, GFP_ATOMIC);
> +	}

Why for all interfaces? This is multicast anyway, so why not just send
the event without an interface index instead?

> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -1155,16 +1155,6 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
>  	}
>  }
>  
> -static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> -{
> -	unsigned long end = jiffies;
> -
> -	if (end >= start)
> -		return jiffies_to_msecs(end - start);
> -
> -	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> -}

Oh, heh. Oh well ...

I think I should probably look at locking too ...

johannes

