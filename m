Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:38440 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3I0QzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 12:55:10 -0400
Subject: [PATCH v3 3/3] ath10k: implement firmware IE container support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 19:55:07 +0300
Message-ID: <20130927165507.2570.22850.stgit@localhost6.localdomain6> (sfid-20130927_185515_268385_850187D7)
In-Reply-To: <20130927164636.2570.24076.stgit@localhost6.localdomain6>
References: <20130927164636.2570.24076.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware IE containers can dynamically provide various information what
firmware supports. Also it can embed more than one image so updating firmware
is easy, user just needs to update one file in /lib/firmware/.

The firmware API 2 or higher will use the IE container format, the current API
1 will not use the new format but it still is supported for some time. FW API 2
files are named as firmware-2.bin (which contains both firmware and otp images)
and API 1 files are firmware.bin and otp.bin.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  184 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/core.h |    2 
 drivers/net/wireless/ath/ath10k/hw.h   |   19 +++
 drivers/net/wireless/ath/ath10k/wmi.c  |    3 -
 4 files changed, 206 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6a354f7..f269340 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -339,7 +339,7 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	ar->firmware_len = 0;
 }
 
-static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
+static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
 {
 	int ret = 0;
 
@@ -400,6 +400,188 @@ err:
 	return ret;
 }
 
