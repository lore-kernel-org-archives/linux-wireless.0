Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53689 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117AbZHHMie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/7] [compat-2.6] Rename CONFIG_IWL4965 symbol
Date: Sat,  8 Aug 2009 14:38:15 +0200
Message-Id: <1249735096-27071-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel 2.6.26 and older CONFIG_IWL4965 was build as an extra
module, but now it is directly included in the iwlagn.

CONFIG_IWL4965 has to be set to y, to build correctly.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/09-rename-iwl4965-config.patch |   31 +++++++++++++++++++++++++
 config.mk                                     |    2 +-
 2 files changed, 32 insertions(+), 1 deletions(-)
 create mode 100644 compat/patches/09-rename-iwl4965-config.patch

diff --git a/compat/patches/09-rename-iwl4965-config.patch b/compat/patches/09-rename-iwl4965-config.patch
new file mode 100644
index 0000000..e539c75
--- /dev/null
+++ b/compat/patches/09-rename-iwl4965-config.patch
@@ -0,0 +1,31 @@
+In kernel 2.6.26 and older CONFIG_IWL4965 was build as an extra
+module, but now it is directly included in the iwlagn.
+
+CONFIG_IWL4965 has to be set to y, to build correctly.
+
+--- a/drivers/net/wireless/iwlwifi/Makefile
++++ b/drivers/net/wireless/iwlwifi/Makefile
+@@ -9,7 +9,7 @@ iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
+ obj-$(CONFIG_IWLAGN)	+= iwlagn.o
+ iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
+ 
+-iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
++iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
+ iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
+--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
++++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
+@@ -3088,10 +3088,10 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
+ 
+ /* Hardware specific file defines the PCI IDs table for that hardware module */
+ static struct pci_device_id iwl_hw_card_ids[] = {
+-#ifdef CONFIG_IWL4965
++#ifdef CONFIG_COMPAT_IWL4965
+ 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
+ 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+-#endif /* CONFIG_IWL4965 */
++#endif /* CONFIG_COMPAT_IWL4965 */
+ #ifdef CONFIG_IWL5000
+ 	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
+ 	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
diff --git a/config.mk b/config.mk
index 0d8962b..2dab9af 100644
--- a/config.mk
+++ b/config.mk
@@ -135,7 +135,7 @@ CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT=y
 # CONFIG_IWLWIFI_DEBUG=y
 # CONFIG_IWLWIFI_DEBUGFS=y
 CONFIG_IWLAGN=m
-CONFIG_IWL4965=y
+CONFIG_COMPAT_IWL4965=y
 CONFIG_IWL5000=y
 CONFIG_IWL3945=m
 CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
-- 
1.6.2.1

