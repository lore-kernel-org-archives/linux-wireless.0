Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58616 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCXT2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 15:28:44 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/4 v2] ath10k:  better firmware loading error messages
Date: Mon, 24 Mar 2014 12:20:41 -0700
Message-Id: <1395688844-24640-2-git-send-email-greearb@candelatech.com> (sfid-20140324_202848_043835_9927EF03)
In-Reply-To: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user know the name of the board file if it is not
found, and make it easier to determine the firmware
api being used.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Incorporate Kalle's suggestions and sample code.

 drivers/net/wireless/ath/ath10k/core.c | 36 +++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 471c219..79c7d48 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -398,8 +398,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
 	if (IS_ERR(ar->firmware)) {
-		ath10k_err("Could not fetch firmware file '%s': %ld\n",
-			   name, PTR_ERR(ar->firmware));
+		ath10k_err("could not fetch firmware file '%s/%s': %ld\n",
+			   ar->hw_params.fw.dir, name, PTR_ERR(ar->firmware));
 		return PTR_ERR(ar->firmware);
 	}
 
@@ -410,14 +410,14 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
 
 	if (len < magic_len) {
-		ath10k_err("firmware image too small to contain magic: %zu\n",
-			   len);
+		ath10k_err("firmware file '%s/%s' too small to contain magic: %zu\n",
+			   ar->hw_params.fw.dir, name, len);
 		ret = -EINVAL;
 		goto err;
 	}
 
 	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
-		ath10k_err("Invalid firmware magic\n");
+		ath10k_err("invalid firmware magic\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -439,7 +439,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		data += sizeof(*hdr);
 
 		if (len < ie_len) {
-			ath10k_err("Invalid length for FW IE %d (%zu < %zu)\n",
+			ath10k_err("invalid length for FW IE %d (%zu < %zu)\n",
 				   ie_id, len, ie_len);
 			ret = -EINVAL;
 			goto err;
@@ -522,8 +522,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	}
 
 	if (!ar->firmware_data || !ar->firmware_len) {
-		ath10k_warn("No ATH10K_FW_IE_FW_IMAGE found from %s, skipping\n",
-			    name);
+		ath10k_warn("No ATH10K_FW_IE_FW_IMAGE found from '%s/%s', skipping\n",
+			    ar->hw_params.fw.dir, name);
 		ret = -ENOMEDIUM;
 		goto err;
 	}
@@ -540,7 +540,9 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 					 ar->hw_params.fw.board);
 	if (IS_ERR(ar->board)) {
 		ret = PTR_ERR(ar->board);
-		ath10k_err("could not fetch board data (%d)\n", ret);
+		ath10k_err("could not fetch board data '%s/%s' (%d)\n",
+			   ar->hw_params.fw.dir, ar->hw_params.fw.board,
+			   ret);
 		goto err;
 	}
 
@@ -558,19 +560,21 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 {
 	int ret;
 
+	ar->fw_api = 2;
+	ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+
 	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
-	if (ret == 0) {
-		ar->fw_api = 2;
-		goto out;
-	}
+	if (ret == 0)
+		goto success;
+
+	ar->fw_api = 1;
+	ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
 	ret = ath10k_core_fetch_firmware_api_1(ar);
 	if (ret)
 		return ret;
 
-	ar->fw_api = 1;
-
-out:
+success:
 	ath10k_dbg(ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
 
 	return 0;
-- 
1.7.11.7

