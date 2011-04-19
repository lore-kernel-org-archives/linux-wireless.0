Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35108 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1DSGJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:09:05 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/4] mwl8k: Add timestamp information for tx packets
Date: Tue, 19 Apr 2011 11:12:50 +0530
Message-Id: <1303191772-4299-2-git-send-email-nishants@marvell.com>
In-Reply-To: <1303191772-4299-1-git-send-email-nishants@marvell.com>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
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
 drivers/net/wireless/mwl8k.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7968301..aca0139 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1792,6 +1792,14 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 		tx_stats->pkts++;
 }
 
+/* HW micro second timer register
+ * located at offset 0xA600. This
+ * will be used to timestamp tx
+ * packets.
+ */
+
+#define	MWL8K_HW_TIMER_REGISTER	(priv->regs + 0xA600)
+
 static void
 mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 {
@@ -1972,6 +1980,10 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
 	else
 		tx->peer_id = 0;
+
+	if (priv->ap_fw)
+		tx->timestamp = cpu_to_le32(ioread32(MWL8K_HW_TIMER_REGISTER));
+
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-- 
1.6.0.3

