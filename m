Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35912 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeGPODm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:42 -0400
Received: by mail-pf0-f195.google.com with SMTP id d14-v6so2539808pfo.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:13 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 2/6] rsi: remove redundant flash_content variable
Date: Mon, 16 Jul 2018 19:09:33 +0530
Message-Id: <1531748377-29215-3-git-send-email-siva8118@gmail.com> (sfid-20180716_153616_556308_551EDA8D)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

while cleaning up the driver, observed that flash_content pointer is not
necessary in rsi_load_firmware(). Instead of this, driver can use
'fw_entry->data' directly.Hence, removed redundant flash_content pointer.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 533d9e9..150c3e6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -842,7 +842,6 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 	const struct firmware *fw_entry = NULL;
 	u32 regout_val = 0, content_size;
 	u16 tmp_regout_val = 0;
-	u8 *flash_content = NULL;
 	struct ta_metadata *metadata_p;
 	int status;
 
@@ -904,28 +903,22 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 			__func__, metadata_p->name);
 		return status;
 	}
-	flash_content = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!flash_content) {
-		rsi_dbg(ERR_ZONE, "%s: Failed to copy firmware\n", __func__);
-		status = -EIO;
-		goto fail;
-	}
 	content_size = fw_entry->size;
 	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", content_size);
 
 	/* Get the firmware version */
 	common->lmac_ver.ver.info.fw_ver[0] =
-		flash_content[LMAC_VER_OFFSET] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET] & 0xFF;
 	common->lmac_ver.ver.info.fw_ver[1] =
-		flash_content[LMAC_VER_OFFSET + 1] & 0xFF;
-	common->lmac_ver.major = flash_content[LMAC_VER_OFFSET + 2] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET + 1] & 0xFF;
+	common->lmac_ver.major = fw_entry->data[LMAC_VER_OFFSET + 2] & 0xFF;
 	common->lmac_ver.release_num =
-		flash_content[LMAC_VER_OFFSET + 3] & 0xFF;
-	common->lmac_ver.minor = flash_content[LMAC_VER_OFFSET + 4] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET + 3] & 0xFF;
+	common->lmac_ver.minor = fw_entry->data[LMAC_VER_OFFSET + 4] & 0xFF;
 	common->lmac_ver.patch_num = 0;
 	rsi_print_version(common);
 
-	status = bl_write_header(adapter, flash_content, content_size);
+	status = bl_write_header(adapter, (u8 *)fw_entry->data, content_size);
 	if (status) {
 		rsi_dbg(ERR_ZONE,
 			"%s: RPS Image header loading failed\n",
@@ -967,7 +960,7 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 
 	rsi_dbg(INFO_ZONE, "Burn Command Pass.. Upgrading the firmware\n");
 
-	status = auto_fw_upgrade(adapter, flash_content, content_size);
+	status = auto_fw_upgrade(adapter, (u8 *)fw_entry->data, content_size);
 	if (status == 0) {
 		rsi_dbg(ERR_ZONE, "Firmware upgradation Done\n");
 		goto load_image_cmd;
@@ -981,13 +974,11 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 
 success:
 	rsi_dbg(ERR_ZONE, "***** Firmware Loading successful *****\n");
-	kfree(flash_content);
 	release_firmware(fw_entry);
 	return 0;
 
 fail:
 	rsi_dbg(ERR_ZONE, "##### Firmware loading failed #####\n");
-	kfree(flash_content);
 	release_firmware(fw_entry);
 	return status;
 }
-- 
2.5.5
