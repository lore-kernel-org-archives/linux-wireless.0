Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46328 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbeIRT6R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 15:58:17 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Eliad Peller <eliad@wizery.com>
Subject: [PATCH] mac80211: allow scans on radar channels, unless there is CAC or CSA
Date: Tue, 18 Sep 2018 16:16:33 +0200
Message-Id: <20180918141633.10282-1-sw@simonwunderlich.de> (sfid-20180918_162536_979944_8FE9CF87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Operating on a DFS channel doesn't mean we can't leave it for a short
time - actually, some features like off-channel CAC work by leaving the
operation channel to check other channels for availability (although
off-channel CAC isn't implemented in mac80211). In our case, we want to
use mesh while doing background surveys on other channels from time to
time.

Therefore, we can enable scans while on DFS channels, unless there is
CAC going on (must be continuous) or a CSA is happening.

Reported-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Cc: Eliad Peller <eliad@wizery.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 47d2ed570470..58a454515a5a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -477,8 +477,11 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
 static bool ieee80211_can_scan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata)
 {
-	if (ieee80211_is_radar_required(local))
-		return false;
+	if (sdata->wdev.cac_started)
+		return -EBUSY;
+
+	if (sdata->vif.csa_active)
+		return -EBUSY;
 
 	if (!list_empty(&local->roc_list))
 		return false;
@@ -550,7 +553,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->scan_req || ieee80211_is_radar_required(local))
+	if (local->scan_req)
 		return -EBUSY;
 
 	if (!ieee80211_can_scan(local, sdata)) {
-- 
2.11.0
