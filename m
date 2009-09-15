Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57197 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZIOXOL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:14:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove BROKEN attribute from SDIO
Date: Wed, 16 Sep 2009 01:13:57 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Message-Id: <200909160113.57539.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO works (more or less), so remove the BROKEN dependency and
let people test it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch depends on all other patches that I already sent but are not applied, yet.


Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-09-16 01:09:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-09-16 01:10:02.000000000 +0200
@@ -63,7 +63,7 @@ config B43_PCMCIA
 
 config B43_SDIO
 	bool "Broadcom 43xx SDIO device support (EXPERIMENTAL)"
-	depends on B43 && SSB_SDIOHOST_POSSIBLE && EXPERIMENTAL && BROKEN
+	depends on B43 && SSB_SDIOHOST_POSSIBLE && EXPERIMENTAL
 	select SSB_SDIOHOST
 	---help---
 	  Broadcom 43xx device support for Soft-MAC SDIO devices.

-- 
Greetings, Michael.
