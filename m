Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1CVVmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 17:42:07 -0400
Subject: Re: [PATCH 5/5 v4] mac80211: New notification to discover mesh
 peer candidates.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1300479732-25920-6-git-send-email-javier@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1300479732-25920-6-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 22:42:03 +0100
Message-ID: <1300830123.3746.50.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-18 at 13:22 -0700, Javier Cardona wrote:

> @@ -1170,6 +1182,7 @@ enum nl80211_iftype {
>   * @NL80211_STA_FLAG_WME: station is WME/QoS capable
>   * @NL80211_STA_FLAG_MFP: station uses management frame protection
>   * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
> + * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
>   * @__NL80211_STA_FLAG_AFTER_LAST: internal use

This looks a little odd, but doesn't really matter.


> +void cfg80211_notify_new_peer_candidate(struct net_device *dev,
> +		const u8 *macaddr, const u8* ie, u8 ie_len, gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +	struct cfg80211_event *ev;
> +	unsigned long flags;
> +
> +	ev = kzalloc(sizeof(*ev), gfp);
> +	if (!ev)
> +		return;
> +	ev->type = EVENT_NEW_CANDIDATE;
> +	memcpy(ev->nc.macaddr, macaddr, ETH_ALEN);
> +	if (ie_len && ie) {
> +		ev->nc.ie = kmemdup(ie, ie_len, gfp);
> +		ev->nc.ie_len = (ev->nc.ie) ? ie_len : 0;
> +	}
> +
> +	spin_lock_irqsave(&wdev->event_lock, flags);
> +	list_add_tail(&ev->list, &wdev->event_list);
> +	spin_unlock_irqrestore(&wdev->event_lock, flags);
> +	queue_work(cfg80211_wq, &rdev->event_work);

Why schedule out here and all the complexity with that? Seems pointless,
just pass the gfp through to nl80211?


Also, this changes the APIs again. Do you think you could collect the
API changes into a separate patch and combine them in nl80211/cfg80211?

johannes

