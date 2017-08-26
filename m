Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33494 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdHZG0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Aug 2017 02:26:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        tomas.winkler@intel.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] nfc: pn544: mei: constify mei_cl_device_id
Date: Sat, 26 Aug 2017 11:56:04 +0530
Message-Id: <4ba05401d57ab830769ef411420efdd62fa3f883.1503728344.git.arvind.yadav.cs@gmail.com> (sfid-20170826_082630_742825_EF3ADC43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mei_cl_device_id are not supposed to change at runtime.
mei driver is working with const 'id_table'. So mark
the non-const mei_cl_device_id structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/pn544/mei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index ad57a8e..a6c2e9c 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -66,7 +66,7 @@ static int pn544_mei_remove(struct mei_cl_device *cldev)
 	return 0;
 }
 
-static struct mei_cl_device_id pn544_mei_tbl[] = {
+static const struct mei_cl_device_id pn544_mei_tbl[] = {
 	{ PN544_DRIVER_NAME, MEI_NFC_UUID, MEI_CL_VERSION_ANY},
 
 	/* required last entry */
-- 
2.7.4
