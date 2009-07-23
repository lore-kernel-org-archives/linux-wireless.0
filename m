Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38343 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZGWKNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:13:40 -0400
Received: by mail-fx0-f218.google.com with SMTP id 18so715131fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:13:40 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/7] mac80211: advance the state machine immediately if no
	delay is needed
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:13:48 +0200
Message-ID: <20090723101348.5147.92831.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of queueing the scan work again without delay just process the
next state immediately.
    
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/scan.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 71500f1..db122e4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -587,15 +587,21 @@ void ieee80211_scan_work(struct work_struct *work)
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

