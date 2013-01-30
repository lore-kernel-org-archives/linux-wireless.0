Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3A3IEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 03:04:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unused SSID from BSS
Date: Wed, 30 Jan 2013 09:05:12 +0100
Message-Id: <1359533112-13100-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_090452_657274_525C3C61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ssid/ssid_len fields in the private BSS
struct are unused, contrary to the comment
we do look up the SSID in the few cases we
need it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae92c47..69febb9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -86,10 +86,6 @@ struct ieee80211_fragment_entry {
 
 
 struct ieee80211_bss {
-	/* don't want to look up all the time */
-	size_t ssid_len;
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-
 	u32 device_ts;
 
 	bool wmm_used;
-- 
1.8.0

