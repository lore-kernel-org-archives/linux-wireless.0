Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3BEKoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 05:44:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: fix radar check for P2P_DEVICE
Date: Tue,  5 Feb 2013 11:44:30 +0100
Message-Id: <1360061070-15314-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_114412_543740_77C7C673)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Radar is not required for P2P_DEVICE interfaces.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d7873c7..37a56ee 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1217,10 +1217,10 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_MONITOR:
 		radar_required = false;
 		break;
-	case NL80211_IFTYPE_P2P_DEVICE:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
-- 
1.8.0

