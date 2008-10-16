Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49631 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYJPXoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:44:06 -0400
Message-ID: <48F7D1C3.20900@lwfinger.net> (sfid-20081017_014409_309390_B32F421B)
Date: Thu, 16 Oct 2008 16:44:03 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>, John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] hostap: Fix sparse warnings
References: <48F761C1.9000109@lwfinger.net>
In-Reply-To: <48F761C1.9000109@lwfinger.net>
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

The warnings are fixed with the following compile-tested fix:

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---



Index: wireless-testing/drivers/net/wireless/hostap/hostap_wlan.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/hostap/hostap_wlan.h
+++ wireless-testing/drivers/net/wireless/hostap/hostap_wlan.h
@@ -822,7 +822,7 @@ struct local_info {
 	int last_scan_results_count;
 	enum { PRISM2_SCAN, PRISM2_HOSTSCAN } last_scan_type;
 	struct work_struct info_queue;
-	long pending_info; /* bit field of pending info_queue items */
+	unsigned long pending_info; /* bit field of pending info_queue items */
 #define PRISM2_INFO_PENDING_LINKSTATUS 0
 #define PRISM2_INFO_PENDING_SCANRESULTS 1
 	int prev_link_status; /* previous received LinkStatus info */



