Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37857 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0CAJRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:49 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35506.86567.739868@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] ath9k: Remove common module
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All code to be shared between ath9k and ath9k_htc
is part of a common library. This reduces module
proliferation.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |    3 --
 drivers/net/wireless/ath/ath9k/Makefile |    3 --
 drivers/net/wireless/ath/ath9k/ath9k.h  |    6 ----
 drivers/net/wireless/ath/ath9k/common.c |   40 -------------------------------
 drivers/net/wireless/ath/ath9k/common.h |   40 -------------------------------
 drivers/net/wireless/ath/ath9k/htc.h    |    1 -
 6 files changed, 0 insertions(+), 93 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath9k/common.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/common.h

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index fd28803..4fc4bc6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,7 +1,5 @@
 config ATH9K_HW
 	tristate
-config ATH9K_COMMON
-	tristate
 
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
@@ -10,7 +8,6 @@ config ATH9K
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
-	select ATH9K_COMMON
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 518ebb7..afe7e19 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -27,9 +27,6 @@ ath9k_hw-y:=	hw.o \
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
-obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
-ath9k_common-y:=	common.o
-
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
 		wmi.o \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b77aedd..ae369a1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -22,14 +22,8 @@
 #include <linux/leds.h>
 
 #include "debug.h"
-#include "common.h"
 #include "lib.h"
 
-/*
- * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
- * should rely on this file or its contents.
- */
-
 struct ath_node;
 
 /* Macro to expand scalars to 64-bit objects */
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
deleted file mode 100644
index 2a3f835..0000000
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (c) 2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-/*
- * Module for common driver code between ath9k and ath9k_htc
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include "common.h"
-
-MODULE_AUTHOR("Atheros Communications");
-MODULE_DESCRIPTION("Shared library for Atheros wireless 802.11n LAN cards.");
-MODULE_LICENSE("Dual BSD/GPL");
-
-static int __init ath9k_cmn_init(void)
-{
-	return 0;
-}
-module_init(ath9k_cmn_init);
-
-static void __exit ath9k_cmn_exit(void)
-{
-	return;
-}
-module_exit(ath9k_cmn_exit);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
deleted file mode 100644
index 7dcf938..0000000
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (c) 2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <net/mac80211.h>
-
-#include "../ath.h"
-#include "../debug.h"
-
-#include "hw.h"
-
-/* Common header for Atheros 802.11n base driver cores */
-
-#define ATH_RSSI_DUMMY_MARKER   0x127
-#define ATH_RSSI_LPF_LEN 		10
-#define RSSI_LPF_THRESHOLD		-20
-#define ATH_RSSI_EP_MULTIPLIER     (1<<7)
-#define ATH_EP_MUL(x, mul)         ((x) * (mul))
-#define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
-#define ATH_LPF_RSSI(x, y, len) \
-    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
-#define ATH_RSSI_LPF(x, y) do {                     			\
-    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
-	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
-} while (0)
-#define ATH_EP_RND(x, mul) 						\
-	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
-
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ad5ce09..201d149 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -25,7 +25,6 @@
 #include <linux/leds.h>
 #include <net/mac80211.h>
 
-#include "common.h"
 #include "htc_hst.h"
 #include "hif_usb.h"
 #include "wmi.h"
-- 
1.7.0.1

