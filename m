Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15294 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752735AbdAKQNy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:13:54 -0500
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 03/12] wil6210: support loading dedicated image for sparrow-plus devices
Date: Wed, 11 Jan 2017 18:12:39 +0200
Message-Id: <1484151168-894-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170111_171408_089574_9BDF231F)
In-Reply-To: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>

Driver may be used in platforms where some use sparrow cards while
other use sparrow-plus cards, where different FW image is needed.
Add the capability to load dedicated FW image in case sparrow-plus
card is detected and fallback to default image if such does not exist.

Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c  |  1 +
 drivers/net/wireless/ath/wil6210/fw.c       |  5 ++--
 drivers/net/wireless/ath/wil6210/fw_inc.c   | 19 +++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     |  8 +++----
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 36 ++++++++++++++++++++++-------
 drivers/net/wireless/ath/wil6210/wil6210.h  | 18 +++++++++++----
 6 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 5e4058a..c9168b4 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1699,6 +1699,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
 	WIL_FIELD(ap_isolate,	S_IRUGO,		doff_u32),
 	WIL_FIELD(discovery_mode, S_IRUGO | S_IWUSR,	doff_u8),
+	WIL_FIELD(chip_revision, S_IRUGO,		doff_u8),
 	{},
 };
 
diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
index 82aae2d..9a62503 100644
--- a/drivers/net/wireless/ath/wil6210/fw.c
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -19,8 +19,9 @@
 #include "wil6210.h"
 #include "fw.h"
 
-MODULE_FIRMWARE(WIL_FW_NAME);
-MODULE_FIRMWARE(WIL_FW2_NAME);
+MODULE_FIRMWARE(WIL_FW_NAME_DEFAULT);
+MODULE_FIRMWARE(WIL_FW_NAME_SPARROW_PLUS);
+MODULE_FIRMWARE(WIL_BOARD_FILE_NAME);
 
 static
 void wil_memset_toio_32(volatile void __iomem *dst, u32 val,
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 8f40eb3..110b532 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -537,3 +537,22 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 	release_firmware(fw);
 	return rc;
 }
