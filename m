Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25940 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeAUJVD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jan 2018 04:21:03 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 5/8] wil6210: configure OTP HW vectors in SW reset flow
Date: Sun, 21 Jan 2018 11:14:40 +0200
Message-Id: <1516526083-31389-6-git-send-email-merez@codeaurora.org> (sfid-20180121_102113_652189_84FC197A)
In-Reply-To: <1516526083-31389-1-git-send-email-merez@codeaurora.org>
References: <1516526083-31389-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OTP HW vectors values are different for 40MHz and 330MHz AHB
clocks.
In SW reset flow, the host driver sets the clock frequency
to 40MHz. In order to allow reading from the OTP, the host
driver should configure the OTP HW vectors with the values
that fits this clock frequency.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c    | 15 +++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h | 11 +++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f6cca0f..d95ff74 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -764,6 +764,21 @@ static int wil_target_reset(struct wil6210_priv *wil, int no_flash)
 	wil_s(wil, RGF_DMA_OFUL_NID_0, BIT_DMA_OFUL_NID_0_RX_EXT_TR_EN |
 	      BIT_DMA_OFUL_NID_0_RX_EXT_A3_SRC);
 
+	if (no_flash) {
+		/* Reset OTP HW vectors to fit 40MHz */
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME1, 0x60001);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME2, 0x20027);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME3, 0x1);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME4, 0x20027);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME5, 0x30003);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME6, 0x20002);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME7, 0x60001);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME8, 0x60001);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME9, 0x60001);
+		wil_w(wil, RGF_USER_XPM_IFC_RD_TIME10, 0x60001);
+		wil_w(wil, RGF_USER_XPM_RD_DOUT_SAMPLE_TIME, 0x57);
+	}
+
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay * RST_DELAY);
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2273a05..d243df3 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -197,6 +197,17 @@ struct RGF_ICR {
 	#define BIT_SPARROW_M_4_SEL_SLEEP_OR_REF	BIT(2)
 #define RGF_USER_OTP_HW_RD_MACHINE_1	(0x880ce0)
 	#define BIT_NO_FLASH_INDICATION		BIT(8)
+#define RGF_USER_XPM_IFC_RD_TIME1	(0x880cec)
+#define RGF_USER_XPM_IFC_RD_TIME2	(0x880cf0)
+#define RGF_USER_XPM_IFC_RD_TIME3	(0x880cf4)
+#define RGF_USER_XPM_IFC_RD_TIME4	(0x880cf8)
+#define RGF_USER_XPM_IFC_RD_TIME5	(0x880cfc)
+#define RGF_USER_XPM_IFC_RD_TIME6	(0x880d00)
+#define RGF_USER_XPM_IFC_RD_TIME7	(0x880d04)
+#define RGF_USER_XPM_IFC_RD_TIME8	(0x880d08)
+#define RGF_USER_XPM_IFC_RD_TIME9	(0x880d0c)
+#define RGF_USER_XPM_IFC_RD_TIME10	(0x880d10)
+#define RGF_USER_XPM_RD_DOUT_SAMPLE_TIME (0x880d64)
 
 #define RGF_DMA_EP_TX_ICR		(0x881bb4) /* struct RGF_ICR */
 	#define BIT_DMA_EP_TX_ICR_TX_DONE	BIT(0)
-- 
1.9.1
