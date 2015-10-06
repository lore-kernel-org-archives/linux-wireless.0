Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43518 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbJFNPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 09:15:51 -0400
Subject: [PATCH 1/2] ath10k: add board 2 API support
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Oct 2015 16:15:46 +0300
Message-ID: <20151006131546.14278.38803.stgit@potku.adurom.net> (sfid-20151006_151554_009470_3FA4DECB)
In-Reply-To: <20151006131455.14278.28222.stgit@potku.adurom.net>
References: <20151006131455.14278.28222.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

QCA6174 needs different board files based on board type. To make it easier to
distribute multiple board files and automatically choose correct board file
create a simple TLV file format following the same principles as with FW IEs.
The file is named board-2.bin and contain multiple board files. Each board file
then can have multiple names.

ath10k searches for file board-N.bin (where N is the interface version number
for the board file, just like we for firmware files) in /lib/firmware/*, for
example for qca99x0 it will try to find it here:

/lib/firmware/ath10k/QCA99X0/hw2.0/board-2.bin

If ath10k doesn't find board-2.bin then it will fallback to the old board.bin file.

This patch adds a simple name scheme using pci device id which for now will be
used by qca6174:

bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x

This removes the old method of having subsystem ids in ar->spec_board_id and
using that in the board file name.

Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
[kvalo@qca.qualcomm.com: simplified the file format, rewrote commit log, other smaller changes]
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |  249 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h  |    9 +
 drivers/net/wireless/ath/ath10k/debug.c |   12 +
 drivers/net/wireless/ath/ath10k/hw.h    |   13 ++
 drivers/net/wireless/ath/ath10k/pci.c   |   13 +-
 5 files changed, 247 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c295c919568b..9d3d9a7fdea4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -541,11 +541,18 @@ static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	return ret;
 }
 
-static void ath10k_core_free_firmware_files(struct ath10k *ar)
+static void ath10k_core_free_board_files(struct ath10k *ar)
 {
 	if (!IS_ERR(ar->board))
 		release_firmware(ar->board);
 
+	ar->board = NULL;
+	ar->board_data = NULL;
+	ar->board_len = 0;
+}
+
+static void ath10k_core_free_firmware_files(struct ath10k *ar)
+{
 	if (!IS_ERR(ar->otp))
 		release_firmware(ar->otp);
 
@@ -557,10 +564,6 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 
 	ath10k_swap_code_seg_release(ar);
 
-	ar->board = NULL;
-	ar->board_data = NULL;
-	ar->board_len = 0;
-
 	ar->otp = NULL;
 	ar->otp_data = NULL;
 	ar->otp_len = 0;
@@ -591,68 +594,241 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_core_fetch_spec_board_file(struct ath10k *ar)
+static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar)
 {
-	char filename[100];
-
-	scnprintf(filename, sizeof(filename), "board-%s-%s.bin",
-		  ath10k_bus_str(ar->hif.bus), ar->spec_board_id);
+	if (!ar->hw_params.fw.board) {
+		ath10k_err(ar, "failed to find board file fw entry\n");
+		return -EINVAL;
+	}
 
-	ar->board = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, filename);
+	ar->board = ath10k_fetch_fw_file(ar,
+					 ar->hw_params.fw.dir,
+					 ar->hw_params.fw.board);
 	if (IS_ERR(ar->board))
 		return PTR_ERR(ar->board);
 
 	ar->board_data = ar->board->data;
 	ar->board_len = ar->board->size;
-	ar->spec_board_loaded = true;
 
 	return 0;
 }
 
-static int ath10k_core_fetch_generic_board_file(struct ath10k *ar)
+static int ath10k_core_parse_bd_ie_board(struct ath10k *ar,
+					 const void *buf, size_t buf_len,
+					 const char *boardname)
 {
-	if (!ar->hw_params.fw.board) {
-		ath10k_err(ar, "failed to find board file fw entry\n");
-		return -EINVAL;
+	const struct ath10k_fw_ie *hdr;
+	bool name_match_found;
+	int ret, board_ie_id;
+	size_t board_ie_len;
+	const void *board_ie_data;
+
+	name_match_found = false;
+
+	/* go through ATH10K_BD_IE_BOARD_ elements */
+	while (buf_len > sizeof(struct ath10k_fw_ie)) {
+		hdr = buf;
+		board_ie_id = le32_to_cpu(hdr->id);
+		board_ie_len = le32_to_cpu(hdr->len);
+		board_ie_data = hdr->data;
+
+		buf_len -= sizeof(*hdr);
+		buf += sizeof(*hdr);
+
+		if (buf_len < ALIGN(board_ie_len, 4)) {
+			ath10k_err(ar, "invalid ATH10K_BD_IE_BOARD length: %d < %d\n",
+				   buf_len, ALIGN(board_ie_len, 4));
+			ret = -EINVAL;
+			goto out;
+		}
+
+		switch (board_ie_id) {
+		case ATH10K_BD_IE_BOARD_NAME:
+			ath10k_dbg_dump(ar, ATH10K_DBG_BOOT, "board name", "",
+					board_ie_data, board_ie_len);
+
+			if (board_ie_len != strlen(boardname))
+				break;
+
+			ret = memcmp(board_ie_data, boardname, strlen(boardname));
+			if (ret)
+				break;
+
+			name_match_found = true;
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "boot found match for name '%s'",
+				   boardname);
+			break;
+		case ATH10K_BD_IE_BOARD_DATA:
+			if (!name_match_found)
+				/* no match found */
+				break;
+
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "boot found board data for '%s'",
+				   boardname);
+
+			ar->board_data = board_ie_data;
+			ar->board_len = board_ie_len;
+
+			ret = 0;
+			goto out;
+		default:
+			ath10k_warn(ar, "unknown ATH10K_BD_IE_BOARD found: %d\n",
+				    board_ie_id);
+			break;
+		}
+
+		/* jump over the padding */
+		board_ie_len = ALIGN(board_ie_len, 4);
+
+		buf_len -= board_ie_len;
+		buf += board_ie_len;
 	}
 
