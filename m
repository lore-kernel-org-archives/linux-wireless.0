Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3APWvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:51:01 -0500
Message-ID: <1358376672.15012.37.camel@jlt4.sipsolutions.net> (sfid-20130116_235106_962854_6926B9ED)
Subject: Re: [PATCHv6 3/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 16 Jan 2013 23:51:12 +0100
In-Reply-To: <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:


> + * @radar_detect_timeout: this timeout indicates the end of the channel
> + *     availability check for radar channels (in jiffies), only after this
> + *     period the user may initiate the tx on the channel.
> + * @cac_started: indicates that channel availability check is started for this
> + *     channel type.

So you're enforcing a certain CAC time, but not the time we are allowed
to treat the channel as clear? Shouldn't *that* be in each channel
struct, rather than the other stuff?

It also seems to me that "cac_started" isn't really all that relevant in
the channel struct either. What seems relevant is the *result* of the
CAC, and how long it's still valid, no?

> +++ b/net/wireless/chan.c
> @@ -287,14 +287,18 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
>  			     struct cfg80211_chan_def *chandef)
>  {
>  	bool res;
> +	u32 prohibited_flags;
>  
>  	trace_cfg80211_reg_can_beacon(wiphy, chandef);
>  
> -	res = cfg80211_chandef_usable(wiphy, chandef,
> -				      IEEE80211_CHAN_DISABLED |
> -				      IEEE80211_CHAN_PASSIVE_SCAN |
> -				      IEEE80211_CHAN_NO_IBSS |
> -				      IEEE80211_CHAN_RADAR);
> +	prohibited_flags = IEEE80211_CHAN_DISABLED;
> +
> +	if (!(wiphy->features & NL80211_FEATURE_DFS))
> +		prohibited_flags |= IEEE80211_CHAN_PASSIVE_SCAN |
> +				    IEEE80211_CHAN_NO_IBSS |
> +				    IEEE80211_CHAN_RADAR;

I have a feeling this change should take into account the channel width,
and whether CAC completed successfully?


> +static int nl80211_start_radar_detection(struct sk_buff *skb,
> +					 struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_chan_def chandef;
> +	int err;
> +
> +	if (!(rdev->wiphy.features & NL80211_FEATURE_DFS))
> +		return -EOPNOTSUPP;
> +
> +	err = nl80211_parse_chandef(rdev, info, &chandef);
> +	if (err)
> +		return err;
> +
> +	if (!(chandef.chan->flags & IEEE80211_CHAN_RADAR))
> +		return -EINVAL;
> +
> +	if (chandef.chan->cac_started)
> +		return -EBUSY;
> +
> +	if (!rdev->ops->start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&rdev->devlist_mtx);
> +	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
> +					   chandef.chan, CHAN_MODE_SHARED,
> +					   BIT(chandef.width));
> +	mutex_unlock(&rdev->devlist_mtx);
> +
> +	if (err)
> +		return err;
> +
> +	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> +	if (!err) {
> +		wdev->preset_chandef = chandef;
> +		chandef.chan->cac_started = true;
> +		chandef.chan->radar_detect_timeout = jiffies +
> +			msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
> +	}
> +
> +	return err;
> +}

This still seems somewhat wrong. For the duration of the CAC, the
channel should be "locked" in some way, no? As it stands now, nothing
prevents userspace from adding another vif and using it for something
entirely different, while cfg80211 thinks the CAC is actually running.

> +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
> +	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq))
> +		goto nla_put_failure;

That should be the entire chandef info, and possibly the WDEV_ID too.

johannes

