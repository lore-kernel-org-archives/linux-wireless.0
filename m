Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43340 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3AYTs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 14:48:57 -0500
Received: by mail-pb0-f42.google.com with SMTP id rp2so400434pbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 11:48:56 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	simon.wunderlich@s2003.tu-chemnitz.de,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] cfg80211: don't dereference NULL chan
Date: Fri, 25 Jan 2013 11:47:55 -0800
Message-Id: <1359143275-28359-1-git-send-email-thomas@cozybit.com> (sfid-20130125_204900_652355_81D744E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "cfg80211: check radar interface combinations"
would dereference chan even though this may be NULL. Fix a
page fault when adding a new interface by adding a
short-circuit check for NULL.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

No action required for this to make it into 3.8, right?

 net/wireless/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1c2795d..d1decbc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1212,7 +1212,8 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_WDS:
-		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
+		radar_required = !!(chan &&
+				    chan->flags & IEEE80211_CHAN_RADAR);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-- 
1.7.10.4

