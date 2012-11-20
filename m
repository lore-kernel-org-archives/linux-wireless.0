Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2KTVjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:39:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: remove printing scan config
Date: Tue, 20 Nov 2012 22:40:04 +0100
Message-Id: <1353447604-16327-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_223939_351202_C7318DE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The frequencies will be printed when actually
doing the scan, and the IEs can be captured
on the hwsim0 monitor.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f1c05d5..2aa8a1a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1367,7 +1367,6 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 				  struct cfg80211_scan_request *req)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
-	int i;
 
 	mutex_lock(&hwsim->mutex);
 	if (WARN_ON(hwsim->tmp_chan || hwsim->hw_scan_request)) {
@@ -1380,11 +1379,6 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	mutex_unlock(&hwsim->mutex);
 
 	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
-	for (i = 0; i < req->n_channels; i++)
-		printk(KERN_DEBUG "hwsim hw_scan freq %d\n",
-			req->channels[i]->center_freq);
-	print_hex_dump(KERN_DEBUG, "scan IEs: ", DUMP_PREFIX_OFFSET,
-			16, 1, req->ie, req->ie_len, 1);
 
 	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan, 0);
 
-- 
1.8.0

