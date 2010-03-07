Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33526 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0CGKUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 05:20:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: fix some build problems with kernel 2.6.24
Date: Sun,  7 Mar 2010 11:20:40 +0100
Message-Id: <1267957241-5578-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    6 +++---
 include/linux/compat-2.6.25.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/compat/Makefile b/compat/Makefile
index 9441ff9..2005ff3 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -12,12 +12,12 @@ compat-$(CONFIG_COMPAT_KERNEL_19) += compat-2.6.19.o
 compat-$(CONFIG_COMPAT_KERNEL_21) += compat-2.6.21.o
 compat-$(CONFIG_COMPAT_KERNEL_22) += compat-2.6.22.o
 compat-$(CONFIG_COMPAT_KERNEL_23) += compat-2.6.23.o
+compat-$(CONFIG_COMPAT_KERNEL_24) += compat-2.6.24.o
 
-compat-$(CONFIG_COMPAT_KERNEL_24) += \
-	compat-2.6.24.o \
+compat-$(CONFIG_COMPAT_KERNEL_25) += \
+	compat-2.6.25.o \
 	pm_qos_params.o
 
-compat-$(CONFIG_COMPAT_KERNEL_25) += compat-2.6.25.o
 compat-$(CONFIG_COMPAT_KERNEL_26) += compat-2.6.26.o
 compat-$(CONFIG_COMPAT_KERNEL_27) += compat-2.6.27.o
 compat-$(CONFIG_COMPAT_KERNEL_28) += compat-2.6.28.o
diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index f62a096..8d329b3 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -27,7 +27,7 @@
  * in a generic manner.
  */
 #define DEFINE_PCI_DEVICE_TABLE(_table) \
-	struct pci_device_id _table[] __devinitdata
+	const struct pci_device_id _table[] __devinitdata
 
 /*
  * Backport work for QoS dependencies (kernel/pm_qos_params.c)
-- 
1.6.3.3

