Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:46502 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZGPJHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:07:08 -0400
Received: by bwz28 with SMTP id 28so1917418bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:07:07 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT 2/5] mac80211: advance the state machine immediately if no delay is needed
Date: Thu, 16 Jul 2009 11:07:15 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200907161104.41975.helmut.schaa@gmail.com>
In-Reply-To: <200907161104.41975.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907161107.15922.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of queueing the scan work again without delay just process the
next state immediately.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

---
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a20f9e7..60a4e00 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -585,15 +585,21 @@ void ieee80211_scan_work(struct work_struct *work)
 		return;
 	}
 
-	switch (local->scan_state) {
-	case SCAN_SET_CHANNEL:
-		if (ieee80211_scan_state_set_channel(local, &next_delay))
-			return;
-		break;
-	case SCAN_SEND_PROBE:
-		ieee80211_scan_state_send_probe(local, &next_delay);
-		break;
-	}
+	/*
+	 * as long as no delay is required advance immediately
+	 * without scheduling a new work
+	 */
+	do {
+		switch (local->scan_state) {
+		case SCAN_SET_CHANNEL:
+			if (ieee80211_scan_state_set_channel(local, &next_delay))
+				return;
+			break;
+		case SCAN_SEND_PROBE:
+			ieee80211_scan_state_send_probe(local, &next_delay);
+			break;
+		}
+	} while (next_delay == 0);
 
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
 			   next_delay);
