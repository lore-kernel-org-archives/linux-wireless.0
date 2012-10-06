Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46408 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab2JFMlP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 08:41:15 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	johannes@sipsolutions.net, arend@broadcom.com
Subject: [PATCH v2 3.7 1/2] cfg80211: fix antenna gain handling
Date: Sat,  6 Oct 2012 14:40:53 +0200
Message-Id: <1349527254-41080-1-git-send-email-nbd@openwrt.org> (sfid-20121006_144119_373902_3E5F032E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No driver initializes chan->max_antenna_gain to something sensible, and
the only place where it is being used right now is inside ath9k. This
leads to ath9k potentially using less tx power than it can use.

Rather than going through every single driver, this patch initializes
chan->orig_mag in wiphy_register(), ignoring whatever value the driver
left in there. If a driver for some reason wishes to limit it independent
from regulatory rulesets, it can do so internally.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/wireless/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 443d4d7..3f72530 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
 		for (i = 0; i < sband->n_channels; i++) {
 			sband->channels[i].orig_flags =
 				sband->channels[i].flags;
-			sband->channels[i].orig_mag =
-				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mag = INT_MAX;
 			sband->channels[i].orig_mpwr =
 				sband->channels[i].max_power;
 			sband->channels[i].band = band;
-- 
1.7.9.6 (Apple Git-31.1)

