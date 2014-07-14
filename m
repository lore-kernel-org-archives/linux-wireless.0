Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29962 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGNGvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:07 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 1/7] wil6210: support for "sparrow" hardware
Date: Mon, 14 Jul 2014 09:49:37 +0300
Message-ID: <1405320583-5775-2-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085112_925316_490F767E)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

New hardware release appears; it require some changes to properly support  it.
Introduce struct wil_board and "board" attribute in wil6210_priv;
keep hardware variant information in this structure.
fill it on probe(). Used in the reset flow.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c     |   42 +++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   22 ++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h  |   10 ++++++
 3 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 53a689e..3704d2a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -314,8 +314,9 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	int delay = 0;
 	u32 hw_state;
 	u32 rev_id;
+	bool is_sparrow = (wil->board->board == WIL_BOARD_SPARROW);
 
-	wil_dbg_misc(wil, "Resetting...\n");
+	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->board->name);
 
 	/* register read */
 #define R(a) ioread32(wil->csr + HOSTADDR(a))
@@ -328,35 +329,59 @@ static void wil_target_reset(struct wil6210_priv *wil)
 
 	wil->hw_version = R(RGF_USER_FW_REV_ID);
 	rev_id = wil->hw_version & 0xff;
+
+	/* Clear MAC link up */
+	S(RGF_HP_CTRL, BIT(15));
 	/* hpal_perst_from_pad_src_n_mask */
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
 	/* car_perst_rst_src_n_mask */
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(7));
 	wmb(); /* order is important here */
 
+	if (is_sparrow) {
+		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x3ff81f);
+		wmb(); /* order is important here */
+	}
+
 	W(RGF_USER_MAC_CPU_0,  BIT(1)); /* mac_cpu_man_rst */
 	W(RGF_USER_USER_CPU_0, BIT(1)); /* user_cpu_man_rst */
 	wmb(); /* order is important here */
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0xFE000000);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0x0000003F);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000170);
+	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, is_sparrow ? 0x000000B0 : 0x00000170);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0xFFE7FC00);
 	wmb(); /* order is important here */
 
+	if (is_sparrow) {
+		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x0);
+		wmb(); /* order is important here */
+	}
+
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_1, 0);
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 	wmb(); /* order is important here */
 
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
-	if (rev_id == 1) {
-		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
-	} else {
-		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
+	if (is_sparrow) {
+		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000003);
+		/* reset A2 PCIE AHB */
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
+
+	} else {
+		W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
+		if (rev_id == 1) {
+			/* reset A1 BOTH PCIE AHB & PCIE RGF */
+			W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
+		} else {
+			W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
+			W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
+		}
+
 	}
+
+	/* TODO: check order here!!! Erez code is different */
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 	wmb(); /* order is important here */
 
@@ -371,7 +396,8 @@ static void wil_target_reset(struct wil6210_priv *wil)
 		}
 	} while (hw_state != HW_MACHINE_BOOT_DONE);
 
-	if (rev_id == 2)
+	/* TODO: Erez check rev_id != 1 */
+	if (!is_sparrow && (rev_id != 1))
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 77b6272..d3fbfa2 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -122,10 +122,12 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct wil6210_priv *wil;
 	struct device *dev = &pdev->dev;
 	void __iomem *csr;
+	struct wil_board *board = (struct wil_board *)id->driver_data;
 	int rc;
 
 	/* check HW */
-	dev_info(&pdev->dev, WIL_NAME " device found [%04x:%04x] (rev %x)\n",
+	dev_info(&pdev->dev, WIL_NAME
+		 " \"%s\" device found [%04x:%04x] (rev %x)\n", board->name,
 		 (int)pdev->vendor, (int)pdev->device, (int)pdev->revision);
 
 	if (pci_resource_len(pdev, 0) != WIL6210_MEM_SIZE) {
@@ -175,6 +177,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, wil);
 	wil->pdev = pdev;
+	wil->board = board;
 
 	wil6210_clear_irq(wil);
 	/* FW should raise IRQ when ready */
@@ -225,8 +228,21 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(wil6210_pcie_ids) = {
-	{ PCI_DEVICE(0x1ae9, 0x0301) },
+static const struct wil_board wil_board_marlon = {
+	.board = WIL_BOARD_MARLON,
+	.name = "marlon",
+};
+
+static const struct wil_board wil_board_sparrow = {
+	.board = WIL_BOARD_SPARROW,
+	.name = "sparrow",
+};
+
+static const struct pci_device_id wil6210_pcie_ids[] = {
+	{ PCI_DEVICE(0x1ae9, 0x0301),
+	  .driver_data = (kernel_ulong_t)&wil_board_marlon },
+	{ PCI_DEVICE(0x1ae9, 0x0310),
+	  .driver_data = (kernel_ulong_t)&wil_board_sparrow },
 	{ /* end: all zeroes */	},
 };
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4249066..09c36a7 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -24,6 +24,13 @@
 
 #define WIL_NAME "wil6210"
 
+struct wil_board {
+	int board;
+#define WIL_BOARD_MARLON	(1)
+#define WIL_BOARD_SPARROW	(2)
+	const char * const name;
+};
+
 /**
  * extract bits [@b0:@b1] (inclusive) from the value @x
  * it should be @b0 <= @b1, or result is incorrect
@@ -93,6 +100,7 @@ struct RGF_ICR {
 #define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
 #define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
 	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
+#define RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0	(0x880c18)
 
 #define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
 	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
@@ -121,6 +129,7 @@ struct RGF_ICR {
 	#define BIT_DMA_PSEUDO_CAUSE_TX		BIT(1)
 	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
 
+#define RGF_HP_CTRL			(0x88265c)
 #define RGF_PCIE_LOS_COUNTER_CTL	(0x882dc4)
 
 /* popular locations */
@@ -365,6 +374,7 @@ struct wil6210_priv {
 	ulong status;
 	u32 fw_version;
 	u32 hw_version;
+	struct wil_board *board;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
 	int recovery_count; /* num of FW recovery attempts in a short time */
 	unsigned long last_fw_recovery; /* jiffies of last fw recovery */
-- 
1.7.6

