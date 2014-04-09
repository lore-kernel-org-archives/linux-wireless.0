Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934092AbaDIUjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:39:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: stefan.pietsch@lsexperts.de,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: ignore invalid BSSIDs when looking for BSSes
Date: Wed,  9 Apr 2014 22:39:25 +0200
Message-Id: <1397075965-2684-2-git-send-email-johannes@sipsolutions.net> (sfid-20140409_223940_590183_8E2534E2)
In-Reply-To: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net>
References: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When looking for a BSS matching given parameters, ignore invalid
BSSIDs. This avoids, for example, trying to join an IBSS that has
a multicast BSSID, which isn't supported by all drivers nor is it
a valid configuration of the IBSS so better create a new one with
a correctly chosen random BSSID.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7d09a712cb1f..746c56ebd66c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -540,6 +540,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (channel && bss->pub.channel != channel)
 			continue;
+		if (!is_valid_ether_addr(bss->pub.bssid))
+			continue;
 		/* Don't get expired BSS structs */
 		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
 		    !atomic_read(&bss->hold))
-- 
1.9.0

