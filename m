Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34082 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754274AbdHUREf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:35 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] nfc: s3fwrn5: constify i2c_device_id
Date: Mon, 21 Aug 2017 22:33:58 +0530
Message-Id: <1503335040-27101-7-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190507_224847_4153305E)
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 3f09d7f..4da409e 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -276,7 +276,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id s3fwrn5_i2c_id_table[] = {
+static const struct i2c_device_id s3fwrn5_i2c_id_table[] = {
 	{S3FWRN5_I2C_DRIVER_NAME, 0},
 	{}
 };
-- 
2.7.4
