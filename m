Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36883 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016Ab3CPSTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:32 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 02/25] rt2800: 5592: early defines
Date: Sat, 16 Mar 2013 19:19:30 +0100
Message-Id: <1363457993-15541-3-git-send-email-stf_xl@wp.pl> (sfid-20130316_191936_521843_32272928)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Add basic defines for 5592 chip. It can not be enabled until
CONFIG_RT2800USB_RT55XX configuration option will be provided in the
Kconfig.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 +++
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 4 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 4db1088..58c0164 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -51,6 +51,7 @@
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
  * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF5592 2.4G/5G 2T2R
  * RF5360 2.4G 1T1R
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
@@ -68,6 +69,7 @@
 #define RF3320				0x000b
 #define RF3322				0x000c
 #define RF3053				0x000d
+#define RF5592				0x000f
 #define RF3290				0x3290
 #define RF5360				0x5360
 #define RF5370				0x5370
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 182e598..45f58c9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4863,6 +4863,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT3572:
 	case RT5390:
 	case RT5392:
+	case RT5592:
 		break;
 	default:
 		ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
@@ -4887,6 +4888,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF5372:
 	case RF5390:
 	case RF5392:
+	case RF5592:
 		break;
 	default:
 		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 098613e..f9ca795 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1200,6 +1200,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x5370) },
 	{ USB_DEVICE(0x148f, 0x5372) },
 #endif
+#ifdef CONFIG_RT2800USB_RT55XX
+	{ USB_DEVICE(0x148f, 0x5572) },
+#endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
 	 * Unclear what kind of devices these are (they aren't supported by the
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 086abb4..4251835 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -193,6 +193,7 @@ struct rt2x00_chip {
 #define RT3883		0x3883	/* WSOC */
 #define RT5390		0x5390  /* 2.4GHz */
 #define RT5392		0x5392  /* 2.4GHz */
+#define RT5592		0x5592
 
 	u16 rf;
 	u16 rev;
-- 
1.7.4.4

