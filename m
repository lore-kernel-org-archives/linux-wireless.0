Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46887 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933869AbcJTSpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 14:45:38 -0400
Message-ID: <1476989132.14078.12.camel@sipsolutions.net> (sfid-20161020_204541_792248_EEECE3EB)
Subject: Re: cfg80211: race problem between suspend and disconnect event
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Date: Thu, 20 Oct 2016 20:45:32 +0200
In-Reply-To: <67400d1c5c2141b3af75bdce9ec43840@SC-EXCH04.marvell.com>
References: <67400d1c5c2141b3af75bdce9ec43840@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Mwifiex driver rejects del_key() requests from cfg80211 during
> suspend. They came very late when driver's cfg80211_suspend handler
> is already executed and driver is in the middle of SDIO's suspend
> handler.

Interesting. Rejecting those calls is probably perfectly reasonable,
and in fact it's not clear to me why we even try to delete the keys
after we've disconnected - any driver implementation should have
removed them already anyway? You probably don't actually care about the
key removal either?

That said though, there's also the critical protocol stop and the
set_qos_map(NULL) call, which removes the QoS mapping. It doesn't look
like you support this right now in your driver, but in any case it'd be
pretty strange to have that happen after or during suspend.

> Please let us know if you have any suggestions to resolves this with
> cfg80211/driver change.

For cfg80211 we could do something like this:

--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -104,13 +104,16 @@ static int wiphy_suspend(struct device *dev)
 
 	rtnl_lock();
 	if (rdev->wiphy.registered) {
-		if (!rdev->wiphy.wowlan_config)
+		if (!rdev->wiphy.wowlan_config) {
 			cfg80211_leave_all(rdev);
+			cfg80211_process_rdev_events(rdev);
+		}
 		if (rdev->ops->suspend)
 			ret = rdev_suspend(rdev, rdev->wiphy.wowlan_config);
 		if (ret == 1) {
 			/* Driver refuse to configure wowlan */
 			cfg80211_leave_all(rdev);
+			cfg80211_process_rdev_events(rdev);
 			ret = rdev_suspend(rdev, NULL);
 		}
 	}


However, that assumes that you actually cfg80211_disconnected()
synchronously while being asked to disconnect, which doesn't seem to be
true from looking at mwifiex, if HostCmd_CMD_802_11_DEAUTHENTICATE
command can be sent to the firmware then you wait for EVENT_LINK_LOST,
EVENT_DEAUTHENTICATED or EVENT_DISASSOCIATED to come back from the
firmware, so this cfg80211 change won't help.


So somehow you'd have to synchronize with the firmware as well, to
process all those things before suspend, I guess?

We could then export cfg80211_process_rdev_events() as
cfg80211_process_wiphy_events() or so, so that you can call that at an
appropriate place from your suspend handler, after having synchronized
with the firmware?

johannes
