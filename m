Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38319 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbaDHIgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:45 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/5] wil6210: Convert to Kbuild
Date: Tue, 8 Apr 2014 11:36:15 +0300
Message-ID: <1396946179-11677-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103653_713857_0F4378A5)
In-Reply-To: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert Makefile -> Kbuild,
to make off-kernel development easier and less intrusive.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kbuild   | 18 ++++++++++++++++++
 drivers/net/wireless/ath/wil6210/Makefile | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kbuild
 delete mode 100644 drivers/net/wireless/ath/wil6210/Makefile

diff --git a/drivers/net/wireless/ath/wil6210/Kbuild b/drivers/net/wireless/ath/wil6210/Kbuild
new file mode 100644
index 0000000..c7a3465
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/Kbuild
@@ -0,0 +1,18 @@
+obj-$(CONFIG_WIL6210) += wil6210.o
+
+wil6210-y := main.o
+wil6210-y += netdev.o
+wil6210-y += cfg80211.o
+wil6210-y += pcie_bus.o
+wil6210-y += debugfs.o
+wil6210-y += wmi.o
+wil6210-y += interrupt.o
+wil6210-y += txrx.o
+wil6210-y += debug.o
+wil6210-y += rx_reorder.o
+wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
+
+subdir-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
deleted file mode 100644
index c7a3465..0000000
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ /dev/null
@@ -1,18 +0,0 @@
-obj-$(CONFIG_WIL6210) += wil6210.o
-
-wil6210-y := main.o
-wil6210-y += netdev.o
-wil6210-y += cfg80211.o
-wil6210-y += pcie_bus.o
-wil6210-y += debugfs.o
-wil6210-y += wmi.o
-wil6210-y += interrupt.o
-wil6210-y += txrx.o
-wil6210-y += debug.o
-wil6210-y += rx_reorder.o
-wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
-
-# for tracing framework to find trace.h
-CFLAGS_trace.o := -I$(src)
-
-subdir-ccflags-y += -D__CHECK_ENDIAN__
-- 
1.8.3.2

