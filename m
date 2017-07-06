Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34915 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdGFQuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 12:50:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        sameo@linux.intel.com
Cc: linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: nxp-nci: constify acpi_device_id.
Date: Thu,  6 Jul 2017 22:20:00 +0530
Message-Id: <50b7d8e8b297f58a2db0e8fbcc13549666174245.1499359652.git.arvind.yadav.cs@gmail.com> (sfid-20170706_185052_645464_8B555C9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

acpi_device_id are not supposed to change at runtime. All functions
working with acpi_device_id provided by <acpi/acpi_bus.h> work with
const acpi_device_id. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2208	    400	      0	   2608	    a30	drivers/nfc/nxp-nci/i2c.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
   2272	    336	      0	   2608	    a30	drivers/nfc/nxp-nci/i2c.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index ff22d76..35d4fc5 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -407,7 +407,7 @@ static const struct of_device_id of_nxp_nci_i2c_match[] = {
 MODULE_DEVICE_TABLE(of, of_nxp_nci_i2c_match);
 
 #ifdef CONFIG_ACPI
-static struct acpi_device_id acpi_id[] = {
+static const struct acpi_device_id acpi_id[] = {
 	{ "NXP7471" },
 	{ },
 };
-- 
2.7.4
