Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2HASWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 14:22:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reset station MLME flags upon new association
Date: Wed,  1 Aug 2012 20:21:59 +0200
Message-Id: <1343845319-22113-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_202208_640686_FADACD7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When associating anew, the old station MLME flags should
be cleared. The only exception is the 40 MHz disable
flag as it might have been set while the channel was set
in a previous authentication attempt so it needs to be
kept intact.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c416a08..9d60b49 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3357,10 +3357,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* prepare assoc data */
-
-	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
-	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
-	ifmgd->flags &= ~IEEE80211_STA_DISABLE_VHT;
+	
+	/*
+	 * keep only the 40 MHz disable bit set as it might have
+	 * been set during authentication already, all other bits
+	 * should be reset for a new connection
+	 */
+	ifmgd->flags &= IEEE80211_STA_DISABLE_40MHZ;
 
 	ifmgd->beacon_crc_valid = false;
 
-- 
1.7.10.4

