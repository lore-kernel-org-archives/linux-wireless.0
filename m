Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57311 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1GZKSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 06:18:42 -0400
Received: by eye22 with SMTP id 22so398866eye.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 03:18:41 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Stop TX BA session if buf_size is zero
Date: Tue, 26 Jul 2011 12:18:27 +0200
Message-Id: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110726_121846_239425_5ADF43A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we receive an ADDBA response with status code 0 and a buf_size of 0
we should stop the TX BA session as otherwise we'll end up queuing
frames in ieee80211_tx_prep_agg forever instead of sending them out as
non AMPDUs.

This fixes a problem with AVM Fritz Stick N wireless devices where
frames to this device are not transmitted anymore by mac80211.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/agg-tx.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c8be8ef..b7075f3 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -777,18 +777,14 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
 #endif
-
+	/*
+	 * IEEE 802.11-2007 7.3.1.14:
+	 * In an ADDBA Response frame, when the Status Code field
+	 * is set to 0, the Buffer Size subfield is set to a value
+	 * of at least 1.
+	 */
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
-			== WLAN_STATUS_SUCCESS) {
-		/*
-		 * IEEE 802.11-2007 7.3.1.14:
-		 * In an ADDBA Response frame, when the Status Code field
-		 * is set to 0, the Buffer Size subfield is set to a value
-		 * of at least 1.
-		 */
-		if (!buf_size)
-			goto out;
-
+			== WLAN_STATUS_SUCCESS && buf_size) {
 		if (test_and_set_bit(HT_AGG_STATE_RESPONSE_RECEIVED,
 				     &tid_tx->state)) {
 			/* ignore duplicate response */
-- 
1.7.3.4

