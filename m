Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47672 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbZAMMfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 07:35:13 -0500
Date: Tue, 13 Jan 2009 14:35:08 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix an operator typo in REG_DOMAIN_2GHZ_MASK
Message-ID: <20090113123508.GC14346@jm.kir.nu> (sfid-20090113_133518_686133_D4791526)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect operator causes the REG_DOMAIN_2GHZ_MASK to be zero which
surely was not the goal of this definition. Mask out the 11a flags
correctly.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/regd_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/regd_common.h	2009-01-13 14:12:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/regd_common.h	2009-01-13 14:13:54.000000000 +0200
@@ -228,7 +228,7 @@ enum {
 };
 
 #define REG_DOMAIN_2GHZ_MASK    (REQ_MASK & \
-	(!(ADHOC_NO_11A | DISALLOW_ADHOC_11A | DISALLOW_ADHOC_11A_TURB)))
+	(~(ADHOC_NO_11A | DISALLOW_ADHOC_11A | DISALLOW_ADHOC_11A_TURB)))
 #define REG_DOMAIN_5GHZ_MASK    REQ_MASK
 
 static struct reg_dmn_pair_mapping regDomainPairs[] = {

-- 
Jouni Malinen                                            PGP id EFC895FA
