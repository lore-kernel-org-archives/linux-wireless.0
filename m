Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43029 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYDAOOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 10:14:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Enable quantum cryptography support
Date: Tue, 1 Apr 2008 16:13:06 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804011613.06749.mb@bu3sch.de> (sfid-20080401_151434_906114_43AEBC44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables support for quantum cryptography on latest b43 devices.
The quantum cryptography algorithm is 100% backward compatible with the
standard CCMP algorithm, so no additional changes to the mac80211 stack
are needed. While staying compatible, it makes the unbreakable(!) WLAN connection
possible. Of course, that's only the case, if both ends use b43-qcrypto.
In the case where one STA uses legacy encryption, the card will automatically
detect this and switch back to plain old CCMP.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue this patch for linux-3.6.26


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-22 15:44:00.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-01 15:53:40.000000000 +0200
@@ -270,6 +270,7 @@ enum {
 #define B43_HF_ANTSELMODE	0x000200000000ULL /* Antenna selection mode (rev >= 13 only) */
 #define B43_HF_MLADVW		0x001000000000ULL /* N PHY ML ADV workaround (rev >= 13 only) */
 #define B43_HF_PR45960W		0x080000000000ULL /* PR 45960 workaround (rev >= 13 only) */
+#define B43_HF_QUANTUMCRYPT	0x100000000000ULL /* Enable quantum cryptography in firmware. */
 
 /* MacFilter offsets. */
 #define B43_MACFILTER_SELF		0x0000
@@ -439,6 +440,7 @@ enum {
 	B43_SEC_ALGO_AES,
 	B43_SEC_ALGO_WEP104,
 	B43_SEC_ALGO_AES_LEGACY,
+	B43_SEC_ALGO_QUANTUM,
 };
 
 struct b43_dmaring;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-27 17:11:38.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-01 15:53:41.000000000 +0200
@@ -3215,6 +3215,13 @@ static int b43_op_set_key(struct ieee802
 		break;
 	case ALG_CCMP:
 		algorithm = B43_SEC_ALGO_AES;
+		if (dev->dev->id.revision >= 20080401) {
+			/* Latest devices can do quantum cryptography
+			 * to encrypt/decrypt the data stream.
+			 * This is 100% backward compatible with the traditional
+			 * CCMP algorithm. */
+			algorithm = B43_SEC_ALGO_QUANTUM;
+		}
 		break;
 	default:
 		B43_WARN_ON(1);
@@ -3254,6 +3261,10 @@ static int b43_op_set_key(struct ieee802
 			b43_hf_write(dev,
 				     b43_hf_read(dev) & ~B43_HF_USEDEFKEYS);
 		}
+		if (algorithm == B43_SEC_ALGO_QUANTUM) {
+			b43_hf_write(dev, b43_hf_read(dev)
+				     | B43_HF_QUANTUMCRYPT);
+		}
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	case DISABLE_KEY: {

-- 
Greetings Michael.
