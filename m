Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbcCaVIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:44 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 06/10] rtl8xxxu: Update some register definitions
Date: Thu, 31 Mar 2016 17:08:38 -0400
Message-Id: <1459458522-28686-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_231040_345719_1D4EDCC8)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Improve descriptive names of some registers and add some additional
registers only found on nextgen chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  | 31 +++++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index e545e84..ade42fe 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -417,13 +417,20 @@
 
 /*  spec version 11 */
 /* 0x0400 ~ 0x047F	Protocol Configuration */
-#define REG_VOQ_INFORMATION		0x0400
-#define REG_VIQ_INFORMATION		0x0404
-#define REG_BEQ_INFORMATION		0x0408
-#define REG_BKQ_INFORMATION		0x040c
-#define REG_MGQ_INFORMATION		0x0410
-#define REG_HGQ_INFORMATION		0x0414
-#define REG_BCNQ_INFORMATION		0x0418
+/* 8192c, 8192d */
+#define REG_VOQ_INFO			0x0400
+#define REG_VIQ_INFO			0x0404
+#define REG_BEQ_INFO			0x0408
+#define REG_BKQ_INFO			0x040c
+/* 8188e, 8723a, 8812a, 8821a, 8192e, 8723b */
+#define REG_Q0_INFO			0x400
+#define REG_Q1_INFO			0x404
+#define REG_Q2_INFO			0x408
+#define REG_Q3_INFO			0x40c
+
+#define REG_MGQ_INFO			0x0410
+#define REG_HGQ_INFO			0x0414
+#define REG_BCNQ_INFO			0x0418
 
 #define REG_CPU_MGQ_INFORMATION		0x041c
 #define REG_FWHW_TXQ_CTRL		0x0420
@@ -494,6 +501,9 @@
 #define REG_DATA_SUBCHANNEL		0x0483
 /* 8723au */
 #define REG_INIDATA_RATE_SEL		0x0484
+/* MACID_SLEEP_1/3 for 8723b, 8192e, 8812a, 8821a */
+#define REG_MACID_SLEEP_3_8732B		0x0484
+#define REG_MACID_SLEEP_1_8732B		0x0488
 
 #define REG_POWER_STATUS		0x04a4
 #define REG_POWER_STAGE1		0x04b4
@@ -508,6 +518,13 @@
 #define REG_RTS_MAX_AGGR_NUM		0x04cb
 #define REG_BAR_MODE_CTRL		0x04cc
 #define REG_RA_TRY_RATE_AGG_LMT		0x04cf
+/* MACID_DROP for 8723a */
+#define REG_MACID_DROP_8732A		0x04d0
+/* EARLY_MODE_CONTROL 8188e */
+#define REG_EARLY_MODE_CONTROL_8188E	0x04d0
+/* MACID_SLEEP_2 for 8723b, 8192e, 8812a, 8821a */
+#define REG_MACID_SLEEP_2_8732B		0x04d0
+#define REG_MACID_SLEEP			0x04d4
 #define REG_NQOS_SEQ			0x04dc
 #define REG_QOS_SEQ			0x04de
 #define REG_NEED_CPU_HANDLE		0x04e0
-- 
2.5.5

