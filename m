Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2GJJLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:11:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: optimize ieee80211_rx_status struct layout
Date: Tue, 10 Jul 2012 11:11:18 +0200
Message-Id: <1341911478-13342-1-git-send-email-johannes@sipsolutions.net> (sfid-20120710_111127_712290_B064822B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We waste a lot of space in this struct because it uses
int values where smaller ones would be sufficient. The
upcoming A-MPDU information needs some space, optimize
the struct now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c5dbb46..7300cb5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -709,13 +709,13 @@ enum mac80211_rx_flags {
  */
 struct ieee80211_rx_status {
 	u64 mactime;
-	enum ieee80211_band band;
-	int freq;
-	int signal;
-	int antenna;
-	int rate_idx;
-	int flag;
-	unsigned int rx_flags;
+	u16 flag;
+	u16 freq;
+	u8 rate_idx;
+	u8 rx_flags;
+	u8 band;
+	u8 antenna;
+	s8 signal;
 };
 
 /**
-- 
1.7.10.4

