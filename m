Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52591 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1DULbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:31:21 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, pnemavat@marvell.com,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH V3 2/4] mwl8k: Add timestamp information for tx packets
Date: Thu, 21 Apr 2011 16:34:57 +0530
Message-Id: <1303383899-3262-2-git-send-email-nishants@marvell.com>
In-Reply-To: <1303383899-3262-1-git-send-email-nishants@marvell.com>
References: <1303383899-3262-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pradeep Nemavat <pnemavat@marvell.com>

Timestamp tx packets using a HW micro-second timer.
This timestamp will be compared to the current timestamp
in the hardware and if the difference is greater than 500ms,
the packet will be dropped.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7968301..4adb050 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -74,6 +74,14 @@ MODULE_PARM_DESC(ap_mode_default,
 #define  MWL8K_A2H_INT_RX_READY			 (1 << 1)
 #define  MWL8K_A2H_INT_TX_DONE			 (1 << 0)
 
+/* HW micro second timer register
+ * located at offset 0xA600. This
+ * will be used to timestamp tx
+ * packets.
+ */
+
+#define	MWL8K_HW_TIMER_REGISTER			0x0000a600
+
 #define MWL8K_A2H_EVENTS	(MWL8K_A2H_INT_DUMMY | \
 				 MWL8K_A2H_INT_CHNL_SWITCHED | \
 				 MWL8K_A2H_INT_QUEUE_EMPTY | \
@@ -1972,6 +1980,11 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
 	else
 		tx->peer_id = 0;
+
+	if (priv->ap_fw)
+		tx->timestamp = cpu_to_le32(ioread32(priv->regs +
+						MWL8K_HW_TIMER_REGISTER));
+
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-- 
1.6.0.3

