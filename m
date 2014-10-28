Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33251 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaJ1Oux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:50:53 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/5] wil6210: reset flow updates
Date: Tue, 28 Oct 2014 16:50:07 +0200
Message-ID: <1414507810-23141-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155056_920777_C7A70FA9)
In-Reply-To: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As communicated with the firmware & hardware teams

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 23 ++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h |  6 ++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7900384..0e95557 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -400,7 +400,7 @@ static inline void wil_release_cpu(struct wil6210_priv *wil)
 static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
-	u32 hw_state;
+	u32 x;
 	u32 rev_id;
 	bool is_sparrow = (wil->board->board == WIL_BOARD_SPARROW);
 
@@ -415,9 +415,22 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	S(RGF_USER_CLKS_CTL_SW_RST_MASK_0, BIT_CAR_PERST_RST);
 
 	wil_halt_cpu(wil);
-	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_CAR_AHB_SW_SEL); /* 40 MHz */
 
 	if (is_sparrow) {
+		S(RGF_CAF_OSC_CONTROL, BIT_CAF_OSC_XTAL_EN);
+		/* XTAL stabilization should take about 3ms */
+		usleep_range(5000, 7000);
+		x = R(RGF_CAF_PLL_LOCK_STATUS);
+		if (!(x & BIT_CAF_OSC_DIG_XTAL_STABLE)) {
+			wil_err(wil, "Xtal stabilization timeout\n"
+				"RGF_CAF_PLL_LOCK_STATUS = 0x%08x\n", x);
+			return -ETIME;
+		}
+		/* switch 10k to XTAL*/
+		C(RGF_USER_SPARROW_M_4, BIT_SPARROW_M_4_SEL_SLEEP_OR_REF);
+		/* 40 MHz */
+		C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_CAR_AHB_SW_SEL);
+
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0, 0x3ff81f);
 		W(RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1, 0xf);
 	}
@@ -458,13 +471,13 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	/* wait until device ready. typical time is 200..250 msec */
 	do {
 		msleep(RST_DELAY);
-		hw_state = R(RGF_USER_HW_MACHINE_STATE);
+		x = R(RGF_USER_HW_MACHINE_STATE);
 		if (delay++ > RST_COUNT) {
 			wil_err(wil, "Reset not completed, hw_state 0x%08x\n",
-				hw_state);
+				x);
 			return -ETIME;
 		}
-	} while (hw_state != HW_MACHINE_BOOT_DONE);
+	} while (x != HW_MACHINE_BOOT_DONE);
 
 	/* TODO: Erez check rev_id != 1 */
 	if (!is_sparrow && (rev_id != 1))
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 7ffaf2f..18f8729 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -117,6 +117,8 @@ struct RGF_ICR {
 	#define BIT_USER_USER_ICR_SW_INT_2	BIT(18)
 #define RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_0	(0x880c18)
 #define RGF_USER_CLKS_CTL_EXT_SW_RST_VEC_1	(0x880c2c)
+#define RGF_USER_SPARROW_M_4			(0x880c50) /* Sparrow */
+	#define BIT_SPARROW_M_4_SEL_SLEEP_OR_REF	BIT(2)
 
 #define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
 	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
@@ -152,6 +154,10 @@ struct RGF_ICR {
 #define RGF_MAC_MTRL_COUNTER_0		(0x886aa8)
 
 #define RGF_CAF_ICR			(0x88946c) /* struct RGF_ICR */
+#define RGF_CAF_OSC_CONTROL		(0x88afa4)
+	#define BIT_CAF_OSC_XTAL_EN		BIT(0)
+#define RGF_CAF_PLL_LOCK_STATUS		(0x88afec)
+	#define BIT_CAF_OSC_DIG_XTAL_STABLE	BIT(0)
 
 /* popular locations */
 #define HOST_MBOX   HOSTADDR(RGF_USER_USER_SCRATCH_PAD)
-- 
2.1.0

