Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38023 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754325AbdHUREm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:42 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] nfc: st21nfca: constify i2c_device_id
Date: Mon, 21 Aug 2017 22:34:00 +0530
Message-Id: <1503335040-27101-9-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190456_295863_3E57F684)
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/st21nfca/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index cd1f7bf..1b34709 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -589,7 +589,7 @@ static int st21nfca_hci_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static struct i2c_device_id st21nfca_hci_i2c_id_table[] = {
+static const struct i2c_device_id st21nfca_hci_i2c_id_table[] = {
 	{ST21NFCA_HCI_DRIVER_NAME, 0},
 	{}
 };
-- 
2.7.4
