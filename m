Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21007 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYEWISl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 04:18:41 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATH] libertas: speeds up downloading of CF firmware
Date: Fri, 23 May 2008 10:18:26 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231018.26751.hs4233@mail.mn-solutions.de> (sfid-20080523_101846_540907_CCB96C61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep the timeout the same (1000*500 == 100000 * 5), but take shorter
naps. Makes downloading the firmware slightly faster.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux.orig/drivers/net/wireless/libertas/if_cs.c
+++ linux/drivers/net/wireless/libertas/if_cs.c
@@ -148,11 +148,11 @@
 {
 	int i;
 
-	for (i = 0; i < 1000; i++) {
+	for (i = 0; i < 100000; i++) {
 		u8 val = if_cs_read8(card, addr);
 		if (val == reg)
 			return i;
-		udelay(500);
+		udelay(5);
 	}
 	return -ETIME;
 }
