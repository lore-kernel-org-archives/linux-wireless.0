Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2LGK63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:58:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wext: explicitly cast -110 to u8
Date: Fri,  7 Dec 2012 11:58:49 +0100
Message-Id: <1354877929-7678-1-git-send-email-johannes@sipsolutions.net> (sfid-20121207_115832_350042_2BC788F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This doesn't generate any different code, but will
suppress a spurious smatch warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index f9680c9..d997d0f 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -176,7 +176,7 @@ int cfg80211_wext_giwrange(struct net_device *dev,
 	case CFG80211_SIGNAL_TYPE_NONE:
 		break;
 	case CFG80211_SIGNAL_TYPE_MBM:
-		range->max_qual.level = -110;
+		range->max_qual.level = (u8)-110;
 		range->max_qual.qual = 70;
 		range->avg_qual.qual = 35;
 		range->max_qual.updated |= IW_QUAL_DBM;
-- 
1.8.0

