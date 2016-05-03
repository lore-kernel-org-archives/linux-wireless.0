Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.hostsharing.net ([83.223.90.233]:57077 "EHLO
	mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbcECTlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 15:41:55 -0400
Message-Id: <a99f9851b2b0e26d0b8af41a16815d5e28beb217.1462285455.git.lukas@wunner.de> (sfid-20160503_214158_359711_D424D054)
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 3 May 2016 21:44:40 +0200
Subject: [PATCH] mwifiex: Drop unnecessary include pcieport_if.h
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This header file is only needed for drivers binding to a PCI bridge
device allocated by drivers/pci/pcie/portdrv_core.c. The mwifiex driver
doesn't do that nor use any symbols defined in pcieport_if.h.

Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 6fc2873..1ccd5ad 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -23,7 +23,6 @@
 #define	_MWIFIEX_PCIE_H
 
 #include    <linux/pci.h>
-#include    <linux/pcieport_if.h>
 #include    <linux/interrupt.h>
 
 #include    "main.h"
-- 
2.8.0.rc3

