Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZCNSK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 14:10:56 -0400
Subject: [PATCH] ieee80211: document DS bit usage
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 19:10:51 +0100
Message-Id: <1237054251.5235.106.camel@johannes.local> (sfid-20090314_191100_730708_EB5EF7E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I keep needing this because I'm too stupid to remember it.
Everybody else can probably remember, but who knows :)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-03-14 18:58:35.000000000 +0100
+++ wireless-testing/include/linux/ieee80211.h	2009-03-14 19:03:03.000000000 +0100
@@ -18,6 +18,22 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+/*
+ * DS bit usage
+ *
+ * TA = transmitter address
+ * RA = receiver address
+ * DA = destination address
+ * SA = source address
+ *
+ * ToDS    FromDS  A1(RA)  A2(TA)  A3      A4      Use
+ * -----------------------------------------------------------------
+ *  0       0       DA      SA      BSSID   -       IBSS/DLS
+ *  0       1       DA      BSSID   SA      -       AP -> STA
+ *  1       0       BSSID   SA      DA      -       AP <- STA
+ *  1       1       RA      TA      DA      SA      unspecified (WDS)
+ */
+
 #define FCS_LEN 4
 
 #define IEEE80211_FCTL_VERS		0x0003


