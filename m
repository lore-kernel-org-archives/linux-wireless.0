Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43409 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaCUS4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 14:56:37 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] ath10k:  Better firmware loading error messages.
Date: Fri, 21 Mar 2014 11:55:49 -0700
Message-Id: <1395428150-31996-2-git-send-email-greearb@candelatech.com> (sfid-20140321_195640_977903_AAD6BF14)
In-Reply-To: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Let user know the name of the board file if it is not
found, and make it easier to determine if it is api-1
or api-n firmware logic that is complaining.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 35f9db4..bf5119f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -398,7 +398,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	/* first fetch the firmware file (firmware-*.bin) */
 	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
 	if (IS_ERR(ar->firmware)) {
-		ath10k_err("Could not fetch firmware file '%s': %ld\n",
+		ath10k_err("api-n: Could not fetch firmware file '%s': %ld\n",
 			   name, PTR_ERR(ar->firmware));
 		return PTR_ERR(ar->firmware);
 	}
@@ -410,14 +410,14 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
 
 	if (len < magic_len) {
-		ath10k_err("firmware image too small to contain magic: %zu\n",
+		ath10k_err("api-n: firmware image too small to contain magic: %zu\n",
 			   len);
 		ret = -EINVAL;
 		goto err;
 	}
 
 	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
-		ath10k_err("Invalid firmware magic\n");
+		ath10k_err("api-n: Invalid firmware magic\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -439,7 +439,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		data += sizeof(*hdr);
 
 		if (len < ie_len) {
-			ath10k_err("Invalid length for FW IE %d (%zu < %zu)\n",
+			ath10k_err("api-n: Invalid length for FW IE %d (%zu < %zu)\n",
 				   ie_id, len, ie_len);
 			ret = -EINVAL;
 			goto err;
@@ -454,7 +454,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->hw->wiphy->fw_version[ie_len] = '\0';
 
 			ath10k_dbg(ATH10K_DBG_BOOT,
-				   "found fw version %s\n",
+				   "api-n: found fw version %s\n",
 				    ar->hw->wiphy->fw_version);
 			break;
 		case ATH10K_FW_IE_TIMESTAMP:
@@ -463,12 +463,12 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 			timestamp = (__le32 *)data;
 
-			ath10k_dbg(ATH10K_DBG_BOOT, "found fw timestamp %d\n",
+			ath10k_dbg(ATH10K_DBG_BOOT, "api-n: found fw timestamp %d\n",
 				   le32_to_cpup(timestamp));
 			break;
 		case ATH10K_FW_IE_FEATURES:
 			ath10k_dbg(ATH10K_DBG_BOOT,
-				   "found firmware features ie (%zd B)\n",
+				   "api-n: found firmware features ie (%zd B)\n",
 				   ie_len);
 
 			for (i = 0; i < ATH10K_FW_FEATURE_COUNT; i++) {
@@ -492,7 +492,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			break;
 		case ATH10K_FW_IE_FW_IMAGE:
 			ath10k_dbg(ATH10K_DBG_BOOT,
-				   "found fw image ie (%zd B)\n",
+				   "api-n: found fw image ie (%zd B)\n",
 				   ie_len);
 
 			ar->firmware_data = data;
@@ -501,7 +501,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			break;
 		case ATH10K_FW_IE_OTP_IMAGE:
 			ath10k_dbg(ATH10K_DBG_BOOT,
-				   "found otp image ie (%zd B)\n",
+				   "api-n: found otp image ie (%zd B)\n",
 				   ie_len);
 
 			ar->otp_data = data;
@@ -514,12 +514,12 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ar->fw_rom_bss_addr = le32_to_cpu(((u32*)(data))[2]);
 			ar->fw_rom_bss_len = le32_to_cpu(((u32*)(data))[3]);
 			ath10k_dbg(ATH10K_DBG_BOOT,
-				   "found FW bss info, RAM: addr 0x%x len 0x%x  ROM: addr 0x%x len 0x%x\n",
+				   "api-n: found FW bss info, RAM: addr 0x%x len 0x%x  ROM: addr 0x%x len 0x%x\n",
 				   ar->fw_ram_bss_addr, ar->fw_ram_bss_len,
 				   ar->fw_rom_bss_addr, ar->fw_rom_bss_len);
 			break;
 		default:
-			ath10k_warn("Unknown FW IE: %u\n",
+			ath10k_warn("api-n: Unknown FW IE: %u\n",
 				    le32_to_cpu(hdr->id));
 			break;
 		}
@@ -532,7 +532,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	}
 
 	if (!ar->firmware_data || !ar->firmware_len) {
-		ath10k_warn("No ATH10K_FW_IE_FW_IMAGE found from %s, skipping\n",
+		ath10k_warn("api-n: No ATH10K_FW_IE_FW_IMAGE found from %s, skipping\n",
 			    name);
 		ret = -ENOMEDIUM;
 		goto err;
@@ -540,7 +540,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 
 	/* now fetch the board file */
 	if (ar->hw_params.fw.board == NULL) {
-		ath10k_err("board data file not defined");
+		ath10k_err("api-n: board data file not defined");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -550,7 +550,9 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 					 ar->hw_params.fw.board);
 	if (IS_ERR(ar->board)) {
 		ret = PTR_ERR(ar->board);
-		ath10k_err("could not fetch board data (%d)\n", ret);
+		ath10k_err("api-n: could not fetch board data %s/%s (%d)\n",
+			   ar->hw_params.fw.dir, ar->hw_params.fw.board,
+			   ret);
 		goto err;
 	}
 
-- 
1.7.11.7

