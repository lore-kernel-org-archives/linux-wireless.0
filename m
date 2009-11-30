Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45408 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZK3Rbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:46 -0500
Date: Mon, 30 Nov 2009 18:31:52 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] mwl8k: get rid of the AMSDU check in the transmit path
Message-ID: <20091130173152.GS20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 43b2d64..9a60381 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -678,14 +678,6 @@ static inline u16 mwl8k_qos_setbit_ack(u16 qos, u8 ack_policy)
 	return (qos & qos_mask) | ((ack_policy & val_mask) << shift);
 }
 
-static inline u16 mwl8k_qos_setbit_amsdu(u16 qos)
-{
-	u16 val_mask = 1 << 7;
-
-	/* AMSDU present Bit 7 */
-	return qos | val_mask;
-}
-
 static inline u16 mwl8k_qos_setbit_qlen(u16 qos, u8 len)
 {
 	u16 val_mask = 0xff;
@@ -1475,9 +1467,6 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		else
 			qos = mwl8k_qos_setbit_ack(qos,
 				MWL8K_TXD_ACK_POLICY_NORMAL);
-
-		if (qos & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			qos = mwl8k_qos_setbit_amsdu(qos);
 	}
 
 	dma = pci_map_single(priv->pdev, skb->data,
-- 
1.5.6.4
