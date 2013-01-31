Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3AaOZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:25:11 -0500
Message-ID: <1359642321.8415.56.camel@jlt4.sipsolutions.net> (sfid-20130131_152516_864339_86BDFB80)
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 31 Jan 2013 15:25:21 +0100
In-Reply-To: <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 13:21 +0100, Simon Wunderlich wrote:

> From: Victor Goldenshtein <victorg@ti.com>

Probably time for you to claim ownership ... ;-)

> Changes to PATCHv6:

Thanks for your patience and the frequent posting :-)

>  /**
> + * enum ieee80211_dfs_state - DFS states for channels
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
> +enum ieee80211_dfs_state {
> +	IEEE80211_DFS_USABLE,
> +	IEEE80211_DFS_UNAVAILABLE,
> +	IEEE80211_DFS_AVAILABLE,

Should UNAVAILABLE be = 0, so that's the default?

> @@ -133,6 +151,9 @@ enum ieee80211_channel_flags {
>   *	to enable this, this is useful only on 5 GHz band.
>   * @orig_mag: internal use
>   * @orig_mpwr: internal use
> + * @dfs_state: current state of this channel. Only relevant if radar is required
> + *	on this channel.
> + * @dfs_state_entered: time when the dfs state was entered.

This is relevant for "unavailable", presumably, to make sure it stays
there for long enough? What unit is that, and how long does it have to
stay? "jiffies" can become unreliable after a long uptime so that might
cause issues. It's unlikely, the issue would be that ~25 days after it
was supposed to be available again it would be rejected as jiffies got
back to the same value ... :)
Also depends on your implementation which I haven't seen yet.

> @@ -412,6 +435,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>  			     u32 prohibited_flags);
>  
>  /**
> + * cfg80211_chandef_dfs_required - checks if radar detection
> + *	is required on any of the channels
> + * @wiphy: the wiphy to validate against
> + * @chandef: the channel definition to check
> + * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
> + */
> +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> +				  const struct cfg80211_chan_def *c);

Why does that need to be exported to mac80211/drivers? Shouldn't
cfg80211 be able to check everything?

