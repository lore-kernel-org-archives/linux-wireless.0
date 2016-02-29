Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 036/113] rtl8xxxu: Add a couple of new register definitions
Date: Mon, 29 Feb 2016 17:04:34 -0500
Message-Id: <1456783551-28315-37-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230612_209131_F0486D7B)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds some additional register definitions for 8723bu, as well as
a bit define for USB RXDMA aggregation in REG_RXDMA_AGG_PG_TH.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index f1375b8..162a9e8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -388,9 +388,14 @@
 
 /* 0x0280 ~ 0x02FF	RXDMA Configuration */
 #define REG_RXDMA_AGG_PG_TH		0x0280
+#define  RXDMA_USB_AGG_ENABLE		BIT(31)
 #define REG_RXPKT_NUM			0x0284
 #define REG_RXDMA_STATUS		0x0288
 
+/* Presumably only found on newer chips such as 8723bu */
+#define REG_RX_DMA_CTRL_8723B		0x0286
+#define REG_RX_DMA_MODE_CTRL_8723B	0x0290
+
 #define REG_RF_BB_CMD_ADDR		0x02c0
 #define REG_RF_BB_CMD_DATA		0x02c4
 
@@ -473,6 +478,7 @@
 #define REG_POWER_STATUS		0x04a4
 #define REG_POWER_STAGE1		0x04b4
 #define REG_POWER_STAGE2		0x04b8
+#define REG_AMPDU_BURST_MODE_8723B	0x04bc
 #define REG_PKT_VO_VI_LIFE_TIME		0x04c0
 #define REG_PKT_BE_BK_LIFE_TIME		0x04c2
 #define REG_STBC_SETTING		0x04c4
-- 
2.5.0

