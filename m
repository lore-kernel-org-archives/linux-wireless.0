Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbYB2Px0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 10:53:26 -0500
Subject: [RFC] p54: spi driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Steffen Meyer <mey@iis.fraunhofer.de>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:04:01 +0100
Message-Id: <1204297442.3938.26.camel@johannes.berg> (sfid-20080229_155335_777774_BB3F5232)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a night of coding (literally!) I'm proud to present
an early version of a p54common/mac80211 based driver for
the N810 wireless chip.

It currently has many problems:
 * Calibration data upload isn't accepted, you don't have a
   MAC address or anything else.

 * Even if it accepted calibration data, p54common couldn't
   parse the PDR structures, especially not revision 3 of
   PDR_PRISM_PA_CAL_CURVE_DATA (PHASER_PA_CAL_METHOD), and
   even if it could parse it it wouldn't know how to use it.
   We need to look into umac or see how it communicates to
   figure that out, shouldn't be too hard (say, compared to
   making 802.11g work on a Broadcom chip...)

 * Hence, this version of the patch actually mangles some
   of the built-in PDA data to make p54common able to read it.
   That's obviously wrong, but it let me test the SPI code.

 * The driver says the firmware fails to boot the second time
   you ifup the device. That's a bug in the driver, I forgot
   to reinit the completion, will fix in a new version.

 * It seems to neither TX nor RX, probably because of the
   bogus calibration data or such, although it does seem to
   give TX status for TX attempts.

 * I don't know whether the TX code is correct, that is if
   the dma_regs structure really contains the memory address
   where the frame should be written to. I can probably see
   what to do by logging what umac does.

 * It relies on p54common to do the locking, which, sadly,
   is rather lacking (and the usb/pci drivers have problems
   with that too afaict.)

The only advantage is that the code is much cleaner than
cx3110x ;)


Michael (Buesch), can you see if enabling serial console with
0xFFFF (the "free fiasco firmware flasher") allows you to see
anything on the serial console? I don't have any more serial
cables to hook up, soldered both I had to routers... It would
be great to get complete frame dumps out of umac by making
cx3110x log all the data. Or maybe we should use debugfs and
a large buffer for that instead of printing out hex dumps? I
think it would be easier though to have the data available on
the development machine not on the N810 itself, although of
course usb-networking could be used for that.
Comments welcome, I have successfully made cx3110x print out
each command that umac hands to the firmware/chip so obviously
doing that is not a problem.

And for those who haven't looked into it in detail: umac is
something like p54common (the device management) and mac80211
(the MLME stuff) rolled into one. I think it means "upper MAC"
because the driver also talks about "lmac" when referring to
the firmware ("lower MAC"). Also umac is about the same size
as mac80211 (including mesh! plus crypto modules plus some...

To build mac80211, I modified compat (patch in separate mail)
to make it work with 2.6.21 (and not try to build PCI drivers
all the time!), the resulting modules can be loaded fine on
my N810 and seem to work. In order to load mac80211 you need
to have crypto support in the kernel. That isn't enabled in
the default N810 kernel (sigh), but I managed to build the
crypto code as an out of tree module in a way that in-kernel
code assumes crypto is not present while modules can use it
fine. I guess I should add an "N810" category to my homepage
and write about all this there.

Code-released-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/Kconfig  |   14 
 drivers/net/wireless/p54spi.c | 1311 ++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/p54spi.h |  141 ++++
 3 files changed, 1466 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/p54spi.c	2008-02-29 13:57:16.000000000 +0100
@@ -0,0 +1,1311 @@
+/*
+ * Copyright (C) 2003 Conexant Americas Inc. All Rights Reserved.
+ * Copyright (C) 2004, 2005, 2006 Nokia Corporation
+ * Copyright 2008	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/firmware.h>
+#include <linux/irq.h>
+#include <net/mac80211.h>
+#include <asm/arch/gpio.h>
+#include <asm/irq.h>
+#include <asm/hardware.h>
+#include <asm/arch/board.h>
+#include <asm/arch/board-nokia.h>
+
+#include "p54.h"
+#include "p54common.h"
+#include "p54spi.h"
+
+
+/* shamelessly copied from cx3110x (but modified) */
+static unsigned char umac_pda[] = {
+/* struct eeprom_pda_wrap */
+0x00,0x00,0x00,0x00,	/* magic */
+0x00,0x00,		/* pad */
+0x00,0x00,		/* eeprom_pda_data_wrap length */
+0x00,0x00,0x00,0x00,	/* arm opcode */
+
+/* actual PDR data */
+0x04,0x00,		/* len */
+0x01,0x00,		/* PDR_MANUFACTURING_PART_NUMBER */
+0x58,0x58,0x58,0x58,0x58,0x58,
+
+0x03,0x00,		/* len */
+0x03,0x00,		/* PDR_NIC_SERIAL_NUMBER */
+0x31,0x30,0x34,0x00,
+
+#if 0 /* bogus MAC address */
+0x04,0x00,		/* len */
+0x01,0x01,		/* PDR_MAC_ADDRESS */
+0x00,0x02,0xee,0xc0,0xff,0xee,
+#endif
+
+0x0b,0x00,		/* len */
+0x01,0x10,		/* PDR_INTERFACE_LIST */
+0x00,0x00,		/* role */
+0x1d,0x00,		/* if_id */
+0x02,0x08,		/* variant */
+0x01,0x00,		/* btm_compat */
+0xff,0x1f,		/* top_compat */
+0x00,0x00,		/* role */
+0x09,0x00,		/* if_id */
+0x01,0x00,		/* variant */
+0x01,0x00,		/* btm_compat */
+0x1f,0x00,		/* top_compat */
+
+0x03,0x00,		/* len */
+0x02,0x10,		/* PDR_HARDWARE_PLATFORM_COMPONENT_ID */
+0x03,0x20,0x00,0x43,
+
+#if 0 /* currently unused by p54common */
+0x06,0x00,		/* len */
+0x08,0x19,		/* PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED */
+0x01,0x00,0xb8,0x0b,0x80,0x00,0x70,0xfe,0x34,0x00,
+#endif
+
+0xae,0x01,		/* len */
+0x04,0x19,		/* PDR_PRISM_PA_CAL_CURVE_DATA */
+0x03,			/* revision 3! p54common can't handle that */
+0x00,			/* channels */
+0x07,			/* points per channel?? */
+0x00,			/* padding */
+0x6c,0x09,		/* 2412 MHz */
+0x0e,0x00,0x09,0x04,0x88,0x01,0x5f,0xea,0xe3,0xd5,0x56,0xfe,
+0x48,0x01,0x53,0xa8,0xef,0xad,0x5e,0xdd,0x04,0x01,0xb3,0x78,
+0x51,0x99,0xe3,0xc4,0xc4,0x00,0x14,0x5e,0x31,0x89,0x20,0xb5,
+0x84,0x00,0xf4,0x4d,0x25,0x79,0xb1,0xa5,0x40,0x00,0xb2,0x43,
+0x16,0x68,0x6e,0x95,0x00,0x00,0xe9,0x3d,0x08,0x58,0x20,0x86,
+0x71,0x09,		/* 2417 MHz */
+0x0e,0x00,0x09,0x04,0x74,0x01,0x5f,0xea,0xe4,0xc7,0x29,0xf3,
+0x34,0x01,0x65,0xa8,0x76,0xa5,0xe8,0xd2,0xf8,0x00,0xcf,0x7c,
+0x38,0x95,0xd0,0xc0,0xb8,0x00,0x48,0x60,0x26,0x85,0x3c,0xb1,
+0x7c,0x00,0xde,0x4f,0x1c,0x76,0xca,0xa2,0x3c,0x00,0x12,0x45,
+0x16,0x66,0x7e,0x93,0x00,0x00,0xd3,0x3e,0x10,0x57,0x28,0x85,
+0x76,0x09,		/* 2422 MHz */
+0x0d,0x00,0x09,0x04,0x90,0x01,0x09,0xe5,0xba,0xda,0xff,0xff,
+0x4c,0x01,0xa1,0x9c,0x8d,0xac,0xc0,0xdc,0x0c,0x01,0x2e,0x73,
+0x61,0x99,0x62,0xc5,0xc8,0x00,0xff,0x58,0x23,0x88,0x2a,0xb4,
+0x84,0x00,0xa7,0x49,0x14,0x77,0xb6,0xa3,0x44,0x00,0x0a,0x41,
+0x15,0x67,0x6d,0x94,0x00,0x00,0x8d,0x3b,0x17,0x56,0x2f,0x84,
+0x7b,0x09,		/* 2427 MHz */
+0x0d,0x00,0x09,0x04,0x84,0x01,0x46,0xea,0xde,0xd1,0xad,0xfa,
+0x44,0x01,0x4f,0xa7,0x6c,0xa8,0xec,0xd7,0x04,0x01,0x4b,0x79,
+0x42,0x96,0x16,0xc2,0xc4,0x00,0x97,0x5d,0x19,0x86,0x38,0xb2,
+0x80,0x00,0x12,0x4c,0x0b,0x75,0xc4,0xa1,0x40,0x00,0x41,0x42,
+0x15,0x65,0x7d,0x92,0x00,0x00,0x4b,0x3c,0x1e,0x55,0x36,0x83,
+0x80,0x09,		/* 2432 MHz */
+0x0d,0x00,0x09,0x04,0x78,0x01,0x5f,0xea,0xe4,0xc9,0x0f,0xf4,
+0x38,0x01,0xac,0xa7,0x96,0xa3,0xde,0xd1,0xfc,0x00,0x8a,0x7b,
+0x72,0x93,0x44,0xbf,0xbc,0x00,0xb5,0x5e,0x44,0x83,0x84,0xaf,
+0x7c,0x00,0x4e,0x4d,0x36,0x73,0x08,0xa0,0x40,0x00,0x49,0x43,
+0x40,0x64,0xb6,0x91,0x00,0x00,0xb0,0x3c,0x4a,0x54,0x70,0x82,
+0x85,0x09,		/* 2437 MHz */
+0x0c,0x00,0x09,0x04,0x8c,0x01,0x12,0xea,0x22,0xda,0xfe,0xff,
+0x4c,0x01,0x84,0xa6,0xf0,0xa9,0x49,0xda,0x08,0x01,0x2a,0x76,
+0xbc,0x95,0xea,0xc1,0xc8,0x00,0x3b,0x5b,0x7e,0x85,0xbe,0xb1,
+0x84,0x00,0x32,0x4a,0x5e,0x74,0x2b,0xa1,0x44,0x00,0xa7,0x40,
+0x6a,0x64,0xe4,0x91,0x00,0x00,0x95,0x3a,0x76,0x53,0xaa,0x81,
+0x8a,0x09,		/* 2442 MHz */
+0x0c,0x00,0x09,0x04,0x80,0x01,0x5f,0xea,0xac,0xd1,0x72,0xf9,
+0x40,0x01,0xe7,0xa7,0xf7,0xa4,0x2e,0xd4,0x00,0x01,0xf1,0x78,
+0xee,0x92,0xec,0xbe,0xc0,0x00,0xab,0x5c,0xa6,0x82,0x06,0xaf,
+0x80,0x00,0x9a,0x4b,0x88,0x72,0x70,0x9f,0x40,0x00,0x45,0x41,
+0x95,0x62,0x29,0x90,0x00,0x00,0x00,0x3b,0xa2,0x52,0xe2,0x80,
+0x8f,0x09,		/* 2447 MHz */
+0x0c,0x00,0x09,0x04,0x7c,0x01,0x56,0xea,0xf4,0xd1,0x3a,0xf9,
+0x3c,0x01,0xf4,0xa6,0x9e,0xa4,0xa8,0xd3,0xfc,0x00,0x70,0x78,
+0x7c,0x92,0x70,0xbe,0xc0,0x00,0xc4,0x5d,0x2e,0x83,0x75,0xaf,
+0x80,0x00,0x48,0x4c,0x06,0x73,0xd3,0x9f,0x40,0x00,0xb1,0x41,
+0x0c,0x63,0x8a,0x90,0x00,0x00,0x42,0x3b,0x10,0x53,0x42,0x81,
+0x94,0x09,		/* 2452 Mhz */
+0x0c,0x00,0x09,0x04,0x78,0x01,0x5f,0xea,0xe6,0xd1,0xfc,0xf8,
+0x38,0x01,0x52,0xa7,0x0e,0xa4,0xe3,0xd2,0xfc,0x00,0xff,0x7a,
+0x0e,0x93,0xf3,0xbe,0xbc,0x00,0xfb,0x5d,0xb0,0x82,0xe3,0xae,
+0x7c,0x00,0x6e,0x4c,0x84,0x72,0x42,0x9f,0x40,0x00,0x4f,0x42,
+0x81,0x63,0xec,0x90,0x00,0x00,0xa2,0x3b,0x7e,0x53,0xa2,0x81,
+0x99,0x09,		/* 2457 MHz */
+0x0c,0x00,0x09,0x04,0x74,0x01,0xb7,0xe9,0x81,0xd1,0xb9,0xf8,
+0x38,0x01,0xf7,0xa8,0x0f,0xa5,0x12,0xd4,0xf8,0x00,0xc9,0x79,
+0x9b,0x92,0x73,0xbe,0xbc,0x00,0xae,0x5e,0x38,0x83,0x50,0xaf,
+0x7c,0x00,0xdf,0x4c,0x02,0x73,0xa5,0x9f,0x40,0x00,0x97,0x42,
+0xf8,0x63,0x4e,0x91,0x00,0x00,0xce,0x3b,0xec,0x53,0x01,0x82,
+0x9e,0x09,		/* 2462 MHz */
+0x0c,0x00,0x09,0x04,0x78,0x01,0x5f,0xea,0x71,0xd3,0x22,0xfa,
+0x38,0x01,0x8d,0xa8,0x16,0xa4,0x13,0xd3,0xf8,0x00,0x8a,0x79,
+0xea,0x91,0xdb,0xbd,0xbc,0x00,0x86,0x5e,0x84,0x82,0xba,0xae,
+0x7c,0x00,0xc5,0x4c,0x4a,0x72,0x10,0x9f,0x40,0x00,0x86,0x42,
+0x3a,0x63,0xb6,0x90,0x00,0x00,0xc1,0x3b,0x29,0x53,0x68,0x81,
+0xa3,0x09,		/* 2467 MHz */
+0x0c,0x00,0x09,0x04,0x78,0x01,0x99,0xe9,0xa2,0xd1,0xeb,0xf8,
+0x3c,0x01,0x63,0xa9,0xc0,0xa4,0x25,0xd4,0xfc,0x00,0x0c,0x7a,
+0x42,0x92,0x44,0xbe,0xbc,0x00,0x71,0x5d,0xd0,0x81,0x24,0xae,
+0x7c,0x00,0x1c,0x4c,0x92,0x71,0x7a,0x9e,0x40,0x00,0x1a,0x42,
+0x7c,0x62,0x1f,0x90,0x00,0x00,0x7e,0x3b,0x66,0x52,0xd0,0x80,
+0xa8,0x09,		/* 2472 MHz */
+0x0c,0x00,0x09,0x04,0x7c,0x01,0xda,0xe9,0x74,0xd3,0x59,0xfa,
+0x3c,0x01,0x51,0xa6,0xb4,0xa3,0x17,0xd3,0x00,0x01,0x74,0x7a,
+0x9a,0x92,0xae,0xbe,0xc0,0x00,0xaf,0x5d,0x24,0x82,0x90,0xae,
+0x80,0x00,0x41,0x4c,0xdc,0x71,0xda,0x9e,0x40,0x00,0xaa,0x41,
+0xc0,0x61,0x88,0x8f,0x00,0x00,0x37,0x3b,0xa4,0x51,0x38,0x80,
+0xb4,0x09,		/* 2484 MHz */
+0x0c,0x00,0x01,0x02,0x7c,0x01,0x5f,0xea,0xb1,0xd2,0x3c,0x01,
+0x2f,0xa7,0xda,0xa3,0xfc,0x00,0xc1,0x7b,0xb8,0x91,0xbc,0x00,
+0x06,0x60,0x32,0x81,0x80,0x00,0x34,0x4f,0xe2,0x71,0x40,0x00,
+0x93,0x43,0xb6,0x61,0x00,0x00,0x26,0x3c,0x8c,0x51,
+/* Why is this shorter than the other entries? */
+
+/*
+ * This entry was massaged by me for p54common...
+ *
+ * Specifically, I changed the entries field and removed two
+ * bytes after the entries field. Also, I have no idea what
+ * the entries "between" the marked ones are, or do they
+ * belong to the other ones?
+ */
+0xa2,0x00,		/* len */
+0x03,0x19,		/* PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS */
+0x00,0x28,		/* pad, entries */
+0x6c,0x09,		/* 2412 MHz */
+0x14,0x14,0x34,0x01,0x34,0x01,
+0x34,0x01,
+0x34,0x01,0x20,0x01,0x13,0x01,
+0x12,0x01,
+0x04,0x01,0x2a,0x01,0x2a,0x01,
+0x71,0x09,		/* 2417 MHz */
+0x14,0x14,0x31,0x01,0x31,0x01,
+0x31,0x01,
+0x31,0x01,0x1e,0x01,0x10,0x01,
+0x0f,0x01,
+0x02,0x01,0x28,0x01,0x28,0x01,
+0x76,0x09,		/* 2422 MHz */
+0x14,0x14,0x34,0x01,0x34,0x01,
+0x34,0x01,
+0x34,0x01,0x21,0x01,0x13,0x01,
+0x12,0x01,
+0x05,0x01,0x2b,0x01,0x2b,0x01,
+0x7b,0x09,		/* 2427 MHz */
+0x14,0x14,0x39,0x01,0x39,0x01,
+0x39,0x01,
+0x39,0x01,0x26,0x01,0x18,0x01,
+0x17,0x01,
+0x0b,0x01,0x30,0x01,0x30,0x01,
+0x80,0x09,		/* 2432 MHz */
+0x14,0x14,0x3c,0x01,0x3c,0x01,
+0x3c,0x01,
+0x3c,0x01,0x28,0x01,0x1b,0x01,
+0x19,0x01,
+0x0e,0x01,0x32,0x01,0x32,0x01,
+0x85,0x09,		/* 2437 MHz */
+0x14,0x14,0x3e,0x01,0x3e,0x01,
+0x3e,0x01,
+0x3e,0x01,0x2b,0x01,0x1d,0x01,
+0x1c,0x01,
+0x10,0x01,0x34,0x01,0x34,0x01,
+0x8a,0x09,		/* 2442 MHz */
+0x14,0x14,0x3d,0x01,0x3d,0x01,
+0x3d,0x01,
+0x3d,0x01,0x2a,0x01,0x1c,0x01,
+0x1b,0x01,
+0x0f,0x01,0x33,0x01,0x33,0x01,
+0x8f,0x09,		/* 2447 MHz */
+0x14,0x14,0x38,0x01,0x38,0x01,
+0x38,0x01,
+0x38,0x01,0x25,0x01,0x17,0x01,
+0x16,0x01,
+0x0a,0x01,0x2d,0x01,0x2d,0x01,
+0x94,0x09,		/* 2452 MHz */
+0x14,0x14,0x2f,0x01,0x2f,0x01,
+0x2f,0x01,
+0x2f,0x01,0x1c,0x01,0x0f,0x01,
+0x0e,0x01,
+0x01,0x01,0x24,0x01,0x24,0x01,
+0x99,0x09,		/* 2457 MHz */
+0x14,0x14,0x29,0x01,0x29,0x01,
+0x29,0x01,
+0x29,0x01,0x16,0x01,0x08,0x01,
+0x07,0x01,
+0xfb,0x00,0x1e,0x01,0x1e,0x01,
+0x9e,0x09,		/* 2462 MHz */
+0x14,0x14,0x2a,0x01,0x2a,0x01,
+0x2a,0x01,
+0x2a,0x01,0x16,0x01,0x09,0x01,
+0x08,0x01,
+0xfb,0x00,0x1f,0x01,0x1f,0x01,
+0xa3,0x09,		/* 2467 MHz */
+0x14,0x14,0x2e,0x01,0x2e,0x01,
+0x2e,0x01,
+0x2e,0x01,0x1b,0x01,0x0d,0x01,
+0x0c,0x01,
+0x00,0x01,0x23,0x01,0x23,0x01,
+0xa8,0x09,		/* 2472 MHz */
+0x14,0x14,0x37,0x01,0x37,0x01,
+0x37,0x01,
+0x37,0x01,0x23,0x01,0x15,0x01,
+0x14,0x01,
+0x08,0x01,0x2c,0x01,0x2c,0x01,
+0xb4,0x09,		/* 2484 MHz */
+0x10,0x04,0x2f,0x01,0x2f,0x01,
+/* Why is this shorter than the other entries? */
+
+0x47,0x00,		/* len */
+0x06,0x19,		/* PDR_PRISM_ZIF_TX_IQ_CALIBRATION */
+0x6c,0x09,		/* 2412 MHz */
+0xda,0x03,0x05,0x00,0x41,0x00,0x00,0x01,
+0x71,0x09,		/* 2417 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0x00,0x01,
+0x76,0x09,		/* 2422 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0x00,0x01,
+0x7b,0x09,		/* 2427 MHz */
+0xd9,0x03,0x05,0x00,0x42,0x00,0xff,0x00,
+0x80,0x09,		/* 2432 MHz */
+0xd9,0x03,0x05,0x00,0x42,0x00,0xff,0x00,
+0x85,0x09,		/* 2437 MHz */
+0xd9,0x03,0x05,0x00,0x42,0x00,0xff,0x00,
+0x8a,0x09,		/* 2442 MHz */
+0xd8,0x03,0x05,0x00,0x42,0x00,0xff,0x00,
+0x8f,0x09,		/* 2447 MHz */
+0xd8,0x03,0x05,0x00,0x42,0x00,0xff,0x00,
+0x94,0x09,		/* 2452 MHz */
+0xd9,0x03,0x05,0x00,0x42,0x00,0xfe,0x00,
+0x99,0x09,		/* 2457 MHz */
+0xd9,0x03,0x05,0x00,0x42,0x00,0xfe,0x00,
+0x9e,0x09,		/* 2462 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0xfe,0x00,
+0xa3,0x09,		/* 2467 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0xfe,0x00,
+0xa8,0x09,		/* 2472 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0xfe,0x00,
+0xb4,0x09,		/* 2484 MHz */
+0xd9,0x03,0x05,0x00,0x41,0x00,0xfe,0x00,
+
+#if 0 /* currently unused by p54common */
+0x03,0x00,		/* len */
+0x08,0x10,		/* PDR_DEFAULT_COUNTRY */
+0x30,0x00,0x00,0x00,
+
+0x0d,0x00,		/* len */
+0x07,0x10,		/* PDR_COUNTRY_LIST */
+0x30,0x00,0x00,0x00,
+0x10,0x00,0x00,0x00,
+0x40,0x00,0x00,0x00,
+0x31,0x00,0x00,0x00,
+0x32,0x00,0x00,0x00,
+0x20,0x00,0x00,0x00,
+
+0x03,0x00,		/* len */
+0x00,0x11,		/* PDR_ANTENNA_GAIN */
+0x08,0x08,0x08,0x08,
+#endif
+
+0x02,0x00,		/* len */
+0x00,0x00,		/* PDR_END */
+0xa8,0xf5		/* bogus data */
+};
+
+
+static void p54spi_hw_reset(struct p54spi *priv)
+{
+	/* power down wlan chip */
+	omap_set_gpio_dataout(priv->conf.power_gpio, 0);
+
+	msleep(2);
+
+	/* power up wlan chip */
+	omap_set_gpio_dataout(priv->conf.power_gpio, 1);
+
+	msleep(300);
+}
+
+static void p54spi_disable_irq(struct p54spi *priv)
+{
+	disable_irq(OMAP_GPIO_IRQ(priv->conf.irq_gpio));
+}
+
+static int p54spi_read(struct p54spi *priv, u8 address,
+		       u8 * rx_buffer, u32 length)
+{
+	struct spi_transfer t[2];
+	struct spi_message m;
+	__le16 addrbuf;
+
+	addrbuf = cpu_to_le16(address << 8 | ADDR_READ_BIT_15);
+
+	spi_message_init(&m);
+	memset(t, 0, 2 * sizeof(struct spi_transfer));
+
+	t[0].cs_change = 0;
+	t[0].bits_per_word = 0;
+	t[0].speed_hz = 0;
+	t[0].tx_buf = &addrbuf;
+	t[0].rx_buf = NULL;
+	t[0].len = sizeof(addrbuf);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].cs_change = 0;
+	t[1].bits_per_word = 0;
+	t[1].speed_hz = 0;
+	t[1].tx_buf = NULL;
+	t[1].rx_buf = rx_buffer;
+	t[1].len = length;
+	spi_message_add_tail(&t[1], &m);
+
+	spi_sync(priv->spidev, &m);
+
+	return 0;
+}
+
+static int p54spi_write(struct p54spi *priv, u8 address,
+			u8 *tx_buffer, u32 length)
+{
+	struct spi_transfer t[3];
+	struct spi_message m;
+	__le16 addrbuf;
+
+	addrbuf = cpu_to_le16(address << 8);
+
+	spi_message_init(&m);
+	memset(t, 0, 3 * sizeof(struct spi_transfer));
+
+	t[0].cs_change = 0;
+	t[0].bits_per_word = 0;
+	t[0].speed_hz = 0;
+	t[0].tx_buf = &addrbuf;
+	t[0].rx_buf = NULL;
+	t[0].len = sizeof(addrbuf);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].cs_change = 0;
+	t[1].bits_per_word = 0;
+	t[1].speed_hz = 0;
+	t[1].tx_buf = tx_buffer;
+	t[1].rx_buf = NULL;
+	t[1].len = length;
+	spi_message_add_tail(&t[1], &m);
+
+	if (length % 2) {
+		__le16 last_word;
+
+		last_word = cpu_to_le16(tx_buffer[length - 1]);
+
+		t[2].cs_change = 0;
+		t[2].bits_per_word = 0;
+		t[2].speed_hz = 0;
+		t[2].tx_buf = &last_word;
+		t[2].rx_buf = NULL;
+		t[2].len = 2;
+
+		spi_message_add_tail(&t[2], &m);
+	}
+
+	spi_sync(priv->spidev, &m);
+
+	return 0;
+}
+
+static int p54spi_dma_read(struct p54spi *priv, u8 address,
+			   void *rx_buffer, unsigned int length)
+{
+	struct spi_transfer t[2];
+	struct spi_message m;
+	__le16 addrbuf;
+
+	if (length < priv->dma_threshold)
+		return p54spi_read(priv, address, rx_buffer, length);
+
+	addrbuf = cpu_to_le16(address << 8 | ADDR_READ_BIT_15);
+
+	spi_message_init(&m);
+	m.is_dma_mapped = 1;
+	memset(t, 0, 2 * sizeof(struct spi_transfer));
+
+	t[0].cs_change = 0;
+	t[0].bits_per_word = 0;
+	t[0].speed_hz = 0;
+	t[0].tx_buf = &addrbuf;
+	t[0].rx_buf = NULL;
+	t[0].len = sizeof(addrbuf);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].cs_change = 0;
+	t[1].bits_per_word = 0;
+	t[1].speed_hz = 0;
+	t[1].tx_buf = NULL;
+	t[1].rx_buf = rx_buffer;
+	t[1].tx_dma = 0;
+	t[1].rx_dma = virt_to_phys(rx_buffer);
+	t[1].len = length;
+	spi_message_add_tail(&t[1], &m);
+
+	spi_sync(priv->spidev, &m);
+
+	return 0;
+}
+
+static int p54spi_dma_write(struct p54spi *priv, u8 address,
+			    u8 *tx_buffer, unsigned int length)
+{
+	struct spi_transfer t[3];
+	struct spi_message m;
+	__le16 addrbuf;
+
+	if (length < priv->dma_threshold)
+		return p54spi_write(priv, address, tx_buffer, length);
+
+	addrbuf = cpu_to_le16(address << 8);
+
+	spi_message_init(&m);
+	m.is_dma_mapped = 1;
+	memset(t, 0, 3 * sizeof(struct spi_transfer));
+
+	t[0].cs_change = 0;
+	t[0].bits_per_word = 0;
+	t[0].speed_hz = 0;
+	t[0].tx_buf = &addrbuf;
+	t[0].rx_buf = NULL;
+	t[0].tx_dma = 0;
+	t[0].rx_dma = 0;
+	t[0].len = sizeof(addrbuf);
+	spi_message_add_tail(&t[0], &m);
+
+	/* Now we push the actual buffer */
+	t[1].cs_change = 0;
+	t[1].bits_per_word = 0;
+	t[1].speed_hz = 0;
+	t[1].tx_buf = tx_buffer;
+	t[1].rx_buf = NULL;
+	t[1].tx_dma = virt_to_phys(tx_buffer);
+	t[1].rx_dma = 0;
+	t[1].len = length;
+
+	spi_message_add_tail(&t[1], &m);
+
+	/* we may have to send an odd-length frame */
+	if (length % 2) {
+		__le16 last_word;
+
+		last_word = cpu_to_le16(tx_buffer[length - 1]);
+
+		t[2].cs_change = 0;
+		t[2].bits_per_word = 0;
+		t[2].speed_hz = 0;
+		t[2].tx_buf = &last_word;
+		t[2].rx_buf = NULL;
+		t[2].tx_dma = 0;
+		t[2].rx_dma = 0;
+		t[2].len = 2;
+		spi_message_add_tail(&t[2], &m);
+	}
+
+	spi_sync(priv->spidev, &m);
+
+	return 0;
+}
+
+static int p54spi_init(struct p54spi *priv)
+{
+	int err;
+
+	err = omap_request_gpio(priv->conf.power_gpio);
+	if (err) {
+		dev_err(priv->dev, "power GPIO (%d) request failed: %d\n",
+			priv->conf.power_gpio, err);
+		return err;
+	}
+
+	err = omap_request_gpio(priv->conf.irq_gpio);
+	if (err) {
+		dev_err(priv->dev, "irq GPIO (%d) request failed: %d\n",
+			priv->conf.irq_gpio, err);
+		omap_free_gpio(priv->conf.power_gpio);
+		return err;
+	}
+
+	omap_set_gpio_direction(priv->conf.power_gpio, 0);
+
+	omap_set_gpio_direction(priv->conf.irq_gpio, 1);
+
+	p54spi_hw_reset(priv);
+
+	return 0;
+}
+
+static void p54spi_uninit(struct p54spi *priv)
+{
+	omap_free_gpio(priv->conf.power_gpio);
+	omap_free_gpio(priv->conf.irq_gpio);
+}
+
+struct p54spi_reg_s {
+	u16 address;
+	u16 length;
+	char *name;
+};
+
+static const struct p54spi_reg_s wlan_registers_array[] = {
+	{ SPI_ADRS_ARM_INTERRUPTS,	32, "ARM_INT     " },
+	{ SPI_ADRS_ARM_INT_EN,		32, "ARM_INT_ENA " },
+	{ SPI_ADRS_HOST_INTERRUPTS,	32, "HOST_INT    " },
+	{ SPI_ADRS_HOST_INT_EN,		32, "HOST_INT_ENA" },
+	{ SPI_ADRS_HOST_INT_ACK,	32, "HOST_INT_ACK" },
+	{ SPI_ADRS_GEN_PURP_1,		32, "GP1_COMM    " },
+	{ SPI_ADRS_GEN_PURP_2,		32, "GP2_COMM    " },
+	{ SPI_ADRS_DEV_CTRL_STAT,	32, "DEV_CTRL_STA" },
+	{ SPI_ADRS_DMA_DATA,		16, "DMA_DATA    " },
+	{ SPI_ADRS_DMA_WRITE_CTRL,	16, "DMA_WR_CTRL " },
+	{ SPI_ADRS_DMA_WRITE_LEN,	16, "DMA_WR_LEN  " },
+	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_WR_BASE " },
+	{ SPI_ADRS_DMA_READ_CTRL,	16, "DMA_RD_CTRL " },
+	{ SPI_ADRS_DMA_READ_LEN,	16, "DMA_RD_LEN  " },
+	{ SPI_ADRS_DMA_WRITE_BASE,	32, "DMA_RD_BASE " }
+};
+
+static void p54spi_dump_register(struct p54spi *priv)
+{
+	uint16_t i;
+	__le16 buffer;
+
+	for (i = 0; i < ARRAY_SIZE(wlan_registers_array); i++) {
+		p54spi_read(priv, wlan_registers_array[i].address,
+			    (u8 *)&buffer,
+			    (wlan_registers_array[i].length) >> 3);
+
+		if (wlan_registers_array[i].length == 32)
+			printk(KERN_DEBUG "%s -> 0x%08x (32 bits)\n",
+			       wlan_registers_array[i].name, buffer);
+		else
+			printk(KERN_DEBUG "%s -> 0x%04x (16 bits)\n",
+			       wlan_registers_array[i].name, buffer);
+	}
+}
+
+static u8 p54spi_wait_bits(struct p54spi *priv, u8 reg, __le32 bits)
+{
+	int i;
+	__le32 buffer;
+
+	for (i = 0; i < 2000; i++) {
+		p54spi_read(priv, reg, (u8 *)&buffer, sizeof(buffer));
+
+		if ((buffer & bits) == bits)
+			return 1;
+
+		msleep(1);
+	}
+	return 0;
+}
+
+static int p54spi_wakeup(struct p54spi *priv)
+{
+	__le32 host_ints, host_ints_ack, target_ints;
+	unsigned long timeout;
+	int err, tries = 0;
+
+ again:
+	if (priv->device_state != DEVSTATE_ACTIVE) {
+		err = -1;
+		goto exit;
+	}
+
+	/* Here we wake the target up */
+	target_ints = cpu_to_le32(SPI_TARGET_INT_WAKEUP);
+	p54spi_write(priv, SPI_ADRS_ARM_INTERRUPTS,
+		     (u8 *)&target_ints, sizeof target_ints);
+
+	/* And wait for the READY interrupt */
+	timeout = jiffies + HZ;
+
+	p54spi_read(priv, SPI_ADRS_HOST_INTERRUPTS,
+		    (u8 *)&host_ints, sizeof(host_ints));
+
+	while (!(host_ints & cpu_to_le32(SPI_HOST_INT_READY))) {
+		if (time_after(jiffies, timeout)) {
+			if (tries < 3) {
+				tries++;
+				dev_warn(priv->dev,
+					 "Haven't got a READY interrupt"
+					 " from WAKEUP, trying again. "
+					 "(host_ints=0x%.8x, tries=%i)\n",
+					 le32_to_cpu(host_ints), tries);
+				goto again;
+			} else {
+				dev_err(priv->dev,
+					"Chip did not respond to "
+					"WAKEUP, it's dead. "
+					" Firmware crashed? "
+					"(host_ints=0x%x, tries=%i)\n",
+					le32_to_cpu(host_ints), tries);
+				priv->device_state = DEVSTATE_DEAD;
+				err = -1;
+				goto exit;
+			}
+		}
+		p54spi_read(priv, SPI_ADRS_HOST_INTERRUPTS,
+			    (u8 *)&host_ints, sizeof(host_ints));
+	}
+
+	host_ints_ack = cpu_to_le32(SPI_HOST_INT_READY);
+	p54spi_write(priv, SPI_ADRS_HOST_INT_ACK,
+		     (u8 *)&host_ints_ack, sizeof(host_ints_ack));
+
+	err = 0;
+
+	if (tries > 0)
+		dev_info(priv->dev,
+			 "chip woke up (host_ints=0x%x, tries=%i)\n",
+			 host_ints, tries);
+
+ exit:
+	return err;
+}
+
+static int p54spi_sleep(struct p54spi *priv)
+{
+	__le32 target_ints;
+
+	target_ints = cpu_to_le32(SPI_TARGET_INT_SLEEP);
+	p54spi_write(priv, SPI_ADRS_ARM_INTERRUPTS,
+		     (u8 *)&target_ints, sizeof target_ints);
+
+	return 0;
+}
+
+static void p54spi_reset(struct p54spi *priv)
+{
+	__le32 target_ints = cpu_to_le32(SPI_TARGET_INT_RDDONE);
+
+
+	p54spi_write(priv, SPI_ADRS_ARM_INTERRUPTS,
+		     (u8 *)&target_ints, sizeof(target_ints));
+
+	priv->device_state = DEVSTATE_DEAD;
+}
+
+static int p54spi_rx(struct p54spi *priv)
+{
+	struct sk_buff *skb;
+	__le16 lenbuf;
+	u16 length;
+	int err;
+
+	printk(KERN_DEBUG "p54spi_rx()\n");
+
+	err = p54spi_wakeup(priv);
+	if (err < 0)
+		return err;
+
+	/* dummy read to flush SPI DMA controller bug */
+	p54spi_read(priv, SPI_ADRS_GEN_PURP_1,
+		    (u8 *)&lenbuf, sizeof(lenbuf));
+
+	p54spi_read(priv, SPI_ADRS_DMA_DATA,
+		    (u8 *)&lenbuf, sizeof(lenbuf));
+
+	length = le16_to_cpu(lenbuf);
+
+	if (length == 0) {
+		dev_warn(priv->dev,
+			 "chip requested DMA rx transfer"
+			 " of a zero length frame\n");
+		return -EINVAL;
+	}
+
+	if (length > SPI_MAX_PACKET_SIZE)
+		length = SPI_MAX_PACKET_SIZE;
+
+	skb = dev_alloc_skb(SPI_MAX_PACKET_SIZE);
+
+	if (!skb) {
+		dev_warn(priv->dev, "failed to alloc RX skb!\n");
+		return -ENOMEM;
+	}
+
+	p54spi_dma_read(priv, SPI_ADRS_DMA_DATA,
+			skb_put(skb, length), length);
+
+	if (p54_rx(priv->hw, skb) == 0)
+		dev_kfree_skb(skb);
+
+	return 0;
+}
+
+static int p54spi_tx(struct p54spi *priv)
+{
+	__le32 host_ints, host_ints_ack;
+	unsigned long timeout;
+	int err;
+	struct sk_buff *skb;
+	struct s_dma_regs dma_regs;
+	struct p54_control_hdr *hdr;
+
+	while ((skb = skb_dequeue(&priv->txskbs))) {
+		/*
+		 * Firmware bug... The first few packets need to be
+		 * horribly delayed.
+		 */
+		if (priv->initial_packets < SPI_DELAY_THRESHOLD)
+			msleep(5);
+
+		priv->initial_packets++;
+
+		err = p54spi_wakeup(priv);
+		if (err < 0) {
+			err = -1;
+			goto exit;
+		}
+
+		hdr = (struct p54_control_hdr *)skb->data;
+
+		/* program DMA and transfer TX buffer */
+		dma_regs.cmd = cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE);
+		dma_regs.len = hdr->len;
+		dma_regs.addr = hdr->req_id;
+
+		p54spi_write(priv, SPI_ADRS_DMA_WRITE_CTRL,
+			     (u8 *)&dma_regs, sizeof(struct s_dma_regs));
+
+		p54spi_dma_write(priv, SPI_ADRS_DMA_DATA,
+				 skb->data, skb->len);
+
+		/* We wait for the DMA Ready interrupt */
+		timeout = jiffies + 2 * HZ;
+		p54spi_read(priv, SPI_ADRS_HOST_INTERRUPTS,
+			    (u8 *)&host_ints, sizeof(host_ints));
+		while (!(host_ints & cpu_to_le32(SPI_HOST_INT_WR_READY))) {
+			if (time_after(jiffies, timeout)) {
+				dev_warn(priv->dev,
+					 "Haven't got a WR_READY for DMA "
+					 "write. (firmware crashed?)\n");
+				err = -1;
+				goto exit;
+			}
+			p54spi_read(priv, SPI_ADRS_HOST_INTERRUPTS,
+				    (u8 *)&host_ints, sizeof(host_ints));
+		}
+
+		host_ints_ack = cpu_to_le32(SPI_HOST_INT_WR_READY);
+		p54spi_write(priv, SPI_ADRS_HOST_INT_ACK,
+			     (u8 *)&host_ints_ack, sizeof(host_ints_ack));
+
+		dev_kfree_skb(skb);
+	}
+
+ exit:
+	return err;
+}
+
+static void p54spi_wq(struct work_struct *work)
+{
+	struct p54spi *priv = container_of(work, struct p54spi, work);
+	__le32 host_ints, host_ints_en, host_ints_ack;
+	int err;
+
+	if (priv->disabled)
+		return;
+
+	p54spi_read(priv, SPI_ADRS_HOST_INTERRUPTS,
+		    (u8 *)&host_ints, sizeof(host_ints));
+
+	if (host_ints & cpu_to_le32(SPI_HOST_INT_READY)) {
+		host_ints_ack = cpu_to_le32(SPI_HOST_INT_READY);
+		p54spi_write(priv, SPI_ADRS_HOST_INT_ACK,
+			     (u8 *)&host_ints_ack, sizeof(host_ints_ack));
+
+		if (priv->upload_state == UPLOAD_STATE_BOOTING) {
+			priv->upload_state = UPLOAD_STATE_RUNNING;
+
+			host_ints_en = cpu_to_le32(SPI_HOST_INT_UPDATE |
+						   SPI_HOST_INT_SW_UPDATE);
+			p54spi_write(priv, SPI_ADRS_HOST_INT_EN,
+				     (u8 *)&host_ints_en,
+				     sizeof(host_ints_en));
+
+			/* Now we can wake up the start() function... */
+			complete(&priv->boot_completion);
+		}
+	}
+
+	if (unlikely(priv->device_state == DEVSTATE_RESETTING)) {
+		p54spi_reset(priv);
+		goto exit;
+	}
+
+	/* Check if LMAC has rx frame */
+	if ((host_ints & cpu_to_le32(SPI_HOST_INT_UPDATE)) ||
+	    (host_ints & cpu_to_le32(SPI_HOST_INT_SW_UPDATE))) {
+		host_ints_ack = cpu_to_le32(SPI_HOST_INT_UPDATE |
+					    SPI_HOST_INT_SW_UPDATE);
+		p54spi_write(priv, SPI_ADRS_HOST_INT_ACK,
+			     (u8 *)&host_ints_ack, sizeof(host_ints_ack));
+
+		err = p54spi_rx(priv);
+		if (err < 0)
+			goto exit;
+	}
+
+	err = p54spi_tx(priv);
+	if (err < 0)
+		goto exit;
+
+ exit:
+	p54spi_sleep(priv);
+
+	return;
+}
+
+static struct p54spi_firmware_file {
+	u8 chip_type;
+	/* Chip's manufacturer name */
+	u8 *name;
+	/* LMAC name */
+	u8 *lm;
+} firmware_array[] = {
+	/* STLC4370, aka gen2.1 */
+	{ 0x21, "STLC4370", "3825.arm" },
+	/* STLC4550, aka gen2.5 */
+	{ 0x25, "STLC4550", "3826.arm" },
+	/* Default to STLC4370 */
+	{ 0x0, "Unknown", "3825.arm" },
+};
+
+static u8 *p54spi_firmware_name(u8 chip_type)
+{
+	int i = 0;
+
+	while (firmware_array[i].chip_type) {
+		if (firmware_array[i].chip_type == chip_type)
+			return firmware_array[i].lm;
+		i++;
+	}
+
+	return NULL;
+
+}
+
+static int p54spi_fetch_firmware(struct p54spi *priv)
+{
+	const struct firmware *fw_entry = NULL;
+	int ret = 0;
+	char *fw_id = p54spi_firmware_name(priv->conf.chip_type);
+	unsigned long firmware_size;
+	u8 *firmware;
+
+	if (!fw_id)
+		return -EINVAL;
+
+	ret = request_firmware(&fw_entry, fw_id, priv->dev);
+	if (ret) {
+		dev_err(priv->dev,
+			"p54spi_fetch_firmware failed for '%s': %d\n",
+			fw_id, ret);
+		return ret;
+	}
+
+	firmware_size = fw_entry->size;
+
+	if (firmware_size % 4) {
+		dev_err(priv->dev,
+			"firmware '%s' size is not multiple of 32bit.\n",
+			fw_id);
+		ret = -EILSEQ; /* Illegal byte sequence  */ ;
+		goto err_out;
+	}
+
+	if (!firmware_size) {
+		dev_err(priv->dev,
+			"firmware '%s' is empty.\n", fw_id);
+		ret = -EILSEQ; /* Illegal byte sequence  */ ;
+		goto err_out;
+	}
+
+	firmware = kmalloc(firmware_size, GFP_KERNEL);
+
+	if (!firmware) {
+		dev_err(priv->dev,
+			"Couldn't allocate memory for firmware.\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	memcpy(firmware, fw_entry->data, firmware_size);
+
+	p54_parse_firmware(priv->hw, fw_entry);
+
+	priv->firmware_size = firmware_size;
+	priv->firmware = firmware;
+
+	return 0;
+ err_out:
+	release_firmware(fw_entry);
+	return ret;
+}
+
+static void p54spi_free(struct p54spi *priv)
+{
+	kfree(priv->firmware);
+	priv->firmware_size = 0;
+	priv->firmware = NULL;
+
+	p54_free_common(priv->hw);
+	ieee80211_free_hw(priv->hw);
+}
+
+static void p54spi_reset_device(struct p54spi *priv, unsigned boot)
+{
+	__le16 dev_reg;
+
+	/* We do the ROM boot */
+	if (boot)
+		dev_reg = cpu_to_le16(SPI_CTRL_STAT_HOST_OVERRIDE |
+				      SPI_CTRL_STAT_HOST_RESET |
+				      SPI_CTRL_STAT_RAM_BOOT);
+	else
+		dev_reg = cpu_to_le16(SPI_CTRL_STAT_HOST_OVERRIDE |
+				      SPI_CTRL_STAT_HOST_RESET |
+				      SPI_CTRL_STAT_START_HALTED);
+	p54spi_write(priv, SPI_ADRS_DEV_CTRL_STAT,
+		     (u8 *)&dev_reg, sizeof(dev_reg));
+
+#define TARGET_BOOT_SLEEP 50
+
+	msleep(TARGET_BOOT_SLEEP);
+
+	if (boot)
+		dev_reg = cpu_to_le16(SPI_CTRL_STAT_HOST_OVERRIDE |
+				      SPI_CTRL_STAT_RAM_BOOT);
+	else
+		dev_reg = cpu_to_le16(SPI_CTRL_STAT_HOST_OVERRIDE |
+				      SPI_CTRL_STAT_START_HALTED);
+
+	p54spi_write(priv, SPI_ADRS_DEV_CTRL_STAT,
+		     (u8 *)&dev_reg, sizeof(dev_reg));
+
+	msleep(TARGET_BOOT_SLEEP);
+
+#undef TARGET_BOOT_SLEEP
+}
+
+static irqreturn_t p54spi_interrupt(int irq, void *data)
+{
+	struct p54spi *priv = data;
+
+	/* FIXME: move state check to workqueue */
+	if (priv->device_state == DEVSTATE_ACTIVE
+	    || priv->device_state == DEVSTATE_BOOTING)
+		queue_work(priv->hw->workqueue, &priv->work);
+
+	return IRQ_HANDLED;
+}
+
+static int p54spi_request_irq(struct p54spi *priv)
+{
+	int ret;
+
+	/* Install interrupt handler */
+	ret = request_irq(OMAP_GPIO_IRQ(priv->conf.irq_gpio),
+			  p54spi_interrupt, SA_INTERRUPT,
+			  "p54spi", priv);
+
+	if (ret < 0) {
+		dev_err(priv->dev,
+			"could not install IRQ-handler: %d.\n",
+			ret);
+		return ret;
+	}
+
+	set_irq_type(OMAP_GPIO_IRQ(priv->conf.irq_gpio), IRQT_RISING);
+
+	return ret;
+}
+
+static int p54spi_upload_firmware(struct p54spi *priv)
+{
+	struct s_dma_regs dma_regs;
+	u32 fw_len, address = FIRMWARE_ADDRESS;
+	__le32 host_reg;
+	uint8_t *fw_buffer;
+
+	fw_len = priv->firmware_size;
+	fw_buffer = priv->firmware;
+
+	if (fw_len == 0)
+		return -EINVAL;
+
+	/* Stop device */
+	p54spi_reset_device(priv, 0);
+
+	while (fw_len > 0) {
+		u32 _fw_len =
+		    (fw_len > SPI_MAX_PACKET_SIZE) ?
+		    SPI_MAX_PACKET_SIZE : fw_len;
+
+		dma_regs.cmd = cpu_to_le16(SPI_DMA_WRITE_CTRL_ENABLE);
+		dma_regs.len = cpu_to_le16(_fw_len);
+		dma_regs.addr = cpu_to_le32(address);
+
+		fw_len -= _fw_len;
+		address += _fw_len;
+
+		p54spi_write(priv, SPI_ADRS_DMA_WRITE_CTRL,
+			     (u8 *) (&dma_regs.cmd), sizeof(short));
+		if (!p54spi_wait_bits(priv, SPI_ADRS_DMA_WRITE_CTRL,
+				      cpu_to_le32(HOST_ALLOWED))) {
+			dev_warn(priv->dev,
+				 "fw upload not allowed to DMA write.\n");
+			p54spi_dump_register(priv);
+			return -EAGAIN;
+		}
+
+		p54spi_write(priv, SPI_ADRS_DMA_WRITE_LEN,
+			     (u8 *) (&dma_regs.len), sizeof(short));
+		p54spi_write(priv, SPI_ADRS_DMA_WRITE_BASE,
+			     (u8 *) (&dma_regs.addr), sizeof(long));
+
+		p54spi_dma_write(priv, SPI_ADRS_DMA_DATA, fw_buffer, _fw_len);
+	}
+
+	BUG_ON(fw_len != 0);
+
+	/* Enable host interrupts */
+	host_reg = cpu_to_le32(SPI_HOST_INTS_DEFAULT);
+	p54spi_write(priv, SPI_ADRS_HOST_INT_EN,
+		     (u8 *)&host_reg, sizeof(host_reg));
+
+	/* Boot device */
+	p54spi_reset_device(priv, 1);
+
+	return 0;
+}
+
+static void p54spi_free_irq(struct p54spi *priv)
+{
+	free_irq(OMAP_GPIO_IRQ(priv->conf.irq_gpio), priv);
+}
+
+static int p54spi_ops_open(struct ieee80211_hw *hw)
+{
+	struct p54spi *priv = hw->priv;
+	int err;
+	unsigned long timeout;
+
+	err = p54spi_init(priv);
+	if (err) {
+		dev_err(priv->dev, "failed to init: %d.\n", err);
+		goto out;
+	}
+
+	priv->device_state = DEVSTATE_BOOTING;
+
+	err = p54spi_request_irq(priv);
+	if (err) {
+		dev_err(priv->dev, "failed to request irq: %d.\n", err);
+		goto out_uninit;
+	}
+
+	priv->disabled = false;
+
+	err = p54spi_upload_firmware(priv);
+	if (err) {
+		dev_err(priv->dev, "failed to load firmware: %d.\n", err);
+		goto out_free_irq;
+	}
+
+	/* Wait for boot, but at most two seconds */
+	timeout = msecs_to_jiffies(2000);
+	timeout = wait_for_completion_interruptible_timeout(
+			&priv->boot_completion, timeout);
+
+	if (!timeout) {
+		dev_err(priv->dev, "failed to boot\n");
+		err = -EBUSY;
+		goto out_free_irq;
+	}
+
+	priv->device_state = DEVSTATE_ACTIVE;
+
+	return 0;
+
+ out_free_irq:
+	priv->disabled = true;
+	p54spi_free_irq(priv);
+ out_uninit:
+	p54spi_uninit(priv);
+ out:
+	return err;
+}
+
+static void p54spi_ops_stop(struct ieee80211_hw *hw)
+{
+	struct p54spi *priv = hw->priv;
+	__le32 host_reg = 0;
+
+	priv->disabled = true;
+	priv->initial_packets = 0;
+
+	p54spi_write(priv, SPI_ADRS_HOST_INT_EN,
+		     (u8 *)&host_reg, sizeof(host_reg));
+
+	p54spi_disable_irq(priv);
+
+	p54spi_reset_device(priv, 0);
+
+	p54spi_free_irq(priv);
+	p54spi_uninit(priv);
+}
+
+static void p54spi_ops_tx(struct ieee80211_hw *hw,
+			  struct p54_control_hdr *data,
+			  size_t len, int free_on_tx)
+{
+	struct p54spi *priv = hw->priv;
+	struct sk_buff *skb = dev_alloc_skb(len);
+
+	if (!skb) {
+		/* this is really bad if free_on_tx is false! */
+		printk(KERN_ERR "OWW! failed to alloc skb! BAD!\n");
+		return;
+	}
+
+	memcpy(skb_put(skb, len), data, len);
+
+	if (free_on_tx)
+		kfree(data);
+
+	skb_queue_tail(&priv->txskbs, skb);
+
+	queue_work(priv->hw->workqueue, &priv->work);
+}
+
+
+#define WLAN_SPI_FREQ    24000000
+static int __devinit p54spi_driver_probe(struct spi_device *spi)
+{
+	struct p54spi *priv;
+	struct ieee80211_hw *hw;
+	const struct omap_wlan_cx3110x_config *conf;
+	int err;
+
+	spi->mode = SPI_MODE_1;
+	spi->bits_per_word = 16;
+	spi->max_speed_hz = WLAN_SPI_FREQ;
+
+	spi_setup(spi);
+
+	hw = p54_init_common(sizeof(*priv));
+	if (!hw)
+		return -ENOMEM;
+
+	priv = hw->priv;
+	priv->hw = hw;
+	priv->dev = &spi->dev;
+	priv->spidev = spi;
+
+	spi_set_drvdata(spi, priv);
+
+	conf = omap_get_config(OMAP_TAG_WLAN_CX3110X,
+			       struct omap_wlan_cx3110x_config);
+
+	/* With some old N770 bootloaders, the chip type is not set */
+	if (conf == NULL || ((conf->chip_type != 0x21) &&
+			     (conf->chip_type != 0x25))) {
+		priv->conf.chip_type = 0x21;
+		priv->conf.power_gpio = 59;
+		priv->conf.irq_gpio = 36;
+		priv->conf.spi_cs_gpio = 21;
+	} else {
+		memcpy(&priv->conf, conf, sizeof(*conf));
+	}
+
+	priv->common.open = p54spi_ops_open;
+	priv->common.stop = p54spi_ops_stop;
+	priv->common.tx = p54spi_ops_tx;
+
+	skb_queue_head_init(&priv->txskbs);
+
+	init_completion(&priv->boot_completion);
+
+	INIT_WORK(&priv->work, p54spi_wq);
+
+	SET_IEEE80211_DEV(hw, &spi->dev);
+
+	err = p54_parse_eeprom(hw, umac_pda, sizeof(umac_pda));
+	if (err) {
+		p54spi_free(priv);
+		return err;
+	}
+
+	err = p54spi_fetch_firmware(priv);
+	if (err) {
+		p54spi_free(priv);
+		return err;
+	}
+
+	err = ieee80211_register_hw(priv->hw);
+	if (err) {
+		p54spi_free(priv);
+		return err;
+	}
+
+	return 0;
+}
+
+static int __devexit p54spi_driver_remove(struct spi_device *spi)
+{
+	struct p54spi *priv = spi_get_drvdata(spi);
+
+	ieee80211_unregister_hw(priv->hw);
+
+	p54spi_free(priv);
+
+	return 0;
+}
+
+static struct spi_driver p54spi_driver = {
+	.driver = {
+		/*
+		 * Yes, the SPI bus hardcodes device/driver names...
+		 * I love device trees how it works on powerpc.
+		 */
+		.name = "cx3110x",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+
+	.probe = p54spi_driver_probe,
+	.remove = __devexit_p(p54spi_driver_remove),
+};
+
+static int __init p54spi_init_module(void)
+{
+	return spi_register_driver(&p54spi_driver);
+}
+
+static void __exit p54spi_cleanup_module(void)
+{
+	spi_unregister_driver(&p54spi_driver);
+}
+
+MODULE_DESCRIPTION("WLAN driver for Nokia N810");
+MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>");
+MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
+MODULE_LICENSE("GPL v2");
+
+module_init(p54spi_init_module);
+module_exit(p54spi_cleanup_module);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/drivers/net/wireless/p54spi.h	2008-02-29 13:57:16.000000000 +0100
@@ -0,0 +1,141 @@
+/*
+ * Copyright (C) 2003 Conexant Americas Inc. All Rights Reserved.
+ * Copyright (C) 2004, 2005, 2006 Nokia Corporation
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __P54SPI
+#define __P54SPI
+
+#include <linux/workqueue.h>
+#include <asm/arch/board-nokia.h>
+#include "p54.h"
+#include "p54common.h"
+
+enum p54spi_device_state {
+	DEVSTATE_IDLE,
+	DEVSTATE_BOOTING,
+	DEVSTATE_ACTIVE,
+	DEVSTATE_DEAD,
+	DEVSTATE_RESETTING,
+};
+
+enum p54spi_upload_state {
+	UPLOAD_STATE_BOOTING,
+	UPLOAD_STATE_RUNNING,
+};
+
+struct p54spi {
+	/* common must be first! */
+	struct p54_common common;
+	struct device *dev;
+	struct completion boot_completion;
+	struct spi_device *spidev;
+	struct ieee80211_hw *hw;
+	struct omap_wlan_cx3110x_config conf;
+	struct sk_buff_head txskbs;
+
+	u8 *firmware;
+	unsigned long firmware_size;
+
+	int initial_packets;
+
+	u16 dma_threshold;
+	bool disabled;
+
+	enum p54spi_device_state device_state;
+	enum p54spi_upload_state upload_state;
+	struct work_struct work;
+};
+
+/* Bit 15 is read/write bit; ON = READ, OFF = WRITE */
+#define ADDR_READ_BIT_15		0x8000
+
+#define SPI_ADRS_ARM_INTERRUPTS		0x00
+#define SPI_ADRS_ARM_INT_EN		0x04
+
+#define SPI_ADRS_HOST_INTERRUPTS	0x08
+#define SPI_ADRS_HOST_INT_EN		0x0c
+#define SPI_ADRS_HOST_INT_ACK		0x10
+
+#define SPI_ADRS_GEN_PURP_1		0x14
+#define SPI_ADRS_GEN_PURP_2		0x18
+
+#define SPI_ADRS_DEV_CTRL_STAT		0x26	/* high word */
+
+#define SPI_ADRS_DMA_DATA		0x28
+
+#define SPI_ADRS_DMA_WRITE_CTRL		0x2c
+#define SPI_ADRS_DMA_WRITE_LEN		0x2e
+#define SPI_ADRS_DMA_WRITE_BASE		0x30
+
+#define SPI_ADRS_DMA_READ_CTRL		0x34
+#define SPI_ADRS_DMA_READ_LEN		0x36
+#define SPI_ADRS_DMA_READ_BASE		0x38
+
+#define SPI_CTRL_STAT_HOST_OVERRIDE	0x8000
+#define SPI_CTRL_STAT_START_HALTED	0x4000
+#define SPI_CTRL_STAT_RAM_BOOT		0x2000
+#define SPI_CTRL_STAT_HOST_RESET	0x1000
+#define SPI_CTRL_STAT_HOST_CPU_EN	0x0800
+
+#define SPI_DMA_WRITE_CTRL_ENABLE	0x0001
+#define SPI_DMA_READ_CTRL_ENABLE	0x0001
+#define HOST_ALLOWED			(1 << 7)
+
+#define FIRMWARE_ADDRESS		0x20000
+
+#define SPI_TIMEOUT			100	/* msec */
+
+#define SPI_MAX_TX_PACKETS		32
+
+#define SPI_MAX_PACKET_SIZE		32767
+
+#define SPI_TARGET_INT_WAKEUP		0x00000001
+#define SPI_TARGET_INT_SLEEP		0x00000002
+#define SPI_TARGET_INT_RDDONE		0x00000004
+
+#define SPI_TARGET_INT_CTS		0x00004000
+#define SPI_TARGET_INT_DR		0x00008000
+
+#define SPI_HOST_INT_READY		0x00000001
+#define SPI_HOST_INT_WR_READY		0x00000002
+#define SPI_HOST_INT_SW_UPDATE		0x00000004
+#define SPI_HOST_INT_UPDATE		0x10000000
+
+/* clear to send */
+#define SPI_HOST_INT_CTS		0x00004000
+
+/* data ready */
+#define SPI_HOST_INT_DR			0x00008000
+
+#define SPI_HOST_INTS_DEFAULT \
+	SPI_HOST_INT_READY | SPI_HOST_INT_UPDATE | SPI_HOST_INT_SW_UPDATE
+
+/*
+ * Structure definitions
+ */
+
+struct s_dma_regs {
+	__le16 cmd;
+	__le16 len;
+	__le32 addr;
+} __attribute__((packed));
+
+#define SPI_DELAY_THRESHOLD 6
+
+#endif				/* __P54SPI */
--- everything.orig/drivers/net/wireless/Kconfig	2008-02-29 13:57:29.000000000 +0100
+++ everything/drivers/net/wireless/Kconfig	2008-02-29 14:01:06.000000000 +0100
@@ -746,6 +746,20 @@ config P54_PCI
 
 	  If you choose to build a module, it'll be called p54pci.
 
+config P54_SPI
+	tristate "Prism54 SPI support
+	depends on P54_COMMON && SPI
+	# only Nokia N810 for now
+	depends on MACH_NOKIA_RX44
+	depends on BROKEN
+	help
+	  This driver is for SPI isl3825/isl3826 wireless cards.
+	  It is currently tested only on the Nokia N810 and doesn't
+	  even work there. This driver requires softmac firmware
+	  which ships on the N810 device.
+
+	  If you choose to build a module, it'll be called p54spi.
+
 source "drivers/net/wireless/ath5k/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"


