Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48491 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2LACaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 21:30:20 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC] cfg80211: fix channel error on mesh join
Date: Fri, 30 Nov 2012 18:30:09 -0800
Message-Id: <1354329009-25513-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121201_033033_391590_53C8E9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix an error on mesh join when no channel has been explicitly set beforehand.

Previously a WARN_ON was hit in cfg80211_reg_can_beacon because center_freq1
was not set.

Also fix double semicolon.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/wireless/mesh.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index f7b2da6..989b6ce 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -145,6 +145,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 						   IEEE80211_CHAN_RADAR))
 					continue;
 				setup->chandef.chan = chan;
+				setup->chandef.center_freq1 = chan->center_freq;
 				break;
 			}
 
@@ -156,7 +157,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		if (!setup->chandef.chan)
 			return -EINVAL;
 
-		setup->chandef.width = NL80211_CHAN_WIDTH_20_NOHT;;
+		setup->chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
 	}
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
-- 
1.7.9.5

