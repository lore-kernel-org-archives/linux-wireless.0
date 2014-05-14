Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46371 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaENLZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 07:25:29 -0400
Received: by mail-ee0-f51.google.com with SMTP id e51so1272555eek.10
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 04:25:27 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luciano.coelho@intel.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: fix start_radar_detection issue
Date: Wed, 14 May 2014 13:25:04 +0200
Message-Id: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140514_132535_411571_6FB86EE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After patch:
cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()

start_radar_detection always fail with -EINVAL.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/chan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 84d686e..7a679a6 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -340,6 +340,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_UNSPECIFIED:
 		width = cfg80211_chandef_get_width(chandef);
 		if (width < 0)
 			return -EINVAL;
@@ -370,7 +371,6 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
-	case NL80211_IFTYPE_UNSPECIFIED:
 		break;
 	case NUM_NL80211_IFTYPES:
 		WARN_ON(1);
-- 
1.7.9.5

