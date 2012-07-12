Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46110 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab2GLOKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 10:10:05 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com
Subject: [PATCH v2] cfg80211: ignore channel state for stopped AP/mesh interfaces
Date: Thu, 12 Jul 2012 16:10:02 +0200
Message-Id: <1342102202-21045-1-git-send-email-nbd@openwrt.org> (sfid-20120712_161010_431220_E73C7A0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this change, running AP + station on the same wiphy does not work
since the commit "cfg80211: add channel checking for iface combinations".
The stopped AP prevents the client from connecting to an AP on a different
channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/chan.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 434c56b..1e03e04 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -136,9 +136,16 @@ cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
+		if (wdev->beacon_interval) {
+			*chan = wdev->channel;
+			*chanmode = CHAN_MODE_SHARED;
+		}
+		return;
 	case NL80211_IFTYPE_MESH_POINT:
-		*chan = wdev->channel;
-		*chanmode = CHAN_MODE_SHARED;
+		if (wdev->mesh_id_len) {
+			*chan = wdev->channel;
+			*chanmode = CHAN_MODE_SHARED;
+		}
 		return;
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
-- 
1.7.3.2

