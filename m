Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab3CPM5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:10 -0400
Message-ID: <1363372823.8656.41.camel@jlt4.sipsolutions.net> (sfid-20130316_135714_194817_9E8BBDC8)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <2799886.P5v870j3h2@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <1362650938.8694.21.camel@jlt4.sipsolutions.net>
	 <1628850.y8u4o7KRXH@lx-vladimir> <2799886.P5v870j3h2@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 19:40:23 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Allow to implement P2P find phase in the driver/firmware.
> 
> Offload scheme designed as follows:
> 
> - Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
>   indicates support for p2p find offload by setting feature
>   NL80211_FEATURE_P2P_FIND_OFFLOAD

Why not just indicate the command presence rather than a feature flag?

> - perform legacy scan, through driver's cfg80211_ops 'scan' method

Why the legacy scan? btw this is what I was worried about -- this API
robs us of the ability to do "progressive" p2p scan.

> - configure rx management filter to get probe-request and probe-response frames

Interesting, so this is pretty much bypassing the scan BSS table
mechanism. I guess it makes sense though.

> - driver start p2p find with hardware and notify wpa_supplicant with
>   cfg80211_p2p_find_notify(NL80211_CMD_START_P2P_FIND)

See other mail -- is that really useful?

>   cfg80211_p2p_find_notify(NL80211_CMD_STOP_P2P_FIND)

btw, if both are needed I'd prefer not to give a command number here,
it's useless to give anything else and this is a bit confusing.

>  /**
> + * struct cfg80211_p2p_find_params - parameters for P2P find
> + * @probe_ie: IE's for probe frames

probe request, presumably?

Also, this is probably *additional* IEs, i.e. supported rates etc. are
expected to be created by the driver?

> + * @probe_resp_ie: IE's for probe response frames

similarly here?

> + * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
> + * @min_discoverable_interval and

need : otherwise it's not valid kernel-doc

> + * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,

same here

> +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> +				nl80211_scan_mcgrp.id, GFP_KERNEL);

indentation


> +static inline int rdev_start_p2p_find(struct cfg80211_registered_device *rdev,
> +				      struct wireless_dev *wdev,
> +				      struct cfg80211_p2p_find_params *params)

indentation


> +static inline void rdev_stop_p2p_find(struct cfg80211_registered_device *rdev,
> +				      struct wireless_dev *wdev)

ditto
 
> +	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
> +		 struct cfg80211_p2p_find_params *params),

ditto

> +	TP_printk(WDEV_PR_FMT ", cmd: %d", WDEV_PR_ARG,
> +		  __entry->cmd)

ditto

johannes

