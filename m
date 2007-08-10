Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbXHJVmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:42:08 -0400
Subject: [PATCH] hostapd: remove use of  ieee80211_msg_key_threshold_notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:44:45 +0200
Message-Id: <1186782285.17351.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code is #if 0'ed anyway, so might as well not use the constant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-10 23:42:58.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-10 23:43:43.000000000 +0200
@@ -1342,13 +1342,17 @@ static void handle_frame(struct hostapd_
 		return;
 	}
 #endif
+# if 0
+/* TODO
+ * get key notification from kernel again... it doesn't give one now
+ * because this code doesn't care
+ */
 	if (msg_type == ieee80211_msg_key_threshold_notification) {
-#if 0 /* TODO */
 		ieee802_11_key_threshold_notification(iface->bss[0], buf,
 						      data_len);
-#endif
 		return;
 	}
+#endif
 
 	/* PS-Poll frame from not associated is 16 bytes. All other frames
 	 * passed to hostapd are 24 bytes or longer.


