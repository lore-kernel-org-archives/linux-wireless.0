Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXHJV0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 17:26:48 -0400
Subject: [PATCH] hostapd: remove use of ieee80211_msg_wep_frame_unknown_key
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 23:29:26 +0200
Message-Id: <1186781366.17351.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just removed it from the kernel because hostapd doesn't really use it.
Kill all references.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-10 23:27:07.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-10 23:28:21.000000000 +0200
@@ -1413,9 +1413,15 @@ static void handle_frame(struct hostapd_
 	case ieee80211_msg_tx_callback_fail:
 		handle_tx_callback(hapd, buf, data_len, 0);
 		return;
+/*
+ * TODO
+ * the kernel never sends this any more, add new nl80211
+ * notification if you need this.
+
 	case ieee80211_msg_wep_frame_unknown_key:
-		/* TODO: ieee802_11_rx_unknown_key(hapd, buf, data_len); */
+		ieee802_11_rx_unknown_key(hapd, buf, data_len);
 		return;
+ */
 	case ieee80211_msg_michael_mic_failure:
 		hostapd_michael_mic_failure(hapd, buf, data_len);
 		return;


