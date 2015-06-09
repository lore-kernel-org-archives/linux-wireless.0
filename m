Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54726 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbbFITfs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:35:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: davem@davemloft.net, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Alexander Kaltsas <alexkaltsas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.1] cfg80211: wext: clear sinfo struct before calling driver
Date: Tue,  9 Jun 2015 21:35:44 +0200
Message-Id: <1433878544-10749-1-git-send-email-johannes@sipsolutions.net> (sfid-20150609_213556_771439_75095DFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Until recently, mac80211 overwrote all the statistics it could
provide when getting called, but it now relies on the struct
having been zeroed by the caller. This was always the case in
nl80211, but wext used a static struct which could even cause
values from one device leak to another.

Using a static struct is OK (as even documented in a comment)
since the whole usage of this function and its return value is
always locked under RTNL. Not clearing the struct for calling
the driver has always been wrong though, since drivers were
free to only fill values they could report, so calling this
for one device and then for another would always have leaked
values from one to the other.

Fix this by initializing the structure in question before the
driver method call.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=99691

Cc: stable@vger.kernel.org
Reported-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Reported-by: Alexander Kaltsas <alexkaltsas@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Dave, would you mind applying this patch directly? It seems a
bit pointless to send a pull request for a single patch again.
---
 net/wireless/wext-compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index fff1bef6ed6d..fd682832a0e3 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1333,6 +1333,8 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	wdev_unlock(wdev);
 
+	memset(&sinfo, 0, sizeof(sinfo));
+
 	if (rdev_get_station(rdev, dev, bssid, &sinfo))
 		return NULL;
 
-- 
2.1.4

