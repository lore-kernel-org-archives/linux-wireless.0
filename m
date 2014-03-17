Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5536 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaCQNfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:16 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 19/21] wil6210: target reset flow update
Date: Mon, 17 Mar 2014 15:34:23 +0200
Message-ID: <1395063265-6522-20-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143539_154841_BC8E8271)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 'real' indication for hardware state.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 11 ++++++-----
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 351925b..c782e25 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -269,7 +269,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 static void wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
-	u32 baud_rate;
+	u32 hw_state;
 	u32 rev_id;
 
 	wil_dbg_misc(wil, "Resetting...\n");
@@ -312,15 +312,16 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	}
 	W(RGF_USER_CLKS_CTL_SW_RST_VEC_0, 0);
 
-	/* wait until device ready. Use baud rate */
+	/* wait until device ready */
 	do {
 		msleep(1);
-		baud_rate = R(RGF_USER_SERIAL_BAUD_RATE);
+		hw_state = R(RGF_USER_HW_MACHINE_STATE);
 		if (delay++ > 100) {
-			wil_err(wil, "Reset not completed\n");
+			wil_err(wil, "Reset not completed, hw_state 0x%08x\n",
+				hw_state);
 			return;
 		}
-	} while (baud_rate != 0x15e);
+	} while (hw_state != HW_MACHINE_BOOT_DONE);
 
 	if (rev_id == 2)
 		W(RGF_PCIE_LOS_COUNTER_CTL, BIT(8));
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 80573f7..fb1006b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -74,7 +74,8 @@ struct RGF_ICR {
 } __packed;
 
 /* registers - FW addresses */
-#define RGF_USER_SERIAL_BAUD_RATE	(0x880050)
+#define RGF_USER_HW_MACHINE_STATE	(0x8801dc)
+	#define HW_MACHINE_BOOT_DONE	(0x3fffffd)
 #define RGF_USER_USER_CPU_0		(0x8801e0)
 #define RGF_USER_MAC_CPU_0		(0x8801fc)
 #define RGF_USER_USER_SCRATCH_PAD	(0x8802bc)
-- 
1.8.3.2

