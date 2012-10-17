Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42521 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab2JQL4c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 07:56:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: [PATCH v3 3.7 1/2] cfg80211: fix antenna gain handling
Date: Wed, 17 Oct 2012 13:56:19 +0200
Message-Id: <1350474980-59623-1-git-send-email-nbd@openwrt.org> (sfid-20121017_135640_599562_9A719EDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No driver initializes chan->max_antenna_gain to something sensible, and
the only place where it is being used right now is inside ath9k. This
leads to ath9k potentially using less tx power than it can use, which can
decrease performance/range in some rare cases.

Rather than going through every single driver, this patch initializes
chan->orig_mag in wiphy_register(), ignoring whatever value the driver
left in there. If a driver for some reason wishes to limit it independent
from regulatory rulesets, it can do so internally.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/wireless/core.c | 3 +--
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
1.7.12.2

