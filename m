Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49023 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3EOO5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:57:36 -0400
Subject: [PATCH 29/29] ath10k: add Kconfig and Makefile
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 17:46:58 +0300
Message-ID: <20130515144658.4492.16855.stgit@localhost6.localdomain6> (sfid-20130515_165741_127972_62FD1D28)
In-Reply-To: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
References: <20130515143356.4492.43033.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig         |    1 +
 drivers/net/wireless/ath/Makefile        |    1 +
 drivers/net/wireless/ath/ath10k/Kconfig  |   39 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/Makefile |   20 +++++++++++++++
 4 files changed, 61 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath10k/Makefile

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 2c02b4e..7f2a160 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -27,6 +27,7 @@ config ATH_DEBUG
 
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
+source "drivers/net/wireless/ath/ath10k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
 source "drivers/net/wireless/ath/ar5523/Kconfig"
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 97b964d..fb05cfd 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
 obj-$(CONFIG_AR5523)		+= ar5523/
 obj-$(CONFIG_WIL6210)		+= wil6210/
+obj-$(CONFIG_ATH10K)		+= ath10k/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
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

