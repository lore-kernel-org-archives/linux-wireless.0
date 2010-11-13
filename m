Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55148 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0KMBYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:14 -0500
Received: by ywc21 with SMTP id 21so947866ywc.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:13 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH V2 1/7] mwl8k: revert unnecessary modification of tx descriptor
Date: Fri, 12 Nov 2010 17:23:47 -0800
Message-Id: <1289611433-5119-2-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts change 783391c443728febc669e40597193308460e7b4f.
The stabilized AP v1 firmware uses the same tx descriptor as
the STA firmware.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 1bbcd7c..f152a25 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1125,12 +1125,10 @@ struct mwl8k_tx_desc {
 	__le32 reserved;
 	__le16 rate_info;
 	__u8 peer_id;
-	__u8 xmitcontrol;
+	__u8 tx_frag_cnt;
 } __packed;
 
 #define MWL8K_TX_DESCS		128
-#define MWL8K_XMITCONTROL_NON_AMPDU	0x04
-
 
 static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 {
@@ -1450,9 +1448,6 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
 	else
 		tx->peer_id = 0;
-
-	if (priv->ap_fw)
-		tx->xmitcontrol = MWL8K_XMITCONTROL_NON_AMPDU;
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
 
-- 
1.7.1.1

