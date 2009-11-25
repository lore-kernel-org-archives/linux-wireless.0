Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60066 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935117AbZKYV4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 16:56:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] airo: Fix integer overflow warning
Date: Wed, 25 Nov 2009 22:55:11 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911252255.11570.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On BigEndian gcc complains:

drivers/net/wireless/airo.c: In function ‘sniffing_mode’:
drivers/net/wireless/airo.c:4809: warning: integer overflow in expression

Fix this by doing the bitwise AND on the host-endian value.

---

I don't know why GCC warns, however. The original code looks OK to me, too.


Index: wireless-testing/drivers/net/wireless/airo.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/airo.c	2009-11-01 13:58:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/airo.c	2009-11-25 22:49:18.000000000 +0100
@@ -4806,7 +4806,7 @@ static int airo_config_commit(struct net
 
 static inline int sniffing_mode(struct airo_info *ai)
 {
-	return le16_to_cpu(ai->config.rmode & RXMODE_MASK) >=
+	return (le16_to_cpu(ai->config.rmode) & le16_to_cpu(RXMODE_MASK)) >=
 		le16_to_cpu(RXMODE_RFMON);
 }
 

-- 
Greetings, Michael.
