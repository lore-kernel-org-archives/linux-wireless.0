Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab3EGOKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:10:42 -0400
Message-ID: <1367935836.8328.45.camel@jlt4.sipsolutions.net> (sfid-20130507_161047_821416_4115BC00)
Subject: Re: [PATCH v6] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 07 May 2013 16:10:36 +0200
In-Reply-To: <1367235610-10375-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1367235610-10375-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1367235610-10375-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

sorry for the delay. Looks good, a few comments below.

> to perform p2p scan, wpa_supplicant:
> - perform legacy scan, through driver's cfg80211_ops 'scan' method
> - configure rx management filter to get probe-request and probe-response frames

Does that part make sense? Why should the supplicant be required to
configure the filter, if the next thing is going to be

> - start p2p find via driver's cfg80211_ops start_p2p_find method

starting the p2p find? I mean, it seems that should implicitly enable
the filter? Or is there a reason you think this command would be useful
_without_ enabling the filter??

> +/**
> + * cfg80211_p2p_find_notify_end - report p2p find phase ended
> + * @wdev: the wireless device reporting the event
> + * @gfp: allocation flags
> + *
> + * p2p find phase may be ended either unsolicited or in response to
> + * ops->p2p_stop_find
> + *
> + * In any case, if @start_p2p_find from driver's struct cfg80211_ops called,
> + * @cfg80211_p2p_find_notify_end should be eventually called
> + */
> +void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);

Please clarify whether or not this should be called when a stop is
explicitly requested by userspace. I don't think it's all that useful,
and if required maybe cfg80211 should send the event itself instead of
having the driver do it?

> + * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
> + * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
> + *	for the p2p find, multiple of 100 TUs, represented as u32
> + *
> + *

One blank line is enough :-)

> +	struct cfg80211_p2p_find_params params = {};

> +	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
> +	if (attr)
> +		params.min_discoverable_interval = nla_get_u32(attr);
> +
> +	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
> +	if (attr)
> +		params.max_discoverable_interval = nla_get_u32(attr);

Shouldn't those have better defaults than 0/0? Or should they just be
required?

> +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", disc. int. [%d..%d]"
> +		  ", n_channels %d",

you shouldn't break strings across lines (and in fact checkpatch
shouldn't warn about 80 cols there, but if it does ignore it)

johannes

