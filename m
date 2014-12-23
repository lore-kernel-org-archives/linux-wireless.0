Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaLWHsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:33 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 15/22] wil6210: detect HW capabilities
Date: Tue, 23 Dec 2014 09:47:17 +0200
Message-Id: <1419320844-23989-16-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091346_908954_5CE8A72C)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read relevant information (HW ID for now) once on init
and set capabilities accordingly.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 32 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  | 20 ++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 66626a8..371809d 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -31,6 +31,36 @@ static bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(debug_fw, " load driver if FW not ready. For FW debug");
 
+static
+void wil_set_capabilities(struct wil6210_priv *wil)
+{
+	u32 rev_id = ioread32(wil->csr + HOSTADDR(RGF_USER_JTAG_DEV_ID));
+
+	bitmap_zero(wil->hw_capabilities, hw_capability_last);
+
+	switch (rev_id) {
+	case JTAG_DEV_ID_MARLON_B0:
+		wil_info(wil, "Board hardware is Marlon B0\n");
+		wil->hw_version = HW_VER_MARLON_B0;
+		break;
+	case JTAG_DEV_ID_SPARROW_A0:
+		wil_info(wil, "Board hardware is Sparrow A0\n");
+		wil->hw_version = HW_VER_SPARROW_A0;
+		break;
+	case JTAG_DEV_ID_SPARROW_A1:
+		wil_info(wil, "Board hardware is Sparrow A1\n");
+		wil->hw_version = HW_VER_SPARROW_A1;
+		break;
+	case JTAG_DEV_ID_SPARROW_B0:
+		wil_info(wil, "Board hardware is Sparrow B0\n");
+		wil->hw_version = HW_VER_SPARROW_B0;
+		break;
+	default:
+		wil_err(wil, "Unknown board hardware 0x%08x\n", rev_id);
+		wil->hw_version = HW_VER_UNKNOWN;
+	}
+}
+
 void wil_disable_irq(struct wil6210_priv *wil)
 {
 	int irq = wil->pdev->irq;
@@ -205,7 +235,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, wil);
 	wil->pdev = pdev;
 	wil->board = board;
-
+	wil_set_capabilities(wil);
 	wil6210_clear_irq(wil);
 
 	wil->platform_handle =
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 64a6d49..d296f2e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -188,6 +188,20 @@ struct RGF_ICR {
 #define RGF_CAF_PLL_LOCK_STATUS		(0x88afec)
 	#define BIT_CAF_OSC_DIG_XTAL_STABLE	BIT(0)
 
+#define RGF_USER_JTAG_DEV_ID	(0x880b34) /* device ID */
+	#define JTAG_DEV_ID_MARLON_B0	(0x0612072f)
+	#define JTAG_DEV_ID_SPARROW_A0	(0x0632072f)
+	#define JTAG_DEV_ID_SPARROW_A1	(0x1632072f)
+	#define JTAG_DEV_ID_SPARROW_B0	(0x2632072f)
+
+enum {
+	HW_VER_UNKNOWN,
+	HW_VER_MARLON_B0,  /* JTAG_DEV_ID_MARLON_B0  */
+	HW_VER_SPARROW_A0, /* JTAG_DEV_ID_SPARROW_A0 */
+	HW_VER_SPARROW_A1, /* JTAG_DEV_ID_SPARROW_A1 */
+	HW_VER_SPARROW_B0, /* JTAG_DEV_ID_SPARROW_B0 */
+};
+
 /* popular locations */
 #define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
 #define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
@@ -426,6 +440,11 @@ enum {
 	fw_recovery_running = 2,
 };
 
+enum {
+	hw_capability_dummy, /* to avoid zero array */
+	hw_capability_last
+};
+
 struct wil_back_rx {
 	struct list_head list;
 	/* request params, converted to CPU byte order - what we asked for */
@@ -452,6 +471,7 @@ struct wil6210_priv {
 	DECLARE_BITMAP(status, wil_status_last);
 	u32 fw_version;
 	u32 hw_version;
+	DECLARE_BITMAP(hw_capabilities, hw_capability_last);
 	struct wil_board *board;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
 	u32 recovery_count; /* num of FW recovery attempts in a short time */
-- 
2.1.0