+static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
+{
+	size_t magic_len, len, ie_len;
+	int ie_id, i, index, bit, ret;
+	struct ath10k_fw_ie *hdr;
+	const u8 *data;
+	__le32 *timestamp;
+
+	/* first fetch the firmware file (firmware-*.bin) */
+	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
+	if (IS_ERR(ar->firmware)) {
+		ath10k_err("Could not fetch firmware file '%s': %ld\n",
+			   name, PTR_ERR(ar->firmware));
+		return PTR_ERR(ar->firmware);
+	}
+
+	data = ar->firmware->data;
+	len = ar->firmware->size;
+
+	/* magic also includes the null byte, check that as well */
+	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
+
+	if (len < magic_len) {
+		ath10k_err("firmware image too small to contain magic: %d\n",
+			   len);
+		return -EINVAL;
+	}
+
+	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
+		ath10k_err("Invalid firmware magic\n");
+		return -EINVAL;
+	}
+
+	/* jump over the padding */
+	magic_len = ALIGN(magic_len, 4);
+
+	len -= magic_len;
+	data += magic_len;
+
+	/* loop elements */
+	while (len > sizeof(struct ath10k_fw_ie)) {
+		hdr = (struct ath10k_fw_ie *)data;
+
+		ie_id = le32_to_cpu(hdr->id);
+		ie_len = le32_to_cpu(hdr->len);
+
+		len -= sizeof(*hdr);
+		data += sizeof(*hdr);
+
+		if (len < ie_len) {
+			ath10k_err("Invalid length for FW IE %d (%d < %d)\n",
+				   ie_id, len, ie_len);
+			return -EINVAL;
+		}
+
+		switch (ie_id) {
+		case ATH10K_FW_IE_FW_VERSION:
+			if (ie_len > sizeof(ar->hw->wiphy->fw_version) - 1)
+				break;
+
+			memcpy(ar->hw->wiphy->fw_version, data, ie_len);
+			ar->hw->wiphy->fw_version[ie_len] = '\0';
+
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found fw version %s\n",
+				    ar->hw->wiphy->fw_version);
+			break;
+		case ATH10K_FW_IE_TIMESTAMP:
+			if (ie_len != sizeof(u32))
+				break;
+
+			timestamp = (__le32 *)data;
+
+			ath10k_dbg(ATH10K_DBG_BOOT, "found fw timestamp %d\n",
+				   le32_to_cpup(timestamp));
+			break;
+		case ATH10K_FW_IE_FEATURES:
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found firmware features ie (%zd B)\n",
+				   ie_len);
+
+			for (i = 0; i < ATH10K_FW_FEATURE_COUNT; i++) {
+				index = i / 8;
+				bit = i % 8;
+
+				if (index == ie_len)
+					break;
+
+				if (data[index] & (1 << bit))
+					__set_bit(i, ar->fw_features);
+			}
+
+			ath10k_dbg_dump(ATH10K_DBG_BOOT, "features", "",
+					ar->fw_features,
+					sizeof(ar->fw_features));
+			break;
+		case ATH10K_FW_IE_FW_IMAGE:
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found fw image ie (%zd B)\n",
+				   ie_len);
+
+			ar->firmware_data = data;
+			ar->firmware_len = ie_len;
+
+			break;
+		case ATH10K_FW_IE_OTP_IMAGE:
+			ath10k_dbg(ATH10K_DBG_BOOT,
+				   "found otp image ie (%zd B)\n",
+				   ie_len);
+
+			ar->otp_data = data;
+			ar->otp_len = ie_len;
+
+			break;
+		default:
+			ath10k_warn("Unknown FW IE: %u\n",
+				    le32_to_cpu(hdr->id));
+			break;
+		}
+
+		/* jump over the padding */
+		ie_len = ALIGN(ie_len, 4);
+
+		len -= ie_len;
+		data += ie_len;
+	};
+
+	if (!ar->firmware_data || !ar->firmware_len) {
+		ath10k_warn("No ATH10K_FW_IE_FW_IMAGE found from %s, skipping\n",
+			    name);
+		ret = -ENOMEDIUM;
+		goto err;
+	}
+
+	/* now fetch the board file */
+	if (ar->hw_params.fw.board == NULL) {
+		ath10k_err("board data file not defined");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ar->board = ath10k_fetch_fw_file(ar,
+					 ar->hw_params.fw.dir,
+					 ar->hw_params.fw.board);
+	if (IS_ERR(ar->board)) {
+		ret = PTR_ERR(ar->board);
+		ath10k_err("could not fetch board data (%d)\n", ret);
+		goto err;
+	}
+
+	ar->board_data = ar->board->data;
+	ar->board_len = ar->board->size;
+
+	return 0;
+
+err:
+	ath10k_core_free_firmware_files(ar);
+	return ret;
+}
+
+static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
+{
+	int ret;
+
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
+	if (ret == 0) {
+		ar->fw_api = 2;
+		goto out;
+	}
+
+	ret = ath10k_core_fetch_firmware_api_1(ar);
+	if (ret)
+		return ret;
+
+	ar->fw_api = 1;
+
+out:
+	ath10k_dbg(ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
+
+	return 0;
+}
+
 static int ath10k_init_download_firmware(struct ath10k *ar)
 {
 	int ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 511b20d..3b5e78d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -336,6 +336,8 @@ struct ath10k {
 	const void *firmware_data;
 	size_t firmware_len;
 
+	int fw_api;
+
 	struct {
 		struct completion started;
 		struct completion completed;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 643f0c9..a9cac43 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -38,6 +38,25 @@
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
 #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
+#define ATH10K_FW_API2_FILE		"firmware-2.bin"
+
+/* includes also the null byte */
+#define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
+
+struct ath10k_fw_ie {
+	__le32 id;
+	__le32 len;
+	u8 data[0];
+};
+
+enum ath10k_fw_ie_type {
+	ATH10K_FW_IE_FW_VERSION = 0,
+	ATH10K_FW_IE_TIMESTAMP = 1,
+	ATH10K_FW_IE_FEATURES = 2,
+	ATH10K_FW_IE_FW_IMAGE = 3,
+	ATH10K_FW_IE_OTP_IMAGE = 4,
+};
+
 /* Known pecularities:
  *  - current FW doesn't support raw rx mode (last tested v599)
  *  - current FW dumps upon raw tx mode (last tested v599)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6803ead..771d77c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -988,7 +988,8 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	ar->phy_capability = __le32_to_cpu(ev->phy_capability);
 	ar->num_rf_chains = __le32_to_cpu(ev->num_rf_chains);
 
-	if (ar->fw_version_build > 636)
+	/* only manually set fw features when not using FW IE format */
+	if (ar->fw_api == 1 && ar->fw_version_build > 636)
 		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
 
 	if (ar->num_rf_chains > WMI_MAX_SPATIAL_STREAM) {

