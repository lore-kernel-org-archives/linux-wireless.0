Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61114 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab0KBA40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:26 -0400
Received: by mail-pv0-f174.google.com with SMTP id 32so629365pvb.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 17:56:26 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 4/7] mwl8k: force AP mode to use non-AMPDU frames
Date: Mon,  1 Nov 2010 17:55:48 -0700
Message-Id: <1288659351-22313-4-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

AP firmware uses xmitcontrol to differentiate between AMPDU
and non-AMPDU frames. As the support for AMPDU is not yet
added, set xmitcontrol to non-AMPDU for all tx frames for AP
firmware. This field will be set to indicate ampdu/non-ampdu
frames when tx AMPDU support is added.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9d614b8..99cc48d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1141,10 +1141,12 @@ struct mwl8k_tx_desc {
 	__le32 reserved;
 	__le16 rate_info;
 	__u8 peer_id;
-	__u8 tx_frag_cnt;
+	__u8 xmitcontrol;
 } __packed;
 
 #define MWL8K_TX_DESCS		128
+#define MWL8K_XMITCONTROL_NON_AMPDU	0x04
+
 
 static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 {
@@ -1465,6 +1467,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
 	else
 		tx->peer_id = 0;
+
+	if (priv->ap_fw)
+		tx->xmitcontrol = MWL8K_XMITCONTROL_NON_AMPDU;
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-- 
1.7.1.1

