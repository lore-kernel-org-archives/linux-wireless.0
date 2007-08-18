Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49213
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbXHRXxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 19:53:19 -0400
Message-Id: <20070818234834.124717000@bu3sch.de>
References: <20070818234833.623623000@bu3sch.de>
Date: Sun, 19 Aug 2007 01:48:34 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 1/6] b43: Fix kconfig, SSB autoselect must depend on b43
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/Kconfig	2007-08-15 15:08:39.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/Kconfig	2007-08-15 15:13:14.000000000 +0200
@@ -11,14 +11,14 @@ config B43
 # Auto-select SSB PCI-HOST support, if possible
 config B43_PCI_AUTOSELECT
 	bool
-	depends on SSB_PCIHOST_POSSIBLE
+	depends on B43 && SSB_PCIHOST_POSSIBLE
 	select SSB_PCIHOST
 	default y
 
 # Auto-select SSB PCICORE driver, if possible
 config B43_PCICORE_AUTOSELECT
 	bool
-	depends on SSB_DRIVER_PCICORE_POSSIBLE
+	depends on B43 && SSB_DRIVER_PCICORE_POSSIBLE
 	select SSB_DRIVER_PCICORE
 	default y
 

-- 

