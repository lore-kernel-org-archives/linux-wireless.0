Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:43111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYIOMlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 08:41:53 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 8A6AE41769
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 14:41:52 +0200 (CEST)
From: Helmut Schaa <hschaa@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC] wpa_supplicant: trigger a scan if signal quality is low
Date: Mon, 15 Sep 2008 14:41:50 +0200
References: <200809151416.07552.hschaa@suse.de>
In-Reply-To: <200809151416.07552.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151441.50699.hschaa@suse.de> (sfid-20080915_144156_883259_B1B61877)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the appropriate wpa_supplicant patch for reference.
It simply triggers a new scan once a "low signal notification" was received.

diff -ur wpa_supplicant-0.6.4/src/common/wireless_copy.h wpa_supplicant-0.6.4_2//src/common/wireless_copy.h
--- wpa_supplicant-0.6.4/src/common/wireless_copy.h	2008-08-10 19:33:12.000000000 +0200
+++ wpa_supplicant-0.6.4_2//src/common/wireless_copy.h	2008-09-15 11:38:14.000000000 +0200
@@ -396,6 +396,8 @@
 					 * pre-authentication
 					 * (struct iw_pmkid_cand) */
 
+#define IWEVROAM	0x8C0A		/* roaming threshold exceeded */
+
 #define IWEVFIRST	0x8C00
 #define IW_EVENT_IDX(cmd)	((cmd) - IWEVFIRST)
 
diff -ur wpa_supplicant-0.6.4/src/drivers/driver.h wpa_supplicant-0.6.4_2//src/drivers/driver.h
--- wpa_supplicant-0.6.4/src/drivers/driver.h	2008-08-10 19:33:12.000000000 +0200
+++ wpa_supplicant-0.6.4_2//src/drivers/driver.h	2008-09-15 11:30:50.000000000 +0200
@@ -1052,7 +1052,13 @@
 	 * FT authentication sequence from the AP. The FT IEs are included in
 	 * the extra information in union wpa_event_data::ft_ies.
 	 */
-	EVENT_FT_RESPONSE
+	EVENT_FT_RESPONSE,
+
+	/**
+	 * EVENT_ROAMING_THRESHOLD - Roaming threshold exceeded
+	 */
+	EVENT_ROAMING_THRESHOLD
+
 } wpa_event_type;
 
 
diff -ur wpa_supplicant-0.6.4/src/drivers/driver_wext.c wpa_supplicant-0.6.4_2//src/drivers/driver_wext.c
--- wpa_supplicant-0.6.4/src/drivers/driver_wext.c	2008-08-10 19:33:12.000000000 +0200
+++ wpa_supplicant-0.6.4_2//src/drivers/driver_wext.c	2008-09-15 11:40:50.000000000 +0200
@@ -497,8 +497,7 @@
 
 	return 0;
 }
-
-
+	
 static int wpa_driver_wext_event_wireless_pmkidcand(
 	struct wpa_driver_wext_data *drv, const char *ev, size_t len)
 {
@@ -684,6 +683,9 @@
 			wpa_driver_wext_event_wireless_pmkidcand(
 				drv, custom, iwe->u.data.length);
 			break;
+		case IWEVROAM:
+			wpa_supplicant_event(ctx, EVENT_ROAMING_THRESHOLD, NULL);
+			break;
 		}
 
 		pos += iwe->len;
diff -ur wpa_supplicant-0.6.4/wpa_supplicant/events.c wpa_supplicant-0.6.4_2//wpa_supplicant/events.c
--- wpa_supplicant-0.6.4/wpa_supplicant/events.c	2008-08-10 19:33:12.000000000 +0200
+++ wpa_supplicant-0.6.4_2//wpa_supplicant/events.c	2008-09-15 12:14:13.000000000 +0200
@@ -613,6 +613,10 @@
 }
 #endif /* CONFIG_NO_SCAN_PROCESSING */
 
+static void wpa_supplicant_event_roaming_threshold(struct wpa_supplicant *wpa_s)
+{
+	wpa_supplicant_req_scan(wpa_s, 0, 0);
+}
 
 static void wpa_supplicant_event_associnfo(struct wpa_supplicant *wpa_s,
 					   union wpa_event_data *data)
@@ -955,6 +959,9 @@
 		wpa_supplicant_event_ft_response(wpa_s, data);
 		break;
 #endif /* CONFIG_IEEE80211R */
+	case EVENT_ROAMING_THRESHOLD:
+		wpa_supplicant_event_roaming_threshold(wpa_s);
+		break;
 	default:
 		wpa_printf(MSG_INFO, "Unknown event %d", event);
 		break;
