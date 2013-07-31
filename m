Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3GaTCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:02:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] cfg80211: fix P2P GO interface teardown
Date: Wed, 31 Jul 2013 21:02:27 +0200
Message-Id: <1375297347-1380-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_210237_569724_A4F81D1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a P2P GO interface goes down, cfg80211 doesn't properly
tear it down, leading to warnings later. Add the GO interface
type to the enumeration to tear it down like AP interfaces.
Otherwise, we leave it pending and mac80211's state can get
very confused, leading to warnings later.

Cc: stable@vger.kernel.org
Reported-by: Ilan Peer <ilan.peer@intel.com>
Tested-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4f9f216..a8c29fa4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -765,6 +765,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		cfg80211_leave_mesh(rdev, dev);
 		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		cfg80211_stop_ap(rdev, dev);
 		break;
 	default:
-- 
1.8.0

