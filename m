Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49558 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbcCHLfh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:35:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Fix BW upgrade for TDLS peers
Date: Tue,  8 Mar 2016 13:35:31 +0200
Message-Id: <1457436931-2330-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160308_123541_163057_9AB96DD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

It is possible that the station is connected to an AP
with bandwidth of 80+80MHz or 160MHz. In such cases
there is no need to perform an upgrade as the maximal
supported bandwidth is 80MHz.

In addition, when upgrading and setting center_freq1
and bandwidth to 80MHz also set center_freq2 to 0.

Fixes: 0fabfaafec3a ("mac80211: upgrade BW of TDLS peers when possible"
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index eed1152..a29ea81 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -314,7 +314,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 	if (max_width > NL80211_CHAN_WIDTH_80)
 		max_width = NL80211_CHAN_WIDTH_80;
 
-	if (uc.width == max_width)
+	if (uc.width >= max_width)
 		return;
 	/*
 	 * Channel usage constrains in the IEEE802.11ac-2013 specification only
@@ -325,6 +325,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < ARRAY_SIZE(centers_80mhz); i++)
 		if (abs(uc.chan->center_freq - centers_80mhz[i]) <= 30) {
 			uc.center_freq1 = centers_80mhz[i];
+			uc.center_freq2 = 0;
 			uc.width = NL80211_CHAN_WIDTH_80;
 			break;
 		}
-- 
2.5.0

