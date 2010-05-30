Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0E3Mxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 May 2010 08:53:48 -0400
Subject: [PATCH] mac80211: drop control frames after processing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 14:53:43 +0200
Message-ID: <1275224023.3599.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After ieee80211_rx_h_ctrl() processing we only
want to process management (including action)
frames, so there's no point in letting control
frames continue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-05-30 14:49:30.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-30 14:50:13.000000000 +0200
@@ -1853,7 +1853,12 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		return RX_QUEUED;
 	}
 
-	return RX_CONTINUE;
+	/*
+	 * After this point, we only want management frames,
+	 * so we can drop all remaining control frames to
+	 * cooked monitor interfaces.
+	 */
+	return RX_DROP_MONITOR;
 }
 
 static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,


