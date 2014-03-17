Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7311 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480AbaCQNe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:59 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 10/21] wil6210: sort HW registers definitions
Date: Mon, 17 Mar 2014 15:34:14 +0200
Message-ID: <1395063265-6522-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143515_063631_C030EBF6)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put all registers in order for easier navigation;
fix naming to reflect hardware cluster

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    |  6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h | 31 +++++++++++++++---------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1f9f1d2..bd27bee 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -244,7 +244,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 #define S(a, v) iowrite32(ioread32(wil->csr + HOSTADDR(a)) | v, \
 		wil->csr + HOSTADDR(a))
 
-	wil->hw_version = R(RGF_FW_REV_ID);
+	wil->hw_version = R(RGF_USER_FW_REV_ID);
 	rev_id = wil->hw_version & 0xff;
 	/* hpal_perst_from_pad_src_n_mask */
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
@@ -268,7 +268,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	if (rev_id == 1) {
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
 	} else {
-		W(RGF_LOS_COUNTER_CTL, BIT(6) | BIT(8));
+		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(6) | BIT(8));
 		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
 	}
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
@@ -284,7 +284,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	} while (baud_rate != 0x15e);
 
 	if (rev_id == 2)
-		W(RGF_LOS_COUNTER_CTL, BIT(8));
+		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
 
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 317621c..b376399 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -74,26 +74,18 @@ struct RGF_ICR {
 } __packed;
 
 /* registers - FW addresses */
-#define RGF_FW_REV_ID			(0x880a8c) /* chip revision */
 #define RGF_USER_SERIAL_BAUD_RATE	(0x880050)
-#define RGF_LOS_COUNTER_CTL		(0x882dc4)
-#define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
-#define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
-	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
-#define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
-#define RGF_USER_MAC_CPU_0		(0x8801fc)
 #define RGF_USER_USER_CPU_0		(0x8801e0)
+#define RGF_USER_MAC_CPU_0		(0x8801fc)
+#define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
+#define RGF_USER_FW_REV_ID		(0x880a8c) /* chip revision */
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_0	(0x880b04)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_1	(0x880b08)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_2	(0x880b0c)
 #define RGF_USER_CLKS_CTL_SW_RST_VEC_3	(0x880b10)
-
-#define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
-#define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
-#define RGF_DMA_PSEUDO_CAUSE_MASK_FW	(0x881c70)
-	#define BIT_DMA_PSEUDO_CAUSE_RX		BIT(0)
-	#define BIT_DMA_PSEUDO_CAUSE_TX		BIT(1)
-	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
+#define RGF_USER_CLKS_CTL_SW_RST_MASK_0	(0x880b14)
+#define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
+	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
 
 #define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
 	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
@@ -108,13 +100,22 @@ struct RGF_ICR {
 /* Interrupt moderation control */
 #define RGF_DMA_ITR_CNT_TRSH		(0x881c5c)
 #define RGF_DMA_ITR_CNT_DATA		(0x881c60)
-#define RGF_DMA_ITR_CNT_CRL		(0x881C64)
+#define RGF_DMA_ITR_CNT_CRL		(0x881c64)
 	#define BIT_DMA_ITR_CNT_CRL_EN		BIT(0)
 	#define BIT_DMA_ITR_CNT_CRL_EXT_TICK	BIT(1)
 	#define BIT_DMA_ITR_CNT_CRL_FOREVER	BIT(2)
 	#define BIT_DMA_ITR_CNT_CRL_CLR		BIT(3)
 	#define BIT_DMA_ITR_CNT_CRL_REACH_TRSH	BIT(4)
 
+#define RGF_DMA_PSEUDO_CAUSE		(0x881c68)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_SW	(0x881c6c)
+#define RGF_DMA_PSEUDO_CAUSE_MASK_FW	(0x881c70)
+	#define BIT_DMA_PSEUDO_CAUSE_RX		BIT(0)
+	#define BIT_DMA_PSEUDO_CAUSE_TX		BIT(1)
+	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
+
+#define RGF_PCIE_LOS_COUNTER_CTL	(0x882dc4)
+
 /* popular locations */
 #define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
 #define HOST_SW_INT (HOSTADDR(RGF_USER_USER_ICR) + \
-- 
1.8.3.2

