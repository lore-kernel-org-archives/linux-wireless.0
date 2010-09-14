Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0INUG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 16:06:58 -0400
Subject: [PATCH] mac80211: use correct station flags lock
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 22:06:53 +0200
Message-ID: <1284494813.3703.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code is modifying the station flags, and
as such should hold the flags lock so it can
do so atomically vs. other flags modifications
and readers. This issue was introduced when
this code was added in eccb8e8f, as it used
the wrong lock (thus not fixing the race that
was previously documented in a comment.)

Cc: stable@kernel.org [2.6.31+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2010-09-14 22:05:14.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-09-14 22:06:24.000000000 +0200
@@ -591,6 +591,7 @@ static void sta_apply_parameters(struct
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
+	unsigned long flags;
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
@@ -599,7 +600,7 @@ static void sta_apply_parameters(struct
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	spin_lock_bh(&sta->lock);
+	spin_lock_irqsave(&sta->flaglock, flags);
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
@@ -626,7 +627,7 @@ static void sta_apply_parameters(struct
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
 	}
-	spin_unlock_bh(&sta->lock);
+	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID


