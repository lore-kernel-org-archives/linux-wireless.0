Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:60002 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1AGSsQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:48:16 -0500
Subject: [PATCH] ssb: Ignore dangling ethernet cores on wireless devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 19:48:05 +0100
Message-ID: <1294426085.18385.8.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some Broadcom based wireless devices contain dangling ethernet cores.
This triggers the ssb probing mechanism and tries to load the b44 driver
on this core.
Ignore the dangling core in the ssb core scanning code to avoid
access to the core and failure of b44 probing.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

---

Does not need to go into stable, because probing of that core
doesn't hurt except for failure messages in the logs.

Index: linux-2.6.37/drivers/ssb/scan.c
===================================================================
--- linux-2.6.37.orig/drivers/ssb/scan.c	2011-01-07 15:35:10.518000002 +0100
+++ linux-2.6.37/drivers/ssb/scan.c	2011-01-07 15:45:54.231998930 +0100
@@ -420,6 +420,16 @@
 			bus->pcicore.dev = dev;
 #endif /* CONFIG_SSB_DRIVER_PCICORE */
 			break;
+		case SSB_DEV_ETHERNET:
+			if (bus->bustype == SSB_BUSTYPE_PCI) {
+				if (bus->host_pci->vendor == PCI_VENDOR_ID_BROADCOM &&
+				    (bus->host_pci->device & 0xFF00) == 0x4300) {
+					/* This is a dangling ethernet core on a
+					 * wireless device. Ignore it. */
+					continue;
+				}
+			}
+			break;
 		default:
 			break;
 		}

-- 
Greetings Michael.