+
+/**
+ * wil_fw_verify_file_exists - checks if firmware file exist
+ *
+ * @wil: driver context
+ * @name: firmware file name
+ *
+ * return value - boolean, true for success, false for failure
+ */
+bool wil_fw_verify_file_exists(struct wil6210_priv *wil, const char *name)
+{
+	const struct firmware *fw;
+	int rc;
+
+	rc = request_firmware(&fw, name, wil_to_dev(wil));
+	if (!rc)
+		release_firmware(fw);
+	return rc != -ENOENT;
+}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 90bfa4f..d169cf2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -934,16 +934,16 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	wil_set_oob_mode(wil, oob_mode);
 	if (load_fw) {
-		wil_info(wil, "Use firmware <%s> + board <%s>\n", WIL_FW_NAME,
-			 WIL_FW2_NAME);
+		wil_info(wil, "Use firmware <%s> + board <%s>\n",
+			 wil->wil_fw_name, WIL_BOARD_FILE_NAME);
 
 		wil_halt_cpu(wil);
 		memset(wil->fw_version, 0, sizeof(wil->fw_version));
 		/* Loading f/w from the file */
-		rc = wil_request_firmware(wil, WIL_FW_NAME, true);
+		rc = wil_request_firmware(wil, wil->wil_fw_name, true);
 		if (rc)
 			return rc;
-		rc = wil_request_firmware(wil, WIL_FW2_NAME, true);
+		rc = wil_request_firmware(wil, WIL_BOARD_FILE_NAME, true);
 		if (rc)
 			return rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index a216d99..67c8115 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -36,18 +36,38 @@ static int wil6210_pm_notify(struct notifier_block *notify_block,
 static
 void wil_set_capabilities(struct wil6210_priv *wil)
 {
-	u32 rev_id = wil_r(wil, RGF_USER_JTAG_DEV_ID);
+	u32 jtag_id = wil_r(wil, RGF_USER_JTAG_DEV_ID);
+	u8 chip_revision = (wil_r(wil, RGF_USER_REVISION_ID) &
+			    RGF_USER_REVISION_ID_MASK);
 
 	bitmap_zero(wil->hw_capabilities, hw_capability_last);
 	bitmap_zero(wil->fw_capabilities, WMI_FW_CAPABILITY_MAX);
-
-	switch (rev_id) {
-	case JTAG_DEV_ID_SPARROW_B0:
-		wil->hw_name = "Sparrow B0";
-		wil->hw_version = HW_VER_SPARROW_B0;
+	wil->wil_fw_name = WIL_FW_NAME_DEFAULT;
+	wil->chip_revision = chip_revision;
+
+	switch (jtag_id) {
+	case JTAG_DEV_ID_SPARROW:
+		switch (chip_revision) {
+		case REVISION_ID_SPARROW_D0:
+			wil->hw_name = "Sparrow D0";
+			wil->hw_version = HW_VER_SPARROW_D0;
+			if (wil_fw_verify_file_exists(wil,
+						      WIL_FW_NAME_SPARROW_PLUS))
+				wil->wil_fw_name = WIL_FW_NAME_SPARROW_PLUS;
+			break;
+		case REVISION_ID_SPARROW_B0:
+			wil->hw_name = "Sparrow B0";
+			wil->hw_version = HW_VER_SPARROW_B0;
+			break;
+		default:
+			wil->hw_name = "Unknown";
+			wil->hw_version = HW_VER_UNKNOWN;
+			break;
+		}
 		break;
 	default:
-		wil_err(wil, "Unknown board hardware 0x%08x\n", rev_id);
+		wil_err(wil, "Unknown board hardware, chip_id 0x%08x, chip_revision 0x%08x\n",
+			jtag_id, chip_revision);
 		wil->hw_name = "Unknown";
 		wil->hw_version = HW_VER_UNKNOWN;
 	}
@@ -55,7 +75,7 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 	wil_info(wil, "Board hardware is %s\n", wil->hw_name);
 
 	/* extract FW capabilities from file without loading the FW */
-	wil_request_firmware(wil, WIL_FW_NAME, false);
+	wil_request_firmware(wil, wil->wil_fw_name, false);
 }
 
 void wil_disable_irq(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index b1cebe7..5640fb0 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -36,8 +36,9 @@
 extern bool disable_ap_sme;
 
 #define WIL_NAME "wil6210"
-#define WIL_FW_NAME "wil6210.fw" /* code */
-#define WIL_FW2_NAME "wil6210.brd" /* board & radio parameters */
+#define WIL_FW_NAME_DEFAULT "wil6210.fw" /* code Sparrow B0 */
+#define WIL_FW_NAME_SPARROW_PLUS "wil6210_sparrow_plus.fw" /* code Sparrow D0 */
+#define WIL_BOARD_FILE_NAME "wil6210.brd" /* board & radio parameters */
 
 #define WIL_MAX_BUS_REQUEST_KBPS 800000 /* ~6.1Gbps */
 
@@ -253,7 +254,12 @@ struct RGF_ICR {
 	#define BIT_CAF_OSC_DIG_XTAL_STABLE	BIT(0)
 
 #define RGF_USER_JTAG_DEV_ID	(0x880b34) /* device ID */
-	#define JTAG_DEV_ID_SPARROW_B0	(0x2632072f)
+	#define JTAG_DEV_ID_SPARROW	(0x2632072f)
+
+#define RGF_USER_REVISION_ID		(0x88afe4)
+#define RGF_USER_REVISION_ID_MASK	(3)
+	#define REVISION_ID_SPARROW_B0	(0x0)
+	#define REVISION_ID_SPARROW_D0	(0x3)
 
 /* crash codes for FW/Ucode stored here */
 #define RGF_FW_ASSERT_CODE		(0x91f020)
@@ -261,7 +267,8 @@ struct RGF_ICR {
 
 enum {
 	HW_VER_UNKNOWN,
-	HW_VER_SPARROW_B0, /* JTAG_DEV_ID_SPARROW_B0 */
+	HW_VER_SPARROW_B0, /* REVISION_ID_SPARROW_B0 */
+	HW_VER_SPARROW_D0, /* REVISION_ID_SPARROW_D0 */
 };
 
 /* popular locations */
@@ -587,7 +594,9 @@ struct wil6210_priv {
 	DECLARE_BITMAP(status, wil_status_last);
 	u8 fw_version[ETHTOOL_FWVERS_LEN];
 	u32 hw_version;
+	u8 chip_revision;
 	const char *hw_name;
+	const char *wil_fw_name;
 	DECLARE_BITMAP(hw_capabilities, hw_capability_last);
 	DECLARE_BITMAP(fw_capabilities, WMI_FW_CAPABILITY_MAX);
 	u8 n_mids; /* number of additional MIDs as reported by FW */
@@ -925,6 +934,7 @@ void wil_update_net_queues_bh(struct wil6210_priv *wil, struct vring *vring,
 int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd);
 int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 			 bool load);
+bool wil_fw_verify_file_exists(struct wil6210_priv *wil, const char *name);
 
 int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
-- 
1.9.1
