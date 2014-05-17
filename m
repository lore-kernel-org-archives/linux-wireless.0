Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36299 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaEQIxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:05 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so2009119wib.5
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/22] staging: vt6656: srom.h move all macros to device.h
Date: Sat, 17 May 2014 09:50:28 +0100
Message-Id: <1400316639-4430-11-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112149_037061_12CA1249)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove srom.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  1 -
 drivers/staging/vt6656/datarate.c |  1 -
 drivers/staging/vt6656/device.h   | 36 ++++++++++++++++++-
 drivers/staging/vt6656/srom.h     | 74 ---------------------------------------
 4 files changed, 35 insertions(+), 77 deletions(-)
 delete mode 100644 drivers/staging/vt6656/srom.h

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3d4610e..9f3b2fb 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -40,7 +40,6 @@
 #include "mac.h"
 #include "baseband.h"
 #include "rf.h"
-#include "srom.h"
 #include "control.h"
 #include "datarate.h"
 #include "rndis.h"
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 547db6f..8032d6b 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -40,7 +40,6 @@
 #include "datarate.h"
 #include "card.h"
 #include "baseband.h"
-#include "srom.h"
 #include "rf.h"
 
 /* static int msglevel = MSG_LEVEL_DEBUG; */
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f8591a2..990b345 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -62,7 +62,6 @@
 #include "tether.h"
 #include "wmgr.h"
 #include "wcmd.h"
-#include "srom.h"
 #include "rc4.h"
 #include "desc.h"
 #include "key.h"
@@ -106,6 +105,41 @@
 #define BB_VGA_LEVEL            4
 #define BB_VGA_CHANGE_THRESHOLD 3
 
+#define EEP_MAX_CONTEXT_SIZE    256
+
+/* Contents in the EEPROM */
+#define EEP_OFS_PAR		0x0
+#define EEP_OFS_ANTENNA		0x17
+#define EEP_OFS_RADIOCTL	0x18
+#define EEP_OFS_RFTYPE		0x1b
+#define EEP_OFS_MINCHANNEL	0x1c
+#define EEP_OFS_MAXCHANNEL	0x1d
+#define EEP_OFS_SIGNATURE	0x1e
+#define EEP_OFS_ZONETYPE	0x1f
+#define EEP_OFS_RFTABLE		0x20
+#define EEP_OFS_PWR_CCK		0x20
+#define EEP_OFS_SETPT_CCK	0x21
+#define EEP_OFS_PWR_OFDMG	0x23
+
+#define EEP_OFS_CALIB_TX_IQ	0x24
+#define EEP_OFS_CALIB_TX_DC	0x25
+#define EEP_OFS_CALIB_RX_IQ	0x26
+
+#define EEP_OFS_MAJOR_VER	0x2e
+#define EEP_OFS_MINOR_VER	0x2f
+
+#define EEP_OFS_CCK_PWR_TBL	0x30
+#define EEP_OFS_OFDM_PWR_TBL	0x40
+#define EEP_OFS_OFDMA_PWR_TBL	0x50
+
+/* Bits in EEP_OFS_ANTENNA */
+#define EEP_ANTENNA_MAIN	0x1
+#define EEP_ANTENNA_AUX		0x2
+#define EEP_ANTINV		0x4
+
+/* Bits in EEP_OFS_RADIOCTL */
+#define EEP_RADIOCTL_ENABLE	0x80
+
 #ifndef RUN_AT
 #define RUN_AT(x)                       (jiffies+(x))
 #endif
diff --git a/drivers/staging/vt6656/srom.h b/drivers/staging/vt6656/srom.h
deleted file mode 100644
index ce61ab4..0000000
--- a/drivers/staging/vt6656/srom.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- * Copyright (c) 1996, 2003 VIA Networking Technologies, Inc.
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
- *
- * File: srom.h
- *
- * Purpose: Implement functions to access eeprom
- *
- * Author: Jerry Chen
- *
- * Date: Jan 29, 2003
- *
- */
-
-#ifndef __SROM_H__
-#define __SROM_H__
-
-#define EEP_MAX_CONTEXT_SIZE    256
-
-//
-// Contents in the EEPROM
-//
-#define EEP_OFS_PAR         0x00        // physical address
-#define EEP_OFS_ANTENNA     0x17
-#define EEP_OFS_RADIOCTL    0x18
-#define EEP_OFS_RFTYPE      0x1B        // for select RF
-#define EEP_OFS_MINCHANNEL  0x1C        // Min Channel #
-#define EEP_OFS_MAXCHANNEL  0x1D        // Max Channel #
-#define EEP_OFS_SIGNATURE   0x1E        //
-#define EEP_OFS_ZONETYPE    0x1F        //
-#define EEP_OFS_RFTABLE     0x20        // RF POWER TABLE
-#define EEP_OFS_PWR_CCK     0x20
-#define EEP_OFS_SETPT_CCK   0x21
-#define EEP_OFS_PWR_OFDMG   0x23
-
-#define EEP_OFS_CALIB_TX_IQ 0x24
-#define EEP_OFS_CALIB_TX_DC 0x25
-#define EEP_OFS_CALIB_RX_IQ 0x26
-
-#define EEP_OFS_MAJOR_VER 0x2E
-#define EEP_OFS_MINOR_VER 0x2F
-
-#define EEP_OFS_CCK_PWR_TBL     0x30
-#define EEP_OFS_OFDM_PWR_TBL    0x40
-#define EEP_OFS_OFDMA_PWR_TBL   0x50
-
-//
-// Bits in EEP_OFS_ANTENNA
-//
-#define EEP_ANTENNA_MAIN    0x01
-#define EEP_ANTENNA_AUX     0x02
-#define EEP_ANTINV          0x04
-
-//
-// Bits in EEP_OFS_RADIOCTL
-//
-#define EEP_RADIOCTL_ENABLE 0x80
-
-#endif /* __EEPROM_H__ */
-- 
1.9.1

