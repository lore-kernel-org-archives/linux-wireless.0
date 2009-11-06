Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:46605 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758296AbZKFVx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 16:53:59 -0500
Message-ID: <4AF49AE9.1040603@redfish-solutions.com>
Date: Fri, 06 Nov 2009 13:53:45 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Don't build SSB modules when SSB isn't present
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Philip A Prindeville <philipp@redfish-solutions.com>

If you're building for a platform that has (for example) no SSB,
then having a single knob to turn to disable this is a major
win.  Especially if more devices get add later that are SSB-based.

Tested.

Signed-off-by: Philip A Prindeville <philipp@redfish-solutions.com>
---
 config.mk |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/config.mk b/config.mk
index ce70832..49be2d0 100644
--- a/config.mk
+++ b/config.mk
@@ -9,6 +9,8 @@ ifeq ($(wildcard $(KLIB_BUILD)/.config),)
  CONFIG_PCI=y
  CONFIG_USB=y
  CONFIG_PCMCIA=y
+ CONFIG_SSB_POSSIBLE=y
+ CONFIG_SSB=m
 else
 include $(KLIB_BUILD)/.config
 endif
@@ -218,6 +220,11 @@ CONFIG_IPW2200_QOS=y
 #
 # % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface

+ifneq ($(CONFIG_SSB),)
+# Sonics Silicon Backplane
+CONFIG_SSB_SPROM=y
+# CONFIG_SSB_DEBUG=y
+
 CONFIG_SSB_BLOCKIO=y
 CONFIG_SSB_PCIHOST_POSSIBLE=y
 CONFIG_SSB_PCIHOST=y
@@ -229,6 +236,7 @@ endif
 # CONFIG_SSB_DEBUG=y
 CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
 CONFIG_SSB_DRIVER_PCICORE=y
+endif

 CONFIG_P54_PCI=m

@@ -397,12 +405,6 @@ CONFIG_WL1251_SPI=m
 CONFIG_WL1251_SDIO=m
 CONFIG_WL1271=m

-# Sonics Silicon Backplane
-CONFIG_SSB_POSSIBLE=y
-CONFIG_SSB=m
-CONFIG_SSB_SPROM=y
-# CONFIG_SSB_DEBUG=y
-
 ifdef CONFIG_COMPAT_WIRELESS_27
 CONFIG_LIBERTAS=n
 else
