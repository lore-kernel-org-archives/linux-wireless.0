Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAIMv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: release multiple ACs in uAPSD, fix more-data bug
Date: Thu,  9 Jan 2014 13:51:20 +0100
Message-Id: <1389271882-15806-3-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135137_861087_7100A0F0)
In-Reply-To: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
References: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a response for PS-Poll or a uAPSD trigger frame is sent, the
more-data bit should be set according to 802.11-2012 11.2.1.5 h),
meaning that it should indicate more data on the relevant ACs
(delivery-enabled or nondelivery-enabled for uAPSD or PS-Poll.)

In, for example, the following scenario:
 * 1 frame on VO queue (either in driver or in mac80211)
 * at least 1 frame on VI queue (in the driver)
 * both VO/VI are delivery-enabled
 * uAPSD trigger frame received

The more-data flag to the driver would not be set, even though
it should be.

While fixing this, I noticed that we should really release frames
from multiple ACs where there's data buffered in the driver for
the corresponding TIDs.

To address all this, restructure the code a bit to consider all
ACs if we only release driver frames or only buffered frames.
This also addresses the more-data bug described above as now the
TIDs will all be marked as released, so the driver will have to
check the number of frames.

While at it, clarify some code and comments and remove the found
variable, replacing it with the appropriate sw/hw release check.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 82 ++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 93bfd67..93e2157 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1245,7 +1245,6 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	bool found = false;
 	bool more_data = false;
 	int ac;
 	unsigned long driver_release_tids = 0;
@@ -1256,9 +1255,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 	__skb_queue_head_init(&frames);
 
-	/*
-	 * Get response frame(s) and more data bit for it.
-	 */
+	/* Get response frame(s) and more data bit for the last one. */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids;
 
@@ -1267,33 +1264,17 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		tids = ieee80211_tids_for_ac(ac);
 
-		if (!found) {
-			driver_release_tids = sta->driver_buffered_tids & tids;
-			if (driver_release_tids) {
-				found = true;
-			} else {
-				struct sk_buff *skb;
-
-				while (n_frames > 0) {
-					skb = skb_dequeue(&sta->tx_filtered[ac]);
-					if (!skb) {
-						skb = skb_dequeue(
-							&sta->ps_tx_buf[ac]);
-						if (skb)
-							local->total_ps_buffered--;
-					}
-					if (!skb)
-						break;
-					n_frames--;
-					found = true;
-					__skb_queue_tail(&frames, skb);
-				}
-			}
+		/* if we already have frames from software, then we can't also
+		 * release from hardware queues
+		 */
+		if (skb_queue_empty(&frames))
+			driver_release_tids |= sta->driver_buffered_tids & tids;
 
-			/*
-			 * If the driver has data on more than one TID then
+		if (driver_release_tids) {
+			/* If the driver has data on more than one TID then
 			 * certainly there's more data if we release just a
-			 * single frame now (from a single TID).
+			 * single frame now (from a single TID). This will
+			 * only happen for PS-Poll.
 			 */
 			if (reason == IEEE80211_FRAME_RELEASE_PSPOLL &&
 			    hweight16(driver_release_tids) > 1) {
@@ -1303,8 +1284,28 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 						driver_release_tids));
 				break;
 			}
+		} else {
+			struct sk_buff *skb;
+
+			while (n_frames > 0) {
+				skb = skb_dequeue(&sta->tx_filtered[ac]);
+				if (!skb) {
+					skb = skb_dequeue(
+						&sta->ps_tx_buf[ac]);
+					if (skb)
+						local->total_ps_buffered--;
+				}
+				if (!skb)
+					break;
+				n_frames--;
+				__skb_queue_tail(&frames, skb);
+			}
 		}
 
+		/* If we have more frames buffered on this AC, then set the
+		 * more-data bit and abort the loop since we can't send more
+		 * data from other ACs before the buffered frames from this.
+		 */
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
 		    !skb_queue_empty(&sta->ps_tx_buf[ac])) {
 			more_data = true;
@@ -1312,7 +1313,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		}
 	}
 
-	if (!found) {
+	if (skb_queue_empty(&frames) && !driver_release_tids) {
 		int tid;
 
 		/*
@@ -1334,10 +1335,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
 
 		ieee80211_send_null_response(sdata, sta, tid, reason);
-		return;
-	}
-
-	if (!driver_release_tids) {
+	} else if (!driver_release_tids) {
 		struct sk_buff_head pending;
 		struct sk_buff *skb;
 		int num = 0;
@@ -1403,12 +1401,12 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/*
 		 * We need to release a frame that is buffered somewhere in the
 		 * driver ... it'll have to handle that.
-		 * Note that, as per the comment above, it'll also have to see
-		 * if there is more than just one frame on the specific TID that
-		 * we're releasing from, and it needs to set the more-data bit
-		 * accordingly if we tell it that there's no more data. If we do
-		 * tell it there's more data, then of course the more-data bit
-		 * needs to be set anyway.
+		 * Note that the driver also has to check the number of frames
+		 * on the TIDs we're releasing from - if there are more than
+		 * n_frames it has to set the more-data bit (if we didn't ask
+		 * it to set it anyway due to other buffered frames); if there
+		 * are fewer than n_frames it has to make sure to adjust that
+		 * to allow the service period to end properly.
 		 */
 		drv_release_buffered_frames(local, sta, driver_release_tids,
 					    n_frames, reason, more_data);
@@ -1416,9 +1414,9 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/*
 		 * Note that we don't recalculate the TIM bit here as it would
 		 * most likely have no effect at all unless the driver told us
-		 * that the TID became empty before returning here from the
+		 * that the TID(s) became empty before returning here from the
 		 * release function.
-		 * Either way, however, when the driver tells us that the TID
+		 * Either way, however, when the driver tells us that the TID(s)
 		 * became empty we'll do the TIM recalculation.
 		 */
 	}
-- 
1.8.5.1

