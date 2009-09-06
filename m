Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51806 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbZIFOWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 10:22:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix sparse warning in hw-tkip code
Date: Sun, 6 Sep 2009 16:18:58 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	gregor kowski <gregor.kowski@gmail.com>
MIME-Version: 1.0
Message-Id: <200909061618.58584.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a sparse warning in the hardware-TKIP code:

drivers/net/wireless/b43/xmit.c:272:18: warning: incorrect type in assignment (different base types)
drivers/net/wireless/b43/xmit.c:272:18:    expected unsigned short [unsigned] [short] <noident>
drivers/net/wireless/b43/xmit.c:272:18:    got restricted unsigned short [usertype] <noident>

The code should work correctly with and without this patch applied.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-09-06 16:10:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-09-06 16:17:08.000000000 +0200
@@ -267,11 +267,11 @@ int b43_generate_txhdr(struct b43_wldev 
 			 */
 			ieee80211_get_tkip_key(info->control.hw_key, skb_frag,
 					IEEE80211_TKIP_P1_KEY, (u8*)phase1key);
-			/* phase1key is in host endian */
-			for (i = 0; i < 5; i++)
-				phase1key[i] = cpu_to_le16(phase1key[i]);
-
-			memcpy(txhdr->iv, phase1key, 10);
+			/* phase1key is in host endian. Copy to little-endian txhdr->iv. */
+			for (i = 0; i < 5; i++) {
+				txhdr->iv[i * 2 + 0] = phase1key[i];
+				txhdr->iv[i * 2 + 1] = phase1key[i] >> 8;
+			}
 			/* iv16 */
 			memcpy(txhdr->iv + 10, ((u8 *) wlhdr) + wlhdr_len, 3);
 		} else {

-- 
Greetings, Michael.
