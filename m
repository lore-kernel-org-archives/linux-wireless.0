Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47294 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbbHaRxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:53:11 -0400
From: Kuei Hao Liu <alanliu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath10k-devel@qca.qualcomm.com>,
	<ath10k-tieto.external@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3] Add wmi-tlv support in test mode
Date: Mon, 31 Aug 2015 10:53:03 -0700
Message-ID: <1441043583-2908-2-git-send-email-alanliu@qca.qualcomm.com> (sfid-20150831_195314_987590_1D9676DF)
In-Reply-To: <1441043583-2908-1-git-send-email-alanliu@qca.qualcomm.com>
References: <1441043583-2908-1-git-send-email-alanliu@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: alanliu <alanliu@qca.qualcomm.com>

Add WMI-TLV and FW API support in ath10k testmode.
Ath10k can get right wmi command format from UTF image
to communicate UTF firmware.

Signed-off-by: Kuei Hao Liu <alanliu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   4 +-
 drivers/net/wireless/ath/ath10k/core.h     |   5 +-
 drivers/net/wireless/ath/ath10k/testmode.c | 123 ++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  15 +++-
 4 files changed, 131 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2551067..b2210b9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -489,8 +489,8 @@ static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		}
 		break;
 	case ATH10K_FIRMWARE_MODE_UTF:
-		data = ar->testmode.utf->data;
-		data_len = ar->testmode.utf->size;
+		data = ar->testmode.utf_firmware_data;
+		data_len = ar->testmode.utf_firmware_len;
 		mode_name = "utf";
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6a387ba..6b11a5c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -768,9 +768,12 @@ struct ath10k {
 	struct {
 		/* protected by conf_mutex */
 		const struct firmware *utf;
+		char fw_version[32];
+		const void *utf_firmware_data;
+		size_t utf_firmware_len;
 		DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
 		enum ath10k_fw_wmi_op_version orig_wmi_op_version;
-
+		enum ath10k_fw_wmi_op_version op_version;
 		/* protected by data_lock */
 		bool utf_monitor;
 	} testmode;
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index b084f88..a94c30c 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -35,6 +35,100 @@ static const struct nla_policy ath10k_tm_policy[ATH10K_TM_ATTR_MAX + 1] = {
 	[ATH10K_TM_ATTR_VERSION_MINOR]	= { .type = NLA_U32 },
 };
 
+bool ath10k_tm_fetch_utf_firmware_api(struct ath10k *ar, const u8 *fw_data, size_t fw_len)
+{
+	size_t magic_len, ie_len;
+	int ie_id;
+	struct ath10k_fw_ie *hdr;
+	__le32 *version;
+	const u8 *data = fw_data;
+	size_t len = fw_len;
+	bool ret = false;
+
+	if(!data || len <= 0)
+		goto err;
+	/* magic also includes the null byte, check that as well */
+	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
+
+	if (len < magic_len) {
+		ath10k_err(ar, "utf firmware file is too small to contain magic\n");
+		goto err;
+	}
+	if (memcmp(data, ATH10K_FIRMWARE_MAGIC, magic_len) != 0) {
+		ath10k_err(ar, "invalid firmware magic\n");
+		goto err;
+	}
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
+			ath10k_err(ar, "invalid length for FW IE %d (%zu < %zu)\n", ie_id, len, ie_len);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		switch (ie_id) {
+		case ATH10K_FW_IE_FW_VERSION:
+			if (ie_len > sizeof(ar->testmode.fw_version) - 1)
+				break;
+
+			memcpy(ar->testmode.fw_version, data, ie_len);
+			ar->testmode.fw_version[ie_len] = '\0';
+
+			ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+				"found fw version %s\n",
+				ar->testmode.fw_version);
+			break;
+		case ATH10K_FW_IE_FW_IMAGE:
+			ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+				"found fw image ie (%zd B)\n",
+				ie_len);
+
+			ar->testmode.utf_firmware_data = data;
+			ar->testmode.utf_firmware_len = ie_len;
+			break;
+		case ATH10K_FW_IE_WMI_OP_VERSION:
+			if (ie_len != sizeof(u32))
+				break;
+			version = (__le32 *)data;
+			ar->testmode.op_version = le32_to_cpup(version);
+			ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "found fw ie wmi op version %d\n",
+			ar->testmode.op_version);
+			break;
+		default:
+			ath10k_warn(ar, "Unknown FW IE: %u\n",
+				le32_to_cpu(hdr->id));
+			break;
+		}
+		/* jump over the padding */
+		ie_len = ALIGN(ie_len, 4);
+
+		len -= ie_len;
+		data += ie_len;
+	}
+	if (!ar->testmode.utf_firmware_data || !ar->testmode.utf_firmware_len) {
+		ath10k_warn(ar, "No ATH10K_FW_IE_FW_IMAGE found\n");
+		goto err;
+	}
+        return true;
+err:
+    return ret;
+}
+
+
 /* Returns true if callee consumes the skb and the skb should be discarded.
  * Returns false if skb is not used. Does not sleep.
  */
