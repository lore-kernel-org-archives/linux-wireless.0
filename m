Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47242 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbbC3Ofr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:35:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: set QoS capability before changing station state
Date: Mon, 30 Mar 2015 16:35:38 +0200
Message-Id: <1427726138-17745-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_163550_214376_72416847)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the upcoming fast-xmit patch, changing station state will
build a header cache based on the station's capabilities, and
as the QoS capability (sta.wme) impacts the header, it needs
to be set before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 301215be59ef..e4dd2fc34de3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1059,6 +1059,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		}
 	}
 
+	if (mask & BIT(NL80211_STA_FLAG_WME) &&
+	    local->hw.queues >= IEEE80211_NUM_ACS)
+		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);
+
 	/* auth flags will be set later for TDLS stations */
 	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
 		ret = sta_apply_auth_flags(local, sta, mask, set);
@@ -1073,10 +1077,6 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			clear_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
 	}
 
-	if (mask & BIT(NL80211_STA_FLAG_WME) &&
-	    local->hw.queues >= IEEE80211_NUM_ACS)
-		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);
-
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
 		sta->sta.mfp = !!(set & BIT(NL80211_STA_FLAG_MFP));
 		if (set & BIT(NL80211_STA_FLAG_MFP))
-- 
2.1.4

