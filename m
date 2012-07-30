Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2G3R7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 13:59:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: enable WDS carrier only after adding station
Date: Mon, 30 Jul 2012 19:59:31 +0200
Message-Id: <1343671171-9768-1-git-send-email-johannes@sipsolutions.net> (sfid-20120730_195936_996417_3053D468)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Enable the carrier on WDS type interfaces only
after having added the station entry for the
WDS peer so outgoing frames will find it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4787351..e3a2eb1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -546,6 +546,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		case NL80211_IFTYPE_MESH_POINT:
 			netif_carrier_off(dev);
 			break;
+		case NL80211_IFTYPE_WDS:
+			break;
 		default:
 			netif_carrier_on(dev);
 		}
@@ -580,6 +582,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 		}
 
 		rate_control_rate_init(sta);
+		netif_carrier_on(dev);
 	}
 
 	/*
-- 
1.7.10.4