@@ -143,7 +237,6 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 {
 	char filename[100];
 	int ret;
-
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf start\n");
 
 	mutex_lock(&ar->conf_mutex);
@@ -166,36 +259,42 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 	}
 
 	snprintf(filename, sizeof(filename), "%s/%s",
-		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
+		ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
 
 	/* load utf firmware image */
 	ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
 	if (ret) {
 		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
-			    filename, ret);
+			filename, ret);
 		goto err;
 	}
 
 	spin_lock_bh(&ar->data_lock);
-
 	ar->testmode.utf_monitor = true;
-
 	spin_unlock_bh(&ar->data_lock);
-
 	BUILD_BUG_ON(sizeof(ar->fw_features) !=
 		     sizeof(ar->testmode.orig_fw_features));
 
 	memcpy(ar->testmode.orig_fw_features, ar->fw_features,
 	       sizeof(ar->fw_features));
 	ar->testmode.orig_wmi_op_version = ar->wmi.op_version;
-
-	/* utf.bin firmware image does not advertise firmware features. Do
-	 * an ugly hack where we force the firmware features so that wmi.c
-	 * will use the correct WMI interface.
-	 */
 	memset(ar->fw_features, 0, sizeof(ar->fw_features));
-	ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
 
+	if(ath10k_tm_fetch_utf_firmware_api(ar,ar->testmode.utf->data, ar->testmode.utf->size)){
+		ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "utf firmware %s advertise firmware feature\n",filename);
+		ar->wmi.op_version = ar->testmode.op_version;
+	}else{
+		/* for utf.bin firmware image does not advertise firmware features. Do
+		* an ugly hack where we force the firmware features so that wmi.c
+		* will use the correct WMI interface.
+		*/
+		ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "utf firmware %s doesn't advertise firmware feature\n",filename);
+		ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
+		ar->testmode.utf_firmware_data = ar->testmode.utf->data;
+		ar->testmode.utf_firmware_len = ar->testmode.utf->size;
+	}
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode wmi version %d\n",
+		ar->wmi.op_version);
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 567b797..cc3d993 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -23,6 +23,7 @@
 #include "wmi-ops.h"
 #include "wmi-tlv.h"
 #include "p2p.h"
+#include "testmode.h"
 
 /***************/
 /* TLV helpers */
@@ -419,7 +420,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
-
+	bool consumed;
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
 
@@ -428,6 +429,18 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
+	consumed = ath10k_tm_event_wmi(ar, id, skb);
+
+	/* Ready event must be handled normally also in UTF mode so that we
+	 * know the UTF firmware has booted, others we are just bypass WMI
+	 * events to testmode.
+	 */
+	if (consumed && id != WMI_TLV_READY_EVENTID) {
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			"wmi tlv testmode consumed 0x%x\n", id);
+		goto out;
+	}
+
 	switch (id) {
 	case WMI_TLV_MGMT_RX_EVENTID:
 		ath10k_wmi_event_mgmt_rx(ar, skb);
-- 
1.9.1

