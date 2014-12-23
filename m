Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaLWHse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 16/22] wil6210: use HW capabilities mask in reset
Date: Tue, 23 Dec 2014 09:47:18 +0200
Message-Id: <1419320844-23989-17-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091349_007260_BD8ECAA8)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the proper reset follow based on HW capabilities
detection instead of chip ID.
Remove old hw ID mechanism which was used only for reset flow.
Remove support for Marlon A0.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 11 +++++----
 drivers/net/wireless/ath/wil6210/main.c      | 33 +++++++++++--------------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  | 37 +++++++++++-----------------
 drivers/net/wireless/ath/wil6210/wil6210.h   | 11 ++-------
 4 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5a0ea72..384bb31 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -194,18 +194,19 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 		wil_dbg_irq(wil, "RX done\n");
 
 		if (isr & BIT_DMA_EP_RX_ICR_RX_HTRSH)
-			wil_err_ratelimited(wil, "Received \"Rx buffer is in risk "
-				"of overflow\" interrupt\n");
+			wil_err_ratelimited(wil,
+					    "Received \"Rx buffer is in risk of overflow\" interrupt\n");
 
-		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE | BIT_DMA_EP_RX_ICR_RX_HTRSH);
+		isr &= ~(BIT_DMA_EP_RX_ICR_RX_DONE |
+			 BIT_DMA_EP_RX_ICR_RX_HTRSH);
 		if (test_bit(wil_status_reset_done, wil->status)) {
 			if (test_bit(wil_status_napi_en, wil->status)) {
 				wil_dbg_txrx(wil, "NAPI(Rx) schedule\n");
 				need_unmask = false;
 				napi_schedule(&wil->napi_rx);
 			} else {
-				wil_err(wil, "Got Rx interrupt while "
-					"stopping interface\n");
+				wil_err(wil,
+					"Got Rx interrupt while stopping interface\n");
 			}
 		} else {
 			wil_err(wil, "Got Rx interrupt while in reset\n");
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index a17278f..fb73ac5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -502,13 +502,10 @@ static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
 	u32 x;
-	u32 rev_id;
-	bool is_sparrow = (wil->board->board == WIL_BOARD_SPARROW);
+	bool is_reset_v2 = test_bit(hw_capability_reset_v2,
+				    wil->hw_capabilities);
 
-	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->board->name);
-
-	wil->hw_version = R(RGF_USER_FW_REV_ID);
-	rev_id = wil->hw_version & 0xff;
+	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->hw_name);
 
 	/* Clear MAC link up */
 	S(RGF_HP_CTRL, BIT(15));
@@ -520,7 +517,7 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	/* Clear Fw Download notification */
 	C(RGF_USER_USAGE_6, BIT(0));
 
-	if (is_sparrow) {
+	if (is_reset_v2) {
 		S(RGF_CAF_OSC_CONTROL, BIT_CAF_OSC_XTAL_EN);
 		/* XTAL stabilization should take about 3ms */
 		usleep_range(5000, 7000);
@@ -541,10 +538,11 @@ static int wil_target_reset(struct wil6210_priv *wil)
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, is_sparrow ? 0x000000f0 : 0x00000170);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3,
+	  is_reset_v2 ? 0x000000f0 : 0x00000170);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FE00);
 
-	if (is_sparrow) {
+	if (is_reset_v2) {
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x0);
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0x0);
 	}
@@ -554,19 +552,14 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
-	if (is_sparrow) {
+	if (is_reset_v2) {
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000003);
 		/* reset A2 PCIE AHB */
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 	} else {
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
-		if (rev_id == 1) {
-			/* reset A1 BOTH PCIE AHB & PCIE RGF */
-			W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
-		} else {
-			W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
-			W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
-		}
+		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
+		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 	}
 
 	/* TODO: check order here!!! Erez code is different */
@@ -583,8 +576,7 @@ static int wil_target_reset(struct wil6210_priv *wil)
 		}
 	} while (x != HW_MACHINE_BOOT_DONE);
 
