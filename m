Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38260 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbYGINun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:50:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Include dma-mapping.h
Date: Wed, 9 Jul 2008 15:48:45 +0200
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807091548.45761.mb@bu3sch.de> (sfid-20080709_155047_255572_7CF16147)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb.h implements DMA mapping functions, so it should
include dma-mapping.h. This fixes compile failures on certain architectures.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is a bugfix for 2.6.27


Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-07-01 23:13:18.000000000 +0200
+++ wireless-testing/include/linux/ssb/ssb.h	2008-07-09 15:43:51.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/mod_devicetable.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/ssb/ssb_regs.h>
 

-- 
Greetings Michael.
