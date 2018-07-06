Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932328AbeGFLEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:04:13 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 12/12] mt76: Kconfig and Makefile for mt76x0 driver
Date: Fri,  6 Jul 2018 13:03:49 +0200
Message-Id: <1530875029-26274-13-git-send-email-sgruszka@redhat.com> (sfid-20180706_130426_185387_2FA72825)
In-Reply-To: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
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
index fc05d79c80d0..84854736809a 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -1,6 +1,13 @@
 config MT76_CORE
 	tristate
 
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
index a0156bc01dea..08f93127e9e7 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
+obj-$(CONFIG_MT76x0U) += mt76x0/
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 
 mt76-y := \
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