-	ar->board = ath10k_fetch_fw_file(ar,
-					 ar->hw_params.fw.dir,
-					 ar->hw_params.fw.board);
+	/* no match found */
+	ret = -ENOENT;
+
+out:
+	return ret;
+}
+
+static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
+					      const char *boardname,
+					      const char *filename)
+{
+	size_t len, magic_len, ie_len;
+	struct ath10k_fw_ie *hdr;
+	const u8 *data;
+	int ret, ie_id;
+
+	ar->board = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, filename);
 	if (IS_ERR(ar->board))
 		return PTR_ERR(ar->board);
 
-	ar->board_data = ar->board->data;
-	ar->board_len = ar->board->size;
-	ar->spec_board_loaded = false;
+	data = ar->board->data;
+	len = ar->board->size;
+
+	/* magic has extra null byte padded */
+	magic_len = strlen(ATH10K_BOARD_MAGIC) + 1;
+	if (len < magic_len) {
+		ath10k_err(ar, "failed to find magic value in %s/%s, file too short: %zu\n",
+			   ar->hw_params.fw.dir, filename, len);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (memcmp(data, ATH10K_BOARD_MAGIC, magic_len)) {
+		ath10k_err(ar, "found invalid board magic\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* magic is padded to 4 bytes */
+	magic_len = ALIGN(magic_len, 4);
+	if (len < magic_len) {
+		ath10k_err(ar, "failed: %s/%s too small to contain board data, len: %zu\n",
+			   ar->hw_params.fw.dir, filename, len);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	data += magic_len;
+	len -= magic_len;
+
+	while (len > sizeof(struct ath10k_fw_ie)) {
+		hdr = (struct ath10k_fw_ie *)data;
+		ie_id = le32_to_cpu(hdr->id);
+		ie_len = le32_to_cpu(hdr->len);
+
+		len -= sizeof(*hdr);
+		data = hdr->data;
+
+		if (len < ALIGN(ie_len, 4)) {
+			ath10k_err(ar, "invalid length for board ie_id %d ie_len %zu len %zu\n",
+				   ie_id, ie_len, len);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		switch (ie_id) {
+		case ATH10K_BD_IE_BOARD:
+			ret = ath10k_core_parse_bd_ie_board(ar, data, ie_len,
+							    boardname);
+			if (ret == -ENOENT)
+				/* no match found, continue */
+				break;
+			else if (ret)
+				/* there was an error, bail out */
+				goto err;
+
+			/* board data found */
+			goto out;
+		}
+
+		/* jump over the padding */
+		ie_len = ALIGN(ie_len, 4);
+
+		len -= ie_len;
+		data += ie_len;
+	}
+
+out:
+	if (!ar->board_data || !ar->board_len) {
+		ath10k_err(ar,
+			   "failed to fetch board data for %s from %s/%s\n",
+			   ar->hw_params.fw.dir, boardname, filename);
+		ret = -ENODATA;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	ath10k_core_free_board_files(ar);
+	return ret;
+}
+
+static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
+					 size_t name_len)
+{
+	scnprintf(name, name_len,
+		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x",
+		  ath10k_bus_str(ar->hif.bus),
+		  ar->id.vendor, ar->id.device,
+		  ar->id.subsystem_vendor, ar->id.subsystem_device);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using board name '%s'\n", name);
 
 	return 0;
 }
 
 static int ath10k_core_fetch_board_file(struct ath10k *ar)
 {
+	char boardname[100];
 	int ret;
 
-	if (strlen(ar->spec_board_id) > 0) {
-		ret = ath10k_core_fetch_spec_board_file(ar);
-		if (ret) {
-			ath10k_info(ar, "failed to load spec board file, falling back to generic: %d\n",
-				    ret);
-			goto generic;
-		}
-
-		ath10k_dbg(ar, ATH10K_DBG_BOOT, "found specific board file for %s\n",
-			   ar->spec_board_id);
-		return 0;
+	ret = ath10k_core_create_board_name(ar, boardname, sizeof(boardname));
+	if (ret) {
+		ath10k_err(ar, "failed to create board name: %d", ret);
+		return ret;
 	}
 
-generic:
-	ret = ath10k_core_fetch_generic_board_file(ar);
+	ar->bd_api = 2;
+	ret = ath10k_core_fetch_board_data_api_n(ar, boardname,
+						 ATH10K_BOARD_API2_FILE);
+	if (!ret)
+		goto success;
+
+	ar->bd_api = 1;
+	ret = ath10k_core_fetch_board_data_api_1(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to fetch generic board data: %d\n", ret);
+		ath10k_err(ar, "failed to fetch board data\n");
 		return ret;
 	}
 
+success:
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "using board api %d\n", ar->bd_api);
 	return 0;
 }
 
@@ -1626,6 +1802,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	ath10k_testmode_destroy(ar);
 
 	ath10k_core_free_firmware_files(ar);
+	ath10k_core_free_board_files(ar);
 
 	ath10k_debug_unregister(ar);
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 002de7113e63..af5c0d741659 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -676,10 +676,15 @@ struct ath10k {
 		struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;
 	} swap;
 
-	char spec_board_id[100];
-	bool spec_board_loaded;
+	struct {
+		u32 vendor;
+		u32 device;
+		u32 subsystem_vendor;
+		u32 subsystem_device;
+	} id;
 
 	int fw_api;
+	int bd_api;
 	enum ath10k_cal_mode cal_mode;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f316efdbd6c3..7e8f6511b232 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -125,19 +125,21 @@ EXPORT_SYMBOL(ath10k_info);
 void ath10k_print_driver_info(struct ath10k *ar)
 {
 	char fw_features[128] = {};
+	char boardinfo[100];
 
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
-	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d features %s\n",
+	scnprintf(boardinfo, sizeof(boardinfo), "sub %04x:%04x",
+		  ar->id.subsystem_vendor, ar->id.subsystem_device);
+
+	ath10k_info(ar, "%s (0x%08x, 0x%08x %s) fw %s fwapi %d bdapi %d htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d features %s\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
-		    (strlen(ar->spec_board_id) > 0 ? ", " : ""),
-		    ar->spec_board_id,
-		    (strlen(ar->spec_board_id) > 0 && !ar->spec_board_loaded
-		     ? " fallback" : ""),
+		    boardinfo,
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
+		    ar->bd_api,
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
 		    ar->wmi.op_version,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 80c174ff6b7b..2d87737e35ff 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -97,6 +97,9 @@ enum qca6174_chip_id_rev {
 
 /* includes also the null byte */
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
+#define ATH10K_BOARD_MAGIC                  "QCA-ATH10K-BOARD"
+
+#define ATH10K_BOARD_API2_FILE         "board-2.bin"
 
 #define REG_DUMP_COUNT_QCA988X 60
 
@@ -159,6 +162,16 @@ enum ath10k_fw_htt_op_version {
 	ATH10K_FW_HTT_OP_VERSION_MAX,
 };
 
+enum ath10k_bd_ie_type {
+	/* contains sub IEs of enum ath10k_bd_ie_board_type */
+	ATH10K_BD_IE_BOARD = 0,
+};
+
+enum ath10k_bd_ie_board_type {
+	ATH10K_BD_IE_BOARD_NAME = 0,
+	ATH10K_BD_IE_BOARD_DATA = 1,
+};
+
 enum ath10k_hw_rev {
 	ATH10K_HW_QCA988X,
 	ATH10K_HW_QCA6174,
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 61df93e2e1c9..269c50e6eb1a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2925,7 +2925,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci probe\n");
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "pci probe %04x:%04x %04x:%04x\n",
+		   pdev->vendor, pdev->device,
+		   pdev->subsystem_vendor, pdev->subsystem_device);
 
 	ar_pci = ath10k_pci_priv(ar);
 	ar_pci->pdev = pdev;
@@ -2933,11 +2935,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar_pci->ar = ar;
 	ar->dev_id = pci_dev->device;
 
-	if (pdev->subsystem_vendor || pdev->subsystem_device)
-		scnprintf(ar->spec_board_id, sizeof(ar->spec_board_id),
-			  "%04x:%04x:%04x:%04x",
-			  pdev->vendor, pdev->device,
-			  pdev->subsystem_vendor, pdev->subsystem_device);
+	ar->id.vendor = pdev->vendor;
+	ar->id.device = pdev->device;
+	ar->id.subsystem_vendor = pdev->subsystem_vendor;
+	ar->id.subsystem_device = pdev->subsystem_device;
 
 	spin_lock_init(&ar_pci->ce_lock);
 	spin_lock_init(&ar_pci->ps_lock);

