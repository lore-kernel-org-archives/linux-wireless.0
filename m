Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40018 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbcDTQqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:46:14 -0400
Subject: [PATCH v2 7/8] ath10k: switch testmode to use
 ath10k_core_fetch_firmware_api_n()
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 19:46:01 +0300
Message-ID: <20160420164601.8801.1260.stgit@potku.adurom.net> (sfid-20160420_184617_044180_6CB0749C)
In-Reply-To: <20160420164301.8801.12099.stgit@potku.adurom.net>
References: <20160420164301.8801.12099.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that all firmware-N.bin related are within struct ath10k_fw_file we can
switch to use ath10k_core_fetch_firmware_api_n() and delete almost identical
ath10k_tm_fetch_utf_firmware_api_2().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |    4 -
 drivers/net/wireless/ath/ath10k/core.h     |    2 
 drivers/net/wireless/ath/ath10k/testmode.c |  124 ----------------------------
 3 files changed, 6 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4af01afdaf6c..db9437a72ba4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -976,8 +976,8 @@ success:
 	return 0;
 }
 
-static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
-					    struct ath10k_fw_file *fw_file)
+int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
+				     struct ath10k_fw_file *fw_file)
 {
 	size_t magic_len, len, ie_len;
 	int ie_id, i, index, bit, ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index faa106654abd..1379054000f9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -933,6 +933,8 @@ void ath10k_core_destroy(struct ath10k *ar);
 void ath10k_core_get_fw_features_str(struct ath10k *ar,
 				     char *buf,
 				     size_t max_len);
+int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
+				     struct ath10k_fw_file *fw_file);
 
 int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		      const struct ath10k_fw_components *fw_components);
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index daf04d74c6d0..120f4234d3b0 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -139,127 +139,6 @@ static int ath10k_tm_cmd_get_version(struct ath10k *ar, struct nlattr *tb[])
 	return cfg80211_testmode_reply(skb);
 }
 
-static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar,
-					      struct ath10k_fw_file *fw_file)
-{
-	size_t len, magic_len, ie_len;
-	struct ath10k_fw_ie *hdr;
-	char filename[100];
-	__le32 *version;
-	const u8 *data;
-	int ie_id, ret;
-
-	snprintf(filename, sizeof(filename), "%s/%s",
-		 ar->hw_params.fw.dir, ATH10K_FW_UTF_API2_FILE);
-
-	/* load utf firmware image */
-	ret = request_firmware(&fw_file->firmware, filename, ar->dev);
-	if (ret) {
-		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
-			    filename, ret);
-		return ret;
-	}
-
-	data = fw_file->firmware->data;
-	len = fw_file->firmware->size;
-
-	/* FIXME: call release_firmware() in error cases */
-
-	/* magic also includes the null byte, check that as well */
-	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
-
-	if (len < magic_len) {
-		ath10k_err(ar, "utf firmware file is too small to contain magic\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
-		ath10k_err(ar, "invalid firmware magic\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	/* jump over the padding */
-	magic_len = ALIGN(magic_len, 4);
-
-	len -= magic_len;
-	data += magic_len;
-
-	/* loop elements */
-	while (len > sizeof(struct ath10k_fw_ie)) {
-		hdr = (struct ath10k_fw_ie *)data;
-
-		ie_id = le32_to_cpu(hdr->id);
-		ie_len = le32_to_cpu(hdr->len);
-
-		len -= sizeof(*hdr);
-		data += sizeof(*hdr);
-
-		if (len < ie_len) {
-			ath10k_err(ar, "invalid length for FW IE %d (%zu < %zu)\n",
-				   ie_id, len, ie_len);
-			ret = -EINVAL;
-			goto err;
-		}
-
-		switch (ie_id) {
-		case ATH10K_FW_IE_FW_VERSION:
-			if (ie_len > sizeof(fw_file->fw_version) - 1)
-				break;
-
-			memcpy(fw_file->fw_version, data, ie_len);
-			fw_file->fw_version[ie_len] = '\0';
-
-			ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-				   "testmode found fw utf version %s\n",
-				   fw_file->fw_version);
-			break;
-		case ATH10K_FW_IE_TIMESTAMP:
-			/* ignore timestamp, but don't warn about it either */
-			break;
-		case ATH10K_FW_IE_FW_IMAGE:
-			ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
-				   "testmode found fw image ie (%zd B)\n",
-				   ie_len);
-
-			fw_file->firmware_data = data;
-			fw_file->firmware_len = ie_len;
-			break;
-		case ATH10K_FW_IE_WMI_OP_VERSION:
-			if (ie_len != sizeof(u32))
-				break;
-			version = (__le32 *)data;
-			fw_file->wmi_op_version = le32_to_cpup(version);
-			ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode found fw ie wmi op version %d\n",
-				   fw_file->wmi_op_version);
-			break;
-		default:
-			ath10k_warn(ar, "Unknown testmode FW IE: %u\n",
-				    le32_to_cpu(hdr->id));
-			break;
-		}
-		/* jump over the padding */
-		ie_len = ALIGN(ie_len, 4);
-
-		len -= ie_len;
-		data += ie_len;
-	}
-
-	if (!fw_file->firmware_data || !fw_file->firmware_len) {
-		ath10k_err(ar, "No ATH10K_FW_IE_FW_IMAGE found\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	return 0;
-
-err:
-	release_firmware(fw_file->firmware);
-
-	return ret;
-}
-
 static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 					      struct ath10k_fw_file *fw_file)
 {
@@ -296,7 +175,8 @@ static int ath10k_tm_fetch_firmware(struct ath10k *ar)
 	struct ath10k_fw_components *utf_mode_fw;
 	int ret;
 
-	ret = ath10k_tm_fetch_utf_firmware_api_2(ar, &ar->testmode.utf_mode_fw.fw_file);
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_UTF_API2_FILE,
+					       &ar->testmode.utf_mode_fw.fw_file);
 	if (ret == 0) {
 		ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode using fw utf api 2");
 		goto out;

