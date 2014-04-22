Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153AbaDVPZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:25:08 -0400
Date: Tue, 22 Apr 2014 17:25:05 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: microread: Platform data header file clean-ups
Message-ID: <20140422172505.25e3dacf@endymion.delvare> (sfid-20140422_172513_517773_06E0E979)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several clean-ups related to include/linux/platform_data/microread.h:
* Fix device name in comment.
* Don't include <linux/i2c.h> as it isn't needed.
* Include this header file from drivers/nfc/microread/i2c.c as that
  file uses struct microread_nfc_platform_data.
* Add this header file to the NFC entry in MAINTAINERS.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
That being said, the header file in question only declares struct
microread_nfc_platform_data, which is only used in
drivers/nfc/microread/i2c.c, and that piece of code doesn't access a
single field of the structure. So I am wondering if this struct and
header file are needed at all in the first place?

 MAINTAINERS                             |    1 +
 drivers/nfc/microread/i2c.c             |    1 +
 include/linux/platform_data/microread.h |    4 +---
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-3.15-rc2.orig/include/linux/platform_data/microread.h	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc2/include/linux/platform_data/microread.h	2014-04-22 17:12:06.702561202 +0200
@@ -1,5 +1,5 @@
 /*
- * Driver include for the PN544 NFC chip.
+ * Driver include for the Inside Secure microread NFC chip.
  *
  * Copyright (C) 2011 Tieto Poland
  * Copyright (C) 2012 Intel Corporation. All rights reserved.
@@ -21,8 +21,6 @@
 #ifndef _MICROREAD_H
 #define _MICROREAD_H
 
-#include <linux/i2c.h>
-
 #define MICROREAD_DRIVER_NAME	"microread"
 
 /* board config platform data for microread */
--- linux-3.15-rc2.orig/MAINTAINERS	2014-04-22 14:51:09.025285048 +0200
+++ linux-3.15-rc2/MAINTAINERS	2014-04-22 17:12:33.909132651 +0200
@@ -6204,6 +6204,7 @@ F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
 F:	include/linux/platform_data/pn544.h
+F:	include/linux/platform_data/microread.h
 F:	Documentation/devicetree/bindings/net/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
--- linux-3.15-rc2.orig/drivers/nfc/microread/i2c.c	2014-04-22 16:56:23.385837875 +0200
+++ linux-3.15-rc2/drivers/nfc/microread/i2c.c	2014-04-22 17:14:06.962088154 +0200
@@ -26,6 +26,7 @@
 #include <linux/gpio.h>
 
 #include <linux/nfc.h>
+#include <linux/platform_data/microread.h>
 #include <net/nfc/hci.h>
 #include <net/nfc/llc.h>
 


-- 
Jean Delvare
SUSE L3 Support
