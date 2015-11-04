Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35393 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbbKDLxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 06:53:51 -0500
Received: by wmll128 with SMTP id l128so111985149wml.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 03:53:50 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 3/4] ath10k: introduce dev_id to hw_params
Date: Wed,  4 Nov 2015 12:53:34 +0100
Message-Id: <1446638015-23310-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20151104_125359_505732_7F3BB705)
In-Reply-To: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A follow up patch introducing a QCA9377 hw1.0 support will need
this device identification helper for an explicit distinction of
HWs, as apparently both QCA6174 hw3.0 and QCA9377 share the same BMI
target version (0x0502000x). For the QCA9377 hw1.1 previously
added we were just lucky we did not overlap with the same chip_id_rev.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 27 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ++++++
 drivers/net/wireless/ath/ath10k/pci.c  |  6 ------
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a30d41559134..b80b8f372354 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(rawmode, "Use raw 802.11 frame datapath");
 static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA988X_HW_2_0_VERSION,
+		.dev_id = QCA988X_2_0_DEVICE_ID,
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -69,6 +70,25 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
+		.dev_id = QCA6164_2_1_DEVICE_ID,
+		.name = "qca6164 hw2.1",
+		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
+		.uart_pin = 6,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.fw = {
+			.dir = QCA6174_HW_2_1_FW_DIR,
+			.fw = QCA6174_HW_2_1_FW_FILE,
+			.otp = QCA6174_HW_2_1_OTP_FILE,
+			.board = QCA6174_HW_2_1_BOARD_DATA_FILE,
+			.board_size = QCA6174_BOARD_DATA_SZ,
+			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+		},
+	},
+	{
+		.id = QCA6174_HW_2_1_VERSION,
+		.dev_id = QCA6174_2_1_DEVICE_ID,
 		.name = "qca6174 hw2.1",
 		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -86,6 +106,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
+		.dev_id = QCA6174_2_1_DEVICE_ID,
 		.name = "qca6174 hw3.0",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -103,6 +124,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
+		.dev_id = QCA6174_2_1_DEVICE_ID,
 		.name = "qca6174 hw3.2",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -121,6 +143,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
+		.dev_id = QCA99X0_2_0_DEVICE_ID,
 		.name = "qca99x0 hw2.0",
 		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -139,6 +162,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.dev_id = QCA9377_1_0_DEVICE_ID,
 		.name = "qca9377 hw1.1",
 		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -1265,7 +1289,8 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
 		hw_params = &ath10k_hw_params_list[i];
 
-		if (hw_params->id == ar->target_version)
+		if (hw_params->id == ar->target_version &&
+		    hw_params->dev_id == ar->dev_id)
 			break;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4a2301589902..622d3816eaf4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -636,6 +636,7 @@ struct ath10k {
 
 	struct ath10k_hw_params {
 		u32 id;
+		u16 dev_id;
 		const char *name;
 		u32 patch_load_addr;
 		int uart_pin;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 01bf2244f54c..13aacbdc98e6 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -22,6 +22,12 @@
 
 #define ATH10K_FW_DIR			"ath10k"
 
+#define QCA988X_2_0_DEVICE_ID   (0x003c)
+#define QCA6164_2_1_DEVICE_ID   (0x0041)
+#define QCA6174_2_1_DEVICE_ID   (0x003e)
+#define QCA99X0_2_0_DEVICE_ID   (0x0040)
+#define QCA9377_1_0_DEVICE_ID   (0x0042)
+
 /* QCA988X 1.0 definitions (unsupported) */
 #define QCA988X_HW_1_0_CHIP_ID_REV	0x0
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c444b43f183d..14dce2a1b39f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -57,12 +57,6 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define ATH10K_PCI_TARGET_WAIT 3000
 #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
-#define QCA988X_2_0_DEVICE_ID	(0x003c)
-#define QCA6164_2_1_DEVICE_ID	(0x0041)
-#define QCA6174_2_1_DEVICE_ID	(0x003e)
-#define QCA99X0_2_0_DEVICE_ID	(0x0040)
-#define QCA9377_1_0_DEVICE_ID	(0x0042)
-
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA6164_2_1_DEVICE_ID) }, /* PCI-E QCA6164 V2.1 */
-- 
2.1.2

