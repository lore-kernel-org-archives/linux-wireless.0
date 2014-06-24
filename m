Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45779 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbaFXTwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:37 -0400
Received: by mail-wg0-f50.google.com with SMTP id m15so913354wgh.9
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/27] iwlwifi: add device / firmware to fw-error-dump file
Date: Tue, 24 Jun 2014 22:52:00 +0300
Message-Id: <1403639541-4621-6-git-send-email-egrumbach@gmail.com> (sfid-20140624_220200_216105_6154D6FB)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can be useful later for parsing since the parsing may
differ based on the device's family / bus.
Also add the human readable version of the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |  5 +++--
 drivers/net/wireless/iwlwifi/iwl-fw.h            |  3 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c           | 24 +++++++++++++++++++++---
 5 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index bf584d3..01a4268 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -567,6 +567,8 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 	}
 
 	drv->fw.ucode_ver = le32_to_cpu(ucode->ver);
+	memcpy(drv->fw.human_readable, ucode->human_readable,
+	       sizeof(drv->fw.human_readable));
 	build = le32_to_cpu(ucode->build);
 
 	if (build)
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 2953ffc..aa0f85e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -74,12 +74,15 @@
  * @IWL_FW_ERROR_DUMP_RXF:
  * @IWL_FW_ERROR_DUMP_TXCMD: last TX command data, structured as
  *	&struct iwl_fw_error_dump_txcmd packets
+ * @IWL_FW_ERROR_DUMP_DEV_FW_INFO:  struct %iwl_fw_error_dump_info
+ *	info on the device / firmware.
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
 	IWL_FW_ERROR_DUMP_REG = 1,
 	IWL_FW_ERROR_DUMP_RXF = 2,
 	IWL_FW_ERROR_DUMP_TXCMD = 3,
+	IWL_FW_ERROR_DUMP_DEV_FW_INFO = 4,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -120,6 +123,27 @@ struct iwl_fw_error_dump_txcmd {
 	u8 data[];
 } __packed;
 
+enum iwl_fw_error_dump_family {
+	IWL_FW_ERROR_DUMP_FAMILY_7 = 7,
+	IWL_FW_ERROR_DUMP_FAMILY_8 = 8,
+};
+
+/**
+ * struct iwl_fw_error_dump_info - info on the device / firmware
+ * @device_family: the family of the device (7 / 8)
+ * @hw_step: the step of the device
+ * @fw_human_readable: human readable FW version
+ * @dev_human_readable: name of the device
+ * @bus_human_readable: name of the bus used
+ */
+struct iwl_fw_error_dump_info {
+	__le32 device_family;
+	__le32 hw_step;
+	u8 fw_human_readable[FW_VER_HUMAN_READABLE_SZ];
+	u8 dev_human_readable[64];
+	u8 bus_human_readable[8];
+} __packed;
+
 /**
  * iwl_mvm_fw_error_next_data - advance fw error dump data pointer
  * @data: previous data block
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 9e6ba1e..929a806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -137,7 +137,8 @@ struct iwl_ucode_tlv {
 	u8 data[0];
 };
 
-#define IWL_TLV_UCODE_MAGIC	0x0a4c5749
+#define IWL_TLV_UCODE_MAGIC		0x0a4c5749
+#define FW_VER_HUMAN_READABLE_SZ	64
 
 struct iwl_tlv_ucode_header {
 	/*
@@ -148,7 +149,7 @@ struct iwl_tlv_ucode_header {
 	 */
 	__le32 zero;
 	__le32 magic;
-	u8 human_readable[64];
+	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
 	__le32 ver;		/* major/minor/API/serial */
 	__le32 build;
 	__le64 ignore;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index de975cd..287b949 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -65,6 +65,8 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
+#include "iwl-fw-file.h"
+
 /**
  * enum iwl_ucode_tlv_flag - ucode API flags
  * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
@@ -312,6 +314,7 @@ struct iwl_fw {
 	bool mvm_fw;
 
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
+	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
 };
 
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a46f028..3ab33e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -827,6 +827,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
+	struct iwl_fw_error_dump_info *dump_info;
 	u32 file_len;
 	u32 trans_len;
 
@@ -835,10 +836,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (mvm->fw_error_dump)
 		return;
 
-	file_len = mvm->fw_error_sram_len +
+	file_len = sizeof(*dump_file) +
+		   sizeof(*dump_data) * 3 +
+		   mvm->fw_error_sram_len +
 		   mvm->fw_error_rxf_len +
-		   sizeof(*dump_file) +
-		   sizeof(*dump_data) * 2;
+		   sizeof(*dump_info);
 
 	trans_len = iwl_trans_dump_data(mvm->trans, NULL, 0);
 	if (trans_len)
@@ -853,6 +855,22 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_file->file_len = cpu_to_le32(file_len);
 	dump_data = (void *)dump_file->data;
+
+	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_DEV_FW_INFO);
+	dump_data->len = cpu_to_le32(sizeof(*dump_info));
+	dump_info = (void *) dump_data->data;
+	dump_info->device_family =
+		mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000 ?
+			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_7) :
+			cpu_to_le32(IWL_FW_ERROR_DUMP_FAMILY_8);
+	memcpy(dump_info->fw_human_readable, mvm->fw->human_readable,
+	       sizeof(dump_info->fw_human_readable));
+	strncpy(dump_info->dev_human_readable, mvm->cfg->name,
+		sizeof(dump_info->dev_human_readable));
+	strncpy(dump_info->bus_human_readable, mvm->dev->bus->name,
+		sizeof(dump_info->bus_human_readable));
+
+	dump_data = iwl_mvm_fw_error_next_data(dump_data);
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
 	dump_data->len = cpu_to_le32(mvm->fw_error_rxf_len);
 	memcpy(dump_data->data, mvm->fw_error_rxf, mvm->fw_error_rxf_len);
-- 
1.8.3.2

