Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29723 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbbFDE5S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 00:57:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t544vDMG011972
	for <linux-wireless@vger.kernel.org>; Wed, 3 Jun 2015 21:57:17 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvkjnx-1
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 21:57:15 -0700
From: David Lin <dlin@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Pete Hsieh <peteh@marvell.com>, Chor Teck Law <ctlaw@marvell.com>
Subject: [PATCH] Add new mac80211 driver mwlwifi.
Date: Thu, 4 Jun 2015 04:57:11 +0000
Message-ID: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com> (sfid-20150604_065726_449748_FA29E81C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Lin <dlin@marvell.com>
---
 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/Makefile               |    2 +
 drivers/net/wireless/mwlwifi/Kconfig        |   17 +
 drivers/net/wireless/mwlwifi/Makefile       |    9 +
 drivers/net/wireless/mwlwifi/mwl_debug.c    |  207 ++
 drivers/net/wireless/mwlwifi/mwl_debug.h    |  118 +
 drivers/net/wireless/mwlwifi/mwl_dev.h      |  465 ++++
 drivers/net/wireless/mwlwifi/mwl_fwcmd.c    | 3615 +++++++++++++++++++++++++++
 drivers/net/wireless/mwlwifi/mwl_fwcmd.h    |  184 ++
 drivers/net/wireless/mwlwifi/mwl_fwdl.c     |  218 ++
 drivers/net/wireless/mwlwifi/mwl_fwdl.h     |   29 +
 drivers/net/wireless/mwlwifi/mwl_mac80211.c |  877 +++++++
 drivers/net/wireless/mwlwifi/mwl_mac80211.h |   32 +
 drivers/net/wireless/mwlwifi/mwl_main.c     | 1095 ++++++++
 drivers/net/wireless/mwlwifi/mwl_rx.c       |  589 +++++
 drivers/net/wireless/mwlwifi/mwl_rx.h       |   30 +
 drivers/net/wireless/mwlwifi/mwl_sysadpt.h  |   64 +
 drivers/net/wireless/mwlwifi/mwl_tx.c       |  892 +++++++
 drivers/net/wireless/mwlwifi/mwl_tx.h       |   34 +
 19 files changed, 8478 insertions(+)
 create mode 100644 drivers/net/wireless/mwlwifi/Kconfig
 create mode 100644 drivers/net/wireless/mwlwifi/Makefile
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_debug.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_debug.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_dev.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwcmd.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwcmd.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwdl.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwdl.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_mac80211.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_mac80211.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_main.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_rx.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_rx.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_sysadpt.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_tx.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_tx.h

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index a63ab2e..1c60845 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -284,5 +284,6 @@ source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
 source "drivers/net/wireless/cw1200/Kconfig"
 source "drivers/net/wireless/rsi/Kconfig"
+source "drivers/net/wireless/mwlwifi/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 6b9e729..9c6c07c 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -62,3 +62,5 @@ obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
 
 obj-$(CONFIG_CW1200)	+= cw1200/
 obj-$(CONFIG_RSI_91X)	+= rsi/
+
+obj-$(CONFIG_MWLWIFI) += mwlwifi/
diff --git a/drivers/net/wireless/mwlwifi/Kconfig b/drivers/net/wireless/mwlwifi/Kconfig
new file mode 100644
index 0000000..ffafe5d
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/Kconfig
@@ -0,0 +1,17 @@
+config MWLWIFI
+	tristate "Marvell Wireless WiFi driver (mwlwifi)"
+	depends on PCI && MAC80211
+	select FW_LOADER
+	select OF
+	---help---
+	  Select to build the driver supporting the:
+
+	  Marvell Wireless WiFi 88W8864 modules
+	  Marvell Wireless WiFi 88W8897 modules
+
+	  This driver uses the kernel's mac80211 subsystem.
+
+	  If you want to compile the driver as a module (= code which can be
+	  inserted in and removed from the running kernel whenever you want),
+	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
+	  module will be called mwlwifi.
diff --git a/drivers/net/wireless/mwlwifi/Makefile b/drivers/net/wireless/mwlwifi/Makefile
new file mode 100644
index 0000000..ad97138
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_MWLWIFI)	+= mwlwifi.o
+
+mwlwifi-objs		+= mwl_main.o
+mwlwifi-objs		+= mwl_mac80211.o
+mwlwifi-objs		+= mwl_fwdl.o
+mwlwifi-objs		+= mwl_fwcmd.o
+mwlwifi-objs		+= mwl_tx.o
+mwlwifi-objs		+= mwl_rx.o
+mwlwifi-objs		+= mwl_debug.o
diff --git a/drivers/net/wireless/mwlwifi/mwl_debug.c b/drivers/net/wireless/mwlwifi/mwl_debug.c
new file mode 100644
index 0000000..1ac270c
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_debug.c
@@ -0,0 +1,207 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements debug related functions.
+*/
+
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "mwl_debug.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define WLDBG_CLASSES ( \
+	DBG_CLASS_PANIC | \
+	DBG_CLASS_ERROR | \
+	DBG_CLASS_WARNING | \
+	DBG_CLASS_INFO | \
+	DBG_CLASS_DATA | \
+	DBG_CLASS_ENTER | \
+	DBG_CLASS_EXIT)
+
+#define PRT_8BYTES "0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n"
+
+/* PRIVATE VARIABLES
+*/
+
+static u32 dbg_levels;
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+void mwl_debug_prt(u32 classlevel, const char *func, const char *format, ...)
+{
+	unsigned char *debug_string;
+	u32 level = classlevel & 0x0000ffff;
+	u32 class = classlevel & 0xffff0000;
+	va_list a_start;
+
+	if (classlevel != 0) {
+		if ((class & WLDBG_CLASSES) != class)
+			return;
+
+		if ((level & dbg_levels) != level) {
+			if (class != DBG_CLASS_PANIC &&
+			    class != DBG_CLASS_ERROR)
+				return;
+		}
+	}
+
+	debug_string = kmalloc(1024, GFP_ATOMIC);
+
+	if (!debug_string)
+		return;
+
+	if (format) {
+		va_start(a_start, format);
+		vsprintf(debug_string, format, a_start);
+		va_end(a_start);
+	} else {
+		debug_string[0] = '\0';
+	}
+
+	switch (class) {
+	case DBG_CLASS_ENTER:
+		pr_debug("Enter %s() ...\n", func);
+		break;
+	case DBG_CLASS_EXIT:
+		pr_debug("... Exit %s()\n", func);
+		break;
+	case DBG_CLASS_WARNING:
+		pr_debug("WARNING: ");
+		break;
+	case DBG_CLASS_ERROR:
+		pr_debug("ERROR: ");
+		break;
+	case DBG_CLASS_PANIC:
+		pr_debug("PANIC: ");
+		break;
+	default:
+		break;
+	}
+
+	if (strlen(debug_string) > 0) {
+		if (debug_string[strlen(debug_string) - 1] == '\n')
+			debug_string[strlen(debug_string) - 1] = '\0';
+			pr_debug("%s(): %s\n", func, debug_string);
+	}
+
+	kfree(debug_string);
+}
+
+void mwl_debug_prtdata(u32 classlevel, const char *func,
+		       const void *data, int len, const char *format, ...)
+{
+	unsigned char *dbg_string;
+	unsigned char dbg_data[16] = "";
+	unsigned char *memptr = (unsigned char *)data;
+	u32 level = classlevel & 0x0000ffff;
+	u32 class = classlevel & 0xffff0000;
+	int curr_byte = 0;
+	int num_bytes = 0;
+	int offset = 0;
+	va_list a_start;
+
+	if ((class & WLDBG_CLASSES) != class)
+		return;
+
+	if ((level & dbg_levels) != level)
+		return;
+
+	dbg_string = kmalloc(len + 1024, GFP_ATOMIC);
+
+	if (!dbg_string)
+		return;
+
+	if (format) {
+		va_start(a_start, format);
+		vsprintf(dbg_string, format, a_start);
+		va_end(a_start);
+	} else {
+		dbg_string[0] = '\0';
+	}
+
+	if (strlen(dbg_string) > 0) {
+		if (dbg_string[strlen(dbg_string) - 1] == '\n')
+			dbg_string[strlen(dbg_string) - 1] = '\0';
+			pr_debug("%s() %s\n", func, dbg_string);
+	} else {
+		pr_debug("%s()\n", func);
+	}
+
+	for (curr_byte = 0; curr_byte < len; curr_byte = curr_byte + 8) {
+		if ((curr_byte + 8) < len) {
+			pr_debug(PRT_8BYTES,
+				 *(memptr + curr_byte + 0),
+				 *(memptr + curr_byte + 1),
+				 *(memptr + curr_byte + 2),
+				 *(memptr + curr_byte + 3),
+				 *(memptr + curr_byte + 4),
+				 *(memptr + curr_byte + 5),
+				 *(memptr + curr_byte + 6),
+				 *(memptr + curr_byte + 7));
+		} else {
+			num_bytes = len - curr_byte;
+			offset = curr_byte;
+			for (curr_byte = 0; curr_byte < num_bytes;
+				curr_byte++) {
+				sprintf(dbg_data, "0x%02x ",
+					*(memptr + offset + curr_byte));
+				strcat(dbg_string, dbg_data);
+			}
+			pr_debug("%s\n", dbg_string);
+			break;
+		}
+	}
+
+	kfree(dbg_string);
+}
+
+void mwl_debug_dumpdata(const void *data, int len, char *marker)
+{
+	unsigned char *memptr = (unsigned char *)data;
+	int curr_byte = 0;
+	int num_bytes = 0;
+	int offset = 0;
+
+	pr_debug("%s\n", marker);
+
+	for (curr_byte = 0; curr_byte < len; curr_byte = curr_byte + 8) {
+		if ((curr_byte + 8) < len) {
+			pr_debug(PRT_8BYTES,
+				 *(memptr + curr_byte + 0),
+				 *(memptr + curr_byte + 1),
+				 *(memptr + curr_byte + 2),
+				 *(memptr + curr_byte + 3),
+				 *(memptr + curr_byte + 4),
+				 *(memptr + curr_byte + 5),
+				 *(memptr + curr_byte + 6),
+				 *(memptr + curr_byte + 7));
+		} else {
+			num_bytes = len - curr_byte;
+			offset = curr_byte;
+			for (curr_byte = 0; curr_byte < num_bytes;
+			     curr_byte++)
+				pr_debug("0x%02x ",
+					 *(memptr + offset + curr_byte));
+			pr_debug("\n\n");
+			break;
+		}
+	}
+}
diff --git a/drivers/net/wireless/mwlwifi/mwl_debug.h b/drivers/net/wireless/mwlwifi/mwl_debug.h
new file mode 100644
index 0000000..226db7b
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_debug.h
@@ -0,0 +1,118 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines debug related functions.
+*/
+
+#ifndef _mwl_debug_h_
+#define _mwl_debug_h_
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+/* CONSTANTS AND MACROS
+*/
+
+#define DBG_LEVEL_0 BIT(0)    /* mwl_main.c     */
+#define DBG_LEVEL_1 BIT(1)    /* mwl_fwdl.c     */
+#define DBG_LEVEL_2 BIT(2)    /* mwl_fwcmd.c    */
+#define DBG_LEVEL_3 BIT(3)    /* mwl_tx.c       */
+#define DBG_LEVEL_4 BIT(4)    /* mwl_rx.c       */
+#define DBG_LEVEL_5 BIT(5)    /* mwl_mac80211.c */
+#define DBG_LEVEL_6 BIT(6)
+#define DBG_LEVEL_7 BIT(7)
+#define DBG_LEVEL_8 BIT(8)
+#define DBG_LEVEL_9 BIT(9)
+#define DBG_LEVEL_10 BIT(10)
+#define DBG_LEVEL_11 BIT(11)
+#define DBG_LEVEL_12 BIT(12)
+#define DBG_LEVEL_13 BIT(13)
+#define DBG_LEVEL_14 BIT(14)
+#define DBG_LEVEL_15 BIT(15)
+
+#define DBG_CLASS_PANIC BIT(16)
+#define DBG_CLASS_ERROR BIT(17)
+#define DBG_CLASS_WARNING BIT(18)
+#define DBG_CLASS_ENTER BIT(19)
+#define DBG_CLASS_EXIT BIT(20)
+#define DBG_CLASS_INFO BIT(21)
+#define DBG_CLASS_DATA BIT(22)
+#define DBG_CLASS_7 BIT(23)
+#define DBG_CLASS_8 BIT(24)
+#define DBG_CLASS_9 BIT(25)
+#define DBG_CLASS_10 BIT(26)
+#define DBG_CLASS_11 BIT(27)
+#define DBG_CLASS_12 BIT(28)
+#define DBG_CLASS_13 BIT(29)
+#define DBG_CLASS_14 BIT(30)
+#define DBG_CLASS_15 BIT(31)
+
+#define WLDBG_PRINT(...) \
+	mwl_debug_prt(0, __func__, __VA_ARGS__)
+
+#ifdef MWL_DEBUG
+
+#define WLDBG_DUMP_DATA(classlevel, data, len) \
+	mwl_debug_prtdata(classlevel | DBG_CLASS_DATA, \
+	__func__, data, len, NULL)
+
+#define WLDBG_ENTER(classlevel) \
+	mwl_debug_prt(classlevel | DBG_CLASS_ENTER, __func__, NULL)
+
+#define WLDBG_ENTER_INFO(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_ENTER, __func__, __VA_ARGS__)
+
+#define WLDBG_EXIT(classlevel) \
+	mwl_debug_prt(classlevel | DBG_CLASS_EXIT, __func__, NULL)
+
+#define WLDBG_EXIT_INFO(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_EXIT, __func__, __VA_ARGS__)
+
+#define WLDBG_INFO(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_INFO, __func__, __VA_ARGS__)
+
+#define WLDBG_WARNING(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_WARNING, __func__, __VA_ARGS__)
+
+#define WLDBG_ERROR(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_ERROR, __func__, __VA_ARGS__)
+
+#define WLDBG_PANIC(classlevel, ...) \
+	mwl_debug_prt(classlevel | DBG_CLASS_PANIC, __func__, __VA_ARGS__)
+
+#else
+
+#define WLDBG_DUMP_DATA(classlevel, data, len)
+#define WLDBG_ENTER(classlevel)
+#define WLDBG_ENTER_INFO(classlevel, ...)
+#define WLDBG_EXIT(classlevel)
+#define WLDBG_EXIT_INFO(classlevel, ...)
+#define WLDBG_INFO(classlevel, ...)
+#define WLDBG_WARNING(classlevel, ...)
+#define WLDBG_ERROR(classlevel, ...)
+#define WLDBG_PANIC(classlevel, ...)
+
+#endif /* MWL_DEBUG */
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+
+void mwl_debug_prt(u32 classlevel, const char *func, const char *format, ...);
+void mwl_debug_prtdata(u32 classlevel, const char *func,
+		       const void *data, int len, const char *format, ...);
+void mwl_debug_dumpdata(const void *data, int len, char *marker);
+
+#endif /* _mwl_debug_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_dev.h b/drivers/net/wireless/mwlwifi/mwl_dev.h
new file mode 100644
index 0000000..7c6facc2
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_dev.h
@@ -0,0 +1,465 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines device related information.
+*/
+
+#ifndef _mwl_dev_h_
+#define _mwl_dev_h_
+
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include <linux/bitops.h>
+#include <net/mac80211.h>
+
+/* CONSTANTS AND MACROS
+*/
+
+/* Map to 0x80000000 (Bus control) on BAR0
+*/
+#define MACREG_REG_H2A_INTERRUPT_EVENTS      0x00000C18 /* (From host to ARM) */
+#define MACREG_REG_H2A_INTERRUPT_CAUSE       0x00000C1C /* (From host to ARM) */
+#define MACREG_REG_H2A_INTERRUPT_MASK        0x00000C20 /* (From host to ARM) */
+#define MACREG_REG_H2A_INTERRUPT_CLEAR_SEL   0x00000C24 /* (From host to ARM) */
+#define MACREG_REG_H2A_INTERRUPT_STATUS_MASK 0x00000C28 /* (From host to ARM) */
+
+#define MACREG_REG_A2H_INTERRUPT_EVENTS      0x00000C2C /* (From ARM to host) */
+#define MACREG_REG_A2H_INTERRUPT_CAUSE       0x00000C30 /* (From ARM to host) */
+#define MACREG_REG_A2H_INTERRUPT_MASK        0x00000C34 /* (From ARM to host) */
+#define MACREG_REG_A2H_INTERRUPT_CLEAR_SEL   0x00000C38 /* (From ARM to host) */
+#define MACREG_REG_A2H_INTERRUPT_STATUS_MASK 0x00000C3C /* (From ARM to host) */
+
+/* Map to 0x80000000 on BAR1
+*/
+#define MACREG_REG_GEN_PTR                  0x00000C10
+#define MACREG_REG_INT_CODE                 0x00000C14
+#define MACREG_REG_SCRATCH                  0x00000C40
+#define MACREG_REG_FW_PRESENT               0x0000BFFC
+
+/* Bit definitio for MACREG_REG_A2H_INTERRUPT_CAUSE (A2HRIC)
+*/
+#define MACREG_A2HRIC_BIT_TX_DONE           0x00000001 /* bit 0 */
+#define MACREG_A2HRIC_BIT_RX_RDY            0x00000002 /* bit 1 */
+#define MACREG_A2HRIC_BIT_OPC_DONE          0x00000004 /* bit 2 */
+#define MACREG_A2HRIC_BIT_MAC_EVENT         0x00000008 /* bit 3 */
+#define MACREG_A2HRIC_BIT_RX_PROBLEM        0x00000010 /* bit 4 */
+#define MACREG_A2HRIC_BIT_RADIO_OFF         0x00000020 /* bit 5 */
+#define MACREG_A2HRIC_BIT_RADIO_ON          0x00000040 /* bit 6 */
+#define MACREG_A2HRIC_BIT_RADAR_DETECT      0x00000080 /* bit 7 */
+#define MACREG_A2HRIC_BIT_ICV_ERROR         0x00000100 /* bit 8 */
+#define MACREG_A2HRIC_BIT_WEAKIV_ERROR      0x00000200 /* bit 9 */
+#define MACREG_A2HRIC_BIT_QUEUE_EMPTY       BIT(10)
+#define MACREG_A2HRIC_BIT_QUEUE_FULL        BIT(11)
+#define MACREG_A2HRIC_BIT_CHAN_SWITCH       BIT(12) /* IEEE80211_DH */
+#define MACREG_A2HRIC_BIT_TX_WATCHDOG       BIT(13)
+#define MACREG_A2HRIC_BA_WATCHDOG           BIT(14)
+#define MACREG_A2HRIC_BIT_SSU_DONE          BIT(16)
+#define MACREG_A2HRIC_CONSEC_TXFAIL         BIT(17) /* 15 taken by ISR_TXACK */
+
+#define ISR_SRC_BITS        ((MACREG_A2HRIC_BIT_RX_RDY) | \
+			     (MACREG_A2HRIC_BIT_TX_DONE) | \
+			     (MACREG_A2HRIC_BIT_OPC_DONE) | \
+			     (MACREG_A2HRIC_BIT_MAC_EVENT) | \
+			     (MACREG_A2HRIC_BIT_WEAKIV_ERROR) | \
+			     (MACREG_A2HRIC_BIT_ICV_ERROR) | \
+			     (MACREG_A2HRIC_BIT_SSU_DONE) | \
+			     (MACREG_A2HRIC_BIT_RADAR_DETECT) | \
+			     (MACREG_A2HRIC_BIT_CHAN_SWITCH) | \
+			     (MACREG_A2HRIC_BIT_TX_WATCHDOG) | \
+			     (MACREG_A2HRIC_BIT_QUEUE_EMPTY) | \
+			     (MACREG_A2HRIC_BA_WATCHDOG) | \
+			     (MACREG_A2HRIC_CONSEC_TXFAIL))
+
+#define MACREG_A2HRIC_BIT_MASK      ISR_SRC_BITS
+
+/* Bit definitio for MACREG_REG_H2A_INTERRUPT_CAUSE (H2ARIC)
+*/
+#define MACREG_H2ARIC_BIT_PPA_READY         0x00000001 /* bit 0 */
+#define MACREG_H2ARIC_BIT_DOOR_BELL         0x00000002 /* bit 1 */
+#define MACREG_H2ARIC_BIT_PS                0x00000004 /* bit 2 */
+#define MACREG_H2ARIC_BIT_PSPOLL            0x00000008 /* bit 3 */
+#define ISR_RESET                           BIT(15)
+#define ISR_RESET_AP33                      BIT(26)
+
+/* Data descriptor related constants
+*/
+#define EAGLE_RXD_CTRL_DRIVER_OWN               0x00
+#define EAGLE_RXD_CTRL_OS_OWN                   0x04
+#define EAGLE_RXD_CTRL_DMA_OWN                  0x80
+
+#define EAGLE_RXD_STATUS_IDLE                   0x00
+#define EAGLE_RXD_STATUS_OK                     0x01
+#define EAGLE_RXD_STATUS_MULTICAST_RX           0x02
+#define EAGLE_RXD_STATUS_BROADCAST_RX           0x04
+#define EAGLE_RXD_STATUS_FRAGMENT_RX            0x08
+
+#define EAGLE_TXD_STATUS_IDLE                   0x00000000
+#define EAGLE_TXD_STATUS_USED                   0x00000001
+#define EAGLE_TXD_STATUS_OK                     0x00000001
+#define EAGLE_TXD_STATUS_OK_RETRY               0x00000002
+#define EAGLE_TXD_STATUS_OK_MORE_RETRY          0x00000004
+#define EAGLE_TXD_STATUS_MULTICAST_TX           0x00000008
+#define EAGLE_TXD_STATUS_BROADCAST_TX           0x00000010
+#define EAGLE_TXD_STATUS_FAILED_LINK_ERROR      0x00000020
+#define EAGLE_TXD_STATUS_FAILED_EXCEED_LIMIT    0x00000040
+#define EAGLE_TXD_STATUS_FAILED_AGING           0x00000080
+#define EAGLE_TXD_STATUS_FW_OWNED               0x80000000
+
+#define EAGLE_TXD_XMITCTRL_USE_RATEINFO         0x1
+#define EAGLE_TXD_XMITCTRL_DISABLE_AMPDU        0x2
+#define EAGLE_TXD_XMITCTRL_ENABLE_AMPDU         0x4
+#define EAGLE_TXD_XMITCTRL_USE_MC_RATE          0x8
+
+#define NBR_BYTES_FW_RX_PREPEND_LEN             2
+#define NBR_BYTES_FW_TX_PREPEND_LEN             2
+
+/* Antenna control
+*/
+#define ANTENNA_TX_4_AUTO                       0
+#define ANTENNA_TX_2                            3
+#define ANTENNA_RX_4_AUTO                       0
+#define ANTENNA_RX_2                            2
+
+/* Band related constants
+*/
+#define BAND_24_CHANNEL_NUM                     14
+#define BAND_24_RATE_NUM                        13
+#define BAND_50_CHANNEL_NUM                     24
+#define BAND_50_RATE_NUM                        8
+
+/* Misc
+*/
+#define WL_SEC_SLEEP(num_secs)              mdelay(num_secs * 1000)
+#define WL_MSEC_SLEEP(num_milli_secs)       mdelay(num_milli_secs)
+
+#define ENDIAN_SWAP32(_val)                 (cpu_to_le32(_val))
+#define ENDIAN_SWAP16(_val)                 (cpu_to_le16(_val))
+
+#define DECLARE_LOCK(l)                     spinlock_t l
+#define SPIN_LOCK_INIT(l)                   spin_lock_init(l)
+#define SPIN_LOCK(l)                        spin_lock(l)
+#define SPIN_UNLOCK(l)                      spin_unlock(l)
+#define SPIN_LOCK_IRQSAVE(l, f)             spin_lock_irqsave(l, f)
+#define SPIN_UNLOCK_IRQRESTORE(l, f)        spin_unlock_irqrestore(l, f)
+
+/* vif and station
+*/
+#define MAX_WEP_KEY_LEN              13
+#define NUM_WEP_KEYS                 4
+#define MWL_MAX_TID                  8
+#define MWL_VIF(_vif)                ((struct mwl_vif *)&((_vif)->drv_priv))
+#define IEEE80211_KEY_CONF(_u8)      ((struct ieee80211_key_conf *)(_u8))
+#define MWL_STA(_sta)                ((struct mwl_sta *)&((_sta)->drv_priv))
+
+/* TYPE DEFINITION
+*/
+
+enum {
+	MWL8864 = 0,
+	MWL8897,
+	MWLUNKNOWN,
+};
+
+enum {
+	AP_MODE_11AC = 0x10,         /* generic 11ac indication mode */
+	AP_MODE_2_4GHZ_11AC_MIXED = 0x17,
+};
+
+enum {
+	AMPDU_NO_STREAM,
+	AMPDU_STREAM_NEW,
+	AMPDU_STREAM_IN_PROGRESS,
+	AMPDU_STREAM_ACTIVE,
+};
+
+enum {
+	IEEE_TYPE_MANAGEMENT = 0,
+	IEEE_TYPE_CONTROL,
+	IEEE_TYPE_DATA
+};
+
+struct mwl_chip_info {
+	char *part_name;
+	char *fw_image;
+};
+
+struct mwl_tx_pwr_tbl {
+	u8 channel;
+	u8 setcap;
+	u16 tx_power[SYSADPT_TX_POWER_LEVEL_TOTAL];
+	u8 cdd;                      /* 0: off, 1: on */
+	u16 txantenna2;
+};
+
+struct mwl_hw_data {
+	u32 fw_release_num;          /* MajNbr:MinNbr:SubMin:PatchLevel */
+	u8 hw_version;               /* plain number indicating version */
+	u8 host_interface;           /* plain number of interface       */
+	u16 max_num_tx_desc;         /* max number of TX descriptors    */
+	u16 max_num_mc_addr;         /* max number multicast addresses  */
+	u16 num_antennas;            /* number antennas used            */
+	u16 region_code;             /* region (eg. 0x10 for USA FCC)   */
+	unsigned char mac_addr[ETH_ALEN]; /* well known -> AA:BB:CC:DD:EE:FF */
+};
+
+struct mwl_rate_info {
+	u32 format:2;        /* 0 = Legacy, 1 = 11n, 2 = 11ac */
+	u32 stbc:1;
+	u32 rsvd1:1;
+	u32 bandwidth:2;     /* 0 = 20 MHz, 1 = 40 MHz, 2 = 80 MHz */
+	u32 short_gi:1;      /* 0 = standard guard interval, 1 = short */
+	u32 rsvd2:1;
+	u32 rate_id_mcs:7;
+	u32 preamble_type:1; /* Preambletype 0 = Long, 1 = Short; */
+	u32 power_id:6;
+	u32 adv_coding:1;    /* ldpc */
+	u32 bf:1;
+	u32 ant_select:8;    /* Bitmap to select one of the transmit antenna */
+} __packed;
+
+struct mwl_tx_desc {
+	u8 data_rate;
+	u8 tx_priority;
+	u16 qos_ctrl;
+	u32 pkt_ptr;
+	u16 pkt_len;
+	u8 dest_addr[ETH_ALEN];
+	u32 pphys_next;
+	u32 sap_pkt_info;
+	struct mwl_rate_info rate_info;
+	u8 type;
+	u8 xmit_control;     /* bit 0: use rateinfo, bit 1: disable ampdu */
+	u16 reserved;
+	u32 tcpack_sn;
+	u32 tcpack_src_dst;
+	struct sk_buff *psk_buff;
+	struct mwl_tx_desc *pnext;
+	u8 reserved1[2];
+	u8 packet_info;
+	u8 packet_id;
+	u16 packet_len_and_retry;
+	u16 packet_rate_info;
+	u8 *sta_info;
+	u32 status;
+} __packed;
+
+struct mwl_hw_rssi_info {
+	u32 rssi_a:8;
+	u32 rssi_b:8;
+	u32 rssi_c:8;
+	u32 rssi_d:8;
+} __packed;
+
+struct mwl_hw_noise_floor_info {
+	u32 noise_floor_a:8;
+	u32 noise_floor_b:8;
+	u32 noise_floor_c:8;
+	u32 noise_floor_d:8;
+} __packed;
+
+struct mwl_rxrate_info {
+	u16 format:3;    /* 0: 11a, 1: 11b, 2: 11n, 4: 11ac    */
+	u16 nss:2;       /* number space spectrum              */
+	u16 bw:2;        /* 0: ht20, 1: ht40, 2: ht80          */
+	u16 gi:1;        /* 0: long interval, 1: short interval*/
+	u16 rt:8;        /* 11a/11b: 1,2,5,11,22,6,9,12,18,24,36,48,54,72*/
+} __packed;              /* 11n/11ac: MCS                      */
+
+struct mwl_rx_desc {
+	u16 pkt_len;                 /* total length of received data      */
+	struct mwl_rxrate_info rate; /* receive rate information           */
+	u32 pphys_buff_data;         /* physical address of payload data   */
+	u32 pphys_next;              /* physical address of next RX desc   */
+	u16 qos_ctrl;                /* received QosCtrl field variable    */
+	u16 ht_sig2;                 /* like name states                   */
+	struct mwl_hw_rssi_info hw_rssi_info;
+	struct mwl_hw_noise_floor_info hw_noise_floor_info;
+	u8 noise_floor;
+	u8 reserved[3];
+	u8 rssi;                     /* received signal strengt indication */
+	u8 status;                   /* status field containing USED bit   */
+	u8 channel;                  /* channel this pkt was received on   */
+	u8 rx_control;               /* the control element of the desc    */
+	/* above are 32bits aligned and is same as FW, RxControl put at end
+	 * for sync
+	 */
+	struct sk_buff *psk_buff;    /* associated sk_buff for Linux       */
+	void *pbuff_data;            /* virtual address of payload data    */
+	struct mwl_rx_desc *pnext;   /* virtual address of next RX desc    */
+} __packed;
+
+struct mwl_desc_data {
+	dma_addr_t pphys_tx_ring;          /* ptr to first TX desc (phys.)    */
+	struct mwl_tx_desc *ptx_ring;      /* ptr to first TX desc (virt.)    */
+	struct mwl_tx_desc *pnext_tx_desc; /* next TX desc that can be used   */
+	struct mwl_tx_desc *pstale_tx_desc;/* the staled TX descriptor        */
+	dma_addr_t pphys_rx_ring;          /* ptr to first RX desc (phys.)    */
+	struct mwl_rx_desc *prx_ring;      /* ptr to first RX desc (virt.)    */
+	struct mwl_rx_desc *pnext_rx_desc; /* next RX desc that can be used   */
+	unsigned int wcb_base;             /* FW base offset for registers    */
+	unsigned int rx_desc_write;        /* FW descriptor write position    */
+	unsigned int rx_desc_read;         /* FW descriptor read position     */
+	unsigned int rx_buf_size;          /* length of the RX buffers        */
+} __packed;
+
+struct mwl_locks {
+	DECLARE_LOCK(xmit_lock);           /* used to protect TX actions      */
+	DECLARE_LOCK(fwcmd_lock);          /* used to protect FW commands     */
+	DECLARE_LOCK(stream_lock);         /* used to protect stream          */
+};
+
+struct mwl_ampdu_stream {
+	struct ieee80211_sta *sta;
+	u8 tid;
+	u8 state;
+	u8 idx;
+};
+
+struct mwl_priv {
+	struct ieee80211_hw *hw;
+	const struct firmware *fw_ucode;
+	int chip_type;
+	struct device_node *dt_node;
+	struct device_node *pwr_node;
+	bool disable_2g;
+	bool disable_5g;
+	int antenna_tx;
+	int antenna_rx;
+	struct mwl_tx_pwr_tbl tx_pwr_tbl[SYSADPT_MAX_NUM_CHANNELS];
+	u32 cdd;                     /* 0: off, 1: on */
+	u16 txantenna2;
+	u8 powinited;
+	u16 max_tx_pow[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* max tx power (dBm) */
+	u16 target_powers[SYSADPT_TX_POWER_LEVEL_TOTAL]; /* target powers   */
+	u8 cal_tbl[200];
+	struct pci_dev *pdev;
+	void *iobase0;               /* MEM Base Address Register 0  */
+	void *iobase1;               /* MEM Base Address Register 1  */
+	u32 next_bar_num;
+	unsigned short *pcmd_buf;    /* pointer to CmdBuf (virtual)  */
+	dma_addr_t pphys_cmd_buf;    /* pointer to CmdBuf (physical) */
+	bool in_send_cmd;
+	int irq;
+	struct mwl_hw_data hw_data;  /* Adapter HW specific info     */
+	/* various descriptor data */
+	struct mwl_desc_data desc_data[SYSADPT_NUM_OF_DESC_DATA];
+	struct sk_buff_head txq[SYSADPT_NUM_OF_DESC_DATA];
+	struct sk_buff_head delay_q;
+	/* number of descriptors owned by fw at any one time */
+	int fw_desc_cnt[SYSADPT_NUM_OF_DESC_DATA];
+	struct mwl_locks locks;      /* various spinlocks */
+	struct tasklet_struct tx_task;
+	struct tasklet_struct rx_task;
+	int txq_limit;
+	bool is_tx_schedule;
+	int recv_limit;
+	bool is_rx_schedule;
+	s8 noise;                    /* Most recently reported noise in dBm */
+	struct ieee80211_supported_band band_24;
+	struct ieee80211_channel channels_24[BAND_24_CHANNEL_NUM];
+	struct ieee80211_rate rates_24[BAND_24_RATE_NUM];
+	struct ieee80211_supported_band band_50;
+	struct ieee80211_channel channels_50[BAND_50_CHANNEL_NUM];
+	struct ieee80211_rate rates_50[BAND_50_RATE_NUM];
+	u32 ap_macids_supported;
+	u32 sta_macids_supported;
+	u32 macids_used;
+	struct list_head vif_list;   /* List of interfaces.          */
+	u32 running_bsses;           /* bitmap of running BSSes      */
+	bool radio_on;
+	bool radio_short_preamble;
+	bool wmm_enabled;
+	struct ieee80211_tx_queue_params wmm_params[SYSADPT_TX_WMM_QUEUES];
+	/* Ampdu stream information */
+	u8 num_ampdu_queues;
+	struct mwl_ampdu_stream ampdu[SYSADPT_TX_AMPDU_QUEUES];
+	struct work_struct watchdog_ba_handle;
+};
+
+struct beacon_info {
+	bool valid;
+	u16 cap_info;
+	u8 b_rate_set[SYSADPT_MAX_DATA_RATES_G];
+	u8 op_rate_set[SYSADPT_MAX_DATA_RATES_G];
+	u8 ie_wmm_len;               /* Keep WMM IE */
+	u8 *ie_wmm_ptr;
+	u8 ie_rsn_len;               /* Keep WPA IE */
+	u8 *ie_rsn_ptr;
+	u8 ie_rsn48_len;             /* Keep WPA2 IE */
+	u8 *ie_rsn48_ptr;
+	u8 ie_ht_len;                /* Keep HT IE */
+	u8 *ie_ht_ptr;
+	u8 ie_list_ht[148];
+	u8 ie_vht_len;               /* Keep VHT IE */
+	u8 *ie_vht_ptr;
+	u8 ie_list_vht[24];
+};
+
+struct mwl_vif {
+	struct list_head list;
+	struct ieee80211_vif *vif;
+	int macid;       /* Firmware macid for this vif.  */
+	u16 seqno;       /* Non AMPDU sequence number assigned by driver.  */
+	struct {         /* Saved WEP keys */
+		u8 enabled;
+		u8 key[sizeof(struct ieee80211_key_conf) + MAX_WEP_KEY_LEN];
+	} wep_key_conf[NUM_WEP_KEYS];
+	u8 bssid[ETH_ALEN];          /* BSSID */
+	u8 sta_mac[ETH_ALEN];        /* Station mac address */
+	/* A flag to indicate is HW crypto is enabled for this bssid */
+	bool is_hw_crypto_enabled;
+	/* Indicate if this is station mode */
+	bool is_sta;
+	struct beacon_info beacon_info;
+	u16 iv16;
+	u32 iv32;
+	s8 keyidx;
+};
+
+struct mwl_tx_info {
+	u32 start_time;
+	u32 pkts;
+};
+
+struct mwl_sta {
+	u8 is_ampdu_allowed;
+	struct mwl_tx_info tx_stats[MWL_MAX_TID];
+	u16 iv16;
+	u32 iv32;
+};
+
+/* DMA header used by firmware and hardware.
+*/
+struct mwl_dma_data {
+	u16 fwlen;
+	struct ieee80211_hdr wh;
+	char data[0];
+} __packed;
+
+/* Transmission information to transmit a socket buffer.
+ */
+struct mwl_tx_ctrl {
+	u8 tx_priority;
+	u16 qos_ctrl;
+	u8 type;
+	u8 xmit_control;
+	u8 *sta_info;
+	bool ccmp;
+} __packed;
+
+#endif /* _mwl_dev_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_fwcmd.c b/drivers/net/wireless/mwlwifi/mwl_fwcmd.c
new file mode 100644
index 0000000..e5ddb44
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_fwcmd.c
@@ -0,0 +1,3615 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements frimware host command related functions.
+*/
+
+#include <linux/etherdevice.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_fwcmd.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define MAX_WAIT_FW_COMPLETE_ITERATIONS         10000
+
+/* 16 bit host command code
+ */
+#define HOSTCMD_CMD_GET_HW_SPEC                 0x0003
+#define HOSTCMD_CMD_SET_HW_SPEC                 0x0004
+#define HOSTCMD_CMD_802_11_GET_STAT             0x0014
+#define HOSTCMD_CMD_802_11_RADIO_CONTROL        0x001c
+#define HOSTCMD_CMD_802_11_TX_POWER             0x001f
+#define HOSTCMD_CMD_802_11_RF_ANTENNA           0x0020
+#define HOSTCMD_CMD_BROADCAST_SSID_ENABLE       0x0050 /* per-vif */
+#define HOSTCMD_CMD_SET_RF_CHANNEL              0x010a
+#define HOSTCMD_CMD_SET_AID                     0x010d /* per-vif */
+#define HOSTCMD_CMD_SET_INFRA_MODE              0x010e /* per-vif */
+#define HOSTCMD_CMD_802_11_RTS_THSD             0x0113
+#define HOSTCMD_CMD_SET_EDCA_PARAMS             0x0115
+#define HOSTCMD_CMD_SET_WMM_MODE                0x0123
+#define HOSTCMD_CMD_SET_FIXED_RATE              0x0126
+#define HOSTCMD_CMD_SET_IES                     0x0127
+#define HOSTCMD_CMD_SET_MAC_ADDR                0x0202 /* per-vif */
+#define HOSTCMD_CMD_SET_RATE_ADAPT_MODE         0x0203
+#define HOSTCMD_CMD_GET_WATCHDOG_BITMAP         0x0205
+#define HOSTCMD_CMD_DEL_MAC_ADDR                0x0206 /* pre-vif */
+#define HOSTCMD_CMD_BSS_START                   0x1100 /* per-vif */
+#define HOSTCMD_CMD_AP_BEACON                   0x1101 /* per-vif */
+#define HOSTCMD_CMD_SET_NEW_STN                 0x1111 /* per-vif */
+#define HOSTCMD_CMD_SET_APMODE                  0x1114
+#define HOSTCMD_CMD_UPDATE_ENCRYPTION           0x1122 /* per-vif */
+#define HOSTCMD_CMD_BASTREAM                    0x1125
+#define HOSTCMD_CMD_DWDS_ENABLE                 0x1144
+#define HOSTCMD_CMD_FW_FLUSH_TIMER              0x1148
+#define HOSTCMD_CMD_SET_CDD                     0x1150
+
+/* Define general result code for each command
+ */
+#define HOSTCMD_RESULT_OK                       0x0000 /* OK */
+/* Genenral error */
+#define HOSTCMD_RESULT_ERROR                    0x0001
+/* Command is not valid */
+#define HOSTCMD_RESULT_NOT_SUPPORT              0x0002
+/* Command is pending (will be processed) */
+#define HOSTCMD_RESULT_PENDING                  0x0003
+/* System is busy (command ignored) */
+#define HOSTCMD_RESULT_BUSY                     0x0004
+/* Data buffer is not big enough */
+#define HOSTCMD_RESULT_PARTIAL_DATA             0x0005
+
+/* Define channel related constants
+ */
+#define FREQ_BAND_2DOT4GHZ                      0x1
+#define FREQ_BAND_4DOT9GHZ                      0x2
+#define FREQ_BAND_5GHZ                          0x4
+#define FREQ_BAND_5DOT2GHZ                      0x8
+#define CH_AUTO_WIDTH	                        0
+#define CH_10_MHZ_WIDTH                         0x1
+#define CH_20_MHZ_WIDTH                         0x2
+#define CH_40_MHZ_WIDTH                         0x4
+#define CH_80_MHZ_WIDTH                         0x5
+#define EXT_CH_ABOVE_CTRL_CH                    0x1
+#define EXT_CH_AUTO                             0x2
+#define EXT_CH_BELOW_CTRL_CH                    0x3
+#define NO_EXT_CHANNEL                          0x0
+
+/* active primary 1st 20MHz channel */
+#define ACT_PRIMARY_CHAN_0                      0
+/* active primary 2nd 20MHz channel */
+#define ACT_PRIMARY_CHAN_1                      1
+/* active primary 3rd 20MHz channel */
+#define ACT_PRIMARY_CHAN_2                      2
+/* active primary 4th 20MHz channel */
+#define ACT_PRIMARY_CHAN_3                      3
+/* active primary 5th 20MHz channel */
+#define ACT_PRIMARY_CHAN_4                      4
+/* active primary 6th 20MHz channel */
+#define ACT_PRIMARY_CHAN_5                      5
+/* active primary 7th 20MHz channel */
+#define ACT_PRIMARY_CHAN_6                      6
+/* active primary 8th 20MHz channel */
+#define ACT_PRIMARY_CHAN_7                      7
+
+/* Define rate related constants
+ */
+#define HOSTCMD_ACT_NOT_USE_FIXED_RATE          0x0002
+
+/* Define station related constants
+ */
+#define HOSTCMD_ACT_STA_ACTION_ADD              0
+#define HOSTCMD_ACT_STA_ACTION_REMOVE           2
+
+/* Define key related constants
+ */
+#define MAX_ENCR_KEY_LENGTH                     16
+#define MIC_KEY_LENGTH                          8
+
+/* Key type is WEP		*/
+#define KEY_TYPE_ID_WEP                         0x00
+/* Key type is TKIP		*/
+#define KEY_TYPE_ID_TKIP                        0x01
+/* Key type is AES-CCMP	*/
+#define KEY_TYPE_ID_AES	                        0x02
+
+/* Group key for TX */
+#define ENCR_KEY_FLAG_TXGROUPKEY                0x00000004
+/* pairwise */
+#define ENCR_KEY_FLAG_PAIRWISE                  0x00000008
+/* Sequence counters are valid */
+#define ENCR_KEY_FLAG_TSC_VALID                 0x00000040
+/* Tx key for WEP */
+#define ENCR_KEY_FLAG_WEP_TXKEY                 0x01000000
+/* Tx/Rx MIC keys are valid */
+#define ENCR_KEY_FLAG_MICKEY_VALID              0x02000000
+
+/* Define block ack related constants
+ */
+#define BASTREAM_FLAG_IMMEDIATE_TYPE            1
+#define BASTREAM_FLAG_DIRECTION_UPSTREAM        0
+
+/* Define general purpose action
+ */
+#define HOSTCMD_ACT_GEN_SET                     0x0001
+#define HOSTCMD_ACT_GEN_SET_LIST                0x0002
+#define HOSTCMD_ACT_GEN_GET_LIST                0x0003
+
+/*      Misc
+*/
+#define MWL_SPIN_LOCK(X)     SPIN_LOCK_IRQSAVE(X, flags)
+#define MWL_SPIN_UNLOCK(X)   SPIN_UNLOCK_IRQRESTORE(X, flags)
+
+#define MAX_ENCR_KEY_LENGTH                     16
+#define MIC_KEY_LENGTH                          8
+
+/* TYPE DEFINITION
+*/
+
+enum {
+	WL_DISABLE = 0,
+	WL_ENABLE = 1,
+	WL_DISABLE_VMAC = 0x80,
+};
+
+enum {
+	WL_GET = 0,
+	WL_SET = 1,
+	WL_RESET = 2,
+};
+
+enum {
+	WL_LONG_PREAMBLE = 1,
+	WL_SHORT_PREAMBLE = 3,
+	WL_AUTO_PREAMBLE = 5,
+};
+
+enum encr_action_type {
+	/* request to enable/disable HW encryption */
+	ENCR_ACTION_ENABLE_HW_ENCR,
+	/* request to set encryption key */
+	ENCR_ACTION_TYPE_SET_KEY,
+	/* request to remove one or more keys */
+	ENCR_ACTION_TYPE_REMOVE_KEY,
+	ENCR_ACTION_TYPE_SET_GROUP_KEY,
+};
+
+enum ba_action_type {
+	BA_CREATE_STREAM,
+	BA_UPDATE_STREAM,
+	BA_DESTROY_STREAM,
+	BA_FLUSH_STREAM,
+	BA_CHECK_STREAM,
+};
+
+enum mac_type {
+	WL_MAC_TYPE_PRIMARY_CLIENT,
+	WL_MAC_TYPE_SECONDARY_CLIENT,
+	WL_MAC_TYPE_PRIMARY_AP,
+	WL_MAC_TYPE_SECONDARY_AP,
+};
+
+/* General host command header
+ */
+
+struct hostcmd_header {
+	u16 cmd;
+	u16 len;
+	u8 seq_num;
+	u8 macid;
+	u16 result;
+} __packed;
+
+/* HOSTCMD_CMD_GET_HW_SPEC
+ */
+
+struct hostcmd_cmd_get_hw_spec {
+	struct hostcmd_header cmd_hdr;
+	u8 version;                  /* version of the HW                    */
+	u8 host_if;                  /* host interface                       */
+	u16 num_wcb;                 /* Max. number of WCB FW can handle     */
+	u16 num_mcast_addr;          /* MaxNbr of MC addresses FW can handle */
+	u8 permanent_addr[ETH_ALEN]; /* MAC address programmed in HW         */
+	u16 region_code;
+	u16 num_antenna;             /* Number of antenna used      */
+	u32 fw_release_num;          /* 4 byte of FW release number */
+	u32 wcb_base0;
+	u32 rxpd_wr_ptr;
+	u32 rxpd_rd_ptr;
+	u32 fw_awake_cookie;
+	u32 wcb_base[SYSADPT_TOTAL_TX_QUEUES - 1];
+} __packed;
+
+/* HOSTCMD_CMD_SET_HW_SPEC
+ */
+
+struct hostcmd_cmd_set_hw_spec {
+	struct hostcmd_header cmd_hdr;
+	/* HW revision */
+	u8 version;
+	/* Host interface */
+	u8 host_if;
+	/* Max. number of Multicast address FW can handle */
+	u16 num_mcast_addr;
+	/* MAC address */
+	u8 permanent_addr[ETH_ALEN];
+	/* Region Code */
+	u16 region_code;
+	/* 4 byte of FW release number, example 0x1234=1.2.3.4 */
+	u32 fw_release_num;
+	/* Firmware awake cookie - used to ensure that the device
+	 * is not in sleep mode
+	 */
+	u32 fw_awake_cookie;
+	/* Device capabilities (see above) */
+	u32 device_caps;
+	/* Rx shared memory queue */
+	u32 rxpd_wr_ptr;
+	/* Actual number of TX queues in WcbBase array */
+	u32 num_tx_queues;
+	/* TX WCB Rings */
+	u32 wcb_base[SYSADPT_NUM_OF_DESC_DATA];
+	/* Max AMSDU size (00 - AMSDU Disabled,
+	 * 01 - 4K, 10 - 8K, 11 - not defined)
+	 */
+	u32 max_amsdu_size:2;
+	/* Indicates supported AMPDU type
+	 * (1 = implicit, 0 = explicit (default))
+	 */
+	u32 implicit_ampdu_ba:1;
+	/* indicates mbss features disable in FW */
+	u32 disablembss:1;
+	u32 host_form_beacon:1;
+	u32 host_form_probe_response:1;
+	u32 host_power_save:1;
+	u32 host_encr_decr_mgt:1;
+	u32 host_intra_bss_offload:1;
+	u32 host_iv_offload:1;
+	u32 host_encr_decr_frame:1;
+	u32 reserved: 21;                       /* Reserved */
+	u32 tx_wcb_num_per_queue;
+	u32 total_rx_wcb;
+} __packed;
+
+/* HOSTCMD_CMD_802_11_GET_STAT
+ */
+
+struct hostcmd_cmd_802_11_get_stat {
+	struct hostcmd_header cmd_hdr;
+	u32 tx_retry_successes;
+	u32 tx_multiple_retry_successes;
+	u32 tx_failures;
+	u32 rts_successes;
+	u32 rts_failures;
+	u32 ack_failures;
+	u32 rx_duplicate_frames;
+	u32 rx_fcs_errors;
+	u32 tx_watchdog_timeouts;
+	u32 rx_overflows;
+	u32 rx_frag_errors;
+	u32 rx_mem_errors;
+	u32 pointer_errors;
+	u32 tx_underflows;
+	u32 tx_done;
+	u32 tx_done_buf_try_put;
+	u32 tx_done_buf_put;
+	/* Put size of requested buffer in here */
+	u32 wait_for_tx_buf;
+	u32 tx_attempts;
+	u32 tx_successes;
+	u32 tx_fragments;
+	u32 tx_multicasts;
+	u32 rx_non_ctl_pkts;
+	u32 rx_multicasts;
+	u32 rx_undecryptable_frames;
+	u32 rx_icv_errors;
+	u32 rx_excluded_frames;
+	u32 rx_weak_iv_count;
+	u32 rx_unicasts;
+	u32 rx_bytes;
+	u32 rx_errors;
+	u32 rx_rts_count;
+	u32 tx_cts_count;
+} __packed;
+
+/* HOSTCMD_CMD_802_11_RADIO_CONTROL
+ */
+
+struct hostcmd_cmd_802_11_radio_control {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	/* @bit0: 1/0,on/off, @bit1: 1/0, long/short @bit2: 1/0,auto/fix */
+	u16 control;
+	u16 radio_on;
+} __packed;
+
+/* HOSTCMD_CMD_802_11_TX_POWER
+ */
+
+struct hostcmd_cmd_802_11_tx_power {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	u16 band;
+	u16 ch;
+	u16 bw;
+	u16 sub_ch;
+	u16 power_level_list[SYSADPT_TX_POWER_LEVEL_TOTAL];
+} __packed;
+
+/* HOSTCMD_CMD_802_11_RF_ANTENNA
+ */
+
+struct hostcmd_cmd_802_11_rf_antenna {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	u16 antenna_mode;     /* Number of antennas or 0xffff(diversity) */
+} __packed;
+
+/* HOSTCMD_CMD_BROADCAST_SSID_ENABLE
+ */
+
+struct hostcmd_cmd_broadcast_ssid_enable {
+	struct hostcmd_header cmd_hdr;
+	u32 enable;
+} __packed;
+
+/* HOSTCMD_CMD_SET_RF_CHANNEL
+ */
+
+struct chnl_flags_11ac {
+	/* bit0=1: 2.4GHz,bit1=1: 4.9GHz,bit2=1: 5GHz,bit3=1: 5.2GHz, */
+	u32	freq_band:6;
+	/* bit6=1:10MHz, bit7=1:20MHz, bit8=1:40MHz */
+	u32	chnl_width:5;
+	/* 000: 1st 20MHz chan, 001:2nd 20MHz chan, 011:3rd 20MHz chan,
+	 * 100:4th 20MHz chan
+	 */
+	u32	act_primary:3;
+	u32	reserved:18;
+} __packed;
+
+struct hostcmd_cmd_set_rf_channel {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	u8 curr_chnl;
+	struct chnl_flags_11ac chnl_flags;
+} __packed;
+
+/* HOSTCMD_CMD_SET_AID
+ */
+
+struct hostcmd_cmd_set_aid {
+	struct hostcmd_header cmd_hdr;
+	u16 aid;
+	u8 mac_addr[ETH_ALEN];       /* AP's Mac Address(BSSID) */
+	u32 gprotect;
+	u8 ap_rates[SYSADPT_MAX_DATA_RATES_G];
+} __packed;
+
+/* HOSTCMD_CMD_SET_INFRA_MODE
+ */
+
+struct hostcmd_cmd_set_infra_mode {
+	struct hostcmd_header cmd_hdr;
+} __packed;
+
+/* HOSTCMD_CMD_802_11_RTS_THSD
+ */
+
+struct hostcmd_cmd_802_11_rts_thsd {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	u16	threshold;
+} __packed;
+
+/* HOSTCMD_CMD_SET_EDCA_PARAMS
+ */
+
+struct hostcmd_cmd_set_edca_params {
+	struct hostcmd_header cmd_hdr;
+	/* 0 = get all, 0x1 =set CWMin/Max,  0x2 = set TXOP , 0x4 =set AIFSN */
+	u16 action;
+	u16 txop;                    /* in unit of 32 us */
+	u32 cw_max;                  /* 0~15 */
+	u32 cw_min;                  /* 0~15 */
+	u8 aifsn;
+	u8 txq_num;                  /* Tx Queue number. */
+} __packed;
+
+/* HOSTCMD_CMD_SET_WMM_MODE
+ */
+
+struct hostcmd_cmd_set_wmm_mode {
+	struct hostcmd_header cmd_hdr;
+	u16 action;                  /* 0->unset, 1->set */
+} __packed;
+
+/* HOSTCMD_CMD_SET_FIXED_RATE
+ */
+
+struct fix_rate_flag {           /* lower rate after the retry count */
+	/* 0: legacy, 1: HT */
+	u32 fix_rate_type;
+	/* 0: retry count is not valid, 1: use retry count specified */
+	u32 retry_count_valid;
+} __packed;
+
+struct fix_rate_entry {
+	struct fix_rate_flag fix_rate_type_flags;
+	/* depending on the flags above, this can be either a legacy
+	 * rate(not index) or an MCS code.
+	 */
+	u32 fixed_rate;
+	u32 retry_count;
+} __packed;
+
+struct hostcmd_cmd_set_fixed_rate {
+	struct hostcmd_header cmd_hdr;
+	/* HOSTCMD_ACT_NOT_USE_FIXED_RATE 0x0002 */
+	u32 action;
+	/* use fixed rate specified but firmware can drop to */
+	u32 allow_rate_drop;
+	u32 entry_count;
+	struct fix_rate_entry fixed_rate_table[4];
+	u8 multicast_rate;
+	u8 multi_rate_tx_type;
+	u8 management_rate;
+} __packed;
+
+/* HOSTCMD_CMD_SET_IES
+ */
+
+struct hostcmd_cmd_set_ies {
+	struct hostcmd_header cmd_hdr;
+	u16 action;                  /* 0->unset, 1->set */
+	u16 ie_list_len_ht;
+	u16 ie_list_len_vht;
+	u16 ie_list_len_proprietary;
+	/*Buffer size same as Generic_Beacon*/
+	u8 ie_list_ht[148];
+	u8 ie_list_vht[24];
+	u8 ie_list_proprietary[112];
+} __packed;
+
+/* HOSTCMD_CMD_SET_RATE_ADAPT_MODE
+ */
+
+struct hostcmd_cmd_set_rate_adapt_mode {
+	struct hostcmd_header cmd_hdr;
+	u16 action;
+	u16 rate_adapt_mode;         /* 0:Indoor, 1:Outdoor */
+} __packed;
+
+/* HOSTCMD_CMD_SET_MAC_ADDR, HOSTCMD_CMD_DEL_MAC_ADDR
+ */
+
+struct hostcmd_cmd_set_mac_addr {
+	struct hostcmd_header cmd_hdr;
+	u16 mac_type;
+	u8 mac_addr[ETH_ALEN];
+} __packed;
+
+/* HOSTCMD_CMD_GET_WATCHDOG_BITMAP
+ */
+
+struct hostcmd_cmd_get_watchdog_bitmap {
+	struct hostcmd_header cmd_hdr;
+	u8 watchdog_bitmap;          /* for SW/BA */
+} __packed;
+
+/* HOSTCMD_CMD_BSS_START
+ */
+
+struct hostcmd_cmd_bss_start {
+	struct hostcmd_header cmd_hdr;
+	u32 enable;                  /* FALSE: Disable or TRUE: Enable */
+} __packed;
+
+/* HOSTCMD_CMD_AP_BEACON
+ */
+
+struct cf_params {
+	u8 elem_id;
+	u8 len;
+	u8 cfp_cnt;
+	u8 cfp_period;
+	u16 cfp_max_duration;
+	u16 cfp_duration_remaining;
+} __packed;
+
+struct ibss_params {
+	u8 elem_id;
+	u8 len;
+	u16	atim_window;
+} __packed;
+
+union ss_params {
+	struct cf_params cf_param_set;
+	struct ibss_params ibss_param_set;
+} __packed;
+
+struct fh_params {
+	u8 elem_id;
+	u8 len;
+	u16 dwell_time;
+	u8 hop_set;
+	u8 hop_pattern;
+	u8 hop_index;
+} __packed;
+
+struct ds_params {
+	u8 elem_id;
+	u8 len;
+	u8 current_chnl;
+} __packed;
+
+union phy_params {
+	struct fh_params fh_param_set;
+	struct ds_params ds_param_set;
+} __packed;
+
+struct rsn_ie {
+	u8 elem_id;
+	u8 len;
+	u8 oui_type[4];              /* 00:50:f2:01 */
+	u8 ver[2];
+	u8 grp_key_cipher[4];
+	u8 pws_key_cnt[2];
+	u8 pws_key_cipher_list[4];
+	u8 auth_key_cnt[2];
+	u8 auth_key_list[4];
+} __packed;
+
+struct rsn48_ie {
+	u8 elem_id;
+	u8 len;
+	u8 ver[2];
+	u8 grp_key_cipher[4];
+	u8 pws_key_cnt[2];
+	u8 pws_key_cipher_list[4];
+	u8 auth_key_cnt[2];
+	u8 auth_key_list[4];
+	u8 rsn_cap[2];
+	u8 pmk_id_cnt[2];
+	u8 pmk_id_list[16];          /* Should modify to 16 * S */
+	u8 reserved[8];
+} __packed;
+
+struct aci_aifsn_field {
+	u8 aifsn:4;
+	u8 acm:1;
+	u8 aci:2;
+	u8 rsvd:1;
+} __packed;
+
+struct ecw_min_max_field {
+	u8 ecw_min:4;
+	u8 ecw_max:4;
+} __packed;
+
+struct ac_param_rcd {
+	struct aci_aifsn_field aci_aifsn;
+	struct ecw_min_max_field ecw_min_max;
+	u16 txop_lim;
+} __packed;
+
+struct wmm_param_elem {
+	u8 elem_id;
+	u8 len;
+	u8 oui[3];
+	u8 type;
+	u8 sub_type;
+	u8 version;
+	u8 rsvd;
+	struct ac_param_rcd ac_be;
+	struct ac_param_rcd ac_bk;
+	struct ac_param_rcd ac_vi;
+	struct ac_param_rcd ac_vo;
+} __packed;
+
+struct channel_info {
+	u8 first_channel_num;
+	u8 num_channels;
+	u8 max_tx_pwr_level;
+} __packed;
+
+struct country {
+	u8 elem_id;
+	u8 len;
+	u8 country_str[3];
+	struct channel_info channel_info[40];
+} __packetd;
+
+struct start_cmd {
+	u8 sta_mac_addr[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 bss_type;
+	u16 bcn_period;
+	u8 dtim_period;
+	union ss_params ss_param_set;
+	union phy_params phy_param_set;
+	u16 probe_delay;
+	u16 cap_info;
+	u8 b_rate_set[SYSADPT_MAX_DATA_RATES_G];
+	u8 op_rate_set[SYSADPT_MAX_DATA_RATES_G];
+	struct rsn_ie rsn_ie;
+	struct rsn48_ie rsn48_ie;
+	struct wmm_param_elem wmm_param;
+	struct country country;
+	u32 ap_rf_type;              /* 0->B, 1->G, 2->Mixed, 3->A, 4->11J */
+} __packed;
+
+struct hostcmd_cmd_ap_beacon {
+	struct hostcmd_header cmd_hdr;
+	struct start_cmd start_cmd;
+} __packed;
+
+/* HOSTCMD_CMD_SET_NEW_STN
+ */
+
+struct cap_info {
+	u16 ess:1;
+	u16 ibss:1;
+	u16 cf_pollable:1;
+	u16 cf_poll_rqst:1;
+	u16 privacy:1;
+	u16 short_preamble:1;
+	u16 pbcc:1;
+	u16 chan_agility:1;
+	u16 spectrum_mgmt:1;
+	u16 qoS:1;
+	u16 short_slot_time:1;
+	u16 apsd:1;
+	u16 rsrvd1:1;
+	u16 dsss_ofdm:1;
+	u16 block_ack:1;
+	u16 rsrvd2:1;
+} __packed;
+
+struct add_ht_chnl {
+	u8 ext_chnl_offset:2;
+	u8 sta_chnl_width:1;
+	u8 rifs_mode:1;
+	u8 psmp_stas_only:1;
+	u8 srvc_intvl_gran:3;
+} __packed;
+
+struct add_ht_op_mode {
+	u16 op_mode:2;
+	u16 non_gf_sta_present:1;
+	u16 rrans_burst_limit:1;
+	u16 non_ht_sta_present:1;
+	u16 rsrv:11;
+} __packed;
+
+struct add_ht_stbc {
+	u16 bsc_stbc:7;
+	u16 dual_stbc_proc:1;
+	u16 scd_bcn:1;
+	u16 lsig_txop_proc_full_sup:1;
+	u16 pco_active:1;
+	u16 pco_phase:1;
+	u16 rsrv:4;
+} __packed;
+
+struct add_ht_info {
+	u8 control_chnl;
+	struct add_ht_chnl add_chnl;
+	struct add_ht_op_mode op_mode;
+	struct add_ht_stbc stbc;
+} __packed;
+
+struct peer_info {
+	u32 legacy_rate_bitmap;
+	u8 ht_rates[4];
+	struct cap_info cap_info;
+	u16 ht_cap_info;
+	u8 mac_ht_param_info;
+	u8 mrvl_sta;
+	struct add_ht_info add_ht_info;
+	u32 tx_bf_capabilities;      /* EXBF_SUPPORT */
+	u32 vht_max_rx_mcs;
+	u32 vht_cap;
+	/* 0:20Mhz, 1:40Mhz, 2:80Mhz, 3:160 or 80+80Mhz */
+	u8 vht_rx_channel_width;
+} __packed;
+
+struct hostcmd_cmd_set_new_stn {
+	struct hostcmd_header cmd_hdr;
+	u16 aid;
+	u8 mac_addr[ETH_ALEN];
+	u16 stn_id;
+	u16 action;
+	u16 reserved;
+	struct peer_info peer_info;
+	/* UAPSD_SUPPORT */
+	u8 qos_info;
+	u8 is_qos_sta;
+	u32 fw_sta_ptr;
+} __packed;
+
+/* HOSTCMD_CMD_SET_APMODE
+ */
+
+struct hostcmd_cmd_set_apmode {
+	struct hostcmd_header cmd_hdr;
+	u8 apmode;
+} __packed;
+
+/* HOSTCMD_CMD_UPDATE_ENCRYPTION
+ */
+
+struct hostcmd_cmd_update_encryptoin {
+	struct hostcmd_header cmd_hdr;
+	/* Action type - see encr_action_type */
+	u32 action_type;             /* encr_action_type */
+	/* size of the data buffer attached. */
+	u32 data_length;
+	u8 mac_addr[ETH_ALEN];
+	u8 action_data[1];
+} __packed;
+
+struct wep_type_key {
+	/* WEP key material (max 128bit) */
+	u8 key_material[MAX_ENCR_KEY_LENGTH];
+} __packed;
+
+struct encr_tkip_seqcnt {
+	u16 low;
+	u32 high;
+} __packed;
+
+struct tkip_type_key {
+	/* TKIP Key material. Key type (group or pairwise key) is
+	 * determined by flags
+	 */
+	/* in KEY_PARAM_SET structure. */
+	u8 key_material[MAX_ENCR_KEY_LENGTH];
+	/* MIC keys */
+	u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
+	u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
+	struct encr_tkip_seqcnt	tkip_rsc;
+	struct encr_tkip_seqcnt	tkip_tsc;
+} __packed;
+
+struct aes_type_key {
+	/* AES Key material */
+	u8 key_material[MAX_ENCR_KEY_LENGTH];
+} __packed;
+
+union mwl_key_type {
+	struct wep_type_key	wep_key;
+	struct tkip_type_key tkip_key;
+	struct aes_type_key	aes_key;
+} __packed;
+
+struct key_param_set {
+	/* Total length of this structure (Key is variable size array) */
+	u16 length;
+	/* Key type - WEP, TKIP or AES-CCMP. */
+	/* See definitions above */
+	u16 key_type_id;
+	/* key flags (ENCR_KEY_FLAG_XXX_ */
+	u32 key_info;
+	/* For WEP only - actual key index */
+	u32 key_index;
+	/* Size of the key */
+	u16 key_len;
+	/* Key material (variable size array) */
+	union mwl_key_type key;
+	u8 mac_addr[ETH_ALEN];
+} __packed;
+
+struct hostcmd_cmd_set_key {
+	struct hostcmd_header cmd_hdr;
+	/* Action type - see encr_action_type */
+	u32 action_type;             /* encr_action_type */
+	/* size of the data buffer attached. */
+	u32 data_length;
+	/* data buffer - maps to one KEY_PARAM_SET structure */
+	struct key_param_set key_param;
+} __packed;
+
+/* HOSTCMD_CMD_BASTREAM
+ */
+
+struct ba_stream_flags {
+	u32	ba_type:1;
+	u32 ba_direction:3;
+	u32 reserved:24;
+} __packed;
+
+struct ba_context {
+	u32 context;
+} __packed;
+
+/* parameters for block ack creation */
+struct create_ba_params {
+	/* BA Creation flags - see above */
+	struct ba_stream_flags flags;
+	/* idle threshold */
+	u32	idle_thrs;
+	/* block ack transmit threshold (after how many pkts should we
+	 * send BAR?)
+	 */
+	u32	bar_thrs;
+	/* receiver window size */
+	u32 window_size;
+	/* MAC Address of the BA partner */
+	u8 peer_mac_addr[ETH_ALEN];
+	/* Dialog Token */
+	u8 dialog_token;
+	/* TID for the traffic stream in this BA */
+	u8 tid;
+	/* shared memory queue ID (not sure if this is required) */
+	u8 queue_id;
+	u8 param_info;
+	/* returned by firmware - firmware context pointer. */
+	/* this context pointer will be passed to firmware for all
+	 * future commands.
+	 */
+	struct ba_context fw_ba_context;
+	u8 reset_seq_no;             /** 0 or 1**/
+	u16 current_seq;
+	/* This is for virtual station in Sta proxy mode for V6FW */
+	u8 sta_src_mac_addr[ETH_ALEN];
+} __packed;
+
+/* new transmit sequence number information */
+struct ba_update_seq_num {
+	/* BA flags - see above */
+	struct ba_stream_flags flags;
+	/* returned by firmware in the create ba stream response */
+	struct ba_context fw_ba_context;
+	/* new sequence number for this block ack stream */
+	u16 ba_seq_num;
+} __packed;
+
+struct ba_stream_context {
+	/* BA Stream flags */
+	struct ba_stream_flags flags;
+	/* returned by firmware in the create ba stream response */
+	struct ba_context fw_ba_context;
+} __packed;
+
+union ba_info {
+	/* information required to create BA Stream... */
+	struct create_ba_params	create_params;
+	/* update starting/new sequence number etc. */
+	struct ba_update_seq_num updt_seq_num;
+	/* destroy an existing stream... */
+	struct ba_stream_context destroy_params;
+	/* destroy an existing stream... */
+	struct ba_stream_context flush_params;
+} __packed;
+
+struct hostcmd_cmd_bastream {
+	struct hostcmd_header cmd_hdr;
+	u32 action_type;
+	union ba_info ba_info;
+} __packed;
+
+/* HOSTCMD_CMD_DWDS_ENABLE
+ */
+
+struct hostcmd_cmd_dwds_enable {
+	struct hostcmd_header cmd_hdr;
+	u32 enable;                  /* 0 -- Disable. or 1 -- Enable. */
+} __packed;
+
+/* HOSTCMD_CMD_FW_FLUSH_TIMER
+ */
+
+struct hostcmd_cmd_fw_flush_timer {
+	struct hostcmd_header cmd_hdr;
+	/* 0 -- Disable. > 0 -- holds time value in usecs. */
+	u32 value;
+} __packed;
+
+/* HOSTCMD_CMD_SET_CDD
+ */
+
+struct hostcmd_cmd_set_cdd {
+	struct hostcmd_header cmd_hdr;
+	u32 enable;
+} __packed;
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv);
+static int mwl_fwcmd_exec_cmd(struct mwl_priv *priv, unsigned short cmd);
+static void mwl_fwcmd_send_cmd(struct mwl_priv *priv);
+static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned short cmd);
+
+static int mwl_fwcmd_802_11_radio_control(struct mwl_priv *priv,
+					  bool enable, bool force);
+static int mwl_fwcmd_get_tx_powers(struct mwl_priv *priv, u16 *powlist, u16 ch,
+				   u16 band, u16 width, u16 sub_ch);
+static int mwl_fwcmd_set_tx_powers(struct mwl_priv *priv, u16 txpow[],
+				   u8 action, u16 ch, u16 band,
+				   u16 width, u16 sub_ch);
+static u8 mwl_fwcmd_get_80m_pri_chnl_offset(u8 channel);
+static void mwl_fwcmd_parse_beacon(struct mwl_priv *priv,
+				   struct mwl_vif *vif, u8 *beacon, int len);
+static int mwl_fwcmd_set_ies(struct mwl_priv *priv, struct mwl_vif *mwl_vif);
+static int mwl_fwcmd_set_ap_beacon(struct mwl_priv *priv,
+				   struct mwl_vif *mwl_vif,
+				   struct ieee80211_bss_conf *bss_conf);
+static int mwl_fwcmd_encryption_set_cmd_info(struct hostcmd_cmd_set_key *cmd,
+					     u8 *addr,
+					     struct ieee80211_key_conf *key);
+
+#ifdef MWL_DEBUG
+static char *mwl_fwcmd_get_cmd_string(unsigned short cmd);
+#endif
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+void mwl_fwcmd_reset(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	if (mwl_fwcmd_chk_adapter(priv)) {
+		writel(ISR_RESET,
+		       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+}
+
+void mwl_fwcmd_int_enable(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	if (mwl_fwcmd_chk_adapter(priv)) {
+		writel(0x00,
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);
+		writel((MACREG_A2HRIC_BIT_MASK),
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+}
+
+void mwl_fwcmd_int_disable(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	if (mwl_fwcmd_chk_adapter(priv)) {
+		writel(0x00,
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+}
+
+int mwl_fwcmd_get_hw_specs(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_get_hw_spec *pcmd;
+	unsigned long flags;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_get_hw_spec *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	WLDBG_PRINT("pcmd = %x", (unsigned int)pcmd);
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	memset(&pcmd->permanent_addr[0], 0xff, ETH_ALEN);
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_GET_HW_SPEC);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->fw_awake_cookie = ENDIAN_SWAP32(priv->pphys_cmd_buf + 2048);
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	while (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_GET_HW_SPEC)) {
+		WLDBG_PRINT("failed execution");
+		WL_MSEC_SLEEP(1000);
+		WLDBG_PRINT("repeat command = %x", (unsigned int)pcmd);
+	}
+
+	ether_addr_copy(&priv->hw_data.mac_addr[0], pcmd->permanent_addr);
+	priv->desc_data[0].wcb_base =
+		ENDIAN_SWAP32(pcmd->wcb_base0) & 0x0000ffff;
+#if SYSADPT_NUM_OF_DESC_DATA > 3
+	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
+		priv->desc_data[i].wcb_base =
+			ENDIAN_SWAP32(pcmd->wcb_base[i - 1]) & 0x0000ffff;
+#endif
+	priv->desc_data[0].rx_desc_read =
+		ENDIAN_SWAP32(pcmd->rxpd_rd_ptr) & 0x0000ffff;
+	priv->desc_data[0].rx_desc_write =
+		ENDIAN_SWAP32(pcmd->rxpd_wr_ptr) & 0x0000ffff;
+	priv->hw_data.region_code = ENDIAN_SWAP16(pcmd->region_code) & 0x00ff;
+	priv->hw_data.fw_release_num = ENDIAN_SWAP32(pcmd->fw_release_num);
+	priv->hw_data.max_num_tx_desc = ENDIAN_SWAP16(pcmd->num_wcb);
+	priv->hw_data.max_num_mc_addr = ENDIAN_SWAP16(pcmd->num_mcast_addr);
+	priv->hw_data.num_antennas = ENDIAN_SWAP16(pcmd->num_antenna);
+	priv->hw_data.hw_version = pcmd->version;
+	priv->hw_data.host_interface = pcmd->host_if;
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2,
+			"region code is %i (0x%x), HW version is %i (0x%x)",
+		priv->hw_data.region_code, priv->hw_data.region_code,
+		priv->hw_data.hw_version, priv->hw_data.hw_version);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_hw_specs(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_hw_spec *pcmd;
+	unsigned long flags;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	/* Info for debugging
+	*/
+	WLDBG_PRINT("%s ...", __func__);
+	WLDBG_PRINT("  -->pPhysTxRing[0] = %x",
+		    priv->desc_data[0].pphys_tx_ring);
+	WLDBG_PRINT("  -->pPhysTxRing[1] = %x",
+		    priv->desc_data[1].pphys_tx_ring);
+	WLDBG_PRINT("  -->pPhysTxRing[2] = %x",
+		    priv->desc_data[2].pphys_tx_ring);
+	WLDBG_PRINT("  -->pPhysTxRing[3] = %x",
+		    priv->desc_data[3].pphys_tx_ring);
+	WLDBG_PRINT("  -->pPhysRxRing    = %x",
+		    priv->desc_data[0].pphys_rx_ring);
+	WLDBG_PRINT("  -->numtxq %d wcbperq %d totalrxwcb %d",
+		    SYSADPT_NUM_OF_DESC_DATA,
+		    SYSADPT_MAX_NUM_TX_DESC,
+		    SYSADPT_MAX_NUM_RX_DESC);
+
+	pcmd = (struct hostcmd_cmd_set_hw_spec *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_HW_SPEC);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->wcb_base[0] = ENDIAN_SWAP32(priv->desc_data[0].pphys_tx_ring);
+#if SYSADPT_NUM_OF_DESC_DATA > 3
+	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
+		pcmd->wcb_base[i] =
+			ENDIAN_SWAP32(priv->desc_data[i].pphys_tx_ring);
+#endif
+	pcmd->tx_wcb_num_per_queue = ENDIAN_SWAP32(SYSADPT_MAX_NUM_TX_DESC);
+	pcmd->num_tx_queues = ENDIAN_SWAP32(SYSADPT_NUM_OF_DESC_DATA);
+	pcmd->total_rx_wcb = ENDIAN_SWAP32(SYSADPT_MAX_NUM_RX_DESC);
+	pcmd->rxpd_wr_ptr = ENDIAN_SWAP32(priv->desc_data[0].pphys_rx_ring);
+	pcmd->disablembss = 0;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_HW_SPEC)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_get_stat(struct ieee80211_hw *hw,
+		       struct ieee80211_low_level_stats *stats)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_802_11_get_stat *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_802_11_get_stat *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_GET_STAT);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_GET_STAT)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	stats->dot11ACKFailureCount =
+		ENDIAN_SWAP32(pcmd->ack_failures);
+	stats->dot11RTSFailureCount =
+		ENDIAN_SWAP32(pcmd->rts_failures);
+	stats->dot11FCSErrorCount =
+		ENDIAN_SWAP32(pcmd->rx_fcs_errors);
+	stats->dot11RTSSuccessCount =
+		ENDIAN_SWAP32(pcmd->rts_successes);
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_radio_enable(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	rc = mwl_fwcmd_802_11_radio_control(priv, true, false);
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return rc;
+}
+
+int mwl_fwcmd_radio_disable(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	rc = mwl_fwcmd_802_11_radio_control(priv, false, false);
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return rc;
+}
+
+int mwl_fwcmd_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	priv->radio_short_preamble = short_preamble;
+	rc = mwl_fwcmd_802_11_radio_control(priv, true, true);
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return rc;
+}
+
+int mwl_fwcmd_max_tx_power(struct ieee80211_hw *hw,
+			   struct ieee80211_conf *conf, u8 fraction)
+{
+	struct ieee80211_channel *channel = conf->chandef.chan;
+	struct mwl_priv *priv;
+	int reduce_val = 0;
+	u16 band = 0, width = 0, sub_ch = 0;
+	u16 maxtxpow[SYSADPT_TX_POWER_LEVEL_TOTAL];
+	int i, tmp;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	switch (fraction) {
+	case 0:
+		reduce_val = 0;    /* Max */
+		break;
+	case 1:
+		reduce_val = 2;    /* 75% -1.25db */
+		break;
+	case 2:
+		reduce_val = 3;    /* 50% -3db */
+		break;
+	case 3:
+		reduce_val = 6;    /* 25% -6db */
+		break;
+	default:
+		/* larger than case 3,  pCmd->MaxPowerLevel is min */
+		reduce_val = 0xff;
+		break;
+	}
+
+	if (channel->band == IEEE80211_BAND_2GHZ)
+		band = FREQ_BAND_2DOT4GHZ;
+	else if (channel->band == IEEE80211_BAND_5GHZ)
+		band = FREQ_BAND_5GHZ;
+
+	if ((conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
+	    (conf->chandef.width == NL80211_CHAN_WIDTH_20)) {
+		width = CH_20_MHZ_WIDTH;
+		sub_ch = NO_EXT_CHANNEL;
+
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_40) {
+		width = CH_40_MHZ_WIDTH;
+		if (conf->chandef.center_freq1 > channel->center_freq)
+			sub_ch = EXT_CH_ABOVE_CTRL_CH;
+		else
+			sub_ch = EXT_CH_BELOW_CTRL_CH;
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_80) {
+		width = CH_80_MHZ_WIDTH;
+		if (conf->chandef.center_freq1 > channel->center_freq)
+			sub_ch = EXT_CH_ABOVE_CTRL_CH;
+		else
+			sub_ch = EXT_CH_BELOW_CTRL_CH;
+	}
+
+	if ((priv->powinited & 2) == 0) {
+		mwl_fwcmd_get_tx_powers(priv, priv->max_tx_pow,
+					channel->hw_value, band, width, sub_ch);
+		priv->powinited |= 2;
+	}
+
+	if ((priv->powinited & 1) == 0) {
+		mwl_fwcmd_get_tx_powers(priv, priv->target_powers,
+					channel->hw_value, band, width, sub_ch);
+		priv->powinited |= 1;
+	}
+
+	for (i = 0; i < SYSADPT_TX_POWER_LEVEL_TOTAL; i++) {
+		if (priv->target_powers[i] > priv->max_tx_pow[i])
+			tmp = priv->max_tx_pow[i];
+		else
+			tmp = priv->target_powers[i];
+		maxtxpow[i] = ((tmp - reduce_val) > 0) ? (tmp - reduce_val) : 0;
+	}
+
+	rc = mwl_fwcmd_set_tx_powers(priv, maxtxpow, HOSTCMD_ACT_GEN_SET,
+				     channel->hw_value, band, width, sub_ch);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "return code: %d", rc);
+
+	return rc;
+}
+
+int mwl_fwcmd_tx_power(struct ieee80211_hw *hw,
+		       struct ieee80211_conf *conf, u8 fraction)
+{
+	struct ieee80211_channel *channel = conf->chandef.chan;
+	struct mwl_priv *priv;
+	int reduce_val = 0;
+	u16 band = 0, width = 0, sub_ch = 0;
+	u16 txpow[SYSADPT_TX_POWER_LEVEL_TOTAL];
+	int index, found = 0;
+	int i, tmp;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	switch (fraction) {
+	case 0:
+		reduce_val = 0;    /* Max */
+		break;
+	case 1:
+		reduce_val = 2;    /* 75% -1.25db */
+		break;
+	case 2:
+		reduce_val = 3;    /* 50% -3db */
+		break;
+	case 3:
+		reduce_val = 6;    /* 25% -6db */
+		break;
+	default:
+		/* larger than case 3,  pCmd->MaxPowerLevel is min */
+		reduce_val = 0xff;
+		break;
+	}
+
+	if (channel->band == IEEE80211_BAND_2GHZ)
+		band = FREQ_BAND_2DOT4GHZ;
+	else if (channel->band == IEEE80211_BAND_5GHZ)
+		band = FREQ_BAND_5GHZ;
+
+	if ((conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
+	    (conf->chandef.width == NL80211_CHAN_WIDTH_20)) {
+		width = CH_20_MHZ_WIDTH;
+		sub_ch = NO_EXT_CHANNEL;
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_40) {
+		width = CH_40_MHZ_WIDTH;
+		if (conf->chandef.center_freq1 > channel->center_freq)
+			sub_ch = EXT_CH_ABOVE_CTRL_CH;
+		else
+			sub_ch = EXT_CH_BELOW_CTRL_CH;
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_80) {
+		width = CH_80_MHZ_WIDTH;
+		if (conf->chandef.center_freq1 > channel->center_freq)
+			sub_ch = EXT_CH_ABOVE_CTRL_CH;
+		else
+			sub_ch = EXT_CH_BELOW_CTRL_CH;
+	}
+
+	/* search tx power table if exist
+	*/
+	for (index = 0; index < SYSADPT_MAX_NUM_CHANNELS; index++) {
+		struct mwl_tx_pwr_tbl *tx_pwr;
+
+		tx_pwr = &priv->tx_pwr_tbl[index];
+
+		/* do nothing if table is not loaded
+		*/
+		if (tx_pwr->channel == 0)
+			break;
+
+		if (tx_pwr->channel == channel->hw_value) {
+			priv->cdd = tx_pwr->cdd;
+			priv->txantenna2 = tx_pwr->txantenna2;
+
+			if (tx_pwr->setcap)
+				priv->powinited = 0x01;
+			else
+				priv->powinited = 0x02;
+
+			for (i = 0; i < SYSADPT_TX_POWER_LEVEL_TOTAL; i++) {
+				if (tx_pwr->setcap)
+					priv->max_tx_pow[i] =
+						tx_pwr->tx_power[i];
+				else
+					priv->target_powers[i] =
+						tx_pwr->tx_power[i];
+			}
+
+			found = 1;
+			break;
+		}
+	}
+
+	if ((priv->powinited & 2) == 0) {
+		mwl_fwcmd_get_tx_powers(priv, priv->max_tx_pow,
+					channel->hw_value, band, width, sub_ch);
+
+		priv->powinited |= 2;
+	}
+
+	if ((priv->powinited & 1) == 0) {
+		mwl_fwcmd_get_tx_powers(priv, priv->target_powers,
+					channel->hw_value, band, width, sub_ch);
+
+		priv->powinited |= 1;
+	}
+
+	for (i = 0; i < SYSADPT_TX_POWER_LEVEL_TOTAL; i++) {
+		if (found) {
+			if ((priv->tx_pwr_tbl[index].setcap) &&
+			    (priv->tx_pwr_tbl[index].tx_power[i] >
+			    priv->max_tx_pow[i]))
+				tmp = priv->max_tx_pow[i];
+			else
+				tmp = priv->tx_pwr_tbl[index].tx_power[i];
+		} else {
+			if (priv->target_powers[i] > priv->max_tx_pow[i])
+				tmp = priv->max_tx_pow[i];
+			else
+				tmp = priv->target_powers[i];
+		}
+
+		txpow[i] = ((tmp - reduce_val) > 0) ? (tmp - reduce_val) : 0;
+	}
+
+	rc = mwl_fwcmd_set_tx_powers(priv, txpow, HOSTCMD_ACT_GEN_SET_LIST,
+				     channel->hw_value, band, width, sub_ch);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "return code: %d", rc);
+
+	return rc;
+}
+
+int mwl_fwcmd_rf_antenna(struct ieee80211_hw *hw, int dir, int antenna)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_802_11_rf_antenna *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_802_11_rf_antenna *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_RF_ANTENNA);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	pcmd->action = ENDIAN_SWAP16(dir);
+
+	if (dir == WL_ANTENNATYPE_RX) {
+		u8 rx_antenna = 4; /* if auto, set 4 rx antennas in SC2 */
+
+		if (antenna != 0)
+			pcmd->antenna_mode = ENDIAN_SWAP16(antenna);
+		else
+			pcmd->antenna_mode = ENDIAN_SWAP16(rx_antenna);
+	} else {
+		u8 tx_antenna = 0xf; /* if auto, set 4 tx antennas in SC2 */
+
+		if (antenna != 0)
+			pcmd->antenna_mode = ENDIAN_SWAP16(antenna);
+		else
+			pcmd->antenna_mode = ENDIAN_SWAP16(tx_antenna);
+	}
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_RF_ANTENNA)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_broadcast_ssid_enable(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, bool enable)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_broadcast_ssid_enable *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_broadcast_ssid_enable *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_BROADCAST_SSID_ENABLE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	pcmd->enable = ENDIAN_SWAP32(enable);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_BROADCAST_SSID_ENABLE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_rf_channel(struct ieee80211_hw *hw,
+			     struct ieee80211_conf *conf)
+{
+	struct ieee80211_channel *channel = conf->chandef.chan;
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_rf_channel *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_rf_channel *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_RF_CHANNEL);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(WL_SET);
+	pcmd->curr_chnl = channel->hw_value;
+
+	if (channel->band == IEEE80211_BAND_2GHZ)
+		pcmd->chnl_flags.freq_band = FREQ_BAND_2DOT4GHZ;
+	else if (channel->band == IEEE80211_BAND_5GHZ)
+		pcmd->chnl_flags.freq_band = FREQ_BAND_5GHZ;
+
+	if ((conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
+	    (conf->chandef.width == NL80211_CHAN_WIDTH_20)) {
+		pcmd->chnl_flags.chnl_width = CH_20_MHZ_WIDTH;
+		pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_0;
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_40) {
+		pcmd->chnl_flags.chnl_width = CH_40_MHZ_WIDTH;
+		if (conf->chandef.center_freq1 > channel->center_freq)
+			pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_0;
+		else
+			pcmd->chnl_flags.act_primary = ACT_PRIMARY_CHAN_1;
+	} else if (conf->chandef.width == NL80211_CHAN_WIDTH_80) {
+		pcmd->chnl_flags.chnl_width = CH_80_MHZ_WIDTH;
+		pcmd->chnl_flags.act_primary =
+			mwl_fwcmd_get_80m_pri_chnl_offset(pcmd->curr_chnl);
+	}
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_RF_CHANNEL)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_aid(struct ieee80211_hw *hw,
+		      struct ieee80211_vif *vif, u8 *bssid, u16 aid)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_aid *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_aid *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_AID);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	pcmd->aid = ENDIAN_SWAP16(aid);
+	ether_addr_copy(pcmd->mac_addr, bssid);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_AID)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_infra_mode(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_infra_mode *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_infra_mode *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_INFRA_MODE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_INFRA_MODE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_rts_threshold(struct ieee80211_hw *hw, int threshold)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_802_11_rts_thsd *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_802_11_rts_thsd *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_RTS_THSD);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action  = ENDIAN_SWAP16(WL_SET);
+	pcmd->threshold = ENDIAN_SWAP16(threshold);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_RTS_THSD)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_edca_params(struct ieee80211_hw *hw, u8 index,
+			      u16 cw_min, u16 cw_max, u8 aifs, u16 txop)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_edca_params *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_edca_params *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_EDCA_PARAMS);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	pcmd->action = ENDIAN_SWAP16(0xffff);
+	pcmd->txop = ENDIAN_SWAP16(txop);
+	pcmd->cw_max = ENDIAN_SWAP32(ilog2(cw_max + 1));
+	pcmd->cw_min = ENDIAN_SWAP32(ilog2(cw_min + 1));
+	pcmd->aifsn = aifs;
+	pcmd->txq_num = index;
+
+	/* The array index defined in qos.h has a reversed bk and be.
+	 * The HW queue was not used this way; the qos code needs to
+	 * be changed or checked
+	 */
+	if (index == 0)
+		pcmd->txq_num = 1;
+	else if (index == 1)
+		pcmd->txq_num = 0;
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_EDCA_PARAMS)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_wmm_mode(struct ieee80211_hw *hw, bool enable)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_wmm_mode *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_wmm_mode *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_WMM_MODE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(enable ? WL_ENABLE : WL_DISABLE);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_WMM_MODE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_use_fixed_rate(struct ieee80211_hw *hw, int mcast, int mgmt)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_fixed_rate *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_fixed_rate *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_FIXED_RATE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	pcmd->action = ENDIAN_SWAP32(HOSTCMD_ACT_NOT_USE_FIXED_RATE);
+	pcmd->multicast_rate = mcast;
+	pcmd->management_rate = mgmt;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_FIXED_RATE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_rate_adapt_mode(struct ieee80211_hw *hw, u16 mode)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_rate_adapt_mode *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_rate_adapt_mode *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_RATE_ADAPT_MODE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(WL_SET);
+	pcmd->rate_adapt_mode = ENDIAN_SWAP16(mode);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_RATE_ADAPT_MODE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_mac_addr_client(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac_addr)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_mac_addr *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_mac_addr *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_MAC_ADDR);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	pcmd->mac_type = WL_MAC_TYPE_SECONDARY_CLIENT;
+	ether_addr_copy(pcmd->mac_addr, mac_addr);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_MAC_ADDR)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_get_watchdog_bitmap(struct ieee80211_hw *hw, u8 *bitmap)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_get_watchdog_bitmap *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_get_watchdog_bitmap *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_GET_WATCHDOG_BITMAP);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_GET_WATCHDOG_BITMAP)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	*bitmap = pcmd->watchdog_bitmap;
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_remove_mac_addr(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u8 *mac_addr)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_mac_addr *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_mac_addr *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_DEL_MAC_ADDR);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	ether_addr_copy(pcmd->mac_addr, mac_addr);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_DEL_MAC_ADDR)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_bss_start(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif, bool enable)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_bss_start *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	if (enable && (priv->running_bsses & (1 << mwl_vif->macid)))
+		return 0;
+
+	if (!enable && !(priv->running_bsses & (1 << mwl_vif->macid)))
+		return 0;
+
+	pcmd = (struct hostcmd_cmd_bss_start *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_BSS_START);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	if (enable) {
+		pcmd->enable = ENDIAN_SWAP32(WL_ENABLE);
+	} else {
+		if (mwl_vif->macid == 0)
+			pcmd->enable = ENDIAN_SWAP32(WL_DISABLE);
+		else
+			pcmd->enable = ENDIAN_SWAP32(WL_DISABLE_VMAC);
+	}
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_BSS_START)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (enable)
+		priv->running_bsses |= (1 << mwl_vif->macid);
+	else
+		priv->running_bsses &= ~(1 << mwl_vif->macid);
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_beacon(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u8 *beacon, int len)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	mwl_fwcmd_parse_beacon(priv, mwl_vif, beacon, len);
+
+	if (mwl_fwcmd_set_ies(priv, mwl_vif))
+		goto err;
+
+	if (mwl_fwcmd_set_ap_beacon(priv, mwl_vif, &vif->bss_conf))
+		goto err;
+
+	mwl_vif->beacon_info.valid = false;
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+
+err:
+
+	mwl_vif->beacon_info.valid = false;
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "set beacon failed");
+
+	return -EIO;
+}
+
+int mwl_fwcmd_set_new_stn_add(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_new_stn *pcmd;
+	unsigned long flags;
+	u32 rates;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	BUG_ON(!sta);
+
+	pcmd = (struct hostcmd_cmd_set_new_stn *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_NEW_STN);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	pcmd->action = ENDIAN_SWAP16(HOSTCMD_ACT_STA_ACTION_ADD);
+	if (mwl_vif->is_sta) {
+		pcmd->aid = 0;
+		pcmd->stn_id = 0;
+	} else {
+		pcmd->aid = ENDIAN_SWAP16(sta->aid);
+		pcmd->stn_id = ENDIAN_SWAP16(sta->aid);
+	}
+	ether_addr_copy(pcmd->mac_addr, sta->addr);
+
+	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
+	else
+		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
+	pcmd->peer_info.legacy_rate_bitmap = ENDIAN_SWAP32(rates);
+
+	if (sta->ht_cap.ht_supported) {
+		pcmd->peer_info.ht_rates[0] = sta->ht_cap.mcs.rx_mask[0];
+		pcmd->peer_info.ht_rates[1] = sta->ht_cap.mcs.rx_mask[1];
+		pcmd->peer_info.ht_rates[2] = sta->ht_cap.mcs.rx_mask[2];
+		pcmd->peer_info.ht_rates[3] = sta->ht_cap.mcs.rx_mask[3];
+		pcmd->peer_info.ht_cap_info = ENDIAN_SWAP16(sta->ht_cap.cap);
+		pcmd->peer_info.mac_ht_param_info =
+			(sta->ht_cap.ampdu_factor & 3) |
+			((sta->ht_cap.ampdu_density & 7) << 2);
+	}
+
+	if (sta->vht_cap.vht_supported) {
+		pcmd->peer_info.vht_max_rx_mcs =
+			ENDIAN_SWAP32(*((u32 *)
+			&sta->vht_cap.vht_mcs.rx_mcs_map));
+		pcmd->peer_info.vht_cap = ENDIAN_SWAP32(sta->vht_cap.cap);
+		pcmd->peer_info.vht_rx_channel_width = sta->bandwidth;
+	}
+
+	pcmd->is_qos_sta = sta->wme;
+	pcmd->qos_info = ((sta->uapsd_queues << 4) | (sta->max_sp << 1));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (mwl_vif->is_sta) {
+		ether_addr_copy(pcmd->mac_addr, mwl_vif->sta_mac);
+
+		if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
+			MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+			WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+			return -EIO;
+		}
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_new_stn_add_self(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_new_stn *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_new_stn *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_NEW_STN);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	pcmd->action = ENDIAN_SWAP16(HOSTCMD_ACT_STA_ACTION_ADD);
+	ether_addr_copy(pcmd->mac_addr, vif->addr);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_new_stn_del(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u8 *addr)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_new_stn *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_new_stn *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_NEW_STN);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	pcmd->action = ENDIAN_SWAP16(HOSTCMD_ACT_STA_ACTION_REMOVE);
+	ether_addr_copy(pcmd->mac_addr, addr);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if  (mwl_vif->is_sta) {
+		ether_addr_copy(pcmd->mac_addr, mwl_vif->sta_mac);
+
+		if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_NEW_STN)) {
+			MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+			WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+			return -EIO;
+		}
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_apmode(struct ieee80211_hw *hw, u8 apmode)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_apmode *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_apmode *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_APMODE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->apmode = apmode;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_APMODE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_update_encryption_enable(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       u8 *addr, u8 encr_type)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_update_encryptoin *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_update_encryptoin *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_UPDATE_ENCRYPTION);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	pcmd->action_type = ENDIAN_SWAP32(ENCR_ACTION_ENABLE_HW_ENCR);
+	ether_addr_copy(pcmd->mac_addr, addr);
+	pcmd->action_data[0] = encr_type;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_UPDATE_ENCRYPTION)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (mwl_vif->is_sta) {
+		if (memcmp(mwl_vif->bssid, addr, ETH_ALEN) == 0)
+			ether_addr_copy(pcmd->mac_addr, mwl_vif->sta_mac);
+		else
+			ether_addr_copy(pcmd->mac_addr, mwl_vif->bssid);
+
+		if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_UPDATE_ENCRYPTION)) {
+			MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+			WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+			return -EIO;
+		}
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_encryption_set_key(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif, u8 *addr,
+				 struct ieee80211_key_conf *key)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_key *pcmd;
+	unsigned long flags;
+	int rc;
+	int keymlen;
+	u32 action;
+	u8 idx;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_key *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_UPDATE_ENCRYPTION);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	rc = mwl_fwcmd_encryption_set_cmd_info(pcmd, addr, key);
+	if (rc) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "encryption not support");
+		return rc;
+	}
+
+	idx = key->keyidx;
+
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		action = ENCR_ACTION_TYPE_SET_KEY;
+	else
+		action = ENCR_ACTION_TYPE_SET_GROUP_KEY;
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (!mwl_vif->wep_key_conf[idx].enabled) {
+			memcpy(mwl_vif->wep_key_conf[idx].key, key,
+			       sizeof(*key) + key->keylen);
+			mwl_vif->wep_key_conf[idx].enabled = 1;
+		}
+
+		keymlen = key->keylen;
+		action = ENCR_ACTION_TYPE_SET_KEY;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		keymlen = MAX_ENCR_KEY_LENGTH + 2 * MIC_KEY_LENGTH;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		keymlen = key->keylen;
+		break;
+	default:
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "encryption not support");
+		return -ENOTSUPP;
+	}
+
+	memcpy((void *)&pcmd->key_param.key, key->key, keymlen);
+	pcmd->action_type = ENDIAN_SWAP32(action);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_UPDATE_ENCRYPTION)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (mwl_vif->is_sta) {
+		if (memcmp(mwl_vif->bssid, addr, ETH_ALEN) == 0)
+			ether_addr_copy(pcmd->key_param.mac_addr,
+					mwl_vif->sta_mac);
+		else
+			ether_addr_copy(pcmd->key_param.mac_addr,
+					mwl_vif->bssid);
+
+		if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_UPDATE_ENCRYPTION)) {
+			MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+			WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+			return -EIO;
+		}
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_encryption_remove_key(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, u8 *addr,
+				    struct ieee80211_key_conf *key)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_set_key *pcmd;
+	unsigned long flags;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_set_key *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_UPDATE_ENCRYPTION);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	rc = mwl_fwcmd_encryption_set_cmd_info(pcmd, addr, key);
+	if (rc) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "encryption not support");
+		return rc;
+	}
+
+	pcmd->action_type = ENDIAN_SWAP32(ENCR_ACTION_TYPE_REMOVE_KEY);
+
+	if (key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	    key->cipher == WLAN_CIPHER_SUITE_WEP104)
+		mwl_vif->wep_key_conf[key->keyidx].enabled = 0;
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_UPDATE_ENCRYPTION)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_check_ba(struct ieee80211_hw *hw,
+		       struct mwl_ampdu_stream *stream,
+		       struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_bastream *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!stream);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_bastream *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_BASTREAM);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	pcmd->cmd_hdr.result = ENDIAN_SWAP16(0xffff);
+
+	pcmd->action_type = ENDIAN_SWAP32(BA_CHECK_STREAM);
+	memcpy(&pcmd->ba_info.create_params.peer_mac_addr[0],
+	       stream->sta->addr, ETH_ALEN);
+	pcmd->ba_info.create_params.tid = stream->tid;
+	pcmd->ba_info.create_params.flags.ba_type =
+		BASTREAM_FLAG_IMMEDIATE_TYPE;
+	pcmd->ba_info.create_params.flags.ba_direction =
+		BASTREAM_FLAG_DIRECTION_UPSTREAM;
+	pcmd->ba_info.create_params.queue_id = stream->idx;
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_BASTREAM)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (pcmd->cmd_hdr.result != 0) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "result error");
+		return -EINVAL;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_create_ba(struct ieee80211_hw *hw,
+			struct mwl_ampdu_stream *stream,
+			u8 buf_size, struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv;
+	struct mwl_vif *mwl_vif;
+	struct hostcmd_cmd_bastream *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!stream);
+
+	BUG_ON(!vif);
+	mwl_vif = MWL_VIF(vif);
+	BUG_ON(!mwl_vif);
+
+	pcmd = (struct hostcmd_cmd_bastream *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_BASTREAM);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+	pcmd->cmd_hdr.result = ENDIAN_SWAP16(0xffff);
+
+	pcmd->action_type = ENDIAN_SWAP32(BA_CREATE_STREAM);
+	pcmd->ba_info.create_params.bar_thrs = ENDIAN_SWAP32(buf_size);
+	pcmd->ba_info.create_params.window_size = ENDIAN_SWAP32(buf_size);
+	memcpy(&pcmd->ba_info.create_params.peer_mac_addr[0],
+	       stream->sta->addr, ETH_ALEN);
+	pcmd->ba_info.create_params.tid = stream->tid;
+	pcmd->ba_info.create_params.flags.ba_type =
+		BASTREAM_FLAG_IMMEDIATE_TYPE;
+	pcmd->ba_info.create_params.flags.ba_direction =
+		BASTREAM_FLAG_DIRECTION_UPSTREAM;
+	pcmd->ba_info.create_params.queue_id = stream->idx;
+	pcmd->ba_info.create_params.param_info =
+		(stream->sta->ht_cap.ampdu_factor &
+		 IEEE80211_HT_AMPDU_PARM_FACTOR) |
+		((stream->sta->ht_cap.ampdu_density << 2) &
+		 IEEE80211_HT_AMPDU_PARM_DENSITY);
+	pcmd->ba_info.create_params.reset_seq_no = 1;
+	pcmd->ba_info.create_params.current_seq = ENDIAN_SWAP16(0);
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_BASTREAM)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	if (pcmd->cmd_hdr.result != 0) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "result error");
+		return -EINVAL;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_destroy_ba(struct ieee80211_hw *hw,
+			 u8 idx)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_bastream *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_bastream *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_BASTREAM);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+
+	pcmd->action_type = ENDIAN_SWAP32(BA_DESTROY_STREAM);
+	pcmd->ba_info.destroy_params.flags.ba_type =
+		BASTREAM_FLAG_IMMEDIATE_TYPE;
+	pcmd->ba_info.destroy_params.flags.ba_direction =
+		BASTREAM_FLAG_DIRECTION_UPSTREAM;
+	pcmd->ba_info.destroy_params.fw_ba_context.context = ENDIAN_SWAP32(idx);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_BASTREAM)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+/* caller must hold priv->locks.stream_lock when calling the stream functions
+*/
+struct mwl_ampdu_stream *mwl_fwcmd_add_stream(struct ieee80211_hw *hw,
+					      struct ieee80211_sta *sta,
+					      u8 tid)
+{
+	struct mwl_priv *priv;
+	struct mwl_ampdu_stream *stream;
+	int i;
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!sta);
+
+	for (i = 0; i < SYSADPT_TX_AMPDU_QUEUES; i++) {
+		stream = &priv->ampdu[i];
+
+		if (stream->state == AMPDU_NO_STREAM) {
+			stream->sta = sta;
+			stream->state = AMPDU_STREAM_NEW;
+			stream->tid = tid;
+			stream->idx = i;
+			return stream;
+		}
+	}
+
+	return NULL;
+}
+
+int mwl_fwcmd_start_stream(struct ieee80211_hw *hw,
+			   struct mwl_ampdu_stream *stream)
+{
+	BUG_ON(!hw);
+	BUG_ON(!stream);
+
+	/* if the stream has already been started, don't start it again
+	*/
+	if (stream->state != AMPDU_STREAM_NEW)
+		return 0;
+
+	return ieee80211_start_tx_ba_session(stream->sta, stream->tid, 0);
+}
+
+void mwl_fwcmd_remove_stream(struct ieee80211_hw *hw,
+			     struct mwl_ampdu_stream *stream)
+{
+	BUG_ON(!hw);
+	BUG_ON(!stream);
+
+	memset(stream, 0, sizeof(*stream));
+}
+
+struct mwl_ampdu_stream *mwl_fwcmd_lookup_stream(struct ieee80211_hw *hw,
+						 u8 *addr, u8 tid)
+{
+	struct mwl_priv *priv;
+	struct mwl_ampdu_stream *stream;
+	int i;
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	for (i = 0; i < SYSADPT_TX_AMPDU_QUEUES; i++) {
+		stream = &priv->ampdu[i];
+
+		if (stream->state == AMPDU_NO_STREAM)
+			continue;
+
+		if (!memcmp(stream->sta->addr, addr, ETH_ALEN) &&
+		    stream->tid == tid)
+			return stream;
+	}
+
+	return NULL;
+}
+
+bool mwl_fwcmd_ampdu_allowed(struct ieee80211_sta *sta, u8 tid)
+{
+	struct mwl_sta *sta_info;
+	struct mwl_tx_info *tx_stats;
+
+	BUG_ON(!sta);
+	sta_info = MWL_STA(sta);
+	BUG_ON(!sta_info);
+
+	BUG_ON(tid >= SYSADPT_MAX_TID);
+
+	tx_stats = &sta_info->tx_stats[tid];
+
+	return (sta_info->is_ampdu_allowed &&
+		tx_stats->pkts > SYSADPT_AMPDU_PACKET_THRESHOLD);
+}
+
+int mwl_fwcmd_set_dwds_stamode(struct ieee80211_hw *hw, bool enable)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_dwds_enable *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_dwds_enable *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_DWDS_ENABLE);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->enable = ENDIAN_SWAP32(enable);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_DWDS_ENABLE)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_fw_flush_timer(struct ieee80211_hw *hw, u32 value)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_fw_flush_timer *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_fw_flush_timer *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_FW_FLUSH_TIMER);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->value = ENDIAN_SWAP32(value);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_FW_FLUSH_TIMER)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+int mwl_fwcmd_set_cdd(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	struct hostcmd_cmd_set_cdd *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_set_cdd *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_CDD);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->enable = ENDIAN_SWAP32(priv->cdd);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_CDD)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static bool mwl_fwcmd_chk_adapter(struct mwl_priv *priv)
+{
+	u32 regval;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	regval = readl(priv->iobase1 + MACREG_REG_INT_CODE);
+
+	if (regval == 0xffffffff) {
+		WLDBG_ERROR(DBG_LEVEL_2, "adapter is not existed");
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "adapter is not existed");
+
+		return false;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return true;
+}
+
+static int mwl_fwcmd_exec_cmd(struct mwl_priv *priv, unsigned short cmd)
+{
+	bool busy = false;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	if (!mwl_fwcmd_chk_adapter(priv)) {
+		WLDBG_ERROR(DBG_LEVEL_2, "no adapter existed");
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "no adapter plugged in");
+		priv->in_send_cmd = false;
+		return -EIO;
+	}
+
+	if (!priv->in_send_cmd) {
+		priv->in_send_cmd = true;
+		mwl_fwcmd_send_cmd(priv);
+		if (mwl_fwcmd_wait_complete(priv, 0x8000 | cmd)) {
+			WLDBG_ERROR(DBG_LEVEL_2, "timeout");
+			WLDBG_EXIT_INFO(DBG_LEVEL_2, "timeout");
+			priv->in_send_cmd = false;
+			return -EIO;
+		}
+	} else {
+		WLDBG_WARNING(DBG_LEVEL_2, "previous command is still running");
+		busy = true;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+	if (!busy)
+		priv->in_send_cmd = false;
+
+	return 0;
+}
+
+static void mwl_fwcmd_send_cmd(struct mwl_priv *priv)
+{
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	writel(priv->pphys_cmd_buf, priv->iobase1 + MACREG_REG_GEN_PTR);
+	writel(MACREG_H2ARIC_BIT_DOOR_BELL,
+	       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+}
+
+static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned short cmd)
+{
+	unsigned int curr_iteration = MAX_WAIT_FW_COMPLETE_ITERATIONS;
+
+	unsigned short int_code = 0;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	do {
+		int_code = ENDIAN_SWAP16(priv->pcmd_buf[0]);
+		WL_MSEC_SLEEP(1);
+	} while ((int_code != cmd) && (--curr_iteration));
+
+	if (curr_iteration == 0) {
+		WLDBG_ERROR(DBG_LEVEL_2, "cmd 0x%04x=%s timed out",
+			    cmd, mwl_fwcmd_get_cmd_string(cmd));
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "timeout");
+		return -EIO;
+	}
+
+	WL_MSEC_SLEEP(3);
+
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+static int mwl_fwcmd_802_11_radio_control(struct mwl_priv *priv,
+					  bool enable, bool force)
+{
+	struct hostcmd_cmd_802_11_radio_control *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	if (enable == priv->radio_on && !force)
+		return 0;
+
+	pcmd = (struct hostcmd_cmd_802_11_radio_control *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_RADIO_CONTROL);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(WL_SET);
+	pcmd->control = ENDIAN_SWAP16(priv->radio_short_preamble ?
+		WL_AUTO_PREAMBLE : WL_LONG_PREAMBLE);
+	pcmd->radio_on = ENDIAN_SWAP16(enable ? WL_ENABLE : WL_DISABLE);
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_RADIO_CONTROL)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	priv->radio_on = enable;
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+static int mwl_fwcmd_get_tx_powers(struct mwl_priv *priv, u16 *powlist, u16 ch,
+				   u16 band, u16 width, u16 sub_ch)
+{
+	struct hostcmd_cmd_802_11_tx_power *pcmd;
+	unsigned long flags;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_802_11_tx_power *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_TX_POWER);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(HOSTCMD_ACT_GEN_GET_LIST);
+	pcmd->ch = ENDIAN_SWAP16(ch);
+	pcmd->bw = ENDIAN_SWAP16(width);
+	pcmd->band = ENDIAN_SWAP16(band);
+	pcmd->sub_ch = ENDIAN_SWAP16(sub_ch);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_TX_POWER)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	for (i = 0; i < SYSADPT_TX_POWER_LEVEL_TOTAL; i++)
+		powlist[i] = (u8)ENDIAN_SWAP16(pcmd->power_level_list[i]);
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+static int mwl_fwcmd_set_tx_powers(struct mwl_priv *priv, u16 txpow[],
+				   u8 action, u16 ch, u16 band,
+				   u16 width, u16 sub_ch)
+{
+	struct hostcmd_cmd_802_11_tx_power *pcmd;
+	unsigned long flags;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+
+	pcmd = (struct hostcmd_cmd_802_11_tx_power *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_802_11_TX_POWER);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->action = ENDIAN_SWAP16(action);
+	pcmd->ch = ENDIAN_SWAP16(ch);
+	pcmd->bw = ENDIAN_SWAP16(width);
+	pcmd->band = ENDIAN_SWAP16(band);
+	pcmd->sub_ch = ENDIAN_SWAP16(sub_ch);
+
+	for (i = 0; i < SYSADPT_TX_POWER_LEVEL_TOTAL; i++)
+		pcmd->power_level_list[i] = ENDIAN_SWAP16(txpow[i]);
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_802_11_TX_POWER)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+}
+
+static u8 mwl_fwcmd_get_80m_pri_chnl_offset(u8 channel)
+{
+	u8 act_primary = ACT_PRIMARY_CHAN_0;
+
+	switch (channel) {
+	case 36:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 40:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 44:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 48:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	case 52:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 56:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 60:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 64:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	case 100:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 104:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 108:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 112:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	case 116:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 120:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 124:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 128:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	case 132:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 136:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 140:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 144:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	case 149:
+		act_primary = ACT_PRIMARY_CHAN_0;
+		break;
+	case 153:
+		act_primary = ACT_PRIMARY_CHAN_1;
+		break;
+	case 157:
+		act_primary = ACT_PRIMARY_CHAN_2;
+		break;
+	case 161:
+		act_primary = ACT_PRIMARY_CHAN_3;
+		break;
+	}
+
+	return act_primary;
+}
+
+static void mwl_fwcmd_parse_beacon(struct mwl_priv *priv,
+				   struct mwl_vif *vif, u8 *beacon, int len)
+{
+	struct ieee80211_mgmt *mgmt;
+	struct beacon_info *beacon_info;
+	int baselen;
+	u8 *pos;
+	size_t left;
+	bool elem_parse_failed;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!vif);
+	BUG_ON(!beacon);
+
+	mgmt = (struct ieee80211_mgmt *)beacon;
+
+	baselen = (u8 *)mgmt->u.beacon.variable - (u8 *)mgmt;
+	if (baselen > len)
+		return;
+
+	beacon_info = &vif->beacon_info;
+	memset(beacon_info, 0, sizeof(struct beacon_info));
+	beacon_info->valid = false;
+	beacon_info->ie_ht_ptr = &beacon_info->ie_list_ht[0];
+	beacon_info->ie_vht_ptr = &beacon_info->ie_list_vht[0];
+
+	beacon_info->cap_info = mgmt->u.beacon.capab_info;
+
+	pos = (u8 *)mgmt->u.beacon.variable;
+	left = len - baselen;
+
+	elem_parse_failed = false;
+
+	while (left >= 2) {
+		u8 id, elen;
+
+		id = *pos++;
+		elen = *pos++;
+		left -= 2;
+
+		if (elen > left) {
+			elem_parse_failed = true;
+			break;
+		}
+
+		switch (id) {
+		case WLAN_EID_SUPP_RATES:
+		case WLAN_EID_EXT_SUPP_RATES:
+			{
+			int idx, bi, oi;
+			u8 rate;
+
+			for (bi = 0; bi < SYSADPT_MAX_DATA_RATES_G;
+			     bi++) {
+				if (beacon_info->b_rate_set[bi] == 0)
+					break;
+			}
+
+			for (oi = 0; oi < SYSADPT_MAX_DATA_RATES_G;
+			     oi++) {
+				if (beacon_info->op_rate_set[oi] == 0)
+					break;
+			}
+
+			for (idx = 0; idx < elen; idx++) {
+				rate = pos[idx];
+				if ((rate & 0x80) != 0) {
+					if (bi < SYSADPT_MAX_DATA_RATES_G)
+						beacon_info->b_rate_set[bi++]
+							= rate & 0x7f;
+					else {
+						elem_parse_failed = true;
+						break;
+					}
+				}
+				if (oi < SYSADPT_MAX_DATA_RATES_G)
+					beacon_info->op_rate_set[oi++] =
+						rate & 0x7f;
+				else {
+					elem_parse_failed = true;
+					break;
+				}
+			}
+			}
+			break;
+		case WLAN_EID_RSN:
+			beacon_info->ie_rsn48_len = (elen + 2);
+			beacon_info->ie_rsn48_ptr = (pos - 2);
+			break;
+		case WLAN_EID_HT_CAPABILITY:
+		case WLAN_EID_HT_OPERATION:
+		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
+		case WLAN_EID_EXT_CAPABILITY:
+			beacon_info->ie_ht_len += (elen + 2);
+			if (beacon_info->ie_ht_len >
+			    sizeof(beacon_info->ie_list_ht)) {
+				elem_parse_failed = true;
+			} else {
+				*beacon_info->ie_ht_ptr++ = id;
+				*beacon_info->ie_ht_ptr++ = elen;
+				memcpy(beacon_info->ie_ht_ptr, pos, elen);
+				beacon_info->ie_ht_ptr += elen;
+			}
+			break;
+		case WLAN_EID_VHT_CAPABILITY:
+		case WLAN_EID_VHT_OPERATION:
+		case WLAN_EID_OPMODE_NOTIF:
+			beacon_info->ie_vht_len += (elen + 2);
+			if (beacon_info->ie_vht_len >
+			    sizeof(beacon_info->ie_list_vht)) {
+				elem_parse_failed = true;
+			} else {
+				*beacon_info->ie_vht_ptr++ = id;
+				*beacon_info->ie_vht_ptr++ = elen;
+				memcpy(beacon_info->ie_vht_ptr, pos, elen);
+				beacon_info->ie_vht_ptr += elen;
+			}
+			break;
+		case WLAN_EID_VENDOR_SPECIFIC:
+			if ((pos[0] == 0x00) && (pos[1] == 0x50) &&
+			    (pos[2] == 0xf2)) {
+				if (pos[3] == 0x01) {
+					beacon_info->ie_rsn_len = (elen + 2);
+					beacon_info->ie_rsn_ptr = (pos - 2);
+				}
+
+				if (pos[3] == 0x02) {
+					beacon_info->ie_wmm_len = (elen + 2);
+					beacon_info->ie_wmm_ptr = (pos - 2);
+				}
+			}
+			break;
+		default:
+			break;
+		}
+
+		left -= elen;
+		pos += elen;
+	}
+
+	if (!elem_parse_failed) {
+		beacon_info->ie_ht_ptr = &beacon_info->ie_list_ht[0];
+		beacon_info->ie_vht_ptr = &beacon_info->ie_list_vht[0];
+		beacon_info->valid = true;
+
+		WLDBG_INFO(DBG_LEVEL_2,
+			   "wmm:%d, rsn:%d, rsn48:%d, ht:%d, vht:%d",
+			   beacon_info->ie_wmm_len,
+			   beacon_info->ie_rsn_len,
+			   beacon_info->ie_rsn48_len,
+			   beacon_info->ie_ht_len,
+			   beacon_info->ie_vht_len);
+
+		WLDBG_DUMP_DATA(DBG_LEVEL_2, beacon_info->b_rate_set,
+				SYSADPT_MAX_DATA_RATES_G);
+
+		WLDBG_DUMP_DATA(DBG_LEVEL_2, beacon_info->op_rate_set,
+				SYSADPT_MAX_DATA_RATES_G);
+	}
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "parse valid:%d", beacon_info->valid);
+}
+
+static int mwl_fwcmd_set_ies(struct mwl_priv *priv, struct mwl_vif *mwl_vif)
+{
+	struct hostcmd_cmd_set_ies *pcmd;
+	unsigned long flags;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+	BUG_ON(!mwl_vif);
+
+	if (!mwl_vif->beacon_info.valid)
+		return -EINVAL;
+
+	if (mwl_vif->beacon_info.ie_ht_len > sizeof(pcmd->ie_list_ht))
+		goto einval;
+
+	if (mwl_vif->beacon_info.ie_vht_len > sizeof(pcmd->ie_list_vht))
+		goto einval;
+
+	pcmd = (struct hostcmd_cmd_set_ies *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_SET_IES);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	pcmd->action = ENDIAN_SWAP16(HOSTCMD_ACT_GEN_SET);
+
+	pcmd->ie_list_len_ht = mwl_vif->beacon_info.ie_ht_len;
+	memcpy(pcmd->ie_list_ht, mwl_vif->beacon_info.ie_ht_ptr,
+	       pcmd->ie_list_len_ht);
+
+	pcmd->ie_list_len_vht = mwl_vif->beacon_info.ie_vht_len;
+	memcpy(pcmd->ie_list_vht, mwl_vif->beacon_info.ie_vht_ptr,
+	       pcmd->ie_list_len_vht);
+
+	if (priv->chip_type == MWL8897) {
+		pcmd->ie_list_len_proprietary = mwl_vif->beacon_info.ie_wmm_len;
+		memcpy(pcmd->ie_list_proprietary,
+		       mwl_vif->beacon_info.ie_wmm_ptr,
+		       pcmd->ie_list_len_proprietary);
+	}
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_SET_IES)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+
+einval:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "length of IE is too long");
+
+	return -EINVAL;
+}
+
+static int mwl_fwcmd_set_ap_beacon(struct mwl_priv *priv,
+				   struct mwl_vif *mwl_vif,
+				   struct ieee80211_bss_conf *bss_conf)
+{
+	struct hostcmd_cmd_ap_beacon *pcmd;
+	unsigned long flags;
+	struct ds_params *phy_ds_param_set;
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	BUG_ON(!priv);
+	BUG_ON(!mwl_vif);
+	BUG_ON(!bss_conf);
+
+	if (!mwl_vif->beacon_info.valid)
+		return -EINVAL;
+
+	/* wmm structure of start command is defined less one byte,
+	 * due to following field country is not used, add byte one
+	 * to bypass the check.
+	 */
+	if (mwl_vif->beacon_info.ie_wmm_len >
+	    (sizeof(pcmd->start_cmd.wmm_param) + 1))
+		goto ielenerr;
+
+	if (mwl_vif->beacon_info.ie_rsn_len > sizeof(pcmd->start_cmd.rsn_ie))
+		goto ielenerr;
+
+	if (mwl_vif->beacon_info.ie_rsn48_len >
+	    sizeof(pcmd->start_cmd.rsn48_ie))
+		goto ielenerr;
+
+	pcmd = (struct hostcmd_cmd_ap_beacon *)&priv->pcmd_buf[0];
+
+	MWL_SPIN_LOCK(&priv->locks.fwcmd_lock);
+
+	memset(pcmd, 0x00, sizeof(*pcmd));
+	pcmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_AP_BEACON);
+	pcmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*pcmd));
+	pcmd->cmd_hdr.macid = mwl_vif->macid;
+
+	ether_addr_copy(pcmd->start_cmd.sta_mac_addr, mwl_vif->bssid);
+	memcpy(pcmd->start_cmd.ssid, bss_conf->ssid, bss_conf->ssid_len);
+	pcmd->start_cmd.bss_type = 1;
+	pcmd->start_cmd.bcn_period  = ENDIAN_SWAP16(bss_conf->beacon_int);
+	pcmd->start_cmd.dtim_period = bss_conf->dtim_period; /* 8bit */
+
+	phy_ds_param_set = &pcmd->start_cmd.phy_param_set.ds_param_set;
+	phy_ds_param_set->elem_id = WLAN_EID_DS_PARAMS;
+	phy_ds_param_set->len = sizeof(phy_ds_param_set->current_chnl);
+	phy_ds_param_set->current_chnl = bss_conf->chandef.chan->hw_value;
+
+	pcmd->start_cmd.probe_delay = ENDIAN_SWAP16(10);
+	pcmd->start_cmd.cap_info = ENDIAN_SWAP16(mwl_vif->beacon_info.cap_info);
+
+	memcpy(&pcmd->start_cmd.wmm_param, mwl_vif->beacon_info.ie_wmm_ptr,
+	       mwl_vif->beacon_info.ie_wmm_len);
+
+	memcpy(&pcmd->start_cmd.rsn_ie, mwl_vif->beacon_info.ie_rsn_ptr,
+	       mwl_vif->beacon_info.ie_rsn_len);
+
+	memcpy(&pcmd->start_cmd.rsn48_ie, mwl_vif->beacon_info.ie_rsn48_ptr,
+	       mwl_vif->beacon_info.ie_rsn48_len);
+
+	memcpy(pcmd->start_cmd.b_rate_set, mwl_vif->beacon_info.b_rate_set,
+	       SYSADPT_MAX_DATA_RATES_G);
+
+	memcpy(pcmd->start_cmd.op_rate_set, mwl_vif->beacon_info.op_rate_set,
+	       SYSADPT_MAX_DATA_RATES_G);
+
+	WLDBG_DUMP_DATA(DBG_LEVEL_2, (void *)pcmd, sizeof(*pcmd));
+
+	if (mwl_fwcmd_exec_cmd(priv, HOSTCMD_CMD_AP_BEACON)) {
+		MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+		WLDBG_EXIT_INFO(DBG_LEVEL_2, "failed execution");
+		return -EIO;
+	}
+
+	MWL_SPIN_UNLOCK(&priv->locks.fwcmd_lock);
+	WLDBG_EXIT(DBG_LEVEL_2);
+
+	return 0;
+
+ielenerr:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "length of IE is too long");
+
+	return -EINVAL;
+}
+
+static int mwl_fwcmd_encryption_set_cmd_info(struct hostcmd_cmd_set_key *cmd,
+					     u8 *addr,
+					     struct ieee80211_key_conf *key)
+{
+	cmd->cmd_hdr.cmd = ENDIAN_SWAP16(HOSTCMD_CMD_UPDATE_ENCRYPTION);
+	cmd->cmd_hdr.len = ENDIAN_SWAP16(sizeof(*cmd));
+	cmd->key_param.length = ENDIAN_SWAP16(sizeof(*cmd) -
+		offsetof(struct hostcmd_cmd_set_key, key_param));
+	cmd->key_param.key_index = ENDIAN_SWAP32(key->keyidx);
+	cmd->key_param.key_len = ENDIAN_SWAP16(key->keylen);
+	ether_addr_copy(cmd->key_param.mac_addr, addr);
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		cmd->key_param.key_type_id = ENDIAN_SWAP16(KEY_TYPE_ID_WEP);
+		if (key->keyidx == 0)
+			cmd->key_param.key_info =
+				ENDIAN_SWAP32(ENCR_KEY_FLAG_WEP_TXKEY);
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		cmd->key_param.key_type_id = ENDIAN_SWAP16(KEY_TYPE_ID_TKIP);
+		cmd->key_param.key_info =
+			(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ?
+			ENDIAN_SWAP32(ENCR_KEY_FLAG_PAIRWISE) :
+			ENDIAN_SWAP32(ENCR_KEY_FLAG_TXGROUPKEY);
+		cmd->key_param.key_info |=
+			ENDIAN_SWAP32(ENCR_KEY_FLAG_MICKEY_VALID |
+				      ENCR_KEY_FLAG_TSC_VALID);
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		cmd->key_param.key_type_id = ENDIAN_SWAP16(KEY_TYPE_ID_AES);
+		cmd->key_param.key_info =
+			(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ?
+			ENDIAN_SWAP32(ENCR_KEY_FLAG_PAIRWISE) :
+			ENDIAN_SWAP32(ENCR_KEY_FLAG_TXGROUPKEY);
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+#ifdef MWL_DEBUG
+static char *mwl_fwcmd_get_cmd_string(unsigned short cmd)
+{
+	int max_entries = 0;
+	int curr_cmd = 0;
+
+	static const struct {
+		u16 cmd;
+		char *cmd_string;
+	} cmds[] = {
+		{ HOSTCMD_CMD_GET_HW_SPEC, "GetHwSpecifications" },
+		{ HOSTCMD_CMD_SET_HW_SPEC, "SetHwSepcifications" },
+		{ HOSTCMD_CMD_802_11_GET_STAT, "80211GetStat" },
+		{ HOSTCMD_CMD_802_11_RADIO_CONTROL, "80211RadioControl" },
+		{ HOSTCMD_CMD_802_11_TX_POWER, "80211TxPower" },
+		{ HOSTCMD_CMD_802_11_RF_ANTENNA, "80211RfAntenna" },
+		{ HOSTCMD_CMD_BROADCAST_SSID_ENABLE, "broadcast_ssid_enable" },
+		{ HOSTCMD_CMD_SET_RF_CHANNEL, "SetRfChannel" },
+		{ HOSTCMD_CMD_SET_AID, "SetAid" },
+		{ HOSTCMD_CMD_SET_INFRA_MODE, "SetInfraMode" },
+		{ HOSTCMD_CMD_802_11_RTS_THSD, "80211RtsThreshold" },
+		{ HOSTCMD_CMD_SET_EDCA_PARAMS, "SetEDCAParams" },
+		{ HOSTCMD_CMD_SET_WMM_MODE, "SetWMMMode" },
+		{ HOSTCMD_CMD_SET_FIXED_RATE, "SetFixedRate" },
+		{ HOSTCMD_CMD_SET_IES, "SetInformationElements" },
+		{ HOSTCMD_CMD_SET_RATE_ADAPT_MODE, "SetRateAdaptationMode" },
+		{ HOSTCMD_CMD_SET_MAC_ADDR, "SetMacAddr" },
+		{ HOSTCMD_CMD_GET_WATCHDOG_BITMAP, "GetWatchdogBitMap" },
+		{ HOSTCMD_CMD_DEL_MAC_ADDR. "DelMacAddr" },
+		{ HOSTCMD_CMD_BSS_START, "BssStart" },
+		{ HOSTCMD_CMD_AP_BEACON, "SetApBeacon" },
+		{ HOSTCMD_CMD_SET_NEW_STN, "SetNewStation" },
+		{ HOSTCMD_CMD_SET_APMODE, "SetApMode" },
+		{ HOSTCMD_CMD_UPDATE_ENCRYPTION, "UpdateEncryption" },
+		{ HOSTCMD_CMD_BASTREAM, "BAStream" },
+		{ HOSTCMD_CMD_DWDS_ENABLE, "DwdsEnable" },
+		{ HOSTCMD_CMD_FW_FLUSH_TIMER, "FwFlushTimer" },
+		{ HOSTCMD_CMD_SET_CDD, "SetCDD" },
+	};
+
+	WLDBG_ENTER(DBG_LEVEL_2);
+
+	max_entries = sizeof(cmds) / sizeof(cmds[0]);
+
+	for (curr_cmd = 0; curr_cmd < max_entries; curr_cmd++) {
+		if ((cmd & 0x7fff) == cmds[curr_cmd].cmd) {
+			WLDBG_EXIT(DBG_LEVEL_2);
+			return cmds[curr_cmd].cmd_string;
+		}
+	}
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_2, "unknown");
+
+	return "unknown";
+}
+#endif
diff --git a/drivers/net/wireless/mwlwifi/mwl_fwcmd.h b/drivers/net/wireless/mwlwifi/mwl_fwcmd.h
new file mode 100644
index 0000000..36b27eb
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_fwcmd.h
@@ -0,0 +1,184 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines firmware host command related functions.
+*/
+
+#ifndef _mwl_fwcmd_h_
+#define _mwl_fwcmd_h_
+
+/* CONSTANTS AND MACROS
+*/
+
+/*  Define OpMode for SoftAP/Station mode
+ *
+ *  The following mode signature has to be written to PCI scratch register#0
+ *  right after successfully downloading the last block of firmware and
+ *  before waiting for firmware ready signature
+ */
+
+#define HOSTCMD_STA_MODE                0x5A
+#define HOSTCMD_SOFTAP_MODE             0xA5
+
+#define HOSTCMD_STA_FWRDY_SIGNATURE     0xF0F1F2F4
+#define HOSTCMD_SOFTAP_FWRDY_SIGNATURE  0xF1F2F4A5
+
+/* TYPE DEFINITION
+*/
+
+enum {
+	WL_ANTENNATYPE_RX = 1,
+	WL_ANTENNATYPE_TX = 2,
+};
+
+enum encr_type {
+	ENCR_TYPE_WEP = 0,
+	ENCR_TYPE_DISABLE = 1,
+	ENCR_TYPE_TKIP = 4,
+	ENCR_TYPE_AES = 6,
+	ENCR_TYPE_MIX = 7,
+};
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+
+void mwl_fwcmd_reset(struct ieee80211_hw *hw);
+
+void mwl_fwcmd_int_enable(struct ieee80211_hw *hw);
+
+void mwl_fwcmd_int_disable(struct ieee80211_hw *hw);
+
+int mwl_fwcmd_get_hw_specs(struct ieee80211_hw *hw);
+
+int mwl_fwcmd_set_hw_specs(struct ieee80211_hw *hw);
+
+int mwl_fwcmd_get_stat(struct ieee80211_hw *hw,
+		       struct ieee80211_low_level_stats *stats);
+
+int mwl_fwcmd_radio_enable(struct ieee80211_hw *hw);
+
+int mwl_fwcmd_radio_disable(struct ieee80211_hw *hw);
+
+int mwl_fwcmd_set_radio_preamble(struct ieee80211_hw *hw,
+				 bool short_preamble);
+
+int mwl_fwcmd_max_tx_power(struct ieee80211_hw *hw,
+			   struct ieee80211_conf *conf, u8 fraction);
+
+int mwl_fwcmd_tx_power(struct ieee80211_hw *hw,
+		       struct ieee80211_conf *conf, u8 fraction);
+
+int mwl_fwcmd_rf_antenna(struct ieee80211_hw *hw, int dir, int antenna);
+
+int mwl_fwcmd_broadcast_ssid_enable(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, bool enable);
+
+int mwl_fwcmd_set_rf_channel(struct ieee80211_hw *hw,
+			     struct ieee80211_conf *conf);
+
+int mwl_fwcmd_set_aid(struct ieee80211_hw *hw,
+		      struct ieee80211_vif *vif, u8 *bssid, u16 aid);
+
+int mwl_fwcmd_set_infra_mode(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
+
+int mwl_fwcmd_set_rts_threshold(struct ieee80211_hw *hw,
+				int threshold);
+
+int mwl_fwcmd_set_edca_params(struct ieee80211_hw *hw, u8 index,
+			      u16 cw_min, u16 cw_max, u8 aifs, u16 txop);
+
+int mwl_fwcmd_set_wmm_mode(struct ieee80211_hw *hw,
+			   bool enable);
+
+int mwl_fwcmd_use_fixed_rate(struct ieee80211_hw *hw,
+			     int mcast, int mgmt);
+
+int mwl_fwcmd_set_rate_adapt_mode(struct ieee80211_hw *hw,
+				  u16 mode);
+
+int mwl_fwcmd_set_mac_addr_client(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif, u8 *mac_addr);
+
+int mwl_fwcmd_get_watchdog_bitmap(struct ieee80211_hw *hw,
+				  u8 *bitmap);
+
+int mwl_fwcmd_remove_mac_addr(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u8 *mac_addr);
+
+int mwl_fwcmd_bss_start(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif, bool enable);
+
+int mwl_fwcmd_set_beacon(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u8 *beacon, int len);
+
+int mwl_fwcmd_set_new_stn_add(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta);
+
+int mwl_fwcmd_set_new_stn_add_self(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif);
+
+int mwl_fwcmd_set_new_stn_del(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u8 *addr);
+
+int mwl_fwcmd_set_apmode(struct ieee80211_hw *hw, u8 apmode);
+
+int mwl_fwcmd_update_encryption_enable(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       u8 *addr, u8 encr_type);
+
+int mwl_fwcmd_encryption_set_key(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif, u8 *addr,
+				 struct ieee80211_key_conf *key);
+
+int mwl_fwcmd_encryption_remove_key(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, u8 *addr,
+				    struct ieee80211_key_conf *key);
+
+int mwl_fwcmd_check_ba(struct ieee80211_hw *hw,
+		       struct mwl_ampdu_stream *stream,
+		       struct ieee80211_vif *vif);
+
+int mwl_fwcmd_create_ba(struct ieee80211_hw *hw,
+			struct mwl_ampdu_stream *stream,
+			u8 buf_size, struct ieee80211_vif *vif);
+
+int mwl_fwcmd_destroy_ba(struct ieee80211_hw *hw,
+			 u8 idx);
+
+struct mwl_ampdu_stream *mwl_fwcmd_add_stream(struct ieee80211_hw *hw,
+					      struct ieee80211_sta *sta,
+					      u8 tid);
+
+int mwl_fwcmd_start_stream(struct ieee80211_hw *hw,
+			   struct mwl_ampdu_stream *stream);
+
+void mwl_fwcmd_remove_stream(struct ieee80211_hw *hw,
+			     struct mwl_ampdu_stream *stream);
+
+struct mwl_ampdu_stream *mwl_fwcmd_lookup_stream(struct ieee80211_hw *hw,
+						 u8 *addr, u8 tid);
+
+bool mwl_fwcmd_ampdu_allowed(struct ieee80211_sta *sta, u8 tid);
+
+int mwl_fwcmd_set_dwds_stamode(struct ieee80211_hw *hw, bool enable);
+
+int mwl_fwcmd_set_fw_flush_timer(struct ieee80211_hw *hw, u32 value);
+
+int mwl_fwcmd_set_cdd(struct ieee80211_hw *hw);
+
+#endif /* _mwl_fwcmd_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_fwdl.c b/drivers/net/wireless/mwlwifi/mwl_fwdl.c
new file mode 100644
index 0000000..442c21c
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_fwdl.c
@@ -0,0 +1,218 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements firmware download related functions.
+*/
+
+#include <linux/io.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_fwcmd.h"
+#include "mwl_fwdl.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define FW_DOWNLOAD_BLOCK_SIZE          256
+#define FW_CHECK_MSECS                  1
+
+#define FW_MAX_NUM_CHECKS               0xffff
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static void mwl_fwdl_trig_pcicmd(struct mwl_priv *priv);
+static void mwl_fwdl_trig_pcicmd_bootcode(struct mwl_priv *priv);
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+int mwl_fwdl_download_firmware(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	const struct firmware *fw;
+	u32 curr_iteration = 0;
+	u32 size_fw_downloaded = 0;
+	u32 int_code = 0;
+	u32 len = 0;
+
+	WLDBG_ENTER(DBG_LEVEL_1);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+	fw = priv->fw_ucode;
+	BUG_ON(!fw);
+
+	mwl_fwcmd_reset(hw);
+
+	/* FW before jumping to boot rom, it will enable PCIe transaction retry,
+	 * wait for boot code to stop it.
+	 */
+	WL_MSEC_SLEEP(FW_CHECK_MSECS);
+
+	writel(MACREG_A2HRIC_BIT_MASK,
+	       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_CLEAR_SEL);
+	writel(0x00, priv->iobase1 + MACREG_REG_A2H_INTERRUPT_CAUSE);
+	writel(0x00, priv->iobase1 + MACREG_REG_A2H_INTERRUPT_MASK);
+	writel(MACREG_A2HRIC_BIT_MASK,
+	       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+
+	/* this routine interacts with SC2 bootrom to download firmware binary
+	 * to the device. After DMA'd to SC2, the firmware could be deflated to
+	 * reside on its respective blocks such as ITCM, DTCM, SQRAM,
+	 * (or even DDR, AFTER DDR is init'd before fw download
+	 */
+	WLDBG_PRINT("fw download start 88");
+
+	/* Disable PFU before FWDL
+	*/
+	writel(0x100, priv->iobase1 + 0xE0E4);
+
+	/* make sure SCRATCH2 C40 is clear, in case we are too quick
+	*/
+	while (readl(priv->iobase1 + 0xc40) == 0)
+		;
+
+	while (size_fw_downloaded < fw->size) {
+		len = readl(priv->iobase1 + 0xc40);
+
+		if (!len)
+			break;
+
+		/* this copies the next chunk of fw binary to be delivered */
+		memcpy((char *)&priv->pcmd_buf[0],
+		       (fw->data + size_fw_downloaded), len);
+
+		/* this function writes pdata to c10, then write 2 to c18
+		*/
+		mwl_fwdl_trig_pcicmd_bootcode(priv);
+
+		/* this is arbitrary per your platform; we use 0xffff */
+		curr_iteration = FW_MAX_NUM_CHECKS;
+
+		/* NOTE: the following back to back checks on C1C is time
+		 * sensitive, hence may need to be tweaked dependent on host
+		 * processor. Time for SC2 to go from the write of event 2 to
+		 * C1C == 2 is ~1300 nSec. Hence the checkings on host has to
+		 * consider how efficient your code can be to meet this timing,
+		 * or you can alternatively tweak this routines to fit your
+		 * platform
+		 */
+		do {
+			int_code = readl(priv->iobase1 + 0xc1c);
+			if (int_code != 0)
+				break;
+			curr_iteration--;
+		} while (curr_iteration);
+
+		do {
+			int_code = readl(priv->iobase1 + 0xc1c);
+			if ((int_code & MACREG_H2ARIC_BIT_DOOR_BELL) !=
+			    MACREG_H2ARIC_BIT_DOOR_BELL)
+				break;
+			curr_iteration--;
+		} while (curr_iteration);
+
+		if (curr_iteration == 0) {
+			/* This limited loop check allows you to exit gracefully
+			 * without locking up your entire system just because fw
+			 * download failed
+			 */
+			WLDBG_PRINT("Exhausted curr_iteration for fw download");
+			goto err_download;
+		}
+
+		size_fw_downloaded += len;
+	}
+
+	WLDBG_PRINT("FwSize = %d downloaded Size = %d curr_iteration %d",
+		    (int)fw->size, size_fw_downloaded, curr_iteration);
+
+	/* Now firware is downloaded successfully, so this part is to check
+	 * whether fw can properly execute to an extent that write back
+	 * signature to indicate its readiness to the host. NOTE: if your
+	 * downloaded fw crashes, this signature checking will fail. This
+	 * part is similar as SC1
+	 */
+	writew(0x00, &priv->pcmd_buf[1]);
+	mwl_fwdl_trig_pcicmd(priv);
+	curr_iteration = FW_MAX_NUM_CHECKS;
+	do {
+		curr_iteration--;
+		writel(HOSTCMD_SOFTAP_MODE, priv->iobase1 + MACREG_REG_GEN_PTR);
+		WL_MSEC_SLEEP(FW_CHECK_MSECS);
+		int_code = readl(priv->iobase1 + MACREG_REG_INT_CODE);
+		if (!(curr_iteration % 0xff))
+			WLDBG_PRINT("%x;", int_code);
+	} while ((curr_iteration) &&
+		 (int_code != HOSTCMD_SOFTAP_FWRDY_SIGNATURE));
+
+	if (curr_iteration == 0) {
+		WLDBG_PRINT("Exhausted curr_iteration for fw signature");
+		goto err_download;
+	}
+
+	WLDBG_PRINT("complete");
+	writel(0x00, priv->iobase1 + MACREG_REG_INT_CODE);
+
+	WLDBG_EXIT(DBG_LEVEL_1);
+
+	return 0;
+
+err_download:
+
+	mwl_fwcmd_reset(hw);
+
+	return -EIO;
+}
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static void mwl_fwdl_trig_pcicmd(struct mwl_priv *priv)
+{
+	WLDBG_ENTER(DBG_LEVEL_1);
+
+	BUG_ON(!priv);
+
+	writel(priv->pphys_cmd_buf, priv->iobase1 + MACREG_REG_GEN_PTR);
+
+	writel(0x00, priv->iobase1 + MACREG_REG_INT_CODE);
+
+	writel(MACREG_H2ARIC_BIT_DOOR_BELL,
+	       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
+
+	WLDBG_EXIT(DBG_LEVEL_1);
+}
+
+static void mwl_fwdl_trig_pcicmd_bootcode(struct mwl_priv *priv)
+{
+	WLDBG_ENTER(DBG_LEVEL_1);
+
+	BUG_ON(!priv);
+
+	writel(priv->pphys_cmd_buf, priv->iobase1 + MACREG_REG_GEN_PTR);
+
+	writel(0x00, priv->iobase1 + MACREG_REG_INT_CODE);
+
+	writel(MACREG_H2ARIC_BIT_DOOR_BELL,
+	       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
+
+	WLDBG_EXIT(DBG_LEVEL_1);
+}
diff --git a/drivers/net/wireless/mwlwifi/mwl_fwdl.h b/drivers/net/wireless/mwlwifi/mwl_fwdl.h
new file mode 100644
index 0000000..cad4056
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_fwdl.h
@@ -0,0 +1,29 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines firmware download related functions.
+*/
+
+#ifndef _mwl_fwdl_h_
+#define _mwl_fwdl_h_
+
+#include <net/mac80211.h>
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+int mwl_fwdl_download_firmware(struct ieee80211_hw *hw);
+
+#endif /* _mwl_fwdl_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_mac80211.c b/drivers/net/wireless/mwlwifi/mwl_mac80211.c
new file mode 100644
index 0000000..41475d0
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_mac80211.c
@@ -0,0 +1,877 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements mac80211 related functions.
+*/
+
+#include <linux/etherdevice.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_fwcmd.h"
+#include "mwl_tx.h"
+#include "mwl_mac80211.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define MWL_DRV_NAME        KBUILD_MODNAME
+
+#define MAX_AMPDU_ATTEMPTS  5
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static void mwl_mac80211_tx(struct ieee80211_hw *hw,
+			    struct ieee80211_tx_control *control,
+			    struct sk_buff *skb);
+static int mwl_mac80211_start(struct ieee80211_hw *hw);
+static void mwl_mac80211_stop(struct ieee80211_hw *hw);
+static int mwl_mac80211_add_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif);
+static void mwl_mac80211_remove_interface(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif);
+static int mwl_mac80211_config(struct ieee80211_hw *hw,
+			       u32 changed);
+static void mwl_mac80211_bss_info_changed(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_bss_conf *info,
+					  u32 changed);
+static void mwl_mac80211_configure_filter(struct ieee80211_hw *hw,
+					  unsigned int changed_flags,
+					  unsigned int *total_flags,
+					  u64 multicast);
+static int mwl_mac80211_set_key(struct ieee80211_hw *hw,
+				enum set_key_cmd cmd_param,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct ieee80211_key_conf *key);
+static int mwl_mac80211_set_rts_threshold(struct ieee80211_hw *hw,
+					  u32 value);
+static int mwl_mac80211_sta_add(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta);
+static int mwl_mac80211_sta_remove(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta);
+static int mwl_mac80211_conf_tx(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				u16 queue,
+				const struct ieee80211_tx_queue_params *params);
+static int mwl_mac80211_get_stats(struct ieee80211_hw *hw,
+				  struct ieee80211_low_level_stats *stats);
+static int mwl_mac80211_get_survey(struct ieee80211_hw *hw,
+				   int idx,
+				   struct survey_info *survey);
+static int mwl_mac80211_ampdu_action(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     enum ieee80211_ampdu_mlme_action action,
+				     struct ieee80211_sta *sta,
+				     u16 tid, u16 *ssn, u8 buf_size);
+static void mwl_mac80211_remove_vif(struct mwl_priv *priv,
+				    struct mwl_vif *vif);
+static void mwl_mac80211_bss_info_changed_sta(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif,
+					      struct ieee80211_bss_conf *info,
+					      u32 changed);
+static void mwl_mac80211_bss_info_changed_ap(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_bss_conf *info,
+					     u32 changed);
+
+/* PRIVATE VARIABLES
+*/
+
+static struct ieee80211_ops mwl_mac80211_ops = {
+	.tx                 = mwl_mac80211_tx,
+	.start              = mwl_mac80211_start,
+	.stop               = mwl_mac80211_stop,
+	.add_interface      = mwl_mac80211_add_interface,
+	.remove_interface   = mwl_mac80211_remove_interface,
+	.config             = mwl_mac80211_config,
+	.bss_info_changed   = mwl_mac80211_bss_info_changed,
+	.configure_filter   = mwl_mac80211_configure_filter,
+	.set_key            = mwl_mac80211_set_key,
+	.set_rts_threshold  = mwl_mac80211_set_rts_threshold,
+	.sta_add            = mwl_mac80211_sta_add,
+	.sta_remove         = mwl_mac80211_sta_remove,
+	.conf_tx            = mwl_mac80211_conf_tx,
+	.get_stats          = mwl_mac80211_get_stats,
+	.get_survey         = mwl_mac80211_get_survey,
+	.ampdu_action       = mwl_mac80211_ampdu_action,
+};
+
+static irqreturn_t (*mwl_mac80211_isr)(int irq, void *dev_id);
+
+static const struct ieee80211_rate mwl_rates_24[] = {
+	{ .bitrate = 10, .hw_value = 2, },
+	{ .bitrate = 20, .hw_value = 4, },
+	{ .bitrate = 55, .hw_value = 11, },
+	{ .bitrate = 110, .hw_value = 22, },
+	{ .bitrate = 220, .hw_value = 44, },
+	{ .bitrate = 60, .hw_value = 12, },
+	{ .bitrate = 90, .hw_value = 18, },
+	{ .bitrate = 120, .hw_value = 24, },
+	{ .bitrate = 180, .hw_value = 36, },
+	{ .bitrate = 240, .hw_value = 48, },
+	{ .bitrate = 360, .hw_value = 72, },
+	{ .bitrate = 480, .hw_value = 96, },
+	{ .bitrate = 540, .hw_value = 108, },
+};
+
+static const struct ieee80211_rate mwl_rates_50[] = {
+	{ .bitrate = 60, .hw_value = 12, },
+	{ .bitrate = 90, .hw_value = 18, },
+	{ .bitrate = 120, .hw_value = 24, },
+	{ .bitrate = 180, .hw_value = 36, },
+	{ .bitrate = 240, .hw_value = 48, },
+	{ .bitrate = 360, .hw_value = 72, },
+	{ .bitrate = 480, .hw_value = 96, },
+	{ .bitrate = 540, .hw_value = 108, },
+};
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+struct ieee80211_ops *mwl_mac80211_get_ops(void)
+{
+	return &mwl_mac80211_ops;
+}
+
+void mwl_mac80211_set_isr(irqreturn_t (*isr)(int irq, void *dev_id))
+{
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	mwl_mac80211_isr = isr;
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static void mwl_mac80211_tx(struct ieee80211_hw *hw,
+			    struct ieee80211_tx_control *control,
+	struct sk_buff *skb)
+{
+	struct mwl_priv *priv;
+	int index;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!skb);
+
+	if (!priv->radio_on) {
+		WLDBG_EXIT_INFO(DBG_LEVEL_5,
+				"dropped TX frame since radio disabled");
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	index = skb_get_queue_mapping(skb);
+
+	mwl_tx_xmit(hw, index, control->sta, skb);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+static int mwl_mac80211_start(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	rc = request_irq(priv->pdev->irq, mwl_mac80211_isr,
+			 IRQF_SHARED, MWL_DRV_NAME, hw);
+	if (rc) {
+		priv->irq = -1;
+		WLDBG_ERROR(DBG_LEVEL_5, "fail to register IRQ handler");
+		return rc;
+	}
+	priv->irq = priv->pdev->irq;
+
+	/* Enable TX reclaim and RX tasklets.
+	*/
+	tasklet_enable(&priv->tx_task);
+	tasklet_enable(&priv->rx_task);
+
+	/* Enable interrupts
+	*/
+	mwl_fwcmd_int_enable(hw);
+
+	rc = mwl_fwcmd_radio_enable(hw);
+
+	if (!rc)
+		rc = mwl_fwcmd_set_rate_adapt_mode(hw, 0);
+
+	if (!rc)
+		rc = mwl_fwcmd_set_wmm_mode(hw, true);
+
+	if (!rc)
+		rc = mwl_fwcmd_set_dwds_stamode(hw, true);
+
+	if (!rc)
+		rc = mwl_fwcmd_set_fw_flush_timer(hw, 0);
+
+	if (rc) {
+		mwl_fwcmd_int_disable(hw);
+		free_irq(priv->pdev->irq, hw);
+		priv->irq = -1;
+		tasklet_disable(&priv->tx_task);
+		tasklet_disable(&priv->rx_task);
+	} else {
+		ieee80211_wake_queues(hw);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+
+	return rc;
+}
+
+static void mwl_mac80211_stop(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	mwl_fwcmd_radio_disable(hw);
+
+	ieee80211_stop_queues(hw);
+
+	/* Disable interrupts
+	*/
+	mwl_fwcmd_int_disable(hw);
+
+	if (priv->irq != -1) {
+		free_irq(priv->pdev->irq, hw);
+		priv->irq = -1;
+	}
+
+	cancel_work_sync(&priv->watchdog_ba_handle);
+
+	/* Disable TX reclaim and RX tasklets.
+	*/
+	tasklet_disable(&priv->tx_task);
+	tasklet_disable(&priv->rx_task);
+
+	/* Return all skbs to mac80211
+	*/
+	mwl_tx_done((unsigned long)hw);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+static int mwl_mac80211_add_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv = hw->priv;
+	struct mwl_vif *mwl_vif;
+	u32 macids_supported;
+	int macid;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+		macids_supported = priv->ap_macids_supported;
+		break;
+	case NL80211_IFTYPE_STATION:
+		macids_supported = priv->sta_macids_supported;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	macid = ffs(macids_supported & ~priv->macids_used);
+
+	if (!macid--) {
+		WLDBG_EXIT_INFO(DBG_LEVEL_5, "no macid can be allocated");
+		return -EBUSY;
+	}
+
+	/* Setup driver private area.
+	*/
+	mwl_vif = MWL_VIF(vif);
+	memset(mwl_vif, 0, sizeof(*mwl_vif));
+	mwl_vif->vif = vif;
+	mwl_vif->macid = macid;
+	mwl_vif->seqno = 0;
+	mwl_vif->is_hw_crypto_enabled = false;
+	mwl_vif->is_sta = false;
+	mwl_vif->beacon_info.valid = false;
+	mwl_vif->iv16 = 1;
+	mwl_vif->iv32 = 0;
+	mwl_vif->keyidx = 0;
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		ether_addr_copy(mwl_vif->sta_mac, vif->addr);
+		mwl_vif->is_sta = true;
+		mwl_fwcmd_bss_start(hw, vif, true);
+		mwl_fwcmd_set_infra_mode(hw, vif);
+		mwl_fwcmd_set_mac_addr_client(hw, vif, vif->addr);
+	}
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		ether_addr_copy(mwl_vif->bssid, vif->addr);
+		mwl_fwcmd_set_new_stn_add_self(hw, vif);
+	}
+
+	priv->macids_used |= 1 << mwl_vif->macid;
+	list_add_tail(&mwl_vif->list, &priv->vif_list);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+
+	return 0;
+}
+
+static void mwl_mac80211_remove_interface(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct mwl_priv *priv = hw->priv;
+	struct mwl_vif *mwl_vif = MWL_VIF(vif);
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	if (vif->type == NL80211_IFTYPE_STATION)
+		mwl_fwcmd_remove_mac_addr(hw, vif, vif->addr);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		mwl_fwcmd_set_new_stn_del(hw, vif, vif->addr);
+
+	mwl_mac80211_remove_vif(priv, mwl_vif);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+static int mwl_mac80211_config(struct ieee80211_hw *hw,
+			       u32 changed)
+{
+	struct ieee80211_conf *conf = &hw->conf;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	WLDBG_INFO(DBG_LEVEL_5, "change: 0x%x", changed);
+
+	if (conf->flags & IEEE80211_CONF_IDLE)
+		rc = mwl_fwcmd_radio_disable(hw);
+	else
+		rc = mwl_fwcmd_radio_enable(hw);
+
+	if (rc)
+		goto out;
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		int rate = 0;
+
+		if (conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
+			mwl_fwcmd_set_apmode(hw, AP_MODE_2_4GHZ_11AC_MIXED);
+			rate = mwl_rates_24[0].hw_value;
+		} else if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ) {
+			mwl_fwcmd_set_apmode(hw, AP_MODE_11AC);
+			rate = mwl_rates_50[0].hw_value;
+		}
+
+		rc = mwl_fwcmd_set_rf_channel(hw, conf);
+
+		if (rc)
+			goto out;
+
+		rc = mwl_fwcmd_use_fixed_rate(hw, rate, rate);
+
+		if (rc)
+			goto out;
+
+		rc = mwl_fwcmd_max_tx_power(hw, conf, 0);
+
+		if (rc)
+			goto out;
+
+		rc = mwl_fwcmd_tx_power(hw, conf, 0);
+
+		if (rc)
+			goto out;
+
+		rc = mwl_fwcmd_set_cdd(hw);
+	}
+
+out:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static void mwl_mac80211_bss_info_changed(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_bss_conf *info,
+					  u32 changed)
+{
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	WLDBG_INFO(DBG_LEVEL_5, "interface: %d, change: 0x%x",
+		   vif->type, changed);
+
+	if (vif->type == NL80211_IFTYPE_STATION)
+		mwl_mac80211_bss_info_changed_sta(hw, vif, info, changed);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		mwl_mac80211_bss_info_changed_ap(hw, vif, info, changed);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+static void mwl_mac80211_configure_filter(struct ieee80211_hw *hw,
+					  unsigned int changed_flags,
+					  unsigned int *total_flags,
+					  u64 multicast)
+{
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	/* AP firmware doesn't allow fine-grained control over
+	 * the receive filter.
+	 */
+	*total_flags &= FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+}
+
+static int mwl_mac80211_set_key(struct ieee80211_hw *hw,
+				enum set_key_cmd cmd_param,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct ieee80211_key_conf *key)
+{
+	int rc = 0;
+	u8 encr_type;
+	u8 *addr;
+	struct mwl_vif *mwl_vif = MWL_VIF(vif);
+	struct mwl_sta *sta_info = MWL_STA(sta);
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(!mwl_vif);
+	BUG_ON(!sta_info);
+
+	if (!sta) {
+		addr = vif->addr;
+	} else {
+		addr = sta->addr;
+		if (mwl_vif->is_sta)
+			ether_addr_copy(mwl_vif->bssid, addr);
+	}
+
+	if (cmd_param == SET_KEY) {
+		rc = mwl_fwcmd_encryption_set_key(hw, vif, addr, key);
+
+		if (rc)
+			goto out;
+
+		if ((key->cipher == WLAN_CIPHER_SUITE_WEP40) ||
+		    (key->cipher == WLAN_CIPHER_SUITE_WEP104)) {
+			encr_type = ENCR_TYPE_WEP;
+		} else if (key->cipher == WLAN_CIPHER_SUITE_CCMP) {
+			encr_type = ENCR_TYPE_AES;
+			if ((key->flags & IEEE80211_KEY_FLAG_PAIRWISE) == 0) {
+				if (!mwl_vif->is_sta)
+					mwl_vif->keyidx = key->keyidx;
+			}
+		} else if (key->cipher == WLAN_CIPHER_SUITE_TKIP) {
+			encr_type = ENCR_TYPE_TKIP;
+		} else {
+			encr_type = ENCR_TYPE_DISABLE;
+		}
+
+		rc = mwl_fwcmd_update_encryption_enable(hw, vif, addr,
+							encr_type);
+
+		if (rc)
+			goto out;
+
+		mwl_vif->is_hw_crypto_enabled = true;
+	} else {
+		rc = mwl_fwcmd_encryption_remove_key(hw, vif, addr, key);
+
+		if (rc)
+			goto out;
+	}
+
+out:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_set_rts_threshold(struct ieee80211_hw *hw,
+					  u32 value)
+{
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	rc =  mwl_fwcmd_set_rts_threshold(hw, value);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_sta_add(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct mwl_vif *mwl_vif = MWL_VIF(vif);
+	struct mwl_sta *sta_info = MWL_STA(sta);
+	struct ieee80211_key_conf *key;
+	int rc;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(!mwl_vif);
+	BUG_ON(!sta_info);
+
+	memset(sta_info, 0, sizeof(*sta_info));
+	sta_info->iv16 = 1;
+	sta_info->iv32 = 0;
+	if (sta->ht_cap.ht_supported)
+		sta_info->is_ampdu_allowed = true;
+
+	if (mwl_vif->is_sta)
+		mwl_fwcmd_set_new_stn_del(hw, vif, sta->addr);
+
+	rc = mwl_fwcmd_set_new_stn_add(hw, vif, sta);
+
+	for (i = 0; i < NUM_WEP_KEYS; i++) {
+		key = IEEE80211_KEY_CONF(mwl_vif->wep_key_conf[i].key);
+
+		if (mwl_vif->wep_key_conf[i].enabled)
+			mwl_mac80211_set_key(hw, SET_KEY, vif, sta, key);
+	}
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_sta_remove(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   struct ieee80211_sta *sta)
+{
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	rc = mwl_fwcmd_set_new_stn_del(hw, vif, sta->addr);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_conf_tx(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				u16 queue,
+				const struct ieee80211_tx_queue_params *params)
+{
+	struct mwl_priv *priv = hw->priv;
+	int rc = 0;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	BUG_ON(queue > SYSADPT_TX_WMM_QUEUES - 1);
+
+	memcpy(&priv->wmm_params[queue], params, sizeof(*params));
+
+	if (!priv->wmm_enabled) {
+		rc = mwl_fwcmd_set_wmm_mode(hw, true);
+		priv->wmm_enabled = true;
+	}
+
+	if (!rc) {
+		int q = SYSADPT_TX_WMM_QUEUES - 1 - queue;
+
+		rc = mwl_fwcmd_set_edca_params(hw, q,
+					       params->cw_min, params->cw_max,
+			params->aifs, params->txop);
+	}
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_get_stats(struct ieee80211_hw *hw,
+				  struct ieee80211_low_level_stats *stats)
+{
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	rc = mwl_fwcmd_get_stat(hw, stats);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_5, "return code: %d", rc);
+
+	return rc;
+}
+
+static int mwl_mac80211_get_survey(struct ieee80211_hw *hw,
+				   int idx,
+	struct survey_info *survey)
+{
+	struct mwl_priv *priv = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->chandef.chan;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = priv->noise;
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+
+	return 0;
+}
+
+static int mwl_mac80211_ampdu_action(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     enum ieee80211_ampdu_mlme_action action,
+				     struct ieee80211_sta *sta,
+				     u16 tid, u16 *ssn, u8 buf_size)
+{
+	int i, rc = 0;
+	struct mwl_priv *priv = hw->priv;
+	struct mwl_ampdu_stream *stream;
+	u8 *addr = sta->addr, idx;
+	struct mwl_sta *sta_info = MWL_STA(sta);
+
+	WLDBG_ENTER(DBG_LEVEL_5);
+
+	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
+		WLDBG_EXIT_INFO(DBG_LEVEL_5, "no HW AMPDU");
+		return -ENOTSUPP;
+	}
+
+	SPIN_LOCK(&priv->locks.stream_lock);
+
+	stream = mwl_fwcmd_lookup_stream(hw, addr, tid);
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		/* By the time we get here the hw queues may contain outgoing
+		 * packets for this RA/TID that are not part of this BA
+		 * session.  The hw will assign sequence numbers to these
+		 * packets as they go out.  So if we query the hw for its next
+		 * sequence number and use that for the SSN here, it may end up
+		 * being wrong, which will lead to sequence number mismatch at
+		 * the recipient.  To avoid this, we reset the sequence number
+		 * to O for the first MPDU in this BA stream.
+		 */
+		*ssn = 0;
+
+		if (!stream) {
+			/* This means that somebody outside this driver called
+			 * ieee80211_start_tx_ba_session.  This is unexpected
+			 * because we do our own rate control.  Just warn and
+			 * move on.
+			 */
+			stream = mwl_fwcmd_add_stream(hw, sta, tid);
+		}
+
+		if (!stream) {
+			WLDBG_EXIT_INFO(DBG_LEVEL_5, "no stream found");
+			rc = -EBUSY;
+			break;
+		}
+
+		stream->state = AMPDU_STREAM_IN_PROGRESS;
+
+		/* Release the lock before we do the time consuming stuff
+		*/
+		SPIN_UNLOCK(&priv->locks.stream_lock);
+
+		for (i = 0; i < MAX_AMPDU_ATTEMPTS; i++) {
+			/* Check if link is still valid
+			*/
+			if (!sta_info->is_ampdu_allowed) {
+				SPIN_LOCK(&priv->locks.stream_lock);
+				mwl_fwcmd_remove_stream(hw, stream);
+				SPIN_UNLOCK(&priv->locks.stream_lock);
+				WLDBG_EXIT_INFO(DBG_LEVEL_5,
+						"link is no valid now");
+				return -EBUSY;
+			}
+
+			rc = mwl_fwcmd_check_ba(hw, stream, vif);
+
+			if (!rc)
+				break;
+
+			WL_MSEC_SLEEP(1000);
+		}
+
+		SPIN_LOCK(&priv->locks.stream_lock);
+
+		if (rc) {
+			mwl_fwcmd_remove_stream(hw, stream);
+			WLDBG_EXIT_INFO(DBG_LEVEL_5, "error code: %d", rc);
+			rc = -EBUSY;
+			break;
+		}
+
+		ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		if (stream) {
+			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				idx = stream->idx;
+				SPIN_UNLOCK(&priv->locks.stream_lock);
+				mwl_fwcmd_destroy_ba(hw, idx);
+				SPIN_LOCK(&priv->locks.stream_lock);
+			}
+
+			mwl_fwcmd_remove_stream(hw, stream);
+		}
+
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		BUG_ON(!stream);
+		BUG_ON(stream->state != AMPDU_STREAM_IN_PROGRESS);
+		SPIN_UNLOCK(&priv->locks.stream_lock);
+		rc = mwl_fwcmd_create_ba(hw, stream, buf_size, vif);
+		SPIN_LOCK(&priv->locks.stream_lock);
+
+		if (!rc) {
+			stream->state = AMPDU_STREAM_ACTIVE;
+		} else {
+			idx = stream->idx;
+			SPIN_UNLOCK(&priv->locks.stream_lock);
+			mwl_fwcmd_destroy_ba(hw, idx);
+			SPIN_LOCK(&priv->locks.stream_lock);
+			mwl_fwcmd_remove_stream(hw, stream);
+		}
+		break;
+	default:
+		rc = -ENOTSUPP;
+	}
+
+	SPIN_UNLOCK(&priv->locks.stream_lock);
+
+	WLDBG_EXIT(DBG_LEVEL_5);
+
+	return rc;
+}
+
+static void mwl_mac80211_remove_vif(struct mwl_priv *priv, struct mwl_vif *vif)
+{
+	if (!priv->macids_used)
+		return;
+
+	priv->macids_used &= ~(1 << vif->macid);
+	list_del(&vif->list);
+}
+
+static void mwl_mac80211_bss_info_changed_sta(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif,
+					      struct ieee80211_bss_conf *info,
+					      u32 changed)
+{
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		mwl_fwcmd_set_radio_preamble(hw,
+					     vif->bss_conf.use_short_preamble);
+	}
+
+	if ((changed & BSS_CHANGED_ASSOC) && vif->bss_conf.assoc) {
+		mwl_fwcmd_set_aid(hw, vif, (u8 *)vif->bss_conf.bssid,
+				  vif->bss_conf.aid);
+	}
+}
+
+static void mwl_mac80211_bss_info_changed_ap(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_bss_conf *info,
+					     u32 changed)
+{
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		mwl_fwcmd_set_radio_preamble(hw,
+					     vif->bss_conf.use_short_preamble);
+	}
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		int idx;
+		int rate;
+
+		/* Use lowest supported basic rate for multicasts
+		 * and management frames (such as probe responses --
+		 * beacons will always go out at 1 Mb/s).
+		 */
+		idx = ffs(vif->bss_conf.basic_rates);
+		if (idx)
+			idx--;
+
+		if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
+			rate = mwl_rates_24[idx].hw_value;
+		else
+			rate = mwl_rates_50[idx].hw_value;
+
+		mwl_fwcmd_use_fixed_rate(hw, rate, rate);
+	}
+
+	if (changed & (BSS_CHANGED_BEACON_INT | BSS_CHANGED_BEACON)) {
+		struct sk_buff *skb;
+
+		skb = ieee80211_beacon_get(hw, vif);
+
+		if (skb) {
+			mwl_fwcmd_set_beacon(hw, vif, skb->data, skb->len);
+			dev_kfree_skb_any(skb);
+		}
+
+		if ((info->ssid[0] != '\0') &&
+		    (info->ssid_len != 0) &&
+		    (!info->hidden_ssid))
+			mwl_fwcmd_broadcast_ssid_enable(hw, vif, true);
+		else
+			mwl_fwcmd_broadcast_ssid_enable(hw, vif, false);
+	}
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		mwl_fwcmd_bss_start(hw, vif, info->enable_beacon);
+}
diff --git a/drivers/net/wireless/mwlwifi/mwl_mac80211.h b/drivers/net/wireless/mwlwifi/mwl_mac80211.h
new file mode 100644
index 0000000..71fc4f8
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_mac80211.h
@@ -0,0 +1,32 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines mac80211 related functions.
+*/
+
+#ifndef _mwl_mac80211_h_
+#define _mwl_mac80211_h_
+
+#include <linux/interrupt.h>
+#include <net/mac80211.h>
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+
+struct ieee80211_ops *mwl_mac80211_get_ops(void);
+void mwl_mac80211_set_isr(irqreturn_t (*isr)(int irq, void *dev_id));
+
+#endif /* _mwl_mac80211_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_main.c b/drivers/net/wireless/mwlwifi/mwl_main.c
new file mode 100644
index 0000000..84a125b
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_main.c
@@ -0,0 +1,1095 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements main functions of this module.
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_fwdl.h"
+#include "mwl_fwcmd.h"
+#include "mwl_tx.h"
+#include "mwl_rx.h"
+#include "mwl_mac80211.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define MWL_DESC         "Marvell 802.11ac Wireless Network Driver"
+#define MWL_DEV_NAME     "Marvell 88W8864 802.11ac Adapter"
+#define MWL_DRV_NAME     KBUILD_MODNAME
+#define MWL_DRV_VERSION	 "10.3.0.2"
+
+#define FILE_PATH_LEN    64
+#define CMD_BUF_SIZE     0x4000
+
+#define INVALID_WATCHDOG 0xAA
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static int mwl_probe(struct pci_dev *pdev, const struct pci_device_id *id);
+static void mwl_remove(struct pci_dev *pdev);
+static int mwl_alloc_pci_resource(struct mwl_priv *priv);
+static void mwl_free_pci_resource(struct mwl_priv *priv);
+static int mwl_init_firmware(struct mwl_priv *priv, char *fw_image);
+static void mwl_reg_notifier(struct wiphy *wiphy,
+			     struct regulatory_request *request);
+static int mwl_process_of_dts(struct mwl_priv *priv);
+static void mwl_set_ht_caps(struct mwl_priv *priv,
+			    struct ieee80211_supported_band *band);
+static void mwl_set_vht_caps(struct mwl_priv *priv,
+			     struct ieee80211_supported_band *band);
+static void mwl_set_caps(struct mwl_priv *priv);
+static int mwl_wl_init(struct mwl_priv *priv);
+static void mwl_wl_deinit(struct mwl_priv *priv);
+static void mwl_watchdog_ba_events(struct work_struct *work);
+static irqreturn_t mwl_interrupt(int irq, void *dev_id);
+
+/* PRIVATE VARIABLES
+*/
+
+static struct pci_device_id mwl_pci_id_tbl[] = {
+	{ PCI_VDEVICE(MARVELL, 0x2a55), .driver_data = MWL8864, },
+	{ PCI_VDEVICE(MARVELL, 0x2b38), .driver_data = MWL8897, },
+	{ },
+};
+
+static struct pci_driver mwl_pci_driver = {
+	.name     = MWL_DRV_NAME,
+	.id_table = mwl_pci_id_tbl,
+	.probe    = mwl_probe,
+	.remove   = mwl_remove
+};
+
+static struct mwl_chip_info mwl_chip_tbl[] = {
+	[MWL8864] = {
+		.part_name	= "88W8864",
+		.fw_image	= "mwlwifi/88W8864.bin",
+	},
+	[MWL8897] = {
+		.part_name	= "88W8897",
+		.fw_image	= "mwlwifi/88W8897.bin",
+	},
+};
+
+static const struct ieee80211_channel mwl_channels_24[] = {
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2412, .hw_value = 1, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2417, .hw_value = 2, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2422, .hw_value = 3, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2427, .hw_value = 4, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2432, .hw_value = 5, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2437, .hw_value = 6, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2442, .hw_value = 7, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2447, .hw_value = 8, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2452, .hw_value = 9, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2457, .hw_value = 10, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2462, .hw_value = 11, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2467, .hw_value = 12, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2472, .hw_value = 13, },
+	{ .band = IEEE80211_BAND_2GHZ, .center_freq = 2484, .hw_value = 14, },
+};
+
+static const struct ieee80211_rate mwl_rates_24[] = {
+	{ .bitrate = 10, .hw_value = 2, },
+	{ .bitrate = 20, .hw_value = 4, },
+	{ .bitrate = 55, .hw_value = 11, },
+	{ .bitrate = 110, .hw_value = 22, },
+	{ .bitrate = 220, .hw_value = 44, },
+	{ .bitrate = 60, .hw_value = 12, },
+	{ .bitrate = 90, .hw_value = 18, },
+	{ .bitrate = 120, .hw_value = 24, },
+	{ .bitrate = 180, .hw_value = 36, },
+	{ .bitrate = 240, .hw_value = 48, },
+	{ .bitrate = 360, .hw_value = 72, },
+	{ .bitrate = 480, .hw_value = 96, },
+	{ .bitrate = 540, .hw_value = 108, },
+};
+
+static const struct ieee80211_channel mwl_channels_50[] = {
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5180, .hw_value = 36, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5200, .hw_value = 40, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5220, .hw_value = 44, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5240, .hw_value = 48, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5260, .hw_value = 52, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5280, .hw_value = 56, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5300, .hw_value = 60, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5320, .hw_value = 64, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5500, .hw_value = 100, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5520, .hw_value = 104, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5540, .hw_value = 108, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5560, .hw_value = 112, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5580, .hw_value = 116, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5600, .hw_value = 120, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5620, .hw_value = 124, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5640, .hw_value = 128, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5660, .hw_value = 132, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5680, .hw_value = 136, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5700, .hw_value = 140, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5720, .hw_value = 144, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5745, .hw_value = 149, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5765, .hw_value = 153, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5785, .hw_value = 157, },
+	{ .band = IEEE80211_BAND_5GHZ, .center_freq = 5805, .hw_value = 161, },
+};
+
+static const struct ieee80211_rate mwl_rates_50[] = {
+	{ .bitrate = 60, .hw_value = 12, },
+	{ .bitrate = 90, .hw_value = 18, },
+	{ .bitrate = 120, .hw_value = 24, },
+	{ .bitrate = 180, .hw_value = 36, },
+	{ .bitrate = 240, .hw_value = 48, },
+	{ .bitrate = 360, .hw_value = 72, },
+	{ .bitrate = 480, .hw_value = 96, },
+	{ .bitrate = 540, .hw_value = 108, },
+};
+
+static const struct ieee80211_iface_limit ap_if_limits[] = {
+	{ .max = SYSADPT_NUM_OF_AP,	.types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_STATION) },
+};
+
+static const struct ieee80211_iface_combination ap_if_comb = {
+	.limits = ap_if_limits,
+	.n_limits = ARRAY_SIZE(ap_if_limits),
+	.max_interfaces = SYSADPT_NUM_OF_AP,
+	.num_different_channels = 1,
+};
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static int mwl_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	static bool printed_version;
+	struct ieee80211_hw *hw;
+	struct mwl_priv *priv;
+	int rc = 0;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	if (id->driver_data >= MWLUNKNOWN)
+		return -ENODEV;
+
+	if (!printed_version) {
+		WLDBG_PRINT("<<%s version %s>>", MWL_DESC, MWL_DRV_VERSION);
+		printed_version = true;
+	}
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		WLDBG_PRINT("%s: cannot enable new PCI device",
+			    MWL_DRV_NAME);
+		WLDBG_EXIT_INFO(DBG_LEVEL_0, "init error");
+		return rc;
+	}
+
+	rc = pci_set_dma_mask(pdev, 0xffffffff);
+	if (rc) {
+		WLDBG_PRINT("%s: 32-bit PCI DMA not supported",
+			    MWL_DRV_NAME);
+		goto err_pci_disable_device;
+	}
+
+	pci_set_master(pdev);
+
+	hw = ieee80211_alloc_hw(sizeof(*priv), mwl_mac80211_get_ops());
+	if (!hw) {
+		WLDBG_PRINT("%s: ieee80211 alloc failed",
+			    MWL_DRV_NAME);
+		rc = -ENOMEM;
+		goto err_pci_disable_device;
+	}
+
+	/* hook regulatory domain change notification
+	*/
+	hw->wiphy->reg_notifier = mwl_reg_notifier;
+
+	/* set interrupt service routine to mac80211 module
+	*/
+	mwl_mac80211_set_isr(mwl_interrupt);
+
+	SET_IEEE80211_DEV(hw, &pdev->dev);
+	pci_set_drvdata(pdev, hw);
+
+	priv = hw->priv;
+	priv->hw = hw;
+	priv->pdev = pdev;
+	priv->chip_type = id->driver_data;
+
+	rc = mwl_alloc_pci_resource(priv);
+	if (rc)
+		goto err_alloc_pci_resource;
+
+	rc = mwl_init_firmware(priv, mwl_chip_tbl[priv->chip_type].fw_image);
+	if (rc) {
+		WLDBG_PRINT("%s: fail to initialize firmware",
+			    MWL_DRV_NAME);
+		goto err_init_firmware;
+	}
+
+	/* firmware is loaded to H/W, it can be released now
+	*/
+	release_firmware(priv->fw_ucode);
+
+	rc = mwl_process_of_dts(priv);
+	if (rc) {
+		WLDBG_PRINT("%s: fail to load dts mwlwifi parameters",
+			    MWL_DRV_NAME);
+		goto err_process_of_dts;
+	}
+
+	rc = mwl_wl_init(priv);
+	if (rc) {
+		WLDBG_PRINT("%s: fail to initialize wireless lan",
+			    MWL_DRV_NAME);
+		goto err_wl_init;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+
+	return rc;
+
+err_wl_init:
+err_process_of_dts:
+err_init_firmware:
+
+	mwl_fwcmd_reset(hw);
+
+err_alloc_pci_resource:
+
+	pci_set_drvdata(pdev, NULL);
+	ieee80211_free_hw(hw);
+
+err_pci_disable_device:
+
+	pci_disable_device(pdev);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_0, "init error");
+
+	return rc;
+}
+
+static void mwl_remove(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	if (!hw) {
+		WLDBG_EXIT_INFO(DBG_LEVEL_0, "ieee80211 hw is null");
+		return;
+	}
+
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	mwl_wl_deinit(priv);
+	mwl_free_pci_resource(priv);
+	pci_set_drvdata(pdev, NULL);
+	ieee80211_free_hw(hw);
+	pci_disable_device(pdev);
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static int mwl_alloc_pci_resource(struct mwl_priv *priv)
+{
+	struct pci_dev *pdev;
+	u32 phys_addr = 0;
+	u32 flags;
+	void *phys_addr1[2];
+	void *phys_addr2[2];
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	pdev = priv->pdev;
+	BUG_ON(!pdev);
+
+	phys_addr = pci_resource_start(pdev, 0);
+	flags = pci_resource_flags(pdev, 0);
+
+	priv->next_bar_num = 1;	/* 32-bit */
+
+	if (flags & 0x04)
+		priv->next_bar_num = 2;	/* 64-bit */
+
+	if (!request_mem_region(phys_addr, pci_resource_len(pdev, 0),
+				MWL_DRV_NAME)) {
+		WLDBG_ERROR(DBG_LEVEL_0,
+			    "%s: cannot reserve PCI memory region 0",
+			    MWL_DRV_NAME);
+		goto err_reserve_mem_region_bar0;
+	}
+
+	phys_addr1[0] = ioremap(phys_addr, pci_resource_len(pdev, 0));
+	phys_addr1[1] = 0;
+
+	priv->iobase0 = phys_addr1[0];
+	if (!priv->iobase0) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: cannot remap PCI memory region 0",
+			    MWL_DRV_NAME);
+		goto err_release_mem_region_bar0;
+	}
+
+	WLDBG_PRINT("priv->iobase0 = %x", (unsigned int)priv->iobase0);
+
+	phys_addr = pci_resource_start(pdev, priv->next_bar_num);
+
+	if (!request_mem_region(phys_addr,
+				pci_resource_len(pdev, priv->next_bar_num),
+				MWL_DRV_NAME)) {
+		WLDBG_ERROR(DBG_LEVEL_0,
+			    "%s: cannot reserve PCI memory region 1",
+			    MWL_DRV_NAME);
+		goto err_iounmap_iobase0;
+	}
+
+	phys_addr2[0] = ioremap(phys_addr,
+				pci_resource_len(pdev, priv->next_bar_num));
+	phys_addr2[1] = 0;
+	priv->iobase1 = phys_addr2[0];
+
+	if (!priv->iobase1) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: cannot remap PCI memory region 1",
+			    MWL_DRV_NAME);
+		goto err_release_mem_region_bar1;
+	}
+
+	WLDBG_PRINT("priv->iobase1 = %x", (unsigned int)priv->iobase1);
+
+	priv->pcmd_buf =
+		(unsigned short *)dma_alloc_coherent(&priv->pdev->dev,
+						     CMD_BUF_SIZE,
+						     &priv->pphys_cmd_buf,
+						     GFP_KERNEL);
+
+	if (!priv->pcmd_buf) {
+		WLDBG_ERROR(DBG_LEVEL_0,
+			    "%s: cannot alloc memory for command buffer",
+			    MWL_DRV_NAME);
+		goto err_iounmap_iobase1;
+	}
+
+	WLDBG_PRINT("priv->pcmd_buf = %x  priv->pphys_cmd_buf = %x",
+		    (unsigned int)priv->pcmd_buf,
+		    (unsigned int)priv->pphys_cmd_buf);
+
+	memset(priv->pcmd_buf, 0x00, CMD_BUF_SIZE);
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+
+	return 0;
+
+err_iounmap_iobase1:
+
+	iounmap(priv->iobase1);
+
+err_release_mem_region_bar1:
+
+	release_mem_region(pci_resource_start(pdev, 1),
+			   pci_resource_len(pdev, 1));
+
+err_iounmap_iobase0:
+
+	iounmap(priv->iobase0);
+
+err_release_mem_region_bar0:
+
+	release_mem_region(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
+
+err_reserve_mem_region_bar0:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_0, "pci alloc fail");
+
+	return -EIO;
+}
+
+static void mwl_free_pci_resource(struct mwl_priv *priv)
+{
+	struct pci_dev *pdev;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	pdev = priv->pdev;
+	BUG_ON(!pdev);
+
+	iounmap(priv->iobase0);
+	iounmap(priv->iobase1);
+	release_mem_region(pci_resource_start(pdev, priv->next_bar_num),
+			   pci_resource_len(pdev, priv->next_bar_num));
+	release_mem_region(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
+	dma_free_coherent(&priv->pdev->dev, CMD_BUF_SIZE,
+			  priv->pcmd_buf, priv->pphys_cmd_buf);
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static int mwl_init_firmware(struct mwl_priv *priv, char *fw_name)
+{
+	struct pci_dev *pdev;
+	int rc = 0;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	pdev = priv->pdev;
+	BUG_ON(!pdev);
+
+	rc = request_firmware(&priv->fw_ucode, fw_name, &priv->pdev->dev);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: cannot load firmware image <%s>",
+			    MWL_DRV_NAME, fw_name);
+		goto err_load_fw;
+	}
+
+	rc = mwl_fwdl_download_firmware(priv->hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0,
+			    "%s: cannot download firmware image <%s>",
+			    MWL_DRV_NAME, fw_name);
+		goto err_download_fw;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+
+	return rc;
+
+err_download_fw:
+
+	release_firmware(priv->fw_ucode);
+
+err_load_fw:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_0, "firmware init fail");
+
+	return rc;
+}
+
+static void mwl_reg_notifier(struct wiphy *wiphy,
+			     struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw;
+	struct mwl_priv *priv;
+	struct property *prop;
+	struct property *fcc_prop = NULL;
+	struct property *etsi_prop = NULL;
+	struct property *specific_prop = NULL;
+	u32 prop_value;
+	int i, j, k;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!wiphy);
+	hw = (struct ieee80211_hw *)wiphy_priv(wiphy);
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	if (priv->pwr_node) {
+		for_each_property_of_node(priv->pwr_node, prop) {
+			if (strcmp(prop->name, "FCC") == 0)
+				fcc_prop = prop;
+			if (strcmp(prop->name, "ETSI") == 0)
+				etsi_prop = prop;
+			if ((prop->name[0] == request->alpha2[0]) &&
+			    (prop->name[1] == request->alpha2[1]))
+				specific_prop = prop;
+		}
+
+		prop = NULL;
+
+		if (specific_prop) {
+			prop = specific_prop;
+		} else {
+			if (request->dfs_region == NL80211_DFS_ETSI)
+				prop = etsi_prop;
+			else
+				prop = fcc_prop;
+		}
+
+		if (prop) {
+			/* Reset the whole table
+			*/
+			for (i = 0; i < SYSADPT_MAX_NUM_CHANNELS; i++)
+				memset(&priv->tx_pwr_tbl[i], 0,
+				       sizeof(struct mwl_tx_pwr_tbl));
+
+			/* Load related power table
+			*/
+			i = 0;
+			j = 0;
+			while (i < prop->length) {
+				prop_value =
+					be32_to_cpu(*(u32 *)(prop->value + i));
+				priv->tx_pwr_tbl[j].channel = prop_value;
+				i += 4;
+				prop_value =
+					be32_to_cpu(*(u32 *)(prop->value + i));
+				priv->tx_pwr_tbl[j].setcap = prop_value;
+				i += 4;
+				for (k = 0; k < SYSADPT_TX_POWER_LEVEL_TOTAL;
+				     k++) {
+					prop_value =
+						be32_to_cpu(*(u32 *)
+							    (prop->value + i));
+					priv->tx_pwr_tbl[j].tx_power[k] =
+						prop_value;
+					i += 4;
+				}
+				prop_value =
+					be32_to_cpu(*(u32 *)(prop->value + i));
+				priv->tx_pwr_tbl[j].cdd = prop_value;
+				i += 4;
+				prop_value =
+					be32_to_cpu(*(u32 *)(prop->value + i));
+				priv->tx_pwr_tbl[j].txantenna2 = prop_value;
+				i += 4;
+				j++;
+			}
+
+			/* Dump loaded power tabel
+			*/
+			WLDBG_PRINT("%s: %s\n", dev_name(&wiphy->dev),
+				    prop->name);
+			for (i = 0; i < SYSADPT_MAX_NUM_CHANNELS; i++) {
+				struct mwl_tx_pwr_tbl *pwr_tbl;
+				char disp_buf[64];
+				char *disp_ptr;
+
+				pwr_tbl = &priv->tx_pwr_tbl[i];
+				if (pwr_tbl->channel == 0)
+					break;
+				WLDBG_PRINT("Channel: %d: 0x%x 0x%x 0x%x",
+					    pwr_tbl->channel,
+					    pwr_tbl->setcap,
+					    pwr_tbl->cdd,
+					    pwr_tbl->txantenna2);
+				disp_ptr = disp_buf;
+				for (j = 0; j < SYSADPT_TX_POWER_LEVEL_TOTAL;
+				     j++) {
+					disp_ptr +=
+						sprintf(disp_ptr, "%x ",
+							pwr_tbl->tx_power[j]);
+				}
+				WLDBG_PRINT("%s", disp_buf);
+			}
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static int mwl_process_of_dts(struct mwl_priv *priv)
+{
+	struct property *prop;
+	u32 prop_value;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+
+	priv->disable_2g = false;
+	priv->disable_5g = false;
+	priv->antenna_tx = ANTENNA_TX_4_AUTO;
+	priv->antenna_rx = ANTENNA_RX_4_AUTO;
+
+	priv->dt_node =
+		of_find_node_by_name(pci_bus_to_OF_node(priv->pdev->bus),
+				     "mwlwifi");
+	if (!priv->dt_node)
+		return -EPERM;
+
+	/* look for all matching property names
+	*/
+	for_each_property_of_node(priv->dt_node, prop) {
+		if (strcmp(prop->name, "marvell,2ghz") == 0)
+			priv->disable_2g = true;
+		if (strcmp(prop->name, "marvell,5ghz") == 0)
+			priv->disable_5g = true;
+		if (strcmp(prop->name, "marvell,chainmask") == 0) {
+			prop_value = be32_to_cpu(*((u32 *)prop->value));
+			if (prop_value == 2)
+				priv->antenna_tx = ANTENNA_TX_2;
+
+			prop_value = be32_to_cpu(*((u32 *)(prop->value + 4)));
+			if (prop_value == 2)
+				priv->antenna_rx = ANTENNA_RX_2;
+		}
+	}
+
+	priv->pwr_node = of_find_node_by_name(priv->dt_node,
+					      "marvell,powertable");
+
+	WLDBG_PRINT("2G: %s\n", priv->disable_2g ? "disable" : "enable");
+	WLDBG_PRINT("5G: %s\n", priv->disable_5g ? "disable" : "enable");
+
+	if (priv->antenna_tx == ANTENNA_TX_4_AUTO)
+		WLDBG_PRINT("TX: 4 antennas\n");
+	else if (priv->antenna_tx == ANTENNA_TX_2)
+		WLDBG_PRINT("TX: 2 antennas\n");
+	else
+		WLDBG_PRINT("TX: unknown\n");
+	if (priv->antenna_rx == ANTENNA_RX_4_AUTO)
+		WLDBG_PRINT("RX: 4 antennas\n");
+	else if (priv->antenna_rx == ANTENNA_RX_2)
+		WLDBG_PRINT("RX: 2 antennas\n");
+	else
+		WLDBG_PRINT("RX: unknown\n");
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+
+	return 0;
+}
+
+static void mwl_set_ht_caps(struct mwl_priv *priv,
+			    struct ieee80211_supported_band *band)
+{
+	struct ieee80211_hw *hw;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	hw = priv->hw;
+	BUG_ON(!hw);
+
+	band->ht_cap.ht_supported = 1;
+
+	band->ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	band->ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	band->ht_cap.cap |= IEEE80211_HT_CAP_SM_PS;
+	band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+	band->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
+
+	hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+	band->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	band->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_4;
+
+	band->ht_cap.mcs.rx_mask[0] = 0xff;
+	band->ht_cap.mcs.rx_mask[1] = 0xff;
+	if (priv->antenna_rx == ANTENNA_RX_4_AUTO)
+		band->ht_cap.mcs.rx_mask[2] = 0xff;
+	band->ht_cap.mcs.rx_mask[4] = 0x01;
+
+	band->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static void mwl_set_vht_caps(struct mwl_priv *priv,
+			     struct ieee80211_supported_band *band)
+{
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	band->vht_cap.vht_supported = 1;
+
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_RXLDPC;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_SHORT_GI_80;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_RXSTBC_1;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN;
+	band->vht_cap.cap |= IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
+
+	if (priv->antenna_rx == ANTENNA_RX_2)
+		band->vht_cap.vht_mcs.rx_mcs_map = 0xfffa;
+	else
+		band->vht_cap.vht_mcs.rx_mcs_map = 0xffea;
+
+	if (priv->antenna_tx == ANTENNA_TX_2)
+		band->vht_cap.vht_mcs.tx_mcs_map = 0xfffa;
+	else
+		band->vht_cap.vht_mcs.tx_mcs_map = 0xffea;
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static void mwl_set_caps(struct mwl_priv *priv)
+{
+	struct ieee80211_hw *hw;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	hw = priv->hw;
+	BUG_ON(!hw);
+
+	/* set up band information for 2.4G
+	*/
+	if (!priv->disable_2g) {
+		BUILD_BUG_ON(sizeof(priv->channels_24) !=
+			     sizeof(mwl_channels_24));
+		memcpy(priv->channels_24, mwl_channels_24,
+		       sizeof(mwl_channels_24));
+
+		BUILD_BUG_ON(sizeof(priv->rates_24) != sizeof(mwl_rates_24));
+		memcpy(priv->rates_24, mwl_rates_24, sizeof(mwl_rates_24));
+
+		priv->band_24.band = IEEE80211_BAND_2GHZ;
+		priv->band_24.channels = priv->channels_24;
+		priv->band_24.n_channels = ARRAY_SIZE(mwl_channels_24);
+		priv->band_24.bitrates = priv->rates_24;
+		priv->band_24.n_bitrates = ARRAY_SIZE(mwl_rates_24);
+
+		mwl_set_ht_caps(priv, &priv->band_24);
+		mwl_set_vht_caps(priv, &priv->band_24);
+
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band_24;
+	}
+
+	/* set up band information for 5G
+	*/
+	if (!priv->disable_5g) {
+		BUILD_BUG_ON(sizeof(priv->channels_50) !=
+			     sizeof(mwl_channels_50));
+		memcpy(priv->channels_50, mwl_channels_50,
+		       sizeof(mwl_channels_50));
+
+		BUILD_BUG_ON(sizeof(priv->rates_50) != sizeof(mwl_rates_50));
+		memcpy(priv->rates_50, mwl_rates_50, sizeof(mwl_rates_50));
+
+		priv->band_50.band = IEEE80211_BAND_5GHZ;
+		priv->band_50.channels = priv->channels_50;
+		priv->band_50.n_channels = ARRAY_SIZE(mwl_channels_50);
+		priv->band_50.bitrates = priv->rates_50;
+		priv->band_50.n_bitrates = ARRAY_SIZE(mwl_rates_50);
+
+		mwl_set_ht_caps(priv, &priv->band_50);
+		mwl_set_vht_caps(priv, &priv->band_50);
+
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->band_50;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static int mwl_wl_init(struct mwl_priv *priv)
+{
+	struct ieee80211_hw *hw;
+	int rc;
+	int i;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	hw = priv->hw;
+	BUG_ON(!hw);
+
+	/* Extra headroom is the size of the required DMA header
+	 * minus the size of the smallest 802.11 frame (CTS frame).
+	 */
+	hw->extra_tx_headroom =
+		sizeof(struct mwl_dma_data) - sizeof(struct ieee80211_cts);
+	hw->queues = SYSADPT_TX_WMM_QUEUES;
+
+	/* Set rssi values to dBm
+	*/
+	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
+
+	/* Ask mac80211 to not to trigger PS mode
+	 * based on PM bit of incoming frames.
+	 */
+	hw->flags |= IEEE80211_HW_AP_LINK_PS;
+
+	hw->vif_data_size = sizeof(struct mwl_vif);
+	hw->sta_data_size = sizeof(struct mwl_sta);
+
+	priv->ap_macids_supported = 0x0000ffff;
+	priv->sta_macids_supported = 0x00010000;
+	priv->macids_used = 0;
+	INIT_LIST_HEAD(&priv->vif_list);
+
+	/* Set default radio state, preamble and wmm
+	*/
+	priv->radio_on = false;
+	priv->radio_short_preamble = false;
+	priv->wmm_enabled = false;
+
+	priv->powinited = 0;
+
+	/* Handle watchdog ba events
+	*/
+	INIT_WORK(&priv->watchdog_ba_handle, mwl_watchdog_ba_events);
+
+	tasklet_init(&priv->tx_task, (void *)mwl_tx_done, (unsigned long)hw);
+	tasklet_disable(&priv->tx_task);
+	tasklet_init(&priv->rx_task, (void *)mwl_rx_recv, (unsigned long)hw);
+	tasklet_disable(&priv->rx_task);
+	priv->txq_limit = SYSADPT_TX_QUEUE_LIMIT;
+	priv->is_tx_schedule = false;
+	priv->recv_limit = SYSADPT_RECEIVE_LIMIT;
+	priv->is_rx_schedule = false;
+
+	SPIN_LOCK_INIT(&priv->locks.xmit_lock);
+	SPIN_LOCK_INIT(&priv->locks.fwcmd_lock);
+	SPIN_LOCK_INIT(&priv->locks.stream_lock);
+
+	rc = mwl_tx_init(hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: fail to initialize TX",
+			    MWL_DRV_NAME);
+		goto err_mwl_tx_init;
+	}
+
+	rc = mwl_rx_init(hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: fail to initialize RX",
+			    MWL_DRV_NAME);
+		goto err_mwl_rx_init;
+	}
+
+	rc = mwl_fwcmd_get_hw_specs(hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: fail to get HW specifications",
+			    MWL_DRV_NAME);
+		goto err_get_hw_specs;
+	}
+
+	SET_IEEE80211_PERM_ADDR(hw, priv->hw_data.mac_addr);
+
+	writel(priv->desc_data[0].pphys_tx_ring,
+	       priv->iobase0 + priv->desc_data[0].wcb_base);
+#if SYSADPT_NUM_OF_DESC_DATA > 3
+	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
+		writel(priv->desc_data[i].pphys_tx_ring,
+		       priv->iobase0 + priv->desc_data[i].wcb_base);
+#endif
+	writel(priv->desc_data[0].pphys_rx_ring,
+	       priv->iobase0 + priv->desc_data[0].rx_desc_read);
+	writel(priv->desc_data[0].pphys_rx_ring,
+	       priv->iobase0 + priv->desc_data[0].rx_desc_write);
+
+	rc = mwl_fwcmd_set_hw_specs(hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: fail to set HW specifications",
+			    MWL_DRV_NAME);
+		goto err_set_hw_specs;
+	}
+
+	WLDBG_PRINT("firmware version: 0x%x", priv->hw_data.fw_release_num);
+
+	mwl_fwcmd_radio_disable(hw);
+
+	mwl_fwcmd_rf_antenna(hw, WL_ANTENNATYPE_TX, priv->antenna_tx);
+
+	mwl_fwcmd_rf_antenna(hw, WL_ANTENNATYPE_RX, priv->antenna_rx);
+
+	hw->wiphy->interface_modes = 0;
+	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP);
+	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
+	hw->wiphy->iface_combinations = &ap_if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
+	mwl_set_caps(priv);
+
+	rc = ieee80211_register_hw(hw);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_0, "%s: fail to register device",
+			    MWL_DRV_NAME);
+		goto err_register_hw;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+
+	return rc;
+
+err_register_hw:
+err_set_hw_specs:
+err_get_hw_specs:
+
+	mwl_rx_deinit(hw);
+
+err_mwl_rx_init:
+
+	mwl_tx_deinit(hw);
+
+err_mwl_tx_init:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_0, "init fail");
+
+	return rc;
+}
+
+static void mwl_wl_deinit(struct mwl_priv *priv)
+{
+	struct ieee80211_hw *hw;
+
+	WLDBG_ENTER(DBG_LEVEL_0);
+
+	BUG_ON(!priv);
+	hw = priv->hw;
+	BUG_ON(!hw);
+
+	ieee80211_unregister_hw(hw);
+	mwl_rx_deinit(hw);
+	mwl_tx_deinit(hw);
+	tasklet_kill(&priv->rx_task);
+	tasklet_kill(&priv->tx_task);
+	mwl_fwcmd_reset(hw);
+
+	WLDBG_EXIT(DBG_LEVEL_0);
+}
+
+static void mwl_watchdog_ba_events(struct work_struct *work)
+{
+	int rc;
+	u8 bitmap = 0, stream_index;
+	struct mwl_ampdu_stream *streams;
+	struct mwl_priv *priv =
+		container_of(work, struct mwl_priv, watchdog_ba_handle);
+	struct ieee80211_hw *hw = priv->hw;
+	u32 status;
+
+	rc = mwl_fwcmd_get_watchdog_bitmap(priv->hw, &bitmap);
+
+	if (rc)
+		goto done;
+
+	SPIN_LOCK(&priv->locks.stream_lock);
+
+	/* the bitmap is the hw queue number.  Map it to the ampdu queue.
+	*/
+	if (bitmap != INVALID_WATCHDOG) {
+		if (bitmap == SYSADPT_TX_AMPDU_QUEUES)
+			stream_index = 0;
+		else if (bitmap > SYSADPT_TX_AMPDU_QUEUES)
+			stream_index = bitmap - SYSADPT_TX_AMPDU_QUEUES;
+		else
+			stream_index = bitmap + 3; /** queue 0 is stream 3*/
+
+		if (bitmap != 0xFF) {
+			/* Check if the stream is in use before disabling it
+			*/
+			streams = &priv->ampdu[stream_index];
+
+			if (streams->state == AMPDU_STREAM_ACTIVE) {
+				ieee80211_stop_tx_ba_session(streams->sta,
+							     streams->tid);
+				SPIN_UNLOCK(&priv->locks.stream_lock);
+				mwl_fwcmd_destroy_ba(hw, stream_index);
+				SPIN_LOCK(&priv->locks.stream_lock);
+			}
+		} else {
+			for (stream_index = 0;
+			     stream_index < SYSADPT_TX_AMPDU_QUEUES;
+			     stream_index++) {
+				streams = &priv->ampdu[stream_index];
+
+				if (streams->state != AMPDU_STREAM_ACTIVE)
+					continue;
+
+				ieee80211_stop_tx_ba_session(streams->sta,
+							     streams->tid);
+				SPIN_UNLOCK(&priv->locks.stream_lock);
+				mwl_fwcmd_destroy_ba(hw, stream_index);
+				SPIN_LOCK(&priv->locks.stream_lock);
+			}
+		}
+	}
+
+	SPIN_UNLOCK(&priv->locks.stream_lock);
+
+done:
+
+	status = readl(priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+	writel(status | MACREG_A2HRIC_BA_WATCHDOG,
+	       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+}
+
+static irqreturn_t mwl_interrupt(int irq, void *dev_id)
+{
+	struct ieee80211_hw *hw = dev_id;
+	struct mwl_priv *priv;
+	void *int_status_mask;
+	unsigned int int_status, clr_status;
+	u32 status;
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	int_status_mask = priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK;
+
+	int_status = readl(priv->iobase1 + MACREG_REG_A2H_INTERRUPT_CAUSE);
+
+	if (int_status == 0x00000000)
+		return IRQ_NONE;
+
+	if (int_status == 0xffffffff) {
+		WLDBG_INFO(DBG_LEVEL_0, "card plugged out???");
+	} else {
+		clr_status = int_status;
+
+		if (int_status & MACREG_A2HRIC_BIT_TX_DONE) {
+			int_status &= ~MACREG_A2HRIC_BIT_TX_DONE;
+
+			if (!priv->is_tx_schedule) {
+				status = readl(int_status_mask);
+				writel((status & ~MACREG_A2HRIC_BIT_TX_DONE),
+				       int_status_mask);
+				tasklet_schedule(&priv->tx_task);
+				priv->is_tx_schedule = true;
+			}
+		}
+
+		if (int_status & MACREG_A2HRIC_BIT_RX_RDY) {
+			int_status &= ~MACREG_A2HRIC_BIT_RX_RDY;
+
+			if (!priv->is_rx_schedule) {
+				status = readl(int_status_mask);
+				writel((status & ~MACREG_A2HRIC_BIT_RX_RDY),
+				       int_status_mask);
+				tasklet_schedule(&priv->rx_task);
+				priv->is_rx_schedule = true;
+			}
+		}
+
+		if (int_status & MACREG_A2HRIC_BA_WATCHDOG) {
+			status = readl(int_status_mask);
+			writel((status & ~MACREG_A2HRIC_BA_WATCHDOG),
+			       int_status_mask);
+			int_status &= ~MACREG_A2HRIC_BA_WATCHDOG;
+			ieee80211_queue_work(hw, &priv->watchdog_ba_handle);
+		}
+
+		writel(~clr_status,
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_CAUSE);
+	}
+
+	return IRQ_HANDLED;
+}
+
+module_pci_driver(mwl_pci_driver);
+
+MODULE_DESCRIPTION(MWL_DESC);
+MODULE_VERSION(MWL_DRV_VERSION);
+MODULE_AUTHOR("Marvell Semiconductor, Inc.");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_SUPPORTED_DEVICE(MWL_DEV_NAME);
+MODULE_DEVICE_TABLE(pci, mwl_pci_id_tbl);
diff --git a/drivers/net/wireless/mwlwifi/mwl_rx.c b/drivers/net/wireless/mwlwifi/mwl_rx.c
new file mode 100644
index 0000000..7d813f3
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_rx.c
@@ -0,0 +1,589 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements receive related functions.
+*/
+
+#include <linux/skbuff.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_rx.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define MAX_NUM_RX_RING_BYTES  (SYSADPT_MAX_NUM_RX_DESC * \
+				sizeof(struct mwl_rx_desc))
+
+#define FIRST_RXD priv->desc_data[0].prx_ring[0]
+#define CURR_RXD  priv->desc_data[0].prx_ring[curr_desc]
+#define NEXT_RXD  priv->desc_data[0].prx_ring[curr_desc + 1]
+#define LAST_RXD  priv->desc_data[0].prx_ring[SYSADPT_MAX_NUM_RX_DESC - 1]
+
+#define DECRYPT_ERR_MASK        0x80
+#define GENERAL_DECRYPT_ERR     0xFF
+#define TKIP_DECRYPT_MIC_ERR    0x02
+#define WEP_DECRYPT_ICV_ERR     0x04
+#define TKIP_DECRYPT_ICV_ERR    0x08
+
+#define W836X_RSSI_OFFSET       8
+
+/* Receive rate information constants
+*/
+#define RX_RATE_INFO_FORMAT_11A       0
+#define RX_RATE_INFO_FORMAT_11B       1
+#define RX_RATE_INFO_FORMAT_11N       2
+#define RX_RATE_INFO_FORMAT_11AC      4
+
+#define RX_RATE_INFO_HT20             0
+#define RX_RATE_INFO_HT40             1
+#define RX_RATE_INFO_HT80             2
+
+#define RX_RATE_INFO_LONG_INTERVAL    0
+#define RX_RATE_INFO_SHORT_INTERVAL   1
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static int mwl_rx_ring_alloc(struct mwl_priv *priv);
+static int mwl_rx_ring_init(struct mwl_priv *priv);
+static void mwl_rx_ring_cleanup(struct mwl_priv *priv);
+static void mwl_rx_ring_free(struct mwl_priv *priv);
+static inline void mwl_rx_prepare_status(struct mwl_rx_desc *pdesc,
+					 struct ieee80211_rx_status *status);
+static inline struct mwl_vif *mwl_rx_find_vif_bss(struct list_head *vif_list,
+						  u8 *bssid);
+static inline void mwl_rx_remove_dma_header(struct sk_buff *skb, u16 qos);
+static int mwl_rx_refill(struct mwl_priv *priv, struct mwl_rx_desc *pdesc);
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+int mwl_rx_init(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	rc = mwl_rx_ring_alloc(priv);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_4, "allocating RX ring failed");
+	} else {
+		rc = mwl_rx_ring_init(priv);
+		if (rc) {
+			mwl_rx_ring_free(priv);
+			WLDBG_ERROR(DBG_LEVEL_4,
+				    "initializing RX ring failed");
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+
+	return rc;
+}
+
+void mwl_rx_deinit(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	mwl_rx_ring_cleanup(priv);
+	mwl_rx_ring_free(priv);
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+}
+
+void mwl_rx_recv(unsigned long data)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct mwl_priv *priv;
+	struct mwl_rx_desc *curr_desc;
+	int work_done = 0;
+	struct sk_buff *prx_skb = NULL;
+	int pkt_len;
+	struct ieee80211_rx_status status;
+	struct mwl_vif *mwl_vif = NULL;
+	struct ieee80211_hdr *wh;
+	u32 status_mask;
+
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	curr_desc = priv->desc_data[0].pnext_rx_desc;
+
+	if (!curr_desc) {
+		status_mask = readl(priv->iobase1 +
+				    MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+		writel(status_mask | MACREG_A2HRIC_BIT_RX_RDY,
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+
+		priv->is_rx_schedule = false;
+
+		WLDBG_EXIT_INFO(DBG_LEVEL_4, "busy or no receiving packets");
+		return;
+	}
+
+	while ((curr_desc->rx_control == EAGLE_RXD_CTRL_DMA_OWN) &&
+	       (work_done < priv->recv_limit)) {
+		prx_skb = curr_desc->psk_buff;
+		if (!prx_skb)
+			goto out;
+		pci_unmap_single(priv->pdev,
+				 ENDIAN_SWAP32(curr_desc->pphys_buff_data),
+				 priv->desc_data[0].rx_buf_size,
+				 PCI_DMA_FROMDEVICE);
+		pkt_len = curr_desc->pkt_len;
+
+		if (skb_tailroom(prx_skb) < pkt_len) {
+			WLDBG_PRINT("Critical error: %x %x %x %x",
+				    skb_tailroom(prx_skb), pkt_len,
+				    curr_desc, curr_desc->pbuff_data);
+			dev_kfree_skb_any(prx_skb);
+			goto out;
+		}
+
+		if (curr_desc->channel != hw->conf.chandef.chan->hw_value) {
+			dev_kfree_skb_any(prx_skb);
+			goto out;
+		}
+
+		mwl_rx_prepare_status(curr_desc, &status);
+
+		priv->noise = -curr_desc->noise_floor;
+
+		wh = &((struct mwl_dma_data *)prx_skb->data)->wh;
+
+		if (ieee80211_has_protected(wh->frame_control)) {
+			/* Check if hw crypto has been enabled for
+			 * this bss. If yes, set the status flags
+			 * accordingly
+			 */
+			if (ieee80211_has_tods(wh->frame_control))
+				mwl_vif = mwl_rx_find_vif_bss(&priv->vif_list,
+							      wh->addr1);
+			else
+				mwl_vif = mwl_rx_find_vif_bss(&priv->vif_list,
+							      wh->addr2);
+
+			if (mwl_vif && mwl_vif->is_hw_crypto_enabled) {
+				/* When MMIC ERROR is encountered
+				 * by the firmware, payload is
+				 * dropped and only 32 bytes of
+				 * mwl8k Firmware header is sent
+				 * to the host.
+				 *
+				 * We need to add four bytes of
+				 * key information.  In it
+				 * MAC80211 expects keyidx set to
+				 * 0 for triggering Counter
+				 * Measure of MMIC failure.
+				 */
+				if (status.flag & RX_FLAG_MMIC_ERROR) {
+					struct mwl_dma_data *tr;
+
+					tr = (struct mwl_dma_data *)
+					     prx_skb->data;
+					memset((void *)&tr->data, 0, 4);
+					pkt_len += 4;
+				}
+
+				if (!ieee80211_is_auth(wh->frame_control))
+					status.flag |= RX_FLAG_IV_STRIPPED |
+						       RX_FLAG_DECRYPTED |
+						       RX_FLAG_MMIC_STRIPPED;
+			}
+		}
+
+		skb_put(prx_skb, pkt_len);
+		mwl_rx_remove_dma_header(prx_skb, curr_desc->qos_ctrl);
+		memcpy(IEEE80211_SKB_RXCB(prx_skb), &status, sizeof(status));
+		ieee80211_rx(hw, prx_skb);
+out:
+		mwl_rx_refill(priv, curr_desc);
+		curr_desc->rx_control = EAGLE_RXD_CTRL_DRIVER_OWN;
+		curr_desc->qos_ctrl = 0;
+		curr_desc = curr_desc->pnext;
+		work_done++;
+	}
+
+	priv->desc_data[0].pnext_rx_desc = curr_desc;
+
+	status_mask = readl(priv->iobase1 +
+			    MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+	writel(status_mask | MACREG_A2HRIC_BIT_RX_RDY,
+	       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+
+	priv->is_rx_schedule = false;
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+}
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static int mwl_rx_ring_alloc(struct mwl_priv *priv)
+{
+	WLDBG_ENTER_INFO(DBG_LEVEL_4, "allocating %i (0x%x) bytes",
+			 MAX_NUM_RX_RING_BYTES, MAX_NUM_RX_RING_BYTES);
+
+	BUG_ON(!priv);
+
+	priv->desc_data[0].prx_ring =
+		(struct mwl_rx_desc *)
+		dma_alloc_coherent(&priv->pdev->dev,
+				   MAX_NUM_RX_RING_BYTES,
+				   &priv->desc_data[0].pphys_rx_ring,
+				   GFP_KERNEL);
+
+	if (!priv->desc_data[0].prx_ring) {
+		WLDBG_ERROR(DBG_LEVEL_4, "can not alloc mem");
+		WLDBG_EXIT_INFO(DBG_LEVEL_4, "no memory");
+		return -ENOMEM;
+	}
+
+	memset(priv->desc_data[0].prx_ring, 0x00, MAX_NUM_RX_RING_BYTES);
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_4, "RX ring vaddr: 0x%x paddr: 0x%x",
+			priv->desc_data[0].prx_ring,
+			priv->desc_data[0].pphys_rx_ring);
+
+	return 0;
+}
+
+static int mwl_rx_ring_init(struct mwl_priv *priv)
+{
+	int curr_desc;
+	struct mwl_desc_data *desc;
+
+	WLDBG_ENTER_INFO(DBG_LEVEL_4,  "initializing %i descriptors",
+			 SYSADPT_MAX_NUM_RX_DESC);
+
+	desc = &priv->desc_data[0];
+
+	if (desc->prx_ring) {
+		desc->rx_buf_size = SYSADPT_MAX_AGGR_SIZE;
+
+		for (curr_desc = 0; curr_desc < SYSADPT_MAX_NUM_RX_DESC;
+		     curr_desc++) {
+			CURR_RXD.psk_buff =
+				dev_alloc_skb(desc->rx_buf_size);
+
+			if (skb_linearize(CURR_RXD.psk_buff)) {
+				dev_kfree_skb_any(CURR_RXD.psk_buff);
+				WLDBG_ERROR(DBG_LEVEL_4,
+					    "need linearize memory");
+				WLDBG_EXIT_INFO(DBG_LEVEL_4,
+						"no suitable memory");
+				return -ENOMEM;
+			}
+
+			skb_reserve(CURR_RXD.psk_buff,
+				    SYSADPT_MIN_BYTES_HEADROOM);
+			CURR_RXD.rx_control = EAGLE_RXD_CTRL_DRIVER_OWN;
+			CURR_RXD.status = EAGLE_RXD_STATUS_OK;
+			CURR_RXD.qos_ctrl = 0x0000;
+			CURR_RXD.channel = 0x00;
+			CURR_RXD.rssi = 0x00;
+
+			if (CURR_RXD.psk_buff) {
+				dma_addr_t dma;
+				u32 val;
+
+				CURR_RXD.pkt_len = SYSADPT_MAX_AGGR_SIZE;
+				CURR_RXD.pbuff_data = CURR_RXD.psk_buff->data;
+				dma = pci_map_single(priv->pdev,
+						     CURR_RXD.psk_buff->data,
+						     desc->rx_buf_size,
+						     PCI_DMA_FROMDEVICE);
+				CURR_RXD.pphys_buff_data =
+					ENDIAN_SWAP32(dma);
+				CURR_RXD.pnext = &NEXT_RXD;
+				val = (u32)desc->pphys_rx_ring +
+				      ((curr_desc + 1) *
+				      sizeof(struct mwl_rx_desc));
+				CURR_RXD.pphys_next =
+					ENDIAN_SWAP32(val);
+				WLDBG_INFO(DBG_LEVEL_4,
+					   "rxdesc:%i 0x%x(%i) 0x%x(%i)",
+					   curr_desc,
+					   EAGLE_TXD_STATUS_IDLE,
+					   EAGLE_TXD_STATUS_IDLE,
+					   desc->rx_buf_size,
+					   desc->rx_buf_size);
+				WLDBG_INFO(DBG_LEVEL_4,
+					   "rxdesc: %i vnext: 0x%p pnext: 0x%x",
+					   curr_desc,
+					   CURR_RXD.pnext,
+					   ENDIAN_SWAP32(CURR_RXD.pphys_next));
+			} else {
+				WLDBG_ERROR(DBG_LEVEL_4,
+					    "rxdesc %i: no skbuff available",
+					    curr_desc);
+				WLDBG_EXIT_INFO(DBG_LEVEL_4,
+						"no socket buffer");
+				return -ENOMEM;
+			}
+		}
+		LAST_RXD.pphys_next =
+			ENDIAN_SWAP32((u32)desc->pphys_rx_ring);
+		LAST_RXD.pnext = &FIRST_RXD;
+		priv->desc_data[0].pnext_rx_desc = &FIRST_RXD;
+
+		WLDBG_EXIT_INFO(DBG_LEVEL_4,
+				"last rxdesc vnext:0x%p pnext:0x%x vfirst 0x%x",
+				LAST_RXD.pnext,
+				ENDIAN_SWAP32(LAST_RXD.pphys_next),
+				desc->pnext_rx_desc);
+
+		return 0;
+	}
+
+	WLDBG_ERROR(DBG_LEVEL_4, "no valid RX mem");
+	WLDBG_EXIT_INFO(DBG_LEVEL_4, "no valid RX mem");
+
+	return -ENOMEM;
+}
+
+static void mwl_rx_ring_cleanup(struct mwl_priv *priv)
+{
+	int curr_desc;
+
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!priv);
+
+	if (priv->desc_data[0].prx_ring) {
+		for (curr_desc = 0; curr_desc < SYSADPT_MAX_NUM_RX_DESC;
+		     curr_desc++) {
+			if (!CURR_RXD.psk_buff)
+				continue;
+
+			if (skb_shinfo(CURR_RXD.psk_buff)->nr_frags)
+				skb_shinfo(CURR_RXD.psk_buff)->nr_frags = 0;
+
+			if (skb_shinfo(CURR_RXD.psk_buff)->frag_list)
+				skb_shinfo(CURR_RXD.psk_buff)->frag_list = NULL;
+
+			pci_unmap_single(priv->pdev,
+					 ENDIAN_SWAP32
+					 (CURR_RXD.pphys_buff_data),
+					 priv->desc_data[0].rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
+
+			dev_kfree_skb_any(CURR_RXD.psk_buff);
+
+			WLDBG_INFO(DBG_LEVEL_4,
+				   "unmapped+free'd %i 0x%p 0x%x %i",
+				   curr_desc, CURR_RXD.pbuff_data,
+				   ENDIAN_SWAP32(CURR_RXD.pphys_buff_data),
+				   priv->desc_data[0].rx_buf_size);
+
+			CURR_RXD.pbuff_data = NULL;
+			CURR_RXD.psk_buff = NULL;
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+}
+
+static void mwl_rx_ring_free(struct mwl_priv *priv)
+{
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!priv);
+
+	if (priv->desc_data[0].prx_ring) {
+		mwl_rx_ring_cleanup(priv);
+
+		dma_free_coherent(&priv->pdev->dev,
+				  MAX_NUM_RX_RING_BYTES,
+				  priv->desc_data[0].prx_ring,
+				  priv->desc_data[0].pphys_rx_ring);
+
+		priv->desc_data[0].prx_ring = NULL;
+	}
+
+	priv->desc_data[0].pnext_rx_desc = NULL;
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+}
+
+static inline void mwl_rx_prepare_status(struct mwl_rx_desc *pdesc,
+					 struct ieee80211_rx_status *status)
+{
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!pdesc);
+	BUG_ON(!status);
+
+	memset(status, 0, sizeof(*status));
+
+	status->signal = -(pdesc->rssi + W836X_RSSI_OFFSET);
+
+	switch (pdesc->rate.format) {
+	case RX_RATE_INFO_FORMAT_11N:
+		status->flag |= RX_FLAG_HT;
+		if (pdesc->rate.bw == RX_RATE_INFO_HT40)
+			status->flag |= RX_FLAG_40MHZ;
+		if (pdesc->rate.gi == RX_RATE_INFO_SHORT_INTERVAL)
+			status->flag |= RX_FLAG_SHORT_GI;
+		break;
+	case RX_RATE_INFO_FORMAT_11AC:
+		status->flag |= RX_FLAG_VHT;
+		if (pdesc->rate.bw == RX_RATE_INFO_HT40)
+			status->flag |= RX_FLAG_40MHZ;
+		if (pdesc->rate.bw == RX_RATE_INFO_HT80)
+			status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		if (pdesc->rate.gi == RX_RATE_INFO_SHORT_INTERVAL)
+			status->flag |= RX_FLAG_SHORT_GI;
+		status->vht_nss = (pdesc->rate.nss + 1);
+		break;
+	}
+
+	status->rate_idx = pdesc->rate.rt;
+
+	if (pdesc->channel > BAND_24_CHANNEL_NUM) {
+		status->band = IEEE80211_BAND_5GHZ;
+		if ((!(status->flag & RX_FLAG_HT)) &&
+		    (!(status->flag & RX_FLAG_VHT))) {
+			status->rate_idx -= 5;
+			if (status->rate_idx >= BAND_50_RATE_NUM)
+				status->rate_idx = BAND_50_RATE_NUM - 1;
+		}
+	} else {
+		status->band = IEEE80211_BAND_2GHZ;
+		if ((!(status->flag & RX_FLAG_HT)) &&
+		    (!(status->flag & RX_FLAG_VHT))) {
+			if (status->rate_idx >= BAND_24_RATE_NUM)
+				status->rate_idx = BAND_24_RATE_NUM - 1;
+		}
+	}
+
+	status->freq = ieee80211_channel_to_frequency(pdesc->channel,
+						      status->band);
+
+	/* check if status has a specific error bit (bit 7) set or indicates
+	 * a general decrypt error
+	 */
+	if ((pdesc->status == GENERAL_DECRYPT_ERR) ||
+	    (pdesc->status & DECRYPT_ERR_MASK)) {
+		/* check if status is not equal to 0xFF
+		 * the 0xFF check is for backward compatibility
+		 */
+		if (pdesc->status != GENERAL_DECRYPT_ERR) {
+			if (((pdesc->status & (~DECRYPT_ERR_MASK)) &
+			    TKIP_DECRYPT_MIC_ERR) && !((pdesc->status &
+			    (WEP_DECRYPT_ICV_ERR | TKIP_DECRYPT_ICV_ERR)))) {
+				status->flag |= RX_FLAG_MMIC_ERROR;
+			}
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+}
+
+static inline struct mwl_vif *mwl_rx_find_vif_bss(struct list_head *vif_list,
+						  u8 *bssid)
+{
+	struct mwl_vif *mwl_vif;
+
+	list_for_each_entry(mwl_vif, vif_list, list) {
+		if (memcmp(bssid, mwl_vif->bssid, ETH_ALEN) == 0)
+			return mwl_vif;
+	}
+
+	return NULL;
+}
+
+static inline void mwl_rx_remove_dma_header(struct sk_buff *skb, u16 qos)
+{
+	struct mwl_dma_data *tr;
+	int hdrlen;
+
+	tr = (struct mwl_dma_data *)skb->data;
+	hdrlen = ieee80211_hdrlen(tr->wh.frame_control);
+
+	if (hdrlen != sizeof(tr->wh)) {
+		if (ieee80211_is_data_qos(tr->wh.frame_control)) {
+			memmove(tr->data - hdrlen, &tr->wh, hdrlen - 2);
+			*((u16 *)(tr->data - 2)) = qos;
+		} else {
+			memmove(tr->data - hdrlen, &tr->wh, hdrlen);
+		}
+	}
+
+	if (hdrlen != sizeof(*tr))
+		skb_pull(skb, sizeof(*tr) - hdrlen);
+}
+
+static int mwl_rx_refill(struct mwl_priv *priv, struct mwl_rx_desc *pdesc)
+{
+	WLDBG_ENTER(DBG_LEVEL_4);
+
+	BUG_ON(!priv);
+	BUG_ON(!pdesc);
+
+	pdesc->psk_buff = dev_alloc_skb(priv->desc_data[0].rx_buf_size);
+
+	if (!pdesc->psk_buff)
+		goto nomem;
+
+	if (skb_linearize(pdesc->psk_buff)) {
+		dev_kfree_skb_any(pdesc->psk_buff);
+		WLDBG_ERROR(DBG_LEVEL_4, "need linearize memory");
+		goto nomem;
+	}
+
+	skb_reserve(pdesc->psk_buff, SYSADPT_MIN_BYTES_HEADROOM);
+
+	pdesc->status = EAGLE_RXD_STATUS_OK;
+	pdesc->qos_ctrl = 0x0000;
+	pdesc->channel = 0x00;
+	pdesc->rssi = 0x00;
+
+	pdesc->pkt_len = priv->desc_data[0].rx_buf_size;
+	pdesc->pbuff_data = pdesc->psk_buff->data;
+	pdesc->pphys_buff_data =
+		ENDIAN_SWAP32(pci_map_single(priv->pdev,
+					     pdesc->psk_buff->data,
+					     priv->desc_data[0].rx_buf_size,
+					     PCI_DMA_BIDIRECTIONAL));
+
+	WLDBG_EXIT(DBG_LEVEL_4);
+
+	return 0;
+
+nomem:
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_4, "no memory");
+
+	return -ENOMEM;
+}
diff --git a/drivers/net/wireless/mwlwifi/mwl_rx.h b/drivers/net/wireless/mwlwifi/mwl_rx.h
new file mode 100644
index 0000000..184ff31
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_rx.h
@@ -0,0 +1,30 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines receive related functions.
+*/
+
+#ifndef _mwl_rx_h_
+#define _mwl_rx_h_
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+
+int mwl_rx_init(struct ieee80211_hw *hw);
+void mwl_rx_deinit(struct ieee80211_hw *hw);
+void mwl_rx_recv(unsigned long data);
+
+#endif /* _mwl_rx_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_sysadpt.h b/drivers/net/wireless/mwlwifi/mwl_sysadpt.h
new file mode 100644
index 0000000..1b17ec0
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_sysadpt.h
@@ -0,0 +1,64 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines system adaptation related information.
+*/
+
+#ifndef _mwl_sysadpt_h_
+#define _mwl_sysadpt_h_
+
+/* CONSTANTS AND MACROS
+*/
+
+#define SYSADPT_MAX_NUM_CHANNELS       64
+
+#define SYSADPT_MAX_DATA_RATES_G       14
+
+#define SYSADPT_TX_POWER_LEVEL_TOTAL   16
+
+#define SYSADPT_TX_WMM_QUEUES          4
+
+#define SYSADPT_TX_AMPDU_QUEUES        4
+
+#define SYSADPT_NUM_OF_AP              16
+
+#define SYSADPT_TOTAL_TX_QUEUES        (SYSADPT_TX_WMM_QUEUES + \
+					SYSADPT_NUM_OF_AP)
+
+#define SYSADPT_TOTAL_HW_QUEUES        (SYSADPT_TX_WMM_QUEUES + \
+					SYSADPT_TX_AMPDU_QUEUES)
+
+#define SYSADPT_NUM_OF_DESC_DATA       (4 + SYSADPT_NUM_OF_AP)
+
+#define SYSADPT_MAX_NUM_TX_DESC        256
+
+#define SYSADPT_TX_QUEUE_LIMIT         1024
+
+#define SYSADPT_DELAY_FREE_Q_LIMIT     SYSADPT_MAX_NUM_TX_DESC
+
+#define SYSADPT_MAX_NUM_RX_DESC        256
+
+#define SYSADPT_RECEIVE_LIMIT          64
+
+#define SYSADPT_MAX_AGGR_SIZE          4096
+
+#define SYSADPT_MIN_BYTES_HEADROOM     64
+
+#define SYSADPT_AMPDU_PACKET_THRESHOLD 64
+
+#define SYSADPT_MAX_TID                8
+
+#endif /* _mwl_sysadpt_h_ */
diff --git a/drivers/net/wireless/mwlwifi/mwl_tx.c b/drivers/net/wireless/mwlwifi/mwl_tx.c
new file mode 100644
index 0000000..3bd1979
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_tx.c
@@ -0,0 +1,892 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file implements transmit related functions.
+*/
+
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+
+#include "mwl_sysadpt.h"
+#include "mwl_dev.h"
+#include "mwl_debug.h"
+#include "mwl_fwcmd.h"
+#include "mwl_tx.h"
+
+/* CONSTANTS AND MACROS
+*/
+
+#define MAX_NUM_TX_RING_BYTES  (SYSADPT_MAX_NUM_TX_DESC * \
+				sizeof(struct mwl_tx_desc))
+
+#define FIRST_TXD(i) priv->desc_data[i].ptx_ring[0]
+#define CURR_TXD(i)  priv->desc_data[i].ptx_ring[curr_desc]
+#define NEXT_TXD(i)  priv->desc_data[i].ptx_ring[curr_desc + 1]
+#define LAST_TXD(i)  priv->desc_data[i].ptx_ring[SYSADPT_MAX_NUM_TX_DESC - 1]
+
+#define STALE_TXD(i) priv->desc_data[i].pstale_tx_desc
+
+#define EAGLE_TXD_XMITCTRL_USE_MC_RATE     0x8     /* Use multicast data rate */
+
+#define MWL_QOS_ACK_POLICY_MASK	           0x0060
+#define MWL_QOS_ACK_POLICY_NORMAL          0x0000
+#define MWL_QOS_ACK_POLICY_BLOCKACK        0x0060
+
+#define EXT_IV                             0x20
+#define INCREASE_IV(iv16, iv32) \
+{ \
+	(iv16)++; \
+	if ((iv16) == 0) \
+		(iv32)++; \
+}
+
+/* Transmit rate information constants
+*/
+#define TX_RATE_FORMAT_LEGACY         0
+#define TX_RATE_FORMAT_11N            1
+#define TX_RATE_FORMAT_11AC           2
+
+#define TX_RATE_BANDWIDTH_20          0
+#define TX_RATE_BANDWIDTH_40          1
+#define TX_RATE_BANDWIDTH_80          2
+
+#define TX_RATE_INFO_STD_GI           0
+#define TX_RATE_INFO_SHORT_GI         1
+
+/* PRIVATE FUNCTION DECLARATION
+*/
+
+static int mwl_tx_ring_alloc(struct mwl_priv *priv);
+static int mwl_tx_ring_init(struct mwl_priv *priv);
+static void mwl_tx_ring_cleanup(struct mwl_priv *priv);
+static void mwl_tx_ring_free(struct mwl_priv *priv);
+static inline void mwl_tx_add_dma_header(struct mwl_priv *priv,
+					 struct sk_buff *skb,
+					 int head_pad,
+					 int tail_pad);
+static inline void mwl_tx_encapsulate_frame(struct mwl_priv *priv,
+					    struct sk_buff *skb, bool *ccmp);
+static inline void mwl_tx_insert_ccmp_hdr(u8 *pccmp_hdr,
+					  u8 key_id, u16 iv16, u32 iv32);
+static inline int mwl_tx_tid_queue_mapping(u8 tid);
+static inline void mwl_tx_count_packet(struct ieee80211_sta *sta, u8 tid);
+static inline void mwl_tx_skbs(struct ieee80211_hw *hw);
+/* static void mwl_tx_descriptor_dump(struct mwl_priv *priv); */
+
+/* PUBLIC FUNCTION DEFINITION
+*/
+
+int mwl_tx_init(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	int rc;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	skb_queue_head_init(&priv->delay_q);
+
+	rc = mwl_tx_ring_alloc(priv);
+	if (rc) {
+		WLDBG_ERROR(DBG_LEVEL_3, "allocating TX ring failed");
+	} else {
+		rc = mwl_tx_ring_init(priv);
+		if (rc) {
+			mwl_tx_ring_free(priv);
+			WLDBG_ERROR(DBG_LEVEL_3, "initializing TX ring failed");
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+
+	return rc;
+}
+
+void mwl_tx_deinit(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	skb_queue_purge(&priv->delay_q);
+
+	mwl_tx_ring_cleanup(priv);
+	mwl_tx_ring_free(priv);
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+}
+
+void mwl_tx_xmit(struct ieee80211_hw *hw,
+		 int index,
+	struct ieee80211_sta *sta,
+	struct sk_buff *skb)
+{
+	struct mwl_priv *priv;
+	struct ieee80211_tx_info *tx_info;
+	struct mwl_vif *mwl_vif;
+	struct ieee80211_hdr *wh;
+	u8 xmitcontrol;
+	u16 qos;
+	int txpriority;
+	u8 tid = 0;
+	struct mwl_ampdu_stream *stream = NULL;
+	bool start_ba_session = false;
+	bool mgmtframe = false;
+	struct ieee80211_mgmt *mgmt;
+	bool eapol_frame = false;
+	bool ccmp = false;
+	struct mwl_dma_data *dma_data;
+	struct mwl_tx_ctrl *tx_ctrl;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	BUG_ON(!skb);
+
+	wh = (struct ieee80211_hdr *)skb->data;
+
+	if (ieee80211_is_data_qos(wh->frame_control))
+		qos = ENDIAN_SWAP16(*((u16 *)ieee80211_get_qos_ctl(wh)));
+	else
+		qos = 0;
+
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		index = IEEE80211_AC_VO;
+		eapol_frame = true;
+	}
+
+	if (ieee80211_is_mgmt(wh->frame_control)) {
+		mgmtframe = true;
+		mgmt = (struct ieee80211_mgmt *)skb->data;
+	}
+
+	mwl_tx_encapsulate_frame(priv, skb, &ccmp);
+
+	dma_data = (struct mwl_dma_data *)skb->data;
+	wh = &dma_data->wh;
+
+	tx_info = IEEE80211_SKB_CB(skb);
+	mwl_vif = MWL_VIF(tx_info->control.vif);
+
+	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		wh->seq_ctrl &= ENDIAN_SWAP16(IEEE80211_SCTL_FRAG);
+		wh->seq_ctrl |= ENDIAN_SWAP16(mwl_vif->seqno);
+		mwl_vif->seqno += 0x10;
+	}
+
+	/* Setup firmware control bit fields for each frame type.
+	*/
+	xmitcontrol = 0;
+
+	if (mgmtframe || ieee80211_is_ctl(wh->frame_control)) {
+		qos = 0;
+	} else if (ieee80211_is_data(wh->frame_control)) {
+		qos &= ~MWL_QOS_ACK_POLICY_MASK;
+
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+			xmitcontrol &= 0xfb;
+			qos |= MWL_QOS_ACK_POLICY_BLOCKACK;
+		} else {
+			xmitcontrol |= 0x4;
+			qos |= MWL_QOS_ACK_POLICY_NORMAL;
+		}
+
+		if (is_multicast_ether_addr(wh->addr1)) {
+			xmitcontrol |= EAGLE_TXD_XMITCTRL_USE_MC_RATE;
+
+			if (ccmp) {
+				mwl_tx_insert_ccmp_hdr(dma_data->data,
+						       mwl_vif->keyidx,
+						       mwl_vif->iv16,
+						       mwl_vif->iv32);
+				INCREASE_IV(mwl_vif->iv16, mwl_vif->iv32);
+			}
+		} else {
+			if (ccmp) {
+				if (mwl_vif->is_sta) {
+					mwl_tx_insert_ccmp_hdr(dma_data->data,
+							       mwl_vif->keyidx,
+							       mwl_vif->iv16,
+							       mwl_vif->iv32);
+					INCREASE_IV(mwl_vif->iv16,
+						    mwl_vif->iv32);
+				} else {
+					struct mwl_sta *sta_info = MWL_STA(sta);
+
+					mwl_tx_insert_ccmp_hdr(dma_data->data,
+							       0,
+							       sta_info->iv16,
+							       sta_info->iv32);
+					INCREASE_IV(sta_info->iv16,
+						    sta_info->iv32);
+				}
+			}
+		}
+	}
+
+	/* Queue ADDBA request in the respective data queue.  While setting up
+	 * the ampdu stream, mac80211 queues further packets for that
+	 * particular ra/tid pair.  However, packets piled up in the hardware
+	 * for that ra/tid pair will still go out. ADDBA request and the
+	 * related data packets going out from different queues asynchronously
+	 * will cause a shift in the receiver window which might result in
+	 * ampdu packets getting dropped at the receiver after the stream has
+	 * been setup.
+	 */
+	if (mgmtframe) {
+		if (unlikely(ieee80211_is_action(wh->frame_control) &&
+			     mgmt->u.action.category == WLAN_CATEGORY_BACK &&
+			     mgmt->u.action.u.addba_req.action_code ==
+			     WLAN_ACTION_ADDBA_REQ)) {
+			u16 capab =
+				ENDIAN_SWAP16(mgmt->u.action.u.addba_req.capab);
+			tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+			index = mwl_tx_tid_queue_mapping(tid);
+		}
+	}
+
+	txpriority = SYSADPT_TX_WMM_QUEUES - index - 1;
+
+	if (sta && sta->ht_cap.ht_supported && !eapol_frame &&
+	    ieee80211_is_data_qos(wh->frame_control)) {
+		tid = qos & 0xf;
+		mwl_tx_count_packet(sta, tid);
+
+		SPIN_LOCK(&priv->locks.stream_lock);
+		stream = mwl_fwcmd_lookup_stream(hw, sta->addr, tid);
+
+		if (stream) {
+			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				WARN_ON(!(qos & MWL_QOS_ACK_POLICY_BLOCKACK));
+
+				txpriority =
+					(SYSADPT_TX_WMM_QUEUES + stream->idx) %
+					SYSADPT_TOTAL_HW_QUEUES;
+			} else if (stream->state == AMPDU_STREAM_NEW) {
+				/* We get here if the driver sends us packets
+				 * after we've initiated a stream, but before
+				 * our ampdu_action routine has been called
+				 * with IEEE80211_AMPDU_TX_START to get the SSN
+				 * for the ADDBA request.  So this packet can
+				 * go out with no risk of sequence number
+				 * mismatch.  No special handling is required.
+				 */
+			} else {
+				/* Drop packets that would go out after the
+				 * ADDBA request was sent but before the ADDBA
+				 * response is received.  If we don't do this,
+				 * the recipient would probably receive it
+				 * after the ADDBA request with SSN 0.  This
+				 * will cause the recipient's BA receive window
+				 * to shift, which would cause the subsequent
+				 * packets in the BA stream to be discarded.
+				 * mac80211 queues our packets for us in this
+				 * case, so this is really just a safety check.
+				 */
+				WLDBG_WARNING(DBG_LEVEL_3,
+					      "can't send packet during ADDBA");
+				SPIN_UNLOCK(&priv->locks.stream_lock);
+				dev_kfree_skb_any(skb);
+				return;
+			}
+		} else {
+			/* Defer calling mwl8k_start_stream so that the current
+			 * skb can go out before the ADDBA request.  This
+			 * prevents sequence number mismatch at the recipient
+			 * as described above.
+			 */
+			if (mwl_fwcmd_ampdu_allowed(sta, tid)) {
+				stream = mwl_fwcmd_add_stream(hw, sta, tid);
+
+				if (stream)
+					start_ba_session = true;
+			}
+		}
+
+		SPIN_UNLOCK(&priv->locks.stream_lock);
+	} else {
+		qos &= ~MWL_QOS_ACK_POLICY_MASK;
+		qos |= MWL_QOS_ACK_POLICY_NORMAL;
+	}
+
+	tx_ctrl = (struct mwl_tx_ctrl *)&tx_info->status;
+	tx_ctrl->tx_priority = txpriority;
+	tx_ctrl->qos_ctrl = qos;
+	tx_ctrl->type = (mgmtframe ? IEEE_TYPE_MANAGEMENT : IEEE_TYPE_DATA);
+	tx_ctrl->xmit_control = xmitcontrol;
+	tx_ctrl->sta_info = (u8 *)sta;
+	tx_ctrl->ccmp = ccmp;
+
+	if (skb_queue_len(&priv->txq[index]) > priv->txq_limit) {
+		dev_kfree_skb_any(skb);
+		WLDBG_INFO(DBG_LEVEL_3, "queue len > limit");
+	} else {
+		skb_queue_tail(&priv->txq[index], skb);
+	}
+
+	mwl_tx_skbs(hw);
+
+	/* Initiate the ampdu session here
+	*/
+	if (start_ba_session) {
+		SPIN_LOCK(&priv->locks.stream_lock);
+		if (mwl_fwcmd_start_stream(hw, stream))
+			mwl_fwcmd_remove_stream(hw, stream);
+		SPIN_UNLOCK(&priv->locks.stream_lock);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+}
+
+void mwl_tx_done(unsigned long data)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct mwl_priv *priv;
+	unsigned long flags;
+	int num;
+	struct sk_buff *done_skb;
+	struct mwl_rate_info rate_info;
+	struct mwl_dma_data *tr;
+	struct ieee80211_tx_info *info;
+	int hdrlen;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	SPIN_LOCK_IRQSAVE(&priv->locks.xmit_lock, flags);
+
+	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
+		while (STALE_TXD(num) && (STALE_TXD(num)->status &
+		       ENDIAN_SWAP32(EAGLE_TXD_STATUS_OK)) &&
+		       (!(STALE_TXD(num)->status &
+		       ENDIAN_SWAP32(EAGLE_TXD_STATUS_FW_OWNED)))) {
+			pci_unmap_single(priv->pdev,
+					 ENDIAN_SWAP32(STALE_TXD(num)->pkt_ptr),
+					 STALE_TXD(num)->psk_buff->len,
+					 PCI_DMA_TODEVICE);
+			done_skb = STALE_TXD(num)->psk_buff;
+			rate_info = STALE_TXD(num)->rate_info;
+			STALE_TXD(num)->pkt_len = 0;
+			STALE_TXD(num)->psk_buff = NULL;
+			STALE_TXD(num)->status =
+				ENDIAN_SWAP32(EAGLE_TXD_STATUS_IDLE);
+			priv->fw_desc_cnt[num]--;
+			STALE_TXD(num) = STALE_TXD(num)->pnext;
+			wmb(); /* memory barrier */
+
+			tr = (struct mwl_dma_data *)done_skb->data;
+			info = IEEE80211_SKB_CB(done_skb);
+			ieee80211_tx_info_clear_status(info);
+
+			info->status.rates[0].idx = -1;
+
+			if (ieee80211_is_data(tr->wh.frame_control) ||
+			    ieee80211_is_data_qos(tr->wh.frame_control)) {
+				skb_get(done_skb);
+				skb_queue_tail(&priv->delay_q, done_skb);
+
+				if (skb_queue_len(&priv->delay_q) >
+				    SYSADPT_DELAY_FREE_Q_LIMIT)
+					dev_kfree_skb_any(
+						skb_dequeue(&priv->delay_q));
+
+				/* Prepare rate information
+				*/
+				info->status.rates[0].idx =
+					rate_info.rate_id_mcs;
+				if (rate_info.format == TX_RATE_FORMAT_LEGACY) {
+					if (hw->conf.chandef.chan->hw_value >
+					    BAND_24_CHANNEL_NUM) {
+						info->status.rates[0].idx -= 5;
+					}
+				}
+				if (rate_info.format == TX_RATE_FORMAT_11N)
+					info->status.rates[0].flags |=
+						IEEE80211_TX_RC_MCS;
+				if (rate_info.format == TX_RATE_FORMAT_11AC)
+					info->status.rates[0].flags |=
+						IEEE80211_TX_RC_VHT_MCS;
+				if (rate_info.bandwidth == TX_RATE_BANDWIDTH_40)
+					info->status.rates[0].flags |=
+						IEEE80211_TX_RC_40_MHZ_WIDTH;
+				if (rate_info.bandwidth == TX_RATE_BANDWIDTH_80)
+					info->status.rates[0].flags |=
+						IEEE80211_TX_RC_80_MHZ_WIDTH;
+				if (rate_info.short_gi == TX_RATE_INFO_SHORT_GI)
+					info->status.rates[0].flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+				info->status.rates[0].count = 1;
+
+				info->status.rates[1].idx = -1;
+			}
+
+			/* Remove H/W dma header
+			*/
+			hdrlen = ieee80211_hdrlen(tr->wh.frame_control);
+			memmove(tr->data - hdrlen, &tr->wh, hdrlen);
+			skb_pull(done_skb, sizeof(*tr) - hdrlen);
+
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			ieee80211_tx_status(hw, done_skb);
+		}
+	}
+
+	SPIN_UNLOCK_IRQRESTORE(&priv->locks.xmit_lock, flags);
+
+	if (priv->irq != -1) {
+		u32 status;
+
+		status = readl(priv->iobase1 +
+			       MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+		writel(status | MACREG_A2HRIC_BIT_TX_DONE,
+		       priv->iobase1 + MACREG_REG_A2H_INTERRUPT_STATUS_MASK);
+
+		mwl_tx_skbs(hw);
+	}
+
+	priv->is_tx_schedule = false;
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+}
+
+/* PRIVATE FUNCTION DEFINITION
+*/
+
+static int mwl_tx_ring_alloc(struct mwl_priv *priv)
+{
+	int num;
+	u8 *mem;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!priv);
+
+	mem = (u8 *)dma_alloc_coherent(&priv->pdev->dev,
+		MAX_NUM_TX_RING_BYTES * SYSADPT_NUM_OF_DESC_DATA,
+		&priv->desc_data[0].pphys_tx_ring, GFP_KERNEL);
+
+	if (!mem) {
+		WLDBG_ERROR(DBG_LEVEL_3, "can not alloc mem");
+		WLDBG_EXIT_INFO(DBG_LEVEL_3, "no memory");
+		return -ENOMEM;
+	}
+
+	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
+		WLDBG_INFO(DBG_LEVEL_3, "allocating %i (0x%x) bytes",
+			   MAX_NUM_TX_RING_BYTES, MAX_NUM_TX_RING_BYTES);
+
+		priv->desc_data[num].ptx_ring = (struct mwl_tx_desc *)
+			(mem + num * MAX_NUM_TX_RING_BYTES);
+
+		priv->desc_data[num].pphys_tx_ring = (dma_addr_t)
+			((u32)priv->desc_data[0].pphys_tx_ring +
+			num * MAX_NUM_TX_RING_BYTES);
+
+		memset(priv->desc_data[num].ptx_ring, 0x00,
+		       MAX_NUM_TX_RING_BYTES);
+
+		WLDBG_INFO(DBG_LEVEL_3, "TX ring vaddr: 0x%x paddr: 0x%x",
+			   priv->desc_data[num].ptx_ring,
+			   priv->desc_data[num].pphys_tx_ring);
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+
+	return 0;
+}
+
+static int mwl_tx_ring_init(struct mwl_priv *priv)
+{
+	int curr_desc;
+	struct mwl_desc_data *desc;
+	int num;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!priv);
+
+	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
+		skb_queue_head_init(&priv->txq[num]);
+		priv->fw_desc_cnt[num] = 0;
+
+		desc = &priv->desc_data[num];
+
+		if (desc->ptx_ring) {
+			WLDBG_INFO(DBG_LEVEL_3, "initializing %i descriptors",
+				   SYSADPT_MAX_NUM_TX_DESC);
+
+			for (curr_desc = 0; curr_desc < SYSADPT_MAX_NUM_TX_DESC;
+			     curr_desc++) {
+				CURR_TXD(num).status =
+					ENDIAN_SWAP32(EAGLE_TXD_STATUS_IDLE);
+				CURR_TXD(num).pnext = &NEXT_TXD(num);
+				CURR_TXD(num).pphys_next =
+					ENDIAN_SWAP32((u32)desc->pphys_tx_ring +
+					((curr_desc + 1) *
+					sizeof(struct mwl_tx_desc)));
+				WLDBG_INFO(DBG_LEVEL_3,
+					   "txdesc: %i 0x%x (%i) 0x%p 0x%x",
+					   curr_desc, EAGLE_TXD_STATUS_IDLE,
+					   EAGLE_TXD_STATUS_IDLE,
+					   CURR_TXD(num).pnext,
+					   ENDIAN_SWAP32(
+					   CURR_TXD(num).pphys_next));
+			}
+			LAST_TXD(num).pnext = &FIRST_TXD(num);
+			LAST_TXD(num).pphys_next =
+				ENDIAN_SWAP32((u32)desc->pphys_tx_ring);
+			desc->pstale_tx_desc = &FIRST_TXD(num);
+			desc->pnext_tx_desc  = &FIRST_TXD(num);
+
+			WLDBG_INFO(DBG_LEVEL_3,
+				   "last txdesc vnext: 0x%p 0x%x 0x%x 0x%x",
+				   LAST_TXD(num).pnext,
+				   ENDIAN_SWAP32(LAST_TXD(num).pphys_next),
+				   desc->pstale_tx_desc, desc->pnext_tx_desc);
+		} else {
+			WLDBG_ERROR(DBG_LEVEL_3, "no valid TX mem");
+			WLDBG_EXIT_INFO(DBG_LEVEL_3, "no valid memory");
+			return -ENOMEM;
+		}
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+
+	return 0;
+}
+
+static void mwl_tx_ring_cleanup(struct mwl_priv *priv)
+{
+	int cleaned_tx_desc = 0;
+	int curr_desc;
+	int num;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!priv);
+
+	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
+		skb_queue_purge(&priv->txq[num]);
+		priv->fw_desc_cnt[num] = 0;
+		if (priv->desc_data[num].ptx_ring) {
+			for (curr_desc = 0; curr_desc < SYSADPT_MAX_NUM_TX_DESC;
+			     curr_desc++) {
+				if (!CURR_TXD(num).psk_buff)
+					continue;
+
+				WLDBG_INFO(DBG_LEVEL_3,
+					   "unmapped and free'd %i 0x%p 0x%x",
+					   curr_desc,
+					   CURR_TXD(num).psk_buff->data,
+					   ENDIAN_SWAP32(
+					   CURR_TXD(num).pkt_ptr));
+				pci_unmap_single(priv->pdev,
+						 ENDIAN_SWAP32(
+						 CURR_TXD(num).pkt_ptr),
+						 CURR_TXD(num).psk_buff->len,
+						 PCI_DMA_TODEVICE);
+				dev_kfree_skb_any(CURR_TXD(num).psk_buff);
+				CURR_TXD(num).status =
+					ENDIAN_SWAP32(EAGLE_TXD_STATUS_IDLE);
+				CURR_TXD(num).psk_buff = NULL;
+				CURR_TXD(num).pkt_ptr = 0;
+				CURR_TXD(num).pkt_len = 0;
+				cleaned_tx_desc++;
+			}
+		}
+	}
+
+	WLDBG_EXIT_INFO(DBG_LEVEL_3, "cleaned %i TX descr", cleaned_tx_desc);
+}
+
+static void mwl_tx_ring_free(struct mwl_priv *priv)
+{
+	int num;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!priv);
+
+	if (priv->desc_data[0].ptx_ring) {
+		dma_free_coherent(&priv->pdev->dev,
+				  MAX_NUM_TX_RING_BYTES *
+				  SYSADPT_NUM_OF_DESC_DATA,
+				  priv->desc_data[0].ptx_ring,
+				  priv->desc_data[0].pphys_tx_ring);
+	}
+
+	for (num = 0; num < SYSADPT_NUM_OF_DESC_DATA; num++) {
+		if (priv->desc_data[num].ptx_ring)
+			priv->desc_data[num].ptx_ring = NULL;
+		priv->desc_data[num].pstale_tx_desc = NULL;
+		priv->desc_data[num].pnext_tx_desc  = NULL;
+	}
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+}
+
+static inline void mwl_tx_add_dma_header(struct mwl_priv *priv,
+					 struct sk_buff *skb,
+					 int head_pad,
+					 int tail_pad)
+{
+	struct ieee80211_hdr *wh;
+	int hdrlen;
+	int reqd_hdrlen;
+	struct mwl_dma_data *tr;
+
+	/* Add a firmware DMA header; the firmware requires that we
+	 * present a 2-byte payload length followed by a 4-address
+	 * header (without QoS field), followed (optionally) by any
+	 * WEP/ExtIV header (but only filled in for CCMP).
+	 */
+	wh = (struct ieee80211_hdr *)skb->data;
+
+	hdrlen = ieee80211_hdrlen(wh->frame_control);
+
+	reqd_hdrlen = sizeof(*tr) + head_pad;
+
+	if (hdrlen != reqd_hdrlen)
+		skb_push(skb, reqd_hdrlen - hdrlen);
+
+	if (ieee80211_is_data_qos(wh->frame_control))
+		hdrlen -= IEEE80211_QOS_CTL_LEN;
+
+	tr = (struct mwl_dma_data *)skb->data;
+
+	if (wh != &tr->wh)
+		memmove(&tr->wh, wh, hdrlen);
+
+	if (hdrlen != sizeof(tr->wh))
+		memset(((void *)&tr->wh) + hdrlen, 0, sizeof(tr->wh) - hdrlen);
+
+	/* Firmware length is the length of the fully formed "802.11
+	 * payload".  That is, everything except for the 802.11 header.
+	 * This includes all crypto material including the MIC.
+	 */
+	tr->fwlen = ENDIAN_SWAP16(skb->len - sizeof(*tr) + tail_pad);
+}
+
+static inline void mwl_tx_encapsulate_frame(struct mwl_priv *priv,
+					    struct sk_buff *skb, bool *ccmp)
+{
+	struct ieee80211_hdr *wh;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_key_conf *key_conf;
+	int data_pad;
+	int head_pad = 0;
+
+	wh = (struct ieee80211_hdr *)skb->data;
+
+	tx_info = IEEE80211_SKB_CB(skb);
+
+	key_conf = NULL;
+
+	if (ieee80211_is_data(wh->frame_control))
+		key_conf = tx_info->control.hw_key;
+
+	/* Make sure the packet header is in the DMA header format (4-address
+	 * without QoS), and add head & tail padding when HW crypto is enabled.
+	 *
+	 * We have the following trailer padding requirements:
+	 * - WEP: 4 trailer bytes (ICV)
+	 * - TKIP: 12 trailer bytes (8 MIC + 4 ICV)
+	 * - CCMP: 8 trailer bytes (MIC)
+	 */
+	data_pad = 0;
+
+	if (key_conf) {
+		head_pad = key_conf->iv_len;
+
+		switch (key_conf->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			data_pad = 4;
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			data_pad = 12;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			data_pad = 8;
+			*ccmp = true;
+			break;
+		}
+	}
+
+	mwl_tx_add_dma_header(priv, skb, head_pad, data_pad);
+}
+
+static inline void mwl_tx_insert_ccmp_hdr(u8 *pccmp_hdr,
+					  u8 key_id, u16 iv16, u32 iv32)
+{
+	*((u16 *)pccmp_hdr) = iv16;
+	pccmp_hdr[2] = 0;
+	pccmp_hdr[3] = EXT_IV | (key_id << 6);
+	*((u32 *)&pccmp_hdr[4]) = iv32;
+}
+
+static inline int mwl_tx_tid_queue_mapping(u8 tid)
+{
+	BUG_ON(tid > 7);
+
+	switch (tid) {
+	case 0:
+	case 3:
+		return IEEE80211_AC_BE;
+	case 1:
+	case 2:
+		return IEEE80211_AC_BK;
+	case 4:
+	case 5:
+		return IEEE80211_AC_VI;
+	case 6:
+	case 7:
+		return IEEE80211_AC_VO;
+	default:
+		break;
+	}
+
+	return -1;
+}
+
+static inline void mwl_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
+{
+	struct mwl_sta *sta_info = MWL_STA(sta);
+	struct mwl_tx_info *tx_stats;
+
+	BUG_ON(!sta);
+	sta_info = MWL_STA(sta);
+	BUG_ON(!sta_info);
+
+	BUG_ON(tid >= SYSADPT_MAX_TID);
+
+	tx_stats = &sta_info->tx_stats[tid];
+
+	if (tx_stats->start_time == 0)
+		tx_stats->start_time = jiffies;
+
+	/* reset the packet count after each second elapses.  If the number of
+	 * packets ever exceeds the ampdu_min_traffic threshold, we will allow
+	 * an ampdu stream to be started.
+	 */
+	if (jiffies - tx_stats->start_time > HZ) {
+		tx_stats->pkts = 0;
+		tx_stats->start_time = 0;
+	} else {
+		tx_stats->pkts++;
+	}
+}
+
+static inline void mwl_tx_skbs(struct ieee80211_hw *hw)
+{
+	struct mwl_priv *priv;
+	unsigned long flags;
+	int num = SYSADPT_NUM_OF_DESC_DATA;
+	struct mwl_desc_data *desc;
+	struct sk_buff *tx_skb;
+	struct ieee80211_tx_info *tx_info;
+	struct mwl_tx_ctrl *tx_ctrl;
+
+	WLDBG_ENTER(DBG_LEVEL_3);
+
+	BUG_ON(!hw);
+	priv = hw->priv;
+	BUG_ON(!priv);
+
+	SPIN_LOCK_IRQSAVE(&priv->locks.xmit_lock, flags);
+
+	while (num--) {
+		while (skb_queue_len(&priv->txq[num]) > 0) {
+			desc = &priv->desc_data[num];
+
+			if (!desc->pnext_tx_desc)
+				break;
+
+			/* Only queue to tx desc when Status is 0 (not when 0x1
+			 * or 0x80000000). If we queue even when Status==0x1
+			 * (DMA'd to fw but txdone haven't change Status to 0),
+			 * mismatch of fwDescCnt with actual number of desc
+			 * with Status==0 could happen. E.g fwDescCnt 256
+			 * instead of 255 when there is one desc with Status==0.
+			 * This can cause Tx to stall when fwDescCnt==256 and
+			 * pStaleTxDesc->Status==0.
+			 */
+			if (desc->pnext_tx_desc->status !=
+			    EAGLE_TXD_STATUS_IDLE) {
+				/* Interrupt F/W anyway
+				*/
+				if (desc->pnext_tx_desc->status &
+				    ENDIAN_SWAP32(EAGLE_TXD_STATUS_FW_OWNED))
+					writel(MACREG_H2ARIC_BIT_PPA_READY,
+					       priv->iobase1 +
+					       MACREG_REG_H2A_INTERRUPT_EVENTS);
+				break;
+			}
+
+			tx_skb = skb_dequeue(&priv->txq[num]);
+
+			BUG_ON(!tx_skb);
+
+			tx_info = IEEE80211_SKB_CB(tx_skb);
+			tx_ctrl = (struct mwl_tx_ctrl *)&tx_info->status;
+
+			desc->pnext_tx_desc->tx_priority = tx_ctrl->tx_priority;
+			desc->pnext_tx_desc->qos_ctrl = tx_ctrl->qos_ctrl;
+			desc->pnext_tx_desc->psk_buff = tx_skb;
+			desc->pnext_tx_desc->pkt_len =
+				ENDIAN_SWAP16(tx_skb->len);
+			desc->pnext_tx_desc->packet_info = 0;
+			desc->pnext_tx_desc->data_rate = 0;
+			desc->pnext_tx_desc->sta_info = tx_ctrl->sta_info;
+			desc->pnext_tx_desc->type = tx_ctrl->type;
+			desc->pnext_tx_desc->xmit_control =
+				tx_ctrl->xmit_control;
+			desc->pnext_tx_desc->sap_pkt_info = 0;
+			desc->pnext_tx_desc->pkt_ptr =
+				ENDIAN_SWAP32(pci_map_single(priv->pdev,
+							     tx_skb->data,
+							     tx_skb->len,
+							     PCI_DMA_TODEVICE));
+			desc->pnext_tx_desc->status =
+				ENDIAN_SWAP32(EAGLE_TXD_STATUS_FW_OWNED);
+			desc->pnext_tx_desc = desc->pnext_tx_desc->pnext;
+			/* make sure all the memory transactions done by cpu
+			 * were completed
+			 */
+			wmb();	/*Data Memory Barrier*/
+			writel(MACREG_H2ARIC_BIT_PPA_READY,
+			       priv->iobase1 + MACREG_REG_H2A_INTERRUPT_EVENTS);
+			priv->fw_desc_cnt[num]++;
+		}
+	}
+
+	SPIN_UNLOCK_IRQRESTORE(&priv->locks.xmit_lock, flags);
+
+	WLDBG_EXIT(DBG_LEVEL_3);
+}
diff --git a/drivers/net/wireless/mwlwifi/mwl_tx.h b/drivers/net/wireless/mwlwifi/mwl_tx.h
new file mode 100644
index 0000000..20a8772
--- /dev/null
+++ b/drivers/net/wireless/mwlwifi/mwl_tx.h
@@ -0,0 +1,34 @@
+/*
+* Copyright (c) 2006-2015 Marvell International Ltd.
+*
+* Permission to use, copy, modify, and/or distribute this software for any
+* purpose with or without fee is hereby granted, provided that the above
+* copyright notice and this permission notice appear in all copies.
+*
+* THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+* WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+* MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+* SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+* WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+* OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+* CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
+/* Description:  This file defines transmit related functions.
+*/
+
+#ifndef _mwl_tx_h_
+#define _mwl_tx_h_
+
+/* PUBLIC FUNCTION DECLARATION
+*/
+
+int mwl_tx_init(struct ieee80211_hw *hw);
+void mwl_tx_deinit(struct ieee80211_hw *hw);
+void mwl_tx_xmit(struct ieee80211_hw *hw,
+		 int index,
+		 struct ieee80211_sta *sta,
+		 struct sk_buff *skb);
+void mwl_tx_done(unsigned long data);
+
+#endif /* _mwl_tx_h_ */
-- 
1.9.1

