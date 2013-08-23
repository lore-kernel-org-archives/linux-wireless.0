Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3HWOQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 10:16:52 -0400
Message-ID: <1377267409.14021.47.camel@jlt4.sipsolutions.net> (sfid-20130823_161655_988521_123B6D99)
Subject: Re: [PATCH v14 2/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Fri, 23 Aug 2013 16:16:49 +0200
In-Reply-To: <1376567489-1863-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1376567489-1863-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-15 at 14:51 +0300, Vladimir Kondratiev wrote:

[...]

Generally, I think this looks good now. Some small comments:

> - configure rx management filter to get probe-request and probe-response frames

This is misleading, there's no "filter" that the supplicant can
configure. It can (and should) subscribe to these frames, but that's not
really the same thing.

> - start p2p find via driver's cfg80211_ops start_p2p_find method
> - driver start p2p find with hardware and notify wpa_supplicant with
>   cfg80211_p2p_find_notify_start()
> - driver/firmware toggle search/listen states. Received probe-request and
>   probe-response frames passed to the wpa_supplicant via cfg80211_rx_mgmt;
>   replied by driver/firmware probe-request frames indicated with
>   NL80211_RXMGMT_FLAG_REPLIED flag

ANSWERED now

> Alternatively, driver/firmware may decide to stop p2p find.

This is somewhat problematic, see below.

> All driver to user space communication done through nl80211 layer.

Well, umm, ok. That seems kinda obvious :)


> @@ -3062,6 +3116,7 @@ struct wireless_dev {
>  	struct mutex mtx;
>  
>  	bool use_4addr, p2p_started;
> +	bool p2p_find_active; /* protected by rtnl */

Should that really be in the wdev, i.e. is it OK to run p2p_find on
multiple wdevs of the same wiphy? That seems odd.
 
> +/**
> + * cfg80211_p2p_find_notify_end - report p2p find phase ended
> + * @wdev: the wireless device reporting the event
> + * @gfp: allocation flags
> + *
> + * p2p find phase may be ended either unsolicited or in response to
> + * ops->stop_p2p_find. If called out of context of ops->stop_p2p_find,
> + * should be protected with rtnl_lock()

I think this is problematic, how are drivers going to be able to
guarantee this? They'd most likely call this from some RX context if the
firmware gives up, or firmware restart context, and not really know
whether the RTNL is held or not? Then drivers will have to make it
async, but then we might just as well make it async in cfg80211, no?

Thinking about this, I'm also starting to think that requiring this to
be called when the stop_p2p_find() operation is called is pretty
pointless, as cfg80211 can just do it itself? If the driver still calls
it, it can obviously suppress the extra event.

> +void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);

That gfp argument is also fairly useless, if you must hold the RTNL it's
likely that you're able to sleep, unless doing something 'exotic' like
	rtnl_lock()
	rcu_read_lock()
	...
	p2p_find_notify_end()

but that would be strange and not usually needed?

> +	if (!wdev->p2p_find_active)
> +		return -ENOENT;
> +
> +	rdev_stop_p2p_find(rdev, wdev);

Here you could do something like

	if p2p_find_active
		send_event()
		p2p_find_active = false

so drivers don't have to call it?

> +void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp)
> +{
> +	ASSERT_RTNL();

In fact, ASSERT_RTNL() can only be called when able to sleep, because it
attempts to lock or so ... unless that changed to lockdep recently?


Ilan also pointed out to me that it might be necessary to document (and
enforce?) that scan/sched_scan can't be executed in parallel? Or can
they?

johannes

