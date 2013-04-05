Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161541Ab3DENEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 09:04:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: disable uAPSD if all ACs are under ACM
Date: Fri,  5 Apr 2013 15:04:31 +0200
Message-Id: <1365167071-2450-1-git-send-email-johannes@sipsolutions.net> (sfid-20130405_150446_432380_9604795F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

It's unlikely that an AP requires WMM mandatory admission control
for all access categories, and if it does then we still transmit
on the background AC without requesting admission. However, avoid
using uAPSD in this case since the implementation could run into
issues and might use other ACs etc.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 304d6cf..43bfa81 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4086,7 +4086,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
-	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
+	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD) &&
+	    sdata->wmm_acm != 0xff) {
 		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-- 
1.8.0