>  struct wireless_dev {
>  	struct wiphy *wiphy;
> @@ -2638,6 +2678,8 @@ struct wireless_dev {
>  
>  	u32 ap_unexpected_nlportid;
>  
> +	bool cac_started;

Don't you need a cac_chandef or something?

>  /**
> + * cfg80211_radar - radar detection event
> + * @dev: network device
> + * @chandef: chandef for the current channel

Doesn't cfg80211 know what channel the device is operating/doing CAC on?

> +#define NL80211_DFS_MIN_CAC_TIME_MS		60000
> +#define NL80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)

Why are those needed in the userspace API?

> @@ -3221,6 +3240,7 @@ enum nl80211_feature_flags {
>  	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
>  	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
>  	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
> +	NL80211_FEATURE_DFS				= 1 << 14,

I don't think we need this any more with the interface combinations
thing?

> +static void cfg80211_set_chans_dfs_state(struct wiphy *wiphy, u32 center_freq,
> +					 u32 bandwidth,
> +					 enum ieee80211_dfs_state dfs_state)
> +{
> +	struct ieee80211_channel *c;
> +	u32 freq;
> +
> +	for (freq = center_freq - bandwidth/2 + 10;
> +	     freq <= center_freq + bandwidth/2 - 10;
> +	     freq += 20) {
> +		c = ieee80211_get_channel(wiphy, freq);
> +		if (!c || !(c->flags & IEEE80211_CHAN_RADAR))
> +			continue;
> +
> +		c->dfs_state = dfs_state;
> +		c->dfs_state_entered = jiffies;

I wonder if it'd make sense to not skip if the radar flag isn't set,
that could be relevant with regdom changes? OTOH, if the regdom changes
(much) I *suspect* we need to invalidate all the radar measurements
anyway since the rules might now be different?

> +int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> +				  const struct cfg80211_chan_def *chandef)
> +{
> +	u32 width;
> +	int r;
> +
> +	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> +		return -EINVAL;
> +
> +	width = cfg80211_chandef_get_width(chandef);
> +	if (width < 0)

never true with a u32, I think you might want to change the function
prototype and the variable :)

> @@ -344,7 +467,10 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
>  		break;
>  	case NL80211_IFTYPE_AP:
>  	case NL80211_IFTYPE_P2P_GO:
> -		if (wdev->beacon_interval) {
> +		if (wdev->cac_started) {
> +			*chan = wdev->preset_chandef.chan;
> +			*chanmode = CHAN_MODE_SHARED;

Ah, ok, so you're using the preset_chandef for CAC as well. I'm not
entirely sure that is correct though, since it could be changed by
userspace without much effect, e.g. by setting the channel with iw or
iwconfig? Unless you added "if (!cac_started)" there everywhere?

> +static inline void __cfg80211_dfs_clear_channel(struct ieee80211_channel *c,

no reason for inline

> +						bool *check_again,
> +						unsigned long *check_again_time)
> +{
> +	unsigned long timeout;
> +
> +	if (c->dfs_state == IEEE80211_DFS_UNAVAILABLE) {

could save on indentation by returning early if it's not unavailable :-)

I guess this addresses the jiffies concern I had above.

> +		timeout = c->dfs_state_entered + NL80211_DFS_MIN_NOP_TIME_MS;
> +		if (time_after_eq(jiffies, timeout)) {
> +			/* TODO: we could notify userspace about that change */
> +			c->dfs_state = IEEE80211_DFS_USABLE;
> +		} else {
> +			if (!*check_again)

should probably set it to false when the function starts, now you rely
on it being set outside which is a bit odd? (or did I just snip that
from my reply and don't see it any more?)

> +	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> +	if (err < 1)
> +		return err;

That doesn't make sense, if userspace starts CAC and that is successful
it would expect to eventually receive an event that it completed? Thus
if you return 0 here it would get confused, no?

> +	if (chandef.chan->dfs_state != IEEE80211_DFS_USABLE)
> +		return -EINVAL;
> +
> +	if (!rdev->ops->start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&rdev->devlist_mtx);
> +	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
> +					   chandef.chan, CHAN_MODE_SHARED,
> +					   BIT(chandef.width));
> +	mutex_unlock(&rdev->devlist_mtx);

You need to keep holding the mutex until you've set cac_started to true
(or failed), otherwise you introduce races.

> +	if (err)
> +		return err;
> +
> +	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> +	if (!err) {
> +		wdev->preset_chandef = chandef;
> +		wdev->cac_started = true;
> +		chandef.chan->dfs_state_entered = jiffies;

No reason to assign dfs_state_entered since it won't be used in this
state anyway, will it?

> @@ -5575,6 +5623,10 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>  	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
>  		return -EINVAL;
>  
> +	if (cfg80211_chandef_usable(&rdev->wiphy, &ibss.chandef,
> +				    IEEE80211_CHAN_NO_IBSS))
> +		return -EINVAL;

That seems like an unrelated change/fix?

> +	/* reason is unspecified, just notify that CAC has failed. */
> +	if (nla_put_u8(msg, NL80211_ATTR_RADAR_EVENT, event))

I think enums should generally be u32.

> +++ b/net/wireless/reg.c
> @@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
>  		return;
>  	}
>  
> +	chan->dfs_state = IEEE80211_DFS_USABLE;
> +	chan->dfs_state_entered = jiffies;

Here also you don't really need the time assignment.

(I skipped this before, so pasting here)

> +void cfg80211_radar_event(struct net_device *netdev,
> +                         struct cfg80211_chan_def *chandef,
> +                         enum nl80211_radar_event event,
> +                         gfp_t gfp)
> +{
> +       struct wireless_dev *wdev = netdev->ieee80211_ptr;
> +       struct wiphy *wiphy = wdev->wiphy;
> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +       unsigned long timeout;
> +
> +       if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> +               return;
> +
> +       trace_cfg80211_radar_event(netdev, chandef, event);
> +
> +       switch (event) {
> +       case NL80211_RADAR_DETECTED:
> +               /*
> +                * only set the chandef supplied channel to unavailable, in
> +                * case the radar is detected on only one of multiple channels
> +                * spanned by the chandef.
> +                */
> +               cfg80211_set_dfs_state(wiphy, chandef,
> +                                      IEEE80211_DFS_UNAVAILABLE);
> +
> +               timeout = msecs_to_jiffies(NL80211_DFS_MIN_NOP_TIME_MS);
> +               queue_delayed_work(cfg80211_wq, &rdev->dfs_update_channels_wk,
> +                                  timeout);
> +               break;
> +       case NL80211_CAC_FINISHED:
> +               timeout = wdev->preset_chandef.chan->dfs_state_entered;
> +               timeout = msecs_to_jiffies(timeout +
> +                                          NL80211_DFS_MIN_CAC_TIME_MS);
> +               WARN_ON(!time_after_eq(jiffies, timeout));
> +               cfg80211_set_dfs_state(wiphy, &wdev->preset_chandef,
> +                                      IEEE80211_DFS_AVAILABLE);
> +               break;
> +       case NL80211_CAC_ABORTED:
> +               /* Shouldn't happen if CAC was never started before. */
> +               WARN_ON(!wdev->cac_started);
> +               break;
> +       default:
> +               break;

I think a warning (and maybe return) would be useful here.

> +       }
> +
> +       wdev->cac_started = false;


Whew. :)
Overall I think this is looking good, mostly minor comments.

johannes

