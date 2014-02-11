Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaBKLre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 06:47:34 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH] mac80211: fix IE buffer len
Date: Tue, 11 Feb 2014 13:45:41 +0200
Message-Id: <1392119141-27279-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140211_124737_971041_969091B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Remove size of SSID IE from the IE buffer in scan and
sched scan, since this IE isn't added to this buffer.

Change-Id: Ic381cd50566529907c3a37f6aaa02d9132fd99da
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/30710
Tested-by: IWL Jenkins
Reviewed-by: EliadX Peller <eliad@wizery.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 88c8161..b211e41 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -472,9 +472,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		u8 *ies;
 
-		local->hw_scan_ies_bufsize = 2 + IEEE80211_MAX_SSID_LEN +
-					     local->scan_ies_len +
-					     req->ie_len;
+		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
 		local->hw_scan_req = kmalloc(
 				sizeof(*local->hw_scan_req) +
 				req->n_channels * sizeof(req->channels[0]) +
@@ -979,8 +977,7 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	int ret, i, iebufsz;
 
-	iebufsz = 2 + IEEE80211_MAX_SSID_LEN +
-		  local->scan_ies_len + req->ie_len;
+	iebufsz = local->scan_ies_len + req->ie_len;
 
 	lockdep_assert_held(&local->mtx);
 
-- 
1.8.3.2

