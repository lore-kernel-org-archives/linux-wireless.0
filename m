Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2G0Kwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 06:52:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: supress HT/VHT disable if not supported
Date: Fri, 27 Jul 2012 12:52:35 +0200
Message-Id: <1343386355-2269-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_125245_307379_8BB99DBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If HT/VHT isn't supported by us we shouldn't print
a message that we disabled it, do that only if the
AP didn't support WMM and we therefore disable it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f0d6fa2..d068eea 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3358,16 +3358,18 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (!sband->ht_cap.ht_supported ||
 	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
-		netdev_info(sdata->dev,
-			    "disabling HT as WMM/QoS is not supported\n");
+		if (!bss->wmm_used)
+			netdev_info(sdata->dev,
+				    "disabling HT as WMM/QoS is not supported by the AP\n");
 	}
 
 	/* disable VHT if we don't support it or the AP doesn't use WMM */
 	if (!sband->vht_cap.vht_supported ||
 	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
-		netdev_info(sdata->dev,
-			    "disabling VHT as WMM/QoS is not supported\n");
+		if (!bss->wmm_used)
+			netdev_info(sdata->dev,
+				    "disabling VHT as WMM/QoS is not supported by the AP\n");
 	}
 
 	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
-- 
1.7.10.4

