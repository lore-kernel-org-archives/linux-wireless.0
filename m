Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57231 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758523AbYCGSxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 13:53:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix failed frames status report typo
Date: Fri, 7 Mar 2008 19:52:24 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803071952.24332.mb@bu3sch.de> (sfid-20080307_185314_231063_79299687)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a typo in the status report.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-07 19:48:55.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-07 19:49:23.000000000 +0100
@@ -914,13 +914,13 @@ static void b43_destroy_dmaring(struct b
 		       "Used slots %d/%d, Failed frames %llu/%llu = %llu.%01llu%%, "
 		       "Average tries %llu.%02llu\n",
 		       (unsigned int)(ring->type), ringname,
 		       ring->max_used_slots,
 		       ring->nr_slots,
 		       (unsigned long long)failed_packets,
-		       (unsigned long long)succeed_packets,
+		       (unsigned long long)nr_packets,
 		       (unsigned long long)divide(permille_failed, 10),
 		       (unsigned long long)modulo(permille_failed, 10),
 		       (unsigned long long)divide(average_tries, 100),
 		       (unsigned long long)modulo(average_tries, 100));
 	}
 #endif /* DEBUG */
