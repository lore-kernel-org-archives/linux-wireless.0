Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0L2Iz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 03:55:58 -0500
Subject: Re: cfg80211 warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Vipin Mehta <vmehta@atheros.com>
Cc: lrodriguez@atheros.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101229021535.GA17397@vmehta-desktop>
References: <20101229021535.GA17397@vmehta-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 09:55:55 +0100
Message-ID: <1293612955.3546.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 18:15 -0800, Vipin Mehta wrote:

>      I was testing a cfg80211 driver when I encountered the following
> warning in the function core.c:wdev_cleanup_work().
> 
>         if (WARN_ON(rdev->scan_req && rdev->scan_req->dev ==
> wdev->netdev)) {
>                 rdev->scan_req->aborted = true;
>                 ___cfg80211_scan_done(rdev, true);
>         }
> 
> Soon enough it leads to another warning in the function
> scan.c:cfg80211_scan_done() when the pending scan operation completes.
>         WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
> 
> The sequence of operation is:
> 1) Connect to an open access point.
> 2) Disconnect.
> 3) Scan via a call to nl80211_trigger_scan.
> 4) A call to cfg80211_netdev_notifier_call() with the state
> NETDEV_GOING_DOWN while the previous scan operation is pending.
> 5) A call to cfg80211_netdev_notifier_call() with the state
> NETDEV_DOWN while the previous scan operation is pending.
> 
> The first warning is observed after step 5) because of a pending scan
> request. The second warning is seen when the driver returns the scan
> results once the pending scan operation is completed. This is because
> cfg80211 had already freed up the pending scan request in the context
> of NETDEV_DOWN.
> 
> Unfortunately, I dont see a way for the cfg80211 driver to get
> notified when the interface is going down since the driver could have
> aborted the pending scan in that case.
> 
> Is the above sequence of operations valid and is cfg80211 expected to
> handle it without the warnings? Is the driver missing some hooks?

The driver is expected to abort scans when interfaces go down, and it
can know that from the mac80211 stop() callback, or the netdev's
ndo_stop() callback (for pure cfg80211 drivers).

johannes

