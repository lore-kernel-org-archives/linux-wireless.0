Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38645 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933860AbaHZHqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 03:46:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.17] Revert "mac80211: disable uAPSD if all ACs are under ACM"
Date: Tue, 26 Aug 2014 09:46:09 +0200
Message-Id: <1409039169-9112-1-git-send-email-johannes@sipsolutions.net> (sfid-20140826_094659_974342_FA0B437B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 24aa11ab8ae03292d38ec0dbd9bc2ac49fe8a6dd.

That commit was wrong since it uses data that hasn't even been set
up yet, but might be a hold-over from a previous connection.

Additionally, it seems like a driver-specific workaround that
shouldn't have been in mac80211 to start with.

Cc: stable@vger.kernel.org
Fixes: 24aa11ab8ae0 ("mac80211: disable uAPSD if all ACs are under ACM")
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 31a8afaf7332..b82a12a9f0f1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4376,8 +4376,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
-	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD) &&
-	    sdata->wmm_acm != 0xff) {
+	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
 		assoc_data->uapsd = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-- 
2.0.0

