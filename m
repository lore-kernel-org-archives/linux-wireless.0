Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3528 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab2EJMdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 08:33:49 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	=?UTF-8?q?Alex=20Villac=C3=AD=C2=ADs=20Lasso?=
	<a_villacis@palosanto.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] rt2x00: Add support for RT5360 based PCI devices.
Date: Thu, 10 May 2012 14:27:33 +0200
Message-Id: <1336652854-16163-1-git-send-email-gwingerde@gmail.com> (sfid-20120510_143354_432561_B1249890)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alex Villací­s Lasso <a villacis@palosanto.com>

This chip is used at least by the D-Link DWA-525 adapter.

Signed-off-by: Alex Villac<ED>s Lasso <a_villacis@palosanto.com>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++++
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9348521..02f8773 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -51,6 +51,7 @@
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
  * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF5360 2.4G 1T1R
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dfc90d3..11488e7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2060,6 +2060,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF3052:
 		rt2800_config_channel_rf3052(rt2x00dev, conf, rf, info);
 		break;
+	case RF5360:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -2549,6 +2550,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
 		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 		break;
+	case RF5360:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -4263,6 +4265,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3022:
 	case RF3052:
 	case RF3320:
+	case RF5360:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -4577,6 +4580,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3021) ||
 		   rt2x00_rf(rt2x00dev, RF3022) ||
 		   rt2x00_rf(rt2x00dev, RF3320) ||
+		   rt2x00_rf(rt2x00dev, RF5360) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
 		   rt2x00_rf(rt2x00dev, RF5372) ||
 		   rt2x00_rf(rt2x00dev, RF5390)) {
@@ -4662,6 +4666,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3022:
 	case RF3320:
 	case RF3052:
+	case RF5360:
 	case RF5370:
 	case RF5372:
 	case RF5390:
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 931331d..4da36c8 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1188,6 +1188,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x3593) },
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
+	{ PCI_DEVICE(0x1814, 0x5360) },
 	{ PCI_DEVICE(0x1814, 0x5362) },
 	{ PCI_DEVICE(0x1814, 0x5390) },
 	{ PCI_DEVICE(0x1814, 0x5392) },
-- 
1.7.10

