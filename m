Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37903 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbdHUREV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:21 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] nfc: nfcmrvl: constify i2c_device_id
Date: Mon, 21 Aug 2017 22:33:54 +0530
Message-Id: <1503335040-27101-3-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190629_156443_BF401CB1)
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/nfcmrvl/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index ffec103..0f22379 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -266,7 +266,7 @@ static const struct of_device_id of_nfcmrvl_i2c_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_nfcmrvl_i2c_match);
 
-static struct i2c_device_id nfcmrvl_i2c_id_table[] = {
+static const struct i2c_device_id nfcmrvl_i2c_id_table[] = {
 	{ "nfcmrvl_i2c", 0 },
 	{}
 };
-- 
2.7.4
