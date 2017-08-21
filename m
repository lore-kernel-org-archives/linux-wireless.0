Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35122 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754253AbdHUREc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:32 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] nfc: pn544: constify i2c_device_id
Date: Mon, 21 Aug 2017 22:33:57 +0530
Message-Id: <1503335040-27101-6-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190541_713153_66787BF9)
In-Reply-To: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/nfc/pn544/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 4b14740..d0207f8 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -54,7 +54,7 @@
 #define PN544_HCI_I2C_LLC_MAX_SIZE	(PN544_HCI_I2C_LLC_LEN_CRC + 1 + \
 					 PN544_HCI_I2C_LLC_MAX_PAYLOAD)
 
-static struct i2c_device_id pn544_hci_i2c_id_table[] = {
+static const struct i2c_device_id pn544_hci_i2c_id_table[] = {
 	{"pn544", 0},
 	{}
 };
-- 
2.7.4
