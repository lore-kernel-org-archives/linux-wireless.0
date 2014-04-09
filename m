Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbaDIUjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:39:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: stefan.pietsch@lsexperts.de,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: reject invalid IBSS BSSIDs in wext compat code
Date: Wed,  9 Apr 2014 22:39:24 +0200
Message-Id: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net> (sfid-20140409_223938_435361_2687194B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Don't allow using a multicast address as the BSSID, that
isn't a valid configuration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 071e99c75e82..a953a60b4f41 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -481,6 +481,9 @@ int cfg80211_ibss_wext_siwap(struct net_device *dev,
 	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
 		bssid = NULL;
 
+	if (bssid && !is_valid_ether_addr(bssid))
+		return -EINVAL;
+
 	/* both automatic */
 	if (!bssid && !wdev->wext.ibss.bssid)
 		return 0;
-- 
1.9.0

