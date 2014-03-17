Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24137 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaCQNev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:51 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 06/21] wil6210: update target reset to support new HW
Date: Mon, 17 Mar 2014 15:34:10 +0200
Message-ID: <1395063265-6522-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145649_839809_73D999B6)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for new chip revision. Revision read from the
internal register, PCIE config's "revision id" register
do not indicate HW version properly

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c     | 29 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  4 ++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4cc1b78..8644418 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -230,14 +230,22 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 
 static void wil_target_reset(struct wil6210_priv *wil)
 {
+	int delay = 100;
+	u32 baud_rate;
+	u32 rev_id;
+
 	wil_dbg_misc(wil, "Resetting...\n");
 
+	/* register read */
+#define R(a) ioread32(wil->csr + HOSTADDR(a))
 	/* register write */
 #define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
 	/* register set = read, OR, write */
 #define S(a, v) iowrite32(ioread32(wil->csr + HOSTADDR(a)) | v, \
 		wil->csr + HOSTADDR(a))
 
+	wil->hw_version = R(RGF_FW_REV_ID);
+	rev_id = wil->hw_version & 0xff;
 	/* hpal_perst_from_pad_src_n_mask */
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT(6));
 	/* car_perst_rst_src_n_mask */
@@ -257,11 +265,30 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_3, 0x00000001);
-	W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
+	if (rev_id == 1) {
+		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00000080);
+	} else {
+		W(RGF_LOS_COUNTER_CTL, BIT(6) | BIT(8));
+		W(RGF_USER_CLKS_CTL_SW_RST_VEC_2, 0x00008000);
+	}
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
+	/* wait until device ready. Use baud rate */
+	do {
+		msleep(1);
+		baud_rate = R(RGF_USER_SERIAL_BAUD_RATE);
+		if (delay-- < 0) {
+			wil_err(wil, "Reset not completed\n");
+			return;
+		}
+	} while (baud_rate != 0x15e);
+
+	if (rev_id == 2)
+		W(RGF_LOS_COUNTER_CTL, BIT(8));
+
 	wil_dbg_misc(wil, "Reset completed\n");
 
+#undef R
 #undef W
 #undef S
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index eeceab3..d96e811 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -74,6 +74,8 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	if (rc)
 		goto release_irq;
 
+	wil_info(wil, "HW version: 0x%08x\n", wil->hw_version);
+
 	return 0;
 
  release_irq:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 11e0898..14f861c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -74,6 +74,9 @@ struct RGF_ICR {
 } __packed;
 
 /* registers - FW addresses */
+#define RGF_FW_REV_ID			(0x880a8c) /* chip revision */
+#define RGF_USER_SERIAL_BAUD_RATE	(0x880050)
+#define RGF_LOS_COUNTER_CTL		(0x882dc4)
 #define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
 #define RGF_USER_USER_ICR		(0x880b4c) /* struct RGF_ICR */
 	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
@@ -342,6 +345,7 @@ struct wil6210_priv {
 	void __iomem *csr;
 	ulong status;
 	u32 fw_version;
+	u32 hw_version;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
 	/* profile */
 	u32 monitor_flags;
-- 
1.8.3.2

