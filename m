Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43563 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab2IGH4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 03:56:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat: drop const to fix compiler warnings
Date: Fri,  7 Sep 2012 09:56:14 +0200
Message-Id: <1347004574-80506-1-git-send-email-nbd@openwrt.org> (sfid-20120907_095626_255733_9E08C68F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When calling pci_find_capability and pci_read_config_word, struct pci_dev
needs to be passed without const.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 compat/compat-3.7.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/compat/compat-3.7.c b/compat/compat-3.7.c
index b37b73a..f591f16 100644
--- a/compat/compat-3.7.c
+++ b/compat/compat-3.7.c
@@ -29,7 +29,7 @@ EXPORT_SYMBOL_GPL(mod_delayed_work);
  * pci_dev but if we found it we likely would remove it from
  * the kernel anyway right? Bite me.
  */
-static inline u16 pcie_flags_reg(const struct pci_dev *dev)
+static inline u16 pcie_flags_reg(struct pci_dev *dev)
 {
 	int pos;
 	u16 reg16;
@@ -43,12 +43,12 @@ static inline u16 pcie_flags_reg(const struct pci_dev *dev)
 	return reg16;
 }
 
-static inline int pci_pcie_type(const struct pci_dev *dev)
+static inline int pci_pcie_type(struct pci_dev *dev)
 {
 	return (pcie_flags_reg(dev) & PCI_EXP_FLAGS_TYPE) >> 4;
 }
 
-static inline int pcie_cap_version(const struct pci_dev *dev)
+static inline int pcie_cap_version(struct pci_dev *dev)
 {
 	return pcie_flags_reg(dev) & PCI_EXP_FLAGS_VERS;
 }
@@ -58,7 +58,7 @@ static inline bool pcie_cap_has_devctl(const struct pci_dev *dev)
 	return true;
 }
 
-static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
+static inline bool pcie_cap_has_lnkctl(struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
@@ -68,7 +68,7 @@ static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
 	       type == PCI_EXP_TYPE_LEG_END;
 }
 
-static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
+static inline bool pcie_cap_has_sltctl(struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
@@ -78,7 +78,7 @@ static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
 		pcie_flags_reg(dev) & PCI_EXP_FLAGS_SLOT);
 }
 
-static inline bool pcie_cap_has_rtctl(const struct pci_dev *dev)
+static inline bool pcie_cap_has_rtctl(struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
-- 
1.7.9.6 (Apple Git-31.1)

