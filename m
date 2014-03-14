Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gwb.able.be ([194.78.97.254]:50457 "EHLO mail.able.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbaCNT46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:56:58 -0400
From: Tijs Van Buggenhout <tvb@able.be>
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Reply-To: tvb@able.be
Cc: tvb@able.be
Subject: [wireless] [b43] [brcmsmac] [3.3.8]: backport bcma_core_pci_up/down from 3.12
Date: Fri, 14 Mar 2014 20:51:19 +0100
Message-ID: <1423990.vA4A9XhDx1@tijs> (sfid-20140314_205703_730461_CF874B9C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 6273720de27b0dbd278f823d9c99d40122f41d63
Author: Tijs Van Buggenhout <tijs.van.buggenhout@vasco.com>
Date:   Fri Mar 14 20:42:21 2014 +0100

Backport bcma_core_pci_up/down from 3.12

Compiling module b43 from compat-wireless-2014-01-23.1 for 3.3.8 kernel
results in build errors like so:

  ...
  CC [M]  /compat-wireless-2014-01-23.1/compat/backport-3.13.o
  CC [M]  /compat-wireless-2014-01-23.1/compat/dma-shared-helpers.o
  LD [M]  /compat-wireless-2014-01-23.1/compat/compat.o
  CC [M]  /compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.o
/compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.c: In function
'b43_wireless_core_exit':
/compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.c:4680:3: error:
implicit declaration of function 'bcma_core_pci_down' [-Werror=implicit-
function-declaration]
/compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.c: In function
'b43_wireless_core_init':
/compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.c:4729:3: error:
implicit declaration of function 'bcma_core_pci_up' [-Werror=implicit-
function-declaration]
cc1: some warnings being treated as errors

make[9]: *** [/compat-wireless-2014-01-23.1/drivers/net/wireless/b43/main.o]
Error 1
make[8]: *** [/compat-wireless-2014-01-23.1/drivers/net/wireless/b43] Error 2
make[7]: *** [/compat-wireless-2014-01-23.1/drivers/net/wireless] Error 2
make[6]: *** [_module_/compat-wireless-2014-01-23.1] Error 2
make[5]: *** [modules] Error 2
make[4]: *** [modules] Error 2
make[3]: *** [modules] Error 2
make[3]: Leaving directory `/compat-wireless-2014-01-23.1'
make[2]: *** [/compat-wireless-2014-01-23.1/.built] Error 2

bcma_core_pci_up and bcma_core_pci_down are used in b43/main.c and
brcmsmac/main.c, but are only introduced in kernel 3.12.0. The following patch
adds a backport of these functions for earlier kernel versions. Tested patch
on b43 and ath9k driver.

Signed-off-by: Tijs Van Buggenhout <tvb@able.be>
--

diff --git a/backport/backport-include/linux/bcma/bcma_driver_pci.h b/backport/backport-include/linux/bcma/bcma_driver_pci.h
new file mode 100644
index 0000000..5e52f04
--- /dev/null
+++ b/backport/backport-include/linux/bcma/bcma_driver_pci.h
@@ -0,0 +1,14 @@
+#ifndef __BACKPORT_BCMA_DRIVER_PCI_H
+#define __BACKPORT_BCMA_DRIVER_PCI_H
+#include_next <linux/bcma/bcma_driver_pci.h>
+#include <linux/version.h>
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,12,0)
+struct bcma_bus;
+#define bcma_core_pci_up LINUX_BACKPORT(bcma_core_pci_up)
+extern void bcma_core_pci_up(struct bcma_bus *bus);
+#define bcma_core_pci_down LINUX_BACKPORT(bcma_core_pci_down)
+extern void bcma_core_pci_down(struct bcma_bus *bus);
+#endif
+
+#endif /* __BACKPORT_BCMA_DRIVER_PCI_H */
diff --git a/backport/compat/backport-3.12.c b/backport/compat/backport-3.12.c
index 7e3dc58..5f0edb2 100644
--- a/backport/compat/backport-3.12.c
+++ b/backport/compat/backport-3.12.c
@@ -27,3 +27,33 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 	return kmalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
+
+#if defined(CONFIG_BCMA) || defined(CONFIG_BCMA_MODULE)
+#include <linux/bcma/bcma.h>
+
+void bcma_core_pci_up(struct bcma_bus *bus)
+{
+	struct bcma_drv_pci *pc;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	pc = &bus->drv_pci[0];
+
+	bcma_core_pci_extend_L1timer(pc, true);
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_up);
+
+void bcma_core_pci_down(struct bcma_bus *bus)
+{
+	struct bcma_drv_pci *pc;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	pc = &bus->drv_pci[0];
+
+	bcma_core_pci_extend_L1timer(pc, false);
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_down);
+#endif

