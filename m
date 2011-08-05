Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1HELLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:36 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 4/8] pci: aspm: add function for disabling ASPM
Date: Fri,  5 Aug 2011 13:10:35 +0200
Message-Id: <1312542639-4274-5-git-send-email-sgruszka@redhat.com> (sfid-20110805_131139_688995_EDB76588)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for disabling ASPM if !CONFIG_PCIEASPM. Patch is based
on code from e1000e.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/pci/pcie/Makefile |    3 +--
 drivers/pci/pcie/aspm.c   |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/pci-aspm.h  |    2 ++
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/Makefile b/drivers/pci/pcie/Makefile
index 00c62df..6e20c59 100644
--- a/drivers/pci/pcie/Makefile
+++ b/drivers/pci/pcie/Makefile
@@ -2,8 +2,7 @@
 # Makefile for PCI-Express PORT Driver
 #
 
-# Build PCI Express ASPM if needed
-obj-$(CONFIG_PCIEASPM)		+= aspm.o
+obj-y				+= aspm.o
 
 pcieportdrv-y			:= portdrv_core.o portdrv_pci.o portdrv_bus.o
 pcieportdrv-$(CONFIG_ACPI)	+= portdrv_acpi.o
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 6892601..2883fc3 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -21,6 +21,8 @@
 #include <linux/pci-aspm.h>
 #include "../pci.h"
 
+#ifdef CONFIG_PCIEASPM
+
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
@@ -976,3 +978,42 @@ bool pcie_aspm_support_enabled(void)
 	return aspm_support_enabled;
 }
 EXPORT_SYMBOL(pcie_aspm_support_enabled);
+
+void pcie_disable_aspm(struct pci_dev *pdev, u16 state)
+{
+	pci_disable_link_state_locked(pdev, state);
+}
+EXPORT_SYMBOL(pcie_disable_aspm);
+
+#else /* CONFIG_PCIEASPM */
+
+void pcie_disable_aspm(struct pci_dev *pdev, u16 state)
+{
+	int pos;
+	u16 reg16;
+	struct pci_dev *parent;
+
+	pos = pci_pcie_cap(pdev);
+	if (!pos)
+		return;
+	/*
+	 * Both device and parent should have the same ASPM setting.
+	 * Disable ASPM in downstream component first and then upstream.
+	 */
+
+	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	reg16 &= ~state;
+	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+
+	parent = pdev->bus->self;
+	if (WARN_ON(!parent))
+		return;
+
+	pos = pci_pcie_cap(parent);
+	pci_read_config_word(parent, pos + PCI_EXP_LNKCTL, &reg16);
+	reg16 &= ~state;
+	pci_write_config_word(parent, pos + PCI_EXP_LNKCTL, reg16);
+}
+EXPORT_SYMBOL(pcie_disable_aspm);
+
+#endif
diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
index 7cea7b6..f9722e6 100644
--- a/include/linux/pci-aspm.h
+++ b/include/linux/pci-aspm.h
@@ -55,6 +55,8 @@ static inline void pcie_no_aspm(void)
 }
 #endif
 
+extern void pcie_disable_aspm(struct pci_dev *pdev, u16 state);
+
 #ifdef CONFIG_PCIEASPM_DEBUG /* this depends on CONFIG_PCIEASPM */
 extern void pcie_aspm_create_sysfs_dev_files(struct pci_dev *pdev);
 extern void pcie_aspm_remove_sysfs_dev_files(struct pci_dev *pdev);
-- 
1.7.1

