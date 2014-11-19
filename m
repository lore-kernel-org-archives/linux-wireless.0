Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39948 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbaKSRc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:32:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH] mac80211: remove redundant check
Date: Wed, 19 Nov 2014 18:32:54 +0100
Message-Id: <1416418374-6987-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183301_765412_71BC4595)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

local->scan_req was tested in the previous line, so it
can't be NULL.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index af0d094b2f2f..d23c8d90c3b4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -799,7 +799,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	if (!sdata || !local->scan_req)
 		goto out;
 
-	if (local->scan_req && !local->scanning) {
+	if (!local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
 		int rc;
 
-- 
2.1.1

