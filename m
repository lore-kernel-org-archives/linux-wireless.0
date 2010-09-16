Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50419 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0IPUz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 16:55:29 -0400
Received: by bwz11 with SMTP id 11so1989428bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 13:55:27 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: update AR9170 phy initvals
Date: Thu, 16 Sep 2010 22:55:20 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Felix <ic.felix@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009162255.21158.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is loosely based on an ath9k patch called:
"ath9k_hw: sync initvals for ar9001 and ar9002 with Atheros"
    
It includes the following changes/fixes:
	- AGC setting improvements
	- timing changes for improved performance
    
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
To begin with: The initvals of AR9160(pci) are slightly
different than those from AR9170(usb). It would be nice
to know if the changes are implemented correctly, or not.
---
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 47709c1..71dea97 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -85,11 +85,12 @@ static struct carl9170_phy_init ar5416_phy_init[] = {
 	{ 0x1c5844, 0x1372161e, 0x13721c1e, 0x13721c24, 0x137216a4, },
 	{ 0x1c5848, 0x001a6a65, 0x001a6a65, 0x00197a68, 0x00197a68, },
 	{ 0x1c584c, 0x1284233c, 0x1284233c, 0x1284233c, 0x1284233c, },
-	{ 0x1c5850, 0x6c48b4e4, 0x6c48b4e4, 0x6c48b0e4, 0x6c48b0e4, },
+	{ 0x1c5850, 0x6c48b4e4, 0x6d48b4e4, 0x6d48b0e4, 0x6c48b0e4, },
 	{ 0x1c5854, 0x00000859, 0x00000859, 0x00000859, 0x00000859, },
 	{ 0x1c5858, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, },
-	{ 0x1c585c, 0x31395c5e, 0x31395c5e, 0x31395c5e, 0x31395c5e, },
+	{ 0x1c585c, 0x31395c5e, 0x3139605e, 0x3139605e, 0x31395c5e, },
 	{ 0x1c5860, 0x0004dd10, 0x0004dd10, 0x0004dd20, 0x0004dd20, },
+	{ 0x1c5864, 0x0001c600, 0x0001c600, 0x0001c600, 0x0001c600, },
 	{ 0x1c5868, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, },
 	{ 0x1c586c, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, },
 	{ 0x1c5900, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
@@ -131,9 +132,10 @@ static struct carl9170_phy_init ar5416_phy_init[] = {
 	{ 0x1c59ac, 0x006f00c4, 0x006f00c4, 0x006f00c4, 0x006f00c4, },
 	{ 0x1c59b0, 0x03051000, 0x03051000, 0x03051000, 0x03051000, },
 	{ 0x1c59b4, 0x00000820, 0x00000820, 0x00000820, 0x00000820, },
+	{ 0x1c59bc, 0x00181400, 0x00181400, 0x00181400, 0x00181400, },
 	{ 0x1c59c0, 0x038919be, 0x038919be, 0x038919be, 0x038919be, },
 	{ 0x1c59c4, 0x06336f77, 0x06336f77, 0x06336f77, 0x06336f77, },
-	{ 0x1c59c8, 0x60f6532c, 0x60f6532c, 0x60f6532c, 0x60f6532c, },
+	{ 0x1c59c8, 0x6af6532c, 0x6af6532c, 0x6af6532c, 0x6af6532c, },
 	{ 0x1c59cc, 0x08f186c8, 0x08f186c8, 0x08f186c8, 0x08f186c8, },
 	{ 0x1c59d0, 0x00046384, 0x00046384, 0x00046384, 0x00046384, },
 	{ 0x1c59d4, 0x00000000, 0x00000000, 0x00000000, 0x00000000, },
