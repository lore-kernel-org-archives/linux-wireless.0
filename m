Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbcAUIUW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 03:20:22 -0500
Date: Thu, 21 Jan 2016 09:20:12 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Eric Lapuyade <eric.lapuyade@intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: microread: Drop platform data header file
Message-ID: <20160121092012.0e0f73e1@endymion.delvare> (sfid-20160121_092026_746587_0B50B464)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Originally I only wanted to drop the unneeded inclusion of
<linux/i2c.h>, but then noticed that struct
microread_nfc_platform_data isn't actually used, and
MICROREAD_DRIVER_NAME is redefined in the only file where it is used,
so we can get rid of the header file and dead code altogether.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Eric Lapuyade <eric.lapuyade@intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Makes me wonder if this driver is used at all? I can't see any
instance in the kernel tree.

 MAINTAINERS                             |    1 
 drivers/nfc/microread/i2c.c             |    8 -------
 include/linux/platform_data/microread.h |   35 --------------------------------
 3 files changed, 44 deletions(-)

--- linux-4.5-rc0.orig/MAINTAINERS	2016-01-20 09:32:43.217162788 +0100
+++ linux-4.5-rc0/MAINTAINERS	2016-01-21 08:45:28.544988567 +0100
@@ -7561,7 +7561,6 @@ F:	net/nfc/
 F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
-F:	include/linux/platform_data/microread.h
 F:	include/linux/platform_data/nfcmrvl.h
 F:	include/linux/platform_data/nxp-nci.h
 F:	include/linux/platform_data/pn544.h
--- linux-4.5-rc0.orig/drivers/nfc/microread/i2c.c	2016-01-21 08:00:28.787349137 +0100
+++ linux-4.5-rc0/drivers/nfc/microread/i2c.c	2016-01-21 08:45:54.420569448 +0100
@@ -246,18 +246,10 @@ static int microread_i2c_probe(struct i2
 			       const struct i2c_device_id *id)
 {
 	struct microread_i2c_phy *phy;
-	struct microread_nfc_platform_data *pdata =
-		dev_get_platdata(&client->dev);
 	int r;
 
 	dev_dbg(&client->dev, "client %p\n", client);
 
-	if (!pdata) {
-		nfc_err(&client->dev, "client %p: missing platform data\n",
-			client);
-		return -EINVAL;
-	}
-
 	phy = devm_kzalloc(&client->dev, sizeof(struct microread_i2c_phy),
 			   GFP_KERNEL);
 	if (!phy)
--- linux-4.5-rc0.orig/include/linux/platform_data/microread.h	2016-01-21 08:00:28.787349137 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,35 +0,0 @@
-/*
- * Driver include for the Inside Secure microread NFC Chip.
- *
- * Copyright (C) 2011 Tieto Poland
- * Copyright (C) 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#ifndef _MICROREAD_H
-#define _MICROREAD_H
-
-#include <linux/i2c.h>
-
-#define MICROREAD_DRIVER_NAME	"microread"
-
-/* board config platform data for microread */
-struct microread_nfc_platform_data {
-	unsigned int rst_gpio;
-	unsigned int irq_gpio;
-	unsigned int ioh_gpio;
-};
-
-#endif /* _MICROREAD_H */

-- 
Jean Delvare
SUSE L3 Support
