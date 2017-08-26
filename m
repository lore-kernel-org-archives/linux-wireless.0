Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37870 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdHZGZ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Aug 2017 02:25:59 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        tomas.winkler@intel.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] nfc: microread: mei: constify mei_cl_device_id
Date: Sat, 26 Aug 2017 11:55:41 +0530
Message-Id: <27f776943a6fd60e938b53673fba7562241ba1bd.1503728505.git.arvind.yadav.cs@gmail.com> (sfid-20170826_082630_439721_544A7658)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mei_cl_device_id are not supposed to change at runtime.
mei driver is working with const 'id_table'. So mark
the non-const mei_cl_device_id structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/microread/mei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index eb5eddf..70bf7a1 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -66,7 +66,7 @@ static int microread_mei_remove(struct mei_cl_device *cldev)
 	return 0;
 }
 
-static struct mei_cl_device_id microread_mei_tbl[] = {
+static const struct mei_cl_device_id microread_mei_tbl[] = {
 	{ MICROREAD_DRIVER_NAME, MEI_NFC_UUID, MEI_CL_VERSION_ANY},
 
 	/* required last entry */
-- 
2.7.4
