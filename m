Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31539 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbbD3NZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 09:25:23 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 3/7] wil6210: fix boot loader "ready" indication
Date: Thu, 30 Apr 2015 16:25:07 +0300
Message-Id: <1430400311-3861-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150430_152527_701694_ADCBA6BB)
In-Reply-To: <1430400311-3861-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1430400311-3861-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot loader "ready" indication has changed from "bit0 set"
to "only bit0 set". This is to address hardware glitches.
Due to glitches, sometimes right after reset register reads
0xffffffff, or (rarely) other garbage.

Reflect this in the driver

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 0623d8c..146fd80 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -551,7 +551,7 @@ static inline void wil_release_cpu(struct wil6210_priv *wil)
 static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
-	u32 x;
+	u32 x, x1 = 0;
 
 	wil_dbg_misc(wil, "Resetting \"%s\"...\n", wil->hw_name);
 
@@ -606,12 +606,16 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	do {
 		msleep(RST_DELAY);
 		x = R(RGF_USER_BL + offsetof(struct RGF_BL, ready));
+		if (x1 != x) {
+			wil_dbg_misc(wil, "BL.ready 0x%08x => 0x%08x\n", x1, x);
+			x1 = x;
+		}
 		if (delay++ > RST_COUNT) {
 			wil_err(wil, "Reset not completed, bl.ready 0x%08x\n",
 				x);
 			return -ETIME;
 		}
-	} while (!(x & BIT_BL_READY));
+	} while (x != BIT_BL_READY);
 
 	C(RGF_USER_CLKS_CTL_0, BIT_USER_CLKS_RST_PWGD);
 
-- 
2.1.0

