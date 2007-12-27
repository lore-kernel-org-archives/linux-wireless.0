Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58133 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXL0VQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 16:16:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix tim search buffer overrun
Date: Thu, 27 Dec 2007 22:15:11 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712272215.12056.mb@bu3sch.de> (sfid-20071227_211650_685107_0251322E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the length of the variable section of the beacon instead of the
whole beacon length for bounds checking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 18:20:38.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-27 22:05:07.000000000 +0100
@@ -1161,7 +1161,7 @@ static void b43_write_beacon_template(st
 				      u16 ram_offset,
 				      u16 shm_size_offset, u8 rate)
 {
-	int i, len;
+	unsigned int i, len, variable_len;
 	const struct ieee80211_mgmt *bcn;
 	const u8 *ie;
 	bool tim_found = 0;
@@ -1176,7 +1176,8 @@ static void b43_write_beacon_template(st
 	/* Find the position of the TIM and the DTIM_period value
 	 * and write them to SHM. */
 	ie = bcn->u.beacon.variable;
-	for (i = 0; i < len - 2; ) {
+	variable_len = len - offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	for (i = 0; i < variable_len - 2; ) {
 		uint8_t ie_id, ie_len;
 
 		ie_id = ie[i];
@@ -1187,7 +1188,7 @@ static void b43_write_beacon_template(st
 			/* This is the TIM Information Element */
 
 			/* Check whether the ie_len is in the beacon data range. */
-			if (len < ie_len + 2 + i)
+			if (variable_len < ie_len + 2 + i)
 				break;
 			/* A valid TIM is at least 4 bytes long. */
 			if (ie_len < 4)
