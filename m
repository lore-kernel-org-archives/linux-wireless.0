Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:49317 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1ILLMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:37 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id C08E98C226
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:35 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 984AD1C6385
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:33 +0300 (EEST)
Subject: [PATCH 4/9] ath6kl: add support for firmware API 2 format
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:33 +0300
Message-ID: <20110912111233.16921.84153.stgit@localhost6.localdomain6> (sfid-20110912_131239_437428_16D78FC4)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the new format all the format images are embedded into one file.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |   20 +++++
 drivers/net/wireless/ath/ath6kl/init.c |  136 +++++++++++++++++++++++++++++++-
 2 files changed, 151 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c6ed1fc..761e550 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -58,6 +58,23 @@
 #define A_DEFAULT_LISTEN_INTERVAL         100
 #define A_MAX_WOW_LISTEN_INTERVAL         1000
 
+/* includes also the null byte */
+#define ATH6KL_FIRMWARE_MAGIC               "QCA-ATH6KL"
+
+enum ath6kl_fw_ie_type {
+	ATH6KL_FW_IE_FW_VERSION = 0,
+	ATH6KL_FW_IE_TIMESTAMP = 1,
+	ATH6KL_FW_IE_OTP_IMAGE = 2,
+	ATH6KL_FW_IE_FW_IMAGE = 3,
+	ATH6KL_FW_IE_PATCH_IMAGE = 4,
+};
+
+struct ath6kl_fw_ie {
+	__le32 id;
+	__le32 len;
+	u8 data[0];
+};
+
 /* AR6003 1.0 definitions */
 #define AR6003_REV1_VERSION                 0x300002ba
 
@@ -68,6 +85,7 @@
 #define AR6003_REV2_FIRMWARE_FILE           "ath6k/AR6003/hw2.0/athwlan.bin.z77"
 #define AR6003_REV2_TCMD_FIRMWARE_FILE      "ath6k/AR6003/hw2.0/athtcmd_ram.bin"
 #define AR6003_REV2_PATCH_FILE              "ath6k/AR6003/hw2.0/data.patch.bin"
+#define AR6003_REV2_FIRMWARE_2_FILE         "ath6k/AR6003/hw2.0/fw-2.bin"
 #define AR6003_REV2_BOARD_DATA_FILE         "ath6k/AR6003/hw2.0/bdata.bin"
 #define AR6003_REV2_DEFAULT_BOARD_DATA_FILE "ath6k/AR6003/hw2.0/bdata.SD31.bin"
 
@@ -77,6 +95,7 @@
 #define AR6003_REV3_FIRMWARE_FILE           "ath6k/AR6003/hw2.1.1/athwlan.bin"
 #define AR6003_REV3_TCMD_FIRMWARE_FILE    "ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
 #define AR6003_REV3_PATCH_FILE            "ath6k/AR6003/hw2.1.1/data.patch.bin"
+#define AR6003_REV3_FIRMWARE_2_FILE           "ath6k/AR6003/hw2.1.1/fw-2.bin"
 #define AR6003_REV3_BOARD_DATA_FILE       "ath6k/AR6003/hw2.1.1/bdata.bin"
 #define AR6003_REV3_DEFAULT_BOARD_DATA_FILE	\
 	"ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
@@ -84,6 +103,7 @@
 /* AR6004 1.0 definitions */
 #define AR6004_REV1_VERSION                 0x30000623
 #define AR6004_REV1_FIRMWARE_FILE           "ath6k/AR6004/hw6.1/fw.ram.bin"
+#define AR6004_REV1_FIRMWARE_2_FILE         "ath6k/AR6004/hw6.1/fw-2.bin"
 #define AR6004_REV1_BOARD_DATA_FILE         "ath6k/AR6004/hw6.1/bdata.bin"
 #define AR6004_REV1_DEFAULT_BOARD_DATA_FILE "ath6k/AR6004/hw6.1/bdata.DB132.bin"
 #define AR6004_REV1_EPPING_FIRMWARE_FILE "ath6k/AR6004/hw6.1/endpointping.bin"
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4055947..41f4e0d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -917,14 +917,10 @@ static int ath6kl_fetch_patch_file(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_fetch_firmwares(struct ath6kl *ar)
+static int ath6kl_fetch_fw_api1(struct ath6kl *ar)
 {
 	int ret;
 
-	ret = ath6kl_fetch_board_file(ar);
-	if (ret)
-		return ret;
-
 	ret = ath6kl_fetch_otp_file(ar);
 	if (ret)
 		return ret;
@@ -940,6 +936,136 @@ static int ath6kl_fetch_firmwares(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
+{
+	size_t magic_len, len, ie_len;
+	const struct firmware *fw;
+	struct ath6kl_fw_ie *hdr;
+	const char *filename;
+	const u8 *data;
+	int ret, ie_id;
+
+	switch (ar->version.target_ver) {
+	case AR6003_REV2_VERSION:
+		filename = AR6003_REV2_FIRMWARE_2_FILE;
+		break;
+	case AR6003_REV3_VERSION:
+		filename = AR6003_REV3_FIRMWARE_2_FILE;
+		break;
+	case AR6004_REV1_VERSION:
+		filename = AR6004_REV1_FIRMWARE_2_FILE;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = request_firmware(&fw, filename, ar->dev);
+	if (ret)
+		return ret;
+
+	data = fw->data;
+	len = fw->size;
+
+	/* magic also includes the null byte, check that as well */
+	magic_len = strlen(ATH6KL_FIRMWARE_MAGIC) + 1;
+
+	if (len < magic_len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (memcmp(data, ATH6KL_FIRMWARE_MAGIC, magic_len) != 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	len -= magic_len;
+	data += magic_len;
+
+	/* loop elements */
+	while (len > sizeof(struct ath6kl_fw_ie)) {
+		/* hdr is unaligned! */
+		hdr = (struct ath6kl_fw_ie *) data;
+
+		ie_id = le32_to_cpup(&hdr->id);
+		ie_len = le32_to_cpup(&hdr->len);
+
+		len -= sizeof(*hdr);
+		data += sizeof(*hdr);
+
+		if (len < ie_len) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		switch (ie_id) {
+		case ATH6KL_FW_IE_OTP_IMAGE:
+			ar->fw_otp = kmemdup(data, ie_len, GFP_KERNEL);
+
+			if (ar->fw_otp == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			ar->fw_otp_len = ie_len;
+			break;
+		case ATH6KL_FW_IE_FW_IMAGE:
+			ar->fw = kmemdup(data, ie_len, GFP_KERNEL);
+
+			if (ar->fw == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			ar->fw_len = ie_len;
+			break;
+		case ATH6KL_FW_IE_PATCH_IMAGE:
+			ar->fw_patch = kmemdup(data, ie_len, GFP_KERNEL);
+
+			if (ar->fw_patch == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			ar->fw_patch_len = ie_len;
+			break;
+		default:
+			ath6kl_dbg(ATH6KL_DBG_TRC, "Unknown fw ie: %u\n",
+				   le32_to_cpup(&hdr->id));
+			break;
+		}
+
+		len -= ie_len;
+		data += ie_len;
+	};
+
+	ret = 0;
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int ath6kl_fetch_firmwares(struct ath6kl *ar)
+{
+	int ret;
+
+	ret = ath6kl_fetch_board_file(ar);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_fetch_fw_api2(ar);
+	if (ret == 0)
+		/* fw api 2 found, use it */
+		return 0;
+
+	ret = ath6kl_fetch_fw_api1(ar);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int ath6kl_upload_board_file(struct ath6kl *ar)
 {
 	u32 board_address, board_ext_address, param;

