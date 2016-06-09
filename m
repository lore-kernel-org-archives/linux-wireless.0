Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbcFISiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:38:52 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 2/4] rtl8xxxu: Add additional documentation for RX DMA registers
Date: Thu,  9 Jun 2016 14:38:48 -0400
Message-Id: <1465497530-18510-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160609_203900_413211_E3A1D605)
In-Reply-To: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This also renames REG_USB_AGG_{TO,TH} to REG_USB_AGG_{TIMEOUT,THRESH}

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index bff883c..921c565 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -405,7 +405,11 @@
 #define REG_DWBCN1_CTRL_8723B		0x0228
 
 /* 0x0280 ~ 0x02FF	RXDMA Configuration */
-#define REG_RXDMA_AGG_PG_TH		0x0280
+#define REG_RXDMA_AGG_PG_TH		0x0280	/* 0-7 : USB DMA size bits
+						   8-14: USB DMA timeout
+						   15  : Aggregation enable
+						         Only seems to be used
+							 on 8723bu/8192eu */
 #define  RXDMA_USB_AGG_ENABLE		BIT(31)
 #define REG_RXPKT_NUM			0x0284
 #define  RXPKT_NUM_RXDMA_IDLE		BIT(17)
@@ -1058,8 +1062,8 @@
 						   0: Use int, 1: use bulk */
 #define REG_USB_HRPWM			0xfe58
 #define REG_USB_DMA_AGG_TO		0xfe5b
-#define REG_USB_AGG_TO			0xfe5c
-#define REG_USB_AGG_TH			0xfe5d
+#define REG_USB_AGG_TIMEOUT		0xfe5c
+#define REG_USB_AGG_THRESH		0xfe5d
 
 #define REG_NORMAL_SIE_VID		0xfe60	/* 0xfe60 - 0xfe61 */
 #define REG_NORMAL_SIE_PID		0xfe62	/* 0xfe62 - 0xfe63 */
-- 
2.5.5