-	/* TODO: Erez check rev_id != 1 */
-	if (!is_sparrow && (rev_id != 1))
+	if (!is_reset_v2)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
@@ -653,6 +645,9 @@ int wil_reset(struct wil6210_priv *wil)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+	if (wil->hw_version == HW_VER_UNKNOWN)
+		return -ENODEV;
+
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 	WARN_ON(test_bit(wil_status_napi_en, wil->status));
 
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 371809d..9b1a589 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -40,25 +40,31 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 
 	switch (rev_id) {
 	case JTAG_DEV_ID_MARLON_B0:
-		wil_info(wil, "Board hardware is Marlon B0\n");
+		wil->hw_name = "Marlon B0";
 		wil->hw_version = HW_VER_MARLON_B0;
 		break;
 	case JTAG_DEV_ID_SPARROW_A0:
-		wil_info(wil, "Board hardware is Sparrow A0\n");
+		wil->hw_name = "Sparrow A0";
 		wil->hw_version = HW_VER_SPARROW_A0;
 		break;
 	case JTAG_DEV_ID_SPARROW_A1:
-		wil_info(wil, "Board hardware is Sparrow A1\n");
+		wil->hw_name = "Sparrow A1";
 		wil->hw_version = HW_VER_SPARROW_A1;
 		break;
 	case JTAG_DEV_ID_SPARROW_B0:
-		wil_info(wil, "Board hardware is Sparrow B0\n");
+		wil->hw_name = "Sparrow B0";
 		wil->hw_version = HW_VER_SPARROW_B0;
 		break;
 	default:
 		wil_err(wil, "Unknown board hardware 0x%08x\n", rev_id);
+		wil->hw_name = "Unknown";
 		wil->hw_version = HW_VER_UNKNOWN;
 	}
+
+	wil_info(wil, "Board hardware is %s\n", wil->hw_name);
+
+	if (wil->hw_version >= HW_VER_SPARROW_A0)
+		set_bit(hw_capability_reset_v2, wil->hw_capabilities);
 }
 
 void wil_disable_irq(struct wil6210_priv *wil)
@@ -179,12 +185,11 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct wil6210_priv *wil;
 	struct device *dev = &pdev->dev;
 	void __iomem *csr;
-	struct wil_board *board = (struct wil_board *)id->driver_data;
 	int rc;
 
 	/* check HW */
 	dev_info(&pdev->dev, WIL_NAME
-		 " \"%s\" device found [%04x:%04x] (rev %x)\n", board->name,
+		 " device found [%04x:%04x] (rev %x)\n",
 		 (int)pdev->vendor, (int)pdev->device, (int)pdev->revision);
 
 	if (pci_resource_len(pdev, 0) != WIL6210_MEM_SIZE) {
@@ -234,7 +239,6 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, wil);
 	wil->pdev = pdev;
-	wil->board = board;
 	wil_set_capabilities(wil);
 	wil6210_clear_irq(wil);
 
@@ -296,23 +300,10 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static const struct wil_board wil_board_marlon = {
-	.board = WIL_BOARD_MARLON,
-	.name = "marlon",
-};
-
-static const struct wil_board wil_board_sparrow = {
-	.board = WIL_BOARD_SPARROW,
-	.name = "sparrow",
-};
-
 static const struct pci_device_id wil6210_pcie_ids[] = {
-	{ PCI_DEVICE(0x1ae9, 0x0301),
-	  .driver_data = (kernel_ulong_t)&wil_board_marlon },
-	{ PCI_DEVICE(0x1ae9, 0x0310),
-	  .driver_data = (kernel_ulong_t)&wil_board_sparrow },
-	{ PCI_DEVICE(0x1ae9, 0x0302), /* same as above, firmware broken */
-	  .driver_data = (kernel_ulong_t)&wil_board_sparrow },
+	{ PCI_DEVICE(0x1ae9, 0x0301) },
+	{ PCI_DEVICE(0x1ae9, 0x0310) },
+	{ PCI_DEVICE(0x1ae9, 0x0302) }, /* same as above, firmware broken */
 	{ /* end: all zeroes */	},
 };
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d296f2e..8a52a5f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -32,13 +32,6 @@ extern int agg_wsize;
 
 #define WIL_MAX_BUS_REQUEST_KBPS 800000 /* ~6.1Gbps */
 
-struct wil_board {
-	int board;
-#define WIL_BOARD_MARLON	(1)
-#define WIL_BOARD_SPARROW	(2)
-	const char * const name;
-};
-
 /**
  * extract bits [@b0:@b1] (inclusive) from the value @x
  * it should be @b0 <= @b1, or result is incorrect
@@ -441,7 +434,7 @@ enum {
 };
 
 enum {
-	hw_capability_dummy, /* to avoid zero array */
+	hw_capability_reset_v2 = 0,
 	hw_capability_last
 };
 
@@ -471,8 +464,8 @@ struct wil6210_priv {
 	DECLARE_BITMAP(status, wil_status_last);
 	u32 fw_version;
 	u32 hw_version;
+	const char *hw_name;
 	DECLARE_BITMAP(hw_capabilities, hw_capability_last);
-	struct wil_board *board;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
 	u32 recovery_count; /* num of FW recovery attempts in a short time */
 	u32 recovery_state; /* FW recovery state machine */
-- 
2.1.0

