Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35083 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754077AbdHUREZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:25 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] nfc: nxp-nci: constify i2c_device_id
Date: Mon, 21 Aug 2017 22:33:55 +0530
Message-Id: <1503335040-27101-4-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190611_028735_97ECBB0C)
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 198585b..ba695e3 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -393,7 +393,7 @@ static int nxp_nci_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id nxp_nci_i2c_id_table[] = {
+static const struct i2c_device_id nxp_nci_i2c_id_table[] = {
 	{"nxp-nci_i2c", 0},
 	{}
 };
-- 
2.7.4
