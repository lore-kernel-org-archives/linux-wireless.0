Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Bruno Randolf <br1@einfach.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 18/28] rtl8xxxu: Document REG_RXFLTMAP registers
Date: Wed,  3 Feb 2016 13:39:52 -0500
Message-Id: <1454524802-26763-19-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194129_116215_9977D81D)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bruno Randolf <br1@einfach.org>

Add comments describing how REG_RXFLTMAP0, REG_RXFLTMAP1 and REG_RXFLTMAP2
work.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  | 26 +++++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index d2995f8a3..d089edd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -569,9 +569,12 @@
 						 (Rx beacon, probe rsp) */
 #define  RCR_ACCEPT_CRC32		BIT(8)  /* Accept CRC32 error packet */
 #define  RCR_ACCEPT_ICV			BIT(9)  /* Accept ICV error packet */
-#define  RCR_ACCEPT_DATA_FRAME		BIT(11)
-#define  RCR_ACCEPT_CTRL_FRAME		BIT(12)
-#define  RCR_ACCEPT_MGMT_FRAME		BIT(13)
+#define  RCR_ACCEPT_DATA_FRAME		BIT(11) /* Accept all data pkt or use
+						   REG_RXFLTMAP2 */
+#define  RCR_ACCEPT_CTRL_FRAME		BIT(12) /* Accept all control pkt or use
+						   REG_RXFLTMAP1 */
+#define  RCR_ACCEPT_MGMT_FRAME		BIT(13) /* Accept all mgmt pkt or use
+						   REG_RXFLTMAP0 */
 #define  RCR_HTC_LOC_CTRL		BIT(14) /* MFC<--HTC=1 MFC-->HTC=0 */
 #define  RCR_UC_DATA_PKT_INT_ENABLE	BIT(16) /* Enable unicast data packet
 						   interrupt */
@@ -651,9 +654,20 @@
 #define REG_LPNAV_CTRL			0x0694
 #define REG_WKFMCAM_CMD			0x0698
 #define REG_WKFMCAM_RWD			0x069c
-#define REG_RXFLTMAP0			0x06a0
-#define REG_RXFLTMAP1			0x06a2
-#define REG_RXFLTMAP2			0x06a4
+
+/*
+ * RX Filters: each bit corresponds to the numerical value of the subtype.
+ * If it is set the subtype frame type is passed. The filter is only used when
+ * the RCR_ACCEPT_DATA_FRAME, RCR_ACCEPT_CTRL_FRAME, RCR_ACCEPT_MGMT_FRAME bit
+ * in the RCR are low.
+ *
+ * Example: Beacon subtype is binary 1000 which is decimal 8 so we have to set
+ * bit 8 (0x100) in REG_RXFLTMAP0 to enable reception.
+ */
+#define REG_RXFLTMAP0			0x06a0	/* Management frames */
+#define REG_RXFLTMAP1			0x06a2	/* Control frames */
+#define REG_RXFLTMAP2			0x06a4	/* Data frames */
+
 #define REG_BCN_PSR_RPT			0x06a8
 #define REG_CALB32K_CTRL		0x06ac
 #define REG_PKT_MON_CTRL		0x06b4
-- 
2.5.0

