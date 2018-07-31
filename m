Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732093AbeGaOVp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 10:21:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 12/14] mt76: Kconfig and Makefile for mt76x0 driver
Date: Tue, 31 Jul 2018 14:41:02 +0200
Message-Id: <1533040864-9026-13-git-send-email-sgruszka@redhat.com> (sfid-20180731_144144_031491_8D269D1D)
In-Reply-To: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Kconfig and Makefiles for mt76x0 driver. Now the driver
can be build.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig         | 7 +++++++
 drivers/net/wireless/mediatek/mt76/Makefile        | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile | 7 +++++++
 3 files changed, 15 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 69906c733a1c..850611ad347a 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -9,6 +9,13 @@ config MT76x2_COMMON
 	tristate
 	depends on MT76_CORE
 
+config MT76x0U
+	tristate "MediaTek MT76x0U (USB) support"
+	depends on MAC80211
+	depends on USB
+	help
+	  This adds support for MT7610U-based wireless USB dongles.
+
 config MT76x2E
 	tristate "MediaTek MT76x2E (PCIe) support"
 	select MT76_CORE
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index dfe1c1ba60db..158d10d2716c 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
+obj-$(CONFIG_MT76x0U) += mt76x0/
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
new file mode 100644
index 000000000000..7843908261ba
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_MT76x0U)    += mt76x0.o
+
+mt76x0-objs	= \
+	usb.o init.o main.o mcu.o trace.o dma.o eeprom.o phy.o \
+	mac.o util.o debugfs.o tx.o core.o
+# ccflags-y := -DDEBUG
+CFLAGS_trace.o := -I$(src)
-- 
1.9.3
