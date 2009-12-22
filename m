Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:54271 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbZLVXDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:49 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/5] rt2x00: convert RT2800PCI_PCI and RT2800PCI_SOC Kconfig symbols to booleans.
Date: Wed, 23 Dec 2009 00:03:24 +0100
Message-Id: <1261523005-5856-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need for Kconfig symbols RT2800PCI_PCI and RT2800PCI_SOC to be
tristates, as they are only used to check whether RT2800 PCI or SOC support
is to be compiled in.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |    4 ++--
 drivers/net/wireless/rt2x00/rt2800pci.c |    8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index bf60689..3ca824a 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -54,12 +54,12 @@ config RT61PCI
 	  When compiled as a module, this driver will be called rt61pci.
 
 config RT2800PCI_PCI
-	tristate
+	boolean
 	depends on PCI
 	default y
 
 config RT2800PCI_SOC
-	tristate
+	boolean
 	depends on RALINK_RT288X || RALINK_RT305X
 	default y
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 96e0244..2f9dedd 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -48,14 +48,6 @@
 #include "rt2800.h"
 #include "rt2800pci.h"
 
-#ifdef CONFIG_RT2800PCI_PCI_MODULE
-#define CONFIG_RT2800PCI_PCI
-#endif
-
-#ifdef CONFIG_RT2800PCI_SOC_MODULE
-#define CONFIG_RT2800PCI_SOC
-#endif
-
 /*
  * Allow hardware encryption to be disabled.
  */
-- 
1.6.5.7

