Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41293 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYJPPqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 11:46:10 -0400
Message-ID: <48F761C1.9000109@lwfinger.net> (sfid-20081016_174625_529721_9312B9FF)
Date: Thu, 16 Oct 2008 08:46:09 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] hostap: Fix sparse warnings
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A compilation with the command "make C=2 CF="-D__CHECK_ENDIAN__" \
                                drivers/net/wireless/hostap/"

 yields the following warnings:

  CHECK   drivers/net/wireless/hostap/hostap_info.c
drivers/net/wireless/hostap/hostap_info.c:156:43: warning: incorrect type in
argument 2 (different signedness)
drivers/net/wireless/hostap/hostap_info.c:156:43:    expected unsigned long
volatile *addr
drivers/net/wireless/hostap/hostap_info.c:156:43:    got long *<noident>
drivers/net/wireless/hostap/hostap_info.c:294:44: warning: incorrect type in
argument 2 (different signedness)
drivers/net/wireless/hostap/hostap_info.c:294:44:    expected unsigned long
volatile *addr
drivers/net/wireless/hostap/hostap_info.c:294:44:    got long *<noident>
drivers/net/wireless/hostap/hostap_info.c:487:12: warning: incorrect type in
argument 2 (different signedness)
drivers/net/wireless/hostap/hostap_info.c:487:12:    expected unsigned long
volatile *addr
drivers/net/wireless/hostap/hostap_info.c:487:12:    got long *<noident>
drivers/net/wireless/hostap/hostap_info.c:491:12: warning: incorrect type in
argument 2 (different signedness)
drivers/net/wireless/hostap/hostap_info.c:491:12:    expected unsigned long
volatile *addr
drivers/net/wireless/hostap/hostap_info.c:491:12:    got long *<noident>

The warnings are fixed with the following compile-tested changes:

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/net/wireless/hostap/hostap_info.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/hostap/hostap_info.c
+++ wireless-testing/drivers/net/wireless/hostap/hostap_info.c
@@ -153,7 +153,7 @@ static void prism2_info_linkstatus(local
 	}

 	/* Get current BSSID later in scheduled task */
-	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, &local->pending_info);
+	set_bit(PRISM2_INFO_PENDING_LINKSTATUS, (ulong *)&local->pending_info);
 	local->prev_link_status = val;
 	schedule_work(&local->info_queue);
 }
@@ -291,7 +291,7 @@ static void prism2_info_scanresults(loca
 	hostap_report_scan_complete(local);

 	/* Perform rest of ScanResults handling later in scheduled task */
-	set_bit(PRISM2_INFO_PENDING_SCANRESULTS, &local->pending_info);
+	set_bit(PRISM2_INFO_PENDING_SCANRESULTS, (ulong *)&local->pending_info);
 	schedule_work(&local->info_queue);
 }

@@ -484,11 +484,11 @@ static void handle_info_queue(struct wor
 	local_info_t *local = container_of(work, local_info_t, info_queue);

 	if (test_and_clear_bit(PRISM2_INFO_PENDING_LINKSTATUS,
-			       &local->pending_info))
+			       (ulong *)&local->pending_info))
 		handle_info_queue_linkstatus(local);

 	if (test_and_clear_bit(PRISM2_INFO_PENDING_SCANRESULTS,
-			       &local->pending_info))
+			       (ulong *)&local->pending_info))
 		handle_info_queue_scanresults(local);
 }
 #endif /* PRISM2_NO_STATION_MODES */



