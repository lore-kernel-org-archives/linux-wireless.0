Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaATMAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 07:00:08 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W5DWP-0007i3-ST
	for linux-wireless@vger.kernel.org; Mon, 20 Jan 2014 13:00:06 +0100
Message-ID: <1390219203.4335.22.camel@jlt4.sipsolutions.net> (sfid-20140120_130012_303574_E227372E)
Subject: [PATCH] mac80211: Fix ROC duration == 0 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Jan 2014 13:00:03 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

In case the given ROC duration is 0, update it to a minimal value before
setting the ieee80211_roc_work parameters, so it also would be valid
for cases where scan is in progress or there are other ROCs queued.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 032081c..e9ae299 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2628,6 +2628,18 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!roc)
 		return -ENOMEM;
 
+	/*
+	 * If the duration is zero, then the driver
+	 * wouldn't actually do anything. Set it to
+	 * 10 for now.
+	 *
+	 * TODO: cancel the off-channel operation
+	 *       when we get the SKB's TX status and
+	 *       the wait time was zero before.
+	 */
+	if (!duration)
+		duration = 10;
+
 	roc->chan = channel;
 	roc->duration = duration;
 	roc->req_duration = duration;
@@ -2651,18 +2663,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 	/* otherwise actually kick it off here (for error handling) */
 
-	/*
-	 * If the duration is zero, then the driver
-	 * wouldn't actually do anything. Set it to
-	 * 10 for now.
-	 *
-	 * TODO: cancel the off-channel operation
-	 *       when we get the SKB's TX status and
-	 *       the wait time was zero before.
-	 */
-	if (!duration)
-		duration = 10;
-
 	ret = drv_remain_on_channel(local, sdata, channel, duration, type);
 	if (ret) {
 		kfree(roc);
-- 
1.8.5.1



