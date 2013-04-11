Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3DKJLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 05:11:34 -0400
Message-ID: <1365671487.8272.27.camel@jlt4.sipsolutions.net> (sfid-20130411_111140_319263_6356D1C7)
Subject: Re: [PATCH v4 1/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Thu, 11 Apr 2013 11:11:27 +0200
In-Reply-To: <1363863994-32510-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363863994-32510-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-21 at 13:06 +0200, Vladimir Kondratiev wrote:
> Allow to implement P2P find phase in the driver/firmware.
> 
> Offload scheme designed as follows:
> 
> - Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
> - Driver indicate firmware or driver responds to the probe requests by setting
>   feature NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD
> - wpa_supplicant analyses methods supported to discover p2p offload support;
> - wpa_supplicant analyses feature flags to discover p2p probe response
>   offload support;
> to perform p2p scan, wpa_supplicant:
> - perform legacy scan, through driver's cfg80211_ops 'scan' method
> - configure rx management filter to get probe-request and probe-response frames
> - start p2p find via driver's cfg80211_ops start_p2p_find method
> - driver start p2p find with hardware and notify wpa_supplicant with
>   cfg80211_p2p_find_notify_start()
> - driver/firmware toggle search/listen states. Received probe-request and
>   probe-response frames passed to the wpa_supplicant via cfg80211_rx_mgmt
> - when wpa_supplicant wants to stop p2p find, it calls driver's
>   cfg80211_ops stop_p2p_find method. Alternatively, driver/firmware may decide
>   to stop p2p find. In all cases, driver notifies wpa_supplicant using
>   cfg80211_p2p_find_notify_end()
> 
> All driver to user space communication done through nl80211 layer.
> 
> Offloaded P2P find does not support variations like progressive scan.

Ok :)

I have a conceptual question: As I understand it, this is going to be
required, ie. the device might not support P2P Find using
remain-on-channel, if this offload is supported. Right?

> +/**
> + * cfg80211_p2p_find_notify_end - report p2p find phase ended
> + * @wdev: the wireless device reporting the event
> + * @gfp: allocation flags
> + *
> + * p2p find phase may be ended either unsolicited or in response to
> + * ops->p2p_stop_find

Does that mean if the p2p_stop_find operation is called, this must also
be called? I'm guessing so, but it'd be good to spell it out explicitly.

> + * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
> + * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
> + *	for the p2p find, represented as u32

Could you please also say here that it's a multiple of 100 TUs?

> @@ -1417,6 +1419,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
>  		}
>  		CMD(start_p2p_device, START_P2P_DEVICE);
>  		CMD(set_mcast_rate, SET_MCAST_RATE);
> +	CMD(start_p2p_find, START_P2P_FIND);
> +	CMD(stop_p2p_find, STOP_P2P_FIND);

For the wiphy size limitation thing, you need to put this into

if (split) {
	CMD(...)
	CMD(...)
}

There's another patch pending that would then conflict here, but I can
sort out that problem.
 
> +static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +	struct wiphy *wiphy = &rdev->wiphy;
> +	struct cfg80211_p2p_find_params params = {};
> +	struct nlattr *attr_freq = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
> +	struct nlattr *attr;
> +	int err, tmp, n_channels, i = 0;
> +	struct ieee80211_channel **channels = NULL;
> +
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_P2P_DEVICE:
> +	case NL80211_IFTYPE_STATION:

I think we (Intel) would also require to use the P2P_DEVICE for this
call, so maybe we should document in the nl80211 command that if
P2P_DEVICE is supported, this command is only supported on the
_P2P_DEVICE and not on _STATION? Anyway that'd be my assumption right
now that it gets used on whichever is used for P2P Device functionality,
so that shouldn't change anything in the supplicant just clarify the API
a bit.

Btw, do you have supplicant patches already?

> +	if (attr_freq) {

Is there value in supporting this call w/o any frequencies set? It seems
to me that the driver would be confused if it got no channels at all?

> +		n_channels = validate_scan_freqs(attr_freq);
> +		if (!n_channels)
> +			return -EINVAL;
> +
> +		channels = kzalloc(n_channels * sizeof(*channels), GFP_KERNEL);
> +		if (!channels)
> +			return -ENOMEM;
> +
> +		/* user specified, bail out if channel not found */
> +		nla_for_each_nested(attr, attr_freq, tmp) {
> +			struct ieee80211_channel *chan;
> +
> +			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
> +
> +			if (!chan)
> +				return -EINVAL;

This leaks memory, no?

> +		if (!i) {
> +			err = -EINVAL;
> +			goto out_free;
> +		}

And here you refuse an empty channel list, but a not-present one still
got accepted above, I think you should change that (which also saves you
a level of indentation here :P)

> +	TP_STRUCT__entry(
> +		WIPHY_ENTRY
> +		WDEV_ENTRY
> +	),
> +	TP_fast_assign(
> +		WIPHY_ASSIGN;
> +		WDEV_ASSIGN;
> +	),
> +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
> +);

I think it'd be worthwhile to trace a bit more data, like the timings
for example? Maybe not the IEs and channel list (those are tricky
anyway), but the easy ones?

johannes

