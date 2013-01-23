Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:57578 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3AWOQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:16:11 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] cfg80211: fix channel check in cfg80211_can_use_iftype_chan
Date: Wed, 23 Jan 2013 15:15:57 +0100
Message-Id: <1358950557-24405-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130123_151614_732096_15C2A04C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit "cfg80211: check radar interface combinations" a regression
was introduced which might lead to NULL dereference if the argument
chan = NULL, which might happen in IBSS/wext case (and probably
others).

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/wireless/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1c2795d..d7873c7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1212,7 +1212,8 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_WDS:
-		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
+		radar_required = !!(chan &&
+				    (chan->flags & IEEE80211_CHAN_RADAR));
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-- 
1.7.10.4

