Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51071 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbYJIPTZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 11:19:25 -0400
Message-ID: <48EE20FB.4060700@lwfinger.net> (sfid-20081009_171929_411248_5ECD9BB1)
Date: Thu, 09 Oct 2008 08:19:23 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>, Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT] p54: Fix for big-endian architecture
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is meant for testing on big-endian hardware. Every indication
is that the data in the bootrec structure is little endian. This patch fixes
a usage of the u32 data array as a string of u8's.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.h
+++ wireless-testing/drivers/net/wireless/p54/p54common.h
@@ -18,7 +18,10 @@
 struct bootrec {
 	__le32 code;
 	__le32 len;
-	u32 data[10];
+	union {
+		u32 data[10];
+		u8 data_char[40];
+	} __attribute__((packed));
 	__le16 rx_mtu;
 } __attribute__((packed));

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -171,8 +171,8 @@ int p54_parse_firmware(struct ieee80211_
 			break;
 		case BR_CODE_COMPONENT_VERSION:
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char*)bootrec->data, 24) < 24)
-				fw_version = (unsigned char*)bootrec->data;
+			if (strnlen(bootrec->data_char, 24) < 24)
+				fw_version = bootrec->data_char;
 			break;
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =

