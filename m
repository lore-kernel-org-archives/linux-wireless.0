Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65116 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LQNap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 08:30:45 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: print all capability bits
Date: Mon, 17 Dec 2012 15:30:41 +0200
Message-ID: <4433962.e7lXLf3bMQ@lx-vladimir> (sfid-20121217_143049_890603_1B26CBD3)
In-Reply-To: <3409795.QNLPYz7pkM@lx-vladimir>
References: <3409795.QNLPYz7pkM@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To continue with capability: not all bits from .11n printed as well.
Patch below adds missing bits.

I'll prepare patch for kernel with the #define's as well

>From 9f7b0078e7008e1735d980a4bb583efd2321d9ed Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 17 Dec 2012 15:26:47 +0200
Subject: [PATCH] iw: print all capability bits

Print all bits from capability info, as defined in the IEEE802.11-2012

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 scan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scan.c b/scan.c
index 295a51c..a07f16a 100644
--- a/scan.c
+++ b/scan.c
@@ -25,7 +25,10 @@
 #define WLAN_CAPABILITY_QOS		(1<<9)
 #define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
 #define WLAN_CAPABILITY_APSD		(1<<11)
+#define WLAN_CAPABILITY_RADIO_MEASURE	(1<<12)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+#define WLAN_CAPABILITY_DEL_BACK	(1<<14)
+#define WLAN_CAPABILITY_IMM_BACK	(1<<15)
 /* DMG (60gHz) 802.11ad */
 /* type - bits 0..1 */
 #define WLAN_CAPABILITY_DMG_TYPE_MASK		(3<<0)
@@ -1265,6 +1268,10 @@ static void print_capa_11n(__u16 capa)
 		printf(" ESS");
 	if (capa & WLAN_CAPABILITY_IBSS)
 		printf(" IBSS");
+	if (capa & WLAN_CAPABILITY_CF_POLLABLE)
+		printf(" CfPollable");
+	if (capa & WLAN_CAPABILITY_CF_POLL_REQUEST)
+		printf(" CfPollReq");
 	if (capa & WLAN_CAPABILITY_PRIVACY)
 		printf(" Privacy");
 	if (capa & WLAN_CAPABILITY_SHORT_PREAMBLE)
@@ -1281,8 +1288,14 @@ static void print_capa_11n(__u16 capa)
 		printf(" ShortSlotTime");
 	if (capa & WLAN_CAPABILITY_APSD)
 		printf(" APSD");
+	if (capa & WLAN_CAPABILITY_RADIO_MEASURE)
+		printf(" RadioMeasure");
 	if (capa & WLAN_CAPABILITY_DSSS_OFDM)
 		printf(" DSSS-OFDM");
+	if (capa & WLAN_CAPABILITY_DEL_BACK)
+		printf(" DelayedBACK");
+	if (capa & WLAN_CAPABILITY_IMM_BACK)
+		printf(" ImmediateBACK");
 }
 
 static int print_bss_handler(struct nl_msg *msg, void *arg)
-- 
1.7.10.4


