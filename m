Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0EKKmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 06:42:08 -0400
Subject: [PATCH 2.6.34] mac80211: don't process work item with wrong frame
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 12:42:04 +0200
Message-ID: <1273574524.3669.51.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we process a frame, we currently just match it
to the work struct by the MAC addresses, and not by
the work type. This means that we can end up doing
the work for an association request item when (for
whatever reason) we receive another frame type, for
example a probe response. Processing the wrong type
of frame will lead to completely invalid data being
processed, and will lead to various problems like
thinking the association was successful even if the
AP never sent an assocation response.

Fix this by making each processing function check
that it is invoked for the right work struct type
only and continue processing otherwise (and drop
frames that we didn't expect).

This bug was uncovered during the debugging for
https://bugzilla.kernel.org/show_bug.cgi?id=15862
but doesn't seem to be the cause for any of the
various problems reported there.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sorry. This is a dumb bug :(

 net/mac80211/work.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/work.c	2010-05-11 09:56:43.000000000 +0200
+++ wireless-testing/net/mac80211/work.c	2010-05-11 10:04:13.000000000 +0200
@@ -33,6 +33,7 @@
 #define IEEE80211_MAX_PROBE_TRIES 5
 
 enum work_action {
+	WORK_ACT_MISMATCH,
 	WORK_ACT_NONE,
 	WORK_ACT_TIMEOUT,
 	WORK_ACT_DONE,
@@ -585,7 +586,7 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 	u16 auth_alg, auth_transaction, status_code;
 
 	if (wk->type != IEEE80211_WORK_AUTH)
-		return WORK_ACT_NONE;
+		return WORK_ACT_MISMATCH;
 
 	if (len < 24 + 6)
 		return WORK_ACT_NONE;
@@ -636,6 +637,9 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	struct ieee802_11_elems elems;
 	u8 *pos;
 
+	if (wk->type != IEEE80211_WORK_ASSOC)
+		return WORK_ACT_MISMATCH;
+
 	/*
 	 * AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function.
@@ -691,6 +695,12 @@ ieee80211_rx_mgmt_probe_resp(struct ieee
 
 	ASSERT_WORK_MTX(local);
 
+	if (wk->type != IEEE80211_WORK_DIRECT_PROBE)
+		return WORK_ACT_MISMATCH;
+
+	if (len < 24 + 12)
+		return WORK_ACT_NONE;
+
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return WORK_ACT_NONE;
@@ -705,7 +715,7 @@ static void ieee80211_work_rx_queued_mgm
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_work *wk;
-	enum work_action rma = WORK_ACT_NONE;
+	enum work_action rma;
 	u16 fc;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
@@ -752,7 +762,17 @@ static void ieee80211_work_rx_queued_mgm
 			break;
 		default:
 			WARN_ON(1);
+			rma = WORK_ACT_NONE;
 		}
+
+		/*
+		 * We've either received an unexpected frame, or we have
+		 * multiple work items and need to match the frame to the
+		 * right one.
+		 */
+		if (rma == WORK_ACT_MISMATCH)
+			continue;
+
 		/*
 		 * We've processed this frame for that work, so it can't
 		 * belong to another work struct.
@@ -762,6 +782,9 @@ static void ieee80211_work_rx_queued_mgm
 	}
 
 	switch (rma) {
+	case WORK_ACT_MISMATCH:
+		/* ignore this unmatched frame */
+		break;
 	case WORK_ACT_NONE:
 		break;
 	case WORK_ACT_DONE:


