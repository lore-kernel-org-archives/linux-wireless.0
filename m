Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34616 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbYBEH7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 02:59:32 -0500
Message-Id: <200802050758.m157wNAU010975@imap1.linux-foundation.org> (sfid-20080205_075935_916442_C418B3B8)
Subject: [patch 1/1] b43: fix build with CONFIG_SSB_PCIHOST=n
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	mb@bu3sch.de
From: akpm@linux-foundation.org
Date: Mon, 04 Feb 2008 23:58:42 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

m68k allmodconfig gives

drivers/net/wireless/b43/main.c:251: error: implicit declaration of function 'mmiowb'

because CONFIG_B43=m, CONFIG_SSB_PCIHOST=n.

Might be Kconfig bustage, but this works...

Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ssb/ssb.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/ssb/ssb.h~b43-fix-build-with-config_ssb_pcihost=n include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~b43-fix-build-with-config_ssb_pcihost=n
+++ a/include/linux/ssb/ssb.h
@@ -373,6 +373,15 @@ void ssb_pcihost_set_power_state(struct 
 	if (sdev->bus->bustype == SSB_BUSTYPE_PCI)
 		pci_set_power_state(sdev->bus->host_pci, state);
 }
+#else
+static inline void ssb_pcihost_unregister(struct pci_driver *driver)
+{
+}
+
+static inline
+void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t state)
+{
+}
 #endif /* CONFIG_SSB_PCIHOST */
 
 
_
