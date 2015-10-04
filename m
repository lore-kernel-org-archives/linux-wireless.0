Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:48 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Lior David <liord@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 03/10] wil6210: log firmware crash information
Date: Sun,  4 Oct 2015 10:23:20 +0300
Message-Id: <1443943407-6663-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092352_802576_3DDB2B29)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print firmware and ucode assert codes when firmware crashed.

Signed-off-by: Lior David <liord@qti.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 7 ++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h   | 4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index a371f036..f651994 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -347,7 +347,12 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	wil6210_mask_irq_misc(wil);
 
 	if (isr & ISR_MISC_FW_ERROR) {
-		wil_err(wil, "Firmware error detected\n");
+		u32 fw_assert_code = wil_r(wil, RGF_FW_ASSERT_CODE);
+		u32 ucode_assert_code = wil_r(wil, RGF_UCODE_ASSERT_CODE);
+
+		wil_err(wil,
+			"Firmware error detected, assert codes FW 0x%08x, UCODE 0x%08x\n",
+			fw_assert_code, ucode_assert_code);
 		clear_bit(wil_status_fwready, wil->status);
 		/*
 		 * do not clear @isr here - we do 2-nd part in thread
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e405bef..525ce2c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -246,6 +246,10 @@ struct RGF_ICR {
 #define RGF_USER_JTAG_DEV_ID	(0x880b34) /* device ID */
 	#define JTAG_DEV_ID_SPARROW_B0	(0x2632072f)
 
+/* crash codes for FW/Ucode stored here */
+#define RGF_FW_ASSERT_CODE		(0x91f020)
+#define RGF_UCODE_ASSERT_CODE		(0x91f028)
+
 enum {
 	HW_VER_UNKNOWN,
 	HW_VER_SPARROW_B0, /* JTAG_DEV_ID_SPARROW_B0 */
-- 
2.1.4

