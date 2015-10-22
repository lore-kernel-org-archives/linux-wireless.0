Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:60077 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbbJVIWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 04:22:45 -0400
From: Bruno Randolf <br1@einfach.org>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] rtl8xxxu: Document REG_RXFLTMAP registers
Date: Thu, 22 Oct 2015 09:22:36 +0100
Message-Id: <1445502156-15247-1-git-send-email-br1@einfach.org> (sfid-20151022_102257_392349_4D0CFA29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add comments describing how REG_RXFLTMAP0, REG_RXFLTMAP1 and REG_RXFLTMAP2
work.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  | 26 +++++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 865bc31..38b13ae 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -559,9 +559,12 @@
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
@@ -641,9 +644,20 @@
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
1.9.1

