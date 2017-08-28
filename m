Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41752 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751192AbdH1TTE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 15:19:04 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5/7] wil6210: clear PAL_UNIT_ICR part of device reset
Date: Mon, 28 Aug 2017 22:18:45 +0300
Message-Id: <1503947927-18877-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170828_211907_839412_7C01C8C7)
In-Reply-To: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

When FW starts running it can get D0 to D3 interrupt that is a leftover
from previous system suspend while FW was not running.
As this interrupt is not relevant anymore, clear it part of device reset
procedure.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 927e332..bac829a 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -943,6 +943,8 @@ static void wil_pre_fw_config(struct wil6210_priv *wil)
 	/* it is W1C, clear by writing back same value */
 	wil_s(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, ICR), 0);
 	wil_w(wil, RGF_CAF_ICR + offsetof(struct RGF_ICR, IMV), ~0);
+	/* clear PAL_UNIT_ICR (potential D0->D3 leftover) */
+	wil_s(wil, RGF_PAL_UNIT_ICR + offsetof(struct RGF_ICR, ICR), 0);
 
 	if (wil->fw_calib_result > 0) {
 		__le32 val = cpu_to_le32(wil->fw_calib_result |
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a8c2680..315ec8b 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -268,6 +268,7 @@ struct RGF_ICR {
 	#define BIT_DMA_PSEUDO_CAUSE_MISC	BIT(2)
 
 #define RGF_HP_CTRL			(0x88265c)
+#define RGF_PAL_UNIT_ICR		(0x88266c) /* struct RGF_ICR */
 #define RGF_PCIE_LOS_COUNTER_CTL	(0x882dc4)
 
 /* MAC timer, usec, for packet lifetime */
-- 
1.9.1
