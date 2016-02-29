Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 022/113] rtl8xxxu: Add some missing register definitions for 8723bu
Date: Mon, 29 Feb 2016 17:04:20 -0500
Message-Id: <1456783551-28315-23-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231100_587634_A2A81EB9)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This introduces additional register definitions for newer generation
chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 3cbb549..f1375b8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -155,6 +155,8 @@
 /*  RTL8723 WIFI/BT/GPS Multi-Function GPIO Select. */
 #define REG_GPIO_IO_SEL_2		0x0062
 
+/*  RTL8723B */
+#define REG_PAD_CTRL1			0x0064
 /*  RTL8723 only WIFI/BT/GPS Multi-Function control source. */
 #define REG_MULTI_FUNC_CTRL		0x0068
 
@@ -196,9 +198,11 @@
 #define REG_HMBOX_EXT_1			0x008a
 #define REG_HMBOX_EXT_2			0x008c
 #define REG_HMBOX_EXT_3			0x008e
-/* Interrupt registers for 8192e/8812 */
+/* Interrupt registers for 8192e/8723bu/8812 */
 #define REG_HIMR0			0x00b0
+#define REG_HISR0			0x00b4
 #define REG_HIMR1			0x00b8
+#define REG_HISR1			0x00bc
 
 /*  Host suspend counter on FPGA platform */
 #define REG_HOST_SUSP_CNT		0x00bc
@@ -337,6 +341,8 @@
 #define REG_MBIST_DONE			0x0178
 #define REG_MBIST_FAIL			0x017c
 #define REG_C2HEVT_MSG_NORMAL		0x01a0
+/* 8192EU/8723BU/8812 */
+#define REG_C2HEVT_CMD_ID_8723B		0x01ae
 #define REG_C2HEVT_CLEAR		0x01af
 #define REG_C2HEVT_MSG_TEST		0x01b8
 #define REG_MCUTST_1			0x01c0
-- 
2.5.0

