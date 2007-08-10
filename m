Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXHJVfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:35:24 -0400
Subject: [PATCH] hostapd: don't reference ieee80211_msg_sta_not_assoc if  it's unused anyway
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:38:01 +0200
Message-Id: <1186781881.17351.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hostapd doesn't do anything about such frames. Kernel no longer sends
them and the constant was removed, so let's not reference it any longer.


Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-10 23:33:19.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-10 23:35:10.000000000 +0200
@@ -1351,9 +1351,12 @@ static void handle_frame(struct hostapd_
 	}
 
 	/* PS-Poll frame from not associated is 16 bytes. All other frames
-	 * passed to hostapd are 24 bytes or longer. */
-	if (len < 24 &&
-	    (msg_type != ieee80211_msg_sta_not_assoc || len < 16)) {
+	 * passed to hostapd are 24 bytes or longer.
+	 * Right now, the kernel doesn't send us any frames from not-associated
+	 * because the code here doesn't care. TODO: add support to kernel
+	 * and send DEAUTH/DISASSOC to them...
+	 */
+	if (len < 24) {
 		printf("handle_frame: too short (%lu), type %d\n",
 		       (unsigned long) len, msg_type);
 		return;
@@ -1425,9 +1428,15 @@ static void handle_frame(struct hostapd_
 	case ieee80211_msg_michael_mic_failure:
 		hostapd_michael_mic_failure(hapd, buf, data_len);
 		return;
-	case ieee80211_msg_sta_not_assoc:
-		/* TODO: ieee802_11_rx_sta_not_assoc(hapd, buf, data_len); */
+/*
+ * TODO
+ * We should be telling them to go away. But we don't support that now.
+ * See also below and above for other TODO items related to this.
+
+ 	case ieee80211_msg_sta_not_assoc:
+		ieee802_11_rx_sta_not_assoc(hapd, buf, data_len);
 		return;
+ */
 	default:
 		printf("handle_frame: unknown msg_type %d\n", msg_type);
 		return;


