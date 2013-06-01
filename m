Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:60850 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3FAL1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:27:47 -0400
Subject: [PATCH v2 29/29] ath10k: add Kconfig and Makefile
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:27:44 +0300
Message-ID: <20130601112744.32443.80409.stgit@localhost6.localdomain6> (sfid-20130601_132750_127054_D2644277)
In-Reply-To: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
References: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |   39 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/Makefile |   20 +++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath10k/Makefile

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
new file mode 100644
index 0000000..cde58fe
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -0,0 +1,39 @@
+config ATH10K
+        tristate "Atheros 802.11ac wireless cards support"
+        depends on MAC80211
+	select ATH_COMMON
+        ---help---
+          This module adds support for wireless adapters based on
+          Atheros IEEE 802.11ac family of chipsets.
+
+          If you choose to build a module, it'll be called ath10k.
+
+config ATH10K_PCI
+	tristate "Atheros ath10k PCI support"
+	depends on ATH10K && PCI
+	---help---
+	  This module adds support for PCIE bus
+
+config ATH10K_DEBUG
+	bool "Atheros ath10k debugging"
+	depends on ATH10K
+	---help---
+	  Enables debug support
+
+	  If unsure, say Y to make it easier to debug problems.
+
+config ATH10K_DEBUGFS
+	bool "Atheros ath10k debugfs support"
+	depends on ATH10K
+	---help---
+	  Enabled debugfs support
+
+	  If unsure, say Y to make it easier to debug problems.
+
+config ATH10K_TRACING
+	bool "Atheros ath10k tracing support"
+	depends on ATH10K
+	depends on EVENT_TRACING
+	---help---
+	  Select this to ath10k use tracing infrastructure.
+
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
new file mode 100644
index 0000000..a4179f4
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -0,0 +1,20 @@
+obj-$(CONFIG_ATH10K) += ath10k_core.o
+ath10k_core-y += mac.o \
+		 debug.o \
+		 core.o \
+		 htc.o \
+		 htt.o \
+		 htt_rx.o \
+		 htt_tx.o \
+		 txrx.o \
+		 wmi.o \
+		 bmi.o
+
+ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
+
+obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
+ath10k_pci-y += pci.o \
+		ce.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)

