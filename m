Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59467 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab2GLOFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:05:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com
Subject: [PATCH] cfg80211: ignore channel state for stopped AP interfaces
Date: Thu, 12 Jul 2012 16:05:28 +0200
Message-Id: <1342101928-16639-1-git-send-email-nbd@openwrt.org> (sfid-20120712_160537_106663_98047F1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this change, running AP + station on the same wiphy does not work
since the commit "cfg80211: add channel checking for iface combinations".
The stopped AP prevents the client from connecting to an AP on a different
channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/chan.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 434c56b..0840d38 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -137,8 +137,10 @@ cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
-		*chan = wdev->channel;
-		*chanmode = CHAN_MODE_SHARED;
+		if (wdev->beacon_interval) {
+			*chan = wdev->channel;
+			*chanmode = CHAN_MODE_SHARED;
+		}
 		return;
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
-- 
1.7.3.2

