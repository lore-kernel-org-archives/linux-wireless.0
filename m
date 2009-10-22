Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49174 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbZJVShL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:11 -0400
Date: Thu, 22 Oct 2009 20:20:25 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/28] mwl8k: clarify WME transmit queue 0/1 swizzling
Message-ID: <20091022182025.GL1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 08ae219..8931be9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -83,12 +83,6 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 				 MWL8K_A2H_INT_RX_READY | \
 				 MWL8K_A2H_INT_TX_DONE)
 
-/* WME stream classes */
-#define WME_AC_BE	0		/* best effort */
-#define WME_AC_BK	1		/* background */
-#define WME_AC_VI	2		/* video */
-#define WME_AC_VO	3		/* voice */
-
 #define MWL8K_RX_QUEUES		1
 #define MWL8K_TX_QUEUES		4
 
@@ -967,24 +961,10 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
  * Packet transmission.
  */
 
-/* Transmit queue assignment.  */
-enum {
-	MWL8K_WME_AC_BK	= 0,		/* background access */
-	MWL8K_WME_AC_BE	= 1,		/* best effort access */
-	MWL8K_WME_AC_VI	= 2,		/* video access */
-	MWL8K_WME_AC_VO	= 3,		/* voice access */
-};
-
 /* Transmit packet ACK policy */
 #define MWL8K_TXD_ACK_POLICY_NORMAL		0
 #define MWL8K_TXD_ACK_POLICY_BLOCKACK		3
 
-#define GET_TXQ(_ac) (\
-		((_ac) == WME_AC_VO) ? MWL8K_WME_AC_VO : \
-		((_ac) == WME_AC_VI) ? MWL8K_WME_AC_VI : \
-		((_ac) == WME_AC_BK) ? MWL8K_WME_AC_BK : \
-		MWL8K_WME_AC_BE)
-
 #define MWL8K_TXD_STATUS_OK			0x00000001
 #define MWL8K_TXD_STATUS_OK_RETRY		0x00000002
 #define MWL8K_TXD_STATUS_OK_MORE_RETRY		0x00000004
@@ -2068,6 +2048,12 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 	if (cmd == NULL)
 		return -ENOMEM;
 
+	/*
+	 * Queues 0 (BE) and 1 (BK) are swapped in hardware for
+	 * this call.
+	 */
+	qnum ^= !(qnum >> 1);
+
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_EDCA_PARAMS);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_SET_EDCA_ALL);
-- 
1.5.6.4
